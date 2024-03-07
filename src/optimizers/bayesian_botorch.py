import rpy2.robjects as ro
import numpy as np
import pandas as pd
import json
import timeit
from typing import Optional
from .base import Optimizer

class BayesianOptimizer(Optimizer):

  DEFAULT_INITIAL_POINTS = 5
  DEFAULT_NUM_EVALUATIONS = 20
  SEED = 1

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
    import torch
    import time
    import botorch
    from botorch.models import FixedNoiseGP, ModelListGP
    from gpytorch.mlls.sum_marginal_log_likelihood import SumMarginalLogLikelihood
    from botorch.acquisition.objective import ConstrainedMCObjective
    from botorch.optim import optimize_acqf
    from botorch import fit_gpytorch_mll
    from botorch.acquisition.monte_carlo import (
        qExpectedImprovement,
        qNoisyExpectedImprovement,
    )
    from botorch.exceptions import BadInitialCandidatesWarning
    from botorch.sampling.normal import SobolQMCNormalSampler

    botorch.manual_seed(self.SEED)
    device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")
    dtype = torch.double
    fixed_params = kwargs.get('fixed_params', [])

    start_time = timeit.default_timer()
    self.model = model

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
      nonlocal trace_errors, trace_times, n_iteration
      augmented_x = np.array([fixed_params + list(e) for e in x.numpy()]) # Parameters to be optimized preffixed by fixed parameters
      errors = []
      y = self.rpy_function_wrapper(self.model.evaluate)(augmented_x, silence_model_output=silence_model_output)
      for x_i, y_i in zip(augmented_x, y):
        measure = measure_extractor.get_measure(json.loads(y_i))
        errors += [error_measure.calculate_error(x_i, measure)]
      errors = torch.reshape(errors, shape=(len(errors),1))
      now = timeit.default_timer()
      trace_time = now - last_time
      trace_errors.extend(errors.numpy().T.tolist())
      trace_times.extend([trace_time] * len(y))
      last_time = now
      # print('Iteration {}:\n Errors: {}\n Time: {}\n'.format(n_iteration, errors, trace_time))
      n_iteration += 1
      return errors

    def outcome_constraint(X):
      """L1 constraint; feasible if less than or equal to zero."""
      return self.constraint_func(X) if self.constraint_func else -1

    def weighted_obj(X):
      """Feasibility weighted objective; zero if not feasible."""
      return model_evaluation_error(X) * (outcome_constraint(X) <= 0).type_as(X)

    NOISE_SE = 0
    train_yvar = torch.tensor(NOISE_SE**2, device=device, dtype=dtype)

    def generate_initial_data(n=10):
      # generate training data
      train_x = torch.rand(10, 6, device=device, dtype=dtype)
      exact_obj = model_evaluation_error(train_x).unsqueeze(-1)  # add output dimension
      exact_con = outcome_constraint(train_x).unsqueeze(-1)  # add output dimension
      train_obj = exact_obj + NOISE_SE * torch.randn_like(exact_obj)
      train_con = exact_con + NOISE_SE * torch.randn_like(exact_con)
      best_observed_value = weighted_obj(train_x).max().item()
      return train_x, train_obj, train_con, best_observed_value
    
    def initialize_model(train_x, train_obj, train_con, state_dict=None):
      # define models for objective and constraint
      model_obj = FixedNoiseGP(train_x, train_obj, train_yvar.expand_as(train_obj)).to(
          train_x
      )
      model_con = FixedNoiseGP(train_x, train_con, train_yvar.expand_as(train_con)).to(
          train_x
      )
      # combine into a multi-output GP model
      model = ModelListGP(model_obj, model_con)
      mll = SumMarginalLogLikelihood(model.likelihood, model)
      # load state dict if it is passed
      if state_dict is not None:
          model.load_state_dict(state_dict)
      return mll, model

    def obj_callable(Z: torch.Tensor, X: Optional[torch.Tensor] = None):
        return Z[..., 0]


    def constraint_callable(Z):
        return Z[..., 1]


    # define a feasibility-weighted objective for optimization
    constrained_obj = ConstrainedMCObjective(
        objective=obj_callable,
        constraints=[constraint_callable],
    )

    bounds = torch.tensor([[0.0] * 6, [1.0] * 6], device=device, dtype=dtype)

    BATCH_SIZE = 2
    NUM_RESTARTS = 2
    RAW_SAMPLES = 32
    N_TRIALS = 2
    N_BATCH = 2
    MC_SAMPLES = 32

    def optimize_acqf_and_get_observation(acq_func):
        """Optimizes the acquisition function, and returns a new candidate and a noisy observation."""
        # optimize
        candidates, _ = optimize_acqf(
            acq_function=acq_func,
            bounds=bounds,
            q=BATCH_SIZE,
            num_restarts=NUM_RESTARTS,
            raw_samples=RAW_SAMPLES,  # used for intialization heuristic
            options={"batch_limit": 5, "maxiter": 200},
        )
        # observe new values
        new_x = candidates.detach()
        exact_obj = model_evaluation_error(new_x).unsqueeze(-1)  # add output dimension
        exact_con = outcome_constraint(new_x).unsqueeze(-1)  # add output dimension
        new_obj = exact_obj + NOISE_SE * torch.randn_like(exact_obj)
        new_con = exact_con + NOISE_SE * torch.randn_like(exact_con)
        return new_x, new_obj, new_con


    def update_random_observations(best_random):
        """Simulates a random policy by taking a the current list of best values observed randomly,
        drawing a new random point, observing its value, and updating the list.
        """
        rand_x = torch.rand(BATCH_SIZE, 6)
        next_random_best = weighted_obj(rand_x).max().item()
        best_random.append(max(best_random[-1], next_random_best))
        return best_random

    verbose = False

    best_observed_all_ei, best_observed_all_nei, best_random_all = [], [], []

    # average over multiple trials
    for trial in range(1, N_TRIALS + 1):

        print(f"\nTrial {trial:>2} of {N_TRIALS} ", end="")
        best_observed_ei, best_observed_nei, best_random = [], [], []

        # call helper functions to generate initial training data and initialize model
        (
            train_x_ei,
            train_obj_ei,
            train_con_ei,
            best_observed_value_ei,
        ) = generate_initial_data(n=10)
        mll_ei, model_ei = initialize_model(train_x_ei, train_obj_ei, train_con_ei)

        train_x_nei, train_obj_nei, train_con_nei = train_x_ei, train_obj_ei, train_con_ei
        best_observed_value_nei = best_observed_value_ei
        mll_nei, model_nei = initialize_model(train_x_nei, train_obj_nei, train_con_nei)

        best_observed_ei.append(best_observed_value_ei)
        best_observed_nei.append(best_observed_value_nei)
        best_random.append(best_observed_value_ei)

        # run N_BATCH rounds of BayesOpt after the initial random batch
        for iteration in range(1, N_BATCH + 1):

            t0 = time.monotonic()

            # fit the models
            fit_gpytorch_mll(mll_ei)
            fit_gpytorch_mll(mll_nei)

            # define the qEI and qNEI acquisition modules using a QMC sampler
            qmc_sampler = SobolQMCNormalSampler(sample_shape=torch.Size([MC_SAMPLES]))

            # for best_f, we use the best observed noisy values as an approximation
            qEI = qExpectedImprovement(
                model=model_ei,
                best_f=(train_obj_ei * (train_con_ei <= 0).to(train_obj_ei)).max(),
                sampler=qmc_sampler,
                objective=constrained_obj,
            )

            qNEI = qNoisyExpectedImprovement(
                model=model_nei,
                X_baseline=train_x_nei,
                sampler=qmc_sampler,
                objective=constrained_obj,
            )

            # optimize and get new observation
            new_x_ei, new_obj_ei, new_con_ei = optimize_acqf_and_get_observation(qEI)
            new_x_nei, new_obj_nei, new_con_nei = optimize_acqf_and_get_observation(qNEI)

            # update training points
            train_x_ei = torch.cat([train_x_ei, new_x_ei])
            train_obj_ei = torch.cat([train_obj_ei, new_obj_ei])
            train_con_ei = torch.cat([train_con_ei, new_con_ei])

            train_x_nei = torch.cat([train_x_nei, new_x_nei])
            train_obj_nei = torch.cat([train_obj_nei, new_obj_nei])
            train_con_nei = torch.cat([train_con_nei, new_con_nei])

            # update progress
            best_random = update_random_observations(best_random)
            best_value_ei = weighted_obj(train_x_ei).max().item()
            best_value_nei = weighted_obj(train_x_nei).max().item()
            best_observed_ei.append(best_value_ei)
            best_observed_nei.append(best_value_nei)

            # reinitialize the models so they are ready for fitting on next iteration
            # use the current state dict to speed up fitting
            mll_ei, model_ei = initialize_model(
                train_x_ei,
                train_obj_ei,
                train_con_ei,
                model_ei.state_dict(),
            )
            mll_nei, model_nei = initialize_model(
                train_x_nei,
                train_obj_nei,
                train_con_nei,
                model_nei.state_dict(),
            )

            t1 = time.monotonic()

            if verbose:
                print(
                    f"\nBatch {iteration:>2}: best_value (random, qEI, qNEI) = "
                    f"({max(best_random):>4.2f}, {best_value_ei:>4.2f}, {best_value_nei:>4.2f}), "
                    f"time = {t1-t0:>4.2f}.",
                    end="",
                )
            else:
                print(".", end="")

        best_observed_all_ei.append(best_observed_ei)
        best_observed_all_nei.append(best_observed_nei)
        best_random_all.append(best_random)

    stop_time = timeit.default_timer()
    return {
      #'x': np.array(min_x),
      #'error': min_error,
      #'evaluations': len(dataset.observations),
      'time': stop_time - start_time,
      'trace': pd.DataFrame({'error': trace_errors, 'time': trace_times}),
      'success': True,
    }
