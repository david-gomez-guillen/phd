################################################
# INCLUDE SECTION. LOAD LIBRARIES, CODE
##########

setwd("S:/grups/MODELING/Lung_AECC_Gerard/3_ModelAECC_Gerard/ModelLC/Git_LC")

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

t0 <- Sys.time()
tstamp <- format(t0, "%Y%m%d_%H%M%S")
logfilename <- paste0("results/logs/exec_", tstamp, ".log")

zz <- file(logfilename, open="wt")
sink(zz)
sink(zz, type="message")

cat(sprintf("Logfile \"%s\" initialized\n", logfilename))
if (exists("sim.name")) {
  cat(paste0("Simulation name:\t", sim.name, "\n"))
}

## Reproducible results
seed <- sample.int(.Machine$integer.max,1)
#seed <- 1433461694
set.seed(seed)
cat(sprintf("Using seed: %10d\n\n", seed))

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
cat("Cluster initialized\n\n")
## [END] cluster setup


## DATA LOAD

## aqui llegim la matriu de transició d'un arxiu excel

 transition.matrix.filename <- "Remarkable TP matrices/tp_dan20.xls"
#transition.matrix.filename <- "Remarkable TP matrices/tp_euron0.xls"

cat("Loading matrix from file:")
cat(transition.matrix.filename)
cat("\n")
tpm <- LoadTPMatrixFromFile(transition.matrix.filename)
cat("Matriu carregada\n")
## [END] data load




################################################
# PARAMETERS SETUP
##########


##llegim els paràmetres

source("karin_parameters.R")


cat(      "\n***************************\n")
cat(        "*** RUNNING PARAMETERS: ***\n")
cat(        "***************************\n")
cat("\n")

## imprimim el sparàmetes d'entrada

cat(sprintf("N=%d\n", N))
cat("\n*** Intervention parameters:\n")
print(interventions_p)
cat("\n*** Cost parameters:\n")
print(costs_p)
cat("\n*** Options parameters:\n")
print(options_p)





################################################
# SIMULATION
##########

cat(      "\n***************************\n")
cat(        "*** STARTING SIMULATION ***\n")
cat(        "***************************\n")

## fem la simulació del model, amb una funció que recull els resulatats del model en cpp

if (!exists("sim.name")) sim.name <- "Unnamed"
# sim <- lc.simulate.cpp(tpm$tpm, tpm$tp.limits,
sim <- lc.simulate.cpp.multiple(tpm$tpm, tpm$tp.limits,
                                interventions_p = interventions_p,
                                costs_p = costs_p, 
                                options_p = options_p, 
                                # initial.healthy.population = N)
                                initial.healthy.population = N,
                                N.sim = Nsim)


# S'afegeix la simulaciÃ³ a la variable "datasim" (es verifica si existeix)
if (exists("datasim")) {
  if (is.null(datasim[[sim.name]])) {
    datasim[[sim.name]] <- sim
  } else {
    datasim[[toString(length(datasim)+1)]] <- sim
  }
} else {
  datasim <- list()
  datasim[[sim.name]] <- sim
}



cat(      "\n**************************\n")
cat(        "*** SIMULATION RESULTS ***\n")
cat(        "**************************\n")

## imprimim els resultats de la simulacio

#print(sim["nh"]) # TODO make it friendlier
print(sim[names(sim)[2:9]]) # (TODO) Warning: if "costs" entry is removed, this has to be modified
print(sim["costs_person"]) # TODO make it friendlier
print(sim["costs_person_year"]) # TODO make it friendlier
print(sim["qaly"])



cat(      "\n*****************************************\n")
cat(        "*** SIMULATION RESULTS - tidy version ***\n")
cat(        "*****************************************\n")

# cat("\n nh, mpst discarded\n")
# cat("incidence, mortality -> graphics\n")
# cat("\n Spontaneous diagnosis:\n")
# 
# cat("\n Screening diagnosis:\n")

cat("\n QALY:       \t")
cat(paste0(mean(sim[["qaly"]]), "      (sd=", sd(sim[["qaly"]]), ")\n"))

# cat("\n Quitting costs per person: \t")
# print(mean(sim[["costs"]][3,])/N)
# 
# cat("\n Cost: \t")
# print(mean(sim[["costs_person"]]["i",]))

cat("\n Cost:       \t")
cat(paste0(mean(sim[["costs_person"]][3])))
 #costpperson.vector <- sim[["costs"]][3,]/N+sim[["costs_person"]]["i",]
 #cat(paste0(mean(costpperson.vector), "      (sd=", sd(costpperson.vector), ")\n"))

#cat("\n Global LC incidence: \t")
#cat(paste0(mean(sim[["lc.global.inc"]]), "      (sd=", sd(sim[["lc.global.inc"]]), ")\n"))


#cat("\n LC Incidence 65+:   \t")
#cat(paste0(mean(sim[["lc.last180.inc"]]), "      (sd=", sd(sim[["lc.last180.inc"]]), ")\n"))


cat("\n")


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

t1 <- Sys.time()
cat(sprintf("\nExecution time: %10.2f secs\n\n", as.numeric(difftime(t1,t0,units="secs"))))

cat("Stopping log\n")
sink()
sink(type="message")


