import numpy as np
import pandas as pd

class ErrorMeasure:
  def __init__(self, target):
    self.target = target
  
  def calculate_error(self, results) -> float:
    pass

class L2Error(ErrorMeasure):
  def calculate_error(self, results) -> float:
    y = self.get_measure(results)
    return np.sqrt(np.sum((self.target-y)**2))

  def get_measure(self, results):
    pass

class PMBIncidenceL2Error(L2Error):
  def get_measure(self, results):
    info = list(results['info'].values())[0]
    info = pd.DataFrame(info['additional.info']).loc[1:,['year', 'incidence_bleeding']]
    
    incidence = info.incidence_bleeding.groupby(info.year // 5).sum()
    
    return incidence