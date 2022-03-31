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
                 r_file_path,
                 r_function,
                 param_names,
                 strata,
                 population=None):
        path = os.path.abspath(r_file_path)
        r = ro.r
        r.setwd(os.path.dirname(path))
        r.source(os.path.basename(path))
        make_simulation_func = ro.globalenv[r_function]

        self.simulate_func = make_simulation_func(
            population,
            param_names,
            strata
        )

    def evaluate(self, x) -> list:
        return self.simulate_func(x)


strata = ['y{}_{}'.format(i, i+4) for i in range(50, 85, 5)]
# Input parameter names 
param_names = ['.p_progression_cancer_s1_2'] * len(strata)
r_file_path = '../../models/endometrium/calibration_wrapper.R'
r_function = 'calibration.simulation'

ec_model = RModel(r_file_path, r_function, param_names, strata, 'bleeding')
result = ec_model.evaluate([.1 for e in param_names])
print(result)