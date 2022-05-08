################################################
# INCLUDE SECTION. LOAD LIBRARIES, CODE
##########

setwd("C:/Users/45790702w/Documents/Model LC/Git-LC")

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
source("scriptUtils.R")

# Output support
library(Matrix)
source("yajirobai.R")


################################################
# INIT SECTION 
##########
tt0 <- Sys.time()
ttstamp <- format(tt0, "%Y%m%d_%H%M%S")

logfilename <- paste0("results/logs/exec_", ttstamp, ".log")
zz <- file(logfilename, open="wt")
sink(zz)
sink(zz, type="message")

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

sim.name <- "Unnamed"



################################################
# PARAMETERS SETUP
##########

N = 100000
Nsim=40
# show.band <- TRUE
show.band <- FALSE
show.overall <- FALSE

options_p <- list(
  # print = TRUE,
  #mpst_computation_states = c(1,2,3),
  smoker_inc_type = "current"
)

source("karin_SUPERparams.R")

################################################
# EL FOR
##########

sim.counter <- 1
# tryCatch({
  for (param in ALL.PARAMETERS) {
    t0 <- Sys.time()
    tstamp <- format(t0, "%Y%m%d_%H%M%S")
    
    # param retrieval
    sim.name <- param$sim.name
    interventions_p <- param$interventions_p
    costs_p <- param$costs_p
    
    # log
    cat("Start simulation ")
    cat(sim.counter)
    cat(": \"")
    cat(sim.name)
    cat("\"\n")
    
    ## Random seed
    seed <- sample.int(.Machine$integer.max,1)
    # cat("WARNING. Using preset seed.\n")
    # seed <- 1966531022
    set.seed(seed)
    cat(sprintf("Using seed: %10d\n", seed))
    
    # go!
    
    # sim <- lc.simulate.cpp(tpm$tpm, tpm$tp.limits,

    sim <- lc.simulate.cpp.multiple(tpm$tpm, tpm$tp.limits,
                                    interventions_p = interventions_p,
                                    costs_p = costs_p, 
                                    options_p = options_p, 
                                    # initial.healthy.population = N)
                                    initial.healthy.population = N,
                                    N.sim = Nsim)
    cat("Saving...")
    source("saver.R")
    cat(" OK!\t\t")

  
  
    t1 <- Sys.time()
    cat(sprintf("\nExecution time: %10.2f secs\n\n", as.numeric(difftime(t1,t0,units="secs"))))
    
    sim.counter <- sim.counter+1
    
  }
# }
# , error=function(e) cat("Exception. Skipping.\n"))



################################################
# CLEANING UP
##########

cat(      "\n*******************\n")
cat(        "*** CLEANING UP ***\n")
cat(        "*******************\n")

cat("Stopping cluster\n")
stopCluster(cl)
registerDoSEQ()
cat("Done\n")

tt1 <- Sys.time()
cat(sprintf("\nTotal execution time: %10.2f mins\n\n", as.numeric(difftime(tt1,tt0,units="mins"))))

cat("Stopping log\n")
sink()
sink(type="message")
