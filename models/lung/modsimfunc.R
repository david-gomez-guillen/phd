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

modsim=function(x){

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


#cat(      "\n***************************\n")
#cat(        "*** RUNNING PARAMETERS: ***\n")
#cat(        "***************************\n")
#cat("\n")
#
#cat(sprintf("N=%d\n", N))
#cat("\n*** Intervention parameters:\n")
#print(interventions_p)
#cat("\n*** Cost parameters:\n")
#print(costs_p)
#cat("\n*** Options parameters:\n")
#print(options_p)





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



#cat(      "\n**************************\n")
#cat(        "*** SIMULATION RESULTS ***\n")
#cat(        "**************************\n")

#print(sim["nh"]) # TODO make it friendlier
#print(sim[names(sim)[2:9]]) # (TODO) Warning: if "costs" entry is removed, this has to be modified
#print(sim["costs_person"]) # TODO make it friendlier
#print(sim["costs_person_year"]) # TODO make it friendlier
#print(sim["qaly"])

lc.incidence=rowMeans(sim$lc.incidence)
lc.mortality=rowMeans(sim$lc.mortality)
tot.mortality=rowMeans(sim$tot.mortality)
qaly=sim$qaly
cost=sim$costs_person[3,1]

ret=list()
ret$inc=lc.incidence
ret$lcm=lc.mortality
ret$om=tot.mortality
ret$qaly=sim$qaly
ret$cost=sim$costs_person[3,1]

return(ret)
}

##### plot
#y=1:9
#names(y)=c("35-39","40-44","45-49","50-54","55-59","60-64","65-69","70-74","75-79")
#par(mfrow=c(1,3))
#plot(y,lc.incidence,"o",col="red", xlab="age group", ylab="incidence")
#lines(y,real.inc,"o",col="blue")#, xlab="age group", ylab="incidence")
#
#plot(y,lc.mortality,"o",col="red", xlab="age group", ylab="lc.mortality")
#lines(y,real.lcmort,"o",col="blue")#, xlab="age group", ylab="incidence")
#
#plot(y,tot.mortality,"o",col="red", xlab="age group", ylab="tot.mortality")
#lines(y,real.othermort,"o",col="blue")#, xlab="age group", ylab="incidence")


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


