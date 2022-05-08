#' Microsimulation Model for Cost-Effectiveness Analysis
#'
#' It specifies and specifies and run a microsimulation model. For more information about the functions required, see Details.
#'
#' \describe{
#'  \item{setupIndividuals(n.subjects, context)}{
#'  Generate the initial state for all  \emph{n.subjects} individuals. This initial state is a list of named lists with the state variables required by the simulation. Important state variables are:
#'   \describe{
#'    \item{simulateStep(state, markov.models, time, context)}{Simulates a single step for an individual. \emph{state} contains the current individual state, \emph{markov.models}
#'    include the models (optionally) used by the simulation, \emph{time} is an integer that represents the current time (e.g. year, semester, ...) and \emph{context} is the list
#'    of values used by the variables in the current simulation. \emph{state} has the following special variables that can be used in the initial state (\emph{setupIndividuals}):}
#'    \describe{
#'     \item{health.state}{The individual's current health state, as specified in the markov model(s).}
#'     \item{initial.time}{The individual's initial time. The simulation will start with this time value (default 0).}
#'     \item{max.time}{The individual's maximum time. After this iteration the simulation will stop regardless of the individual's state (default 100).}
#'     \item{time.step}{The individual's time step. The simulation's time will increase between iterations by this amount (default 1).}
#'     }
#'
#'   }
#'  }
#'  \item{aggregateIndividualResults(results, context)}{Aggregate an individual's full simulation history (\emph{results}) into an individual summary.}
#'  \item{aggregatePopulationResults(results, context)}{Aggregate individual summaries (\emph{results}) into a cohort summary.}
#'  \item{calibrate(n.subjects, calibrationVars, expectedOutput, context, method, distance.function, ...) {)}{Calibrates the model by
#'   adjusting the variables in \emph{calibrationVars} that optimize the output (\emph{expectedOutput}). The \emph{method} and \emph{distance.function} are used by the optimization process.}
#' }
#' @docType class
#' @export
MicrosimulationModel <- setRefClass('MicrosimulationModel',
                                    contains='CEAModel',
                                    fields=c('markovModels',
                                             'setupIndividuals',
                                             'aggregateIndividualResults',
                                             'aggregatePopulationResults',
                                             'distancePenalty',
                                             'sanityCheck',
                                             'calibrationCount'),
                                    methods=list(
                                      show = function(...) {
                                        markovModels$show(...)
                                      },
                                      getCostEffectiveness = function(context) {
                                        # TODO
                                      },
                                      simulate = function(n.subjects,
                                                          strat.context,
                                                          collectIndividualHistories=FALSE,
                                                          collectIndividualSummaries=TRUE,
                                                          n.cores=4,
                                                          debug.time=FALSE,
                                                          debug.individual=FALSE,
                                                          debug.output=FALSE,
                                                          random.seed=NULL,
                                                          is.calibration=FALSE,
                                                          params.displayed=NULL) {
                                        if (is.null(params.displayed)) {
                                          params.displayed <- names(strat.context[[1]])
                                        }
                                        if (debug.time || debug.individual) {
                                          n.cores <- 1
                                        }
                                        start_time <- Sys.time()

                                        cat('====================================\n')
                                        if (is.calibration) {
                                          cat(paste0('Calibration attempt #', strat.context$.calibration.iter, '\n'))
                                          strat.context$.calibration.iter <- NULL
                                        } else {
                                          cat('Simulating...\n')
                                        }

                                        strata <- names(strat.context)

                                        cat('====================================\n')
                                        cat('Parameters:\n')
                                        for(stratum in strata) {
                                          cat(' * ', stratum, '\n', sep='')
                                          lapply(params.displayed, function(par) {cat('   - ', paste0(par, ': ', strat.context[[stratum]][[par]], '\n'), sep='')})
                                        }
                                        if (is.calibration && !sanityCheck(strat.context)) {
                                          end_time <- Sys.time()
                                          cat(paste0('Time: ', formatC(end_time - start_time, digits=2, format='f'), 's \n'))
                                          cat('Sanity check not passed, not simulating.\n')
                                          return(NULL)
                                        }
                                        individualSummaries <- list()
                                        initial.states <- setupIndividuals(n.subjects, strat.context)

                                        cl <- parallel::makeCluster(n.cores)
                                        parallel::clusterExport(cl, ls(name=1, all.names=TRUE))
                                        doParallel::registerDoParallel(cl)

                                        # All markov models evaluated for all strata.
                                        # If there is only one model, each evaluated model will be named as the strata.
                                        # If there is more than one, each combination will be named as '<model-name>.<stratum-name>'.
                                        if (length(markovModels) == 1) {
                                          models <- list(markovModels)
                                        } else {
                                          models <- markovModels
                                        }
                                        models <- unlist(lapply(models, function(model) {lapply(strat.context, function(ctx) {model$evaluate(ctx, partial.eval = FALSE)})}))
                                        # print(paste0('Available instanced markov models: ', paste0(names(models), collapse=', ')))

                                        if (n.cores == 1) {
                                          `%dosim%` <- foreach::`%do%`
                                          if (!is.null(random.seed))
                                            set.seed(random.seed)  # Initialize the seed just once
                                        } else {
                                          `%dosim%`<- foreach::`%dopar%`
                                        }

                                        subjectSimulationOutput <- foreach::foreach(subject.id=seq_along(initial.states)) %dosim% {
                                          if (n.cores > 1 && !is.null(random.seed)) {
                                            set.seed(subject.id)
                                            # When using multiple cores we need different iteration-dependent seeds or
                                            # different cores might replicate the same simulation
                                          }
                                          state <- initial.states[[subject.id]]
                                          initial.time <- state$initial.time
                                          if (is.null(initial.time))
                                            initial.time <- 0
                                          max.time <- state$max.time
                                          if (is.null(max.time))
                                            max.time <- 120
                                          time.step <- state$time.step
                                          if (is.null(time.step))
                                            time.step <- 1
                                          state$initial.time <- NULL
                                          state$max.time <- NULL
                                          state$time.step <- NULL
                                          individualHistory <- list()
                                          simulateStep <- state$simulateFunc
                                          for(time in seq(initial.time, max.time, time.step)) {
                                            if (debug.time) browser()
                                            # Early stop if simulateStep is FALSE
                                            if (is.logical(simulateStep) && !simulateStep) break
                                            tryCatch({
                                              state <- simulateStep(
                                                state=state,
                                                markov.models=models,
                                                time=time,
                                                strat.context=strat.context)
                                            },
                                            error=function(e) {
                                              state.str <- paste(names(state), state, sep = ": ", collapse = "\n")
                                              stop(paste0('simulateStep error: ', e, '\n', state.str))
                                            })
                                            # If simulateFunc is not explicitly returned, it is assumed to be the same function
                                            if (!is.null(state$simulateFunc)) {
                                              simulateStep <- state$simulateFunc
                                            }
                                            storedState <- state[names(state) != 'simulateFunc'] # Exclude simulate function from history
                                            storedState$time <- time
                                            individualHistory <- append(individualHistory, list(storedState))
                                          }
                                          if (debug.individual) browser()
                                          subjectSimulationOutput <- list()

                                          if (collectIndividualHistories) {
                                            subjectSimulationOutput$individualHistory <- individualHistory
                                          }
                                          tryCatch({
                                            subjectSimulationOutput$individualSummary <- aggregateIndividualResults(individualHistory, strat.context)
                                          },
                                          error=function(e) {
                                            stop(as.character(e))
                                          })
                                          return(subjectSimulationOutput)
                                        }
                                        parallel::stopCluster(cl)

                                        if (debug.output) browser()

                                        individualSummaries <- lapply(subjectSimulationOutput, function(elem) {elem$individualSummary})

                                        tryCatch({
                                          globalSummary <- aggregatePopulationResults(individualSummaries, strat.context)
                                        },
                                        error=function(e) {
                                          stop(paste0('aggregateIndividualResults error: ', e))
                                        })
                                        output <- list(
                                          summary = globalSummary
                                        )
                                        if (collectIndividualHistories)
                                          output$individualHistories <- lapply(subjectSimulationOutput, function(elem) {elem$individualHistory})
                                        if (collectIndividualSummaries)
                                          output$individualSummaries <- individualSummaries
                                        end_time <- Sys.time()
                                        cat(paste0('Time: ', formatC(end_time - start_time, digits=2, format='f'), 's \n'))
                                        return(output)
                                      },
                                      calibrate = function(n.subjects,
                                                           calibrationVars,
                                                           expectedOutput,
                                                           strat.context,
                                                           method=NULL,
                                                           distance.function=NULL,
                                                           n.cores=4,
                                                           random.seed=NULL,
                                                           penalty.distance=1e10,
                                                           ...) {
                                        calibrationStartTime <- Sys.time()
                                        pars <- strat.context[[1]][calibrationVars]
                                        missingVars <- setdiff(calibrationVars, names(pars))
                                        if (length(missingVars) != 0)
                                          stop(paste0('Some calibration variable(s) ["', paste0(missingVars, collapse = '", "'), '"] are not in the original context(s).'))

                                        if (is.null(distance.function)) { # Euclidean distance by default
                                          distance.function <- function(pars, actual, expected, strat.context) {
                                            x <- sapply(seq_along(actual), function(i) {actual[[i]] - expected[[i]]})
                                            return(sqrt(sum(x**2)))
                                          }
                                        }

                                        .self$calibrationCount <- 1
                                        .simulation.fitness <- function(pars,
                                                                        n.subjects,
                                                                        strat.context
                                        ) {
                                          strat.context$.calibration.iter <- .self$calibrationCount

                                          split.pars <- strsplit(names(pars), '__')
                                          for(i in seq_along(split.pars)) {
                                            strat.context[[split.pars[[i]][1]]][[split.pars[[i]][2]]] <- pars[[i]]
                                          }

                                          output <- simulate(n.subjects=n.subjects,
                                                             collectIndividualHistories=FALSE,
                                                             collectIndividualSummaries=FALSE,
                                                             strat.context=strat.context,
                                                             n.cores=n.cores,
                                                             random.seed=random.seed,
                                                             is.calibration=TRUE,
                                                             params.displayed=calibrationVars
                                          )$summary

                                          strat.context$.calibration.iter <- NULL
                                          .self$calibrationCount <- .self$calibrationCount + 1

                                          if (!is.null(output)) {
                                            actualOutput <- output[[names(expectedOutput)]]
                                            distance <- distance.function(pars, actualOutput, expectedOutput, strat.context)
                                          } else {
                                            distance <- penalty.distance
                                          }
                                          cat(paste0('Error: ', distance, '\n'))
                                          cat('------------------------------------\n\n')
                                          return(distance)
                                        }

                                        optim.pars <- c()
                                        for(stratum in names(strat.context)) {
                                          var.names <- names(strat.context[[stratum]])
                                          var.names <- var.names[var.names %in% calib.vars]
                                          var.names <- paste0(stratum, '__', var.names)
                                          var.values <- unlist(strat.context[[stratum]])
                                          var.values <- var.values[names(var.values) %in% calib.vars]
                                          names(var.values) <- var.names
                                          optim.pars <- c(optim.pars, var.values)
                                        }

                                        output <- optim( par=optim.pars,
                                                         fn=.simulation.fitness,
                                                         method = method,
                                                         n.subjects=n.subjects,
                                                         strat.context=strat.context,
                                                         ...)
                                        calibrationEndTime <- Sys.time()
                                        cat(paste0('Calibration elapsed time: ', formatC(calibrationEndTime - calibrationStartTime, digits=2, format='f'), 's \n'))

                                        return(output)
                                      }
                                    ))



