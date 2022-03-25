#!/usr/bin/env python
# coding: utf-8

# # Optimization benchmark for cost-effectiveness models (lung model)
# 
# Models evaluated:

# In[ ]:


import time
import json
import math
import os
import itertools
import numpy as np
import pandas as pd
from math import pi, cos, sqrt
from timeit import default_timer as timer
import rpy2.robjects as ro
from rpy2.robjects import pandas2ri

r = ro.r
r.setwd(globals()['_dh'][0] + '/../models/lung/3_ModelAECC_Gerard/ModelLC/Git_LC')
r.source('calibration_wrapper.R')
simulate_func = ro.globalenv['distance.function']

initial_guess = [
    1.213941e-06, 6.545872e-01, 2.246275e-01, 5.963744e-01, 2.394308e-02, 3.106926e-02, 2.794314e-02, 1.087255e-05, 6.844754e-01, 
    1.051884e-01, 7.424919e-01, 1.887970e-02, 2.471663e-02, 2.791269e-02, 3.205524e-05, 2.313676e-01, 3.555522e-02, 8.856038e-01, 
    1.132692e-02, 2.438057e-02, 1.744913e-02, 3.294341e-05, 3.026535e-01, 1.621603e-01, 6.240864e-01, 6.033806e-03, 3.053075e-02, 
    2.260926e-02, 4.296202e-05, 4.960837e-01, 1.606893e-01, 9.363777e-01, 1.769338e-02, 1.353436e-03, 2.057389e-02, 4.512876e-05, 
    1.024800e-01, 6.893908e-02, 1.601334e-01, 1.034956e-02, 1.300131e-02, 2.715497e-02, 3.758481e-05, 1.354800e-01, 1.826121e-02, 
    6.013894e-01, 2.711442e-02, 3.465066e-03, 2.510431e-02, 5.687846e-05, 3.202555e-02, 8.399107e-02, 8.905349e-01, 1.125023e-03, 
    3.516895e-02, 3.145581e-02, 3.695752e-05, 9.087717e-01, 5.573168e-03, 7.610368e-01, 4.831828e-02, 1.839338e-02, 4.312801e-02
]

functions = [
    {
        'function': simulate_func,
        'initial_guesses': [initial_guess],
        'bounds': [(p*.8, min(p*1.2, 1)) for p in initial_guess],
    }, 
]


# ## Classical optimization
# 
# Optimization methods used (with different initial guesses tested):
# 
# - Nelder-Mead
# - BFGS
# - L-BFGS-B
# 
# Currently disabled due to excessive computation time

# In[ ]:


from scipy.optimize import minimize
from IPython.display import display, HTML

methods = ['Nelder-Mead', 'BFGS', 'L-BFGS-B']


params_set = itertools.product(functions,            # Objective functions
                               methods)              # Optimization methods

def classical_function_wrapper(func):
    def wrapper(X):
        X2 = ro.vectors.FloatVector(X)
        result = func(X2)
        print(result.rx2(1)[0])
        return result.rx2(1)[0]
    return wrapper

results_df = pd.DataFrame()
for f, method in params_set:
    for initial_guess in f['initial_guesses']:
        function = f['function']
        start = timer()
        result = minimize(classical_function_wrapper(function), initial_guess, method=method)
        elapsed_time = timer() - start
        x = result['x']
        fun = result['fun']
        print(result)
        error = opt_error(x, f['minima'])
        success = result['success']
        nfev = result['nfev']
        nit = result['nit']
        results_df = results_df.append(
            {
                'function': function.__name__,
                'method': method,
                'initial_guess': initial_guess,
                'time': elapsed_time,
                'solution': x,
                'error': error,
                'n_samples': None,
                'iterations': nit,
                'evaluations': nfev,
                'prior_width': None,
                'success': success,
            }, ignore_index=True
        )

results_df


# ## Bayesian optimization
# 
# - Surrogate model used: Gaussian process
# - Prior for the optimum: Gaussian

# In[ ]:


import math
import sys
import os
from functools import reduce
from contextlib import redirect_stdout
from hypermapper import optimizer
from concurrent.futures import ProcessPoolExecutor

N_CORES = 1
N_PRIOR_BINS = 10
DEBUG = True

def bo_function_wrapper(func):
    def wrapper(X):
        X2 = [X['x{}'.format(i+1)] for i in range(len(X))]
        X2 = ro.vectors.FloatVector(X2)
        result = func(X2)
        print(result.rx2(1)[0])
        return result.rx2(1)[0]
    return wrapper

'''def classical_function_wrapper(func):
    def wrapper(X):
        X2 = ro.vectors.FloatVector(X)
        result = func(X2)
        print(result.rx2(1)[0])
        return result.rx2(1)[0]
    return wrapper'''
            
