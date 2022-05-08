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

#zz <- file(logfilename, open="wt")
#sink(zz)
#sink(zz, type="message")

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

N = 100000
Nsim=1
# show.band <- TRUE
show.band <- FALSE
show.overall <- TRUE
# show.overall <- FALSE

source("PSA_parameters.R")

#si no inicialitzem aixo es queixa
cost=vector()
qaly=vector()
costni=vector()
qalyni=vector()
z=vector()
counter=0
ce=0
nce=0
for(par1 in params){
  counter=counter+1

  interventions_p=par1$interventions_p
  costs_p=par1$costs_p
  #options_p=par1$options_p
  #no entenc que passa amb els parametres



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


##cal???
## Random seed
#seed <- sample.int(.Machine$integer.max,1)
# cat("WARNING. Using preset seed.\n")
# seed <- 1966531022
#set.seed(seed)
#cat(sprintf("Using seed: %10d\n", seed))


################################################
# SIMULATION
##########

cat(      "\n***************************\n")
cat(        "*** STARTING SIMULATION ***\n")
cat(        "***************************\n")



    sim <- lc.simulate.cpp.multiple(tpm$tpm, tpm$tp.limits,
                                    interventions_p = interventions_p,
                                    costs_p = costs_p,
                                    options_p = options_p,
                                    # initial.healthy.population = N)
                                    initial.healthy.population = N,
                                    N.sim = Nsim)


    cat(      "\n**************************\n")
    cat(        "*** SIMULATION RESULTS ***\n")
    cat(        "**************************\n")

    #print(sim["nh"]) # TODO make it friendlier
    #descomentar linia dabaix per mes informacio
    #print(sim[names(sim)[2:9]]) # (TODO) Warning: if "costs" entry is removed, this has to be modified
    print(sim["costs_person"]) # TODO make it friendlier
    print(sim["costs_person_year"]) # TODO make it friendlier
    print(sim["qaly"])
    cost[counter]=sim$'costs_person'[3,1]
    qaly[counter]=sim$'qaly'

    cat(      "\n**********************************\n")
    cat(        "*** NO INTERVENTION SIMULATION ***\n")
    cat(        "**********************************\n")

    ##no intervention parameters


                  interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                                       diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),

                                       # no quitting nor screening
                                       screening_start_age=55, screening_end_age=55, screening_periodicity=12, screening_coverage=0.1869, screening_quitters_years=15, survival_after_scr_dx=.3714,
                                       quitting_interventions = list(list()), quitting_effect_type = 'logistic', quitting_ref_years = 15, quitting_rr_after_ref_years = .2, # reducció 80% als 15 anys


                                       p_smoker=0,
                                       rr_smoker=1

                  )
                  costs_p <- list(
                    screening=list(i=0),
                    quitting.int=list(i=0), # dummy
                    postdx_treatment=list(i=randpostdx[[counter]]),

                    #usual.care=list(md=c(0, 1,5,10,0.2,0,0)),

                    utilities=c(1,randutil1[[counter]],randutil2[[counter]],randutil3[[counter]],0,0,0),

                    discount.factor=0.03
                  )

                  options_p <- list(
                    smoker_inc_type = "current"
                  )


    # [END] parameters

      ## intervention parameters
    #interventions_p=list(diag_screen=c(0,scr_ef[[j]],scr_ef[[j]],scr_ef[[j]],0,0,0),
    #                     diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
    #
    #                     screening_start_age=55,
    #                     screening_end_age=55,
    #                     screening_periodicity=12*3,
    #                     screening_coverage=0.1869,
    #                     screening_quitters_years=15,
    #                     survival_after_scr_dx=.3714,
    #
    #                     p_smoker=.313,
    #                     rr_smoker=32.67,
    #
    #                     quitting_interventions = list(list(
    #                       coverage     = .1869,
    #                       success_rate = quit_ef[[j]],
    #                       #success_rate = .0994,
    #                       interv_steps = 1
    #                     ), list(
    #                       coverage     = .1869*(1-quit_ef[[j]]),
    #                       success_rate = quit_ef[[j]],
    #                       #coverage     = .1869*(1-.0994),
    #                       #success_rate = .0994,
    #                       interv_steps = 1+12*5
    #                     ), list(
    #                       coverage     = .1869*(1-quit_ef[[j]])*(1-quit_ef[[j]]),
    #                       success_rate = quit_ef[[j]],
    #                       #coverage     = .1869*(1-.0994)*(1-.0994),
    #                       #success_rate = .0994,
    #                       interv_steps = 1+12*10
    #                     )
    #                     ),
    #
    #
    #                     quitting_effect_type      = 'logistic',
    #                     quitting_ref_years        = 15,
    #                     quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
    #)
    #costs_p=costs_p <- list(
    #  # screening=list(i=0),
    #  screening=list(i=randscr[[j]]),
    #
    #  # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
    #
    #  # quitting.int=list(i=0), # dummy
    #  # quitting.int=list(i=26.84), # breu
    #  quitting.int=list(i=randquit[[j]]), # intensiva
    #
    #  # postdx_treatment=list(i=0),
    #  postdx_treatment=list(i=randpostdx[[j]]),
    #
    #  utilities=c(1,randutil1[[j]],randutil2[[j]],randutil3[[j]],0,0,0),
    #  discount.factor=0.03
    #)
    #options_p <- list(
    #  smoker_inc_type = "current"
    #)
    ##end parameters

    ##intervention 2 param
    #interventions_p=list(diag_screen=c(0,0,0,0,0,0,0),
    #                     diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
    #
    #                     screening_start_age=55,
    #                     screening_end_age=55,
    #                     screening_periodicity=12*3,
    #                     screening_coverage=0,
    #                     screening_quitters_years=15,
    #                     survival_after_scr_dx=.3714,
    #
    #                     p_smoker=.313,
    #                     rr_smoker=32.67,
    #
    #                     quitting_interventions = list(list(
    #                       coverage     = .1869,
    #                       success_rate = .2,
    #                       interv_steps = 1
    #                     ), list(
    #                        coverage     = .1869*(1-.2),
    #                        success_rate = .2,
    #                       interv_steps = 1+12*5
    #                     ), list(
    #                        coverage     = .1869*(1-.2)*(1-.2),
    #                        success_rate = .2,
    #                       interv_steps = 1+12*10
    #                     )
    #                     ),
    #
    #
    #                     quitting_effect_type      = 'logistic',
    #                     quitting_ref_years        = 15,
    #                     quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
    #)
    #costs_p=costs_p <- list(
    #  # screening=list(i=0),
    #  screening=list(i=175),
    #
    #  # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
    #
    #  # quitting.int=list(i=0), # dummy
    #  # quitting.int=list(i=26.84), # breu
    #  quitting.int=list(i=343.75), # intensiva
    #
    #  # postdx_treatment=list(i=0),
    #  postdx_treatment=list(i=14160.4),
    #
    #  utilities=c(1,.705,.655,.530,0,0,0),
    #  discount.factor=0.03
    #)

      cat(sprintf("N=%d\n", N))
      cat("\n*** Intervention parameters:\n")
      print(interventions_p)
      cat("\n*** Cost parameters:\n")
      print(costs_p)
      cat("\n*** Options parameters:\n")
      print(options_p)

    ####SIMULATION

    sim <- lc.simulate.cpp.multiple(tpm$tpm, tpm$tp.limits,
                                    interventions_p = interventions_p,
                                    costs_p = costs_p,
                                    options_p = options_p,
                                    # initial.healthy.population = N)
                                    initial.healthy.population = N,
                                    N.sim = Nsim)

    ##end simulation

    print(sim["costs_person"]) # TODO make it friendlier
    print(sim["costs_person_year"]) # TODO make it friendlier
    print(sim["qaly"])
    costni[counter]=sim$'costs_person'[3,1]
    qalyni[counter]=sim$'qaly'
    print(counter)
