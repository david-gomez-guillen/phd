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

conIni=c(x[[1]][1,2],x[[1]][1,6],x[[1]][2,3],x[[1]][2,4],x[[1]][2,5],x[[1]][2,6],x[[1]][3,4],x[[1]][3,5],x[[1]][3,6],x[[1]][4,5],x[[1]][4,6])
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


# Càrrega temporal de mortalitats TODO 
real.mort <- list(
  #lc.incidence = c(1.6,11.8,39.6,91.9,170.4,258.3,340.2,407.8,432.7), # MEN
  lc.incidence = c(1.3,10.5,21.0,34.4,44.2,47.8,48.0,50.1,56.8), # WOMEN
  #lc.mortality = c(1,5.8,28.3,64.9,121.7,187.4,255.8,328.1,400.6), # MEN
  lc.mortality = c(0.9,7.8,14.2,22.7,29.6,32.4,33.6,37.4,50.3), # WOMEN
  #tot.mortality = c( 0.703794,
  #                   1.154704,
  #                   2.179599,
  #                   3.976368,
  #                   6.479547,
  #                   9.839768,
  #                   14.806531,
  #                   22.589549,
  #                   38.978694
  #)*100 # taxes x1000     # MEN
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
interventions_p=list(diag_screen=c(0,0,0,0,0,0,0),
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
wl <- list("NM", c(.45,.45,.1))
tp.pre <- tpm$tpm
p.post.i <- SingleRun(tp.pre, wl, "Nelder-Mead", calib.p = calib.p, dist.age.groups = 1:9)


# Calib 2: NM from previous, weighted 49/49/2
wl <- list("NM", c(.45, .45, .1))
tp.pre <- tp.post.sa
tp.post.1 <- SingleRun(tp.pre, wl, "Nelder-Mead", calib.p = calib.p, dist.age.groups = 1:9)

# Calib 3: NM from previous, weighted 49/49/2
wl <- list("NM", c(.45, .45, .1))
tp.pre <- tp.post.1
tp.post.2 <- SingleRun(tp.pre, wl, "Nelder-Mead", calib.p = calib.p, dist.age.groups = 1:9)




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

