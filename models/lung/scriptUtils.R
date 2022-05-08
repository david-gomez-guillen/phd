SingleRun <- function(tp.pre, weight.chain, method, 
                      calib.p=NULL, dist.age.groups=NULL) {
  
  cat("\n************************************************************\n")
  cat(paste0("[ ",
             format(Sys.time(), "%Y%m%d %H:%M:%S"),
             " ] BEGIN RUN\n"))
  
  cat("Starting matrix: (if this list is empty, using original matrix)\n")
  print(weight.chain[-length(weight.chain)])
  
  weights <- weight.chain[[length(weight.chain)]]
  
  cat(paste0("Current method: ",
             method,
             "\n"))
  cat("Current weights: \n")
  print(weights)

  calib.v <- TPMatricesToCalibrableVector(tp.pre, calib.p)
  calib.d <- list(weights=weights,
                  age.groups.considered=dist.age.groups)
  
  if (method == "Nelder-Mead") {
    cat("optim (Nelder-Mead) begins...\n")
    time <- system.time(
      opt.pars <- optim(par = calib.v$var
                        , fn = ParametrizableDistanceFunction
                        , mat.reconstruction.info = calib.v
                        , calib.parameters = calib.p
                        , distance.parameters = calib.d
                        , observed.data=real.mort
                        , tp.limits=tpm$tp.limits  # TODO aquesta referència és lletja
                        # , control=list(trace=4, maxit=10)))
                        , control=list(trace=4, maxit=100000, verbose=TRUE)))
    
  } else if (method == "SA") {
    cat("optim (Simulated Annealing) begins...\n")
    time <- system.time(
      opt.pars <- GenSA(par = calib.v$var
                        , fn = ParametrizableDistanceFunction
                        , mat.reconstruction.info = calib.v
                        , calib.parameters = calib.p
                        , distance.parameters = calib.d
                        , lower = rep(0, length(calib.v$var))
                        , upper = rep(1, length(calib.v$var))
                        , observed.data=real.mort
                        , tp.limits=tpm$tp.limits  # TODO aquesta referència és lletja
                        # , control=list(max.call=1, trace.mat=TRUE)))
                        , control=list(threshold.stop=0.07, trace.mat=TRUE, verbose=TRUE)))
                        # , control=list(max.call=10000, trace.mat=TRUE)))
  } else {
    time <- 0
    cat("WARNING: optim process NOT EXECUTED. Method provided is not supported\n")
    opt.pars <- list(par=calib.v$var)
  }
  
  cat("optim ended\n")
  cat("Total time used in optimization(in hours):\n")
  print(time/3600)
  
  cat("Now simulating...\n")
  calib.optimized <- calib.v
  calib.optimized$var <- opt.pars$par
  tp.post  <- TPMatricesFromCalibrableVector(calib.optimized, calib.p)
  sim.pre  <- lc.simulate.cpp.multiple(tp.pre , tpm$tp.limits, interventions_p = interventions_p, costs_p = costs_p, options_p = options_p,
                                       initial.healthy.population = kHealthy, N.sim = kNsim)
  sim.post <- lc.simulate.cpp.multiple(tp.post, tpm$tp.limits, interventions_p = interventions_p, costs_p = costs_p, options_p = options_p,
                                       initial.healthy.population = kHealthy, N.sim = kNsim)
  cat("Simulation ended\n")
  
  tstamp <- format(Sys.time(), "%Y%m%d_%H%M%S")
  cat(paste0("Generated timestamp to save results: ", tstamp, "\n"))
  
  fname <- paste0("results/calibration_results_", tstamp)
  save(time, opt.pars, calib.v, calib.optimized, calib.p, calib.d, tp.post, sim.pre, sim.post, tstamp, file=fname)
  cat(paste0("Results saved at ", fname, "\n"))
  
  MakeCalibrationGraphs(real.mort, sim.pre, sim.post, tpm$age.groups, tstamp, weight.chain)  # TODO aquesta referència és lletja
  cat("Graphs saved\n")
  
  cat(paste0("[ ",
             format(Sys.time(), "%Y%m%d %H:%M:%S"),
             " ] END RUN\n\n"))
  
  return(tp.post)
}

UnifiedDistanceVector <- function(tp, obs.data, tp.limits) {
  calib.v <- TPMatricesToCalibrableVector(tp)
  return(c(ParametrizableDistanceFunction(par = calib.v$var,
                                          mat.reconstruction.info = calib.v,
                                          distance.parameters = list(weights=c(1,0,0)),
                                          observed.data = obs.data,
                                          tp.limits = tp.limits),
           ParametrizableDistanceFunction(par = calib.v$var,
                                          mat.reconstruction.info = calib.v,
                                          distance.parameters = list(weights=c(1,1,0)),
                                          observed.data = obs.data,
                                          tp.limits = tp.limits),
           ParametrizableDistanceFunction(par = calib.v$var,
                                          mat.reconstruction.info = calib.v,
                                          distance.parameters = list(weights=c(1,1,1)),
                                          observed.data = obs.data,
                                          tp.limits = tp.limits)))
}

