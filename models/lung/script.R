

# Simulation basics
source("constantDefinition.R")
source("lcSimulCpp.R")
source("lcInterventionsUtils.R")

# Data load and manip
source("loadTPMatrixFromFile.R")
source("calibrationParametersUtils.R")
source("TPMatricesFromVector.R")
source("TPMatricesToVector.R")

# Distance-specific files
source("distanceFunction.R")
# source("parallelGradient.R")

# Graphs
source("graphScript.R")

# Parallel support
library(foreach)
library(doParallel)
library(doRNG)
library(itertools)

# Generalized Simulated Annealing
library(GenSA)

# Utils
source("scriptUtils.R")

# Càrrega temporal de mortalitats TODO
real.mort <- list(
  lc.incidence = c(1.6,11.8,39.6,91.9,170.4,258.3,340.2,407.8,432.7),
  lc.mortality = c(1,5.8,28.3,64.9,121.7,187.4,255.8,328.1,400.6),
  tot.mortality = c( 0.703794,
                     1.154704,
                     2.179599,
                     3.976368,
                     6.479547,
                     9.839768,
                     14.806531,
                     22.589549,
                     38.978694#,
                     # 67.599756
  )*100 # taxes x1000
)

# Dades de mortalitat carregades


##########################
### SCRIPT BEGINS HERE ###
##########################

assign("last.warning", NULL, envir = baseenv())  # DEBUG only
set.seed(42)  # Reproducible results
# sink("results/test_20170620.log")
cat("\n### WARNING! If you are seeing this message, you may have forgotten to redirect output to log file!\n\n")

## CLUSTER SETUP
n.cores <- kNcores

cat(        "***********************************\n")
cat(sprintf("*** RUNNING ON A %d-core CLUSTER ***\n", n.cores))
cat(        "***********************************\n")
cat("\n")

cat("Initializing cluster...\n")
cl <- makeCluster(n.cores)
registerDoParallel(cl)
clusterExport(cl, c('lc.simulate.cpp', 'lc_simulate_cpp',
                    'TPMatricesFromCalibrableVector', 
                    'kStartAge', 'kEndAge', 'kPeriods', 'kHealthy',
                    'kDefaultGroupLength',
                    'kOptionsDefaultIncidence',
                    'GetAllInterventionsParameters',
                    'kInterventionsDefaultParameters'))
# SET UP CPU AFFINITY
# linux-based server requires OS-independent code,
# skipping this step
#
# pids <- foreach (i = 1:n.cores, .combine=c) %dopar% {
#   Sys.getpid()
# }
# for (i in 1:n.cores) {
#   shell(paste0("PowerShell -Command \"& {(Get-Process -id ",pids[i],").ProcessorAffinity = ",2^(i-1),"}\""))
#   s <- sprintf("[ PID %4d ] Affinity set to CPU #%d\n" ,pids[i],i-1)
#   cat(s)
# }
cat("Cluster initialized\n\n")


## DATA LOAD
cat("Carregant matriu...\n")
# tpm <- LoadTPMatrixFromFile("LC Excel model_mds_v02_ASB.xlsx", sheet = "7")
# tpm <- LoadTPMatrixFromFile("LC Excel model_mds_v02_ASB.xlsx", sheet = "11")
# tpm <- LoadTPMatrixFromFile("Remarkable TP matrices/tp_alice.xls")
# tpm <- LoadTPMatrixFromFile("Remarkable TP matrices/tp_alice_II.xls")
# tpm <- LoadTPMatrixFromFile("Remarkable TP matrices/tp_bob.xls")
# tpm <- LoadTPMatrixFromFile("Remarkable TP matrices/tp_bob_II.xls")
# tpm <- LoadTPMatrixFromFile("Remarkable TP matrices/tp_craig.xls")
# tpm <- LoadTPMatrixFromFile("Remarkable TP matrices/tp_carol.xls")
# tpm <- LoadTPMatrixFromFile("Remarkable TP matrices/tp_dratini.xls")
# tpm <- LoadTPMatrixFromFile("Remarkable TP matrices/tp_deSAstre.xls")
# tpm <- LoadTPMatrixFromFile("Remarkable TP matrices/tp_dan07.xls")
# tpm <- LoadTPMatrixFromFile("Remarkable TP matrices/tp_dan20.xls")
tpm <- LoadTPMatrixFromFile("Remarkable TP matrices/tp_euron0.xls")
# tpm$tpm <- A
cat("Matriu carregada\n")

