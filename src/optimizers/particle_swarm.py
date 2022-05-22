import numpy as np
import tensorflow as tf
import tensorflow_probability as tfp
import rpy2.robjects as ro
import trieste
import json
import timeit
from trieste.models.gpflow import build_gpr, GaussianProcessRegression
from trieste.space import Box
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
    bounds = list(zip(*bounds))
    self.model_evaluations = 0

    self.model.setup(params)
    def model_evaluation_error(x):
      y = self.rpy_function_wrapper(self.model.evaluate)(x, silence_model_output=silence_model_output)
      errors = []
      for y_i in y:
        measure = measure_extractor.get_measure(json.loads(y_i))
        errors += [error_measure.calculate_error(measure)]
      errors = tf.reshape(tf.convert_to_tensor(errors), shape=(len(errors),1))
      if print_errors:
        print('Errors: {}'.format(errors))
      self.model_evaluations = self.model_evaluations + 1
      return errors

    xopt, fopt = pso(model_evaluation_error, bounds[0], bounds[1], f_ieqcons=None, **kwargs)
    
    stop_time = timeit.default_timer()
    return {
      'x': xopt,
      'error': fopt,
      'evaluations': self.model_evaluations,
      'time': stop_time - start_time,
      'success': True,
    }
