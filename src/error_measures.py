import numpy as np
import pandas as pd

class ErrorMeasure:
  def __init__(self, target=None):
    self.target = target
  
  def calculate_error(self, results) -> float:
    raise NotImplementedError

  def get_measure(self, results):
    raise NotImplementedError

  def get_target(self):
    return self.target

class L2Error(ErrorMeasure):
  def calculate_error(self, results) -> float:
    y = self.get_measure(results)
    return np.sqrt(np.sum((self.target-y)**2))

class PMBIncidenceL2Error(L2Error):
  def __init__(self, target=None):
    if target:
      self.target = target
    else:
      self.target = [ # TODO: Source
        0.048220892, 0.081144281, 0.105328782, 0.117587650, 
        0.119602721, 0.119602721, 0.119602721
        ]

  def get_measure(self, results):
    info = list(results['info'].values())[0]
    info = pd.DataFrame(info['additional.info']).loc[1:,['year', 'incidence_bleeding']]
    
    incidence = info.incidence_bleeding.groupby(info.year // 5).sum()
    
    return incidence

class PMBMortalityL2Error(L2Error):
  def __init__(self, target=None):
    if target:
      self.target = target
    else:
      self.target = [ # TODO: Source
        0.02259857, 0.02502118, 0.02502118, 0.03519120,
        0.03519120, 0.06203351, 0.06203351
        ]

  def get_measure(self, results):
    info = list(results['info'].values())[0]
    info = pd.DataFrame(info['additional.info']).loc[1:,['year', 'mortality']]
    
    mortality = info.mortality.groupby(info.year // 5).sum()
    
    return mortality