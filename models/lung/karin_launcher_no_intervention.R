
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

#t0 <- Sys.time()
#tstamp <- format(t0, "%Y%m%d_%H%M%S")
#logfilename <- paste0("results/logs/exec_", tstamp, ".log")

#zz <- file(logfilename, open="wt")
#sink(zz)
#sink(zz, type="message")
#
#cat(sprintf("Logfile \"%s\" initialized\n", logfilename))
#if (exists("sim.name")) {
#  cat(paste0("Simulation name:\t", sim.name, "\n"))
#}

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
transition.matrix.filename <- "Remarkable TP matrices/tp_dan20.xls"
#transition.matrix.filename <- "Remarkable TP matrices/tp_euron0.xls"

cat("Loading matrix from file:")
cat(transition.matrix.filename)
cat("\n")
tpm <- LoadTPMatrixFromFile(transition.matrix.filename)
cat("Matriu carregada\n")
## [END] data load

#####################
#####canviem matriu per tots els grups
####################



  x3=ma[[100]]
 
  
  #35-39
  for(i in 1:4){
    for(j in 1:4){
      tpm$`tpm`$`35-39`[i,j]=x3[[1]][i,j]
    }
  }
  for(i in 1:4){
    for(j in 6:7){
      tpm$`tpm`$`35-39`[i,j]=x3[[1]][i,j-1]
    }
  }
  #40-44
  for(i in 1:4){
    for(j in 1:4){
      tpm$`tpm`$`40-44`[i,j]=x3[[2]][i,j]
    }
  }
  for(i in 1:4){
    for(j in 6:7){
      tpm$`tpm`$`40-44`[i,j]=x3[[2]][i,j-1]
    }
  }
  #45-49
  for(i in 1:4){
    for(j in 1:4){
      tpm$`tpm`$`45-49`[i,j]=x3[[3]][i,j]
    }
  }
  for(i in 1:4){
    for(j in 6:7){
      tpm$`tpm`$`45-49`[i,j]=x3[[3]][i,j-1]
    }
  }
  #50-54
  for(i in 1:4){
    for(j in 1:4){
      tpm$`tpm`$`50-54`[i,j]=x3[[4]][i,j]
    }
  }
  for(i in 1:4){
    for(j in 6:7){
      tpm$`tpm`$`50-54`[i,j]=x3[[4]][i,j-1]
    }
  }
  #55-59
  for(i in 1:4){
    for(j in 1:4){
      tpm$`tpm`$`55-59`[i,j]=x3[[5]][i,j]
    }
  }
  for(i in 1:4){
    for(j in 6:7){
      tpm$`tpm`$`55-59`[i,j]=x3[[5]][i,j-1]
    }
  }
  #60-64
  for(i in 1:4){
    for(j in 1:4){
      tpm$`tpm`$`60-64`[i,j]=x3[[6]][i,j]
    }
  }
  for(i in 1:4){
    for(j in 6:7){
      tpm$`tpm`$`60-64`[i,j]=x3[[6]][i,j-1]
    }
  }
  #65-69
  for(i in 1:4){
    for(j in 1:4){
      tpm$`tpm`$`65-69`[i,j]=x3[[7]][i,j]
    }
  }
  for(i in 1:4){
    for(j in 6:7){
      tpm$`tpm`$`65-69`[i,j]=x3[[7]][i,j-1]
    }
  }
  #70-74
  for(i in 1:4){
    for(j in 1:4){
      tpm$`tpm`$`70-74`[i,j]=x3[[8]][i,j]
    }
  }
  for(i in 1:4){
    for(j in 6:7){
      tpm$`tpm`$`70-74`[i,j]=x3[[8]][i,j-1]
    }
  }
  #75-79
  for(i in 1:4){
    for(j in 1:4){
      tpm$`tpm`$`75-79`[i,j]=x3[[9]][i,j]
    }
  }
  for(i in 1:4){
    for(j in 6:7){
      tpm$`tpm`$`75-79`[i,j]=x3[[9]][i,j-1]
    }
  }
  
  
  
  ########################
  ##### matriu canviada
  #######################
  
  
  ################################################
  # PARAMETERS SETUP
  ##########
  
  source("calib_param.R")

