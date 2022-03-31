import json
import os
from models import RModel
from error_measures import PMBIncidenceL2Error
from optimizer import NelderMeadOptimizer


params = [('.p_cancer___bleeding', 'y{}_{}'.format(i, i+4)) for i in range(50, 85, 5)]
initial_guess = [.1] * len(params)
bounds = [(.9*p, min(1.1*p, 1)) for p in initial_guess]
incidence_target = [0.048220892, 0.081144281, 0.105328782, 0.117587650, 0.119602721, 0.119602721, 0.119602721]

ec_model = RModel(script_path=os.path.abspath('../models/endometrium/calibration_wrapper.R'), 
                  r_function='make.calibration.func', 
                  population='bleeding')
incidence_error = PMBIncidenceL2Error(incidence_target)
optimizer = NelderMeadOptimizer()

result = optimizer.optimize(ec_model, params, bounds, incidence_error, initial_guess=initial_guess)
print(result)
