library(lcsimul.dev)

force(kStartAge)
force(kEndAge)
force(kPeriods)
force(kHealthy)
force(age.weights)


##funcio en R que crida la funcio en cpp que executa el model.

lc.simulate.cpp <- function(
  tp, tp.limits,
  start.age = kStartAge, end.age = kEndAge, periods.per.year = kPeriods,
  initial.healthy.population = kHealthy,
  interventions_p = list(),
  options_p = list(),
  costs_p = list(),
  lib = 'dev') {

  force(tp)
  force(tp.limits)
  force(interventions_p)
  N.states <- dim(tp[[1]])[1]
  
  if (is.null(options_p$incidence)) options_p$incidence <- kOptionsDefaultIncidence

  # Es permet escollir la llibreria antiga (abans de la implementació de les intervencions)
  if (lib == 'old') {
    sim.results <- lcsimul::lc_simulate_cpp(tps = tp,
                                            tp_limits = tp.limits,
                                            start_age = start.age,
                                            end_age = end.age,
                                            periods_per_year = periods.per.year,
                                            N_states = N.states,
                                            initial_healthy_population = initial.healthy.population,
                                            incidence_from_states = kOptionsDefaultIncidence$from,
                                            incidence_to_states = kOptionsDefaultIncidence$to)
  } else {
    sim.results <- lc_simulate_cpp(tps = tp,
                                   tp_limits = tp.limits,
                                   start_age = start.age,
                                   end_age = end.age,
                                   periods_per_year = periods.per.year,
                                   N_states = N.states,
                                   initial_healthy_population = initial.healthy.population,
                                   interventions_p = GetAllInterventionsParameters(interventions_p),
                                   options_p = options_p,
                                   costs_p = costs_p) 
  }
  
  ret <- list()
  ret$nh <-  sim.results[["nh"]]

  year.starting.periods <- (0:(end.age-start.age))*periods.per.year+1

  # funcio per transformar les dades generals incidencia/mortalitat en dades per any i grup d'edat
  
  SummarizeYearlyPerGroup <- function(monthly.diff.data, monthly.alive, mult.factor) {
    # Group calculations generalized
    g.len <- kDefaultGroupLength
    a <- if(start.age %% g.len == 0) start.age else (start.age%/%g.len)*g.len + g.len
    b <- if(end.age %% g.len == 0)   end.age   else (end.age%/%g.len)*g.len
    left  <- if(start.age %% g.len == 0) integer() else rep.int(start.age, (a-start.age)*periods.per.year)
    mid   <- rep(seq(a,b-1,g.len), each=g.len*periods.per.year)
    right <- if(end.age %% g.len == 0)   integer() else rep.int(b, (end.age-b)*periods.per.year)
    corresponding.age.group <- c(left, mid, right)
    n.age.groups.present <- length(unique(corresponding.age.group))
    
    monthly.data.split.by.group  <- split(monthly.diff.data, corresponding.age.group)
    monthly.alive.split.by.group <- split(monthly.alive, corresponding.age.group)
    monthly.ratio.by.group <- sapply(1:n.age.groups.present,
                             function(i) {
                               sum(monthly.data.split.by.group[[i]])/
                                 sum(monthly.alive.split.by.group[[i]])
                             })
    return (mult.factor*periods.per.year*monthly.ratio.by.group)
  }
  
  alive.pop.monthly <- rowSums(ret$nh[,1:(N.states-2)])[-nrow(ret$nh)]

  ret$lc.incidence   <- SummarizeYearlyPerGroup(sim.results[["incidence"]], alive.pop.monthly, 1e5)
  ret$lc.inc.smokers <- SummarizeYearlyPerGroup(sim.results[["incidence_smokers"]], alive.pop.monthly, 1e5)
  ret$lc.inc.non.smokers <- SummarizeYearlyPerGroup(sim.results[["incidence"]] - sim.results[["incidence_smokers"]], alive.pop.monthly, 1e5)
  ret$lc.mortality   <- SummarizeYearlyPerGroup(diff(ret$nh[,N.states-1]), alive.pop.monthly, 1e5)
  ret$tot.mortality  <- SummarizeYearlyPerGroup(diff(ret$nh[,N.states-1])+diff(ret$nh[,N.states]), alive.pop.monthly, 1e5)
  
  ret$lc.globalsim.inc  <- sum(sim.results[["incidence"]])/sum(alive.pop.monthly)*periods.per.year*1e5
  l <- length(alive.pop.monthly)
  ret$lc.last15y.inc  <- sum(sim.results[["incidence"]][(l-180+1):l])/sum(alive.pop.monthly[(l-180+1):l])*periods.per.year*1e5
  
  ret$lc.globalsim.crude.inc <- sum(ret$lc.incidence*age.weights$crude)
  ret$lc.globalsim.asr.inc <- sum(ret$lc.incidence*age.weights$standard)
  
  n.age.groups <- 9 # TODO WARNING
  ret$lc.last15y.crude.inc <- sum((ret$lc.incidence*age.weights$crude)[(n.age.groups-2):n.age.groups])/sum(age.weights$crude[(n.age.groups-2):n.age.groups])
  ret$lc.last15y.asr.inc <- sum((ret$lc.incidence*age.weights$standard)[(n.age.groups-2):n.age.groups])/sum(age.weights$standard[(n.age.groups-2):n.age.groups])
  
  ret$lc.globalmort.inc <- sum(diff(ret$nh[,N.states-1]))/sum(alive.pop.monthly)*periods.per.year*1e5
  ret$lc.globalmort.crude.inc <- sum(ret$lc.mortality*age.weights$crude)
  ret$lc.globalmort.asr.inc <- sum(ret$lc.mortality*age.weights$standard)
  
  ret$lc.deaths.origin <- sim.results[["lc_deaths"]]
  ret$scr.diag.state <- sim.results[["scr_diagnosis_state"]]
  ret$total.screens <- sim.results[["screened_total"]]
  
  # Definició de funció genèrica per obtenir resums per grup
  SummarizePerGroup <- function(monthly.data) {
    # Group calculations generalized
    g.len <- kDefaultGroupLength
    a <- if(start.age %% g.len == 0) start.age else (start.age%/%g.len)*g.len + g.len
    b <- if(end.age %% g.len == 0)   end.age   else (end.age%/%g.len)*g.len
    left  <- if(start.age %% g.len == 0) integer() else rep.int(start.age, (a-start.age)*periods.per.year)
    mid   <- rep(seq(a,b-1,g.len), each=g.len*periods.per.year)
    right <- if(end.age %% g.len == 0)   integer() else rep.int(b, (end.age-b)*periods.per.year)
    corresponding.age.group <- c(left, mid, right)
    n.age.groups.present <- length(unique(corresponding.age.group))
    
    monthly.data.split.by.group  <- split(monthly.data, corresponding.age.group)
    return(sapply(monthly.data.split.by.group, sum))
  }
  
  # TODO provisional
  ret$scr.diag <- sim.results[["screening_diagnosed"]]
  ret$spo.diag <- SummarizePerGroup(sim.results[["spontaneous_diagnosed"]])
  ret$mpst <- sim.results[["mpst"]]
  ret$costs <- sim.results[["costs"]]
  
  # pato<<- sim.results[["costs_m"]]
  
  # COSTS_M
  discount.vector <- 1/(1+costs_p$discount.factor)^(0:(end.age-start.age-1))
  ret$costs_m <- list(list(md= as.vector(discount.vector%*%sim.results[["costs_m"]][[1]]),
                           nmd=as.vector(discount.vector%*%sim.results[["costs_m"]][[2]]),
                           i=  as.vector(discount.vector%*%sim.results[["costs_m"]][[3]])))
  ret$costs_person <- c(mean(ret$costs_m[[1]]$md),mean(ret$costs_m[[1]]$nmd),mean(ret$costs_m[[1]]$i))
  names(ret$costs_person) <- c("md", "nmd", "i")
  ret$costs_person_year <- ret$costs_person/(end.age-start.age)
  
  ret$undisc_costs <- list(list(md= as.vector(rep(1,end.age-start.age)%*%sim.results[["costs_m"]][[1]]),
                                nmd=as.vector(rep(1,end.age-start.age)%*%sim.results[["costs_m"]][[2]]),
                                i=  as.vector(rep(1,end.age-start.age)%*%sim.results[["costs_m"]][[3]])))
  ret$undisc_costs_person <- c(mean(ret$undisc_costs[[1]]$md),mean(ret$undisc_costs[[1]]$nmd),mean(ret$undisc_costs[[1]]$i))
  names(ret$undisc_costs_person) <- c("md", "nmd", "i")
  
  #ret$costs_m <- list(sim.results[["costs_m"]])
  #names(ret$costs_m[[1]]) <- c("md", "nmd", "i")

  # QALY value
  discount.vector <- rep(1/(1+costs_p$discount.factor)^(0:(end.age-start.age-1)), each=periods.per.year)
  ret$qaly <- discount.vector%*%(sim.results[["nh"]]%*%costs_p$utilities)[-1]/(periods.per.year*initial.healthy.population)
  ret$undisc_qaly <- sum((sim.results[["nh"]]%*%costs_p$utilities)[-1]/(periods.per.year*initial.healthy.population))
  
  return(ret)
}

