import os
import json
import concurrent.futures
import numpy as np
import pandas as pd
import time
from models import RModel
from measure_extractors.measure_extractors import ECModelExtractor, LCModelExtractor
from error_measures.error_measures import PMBIncidenceL2Error, PMBMortalityL2Error, WeightedError
from optimizers.classical import NelderMeadOptimizer
from optimizers.bayesian import BayesianOptimizer
from optimizers.particle_swarm import ParticleSwarmOptimizer
from optimizers.annealing import AnnealingOptimizer

PROJECT_PATH = os.path.abspath(os.path.join(__file__, os.path.pardir, os.path.pardir))
print(PROJECT_PATH)
starting_matrix = 1
n_matrices = 1

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
initial_guess = initial_guess[((starting_matrix-1)*11):(starting_matrix+n_matrices)*11]
params = [('x{}'.format(i), '') for i, _ in enumerate(initial_guess)]

model = RModel(script_path='{}/models/lung/calibration_wrapper.R'.format(PROJECT_PATH), 
                    r_function='make.calibration.func', 
                    population='',
                    global_vars={'N_MATRICES': 1,
                                 'STARTING_MATRIX': 1})
model.setup(params, False)

inputs = [(np.maximum(np.array(initial_guess), 0)).tolist() for noise in np.random.normal(0, 1e-8, 10000)]

times = []
for x in inputs:
    a = time.perf_counter_ns()
    model.evaluate(x)
    b = time.perf_counter_ns()
    times.append(b-a)

times = np.array(times) * 1e-6  # ms
print(np.mean(times))
print(np.sqrt(np.var(times)))