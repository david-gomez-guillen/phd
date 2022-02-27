#!/usr/bin/env python
# coding: utf-8

# # Optimization benchmark for non-convex sample functions
# 
# Functions evaluated:
# 
# - [Branin](https://www.sfu.ca/~ssurjano/branin.html)
# - [Rosenbrock](https://en.wikipedia.org/wiki/Rosenbrock_function)
# - [Rastrigin](https://en.wikipedia.org/wiki/Rastrigin_function)

# In[1]:


import time
import json
import math
import itertools
import numpy as np
import pandas as pd
from math import pi, cos, sqrt
from timeit import default_timer as timer

evaluation_delay = 0

# Optima in [-5, 10] x [0, 15]
branin_minima = [(-pi, 12.275), (pi, 2.275), (9.42478, 2.475)]
def branin(x):
    a=1
    b=5.1/(4*pi**2)
    c=5/pi
    r=6
    s=10
    t=1/(8*pi)
    return a*(x[1]-b*x[0]**2+c*x[0]-r)**2 + s*(1-t)*cos(x[0])+s  

ROSENBROCK_N = 10
rosenbrock_minima = [(1,) * ROSENBROCK_N]
def rosenbrock(x):
    return sum(100.0*(np.array(x[1:])-np.array(x[:-1])**2.0)**2.0 + (1-np.array(x[:-1]))**2.0)

RASTRIGIN_N = 10
# Optima in [-5.12, 5.12] x [-5.12, 5.12]
rastrigin_minima = [(0,) * RASTRIGIN_N]
def rastrigin(x):
    A = 10
    n = len(x)
    return A * n + sum([x_i**2 - A*math.cos(2*math.pi*x_i) for x_i in x])

def opt_error(x, minima):
    def l2_norm(x,y):
        return np.linalg.norm(np.array(x) - np.array(y))
    distances = [l2_norm(x,m) for m in minima]
    return min(distances)

functions = [
    {
        'function': branin,
        'initial_guesses': [np.zeros(2), 
                            np.ones(2),
                            np.random.rand(2)],
        'minima': branin_minima,
        'bounds': [(-5,10), (0,15)],
    }, 
    {
        'function': rosenbrock,
        'initial_guesses': [np.zeros(ROSENBROCK_N), 
                            np.random.rand(ROSENBROCK_N)*10-5],
        'minima': rosenbrock_minima,
        'bounds': [(-10,10)] * ROSENBROCK_N,
    }, 
    {
        'function': rastrigin,
        'initial_guesses': [np.ones(RASTRIGIN_N), 
                            np.random.rand(ROSENBROCK_N)*10-5],
        'minima': rastrigin_minima,
        'bounds': [(-5.12,5.12)] * RASTRIGIN_N,
    },
]


# ## Classical optimization
# 
# Optimization methods used (with different initial guesses tested):
# 
# - Nelder-Mead
# - BFGS
# - L-BFGS-B

# In[2]:


from scipy.optimize import minimize
from IPython.display import display, HTML

methods = ['Nelder-Mead', 'BFGS', 'L-BFGS-B']


params_set = itertools.product(functions,            # Objective functions
                               methods)              # Optimization methods

results_df = pd.DataFrame()
for f, method in params_set:
    for initial_guess in f['initial_guesses']:
        function = f['function']
        start = timer()
        result = minimize(function, initial_guess, method=method)
        elapsed_time = timer() - start
        x = result['x']
        fun = result['fun']
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
# - Number of samples: 1, 10, 20
# - Optimization iterations: 10, 20, 50, 100
# - (Flat) prior for the optimum: No prior, very specific prior, less specific prior

# In[3]:


import math
import sys
import os
from functools import reduce
from contextlib import redirect_stdout
from hypermapper import optimizer
from concurrent.futures import ProcessPoolExecutor

N_CORES = 1
N_PRIOR_BINS = 10
DEBUG = False

