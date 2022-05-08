rm(list=ls())

library(CEAModel)

markovModelByAge <- function(models, years) {
  if (years < 40) name <- '<40y'
  else name <- '>40y'
  return(models[[name]])
}


setupIndividuals <- function(n.subjects, strat.context) {
  # if (sanity.check(strat.context)) {
    simulateFunc <- .simulateUnvaccinated
  # }
  # else {
  #   simulateFunc <- NULL # Early-stop simulation with invalid parameters
  # }
  initial.states <- lapply(seq(n.subjects), function(i) {
    state <- list()
    state$simulateFunc <- simulateFunc
    state$health.state <- 'healthy'
    state$is.vaccinated <- 0
    state$initial.time <- 1
    state$max.time <- 100
    state$time.step <- 1

    return(state)
  })
  return(initial.states)
}

sanity.check <- function(strat.context) {
  for(context in strat.context) {
    contextProbs <- context[startsWith(names(context), 'p_')]
    if (any((contextProbs < 0) | (contextProbs > 1))) {
      return(FALSE)
    }
    if (sum(unlist(context[c('p_cd', 'p_cs')])) > 1)
      return(FALSE)

    contextCosts <- context[startsWith(names(context), 'c_')]
    if (any(contextCosts < 0))
      return(FALSE)
  }
  return(TRUE)
}

.simulateUnvaccinated <- function(state, markov.models, time, strat.context) {
  markov <- markov.models$model1.l40

  next.health.state <- .sample(1, markov$tpMatrix[state$health.state,])

  # VACCINATION
  is.vaccinated <- rbinom(1,1,strat.context$l40$p_vaccinated)
  if (is.vaccinated) additional.cost <- 1000
  else additional.cost <- 0

  simulateFunc <- .getSimulateFunc(next.health.state, state)

  state.change <- list(
    is.vaccinated = is.vaccinated,
    cost = markov$nodes[[next.health.state]]$info$cost + additional.cost,
    outcome = markov$nodes[[next.health.state]]$info$outcome,
    health.state = next.health.state,
    simulateFunc = simulateFunc
  )
  if (is.vaccinated) state.change$vaccine.time <- time
  return(modifyList(state, state.change))
}


.simulateVaccinated <- function(state, markov.models, time, strat.context) {
  markov <- markov.models$model2.ge40

  next.health.state <- .sample(1, markov$tpMatrix[state$health.state,])

  simulateFunc <- .getSimulateFunc(next.health.state, state)

  state.change <- list(
    cost = markov$nodes[[next.health.state]]$info$cost,
    outcome = markov$nodes[[next.health.state]]$info$outcome,
    health.state = next.health.state,
    simulateFunc = simulateFunc
  )
  return(modifyList(state, state.change))
}


.simulateCancer <- function(state, markov.models, time, strat.context, random.seed) {
  markov <- markov.models$model2.l40
  node <- markov$nodes[[state$health.state]]

  next.health.state <- .sample(1, markov$tpMatrix[state$health.state,])

  simulateFunc <- .getSimulateFunc(next.health.state, state)

  if (state$is.vaccinated) cost <- 750
  else cost <- 0

  state.change <- list(
    cost = cost,
    outcome = markov$nodes[[next.health.state]]$info$outcome,
    health.state = next.health.state,
    simulateFunc = simulateFunc
  )
  return(modifyList(state, state.change))
}

.getSimulateFunc <- function(health.state, state) {
  if (health.state == 'healthy') {
    if (state$is.vaccinated)
      simulateFunc <- .simulateVaccinated
    else
      simulateFunc <- .simulateUnvaccinated
  } else if (health.state == 'cancer') {
    simulateFunc <- .simulateCancer
  } else if (health.state %in% c('death', 'survive')) {
    simulateFunc <- NULL
  }
  return(simulateFunc)
}

aggregateIndividualResults <- function(results, strat.context) {
  # Warning: while calibrating the results parameter might be empty if the
  # parameters are invalid since the simulation will be skipped
  history <- list(
    cost=sum(sapply(results, function(step) step$cost)),
    outcome=sum(sapply(results, function(step) step$outcome)),
    life.years=length(results),
    vaccination.age=results[[length(results)]]$vaccine.time
  )
  return(history)
}


aggregatePopulationResults <- function(results, strat.context) {
  stats <- list(
    avg.cost=mean(sapply(results, function(step) step$cost)),
    avg.outcome=mean(sapply(results, function(step) step$outcome)),
    avg.life.years=mean(sapply(results, function(step) step$life.years)),
    avg.vaccination.age=mean(unlist(sapply(results, function(step) step$vaccination.age))),
    vaccine.coverage=length(unlist(sapply(results, function(step) step$vaccination.age))) / length(results) * 100
  )
  return(stats)
}

MAX_RANDOM <- 1e2
sampleIndex <- 1
samples <- runif(MAX_RANDOM)

.sample <- function(n, tpVector) {
  samples <- rmultinom(n, 1, tpVector)
  return(apply(samples, 2, function(s) names(s)[s==1]))
}




model <- loadMicrosimulationModel(markov.file.paths = 'test/modelSpecs/markov_test.xlsx',
                                  setup.individuals.func = setupIndividuals,
                                  aggregate.individual.results.func = aggregateIndividualResults,
                                  aggregate.population.results.func = aggregatePopulationResults,
                                  sanity.check.func = sanity.check
                                  )
mkv <- model$markovModels
context.l40 <- list(
  p_hc=.001,
  p_hd=.01,
  p_cd=.1,
  p_cs=.15,
  c_healthy=10,
  c_cancer=100000,
  c_survive=50,
  c_death=0,
  u_healthy=1,
  u_survive=.9,
  u_cancer=.5,
  p_vaccinated=.4
)

context.ge40 <- list(
  p_hc=.002,
  p_hd=.02,
  p_cd=.2,
  p_cs=.15,
  c_healthy=10,
  c_cancer=100000,
  c_survive=50,
  c_death=0,
  u_healthy=1,
  u_survive=.9,
  u_cancer=.5,
  p_vaccinated=.4
)

strat.context <- list(l40=context.l40, ge40=context.ge40)

# output <- model$simulate(n.subjects = 20,
#                          collectIndividualHistories=TRUE,
#                          collectIndividualSummaries=TRUE,
#                context = context)




distance.function <- function(pars, actual, expected, strat.context) {
  x <- sapply(seq_along(actual), function(i) {actual[[i]] - expected[[i]]})
  dist <- sqrt(sum(x**2))
  # if (!sanity.check(strat.context))
  #   dist <- dist + 1e10
  return(dist)
}

calib.vars <- names(strat.context[[1]])
calib.vars <- calib.vars[startsWith(calib.vars, 'p_')]

calibrationOutput <- model$calibrate(n.subjects=20,
                                     calibrationVars=calib.vars,
                                     expectedOutput=list(avg.cost=50),
                                     # method='SANN',
                                     strat.context=strat.context,
                                     distance.function = distance.function,
                                     n.cores=1,
                                     random.seed=0
                                     )
print(calibrationOutput)

