# TODO temporal. Definir en un fitxer de constants
force(kStartAge)
force(kEndAge)
force(kPeriods)
force(kNsim)

DistanceFunction <- function(non.trivial.tp.vector, non.trivial.idxs,
                                  fixed.mort.values=NULL,
                                  observed.data, tp.limits,
                                  dist.start.age = kStartAge,
                                  dist.end.age = kEndAge,
                                  dist.periods = kPeriods,
                                  dist.healthy = kHealthy,
                                  min.alive = kAlive,
                                  dist.weights = c(1,1,1),
                                  N.states, verbose=TRUE) {
  warning("Using deprecated function 'DistanceFunction'")
  YouthDistanceFunction(non.trivial.tp.vector, 
                        NULL,
                        NULL,
                        non.trivial.idxs,
                        fixed.mort.values,
                        observed.data, tp.limits,
                        dist.start.age,
                        dist.end.age,
                        dist.periods,
                        dist.healthy,
                        min.alive,
                        dist.weights,
                        1,
                        length(non.trivial.idxs),
                        N.states, verbose)
}

YouthDistanceFunction <- function(values.to.optimize, prev.nt.values, post.nt.values,
                                  non.trivial.idxs,
                                  fixed.mort.values=NULL,
                                  observed.data, tp.limits,
                                  dist.start.age = kStartAge,
                                  dist.end.age = kEndAge,
                                  dist.periods = kPeriods,
                                  dist.healthy = kHealthy,
                                  min.alive = kAlive,
                                  dist.weights = c(1,1,1),
                                  starting.age.group=1,
                                  ending.age.group=length(non.trivial.idxs),
                                  N.states, verbose=TRUE) {
  warning("Using deprecated function 'YouthDistanceFunction'")
  # if (verbose) {
  #   df.counter <<- ifelse(exists("df.counter"), df.counter+1, 1)
  #   if(df.counter %% 50 == 0) {
  #     pid <- Sys.getpid()
  #     sprintf("[ Worker %4d ] Distance function called from this node for %4dth time" ,pid,df.counter)
  #   }
  # }

  non.trivial.tp.vector <- c(prev.nt.values, values.to.optimize, post.nt.values)
  
  tpms <- TPMatricesFromVector(N = N.states,
                               values = non.trivial.tp.vector,
                               idxs = non.trivial.idxs,
                               mort = fixed.mort.values)

  # Check and penalize negative probabilities
  if (sum(sapply(tpms, function(x) sum(x<0))) > 0) {
    return(1e7)
  }

  # lc.sim <- lc.simulate.cpp(tp = tpms,
  #                           tp.limits = tp.limits,
  #                           start.age = dist.start.age,
  #                           end.age = dist.end.age,
  #                           periods.per.year = dist.periods,
  #                           initial.healthy.population = dist.healthy)

  lc.sim <- lc.simulate.cpp.multiple(tp = tpms,
                                     tp.limits = tp.limits,
                                     start.age = dist.start.age,
                                     end.age = dist.end.age,
                                     periods.per.year = dist.periods,
                                     initial.healthy.population = dist.healthy,
                                     N.sim = kNsim)

  # Check and penalize big mortality. A minimum of alive people is required
  if (any(sapply(lc.sim$nh, function(nh) sum(nh[nrow(nh),1:(N.states-2)])) < min.alive)) {
    return(1e7)
  }


  lc.incidence <- rowMeans(lc.sim$lc.incidence)
  lc.incidence[is.nan(lc.incidence)] <- 1000*observed.data$lc.incidence[is.nan(lc.incidence)]  # => relative error = 1000

  # lc.mortality <- lc.sim$lc.mortality
  lc.mortality <- rowMeans(lc.sim$lc.mortality)
  lc.mortality[is.nan(lc.mortality)] <- 1000*observed.data$lc.mortality[is.nan(lc.mortality)]  # => relative error = 1000

  # tot.mortality <- lc.sim$tot.mortality
  tot.mortality <- rowMeans(lc.sim$tot.mortality)
  tot.mortality[is.nan(tot.mortality)] <- 1000*observed.data$tot.mortality[is.nan(tot.mortality)]  # => relative error = 1000

  dist.lci <- ifelse(observed.data$lc.incidence == 0,  # no tindria gaire sentit
                     0,
                     abs(observed.data$lc.incidence - lc.incidence)/observed.data$lc.incidence)
  dist.lcm <- ifelse(observed.data$lc.mortality == 0,  # no tindria gaire sentit
                     0,
                     abs(observed.data$lc.mortality - lc.mortality)/observed.data$lc.mortality)
  dist.tot <- ifelse(observed.data$tot.mortality == 0,  # no tindria gaire sentit
                     0,
                     abs(observed.data$tot.mortality - tot.mortality)/observed.data$tot.mortality)

  # DEBUG Comparable prints
  # print(cbind(lc.incidence,
  #             observed.data$lc.incidence,
  #             lc.mortality,
  #             observed.data$lc.mortality,
  #             tot.mortality, observed.data$tot.mortality))
  # END DEBUG

  # return(sum(dist.lci+dist.lcm+dist.tot))  # 33% lc.inc, 33% lc.mort, 33% tot.mort
  # return(sum(3*dist.lci+dist.lcm))  # 75% lc.inc, 25% lc.mort, 0% tot.mort
  # return(sum(dist.lci))  # 100% lc.inc, 0% lc.mort, 0% tot.mort
  return(sum(dist.weights[1]*dist.lci[starting.age.group:ending.age.group] +
               dist.weights[2]*dist.lcm[starting.age.group:ending.age.group] +
               dist.weights[3]*dist.tot[starting.age.group:ending.age.group]) / sum(dist.weights))  # Weighted according to parameters supplied and normalized
}


