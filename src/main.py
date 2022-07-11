import os
import json
import concurrent.futures
import numpy as np
import pandas as pd
from models import RModel
from measure_extractors.measure_extractors import ECModelExtractor, LCModelExtractor
from error_measures.error_measures import PMBIncidenceL2Error, PMBMortalityL2Error, WeightedError
from optimizers.classical import NelderMeadOptimizer
from optimizers.bayesian import BayesianOptimizer
from optimizers.particle_swarm import ParticleSwarmOptimizer
from optimizers.annealing import AnnealingOptimizer

def calibrate(model, optimizer, params, bounds, extractor, error, label, **kwargs):
    result = optimizer.optimize(model, 
                                params, 
                                bounds, 
                                extractor,
                                error, 
                                **kwargs)

    print('{}'.format(optimizer.__class__.__name__))
    print('Best solution: {}'.format(result['x']))
    print(' Error: {}'.format(result['error']))
    print(' Model evaluations: {}'.format(result['evaluations']))
    print(' Time: {}'.format(result['time']))
    trace = result['trace']
    result['trace'] = None
    result['x'] = result['x'].tolist()

    json.dump(result, open('{}/phd/output/{}_info.csv'.format(os.path.expanduser('~'), label), 'w'))
    trace.to_csv('{}/phd/output/{}_trace.csv'.format(os.path.expanduser('~'), label), index_label='index')


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
    calibrate(model, nm_optimizer, params, bounds, extractor, error, initial_guess=initial_guess)

    bo_optimizer = BayesianOptimizer()
    calibrate(model, bo_optimizer, params, bounds, extractor, error)

    pso_optimizer = ParticleSwarmOptimizer()
    calibrate(model, pso_optimizer, params, bounds, extractor, error)

    annealing_optimizer = AnnealingOptimizer()
    calibrate(model, annealing_optimizer, params, bounds, extractor, error)

def calibrate_lung_model(algorithm, n_matrices):
    initial_guess = [0.0000014899094538366, 0.00005867, 0.0373025655099923, 0.45001903545473, 
                    0.0310692140027966, 2.06599720339873E-06, 0.083259360316924, 0.0310687721751887, 
                    2.50782481130141E-06, 0.031069806, 1.47440016369862E-06
                    
                    ,1.04877E-05, 0.00009628, 0.014591745, 0.481776189, 0.031069873,
                    1.40669E-06, 0.050026676, 0.031069146, 2.13361E-06, 0.031070341, 9.38951E-07

                    ,0.00001850743, 0.00018182, 0.009078452, 0.445602151, 0.031940262, 1.36813E-06, 
                    0.040413788, 0.031940366, 1.2638E-06, 0.031940406, 1.22435E-06,
                    
                    3.37959E-05, 0.00033198, 0.216982823, 0.745686098, 0.03193267, 8.96007E-06,
                    0.279118741, 0.031934889, 6.74088E-06, 0.031930383, 1.12474E-05,
                    
                    0.000047266, 0.00054161, 0.587748693, 0.367077318, 0.022454858, 0.012333952, 
                    0.938189625, 0.025488122, 0.009300688, 0.030911619, 0.003877191,
                    
                    0.000057056, 0.00082374, 0.014863212, 0.94528741, 0.02701171, 0.0077771, 
                    0.945729932, 0.033553455, 0.001235355, 0.031429049, 0.003359761,
                    
                    0.00029203, 0.00124249, 0.57293827, 0.071391822, 0.040115762, 0.000770938, 
                    0.922967658, 0.004939897, 0.035946803, 0.031592197, 0.009294503,
                    
                    0.00005383, 0.00190251, 0.224558597, 0.349067177, 0.040817026, 6.96743E-05,
                    0.071749361, 0.001859725, 0.039026975, 0.037767242, 0.003119458,
                    
                    0.000058942, 0.00330943, 0.009683304, 0.414010634, 0.022973067, 0.030664353, 
                    0.60868601, 0.006745365, 0.046892055, 0.067318463, 0.004318957
                    ]
    initial_guess = initial_guess[:n_matrices*11]
    target = {
        'incidence': np.array([1.9, 9.0, 20.9, 39.7, 57.9, 68.8, 71.4, 70.4, 69.9]),
        'lc_mortality': np.array([0.29, 5.0, 13.4, 26.6, 42.5, 51.1, 52.0, 52.3, 53.9]),
        'other_mortality': np.array([39.8893, 64.0476, 114.6431, 188.9474, 289.2546 ,417.0061, 604.7883, 996.8391, 1871.6366])
    }
    params = [('x{}'.format(i), '') for i, _ in enumerate(initial_guess)]
    bounds = [(.75*p, min(1.25*p, 1)) for p in initial_guess]
    model = RModel(script_path=os.path.expanduser('~/phd/models/lung/calibration_wrapper.R'.format(os.path.dirname(__file__))), 
                    r_function='make.calibration.func', 
                    population='',
                    global_vars={'N_MATRICES': n_matrices})
                    
    extractor = LCModelExtractor()
    error = WeightedError(target=target)

    if algorithm == 'nelder-mead':
        nm_optimizer = NelderMeadOptimizer()
        calibrate(model,
                nm_optimizer,
                params,
                bounds,
                extractor,
                error,
                initial_guess=initial_guess,
                label='{}_{}'.format(algorithm, n_matrices))
    elif algorithm == 'annealing':
        annealing_optimizer = AnnealingOptimizer()
        calibrate(model,
                  annealing_optimizer,
                  params,
                  bounds,
                  extractor,
                  error,
                  initial_guess=initial_guess,
                  label='{}_{}'.format(algorithm, n_matrices))
    elif algorithm == 'pso':
        pso_optimizer = ParticleSwarmOptimizer()
        calibrate(model,
                  pso_optimizer,
                  params,
                  bounds,
                  extractor,
                  error,
                  swarmsize=n_matrices*100,
                  maxiter=n_matrices*100,
                  label='{}_{}'.format(algorithm, n_matrices))
    elif algorithm == 'bayesian':
        bo_optimizer = BayesianOptimizer(initial_points=n_matrices*10, n_evaluations=40+n_matrices*10)
        calibrate(model,
                  bo_optimizer,
                  params,
                  bounds,
                  extractor,
                  error,
                  label='{}_{}'.format(algorithm, n_matrices),
                  silence_model_output=False)
    else:
        raise ValueError('Algorithm not implemented')

if __name__ == '__main__':
    algorithms = [#'nelder-mead', 
                  #'annealing', 
                  #'pso', 
                  'bayesian']
    max_workers = [#9, 
                   #9, 
                   #1, 
                   1]
    dfs = []

    for i, alg in enumerate(algorithms):
         with concurrent.futures.ProcessPoolExecutor(max_workers=max_workers[i]) as executor:
             for n_matrices in range(1,10):
                 executor.submit(calibrate_lung_model, algorithm=alg, n_matrices=n_matrices)
         executor.shutdown(wait=True)

