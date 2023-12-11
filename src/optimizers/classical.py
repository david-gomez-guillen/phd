import json
import timeit
import rpy2.robjects as ro
import numpy as np
import pandas as pd
from scipy.optimize import minimize
from .base import Optimizer

class ScipyOptimizer(Optimizer):  
  def rpy_function_wrapper(self, func):
    def wrapper(X, **kwargs):
      X2 = ro.vectors.FloatVector(X)
      result = func(X2, **kwargs)
      return result
    return wrapper

  def _optimize(self, algorithm, model, params, bounds, measure_extractor, error_measure, silence_model_output=True, print_errors=True, **kwargs) -> list:
    start_time = timeit.default_timer()
    initial_guess = kwargs['initial_guess']
    fixed_params = kwargs.get('fixed_params', [])
    errors = []
    if kwargs.get('seed'):
      np.random.seed(kwargs['seed'])
    model.setup(params=params, silence_model_output=silence_model_output, **kwargs)

    del kwargs['initial_guess']
    del kwargs['fixed_params']
    del kwargs['calibration_params']
    kwargs.pop('constraint_func', None)
    
    def model_evaluation_error(x):
      augmented_x = np.array(fixed_params + list(x)) # Parameters to be optimized preffixed by fixed parameters
      y = self.rpy_function_wrapper(model.evaluate)(augmented_x, silence_model_output=silence_model_output)
      measure = measure_extractor.get_measure(json.loads(y))
      error = error_measure.calculate_error(augmented_x, measure)
      errors.extend([error])
      # print('Error: {}'.format(error))
      return error
    result = minimize(model_evaluation_error, initial_guess, method=algorithm, bounds=bounds, **kwargs)

    stop_time = timeit.default_timer()

    return {
      'x': result['x'],
      'error': result['fun'],
      'evaluations': result['nfev'],
      'time': stop_time - start_time,
      'trace': pd.DataFrame({'error': errors}),
      'success': result['success'],
    }


class NelderMeadOptimizer(ScipyOptimizer):
  def optimize(self, model, params, bounds, measure_extractor, error_measure, silence_model_output=True, print_errors=True, **kwargs) -> list:
    return self._optimize('Nelder-Mead', model, params, bounds, measure_extractor, error_measure, silence_model_output, print_errors, **kwargs)
