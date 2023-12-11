import numpy as np
import pandas as pd

class ErrorMeasure:
  def __init__(self, target=None, constraint_func=None):
    self.target = target
  
  def calculate_error(self, x, y, **kwargs) -> float:
    raise NotImplementedError

  def get_target(self):
    return self.target

class L2Error(ErrorMeasure):
  def calculate_error(self, x, y, **kwargs) -> float:
    return np.sum((self.target-y)**2)

class PMBIncidenceL2Error(L2Error):
  def __init__(self, target, constraint_func=None):
    self.target = target

class PMBMortalityL2Error(L2Error):
  def __init__(self, target, constraint_func=None):
    self.target = target

class WeightedError(L2Error):
  def __init__(self, target, constraint_func=None):
    self.target = target
    self.constraint_func = constraint_func # Constraint satisfied if constraint_func(x) < 0

  def calculate_error(self, x, y, **kwargs) -> float:
    PENALTY_FACTOR = 1e5
    n_outputs = len(y['incidence'])
    target = {
      'incidence': self.target['incidence'][:n_outputs],
      'lc_mortality': self.target['lc_mortality'][:n_outputs],
      'other_mortality': self.target['other_mortality'][:n_outputs]
    }
    if self.constraint_func and kwargs.get('use_constraint_penalty', True):
      penalty = max(0, self.constraint_func(x)) * PENALTY_FACTOR
    else:
      penalty = 0
    return np.sum(
              .45 * (y['incidence'] - target['incidence'])**2/target['incidence'] + \
              .45 * (y['lc_mortality'] - target['lc_mortality'])**2/target['lc_mortality'] + \
              .1 * (y['other_mortality'] - target['other_mortality'])**2/target['other_mortality']
    ) + penalty