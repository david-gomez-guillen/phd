import numpy as np
import tensorflow as tf
import tensorflow_probability as tfp
import rpy2.robjects as ro
import trieste
import gpflow
import json
import timeit
from trieste.models.gpflow import build_gpr, GaussianProcessRegression
from trieste.space import Box
from .base import Optimizer

class BayesianOptimizer(Optimizer):
  def rpy_function_wrapper(self, func):
    def wrapper(X, **kwargs):
      results = []
      for i in range(X.shape[0]):
        X2 = ro.vectors.FloatVector(X[i])
        results += [func(X2, **kwargs)]
      return results
    return wrapper

  def optimize(self, model, params, bounds, error_measure, silence_model_output=True, **kwargs) -> list:
    start_time = timeit.default_timer()
    self.model = model
    bounds = list(zip(*bounds))
    search_space = Box(*bounds)

    self.model.setup(params)
    def model_evaluation_error(x):
      y = self.rpy_function_wrapper(self.model.evaluate)(x, silence_model_output=silence_model_output)
      errors = []
      for y_i in y:
        errors += [error_measure.calculate_error(json.loads(y_i))]
      errors = tf.reshape(tf.convert_to_tensor(errors), shape=(len(errors),1))
      print('Errors: {}'.format(errors))
      return errors

    observer = trieste.objectives.utils.mk_observer(model_evaluation_error)

    num_initial_points = 3
    initial_query_points = search_space.sample_sobol(num_initial_points)
    initial_data = observer(initial_query_points)

    gpflow_model = build_gpr(initial_data, search_space, likelihood_variance=1e-7)
    surrogate_model = GaussianProcessRegression(gpflow_model, num_kernel_samples=100)

    bo = trieste.bayesian_optimizer.BayesianOptimizer(observer, search_space)

    num_steps = 3
    result = bo.optimize(num_steps, initial_data, surrogate_model)
    dataset = result.try_get_final_dataset()

    errors = dataset.observations.numpy().T.tolist()[0]
    min_error = min(errors)
    min_index = errors.index(min_error)
    min_x = dataset.query_points.numpy().tolist()[min_index]
    
    stop_time = timeit.default_timer()
    return {
      'x': min_x,
      'error': min_error,
      'evaluations': len(dataset.observations),
      'time': stop_time - start_time,
      'success': True,
    }
