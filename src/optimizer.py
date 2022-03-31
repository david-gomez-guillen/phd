import json
import rpy2.robjects as ro
import numpy as np
from scipy.optimize import minimize

class Optimizer:
  def __init__(self):
      pass

  def optimize(self, model, error_measure, **kwargs) -> list:
    pass

class ScipyOptimizer(Optimizer):  
  def rpy_function_wrapper(self, func):
    def wrapper(X):
      X2 = ro.vectors.FloatVector(X)
      result = func(X2)
      return result
    return wrapper

class NelderMeadOptimizer(ScipyOptimizer):
  def optimize(self, model, params, bounds, error_measure, **kwargs) -> list:
    initial_guess = kwargs['initial_guess']
    if kwargs.get('seed'):
      np.random.seed(kwargs['seed'])
    model.setup(params=params)
    def model_evaluation_error(x):
      y = self.rpy_function_wrapper(model.evaluate)(x)
      error = error_measure.calculate_error(json.loads(y))
      print('Error: {}'.format(error))
      return error
    result = minimize(model_evaluation_error, initial_guess, method='Nelder-Mead', bounds=bounds)
    return {
      'x': result['x'],
      'error': result['fun'],
      'evaluations': result['nfev'],
      'success': result['success'],
    }
