################################################
# INCLUDE SECTION. LOAD LIBRARIES, CODE
##########

#setwd("S:/grups/MODELING/Lung_AECC_Gerard/3_ModelAECC_Gerard/ModelLC/Git_LC")
setwd("/mnt/atlas/projects/2019_DG_PREC_Lung_CE/ModelLC/Git_LC")

# Simulation basics
source("constantDefinition.R")
source("lcSimulCpp.R")
source("lcInterventionsUtils.R")

# Data load and manip
source("loadTPMatrixFromFile.R")

# Parallel support
library(doMPI)
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
ma <- readRDS('matriu')
#ttstamp <- format(tt0, "%Y%m%d_%H%M%S")
#
#logfilename <- paste0("results/logs/exec_", ttstamp, ".log")
#zz <- file(logfilename, open="wt")
#sink(zz)
#sink(zz, type="message")

## CLUSTER SETUP

args <- commandArgs(trailingOnly=TRUE)
if (length(args)==0) {
  n.cores <- 8
} else {
  n.cores <- as.numeric(args[1])
}

cl <- startMPIcluster(n.cores)
registerDoMPI(cl)
cat("Cluster initialized\n\n")
## [END] cluster setup



## DATA LOAD
transition.matrix.filename <- "Remarkable TP matrices/tp_dan20.xls"

cat("Loading matrix from file:")
cat(transition.matrix.filename)
cat("\n")
tpm=list()
tpm[[1]] <- LoadTPMatrixFromFile(transition.matrix.filename)
for(j in 2:50){
  tpm[[j]]=tpm[[1]]
}



##canviem a la matriu calibrada
for(k in 1:50){
  x=ma[[k*2]]
  conIni=c(x[[1]][1,2],x[[1]][1,6],x[[1]][2,3],x[[1]][2,4],x[[1]][2,5],x[[1]][2,6],x[[1]][3,4],x[[1]][3,5],x[[1]][3,6],x[[1]][4,5],x[[1]][4,6])
  #conIni=c(conIni, 8.66004e-06,x[[2]][1,6],x[[2]][2,3],x[[2]][2,4],x[[2]][2,5],x[[2]][2,6],x[[2]][3,4],x[[2]][3,5],x[[2]][3,6],x[[2]][4,5],x[[2]][4,6])
  
  for(q in 2:9){
    conIni=c(conIni,x[[q]][1,2],x[[q]][1,6],x[[q]][2,3],x[[q]][2,4],x[[q]][2,5],x[[q]][2,6],x[[q]][3,4],x[[q]][3,5],x[[q]][3,6],x[[q]][4,5],x[[q]][4,6])
  }
  
  par=conIni
  a=vector()
  b=vector()
  c=vector()
  d=vector()
  e=vector()
  f=vector()
  g=vector()
  h=vector()
  l=vector()
  m=vector()
  n=vector()
  count=0
  for(q in 1:9){
    a[q]=par[11*count+1] 
    b[q]=par[11*count+2]
    c[q]=par[11*count+3]
    d[q]=par[11*count+4]
    e[q]=par[11*count+5]
    f[q]=par[11*count+6]
    g[q]=par[11*count+7] 
    h[q]=par[11*count+8] 
    l[q]=par[11*count+9]
    m[q]=par[11*count+10]
    n[q]=par[11*count+11]
    count=count+1
  }
  x2=list()
  x3=list()
  for(q in 1:9){
    x2[[q]]=c(1-a[q]-b[q],a[q],0,0,0,b[q],0,1-c[q]-d[q]-e[q]-f[q],c[q],d[q],e[q],f[q],0,0,1-g[q]-h[q]-l[q],g[q],h[q],l[q],0,0,0,1-m[q]-n[q],m[q],n[q],0,0,0,0,1,0,0,0,0,0,0,1)
    x3[[q]]=matrix(x2[[q]],nrow=6,ncol=6,byrow=T)
  }
  
  #35-39
  for(i in 1:4){
    for(j in 1:4){
      tpm[[k]]$`tpm`$`35-39`[i,j]=x3[[1]][i,j]
    }
  }
  for(i in 1:4){
    for(j in 6:7){
      tpm[[k]]$`tpm`$`35-39`[i,j]=x3[[1]][i,j-1]
    }
  }
  #40-44
  for(i in 1:4){
    for(j in 1:4){
      tpm[[k]]$`tpm`$`40-44`[i,j]=x3[[2]][i,j]
    }
  }
  for(i in 1:4){
    for(j in 6:7){
      tpm[[k]]$`tpm`$`40-44`[i,j]=x3[[2]][i,j-1]
    }
  }
  #45-49
  for(i in 1:4){
    for(j in 1:4){
      tpm[[k]]$`tpm`$`45-49`[i,j]=x3[[3]][i,j]
    }
  }
  for(i in 1:4){
    for(j in 6:7){
      tpm[[k]]$`tpm`$`45-49`[i,j]=x3[[3]][i,j-1]
    }
  }
  #50-54
  for(i in 1:4){
    for(j in 1:4){
      tpm[[k]]$`tpm`$`50-54`[i,j]=x3[[4]][i,j]
    }
  }
  for(i in 1:4){
    for(j in 6:7){
      tpm[[k]]$`tpm`$`50-54`[i,j]=x3[[4]][i,j-1]
    }
  }
  #55-59
  for(i in 1:4){
    for(j in 1:4){
      tpm[[k]]$`tpm`$`55-59`[i,j]=x3[[5]][i,j]
    }
  }
  for(i in 1:4){
    for(j in 6:7){
      tpm[[k]]$`tpm`$`55-59`[i,j]=x3[[5]][i,j-1]
    }
  }
  #60-64
  for(i in 1:4){
    for(j in 1:4){
      tpm[[k]]$`tpm`$`60-64`[i,j]=x3[[6]][i,j]
    }
  }
  for(i in 1:4){
    for(j in 6:7){
      tpm[[k]]$`tpm`$`60-64`[i,j]=x3[[6]][i,j-1]
    }
  }
  #65-69
  for(i in 1:4){
    for(j in 1:4){
      tpm[[k]]$`tpm`$`65-69`[i,j]=x3[[7]][i,j]
    }
  }
  for(i in 1:4){
    for(j in 6:7){
      tpm[[k]]$`tpm`$`65-69`[i,j]=x3[[7]][i,j-1]
    }
  }
  #70-74
  for(i in 1:4){
    for(j in 1:4){
      tpm[[k]]$`tpm`$`70-74`[i,j]=x3[[8]][i,j]
    }
  }
  for(i in 1:4){
    for(j in 6:7){
      tpm[[k]]$`tpm`$`70-74`[i,j]=x3[[8]][i,j-1]
    }
  }
  #75-79
  for(i in 1:4){
    for(j in 1:4){
      tpm[[k]]$`tpm`$`75-79`[i,j]=x3[[9]][i,j]
    }
  }
  for(i in 1:4){
    for(j in 6:7){
      tpm[[k]]$`tpm`$`75-79`[i,j]=x3[[9]][i,j-1]
    }
  }
}
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