costs_p <- list(
  screening=list(i=0),
  quitting.int=list(i=0), # dummy
  postdx_treatment=list(i=14160.4*4),
  
  #usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
  
  utilities=c(1,.705,.655,.530,0,0,0),
  
  discount.factor=0.03
)
  ################################################
  # SIMULATION
  ##########
  
  cat(      "\n***************************\n")
  cat(        "*** STARTING SIMULATION ***\n")
  cat(        "***************************\n")
  
  
  if (!exists("sim.name")) sim.name <- "Unnamed"
  # sim <- lc.simulate.cpp(tpm$tpm, tpm$tp.limits,
  sim <- lc.simulate.cpp.multiple(tpm$tpm, tpm$tp.limits,
                                  interventions_p = interventions_p,
                                  costs_p = costs_p, 
                                  options_p = options_p, 
                                  # initial.healthy.population = N)
                                  initial.healthy.population = N,
                                  N.sim = Nsim)
  
  
  # S'afegeix la simulació a la variable "datasim" (es verifica si existeix)
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
  
  library(xlsx)
  library(dplyr)

  excel.filename <- "results/0-lc_excelresults_no_int4.xlsx"
  df=data.frame()
  
  df[1, "sim.name"] <- sim.name
  
  # RESULTS
  df[1, "QALY"] <- mean(sim[["qaly"]])
  df[1, "sd.QALY"] <- sd(sim[["qaly"]])
  # df[r, "Cost"] <- mean(costpperson.vector)
  # df[r, "sd.Cost"] <- sd(costpperson.vector)
  df[1, "Cost"] <- mean(sim[["costs_person"]]["i",])
  df[1, "sd.Cost"] <- sd(sim[["costs_person"]]["i",])
  df[1, "Undisc.QALY"] <- mean(sim[["undisc_qaly"]])
  df[1, "sd.Undisc.QALY"] <- sd(sim[["undisc_qaly"]])
  df[1, "Undisc.cost"] <- mean(sim[["undisc_costs_person"]]["i",])
  df[1, "sd.Undisc.cost"] <- sd(sim[["undisc_costs_person"]]["i",])
  df[1, "Inc.Global.sim"] <- mean(sim[["lc.globalsim.inc"]])
  df[1, "sd.Inc.Global.sim"] <- sd(sim[["lc.globalsim.inc"]])
  df[1, "Inc.65.sim"] <- mean(sim[["lc.last15y.inc"]])
  df[1, "sd.Inc.65.sim"] <- sd(sim[["lc.last15y.inc"]])
  df[1, "Inc.Global.crude"] <- mean(sim[["lc.globalsim.crude.inc"]])
  df[1, "sd.Inc.Global.crude"] <- sd(sim[["lc.globalsim.crude.inc"]])
  df[1, "Inc.65.crude"] <- mean(sim[["lc.last15y.crude.inc"]])
  df[1, "sd.Inc.65.crude"] <- sd(sim[["lc.last15y.crude.inc"]])
  df[1, "Inc.Global.asr"] <- mean(sim[["lc.globalsim.asr.inc"]])
  df[1, "sd.Inc.Global.asr"] <- sd(sim[["lc.globalsim.asr.inc"]])
  df[1, "Inc.65.asr"] <- mean(sim[["lc.last15y.asr.inc"]])
  df[1, "sd.Inc.65.asr"] <- sd(sim[["lc.last15y.asr.inc"]])
  
  df[1, "LCMort.Global.sim"] <- mean(sim[["lc.globalmort.inc"]])
  df[1, "sd.LCMort.Global.sim"] <- sd(sim[["lc.globalmort.inc"]])
  df[1, "LCMort.Global.crude"] <- mean(sim[["lc.globalmort.crude.inc"]])
  df[1, "sd.LCMort.Global.crude"] <- sd(sim[["lc.globalmort.crude.inc"]])
  df[1, "LCMort.Global.asr"] <- mean(sim[["lc.globalmort.asr.inc"]])
  df[1, "sd.LCMort.Global.asr"] <- sd(sim[["lc.globalmort.asr.inc"]])
  
  lc.deaths.origin <- rowMeans(sim[["lc.deaths.origin"]])
  df[1, "lc.deaths_1"] <- lc.deaths.origin[2]
  df[1, "lc.deaths_2"] <- lc.deaths.origin[3]
  df[1, "lc.deaths_3"] <- lc.deaths.origin[4]
  df[1, "lc.deaths.total"] <- mean(colSums(sim[["lc.deaths.origin"]]))
  df[1, "sd.lc.deaths.total"] <- sd(colSums(sim[["lc.deaths.origin"]]))
  
  scr.diag.stage <- rowMeans(sim[["scr.diag.state"]])
  df[1, "scr.diag.stage_1"] <- scr.diag.stage[2]
  df[1, "scr.diag.stage_2"] <- scr.diag.stage[3]
  df[1, "scr.diag.stage_3"] <- scr.diag.stage[4]
  df[1, "scr.diag.total"] <- mean(colSums(sim[["scr.diag.state"]]))
  df[1, "sd.scr.diag.total"] <- sd(colSums(sim[["scr.diag.state"]]))
  df[1, "screened.total"] <- mean(sim[["total.screens"]])
  df[1, "sd.screened.total"] <- sd(sim[["total.screens"]])
  
  
  # EXEC PARAMS
  df[1, "start.age"] <- kStartAge #warning
  df[1, "end.age"] <- kEndAge #warning
  df[1, "N"] <- N
  df[1, "periods.per.year"] <- kPeriods #warning
  df[1, "Nsim"] <- Nsim
  df[1, "Ncores"] <- n.cores
  
  # NH PARAMS
  df[1, "p_smoker"] <- interventions_p$p_smoker
  df[1, "rr_smoker"] <- interventions_p$rr_smoker
  df[1, "utility_1"] <- costs_p$utilities[2]
  df[1, "utility_2"] <- costs_p$utilities[3]
  df[1, "utility_3"] <- costs_p$utilities[4]
  df[1, "discount"] <- costs_p$discount.factor
  
  # QUITTING PARAMS
  df[1, "quit.type"] <- interventions_p$quitting_effect_type
  df[1, "quit.refyears"] <- interventions_p$quitting_ref_years
  df[1, "quit.riskred"] <- interventions_p$quitting_rr_after_ref_years
  
  # QUITTING INTS
  Nquit <- length(interventions_p$quitting_interventions)
  df[r, "Nquit.interventions"] <- Nquit
  if (Nquit > 0) {
    # QUIT 1
    df[1, "quit1.cov"] <- ifelse(is.null(interventions_p$quitting_interventions[[1]]$coverage), NA, interventions_p$quitting_interventions[[1]]$coverage)
    df[1, "quit1.eff"] <- ifelse(is.null(interventions_p$quitting_interventions[[1]]$success_rate), NA, interventions_p$quitting_interventions[[1]]$success_rate)
    df[1, "quit1.age"] <- ifelse(is.null(interventions_p$quitting_interventions[[1]]$interv_steps), NA, interventions_p$quitting_interventions[[1]]$interv_steps[1]/df[r, "periods.per.year"]+df[r, "start.age"])
    
    if (Nquit > 1) {
      # QUIT 2
      df[1, "quit2.cov"] <- interventions_p$quitting_interventions[[2]]$coverage
      df[1, "quit2.eff"] <- interventions_p$quitting_interventions[[2]]$success_rate
      df[1, "quit2.age"] <- interventions_p$quitting_interventions[[2]]$interv_steps[1]/df[r, "periods.per.year"]+df[r, "start.age"]
      
      if (Nquit > 2) {
        # QUIT 3
        df[1, "quit3.cov"] <- interventions_p$quitting_interventions[[3]]$coverage
        df[1, "quit3.eff"] <- interventions_p$quitting_interventions[[3]]$success_rate
        df[1, "quit3.age"] <- interventions_p$quitting_interventions[[3]]$interv_steps[1]/df[r, "periods.per.year"]+df[r, "start.age"]
        
        if (Nquit > 3) {
          # QUIT 4
          df[1, "quit4.cov"] <- interventions_p$quitting_interventions[[4]]$coverage
          df[1, "quit4.eff"] <- interventions_p$quitting_interventions[[4]]$success_rate
          df[1, "quit4.age"] <- interventions_p$quitting_interventions[[4]]$interv_steps[1]/df[r, "periods.per.year"]+df[r, "start.age"]
          
        } else {
          df[1, "quit4.cov"] <- df[r, "quit4.eff"] <- df[r, "quit4.age"] <- NA
        }
      } else {
        df[1, "quit3.cov"] <- df[r, "quit3.eff"] <- df[r, "quit3.age"] <- NA
        df[1, "quit4.cov"] <- df[r, "quit4.eff"] <- df[r, "quit4.age"] <- NA
      }
    } else {
      df[1, "quit2.cov"] <- df[r, "quit2.eff"] <- df[r, "quit2.age"] <- NA
      df[1, "quit3.cov"] <- df[r, "quit3.eff"] <- df[r, "quit3.age"] <- NA
      df[1, "quit4.cov"] <- df[r, "quit4.eff"] <- df[r, "quit4.age"] <- NA
    }
  } else {
    df[1, "quit1.cov"] <- df[r, "quit1.eff"] <- df[r, "quit1.age"] <- NA
    df[1, "quit2.cov"] <- df[r, "quit2.eff"] <- df[r, "quit2.age"] <- NA
    df[1, "quit3.cov"] <- df[r, "quit3.eff"] <- df[r, "quit3.age"] <- NA
    df[1, "quit4.cov"] <- df[r, "quit4.eff"] <- df[r, "quit4.age"] <- NA
  }
  
  
  # SCREEN PARAMS
  df[1, "screen.cov"] <- interventions_p$screening_coverage
  df[1, "screen.eff_1"] <- interventions_p$diag_screen[2]
  df[1, "screen.eff_2"] <- interventions_p$diag_screen[3]
  df[1, "screen.eff_3"] <- interventions_p$diag_screen[4]
  df[1, "screen.start.age"] <- interventions_p$screening_start_age
  df[1, "screen.end.age"] <- interventions_p$screening_end_age
  df[1, "screen.period"] <- interventions_p$screening_periodicity
  df[1, "screen.survival"] <- interventions_p$survival_after_scr_dx
  df[1, "cost.postdiag"] <- costs_p$postdx_treatment$i
  df[1, "cost.quit1"] <- costs_p$quitting.int$i #warning
  df[1, "cost.quit2"] <- costs_p$quitting.int$i #warning
  df[1, "cost.quit3"] <- costs_p$quitting.int$i #warning
  df[1, "cost.quit4"] <- costs_p$quitting.int$i #warning
  df[1, "cost.screen"] <- costs_p$screening$i #warning
  df[1, "spont.diag_1"] <- 0.182
  df[1, "spont.diag_2"] <- 0.401-0.182
  df[1, "spont.diag_3"] <- 0.934-0.401
  df[1, "time"] <- tstamp
  df[1, "seed"] <- seed
  
  write.xlsx(df, file=excel.filename, sheetName="execdata", row.names = FALSE)
  
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

#t1 <- Sys.time()
#cat(sprintf("\nExecution time: %10.2f secs\n\n", as.numeric(difftime(t1,t0,units="secs"))))

#cat("Stopping log\n")
#sink()
#sink(type="message")




