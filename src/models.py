import os
import rpy2.robjects as ro
from rpy2.robjects import pandas2ri

class Model:
    def __init__(self, path):
        self.path = path

    def evaluate(self, x) -> list:
        pass

class RModel(Model):
    def __init__(self, 
                 script_path,
                 r_function,
                 population=None):
      self.script_path = script_path
      self.r_function = r_function
      self.population = population

    def setup(self, params):
      path = os.path.abspath(self.script_path)
      r = ro.r
      r.setwd(os.path.dirname(path))
      r.source(os.path.basename(path))
      make_simulation_func = ro.globalenv[self.r_function]

      param_names, strata = zip(*params)
      param_names, strata = list(param_names), list(strata)

      self.simulate_func = make_simulation_func(
          self.population,
          param_names,
          strata
      )

    def evaluate(self, x) -> list:
      return str(self.simulate_func(x))