demon <- 0


interventions_p <- list()

# Test1: Single simulation
# sim <- lc.simulate.cpp(tpm$tpm, tpm$tp.limits, interventions_p = interventions_p)
sim <- lc.simulate.cpp(tpm$tpm, tpm$tp.limits, interventions_p = interventions_p, costs_p = costs_p, options_p = options_p, initial.healthy.population = 100000)
stop ("ok ok")

# Test2: Multiple simulation in parallel (10 executions by default)
# time <- system.time(sim <- lc.simulate.cpp.multiple(tpm$tpm, tpm$tp.limits, N.sim = 10))

# Test5: Easter multi-test
# EasterMultiTest(tpm)

# Test 6: Compute distance of loaded matrix
# time <- system.time(
#   d <- UnifiedDistanceVector(tpm$tpm, real.mort, tpm$tp.limits)
# )
# 
# cat(        "Normalized distance w/ weights  100/0/0,  50/50/0, 33/33/33:\n")
# cat(sprintf("                     VALUES = (%8.2f, %8.2f, %8.2f)\n", d[1], d[2], d[3]))

# Test 7: Incremental calibration
# this test contained not adapted legacy code and has been removed

# Test 8: Example calibration
# calib.p <- list(pin.any.to.death.totals=TRUE)
# time <- system.time(
#   tp.post <- SingleRun(tpm$tpm, list("NM", c(1,0,0)), "Nelder-Mead", calib.p))

# Test 9: SA from Carol
# wl <- list("NM", c(.49, .49, .02))
# calib.p <- list(pin.any.to.death.totals = TRUE,
#                 age.groups = 4:6)
# distance.ag <- 4:9
# tp.post <- SingleRun(tpm$tpm, wl, "NM", calib.p = calib.p, dist.age.groups = distance.ag)
# 
# sim.deSAstre <- lc.simulate.cpp.multiple(tpm$tpm, tpm$tp.limits, N.sim = 10)
# sim.post  <- lc.simulate.cpp.multiple(tp.post, tpm$tp.limits, N.sim = 10)

# Test \Omega: Show Alice and Bob
sims <- list()
# tpm <- LoadTPMatrixFromFile("Remarkable TP matrices/tp_alice.xls")
# sims[["Alice"]] <- lc.simulate.cpp.multiple(tpm$tpm, tpm$tp.limits, N.sim = 10)
# tpm <- LoadTPMatrixFromFile("Remarkable TP matrices/tp_alice_II.xls")
# sims[["Alice.II"]] <- lc.simulate.cpp.multiple(tpm$tpm, tpm$tp.limits, N.sim = 10)
# tpm <- LoadTPMatrixFromFile("Remarkable TP matrices/tp_bob.xls")
# sims[["Bob"]] <- lc.simulate.cpp.multiple(tpm$tpm, tpm$tp.limits, N.sim = 10)
# tpm <- LoadTPMatrixFromFile("Remarkable TP matrices/tp_bob_II.xls")
# sims[["Bob.II"]] <- lc.simulate.cpp.multiple(tpm$tpm, tpm$tp.limits, N.sim = 10)
# tpm <- LoadTPMatrixFromFile("Remarkable TP matrices/tp_craig.xls")
# sims[["Craig"]] <- lc.simulate.cpp.multiple(tpm$tpm, tpm$tp.limits, N.sim = 10)
# tpm <- LoadTPMatrixFromFile("Remarkable TP matrices/tp_carol.xls")
# sims[["Carol"]] <- lc.simulate.cpp.multiple(tpm$tpm, tpm$tp.limits, N.sim = 10)
# tpm <- LoadTPMatrixFromFile("Remarkable TP matrices/tp_dratini.xls")
# sims[["Dratini"]] <- lc.simulate.cpp.multiple(tpm$tpm, tpm$tp.limits, N.sim = 10)
# tpm <- LoadTPMatrixFromFile("Remarkable TP matrices/tp_deSAstre.xls")
# sims[["deSAstre"]] <- lc.simulate.cpp.multiple(tpm$tpm, tpm$tp.limits, N.sim = 10)
# tpm <- LoadTPMatrixFromFile("Remarkable TP matrices/tp_dan07.xls")
# sims[["Dan.07"]] <- lc.simulate.cpp.multiple(tpm$tpm, tpm$tp.limits, N.sim = 10)
# tpm <- LoadTPMatrixFromFile("Remarkable TP matrices/tp_dan20.xls")
# sims[["Dan.20"]] <- lc.simulate.cpp.multiple(tpm$tpm, tpm$tp.limits, N.sim = 10)
interventions_p=list(diag_screen=c(5e-6,0.01,0.02,0.03,0,0,0), 
                     diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                     screening_start_age=50,
                     screening_end_age=70,
                     screening_periodicity=3,
                     screening_coverage=.7,
                     screening_quitters_years=10,
                     p_smoker=.3,
                     rr_smoker=1,

                     quitting_interventions = list(list(
                       coverage     = .3,
                       success_rate = .3,
                       interv_steps = seq(60,150,30)
                     ), list(
                       coverage = 1,
                       success_rate = 1,
                       interv_steps = 480
                     )),
                     # ),
                     
                     quitting_effect_type      = 'exponential',
                     quitting_rr_per_period    = .2^(1/(15*kPeriods)) # reducció 80% als 15 anys
                     )