EasterMultiTest <- function(tpm) {
  warning("function 'EasterMultiTest' has not been revised after deprecation of old legacy functions")
  # Test 5
  wl <- list()

  # 5.1
  wl <- list("NM", c(1,0,0))
  tp.pre <- tpm$tpm
  tp.5.1 <- SingleRun(tp.pre, wl, "Nelder-Mead")

  ### 5.1.1
  wl <- list("NM", c(1,0,0), c(1,1,0))
  tp.pre  <- tp.5.1
  tp.5.1.1 <- SingleRun(tp.pre, wl, "Nelder-Mead")

  ##### 5.1.1.1
  wl <- list("NM", c(1,0,0), c(1,1,0), c(1,1,1))
  tp.pre  <- tp.5.1.1
  tp.post <- SingleRun(tp.pre, wl, "Nelder-Mead")

  ### 5.1.2
  wl <- list("NM", c(1,0,0), c(4,1,0))
  tp.pre  <- tp.5.1
  tp.5.1.2 <- SingleRun(tp.pre, wl, "Nelder-Mead")

  ##### 5.1.2.1
  wl <- list("NM", c(1,0,0), c(4,1,0), c(2,2,1))
  tp.pre  <- tp.5.1.2
  tp.post <- SingleRun(tp.pre, wl, "Nelder-Mead")

  ### 5.1.3
  wl <- list("NM", c(1,0,0), c(9,9,2))
  tp.pre  <- tp.5.1
  tp.5.1.3 <- SingleRun(tp.pre, wl, "Nelder-Mead")

  ##### 5.1.3.1
  wl <- list("NM", c(1,0,0), c(9,9,2), c(1,1,1))
  tp.pre  <- tp.5.1.3
  tp.5.1.3 <- SingleRun(tp.pre, wl, "Nelder-Mead")

  ### 5.1.4
  wl <- list("NM", c(1,0,0), c(1,0,0))
  tp.pre  <- tp.5.1
  tp.5.1.4 <- SingleRun(tp.pre, wl, "Nelder-Mead")

  ##### 5.1.4.1
  wl <- list("NM", c(1,0,0), c(1,0,0), c(4,1,0))
  tp.pre  <- tp.5.1.4
  tp.5.1.4.1 <- SingleRun(tp.pre, wl, "Nelder-Mead")

  ####### 5.1.4.1.1
  wl <- list("NM", c(1,0,0), c(1,0,0), c(4,1,0), c(1,1,0))
  tp.pre  <- tp.5.1.4.1
  tp.post <- SingleRun(tp.pre, wl, "Nelder-Mead")

  ####### 5.1.4.1.2
  wl <- list("NM", c(1,0,0), c(1,0,0), c(4,1,0), c(1,1,1))
  tp.pre  <- tp.5.1.4.1
  tp.post <- SingleRun(tp.pre, wl, "Nelder-Mead")

  ##### 5.1.4.2
  wl <- list("NM", c(1,0,0), c(1,0,0), c(1,1,0))
  tp.pre  <- tp.5.1.4
  tp.5.1.4.2 <- SingleRun(tp.pre, wl, "Nelder-Mead")

  ####### 5.1.4.2.1
  wl <- list("NM", c(1,0,0), c(1,0,0), c(1,1,0), c(2,2,1))
  tp.pre  <- tp.5.1.4.1
  tp.post <- SingleRun(tp.pre, wl, "Nelder-MOOD")

  ##### 5.1.4.3
  wl <- list("NM", c(1,0,0), c(1,0,0), c(9,9,2))
  tp.pre  <- tp.5.1.4
  tp.post <- SingleRun(tp.pre, wl, "Nelder-Mead")

  # 5.2
  wl <- list("NM", c(1,1,0))
  tp.pre <- tpm$tpm
  tp.5.2 <- SingleRun(tp.pre, wl, "Nelder-Mead")

  ### 5.2.1
  wl <- list("NM", c(1,1,0), c(7,2,1))
  tp.pre <- tp.5.2
  tp.5.2.1 <- SingleRun(tp.pre, wl, "Nelder-Mead")

  ##### 5.2.1.1
  wl <- list("NM", c(1,1,0), c(7,2,1), c(9,9,2))
  tp.pre <- tp.5.2.1
  tp.post <- SingleRun(tp.pre, wl, "Nelder-Mead")

  ### 5.2.2
  wl <- list("NM", c(1,1,0), c(1,0,0))
  tp.pre <- tp.5.2
  tp.5.2.2 <- SingleRun(tp.pre, wl, "Nelder-Mead")

  ##### 5.2.2.1
  wl <- list("NM", c(1,1,0), c(1,0,0), c(1,1,1))
  tp.pre <- tp.5.2.2
  tp.post <- SingleRun(tp.pre, wl, "Nelder-Mead")

  ### 5.2.3
  wl <- list("NM", c(1,1,0), c(1,1,1))
  tp.pre <- tp.5.2
  tp.5.2.3 <- SingleRun(tp.pre, wl, "Nelder-Mead")

  ##### 5.2.3.1
  wl <- list("NM", c(1,1,0), c(1,1,1), c(14,5,1))
  tp.pre <- tp.5.2.3
  tp.post <- SingleRun(tp.pre, wl, "Nelder-Mead")

  ### 5.2.4
  wl <- list("NM", c(1,1,0), c(4,1,0))
  tp.pre <- tp.5.2
  tp.5.2.4 <- SingleRun(tp.pre, wl, "Nelder-Mead")

  ##### 5.2.4.1
  wl <- list("NM", c(1,1,0), c(4,1,0), c(3,1,1))
  tp.pre <- tp.5.2.4
  tp.post <- SingleRun(tp.pre, wl, "Nelder-Mead")

  # 5.3
  wl <- list("SA", c(4,0.9,0.1))
  tp.pre <- tpm$tpm
  tp.5.3 <- SingleRun(tp.pre, wl, "SA")

  ### 5.3.1
  wl <- list("SA", c(4,0.9,0.1), c(4,0.9,0.1))
  tp.pre <- tp.5.3
  tp.5.3.1 <- SingleRun(tp.pre, wl, "Nelder-Mead")

  ##### 5.3.1.1
  wl <- list("SA", c(4,0.9,0.1), c(4,0.9,0.1), c(6,3,1))
  tp.pre <- tp.5.3.1
  tp.5.3.1.1 <- SingleRun(tp.pre, wl, "Nelder-Mead")

  ####### 5.3.1.1.1
  wl <- list("SA", c(4,0.9,0.1), c(4,0.9,0.1), c(6,3,1), c(1,1,1))
  tp.pre <- tp.5.3.1.1
  tp.post <- SingleRun(tp.pre, wl, "Nelder-Mead")

  cat("Calling SA with 10K iterations maximum\n")

  # 5.4
  wl <- list("SA", c(0.98,0.01,0.01))
  tp.pre <- tpm$tpm
  tp.5.4 <- SingleRun(tp.pre, wl, "SA")

  ### 5.4.1
  wl <- list("SA", c(0.98,0.01,0.01), c(0.98,0.01,0.01))
  tp.pre <- tp.5.4
  tp.5.4.1 <- SingleRun(tp.pre, wl, "Nelder-Mead")

  ##### 5.4.1.1
  wl <- list("SA", c(0.98,0.01,0.01), c(0.98,0.01,0.01), c(1,1,0))
  tp.pre <- tp.5.4.1
  tp.5.4.1.1 <- SingleRun(tp.pre, wl, "Nelder-Mead")

  ####### 5.4.1.1.1
  wl <- list("SA", c(0.98,0.01,0.01), c(0.98,0.01,0.01), c(1,1,0), c(1,1,1))
  tp.pre <- tp.5.4.1.1
  tp.post <- SingleRun(tp.pre, wl, "Nelder-Mead")

  ### 5.4.2
  wl <- list("SA", c(0.98,0.01,0.01), c(4,1,0))
  tp.pre <- tp.5.4
  tp.5.4.2 <- SingleRun(tp.pre, wl, "Nelder-Mead")

  ### 5.4.2.1
  wl <- list("SA", c(0.98,0.01,0.01), c(4,1,0), c(2,2,1))
  tp.pre <- tp.5.4.2
  tp.post <- SingleRun(tp.pre, wl, "Nelder-Mead")

  ### 5.4.3
  wl <- list("SA", c(0.98,0.01,0.01), c(1,1,0))
  tp.pre <- tp.5.4
  tp.5.4.3 <- SingleRun(tp.pre, wl, "Nelder-Mead")

  ### 5.4.3.1
  wl <- list("SA", c(0.98,0.01,0.01), c(1,1,0), c(1,1,1))
  tp.pre <- tp.5.4.3
  tp.post <- SingleRun(tp.pre, wl, "Nelder-Mead")

}