## fa servir la funcio lc.simulate.cpp, l'unic que fa �s paralelitzarla

lc.simulate.cpp.multiple <- function(
  tp, tp.limits,
  start.age = kStartAge, end.age = kEndAge, periods.per.year = kPeriods,
  initial.healthy.population = kHealthy,
  N.sim = 5,
  lib = 'dev',
  interventions_p = list(),
  options_p = list(),
  costs_p = list(),
  parallel.exec = TRUE) {

  if (parallel.exec) {
    n.chunks <- getDoParWorkers()
  } else {
    n.chunks <- 1
  }

  return(foreach(I=isplitVector(1:N.sim,chunks=n.chunks),
                 .packages = "Matrix",
                 # Define combine function (generalitzat per si s'afegeixen nous atributs)
                 .combine = function(...) {
                   combined <- list(nh=list(),
                                    lc.incidence=double(),
                                    lc.inc.smokers=double(),
                                    lc.inc.non.smokers=double(),
                                    lc.mortality=double(),
                                    tot.mortality=double(),
                                    lc.globalsim.inc=double(),
                                    lc.last15y.inc=double(),
                                    lc.globalsim.crude.inc=double(),
                                    lc.last15y.crude.inc=double(),
                                    lc.globalsim.asr.inc=double(),
                                    lc.last15y.asr.inc=double(),
                                    lc.globalmort.inc=double(),
                                    lc.globalmort.crude.inc=double(),
                                    lc.globalmort.asr.inc=double(),
                                    lc.deaths.origin=integer(),
                                    scr.diag.state=integer(),
                                    total.screens=integer(),
                                    scr.diag=integer(),
                                    spo.diag=integer(),
                                    mpst=double(),
                                    costs=double(),
                                    costs_m=list(),
                                    costs_person=double(),
                                    costs_person_year=double(),
                                    undisc_costs=list(),
                                    undisc_costs_person=double(),
                                    qaly=double(),
                                    undisc_qaly=double())
                   nam <- names(combined)
                   
                   for (x in list(...)) {
                     for (att in nam) {
                       if (is.list(combined[[att]])) {
                         combined[[att]] <- c(combined[[att]], x[[att]])
                       } else if (length(x[[att]]) > 0) {
                         combined[[att]] <- cbind(combined[[att]], x[[att]])
                       }
                     }
                   }
                   return(combined)
                 },
                 # Needed to combine more than one item at a time
                 .multicombine = TRUE) %dorng% {

    # zz <- file(paste0("results/logs/exec_pid_",Sys.getpid(),"_", as.integer(Sys.time())%%1e7,".log"), open="wt")
    # sink(zz)
    # sink(zz, type="message")
    
    # node.res contains *this* node results
    node.res <- list(nh=list(),
                     lc.incidence=double(),
                     lc.inc.smokers=double(),
                     lc.inc.non.smokers=double(),
                     lc.mortality=double(),
                     tot.mortality=double(),
                     lc.globalsim.inc=double(),
                     lc.last15y.inc=double(),
                     lc.globalsim.crude.inc=double(),
                     lc.last15y.crude.inc=double(),
                     lc.globalsim.asr.inc=double(),
                     lc.last15y.asr.inc=double(),
                     lc.globalmort.inc=double(),
                     lc.globalmort.crude.inc=double(),
                     lc.globalmort.asr.inc=double(),
                     lc.deaths.origin=integer(),
                     scr.diag.state=integer(),
                     total.screens=integer(),
                     scr.diag=integer(),
                     spo.diag=integer(),
                     mpst=double(),
                     costs=double(),
                     costs_m=list(),
                     costs_person=double(),
                     costs_person_year=double(),
                     undisc_costs=list(),
                     undisc_costs_person=double(),
                     qaly=double(),
                     undisc_qaly=double())
    for(i in 1:length(I)) {
      aux <- lc.simulate.cpp(tp=tp, tp.limits=tp.limits,
                             start.age=start.age, end.age=end.age,
                             periods.per.year=periods.per.year,
                             initial.healthy.population=initial.healthy.population,
                             lib = lib, 
                             interventions_p = interventions_p,
                             options_p = options_p,
                             costs_p = costs_p)
      
      # Per combinar els resultats del node (generalitzat per si s'afegeixen nous atributs)
      nam <- names(node.res)
      for(att in nam[nam!='nh']) {
        if (length(aux[[att]]) > 0)
          node.res[[att]] <- cbind(node.res[[att]], aux[[att]])
      }
      node.res$nh[[i]] <- aux$nh
    }
    # sink()
    # sink(type="message")
    
    node.res
  })
}

