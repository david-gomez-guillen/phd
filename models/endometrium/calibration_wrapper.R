library(jsonlite)

source('load_models.R')
source('markov.R')

make.calibration.func <- function(population, param.names, param.strata) {
  initial.state <- sapply(markov$nodes,
                          function(n) if (n$name=='postmenopausal_bleeding') 1 else 0)
  
  simulation.func <- function(params) {
    calib.strat.ctx <- strat.ctx
    for(i in seq_along(params)) {
      if (param.strata[i] == '') { # Parameter applies to all strata
        for(j in seq_along(param.strata))
          calib.strat.ctx[[param.strata[[j]]]][[param.names[[i]]]] <- params[i]
      } else {
        # Parameter applied to stratum param.strata[i]
        calib.strat.ctx[[param.strata[[i]]]][[param.names[[i]]]] <- params[i]
      }
    }
    
    if (population == 'bleeding') {
      strategies <- strategies.bleeding
      start.age <- BLEEDING.START.AGE
      max.age <- BLEEDING.MAX.AGE-1
    } else if (population == 'asymptomatic') {
      strategies <- strategies.asymptomatic
      start.age <- ASYMPTOMATIC.START.AGE
      max.age <- ASYMPTOMATIC.MAX.AGE-1
    } else if (population == 'lynch') {
      strategies <- strategies.lynch
      start.age <- LYNCH.START.AGE
      max.age <- LYNCH.MAX.AGE-1
    } else if (population == 'all') {
      strategies <- strategies.all
      start.age <- COMBINED.START.AGE
      max.age <- COMBINED.MAX.AGE
    }
    
    result <- simulate(population,
                       strategies,
                       markov,
                       calib.strat.ctx,
                       initial.state,
                       start.age=start.age,
                       max.age=max.age,
                       discount.rate = .03,
                       plot=FALSE)
    
    return(toJSON(result))
  }
  return(simulation.func)
}