import os
import numpy as np
from models import RModel
from measure_extractors.measure_extractors import ECModelExtractor, LCModelExtractor
from error_measures.error_measures import PMBIncidenceL2Error, PMBMortalityL2Error, WeightedError
from optimizers.classical import NelderMeadOptimizer
from optimizers.bayesian import BayesianOptimizer

def calibrate(model, optimizer, params, bounds, extractor, error, initial_guess):
    result = optimizer.optimize(model, 
                                params, 
                                bounds, 
                                extractor,
                                error, 
                                initial_guess=initial_guess)

    print('{}'.format(optimizer.__class__.__name__))
    print('Best solution: {}'.format(result['x']))
    print(' Error: {}'.format(result['error']))
    print(' Model evaluations: {}'.format(result['evaluations']))


def calibrate_endometrium_model():
    params = [('.p_cancer___bleeding', 'y{}_{}'.format(i, i+4)) for i in range(50, 85, 5)]
    initial_guess = [.1] * len(params)
    target = [
        0.048220892, 0.081144281, 0.105328782, 0.117587650, 
        0.119602721, 0.119602721, 0.119602721
    ]
    bounds = [(.75*p, min(1.25*p, 1)) for p in initial_guess]
    model = RModel(script_path=os.path.abspath('models/endometrium/calibration_wrapper.R'), 
                    r_function='make.calibration.func', 
                    population='bleeding')

    extractor = ECModelExtractor('incidence_bleeding')
    error = PMBIncidenceL2Error(target=target)

    # extractor = ECModelExtractor('incidence_mortality')
    # target = [
    #     0.02259857, 0.02502118, 0.02502118, 0.03519120,
    #     0.03519120, 0.06203351, 0.06203351
    # ]
    # error = PMBMortalityL2Error(target=target)

    nm_optimizer = NelderMeadOptimizer()
    calibrate(model, nm_optimizer, params, bounds, extractor, error, initial_guess)

    bo_optimizer = BayesianOptimizer()
    calibrate(model, bo_optimizer, params, bounds, extractor, error, initial_guess)


def calibrate_lung_model():
    initial_guess = [0.0000014899094538366, 0.00005867, 0.0373025655099923, 0.45001903545473, 
                    0.0310692140027966, 2.06599720339873E-06, 0.083259360316924, 0.0310687721751887, 
                    2.50782481130141E-06, 0.031069806, 1.47440016369862E-06]
    target = {
        'incidence': np.array([1.9, 9.0, 20.9, 39.7, 57.9, 68.8, 71.4, 70.4, 69.9]),
        'lc_mortality': np.array([0.29, 5.0, 13.4, 26.6, 42.5, 51.1, 52.0, 52.3, 53.9]),
        'other_mortality': np.array([39.8893, 64.0476, 114.6431, 188.9474, 289.2546 ,417.0061, 604.7883, 996.8391, 1871.6366])
    }
    params = [('x{}'.format(i), '') for i, _ in enumerate(initial_guess)]
    bounds = [(.75*p, min(1.25*p, 1)) for p in initial_guess]
    model = RModel(script_path=os.path.abspath('models/lung/calibration_wrapper.R'), 
                    r_function='make.calibration.func', 
                    population='')
                    
    extractor = LCModelExtractor()
    error = WeightedError(target=target)

    nm_optimizer = NelderMeadOptimizer()
    calibrate(model, nm_optimizer, params, bounds, extractor, error, initial_guess)

    bo_optimizer = BayesianOptimizer(initial_points=10, n_evaluations=40)
    calibrate(model, bo_optimizer, params, bounds, extractor, error, initial_guess)


if __name__ == '__main__':
    calibrate_lung_model()
