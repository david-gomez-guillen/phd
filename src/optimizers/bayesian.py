import numpy as np
import tensorflow as tf
import tensorflow_probability as tfp
import trieste
import gpflow
from trieste.models.gpflow import build_gpr, GaussianProcessRegression
from trieste.space import Box
from .base import Optimizer

class BayesianOptimizer(Optimizer):
  def __init__(self):    
    class Sim:
        threshold = 0.5

        @staticmethod
        def objective(input_data):
            x, y = input_data[..., -2], input_data[..., -1]
            z = model.evaluate(input_data)
            return z[:, None]

        @staticmethod
        def constraint(input_data):
            x, y = input_data[:, -2], input_data[:, -1]
            z = np.ones(x)
            return z[:, None]

  def optimize(self, model, params, bounds, error_measure, silence_model_output=True, **kwargs) -> list:
    self.model = model
    search_space = Box(bounds)

    def build_model(data):
        variance = tf.math.reduce_variance(data.observations)
        kernel = gpflow.kernels.Matern52(variance=variance, lengthscales=[0.2, 0.2])
        prior_scale = tf.cast(1.0, dtype=tf.float64)
        kernel.variance.prior = tfp.distributions.LogNormal(
            tf.cast(-2.0, dtype=tf.float64), prior_scale
        )
        kernel.lengthscales.prior = tfp.distributions.LogNormal(
            tf.math.log(kernel.lengthscales), prior_scale
        )
        gpr = gpflow.models.GPR(data.astuple(), kernel, noise_variance=1e-5)
        gpflow.set_trainable(gpr.likelihood, False)

        return GaussianProcessRegression(gpr, num_kernel_samples=100)


    model = build_model(initial_data)











    def observer(query_points):
        return {
            "OBJECTIVE": Dataset(query_points, Sim.objective(query_points)),
            "CONSTRAINT": Dataset(query_points, Sim.constraint(query_points)),
        }
    bo = trieste.bayesian_optimizer.BayesianOptimizer(observer, search_space)