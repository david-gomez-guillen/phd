import json
import rpy2.robjects as ro
import numpy as np
from scipy.optimize import minimize
from .base import Optimizer

class ScipyOptimizer(Optimizer):  
  def rpy_function_wrapper(self, func):
    def wrapper(X, **kwargs):
      X2 = ro.vectors.FloatVector(X)
      result = func(X2, kwargs)
      return result
    return wrapper

  def _optimize(self, algorithm, model, params, bounds, error_measure, silence_model_output=True, **kwargs) -> list:
    initial_guess = kwargs['initial_guess']
    if kwargs.get('seed'):
      np.random.seed(kwargs['seed'])
    model.setup(params=params, silence_model_output=silence_model_output)
    def model_evaluation_error(x):
      y = self.rpy_function_wrapper(model.evaluate)(x, silence_model_output=silence_model_output)
      error = error_measure.calculate_error(json.loads(y))
      print('Error: {}'.format(error))
      return error
    result = minimize(model_evaluation_error, initial_guess, method=algorithm, bounds=bounds)
    return {
      'x': result['x'],
      'error': result['fun'],
      'evaluations': result['nfev'],
      'success': result['success'],
    }


class NelderMeadOptimizer(ScipyOptimizer):
  def optimize(self, model, params, bounds, error_measure, silence_model_output=True, **kwargs) -> list:
    return self._optimize('Nelder-Mead', model, params, bounds, error_measure, silence_model_output, **kwargs)