#' Load microsimulation model from XLSX file and simulation functions
#'
#' Generates a microsimulation model as specified by the XLSX file (markov models) and the following necessary functions.
#'
#' @param markovFilePaths path to XLSX file(s) with the markov model specification(s)
#' @param setupIndividualsFunc function that sets up the initial state for the simulated subjects
#' @param aggregateIndividualResultsFunc function that aggregates the results from an entire subject simulation history into an individual summary
#' @param aggregatePopulationResultsFunc function that aggregates the results from all individual summaries into a global summary.
#' @param sanityCheckFunc function that checks whether the context variables are valid or not. By default it returns always true (no check performed)
#'
#' @return MicrosimulationModel
#'
#' @examples
#' TODO: Finish example
#' library(CEAModel)
#' simulateStep <- function(subject, t, context) {}
#' aggregateIndividualResults <- function(results, context) {}
#' aggregatePopulationResults <- function(results, context) {}
#' calibrate <- function(expectedOutput, context) {}
#' sanityCheck = function(context) {}
#' ms.model <- loadMicrosimulationModel(markovFilePaths='example.xlsx',
#'                                      setupIndividualsFunc = setupIndividuals,
#'                                      aggregateIndividualResultsFunc = aggregateIndividualResults,
#'                                      aggregatePopulationResultsFunc = aggregatePopulationResults,
#'                                      sanityCheckFunc = sanityCheck
#'                                      )
#' print(ms.model)
#'
#' @export
loadMicrosimulationModel <- function(markov.file.paths,
                                     setup.individuals.func,
                                     aggregate.individual.results.func,
                                     aggregate.population.results.func,
                                     sanity.check.func=NULL) {
  markov.models <- loadMarkovModels(markov.file.paths)
  if (is.null(sanity.check.func)) {
    sanityCheckFunc <- function(ctx) {return(TRUE)}
  }
  return(MicrosimulationModel(markovModels=markov.models,
                              setupIndividuals=setup.individuals.func,
                              aggregateIndividualResults=aggregate.individual.results.func,
                              aggregatePopulationResults=aggregate.population.results.func,
                              sanityCheck=sanity.check.func))
}
