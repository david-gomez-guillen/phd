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
  def __init__(self, target=None):
    if target:
      self.target = target
    else:
      self.target = [ # TODO: Source
        0.048220892, 0.081144281, 0.105328782, 0.117587650, 
        0.119602721, 0.119602721, 0.119602721
        ]

class PMBMortalityL2Error(L2Error):
  def __init__(self, target=None):
    if target:
      self.target = target
    else:
      self.target = [ # TODO: Source
        0.02259857, 0.02502118, 0.02502118, 0.03519120,
        0.03519120, 0.06203351, 0.06203351
        ]

class WeightedError(L2Error):
  def __init__(self, target=None):
    if target:
      self.target = target
    else:
      self.target = {
        'incidence': np.array([1.9, 9.0, 20.9, 39.7, 57.9, 68.8, 71.4, 70.4, 69.9]),
        'lc_mortality': np.array([0.29, 5.0, 13.4, 26.6, 42.5, 51.1, 52.0, 52.3, 53.9]),
        'other_mortality': np.array([39.8893, 64.0476, 114.6431, 188.9474, 289.2546 ,417.0061, 604.7883, 996.8391, 1871.6366])
      }

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