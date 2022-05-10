import numpy as np
import pandas as pd

class ErrorMeasure:
  def __init__(self, target=None):
    self.target = target
  
  def calculate_error(self, y) -> float:
    raise NotImplementedError

  def get_target(self):
    return self.target

class L2Error(ErrorMeasure):
  def calculate_error(self, y) -> float:
    return np.sum((self.target-y)**2)

class PMBIncidenceL2Error(L2Error):
  def __init__(self, target):
    self.target = target

class PMBMortalityL2Error(L2Error):
  def __init__(self, target):
    self.target = target

class WeightedError(L2Error):
  def __init__(self, target):
    self.target = target

  def calculate_error(self, y) -> float:
    n_outputs = len(y['incidence'])
    target = {
      'incidence': self.target['incidence'][:n_outputs],
      'lc_mortality': self.target['lc_mortality'][:n_outputs],
      'other_mortality': self.target['other_mortality'][:n_outputs]
    }
    return np.sum(
              .45 * np.abs(y['incidence'] - target['incidence'])/target['incidence'] + \
              .45 * np.abs(y['lc_mortality'] - target['lc_mortality'])/target['lc_mortality'] + \
              .1 * np.abs(y['other_mortality'] - target['other_mortality'])/target['other_mortality']
    )