# interventions_p$quitting_int_steps <- integer()
interventions_p$rr_smoker <- 10

costs_p <- list(
  screening=list(md=pi),
  usual.care=list(nmd=c(0.1, 1,5,10,0.2,0,0)),
  quitting.int=list(i=exp(1))
)

options_p <- list(
  # print = TRUE,
  mpst_computation_states = c(1,2,3),
  smoker_inc_type = "current"
)

sims[["Control"]] <- lc.simulate.cpp.multiple(tpm$tpm, tpm$tp.limits, start.age=35, end.age=80, lib='old', N.sim = 10, interventions_p = interventions_p)
interventions_p[["rr_smoker"]] <- 1
sims[["RR=1"]] <- lc.simulate.cpp.multiple(tpm$tpm, tpm$tp.limits, start.age=35, end.age=80, N.sim = 10, interventions_p = interventions_p)
interventions_p[["rr_smoker"]] <- 5
sims[["RR=5"]] <- lc.simulate.cpp.multiple(tpm$tpm, tpm$tp.limits, start.age=35, end.age=80, N.sim = 10, interventions_p = interventions_p)
interventions_p[["rr_smoker"]] <- 10
sims[["RR=10"]] <- lc.simulate.cpp.multiple(tpm$tpm, tpm$tp.limits, start.age=35, end.age=80, N.sim = 10, interventions_p = interventions_p)
interventions_p[["rr_smoker"]] <- 20
sims[["RR=20"]] <- lc.simulate.cpp.multiple(tpm$tpm, tpm$tp.limits, start.age=35, end.age=80, N.sim = 10, interventions_p = interventions_p)

# DEV <- matrix(nrow = 0,ncol=27)
# OLD <- matrix(nrow = 0,ncol=27)
# for(i in 1:10){
# O <- lc.simulate.cpp(tpm$tpm, tpm$tp.limits, start.age=35, end.age=80, lib='dev'); DEV <- rbind(DEV,(c(O[["lc.incidence"]],O[["lc.mortality"]],O[["tot.mortality"]])))
# O <- lc.simulate.cpp(tpm$tpm, tpm$tp.limits, start.age=35, end.age=80, lib='old'); OLD <- rbind(OLD,(c(O[["lc.incidence"]],O[["lc.mortality"]],O[["tot.mortality"]])))
# }

# cbind(OLD, rep(999.999, 10), rep(999.999, 10), rep(999.999, 10), rep(999.999, 10), rep(999.999, 10), DEV)
# aux <- colMeans(cbind(OLD, DEV))
# rbind(aux[1:9],aux[28:36])
# split(aux[1:27]-aux[28:54],c(1,2,3))

MakeComparativeGraphs(observed.data = real.mort,
                      results = sims,
                      age.groups = tpm$age.groups,
                      title = "Comparativa interval aplicació RR",
                      subtitle = "Amb una prevalença de tabac del 30%, RR=10")

stop("ok")

cat("Stopping cluster\n")
stopCluster(cl)
registerDoSEQ()
cat("Done\n")
sink()



