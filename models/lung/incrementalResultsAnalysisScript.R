
sims <- list()
tps <- list()
N.sim = 16

load("results_pcdavid/calibration_results_20170425_170438")
sims[[1]] <- lc.simulate.cpp.multiple(tp.post, tpm$tp.limits, N.sim = N.sim)
tps[[1]] <- tp.post

load("results_pcdavid/calibration_results_20170425_172705")
sims[[2]] <- lc.simulate.cpp.multiple(tp.post, tpm$tp.limits, N.sim = N.sim)
tps[[2]] <- tp.post

load("results_pcdavid/calibration_results_20170425_175927")
sims[[3]] <- lc.simulate.cpp.multiple(tp.post, tpm$tp.limits, N.sim = N.sim)
tps[[3]] <- tp.post

load("results_pcdavid/calibration_results_20170425_183416")
sims[[4]] <- lc.simulate.cpp.multiple(tp.post, tpm$tp.limits, N.sim = N.sim)
tps[[4]] <- tp.post

load("results_pcdavid/calibration_results_20170425_191831")
sims[[5]] <- lc.simulate.cpp.multiple(tp.post, tpm$tp.limits, N.sim = N.sim)
tps[[5]] <- tp.post

# load("results_pcdavid/calibration_results_20170424_203905")
# sims[[6]] <- lc.simulate.cpp.multiple(tp.post, tpm$tp.limits, N.sim = N.sim)
# tps[[6]] <- tp.post
# 
# load("results_pcdavid/calibration_results_20170424_213539")
# sims[[7]] <- lc.simulate.cpp.multiple(tp.post, tpm$tp.limits, N.sim = N.sim)
# tps[[7]] <- tp.post
# 
# load("results_pcdavid/calibration_results_20170424_224550")
# sims[[8]] <- lc.simulate.cpp.multiple(tp.post, tpm$tp.limits, N.sim = N.sim)
# tps[[8]] <- tp.post
# 
# load("results_pcdavid/calibration_results_20170425_104744")
# sims[[9]] <- lc.simulate.cpp.multiple(tp.post, tpm$tp.limits, N.sim = N.sim)
# tps[[9]] <- tp.post

names(sims) <- as.character(tpm$age.groups)[5:9]
dists <- sapply(tps, UnifiedDistanceVector, obs.data=real.mort, tp.limits=tpm$tp.limits, N.states=tpm$N.states)

MakeComparativeGraphs(observed.data = real.mort,
                      results = sims,
                      age.groups = tpm$age.groups,
                      title = 'Incremental Calibration')
