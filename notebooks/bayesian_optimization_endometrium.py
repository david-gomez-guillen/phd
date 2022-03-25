#!/usr/bin/env python
# coding: utf-8

# # Optimization benchmark for cost-effectiveness models (endometrium model)
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
r.setwd(globals()['_dh'][0] + '/../models/endometrium')
r.source('calibration_wrapper.R')
make_simulation_func = ro.globalenv['calibration.simulation']

# Strata of the input parameters
strata = ['y{}_{}'.format(i, i+4) for i in range(50, 85, 5)]
# Input parameter names 
param_names =['.p_cancer___bleeding'] * len(strata)
# Expected value of the output (incidence per age group)
expected_output = [0.048220892, 0.081144281, 0.105328782,
     0.117587650, 0.119602721, 0.119602721, 0.119602721]

simulate_func = make_simulation_func(
    param_names,
    strata,
    ro.vectors.FloatArray(expected_output)
 )

initial_guess = [0.048220892, 0.081144281, 0.105328782,
     0.117587650, 0.119602721, 0.119602721, 0.119602721]

functions = [
    {
        'function': simulate_func,
        'initial_guesses': initial_guess,
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
# - Model used: Gaussian process
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

def bo_optimization(f, model, n_samples, optim_iters, prior_width, experiment_num):
    example_scenario = {
        "application_name": "bo_endometrium_{}".format(experiment_num),
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
    df = pd.read_csv('bo_endometrium_{}_output_samples.csv'.format(experiment_num))
    best_found = df.sort_values('Value').iloc[1,:]

    x = list(best_found[0:len(f['bounds'])])
    print(df)

    print('Test {} done.'.format(experiment_num))
    
    return {
            'function': 'endometrium_model',
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
    [50],                 # Optimization iterations
    [-1]                  # Use prior?
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
df.to_csv('bo_endometrium_optimization_comparison.csv')


# ## Comparison of BO parameters

# In[ ]:


get_ipython().run_line_magic('matplotlib', 'inline')
df = pd.read_csv('bo_endometrium_optimization_comparison.csv')
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