#    print(qaly)
#    print(qalyni)
#    print(cost)
#    print(costni)


    ##si l'icer es menor a 25000 o es cost saving l'estraegia es cost-efectiva
    icer=(cost[counter]-costni[counter])/(qaly[counter]-qalyni[counter])
    if(icer<=25000 && (qaly[counter]-qalyni[counter])>=0){
      ce=ce+1
      z[counter]=1
    }else{
      nce=nce+1
      z[counter]=2
    }

    cat("\n")

}
###########
## END FOR
###########

#icer=(cost-costni)/(qaly-qalyni)
print(abs(icer))
#print(icer)
cat("qaly no int\n")
cat(paste0(mean(qalyni)))
cat("\n cost no int\n")
cat(paste0(mean(costni)))
cat("\n qaly int\n")
cat(paste0(mean(qaly)))
cat("\n cost int\n")
cat(paste0(mean(cost)))
cat("\n proportion times is cost effective\n")
cat(paste0(ce/(ce+nce)))

library('scales') #llibreria per percentatges

##################################
######grafica analisi sensibilitat
##################################

x=qaly-qalyni
y=cost-costni
#plot(x,y,col=c("green","red")[z],ylim=c(0,80),cex=.4, pch=3, xlab="incremental QALY", ylab="incremental cost")
plot(x,y,col=c("green","red")[z],xlim=c(-0.1,0.1), ylim=c(-300,500),cex=.4, pch=3, xlab="incremental QALY", ylab="incremental cost")
##title(main="quit_cost->lognormal:\n E=343.75, sd=343.75", cex.main=0.6)
abline(1,25000,col=2)
abline(0,1,col=1)
abline(v=0,col=2)
per=percent(ce/(ce+nce))
text(0.09,450,per, cex=0.8)
#text(0.05,-50,"postdx_cost->lognormal",cex=0.6)
#text(0.05,-75,"E=14160.4, sd=14160.4*0.15",cex=0.6)
#text(-0.07,-250,"scr_cost->lognormal",cex=0.6)
#text(-0.07,-275,"E=175, sd=175*0.75",cex=0.6)
#text(-0.08,-250,"quit_cost->gamma",cex=0.6)
#text(-0.08,-275,"E=343.75, sd=343.75",cex=0.6)
text(-0.08,-250,"move all param; costs->gamma",cex=0.6)
#text(-0.08,-250,"quit_ef->beta",cex=0.6)





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

#cat("Stopping log\n")
#sink()
#sink(type="message")