ParametrizableDistanceFunction <- function(par,
                                           mat.reconstruction.info,
                                           calib.parameters = NULL,
                                           distance.parameters = list(weights=c(1,1,1),
                                                                      age.groups.considered=NULL),
                                           observed.data,
                                           tp.limits,
                                           dist.start.age = kStartAge,
                                           dist.end.age = kEndAge,
                                           dist.periods = kPeriods,
                                           dist.healthy = kHealthy,
                                           min.alive = kAlive,
                                           verbose = TRUE) {
  N.states <- mat.reconstruction.info$N
  
  tpms <- TPMatricesFromCalibrableVector(
    v.info = c(list(var=par), mat.reconstruction.info), 
    calib.parameters = calib.parameters)
  
  # Check and penalize negative probabilities
  if (sum(sapply(tpms, function(x) sum(x<0))) > 0) {
    if (verbose) {
      demon <<- demon+1
      cat(sprintf("%6d > %10.6f\n", demon, 1e7))
    }
    return(1e7)
  }
  
  # lc.sim <- lc.simulate.cpp(tp = tpms,
  lc.sim <- lc.simulate.cpp.multiple(tp = tpms,
                                     tp.limits = tp.limits,
                                     interventions_p = interventions_p,
                                     costs_p = costs_p, 
                                     options_p = options_p, 
                                     start.age = dist.start.age,
                                     end.age = dist.end.age,
                                     periods.per.year = dist.periods,
                                     # initial.healthy.population = dist.healthy)
                                     initial.healthy.population = dist.healthy,
                                     N.sim = kNsim,
                                     parallel.exec = FALSE)
  
  # Check and penalize big mortality. A minimum of alive people is required
  if (any(sapply(lc.sim$nh, function(nh) sum(nh[nrow(nh),1:(N.states-2)])) < min.alive)) {
    return(1e7)
  }

  
  lc.incidence <- rowMeans(lc.sim$lc.incidence)
  lc.incidence[is.nan(lc.incidence)] <- 1000*observed.data$lc.incidence[is.nan(lc.incidence)]  # => relative error = 1000
  
  lc.mortality <- rowMeans(lc.sim$lc.mortality)
  lc.mortality[is.nan(lc.mortality)] <- 1000*observed.data$lc.mortality[is.nan(lc.mortality)]  # => relative error = 1000
  
  tot.mortality <- rowMeans(lc.sim$tot.mortality)
  tot.mortality[is.nan(tot.mortality)] <- 1000*observed.data$tot.mortality[is.nan(tot.mortality)]  # => relative error = 1000
  
  dist.lci <- ifelse(observed.data$lc.incidence == 0,  # no tindria gaire sentit
                     0,
                     abs(observed.data$lc.incidence - lc.incidence)/observed.data$lc.incidence)
  dist.lcm <- ifelse(observed.data$lc.mortality == 0,  # no tindria gaire sentit
                     0,
                     abs(observed.data$lc.mortality - lc.mortality)/observed.data$lc.mortality)
  dist.tot <- ifelse(observed.data$tot.mortality == 0,  # no tindria gaire sentit
                     0,
                     abs(observed.data$tot.mortality - tot.mortality)/observed.data$tot.mortality)
  
  
  # Process distance parameters (weights and age.groups.considered)
  w <- distance.parameters$weights
  if (is.null(w)) {
    w <- c(1,1,1)  # default weights
  }
  ag <- distance.parameters$age.groups.considered
  if (is.null(ag) || length(ag) == 0) {
    ag <- 1:length(tpms)
  }
  
  ret <- sum(w[1]*dist.lci[ag] +
               w[2]*dist.lcm[ag] +
               w[3]*dist.tot[ag]) / sum(w)
  
  if (verbose) {
    demon <<- demon+1
    cat(sprintf("%6d > %10.6f\n", demon, ret))
  }
  return(ret)  # Weighted according to parameters supplied and normalized
  
}



