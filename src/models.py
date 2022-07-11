import os
import contextlib
import rpy2.robjects as ro
from rpy2.robjects import pandas2ri

class Model:
    def __init__(self, path):
        self.path = path

    def evaluate(self, x, silence_model_output) -> list:
      raise NotImplementedError

class RModel(Model):
    def __init__(self, 
                 script_path,
                 r_function,
                 population=None,
                 global_vars={}):
      self.script_path = script_path
      self.r_function = r_function
      self.population = population
      self.global_vars = global_vars

    def setup(self, params, silence_model_output=False):
      def _init_model():
        path = os.path.abspath(self.script_path)
        r = ro.r
        r.setwd(os.path.dirname(path))
        r.source(os.path.basename(path))
        for key, value in self.global_vars.items():
          ro.globalenv[key] = value
        make_simulation_func = ro.globalenv[self.r_function]

        param_names, strata = zip(*params)
        param_names, strata = list(param_names), list(strata)

        self.simulate_func = make_simulation_func(
            self.population,
            param_names,
            strata
        )

      if silence_model_output:
        # Silence model initialization
        with contextlib.redirect_stdout(None):
          with contextlib.redirect_stderr(None):
            _init_model()
      else:
        _init_model()

    def evaluate(self, x, silence_model_output=False) -> list:
      if silence_model_output:
        # Silence model evaluation
        with contextlib.redirect_stdout(None):
          with contextlib.redirect_stderr(None):
            result = str(self.simulate_func(x))
      else:
        result = str(self.simulate_func(x))
      return result
