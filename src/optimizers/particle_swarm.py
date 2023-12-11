import rpy2.robjects as ro
import pandas as pd
import numpy as np
import json
import timeit
from pyswarm import pso
from .base import Optimizer

class ParticleSwarmOptimizer(Optimizer):
  def rpy_function_wrapper(self, func):
    def wrapper(X, **kwargs):
      X2 = ro.vectors.FloatVector(X)
      results = [func(X2, **kwargs)]
      return results
    return wrapper

  def optimize(self, model, params, bounds, measure_extractor, error_measure, silence_model_output=True, print_errors=False, **kwargs) -> list:
    start_time = timeit.default_timer()
    self.model = model
    fixed_params = kwargs.get('fixed_params', [])
    bounds = list(zip(*bounds))
    trace_errors = []
    self.model_evaluations = 0
    maxiter = kwargs.get('maxiter', 100)
    swarmsize = kwargs.get('swarmsize', 100)

    model.setup(params, silence_model_output=silence_model_output, **kwargs)
    
    del kwargs['initial_guess']
    del kwargs['fixed_params']
    del kwargs['calibration_params']
    kwargs.pop('constraint_func', None)
    # def model_evaluation_error(x):
    #   y = self.rpy_function_wrapper(self.model.evaluate)(x, silence_model_output=silence_model_output)
    #   errors = []
    #   for y_i in y:
    #     measure = measure_extractor.get_measure(json.loads(y_i))
    #     errors += [error_measure.calculate_error(measure)]
    #   errors = tf.reshape(tf.convert_to_tensor(errors), shape=(len(errors),1))
    #   if print_errors:
    #     print('Errors: {}'.format(errors))
    #   self.model_evaluations = self.model_evaluations + 1
    #   return errors

    def model_evaluation_error(x):
      augmented_x = np.array(fixed_params + list(x)) # Parameters to be optimized preffixed by fixed parameters
      y = self.rpy_function_wrapper(model.evaluate)(augmented_x, silence_model_output=silence_model_output)
      errors = []
      for y_i in y:
        measure = measure_extractor.get_measure(json.loads(y_i))
        # errors += [error_measure.calculate_error(measure)]
        error = error_measure.calculate_error(augmented_x, measure)
        errors.extend([error])
      self.model_evaluations = self.model_evaluations + 1
      trace_errors.extend(errors)
      # print('Error: {}'.format(error))
      return error

    xopt, fopt = pso(model_evaluation_error, bounds[0], bounds[1], f_ieqcons=None, maxiter=maxiter, swarmsize=swarmsize)
    
    stop_time = timeit.default_timer()
    return {
      'x': xopt,
      'error': fopt,
      'evaluations': self.model_evaluations,
      'time': stop_time - start_time,
      'trace': pd.DataFrame({'error': trace_errors}),
      'success': True,
    }
