import rpy2.robjects as ro
import numpy as np
import pandas as pd
import json
import timeit
from .base import Optimizer

class BayesianOptimizer(Optimizer):

  DEFAULT_INITIAL_POINTS = 5
  DEFAULT_NUM_EVALUATIONS = 20
  TF_SEED = 1

  def __init__(self,
               initial_points=DEFAULT_INITIAL_POINTS,
               n_evaluations=DEFAULT_NUM_EVALUATIONS):
    self.initial_points = initial_points
    self.n_evaluations = n_evaluations
    self.constraint_func = None

  def rpy_function_wrapper(self, func):
    def wrapper(X, **kwargs):
      results = []
      for i in range(X.shape[0]):
        X2 = ro.vectors.FloatVector(X[i])
        results += [func(X2, **kwargs)]
      return results
    return wrapper

  def optimize(self, model, params, bounds, measure_extractor, error_measure, silence_model_output=True, print_errors=True, **kwargs) -> list:
    import tensorflow as tf  # Lazy import
    import trieste
    import gpflow
    from trieste.models.gpflow import build_gpr, GaussianProcessRegression
    from trieste.space import Box
    from trieste.data import Dataset
    from trieste.acquisition.rule import EfficientGlobalOptimization

    tf.random.set_seed(self.TF_SEED)
    fixed_params = kwargs.get('fixed_params', [])

    start_time = timeit.default_timer()
    self.model = model
    bounds = list(zip(*bounds))
    search_space = Box(*bounds)
    trace_errors = []
    trace_times = []
    n_iteration = 0

    self.model.setup(params, silence_model_output=silence_model_output, **kwargs)
    self.constraint_func = kwargs.get('constraint_func')
    error_measure.constraint_func = None

    del kwargs['initial_guess']
    del kwargs['fixed_params']
    del kwargs['calibration_params']
    kwargs.pop('constraint_func', None)

    def model_evaluation_error(x):
      nonlocal last_time, trace_errors, trace_times, n_iteration
      augmented_x = np.array([fixed_params + list(e) for e in x.numpy()]) # Parameters to be optimized preffixed by fixed parameters
      errors = []
      y = self.rpy_function_wrapper(self.model.evaluate)(augmented_x, silence_model_output=silence_model_output)
      for x_i, y_i in zip(augmented_x, y):
        measure = measure_extractor.get_measure(json.loads(y_i))
        errors += [error_measure.calculate_error(x_i, measure)]
      errors = tf.reshape(tf.convert_to_tensor(errors), shape=(len(errors),1))
      now = timeit.default_timer()
      trace_time = now - last_time
      trace_errors.extend(errors.numpy().T.tolist())
      trace_times.extend([trace_time] * len(y))
      last_time = now
      # print('Iteration {}:\n Errors: {}\n Time: {}\n'.format(n_iteration, errors, trace_time))
      n_iteration += 1
      return errors

    last_time = timeit.default_timer()
    if self.constraint_func:
      def observer(query_points):
        errors = model_evaluation_error(query_points)

        augmented_x = np.array([fixed_params + list(e) for e in query_points.numpy()]) # Parameters to be optimized preffixed by fixed parameters
        constraint_values = [self.constraint_func(x_i) for x_i in augmented_x]
        constraint_values = tf.reshape(tf.convert_to_tensor(constraint_values, dtype=np.float64), shape=(len(constraint_values),1))

        return {
          'OBJECTIVE': Dataset(query_points, errors),
          'CONSTRAINT': Dataset(query_points, constraint_values)
        }      
      pof = trieste.acquisition.ProbabilityOfFeasibility(threshold=0.0)
      eci = trieste.acquisition.ExpectedConstrainedImprovement('OBJECTIVE', pof.using('CONSTRAINT'))
      acquisition_rule = EfficientGlobalOptimization(eci)
    else:
      # observer = trieste.objectives.utils.mk_observer(model_evaluation_error)
      def observer(query_points):
        errors = model_evaluation_error(query_points)

        return {
          'OBJECTIVE': Dataset(query_points, errors)
        }      
      acquisition_rule = EfficientGlobalOptimization(trieste.acquisition.ExpectedImprovement())

    initial_query_points = search_space.sample_sobol(self.initial_points)
    initial_data = observer(initial_query_points)

    # optimizer = trieste.models.optimizer.Optimizer(
    #   optimizer=gpflow.optimizers.Scipy(),
    #   minimize_args=dict(method='Nelder-Mead')
    # )

    def create_bo_model(data, *args, **kwargs):
      gpr = build_gpr(data, search_space, likelihood_variance=1e-7)
      return GaussianProcessRegression(gpr)
    
    initial_models = trieste.utils.map_values(create_bo_model, initial_data)
    # gpflow_model = build_gpr(initial_data, search_space, likelihood_variance=1e-7)
    # surrogate_model = GaussianProcessRegression(gpflow_model, 
    #                                             optimizer=optimizer,
    #                                             num_kernel_samples=100)

    bo = trieste.bayesian_optimizer.BayesianOptimizer(observer, search_space)

    # Reinitialize error tracking, excluding model initialization sampling
    trace_errors = []
    trace_times = []
    last_time = timeit.default_timer()

    result = bo.optimize(self.n_evaluations, initial_data, initial_models, acquisition_rule)
    
    if self.constraint_func:
      dataset = result.try_get_final_datasets()['OBJECTIVE']
    else:
      dataset = result.try_get_final_dataset()

    errors = dataset.observations.numpy().T.tolist()[0]
    min_error = min(errors)
    min_index = errors.index(min_error)
    min_x = dataset.query_points.numpy().tolist()[min_index]
    
    stop_time = timeit.default_timer()
    return {
      'x': np.array(min_x),
      'error': min_error,
      'evaluations': len(dataset.observations),
      'time': stop_time - start_time,
      'trace': pd.DataFrame({'error': trace_errors, 'time': trace_times}),
      'success': True,
    }