def bo_optimization(f, model, n_samples, optim_iters, prior_width, experiment_num):
    example_scenario = {
        "application_name": "bo_lung_{}".format(experiment_num),
        "design_of_experiment": {
            "doe_type": "random sampling",
            "number_of_samples": n_samples
        },
        "optimization_objectives": ["Value"],
        "optimization_iterations": optim_iters,
        "models": {
            "model": model
        },
        "input_parameters" : {
        },
        #"print_posterior_best": True,
        #"print_best": True,
    }
    
    for i, bounds in enumerate(f['bounds']):            
        example_scenario['input_parameters']['x{}'.format(i+1)] = {
            'parameter_type': 'real',
            'values': bounds,
        }
        if prior_width != -1:
            example_scenario['input_parameters']['x{}'.format(i+1)]['prior'] = 'gaussian'
            
    scenario_file_path = "bo_optimization_scenario_{}.json".format(experiment_num)
    with open(scenario_file_path, "w") as scenario_file:
        json.dump(example_scenario, scenario_file, indent=4)

    stdout = sys.stdout # Jupyter uses a special stdout and HyperMapper logging overwrites it. Save stdout to restore later
    start = timer()
    with open(os.devnull, 'w') as devnull:
        if DEBUG:
            optimizer.optimize(scenario_file_path, bo_function_wrapper(f['function']))
        else:
            with redirect_stdout(devnull):
                optimizer.optimize(scenario_file_path, bo_function_wrapper(f['function']))
    elapsed_time = timer() - start
    sys.stdout = stdout
    df = pd.read_csv('bo_lung_{}_output_samples.csv'.format(experiment_num))
    best_found = df.sort_values('Value').iloc[1,:]

    x = list(best_found[0:len(f['bounds'])])
    print(df)

    print('Test {} done.'.format(experiment_num))
    
    return {
            'function': 'lung_model',
            'method': 'BO',
            'initial_guess': None,
            'time': elapsed_time,
            'solution': x,
            'error': error,
            'n_samples': n_samples,
            'iterations': None,
            'evaluations': optim_iters,
            'prior_width': prior_width,
            'success': 1,
    }
       
pars = [
    functions,            # Objective functions
    ['gaussian_process'], # Model
    [50],                  # Number of samples
    [30],                 # Optimization iterations
    [1]                  # Use prior?
]
params_set = itertools.product(*pars)           # Use prior?
num_combinations = reduce(lambda x,y:x*y, [len(p) for p in pars])

print('{} tests to perform...'.format(num_combinations))
with ProcessPoolExecutor(N_CORES) as executor:
    futures = []
    for i, (f, model, n_samples, optim_iters, prior_width) in enumerate(params_set):
        futures.append(executor.submit(bo_optimization, f, model, n_samples, optim_iters, prior_width, i))
        
    start = timer()
    results = [f.result() for f in futures]
    print('Total experiment time: {0:.2f} min'.format((timer() - start)/60))
    bo_results_df = pd.DataFrame(results)       
        
bo_results_df


# In[ ]:


df = results_df.append(bo_results_df)
df.to_csv('bo_lung_optimization_comparison.csv')


# ## Comparison of BO parameters

# In[ ]:


get_ipython().run_line_magic('matplotlib', 'inline')
df = pd.read_csv('bo_lung_optimization_comparison.csv')
bo_df = df[df.method.eq('BO')]

bo_df.boxplot('time', by='prior_width')
bo_df.boxplot('error', by='prior_width')
bo_df.boxplot('error', by='n_samples')
bo_df.boxplot('error', by='evaluations')


# ## Comparison of branin function

# In[ ]:


df_branin = df[df.function.eq('branin')]
df_branin.boxplot('time', by='method')
df_branin.boxplot('evaluations', by='method')
df_branin.boxplot('error', by='method')
df_branin.boxplot('error', by='n_samples')
df_branin[df_branin.method.eq('BO')].boxplot('error', by='evaluations')


# ## Comparison of rosenbrock function

# In[ ]:


df_rosenbrock = df[df.function.eq('rosenbrock')]
df_rosenbrock.boxplot('time', by='method')
df_rosenbrock.boxplot('evaluations', by='method')
df_rosenbrock.boxplot('error', by='method')
df_rosenbrock.boxplot('error', by='n_samples')
df_rosenbrock[df_rosenbrock.method.eq('BO')].boxplot('error', by='evaluations')


# ## Comparison of rastrigin function

# In[ ]:


df_rastrigin = df[df.function.eq('rastrigin')]
df_rastrigin.boxplot('time', by='method')
df_rastrigin.boxplot('evaluations', by='method')
df_rastrigin.boxplot('error', by='method')
df_rastrigin.boxplot('error', by='n_samples')
df_rastrigin[df_rastrigin.method.eq('BO')].boxplot('error', by='evaluations')


# In[ ]:




