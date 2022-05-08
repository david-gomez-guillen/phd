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
#####canviem matriu nomes pel grup 1
####################
#dan_20
#conIni=c(1.46958E-05, 0.000856976, 0.47858908,	0.23417185, 0.010939932,	0.092374901,	0.251344813, 0.284421879,	0.017834855, 0.117218696, 0.014050839)

#calibrated
#conIni=c(1.483763e-06, 5.871826e-05, 3.529424e-02, 4.895493e-01, 6.348008e-04, 3.463657e-03, 5.634374e-02, 2.230856e-02, 1.872059e-10, 3.824475e-02, 1.044427e-03)  #homes
#conIni=c(1.443825e-06, 3.152918e-05, 5.516848e-10, 3.688193e-01, 5.650067e-02, 3.347752e-02, 8.819412e-02, 6.095164e-02, 9.458778e-02, 3.667816e-02, 9.372485e-03)  #dones
#
#
#
#par1=conIni
#a=par1[1] 
#b=par1[2]
#c=par1[3]
#d=par1[4]
#e=par1[5]
#f=par1[6]
#g=par1[7] 
#h=par1[8] 
#l=par1[9]
#m=par1[10]
#n=par1[11]
#x2=c(1-a-b,a,0,0,0,b,0,1-c-d-e-f,c,d,e,f,0,0,1-g-h-l,g,h,l,0,0,0,1-m-n,m,n,0,0,0,0,1,0,0,0,0,0,0,1)
#x3=matrix(x2,nrow=6,ncol=6,byrow=T)
#
#for(i in 1:4){
#  for(j in 1:4){
#            tpm$`tpm`$`35-39`[i,j]=x3[i,j]
#  }
#}
#for(i in 1:4){
#  for(j in 6:7){
#    tpm$`tpm`$`35-39`[i,j]=x3[i,j-1]
#  }
#}
#tp=tpm$`tpm`$`35-39`
#
########################
##### matriu canviada
#######################


#####################
#####canviem matriu per tots els grups d'edat
####################

#calibrated

#conIni=c(1.065588e-06, 0.0000317413, 0.04547468, 0.41169537
#         , 0.07632464
#         , 0.0048944236
#         , 0.04243969
#         , 0.03068166
#         , 0.0020759803
#         , 0.05549875
#         , 0.0002395621,8.701624e-06, 5.887953e-05, 0.02438962, 0.47127692, 0.14802879,
#         2.688046e-03, 0.08094565, 0.02302177, 7.075728e-03, 0.04813547, 1.184806e-04,1.729557e-05, 1.006201e-04, 0.03140043, 0.44675792, 0.11320735, 2.930460e-05, 
#         0.02231006, 0.05523594, 2.395068e-04, 0.02594896, 4.269342e-07,2.833578e-05, 1.522946e-04, 0.2169975, 0.7456870, 0.03193589, 2.491273e-06,
#         0.2587072, 0.03335300, 5.851947e-03, 0.06872565,  4.952168e-02, 3.653356e-05, 0.0002521281, 0.531670029, 0.4238287, 0.00117613, 0.0009220933, 
#         0.9664381, 0.01536178, 0.0125145335, 0.04191489, 0.0046873273,0.0000392827, 0.0003320690, 0.0148729402, 0.9452883, 0.02702065, 0.0077820142, 
#         0.9459558, 0.05228824, 0.0008839752, 0.03539725, 0.0167845783,4.502399e-05, 4.962560e-04, 0.59549010, 0.05440848, 0.00718508, 3.074102e-06, 
#         0.87277627, 0.03546284, 4.190248e-02, 0.03165383, 1.325678e-02,8.622778e-05, 0.0284376166, 0.1762208, 0.38693820, 0.07615560, 0.0003164516,
#         0.06145815, 0.01298584, 0.0098327767, 0.04016585, 0.0316407017,0.0001868193, 0.064480229, 0.02342019, 0.4211509, 0.004104144, 0.006149856, 
#         0.6806196, 0.010045825, 0.040818522, 0.019103444, 0.010574882)

#conIni=c(x[[1]][1,2],x[[1]][1,6],x[[1]][2,3],x[[1]][2,4],x[[1]][2,5],x[[1]][2,6],x[[1]][3,4],x[[1]][3,5],x[[1]][3,6],x[[1]][4,5],x[[1]][4,6])
#for(q in 2:9){
#  conIni=c(conIni,x[[q]][1,2],x[[q]][1,6],x[[q]][2,3],x[[q]][2,4],x[[q]][2,5],x[[q]][2,6],x[[q]][3,4],x[[q]][3,5],x[[q]][3,6],x[[q]][4,5],x[[q]][4,6])
#}

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


cat(      "\n***************************\n")
cat(        "*** RUNNING PARAMETERS: ***\n")
cat(        "***************************\n")
cat("\n")

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



cat(      "\n**************************\n")
cat(        "*** SIMULATION RESULTS ***\n")
cat(        "**************************\n")

#print(sim["nh"]) # TODO make it friendlier
print(sim[names(sim)[2:9]]) # (TODO) Warning: if "costs" entry is removed, this has to be modified
print(sim["costs_person"]) # TODO make it friendlier
print(sim["costs_person_year"]) # TODO make it friendlier
print(sim["qaly"])

lc.incidence=rowMeans(sim$lc.incidence)
lc.mortality=rowMeans(sim$lc.mortality)
tot.mortality=rowMeans(sim$tot.mortality)


real.inc = c(1.3,10.5,21.0,34.4,44.2,47.8,48.0,50.1,56.8) # WOMEN
real.lcmort= c(0.9,7.8,14.2,22.7,29.6,32.4,33.6,37.4,50.3)
real.othermort = c( 0.380972, 0.694827, 1.202252, 1.960304, 3.035235, 4.089336, 6.007853, 10.002099, 19.884787)*100

di1=sum(0.49*abs(lc.incidence-real.inc)/real.inc+0.49*abs(lc.mortality-real.lcmort)/real.lcmort+0.02*abs(tot.mortality-real.othermort)/real.othermort) #dones
#d=0.49*abs(lc.incidence[1]-1.6)/1.6+0.49*abs(lc.mortality[1]-1)+0.02*abs(tot.mortality[1]-70.3794)/70.3794 #homes
#di=0.49*abs(lc.incidence[1]-1.3)/1.3+0.49*abs(lc.mortality[1]-0.9)/0.9+0.02*abs(tot.mortality[1]-38.0972)/38.0972 #dones
cat("\n")


##### plot
y=1:9
names(y)=c("35-39","40-44","45-49","50-54","55-59","60-64","65-69","70-74","75-79")
par(mfrow=c(1,3))
plot(y,lc.incidence,"o",col="red", xlab="age group", ylab="incidence")
lines(y,real.inc,"o",col="blue")#, xlab="age group", ylab="incidence")

plot(y,lc.mortality,"o",col="red", xlab="age group", ylab="lc.mortality")
lines(y,real.lcmort,"o",col="blue")#, xlab="age group", ylab="incidence")

plot(y,tot.mortality,"o",col="red", xlab="age group", ylab="tot.mortality")
lines(y,real.othermort,"o",col="blue")#, xlab="age group", ylab="incidence")


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