source("params_dones_scrcov91.R")

################################################
# EL FOR
##########

sim.counter <- 1
for (param in ALL.PARAMETERS) {
  simu=list()
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
  # seed <- 92314534
  # set.seed(seed)
  cat(sprintf("Using seed: %10d\n", seed))
  
  # go!
  
  # sim <- lc.simulate.cpp(tpm[[k]]$tpm, tpm[[k]]$tp.limits,
  
  # tryCatch({
  
  #'lc.simulate.cpp'
  #simulem les 50 matrius
  simu <- foreach(j=1:50, 
                  .packages=c('doRNG', 'itertools'),
                  .export = c('ma', 'lc.simulate.cpp', 'lc_simulate_cpp',
                              'kStartAge', 'kEndAge', 'kPeriods', 'kHealthy',
                              'kDefaultGroupLength',
                              'kOptionsDefaultIncidence',
                              'GetAllInterventionsParameters',
                              'kInterventionsDefaultParameters',
                              'age.weights')) %dopar% {
                                res <-lc.simulate.cpp.multiple(tpm[[j]]$tpm, tpm[[j]]$tp.limits,
                                                               interventions_p = interventions_p,
                                                               costs_p = costs_p, 
                                                               options_p = options_p, 
                                                               # initial.healthy.population = N)
                                                               initial.healthy.population = N,
                                                               N.sim = Nsim,
                                                               parallel.exec = TRUE)
                                
                                return(res)                             
                              }
  sim=list()
  #sim <- unlist(lapply(results, simu))
  for(c in 1:50){
    sim=c(sim,simu[[c]])
  }
  
  cat("Saving...")
  source("saver_scrcov91.R")
  cat(" OK!\t\t")
  #sim.counter <- sim.counter+1
  
  # }
  # , error=function(e) cat("Exception. Skipping.\n"))
  
  
  t1 <- Sys.time()
  cat(sprintf("\nExecution time: %10.2f secs\n\n", as.numeric(difftime(t1,t0,units="secs"))))
  
  sim.counter <- sim.counter+1
  
  
}


################################################
# CLEANING UP
##########

cat(      "\n*******************\n")
cat(        "*** CLEANING UP ***\n")
cat(        "*******************\n")

cat("Stopping cluster\n")
# stopCluster(cl)
# registerDoSEQ()
closeCluster(cl)
cat("Done\n")

t1 <- Sys.time()
cat(sprintf("\nExecution time: %10.2f secs\n\n", as.numeric(difftime(t1,t0,units="secs"))))

cat("Stopping log\n")
# sink()
#sink(type="message")


