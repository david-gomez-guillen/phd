import numpy as np
import pandas as pd

class MeasureExtractor:  
  def get_measure(self, results):
    raise NotImplementedError

class ECModelExtractor(MeasureExtractor):
  def __init__(self, metric):
    self.metric = metric

  def get_measure(self, results) -> float:
    info = list(results['info'].values())[0]
    info = pd.DataFrame(info['additional.info']).loc[1:,['year', self.metric]]
    
    incidence = info[self.metric].groupby(info.year // 5).sum()
    
    return incidence

class LCModelExtractor(MeasureExtractor):
  def get_measure(self, results) -> float:    
    return {
      'incidence': np.array(results['incidence']),
      'lc_mortality': np.array(results['lc_mortality']),
      'other_mortality': np.array(results['other_mortality']),
    }