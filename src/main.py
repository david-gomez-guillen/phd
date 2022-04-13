import os
from models import RModel
from error_measures import PMBIncidenceL2Error, PMBMortalityL2Error
from optimizer import NelderMeadOptimizer


params = [('.p_cancer___bleeding', 'y{}_{}'.format(i, i+4)) for i in range(50, 85, 5)]
initial_guess = [.1] * len(params)
bounds = [(.75*p, min(1.25*p, 1)) for p in initial_guess]
ec_model = RModel(script_path=os.path.abspath('models/endometrium/calibration_wrapper.R'), 
                  r_function='make.calibration.func', 
                  population='bleeding')
                  
#incidence_error = PMBIncidenceL2Error()
mortality_error = PMBMortalityL2Error()
optimizer = NelderMeadOptimizer()

result = optimizer.optimize(ec_model, 
                            params, 
                            bounds, 
                            mortality_error, 
                            initial_guess=initial_guess)

print('Best solution: {}'.format(result['x']))
print(' Error: {}'.format(result['error']))
print(' Model evaluations: {}'.format(result['evaluations']))