def function_wrapper(func):
    def wrapper(X):
        X2 = [X['x{}'.format(i+1)] for i in range(len(X))]
        return func(np.array(X2))
    return wrapper

def bo_optimization(f, model, n_samples, optim_iters, prior_width, experiment_num):
    example_scenario = {
        "application_name": "bo_tests_{}".format(experiment_num),
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
            a, b = f['bounds'][i]
            bounds_range = b - a
            m = f['minima'][0][i] # ith component of first minimum
            prior_bin = math.floor((m-a)/(b-a)*N_PRIOR_BINS)
            # Flat prior with "zero" probabilities equal to ALMOST_ZERO to avoid
            # numerical issues when taking logarithms
            ALMOST_ZERO = 1e-10
            prior = np.array([1 if abs(i-prior_bin) <= prior_width else ALMOST_ZERO for i in range(N_PRIOR_BINS)])
            prior = prior / sum(prior)
            example_scenario['input_parameters']['x{}'.format(i+1)]['prior'] = prior.tolist()

    scenario_file_path = "bo_optimization_scenario_{}.json".format(experiment_num)
    with open(scenario_file_path, "w") as scenario_file:
        json.dump(example_scenario, scenario_file, indent=4)

    stdout = sys.stdout # Jupyter uses a special stdout and HyperMapper logging overwrites it. Save stdout to restore later
    start = timer()
    with open(os.devnull, 'w') as devnull:
        if DEBUG:
            optimizer.optimize(scenario_file_path, function_wrapper(f['function']))
        else:
            with redirect_stdout(devnull):
                optimizer.optimize(scenario_file_path, function_wrapper(f['function']))
    elapsed_time = timer() - start
    sys.stdout = stdout

    df = pd.read_csv('bo_tests_{}_output_samples.csv'.format(experiment_num))
    best_found = df.sort_values('Value').iloc[1,:]

    x = list(best_found[0:len(f['bounds'])])
    error = opt_error(x, f['minima'])

    print('Test {} done.'.format(experiment_num))
    
    return {
            'function': f['function'].__name__,
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
    [1, 50, 500],          # Number of samples
    [10, 25, 50],        # Optimization iterations
    [-1, 1]            # Use prior?
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


# In[4]:


df = results_df.append(bo_results_df)
df.to_csv('bo_optimization_comparison.csv')


# ## Comparison of BO parameters

# In[9]:


get_ipython().run_line_magic('matplotlib', 'inline')
df = pd.read_csv('bo_optimization_comparison.csv')
bo_df = df[df.method.eq('BO')]

bo_df.boxplot('time', by='prior_width')
bo_df.boxplot('error', by='prior_width')
bo_df.boxplot('error', by='n_samples')
bo_df.boxplot('error', by='evaluations')


# ## Comparison of branin function

# In[6]:


df_branin = df[df.function.eq('branin')]
df_branin.boxplot('time', by='method')
df_branin.boxplot('evaluations', by='method')
df_branin.boxplot('error', by='method')
df_branin.boxplot('error', by='n_samples')
df_branin[df_branin.method.eq('BO')].boxplot('error', by='evaluations')


# ## Comparison of rosenbrock function

# In[7]:


df_rosenbrock = df[df.function.eq('rosenbrock')]
df_rosenbrock.boxplot('time', by='method')
df_rosenbrock.boxplot('evaluations', by='method')
df_rosenbrock.boxplot('error', by='method')
df_rosenbrock.boxplot('error', by='n_samples')
df_rosenbrock[df_rosenbrock.method.eq('BO')].boxplot('error', by='evaluations')


# ## Comparison of rastrigin function

# In[8]:


df_rastrigin = df[df.function.eq('rastrigin')]
df_rastrigin.boxplot('time', by='method')
df_rastrigin.boxplot('evaluations', by='method')
df_rastrigin.boxplot('error', by='method')
df_rastrigin.boxplot('error', by='n_samples')
df_rastrigin[df_rastrigin.method.eq('BO')].boxplot('error', by='evaluations')


# In[ ]:




