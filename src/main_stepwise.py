import os
import sys
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

PROJECT_PATH = os.path.abspath(os.path.join(__file__, os.path.pardir, os.path.pardir))

def calibrate(optimizer, n_matrices, simulation_delay, extractor, label, **kwargs):
    target = {
        'incidence': np.array([1.9, 9.0, 20.9, 39.7, 57.9, 68.8, 71.4, 70.4, 69.9]),
        'lc_mortality': np.array([0.29, 5.0, 13.4, 26.6, 42.5, 51.1, 52.0, 52.3, 53.9]),
        'other_mortality': np.array([39.8893, 64.0476, 114.6431, 188.9474, 289.2546 ,417.0061, 604.7883, 996.8391, 1871.6366])
    }
    initial_guess = [0.0000014899094538366, 0.00005867, 0.0373025655099923, 
                   0.45001903545473, 0.0310692140027966, 2.06599720339873e-06, 
                   0.083259360316924, 0.0310687721751887, 2.50782481130141e-06, 
                   0.031069806, 1.47440016369862e-06,
                   
                   1.04877e-05, 0.00009628, 0.014591745, 0.481776189, 
                   0.031069873, 1.40669e-06, 0.050026676, 0.031069146, 
                   2.13361e-06, 0.031070341, 9.38951e-07,
                   
                   0.00001850743, 0.00018182, 0.009078452, 0.445602151, 
                   0.031940262, 1.36813e-06, 0.040413788, 0.031940366, 
                   1.2638e-06, 0.031940406, 1.22435e-06,
                   
                   3.37959e-05, 0.00033198, 0.216982823, 0.745686098, 
                   0.03195267, 8.96007e-06, 0.279118741, 0.031934889, 
                   6.74088e-06, 0.031930383, 1.12474e-05,
                   
                   0.000047266, 0.00054161, 0.587748693, 0.367077318, 
                   0.0346737, 0.012333952, 0.938189625, 0.025488122, 
                   0.009300688, 0.030911619, 0.003877191,
                   
                   0.000057056, 0.00082374, 0.014863212, 0.94528741, 
                   0.03739473,0.0077771, 0.945729932, 0.033553455, 
                   0.001235355, 0.031429049, 0.003359761,
                   
                   0.00029203, 0.00124249, 0.57293827, 0.071391822, 
                   0.040115762, 0.000770938, 0.922967658, 0.004939897, 
                   0.035946803, 0.031592197, 0.009294503,
                   
                   0.00005383, 0.00190251, 0.224558597, 0.349067177, 
                   0.040817026, 6.96743e-05, 0.071749361, 0.001859725, 
                   0.039026975, 0.037767242, 0.003119458,
                   
                   0.000058942, 0.00330943, 0.009683304, 0.414010634, 
                   0.04151829, 0.030664353, 0.60868601, 0.006745365, 
                   0.046892055, 0.067318463, 0.004318957]
    
    def calibrate_step(group, fixed_params):
        initial_guess_group = initial_guess[(group*11):(group+1)*11]

        target_group = {k:v[0:n_matrices] for (k,v) in target.items()}
        params = [('x{}'.format(i), '') for i, _ in enumerate(initial_guess_group)]
        bounds = [(.5*p, min(1.5*p, 1)) for p in initial_guess_group]
        model = RModel(script_path='{}/models/lung/calibration_wrapper.R'.format(PROJECT_PATH), 
                        r_function='make.calibration.func', 
                        population='',
                        global_vars={'N_MATRICES': group+1,
                                    'STARTING_MATRIX': 1,
                                    'DELAY': simulation_delay})
        def make_constraint_func(i):
            def constraint_func(x):
                if i == 0:
                    return -1.0 + np.random.random() * 1e-4
                else:
                    return x[(group-1)*11+4] - x[group*11+4]
            return constraint_func
        
        constraint_func = make_constraint_func(group)
        # constraint_func = None
        error = WeightedError(target=target_group, constraint_func=constraint_func)

        kwargs['fixed_params'] = fixed_params
        kwargs['initial_guess'] = initial_guess_group
        kwargs['constraint_func'] = constraint_func
        kwargs['calibration_params'] = {}
        kwargs['calibration_params']['N_MATRICES'] = group+1
        kwargs['calibration_params']['STARTING_MATRIX'] = 1
        kwargs['calibration_params']['DELAY'] = simulation_delay
        print(kwargs['calibration_params'])
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
        print(' Label: {}'.format(label))
        # trace = result['trace']
        # result['trace'] = None
        # result['x'] = result['x'].tolist()

        # trace['error'] = trace['error'].apply(lambda x: x if type(x) is float else x[0])  # Assuming one value per line

        # jobid = '{}_{}'.format(os.getenv('SLURM_JOB_NAME'), os.getenv('SLURM_JOB_ID'))
        # output_dir = 'output/{}'.format(jobid) if jobid else 'output'
        # try:
        #     os.makedirs('{}/{}'.format(PROJECT_PATH, output_dir))
        # except FileExistsError:
        #     pass
        # json.dump(result, open('{}/{}/{}_info.csv'.format(PROJECT_PATH, output_dir, label), 'w'))
        # trace.to_csv('{}/{}/{}_trace.csv'.format(PROJECT_PATH, output_dir, label), index_label='index')
        return result

    fixed_params = []
    errors = []
    for i in range(n_matrices):
        group_results = calibrate_step(i, fixed_params)
        errors.append(group_results['error'])
        fixed_params.extend(group_results['x'])
    print('FULL CALIBRATED PARAMETERS')
    print(fixed_params)
    print(np.array(fixed_params)[list(range(4, 11*n_matrices, 11))])
    print(errors)


def calibrate_endometrium_model():
    params = [('.p_cancer___bleeding', 'y{}_{}'.format(i, i+4)) for i in range(50, 85, 5)]
    initial_guess = [.1] * len(params)
    target = [
        0.048220892, 0.081144281, 0.105328782, 0.117587650, 
        0.119602721, 0.119602721, 0.119602721
    ]
    bounds = [(.75*p, min(1.25*p, 1)) for p in initial_guess]
    model = RModel(script_path='{}/models/endometrium/calibration_wrapper.R'.format(PROJECT_PATH), 
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

def calibrate_lung_model(algorithm, n_matrices, starting_matrix=1, simulation_delay=0):
    extractor = LCModelExtractor()

    if algorithm == 'nelder-mead':
        nm_optimizer = NelderMeadOptimizer()
        calibrate(nm_optimizer,
                  n_matrices,
                  simulation_delay,
                  extractor,
                  label='{}_{}_{}_{}'.format(algorithm, starting_matrix, n_matrices, simulation_delay),
                  options={'maxiter':n_matrices*11*10000,
                           'xatol': 1e-12,
                           'fatol': 1e-12})
    elif algorithm == 'annealing':
        annealing_optimizer = AnnealingOptimizer()
        calibrate(annealing_optimizer,
                  n_matrices,
                  simulation_delay,
                  extractor,
                  label='{}_{}_{}_{}'.format(algorithm, starting_matrix, n_matrices, simulation_delay))
    elif algorithm == 'pso':
        pso_optimizer = ParticleSwarmOptimizer()
        calibrate(pso_optimizer,
                  n_matrices,
                  simulation_delay,
                  extractor,
                  swarmsize=n_matrices*50,#1000,
                  maxiter=n_matrices*50,#1000,
                  label='{}_{}_{}_{}'.format(algorithm, starting_matrix, n_matrices, simulation_delay))
    elif algorithm == 'bayesian':
        bo_optimizer = BayesianOptimizer(initial_points=10, 
                                         n_evaluations=30)
        calibrate(bo_optimizer,
                  n_matrices,
                  simulation_delay,
                  extractor,
                  label='{}_{}_{}_{}'.format(algorithm, starting_matrix, n_matrices, simulation_delay),
                  silence_model_output=False)
    else:
        raise ValueError('Algorithm not implemented')

if __name__ == '__main__':
    np.random.seed(1)
    if len(sys.argv) == 1:
        parameters = [
            #('nelder-mead', 1),
            ('annealing', 1),
            #('pso', 1),
            #('bayesian', 1)
            ]
        start = [1]
        end = [1]
        delays = [0]
    else:
        parameters = [(sys.argv[1], int(sys.argv[2]))]
        start = [int(sys.argv[3])]
        end = [int(sys.argv[4])]
        delays = [float(a) for a in sys.argv[5:]]
    dfs = []    
    results = []

    # for alg, n_workers in parameters:
    #     with concurrent.futures.ProcessPoolExecutor(max_workers=n_workers) as executor:
    #         for n_matrices in range(5,10):
    #             results.append(executor.submit(calibrate_lung_model, algorithm=alg, n_matrices=n_matrices))
    #     executor.shutdown(wait=True)

    # for alg, n_workers in parameters:
    #      with concurrent.futures.ProcessPoolExecutor(max_workers=n_workers) as executor:
    #          for last_matrix in end:#range(2,3):
    #              for starting_matrix in start:#range(1,last_matrix+1):
    #                  for delay in delays:
    #                     executor.submit(calibrate_lung_model, algorithm=alg, n_matrices=last_matrix-starting_matrix+1, starting_matrix=starting_matrix, simulation_delay=delay)
    #          executor.shutdown(wait=True)

    # for alg, n_workers in parameters:
    #     with concurrent.futures.ProcessPoolExecutor(max_workers=n_workers) as executor:
    #         for starting_matrix in range(1,10):
    #             executor.submit(calibrate_lung_model, algorithm=alg, n_matrices=1, starting_matrix=starting_matrix)
    #         executor.shutdown(wait=True)

    calibrate_lung_model(algorithm='bayesian', n_matrices=9, simulation_delay=.1)


    # Print possible exceptions
    for r in results:
        print(r.exception())
