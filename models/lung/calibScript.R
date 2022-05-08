################################################
# INCLUDE SECTION. LOAD LIBRARIES, CODE
##########

# setwd("S:/grups/MODELING/Lung_AECC_Gerard/3_ModelAECC_Gerard/ModelLC/Git_LC")

# Simulation basics
source("constantDefinition.R")
source("lcSimulCpp.R")
source("lcInterventionsUtils.R")

# Data load and manip
source("loadTPMatrixFromFile.R")

# Parallel support
library(foreach)
library(doParallel)
library(doRNG)
library(itertools)

# Utils
source("distanceFunction.R")
source("scriptUtils.R")
source("TPMatricesFromVector.R")
source("TPMatricesToVector.R")
source("calibrationParametersUtils.R")
source("graphScript.R")

# Generalized Simulated Annealing
library(GenSA)

# Output support
library(Matrix)
source("yajirobai.R")


################################################
# INIT SECTION 
##########
#tt0 <- Sys.time()
#ttstamp <- format(tt0, "%Y%m%d_%H%M%S")
#
#logfilename <- paste0("results/logs/calib_exec_", ttstamp, ".log")
#zz <- file(logfilename, open="wt")
#sink(zz)
#sink(zz, type="message")

## CLUSTER SETUP
n.cores <- kNcores

cat(        "***********************************\n")
cat(sprintf("*** RUNNING ON A %d-core CLUSTER ***\n", n.cores))
cat(        "***********************************\n")
cat("\n")

cat("Initializing cluster...\n")
cl <- makeCluster(n.cores)
clusterExport(cl, c('lc.simulate.cpp', 'lc_simulate_cpp',
                    'kStartAge', 'kEndAge', 'kPeriods', 'kHealthy',
                    'kDefaultGroupLength',
                    'kOptionsDefaultIncidence',
                    'GetAllInterventionsParameters',
                    'kInterventionsDefaultParameters',
                    'age.weights'))
registerDoParallel(cl)
# registerDoSEQ()
cat("Cluster initialized\n\n")
## [END] cluster setup



## DATA LOAD
transition.matrix.filename <- "Remarkable TP matrices/tp_dan20.xls"

cat("Loading matrix from file:")
cat(transition.matrix.filename)
cat("\n")
tpm <- LoadTPMatrixFromFile(transition.matrix.filename)
cat("Matriu carregada\n")
## [END] data load


# Càrrega temporal de mortalitats TODO 
real.mort <- list(
  #lc.incidence = c(1.6,11.8,39.6,91.9,170.4,258.3,340.2,407.8,432.7), # MEN
  lc.incidence = c(1.3,10.5,21.0,34.4,44.2,47.8,48.0,50.1,56.8), # WOMEN
  #lc.mortality = c(1,5.8,28.3,64.9,121.7,187.4,255.8,328.1,400.6), # MEN
  lc.mortality = c(0.9,7.8,14.2,22.7,29.6,32.4,33.6,37.4,50.3), # WOMEN
  # tot.mortality = c( 0.703794,
  #                    1.154704,
  #                    2.179599,
  #                    3.976368,
  #                    6.479547,
  #                    9.839768,
  #                    14.806531,
  #                    22.589549,
  #                    38.978694
  # )*100 # taxes x1000     # MEN
  tot.mortality = c( 0.380972,
                     0.694827,
                     1.202252,
                     1.960304,
                     3.035235,
                     4.089336,
                     6.007853,
                     10.002099,
                     19.884787
  )*100 # taxes x1000     # WOMEN
)

# Simulation parameters when calibrating
interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                     diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                     
                     # no quitting nor screening
                     screening_start_age=55, screening_end_age=55, screening_periodicity=12, screening_coverage=0.1869, screening_quitters_years=15, survival_after_scr_dx=.3714,
                     quitting_interventions = list(list()), quitting_effect_type = 'logistic', quitting_ref_years = 15, quitting_rr_after_ref_years = .2, # reducció 80% als 15 anys
                     
                     # TODO dones? 1?
                     p_smoker=0,
                    
                     
                     # TODO dones
                     rr_smoker=1
                  
)
costs_p <- list(
  screening=list(i=0),
  quitting.int=list(i=0), # dummy
  postdx_treatment=list(i=14160.4),
  utilities=c(1,.705,.655,.530,0,0,0),
  discount.factor=0.03
)

options_p <- list(
  smoker_inc_type = "current"
)
# [END] parameters



demon <- 0

calib.p <- list(pin.any.to.death.totals = TRUE)

# Calib 1: SA from Dan20, weighted 49/49/2
wl <- list("NM", c(.49,.49,.02))
tp.pre <- tpm$tpm
tp.post.1 <- SingleRun(tp.pre, wl, "Nelder-Mead", calib.p = calib.p, dist.age.groups = 1:9)
#tp.post.sa <- SingleRun(tp.pre, wl, "SA", calib.p = calib.p, dist.age.groups = 1:9)

# Calib 2: NM from previous, weighted 49/49/2
 #wl <- list("NM", c(.49, .49, .02))
 #tp.pre <- tp.post.sa
 #tp.post.1 <- SingleRun(tp.pre, wl, "Nelder-Mead", calib.p = calib.p, dist.age.groups = 1:9)
 
# Calib 3: NM from previous, weighted 49/49/2
 #wl <- list("NM", c(.49, .49, .02))
 #tp.pre <- tp.post.1
 #tp.post.2 <- SingleRun(tp.pre, wl, "Nelder-Mead", calib.p = calib.p, dist.age.groups = 1:9)




# Calib 3: Dan-like series => Euron, weighted 49/49/2
# TBD


cat(      "\n*******************\n")
cat(        "*** CLEANING UP ***\n")
cat(        "*******************\n")

cat("Stopping cluster\n")
stopCluster(cl)
registerDoSEQ()
cat("Done\n")

tt1 <- Sys.time()
cat(sprintf("\nTotal execution time: %10.2f mins\n\n", as.numeric(difftime(tt1,tt0,units="mins"))))

#cat("Stopping log\n")
#sink()
#sink(type="message")

