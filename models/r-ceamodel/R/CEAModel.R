library(magrittr)
#' @importFrom magrittr %>%

Node <- setRefClass('Node',
                    fields=c('id', 'name', 'in_transition', 'info', 'probs', 'out'),
                    methods=list(
                      show = function() {
                        cat('CEAModel Node\n')
                        cat(paste0('* ID: ', id, '\n'))
                        cat(paste0('* Name: ', name, '\n'))
                        cat(paste0('* Node info: \n'))
                        for(key in names(info)) {
                          cat(paste0(' - ', key, ': ', info[[key]], '\n'))
                        }
                        cat(paste0('* Out edges: \n'))
                        for(i in seq_along(out)) {
                          cat(paste0(' - ', out[[i]]$name, ' [p=', probs[[i]], ']\n'))
                        }
                      },
                      parseNodeValue = function(value, context=list(), partial.eval=FALSE) {
                        if (length(value) > 0 &&
                            !is.null(value) && !is.na(value) &&
                            tryCatch(is.na(as.numeric(value)), warning=function(c){TRUE})) {
                          if (! value %in% names(context) || is.null(context[[value]])) {
                            if (partial.eval) {
                              return(value)  # Return unevaluated variable
                            } else {
                              stop(paste0('"', value, '" is not defined in context'))
                            }
                          }
                          retValue <- context[[value]]
                        } else {retValue <- value}
                        return(as.numeric(retValue))
                      },
                      getLeaves = function(context=list(), currentProb=1, currentCost=0, prevalence=NULL) {
                        cost <- .parseValue(ifelse(!is.null(info$cost), info$cost, 0), context)
                        if (length(out) == 0) {
                          ret <- list()
                          leaves <- data.frame(name=name,
                                               cost=currentCost + cost,
                                               prob=currentProb,
                                               outcome=ifelse(!is.null(info$outcome),
                                                                       .parseValue(info$outcome, context, partial.eval = TRUE),
                                                                       1),
                                               stringsAsFactors = F)
                        }
                        else {
                          sensitivity.defined <- !is.null(info[['sensitivity']])
                          specificity.defined <- !is.null(info[['specificity']])
                          specificity_c.defined <- !is.null(info[['specificity_c']])
                          if (length(out) > 0 &&
                              !is.null(prevalence) &&
                              sensitivity.defined && (
                                specificity.defined || specificity_c.defined
                                )
                              ) {
                            if (specificity.defined && specificity_c.defined)
                              stop('"specificity" and "specificity_c" both specified, only one of them must be defined')
                            sensitivity <- .parseProbs(info[['sensitivity']], context, size=length(out))
                            if (specificity.defined) {
                              specificity <- .parseProbs(info[['specificity']], context, size=length(out))

                              # Probability complement not correct for specificity, fixing
                              specificity_c <- 1 - specificity
                              specificity_c[length(specificity_c)] <- 1 - sum(specificity_c[-length(specificity_c)])
                              specificity <- 1 - specificity_c
                            } else {
                              specificity_c <- .parseProbs(info[['specificity_c']], context, size=length(out))
                              specificity <- 1 - specificity_c
                            }

                            tp <- prevalence * sensitivity
                            fp <- (1 - prevalence) * (1 - specificity)
                            actualOutProbs <- tp + fp
                            prevalences <- ifelse(!is.na(tp / actualOutProbs), tp / actualOutProbs, 0)
                          } else if (length(out) > 0) {
                            actualOutProbs <- .parseProbs(probs, context=context)
                            prevalences <- rep(prevalence, length(out))
                          }

                          childrenResults <- lapply(seq_along(out),
                                                   function(i) {
                                                     if (!is.null(prevalence) && sensitivity.defined && (specificity.defined || specificity_c.defined)) {
                                                       prevalence <- prevalences[i]
                                                     }
                                                     child <- out[[i]]
                                                     p <- as.numeric(actualOutProbs[[i]])
                                                     return(child$getLeaves(context,
                                                                            currentProb*p,
                                                                            currentCost+cost,
                                                                            prevalence=prevalence))
                                                   }
                          )
                          leaves <- data.frame()
                          for(i in seq_along(childrenResults)) {
                            leaves <- rbind(leaves, childrenResults[[i]])
                          }
                        }
                        return(leaves)
                      },
                      getExpectedMeasure = function(measure, context=list(), use.only.leaves=FALSE) {
                        measureValue <- info[[measure]]
                        m <- parseNodeValue(measureValue, context)
                        if ((use.only.leaves && length(out) > 0) || length(m) == 0 || is.na(m)) {
                          # warning(paste0('"', measureValue, '" does not exist for node "', name, '"; assuming 0'))
                          currentMeasure <- 0
                        }
                        else {
                          currentMeasure <- m
                        }

                        if (length(out) > 0) {
                          actualOutProbs <- .parseProbs(probs, context)
                          outMeasure <- sum(sapply(seq_along(out),
                                                   function(i) {
                                                     child <- out[[i]]
                                                     p <- as.numeric(actualOutProbs[[i]])
                                                     return(p * child$getExpectedMeasure(measure, context, use.only.leaves))
                                                   }
                          )
                          )
                          currentMeasure <- currentMeasure + outMeasure
                        }
                        return(currentMeasure)
                      },
                      getExpectedMeasureBatch = function(measure, context=list(), use.only.leaves=FALSE) {
                        if (length(context) == 0) {
                          num_simulations <- 1
                        } else if (is.matrix(context[[1]])) {
                          num_simulations <- nrow(context[[1]])
                        } else {
                          num_simulations <- length(context[[1]])
                        }
                        if (length(context) == 0) num_samples <- 0
                        else num_samples <- min(sapply(context, function(v) length(v)))
                        results <- sapply(seq(num_simulations), function(i) {
                          iterationContext <- sapply(context, function(v) {
                            if (length(v) != num_samples) {
                              v
                            } else if (is.matrix(v)) {
                              v[i,]
                            } else {
                              v[[i]]
                            }
                          })
                          iterResults <- getExpectedMeasure(measure, iterationContext, use.only.leaves)
                          return(iterResults)
                        })
                        return(results)
                      },
                      getExpectedCost = function(context=list()) {
                        return(getExpectedMeasureBatch('cost', context=context, use.only.leaves = FALSE))
                      },
                      getExpectedEffectiveness = function(context=list()) {
                        return(getExpectedMeasureBatch('outcome', context, use.only.leaves = TRUE))
                      },
                      getCostEffectiveness = function(context=list()) {
                        cost <- getExpectedCost(context)
                        eff <- getExpectedEffectiveness(context)
                        ce <- cost / eff
                        return(list(
                          cost=cost,
                          effectiveness=eff,
                          ce=ce
                        ))
                      },
                      getNetMonetaryBenefit = function(wtp, context=list()) {
                        return(getExpectedEffectiveness(context) * wtp - getExpectedCost(context))
                      },
                      getNetHealthBenefit = function(wtp, context=list()) {
                        return(getExpectedEffectiveness(context) - getExpectedCost(context) / wtp)
                      },
                      getParameters = function(recursive=TRUE) {
                        vars <- c(info[['cost']], info[['outcome']])
                        # When only two children, if the sensitivity and specificity are specified
                        # the actual probability will be calculated from them (and the prevalence)
                        # and the probability value given will be ignored, so it is not included
                        # here as a parameter
                        if (is.null(info[['sensitivity']]) || (is.null(info[['specificity']]) && is.null(info[['specificity_c']]))) {
                          vars <- append(vars, probs)
                        } else {
                          sensitivity <- .parseProbs(info[['sensitivity']], partial.eval = TRUE)
                          specificity <- .parseProbs(info[['specificity']], partial.eval = TRUE)
                          specificity_c <- .parseProbs(info[['specificity_c']], partial.eval = TRUE)
                          vars <- unlist(append(vars, c(sensitivity, specificity, specificity_c)))
                        }
                        vars <- vars[vars != '#' & !is.na(vars) & suppressWarnings(is.na(as.numeric(vars)))]
                        if (recursive) {
                          for(node in out) {
                            vars <- c(vars, node$getParameters(recursive=recursive))
                          }
                        }
                        if (length(vars) > 0) {
                          vars <- vars[!duplicated(vars)]
                          vars <- vars[order(vars)]
                        }
                        return(vars)
                      },
                      runIterations = function(context=list(), max.steps=100, attributes=NULL, seed=NULL) {
                        if (length(context) == 0) {
                          num_simulations <- 1
                        } else if (is.matrix(context[[1]])) {
                          num_simulations <- nrow(context[[1]])
                        } else {
                          num_simulations <- length(context[[1]])
                        }
                        results <- lapply(seq(num_simulations), function(i) {
                          iterationContext <- sapply(context, function(v) {
                            if (is.matrix(v)) {
                              v[i,]
                            } else {
                              v[[i]]
                            }
                          })
                          iterResults <- as.environment(runIteration(context=iterationContext, max.steps=max.steps, seed=seed))
                          return(iterResults)
                        })
                        if (!is.null(attributes)) {
                          attrResults <- list()
                          for(at in attributes) {
                            attrResults[[at]] <- sapply(results, function(r) get(attributes, envir=r))
                          }
                          results <- attrResults
                        }
                        return(results)
                      },
                      runIteration = function(context=list(), prevalence=NULL, max.steps=100, step=0, seed=NULL) {
                        if (!is.null(seed)) set.seed(seed)
                        if (is.null(info$cost)) nodeCost <- 0
                        else nodeCost <- parseNodeValue(info$cost, context)

                        if (is.character(prevalence)) {
                          prevalence <- context[[prevalence]]
                        }

                        currentNodeInfo <- list(list(node=.self, cost=nodeCost))

                        if (length(out) == 0 ||
                            step == max.steps ||
                            any(probs==1)) {
                        }
                        else {
                          sensitivity.defined <- !is.null(info[['sensitivity']])
                          specificity.defined <- !is.null(info[['specificity']])
                          specificity_c.defined <- !is.null(info[['specificity_c']])
                          if (length(out) > 0 &&
                              !is.null(prevalence) &&
                              sensitivity.defined && (
                                specificity.defined || specificity_c.defined
                              )
                          ) {
                            sensitivity <- .parseProbs(info[['sensitivity']], context, size=length(out))
                            if (specificity.defined) {
                              specificity <- .parseProbs(info[['specificity']], context, size=length(out))

                              # Probability complement not correct for specificity, fixing
                              specificity_c <- 1 - specificity
                              specificity_c[length(specificity_c)] <- 1 - sum(specificity_c[-length(specificity_c)])
                              specificity <- 1 - specificity_c
                            } else {
                              specificity_c <- .parseProbs(info[['specificity_c']], context, size=length(out))
                              specificity <- 1 - specificity_c
                            }

                            tp <- prevalence * sensitivity
                            fp <- (1 - prevalence) * (1 - specificity)
                            node.probs <- tp + fp
                            prevalences <- ifelse(!is.na(tp / node.probs), tp / node.probs, 0)
                          } else if (length(out) > 0) {
                            if (length(probs) == 0) {
                              # Probabilities (or sensitivity/specificity) not defined
                              node.probs <- rep('', length(out))
                            } else {
                              node.probs <- .parseProbs(probs, context=context, partial.eval = TRUE)
                            }
                            prevalences <- rep(prevalence, length(out))
                          }
                          randomChildIndex <- sample(length(node.probs), size=1, prob=node.probs)
                          outNode <- out[[randomChildIndex]]$runIteration(context,
                                                                          prevalence=prevalences[[randomChildIndex]],
                                                                          step=step+1,
                                                                          max.steps=max.steps)

                          currentNodeInfo <- append(currentNodeInfo,
                                                    outNode)
                        }
                        return(currentNodeInfo)
                      },
                      toString = function(level = 0, prob = NULL) {
                        displayedTree <- paste0(paste0(rep('--',level), collapse=''), name)
                        text <- c()
                        if (!is.null(prob)) {
                          text <- c(text, paste0('p = ', prob))
                        }
                        if (!is.null(info[['cost']])) {
                          text <- c(text, paste0('cost = ', info[['cost']]))
                        }
                        if (!is.null(info[['outcome']])) {
                          text <- c(text, paste0('u = ', info[['outcome']]))
                        }
                        if (length(text) > 0) {
                          displayedTree <- paste0(displayedTree, ' (', paste0(text, collapse = ', '), ')')
                        }
                        for(i in seq_along(out)) {
                          child <- out[[i]]
                          if (length(probs) > 1) {
                            childProb <- probs[[i]]
                          } else {
                            childProb <- paste0(probs, '[', i, ']')
                          }
                          displayedTree <- paste(displayedTree, child$toString(level=level+1, prob=childProb), sep='\n')
                        }
                        return(displayedTree)
                      },
                      getNodes = function(context=list(), prevalence=NULL) {
                        nodes <- .getNodes(path.prob=1, path.cost=0, context, prevalence=prevalence)
                        for(node in nodes) {
                          node$info['visited'] <- NULL
                        }
                        return(nodes)
                      },
                      .getNodes = function(path.prob, path.cost, context, prevalence=NULL) {
                        if (!is.null(.self$info[['visited']])) {
                          return(list())
                        }
                        .self$info['visited'] <- TRUE
                        .self$info['path.prob'] <- path.prob

                        .parseValue(.self$info$cost, context, partial.eval = T)
                        .self$info['path.cost'] <- '?'
                        .self$info['path.cost.weighted'] <- '?'
                        suppressWarnings(try({
                          path.cost <- ifelse(is.null(.self$info$cost), path.cost, path.cost + .parseValue(.self$info$cost, context))
                          .self$info['path.cost'] <- path.cost
                          .self$info['path.cost.weighted'] <- round(path.cost * path.prob, digits = 2)
                          }, silent=TRUE))
                        .self$info['path.prob.100k'] <- '?'
                        .self$info['disease.100k'] <- '?'
                        suppressWarnings(try(.self$info['path.prob.100k'] <- round(path.prob * 100000), silent=TRUE))
                        suppressWarnings(try(.self$info['disease.100k'] <- round(prevalence * path.prob * 100000), silent=TRUE))
                        nodes <- .self
                        # if (length(probs) > 0)
                        #   node.probs <- .parseProbs(probs, context=context, partial.eval = TRUE)

                        sensitivity.defined <- !is.null(info[['sensitivity']])
                        specificity.defined <- !is.null(info[['specificity']])
                        specificity_c.defined <- !is.null(info[['specificity_c']])
                        if (length(out) > 0 &&
                            !is.null(prevalence) &&
                            sensitivity.defined && (
                              specificity.defined || specificity_c.defined
                            )
                        ) {
                          sensitivity <- .parseProbs(info[['sensitivity']], context, size=length(out))
                          if (specificity.defined) {
                            specificity <- .parseProbs(info[['specificity']], context, size=length(out))

                            # Probability complement not correct for specificity, fixing
                            specificity_c <- 1 - specificity
                            specificity_c[length(specificity_c)] <- 1 - sum(specificity_c[-length(specificity_c)])
                            specificity <- 1 - specificity_c
                          } else {
                            specificity_c <- .parseProbs(info[['specificity_c']], context, size=length(out))
                            specificity <- 1 - specificity_c
                          }

                          tp <- prevalence * sensitivity
                          fp <- (1 - prevalence) * (1 - specificity)
                          node.probs <- tp + fp
                          prevalences <- ifelse(!is.na(tp / node.probs), tp / node.probs, 0)
                        } else if (length(out) > 0) {
                          if (length(probs) == 0) {
                            # Probabilities (or sensitivity/specificity) not defined
                            node.probs <- rep('', length(out))
                          } else {
                            node.probs <- .parseProbs(probs, context=context, partial.eval = TRUE)
                          }
                          prevalences <- rep(prevalence, length(out))
                        }

                        for(i in seq_along(out)) {
                          child <- out[[i]]
                          prob <- node.probs[[i]]
                          child.path.prob <- '?'
                          suppressWarnings(try(child.path.prob <- path.prob * prob, silent=TRUE))
                          if (!is.null(prevalence)) {
                            prevalence <- prevalences[i]
                          }
                          nodes <- append(nodes, child$.getNodes(path.prob=child.path.prob, path.cost=path.cost, context=context, prevalence=prevalence))
                        }
                        return(nodes)
                      },
                      getEdgeDisplayInfo = function(context=NULL, prevalence=NULL, showProbs=TRUE, showPrettyProbs=TRUE, showLoops=TRUE, probPrecision=8, edge.description=NULL, recursive=TRUE) {
                        nodes <- getNodes(context = context, prevalence=prevalence)
                        for(node in nodes)
                          node$info['visited'] <- NULL
                        edges <- .getEdgeDisplayInfo(context=context, prevalence=prevalence, showProbs=showProbs, showLoops=showLoops, probPrecision=probPrecision, edge.description=edge.description, recursive=recursive)
                        for(node in nodes)
                          node$info['visited'] <- NULL
                        return(edges)
                      },
                      .getEdgeDisplayInfo = function(context=NULL, prevalence=NULL, showProbs=TRUE, showPrettyProbs=TRUE, showLoops=TRUE, probPrecision=8, edge.description=NULL, recursive=TRUE) {
                        if (!is.null(.self$info[['visited']]) | length(out) == 0)
                          return(list())
                        .self$info['visited'] <- TRUE
                        edges <- data.frame()
                        if (!is.null(context)) {
                          if (length(out) > 0) {
                            sensitivity.defined <- !is.null(info[['sensitivity']])
                            specificity.defined <- !is.null(info[['specificity']])
                            specificity_c.defined <- !is.null(info[['specificity_c']])
                            if (!is.null(prevalence) && sensitivity.defined && (specificity.defined || specificity_c.defined)) {
                              sensitivity <- .parseProbs(info[['sensitivity']], context, size=length(out))
                              if (specificity.defined) {
                                specificity <- .parseProbs(info[['specificity']], context, size=length(out))

                                # Probability complement not correct for specificity, fixing
                                specificity_c <- 1 - specificity
                                specificity_c[length(specificity_c)] <- 1 - sum(specificity_c[-length(specificity_c)])
                                specificity <- 1 - specificity_c
                              } else {
                                specificity_c <- .parseProbs(info[['specificity_c']], context, size=length(out))
                                specificity <- 1 - specificity_c
                              }

                              tp <- prevalence * sensitivity
                              fp <- (1 - prevalence) * (1 - specificity)
                              actualProbs <- tp + fp
                              prevalences <- ifelse(!is.na(tp / actualProbs), tp / actualProbs, 0)
                            } else {
                              actualProbs <- .parseProbs(probs, context=context)
                              prevalences <- rep(prevalence, length(out))
                            }
                          }
                        } else {
                          actualProbs <- probs
                          if (length(actualProbs) == 1) {  # Multivariate distribution (e.g. dirichlet)
                            actualProbs <- paste0(actualProbs[[1]], '[', seq_along(out), ']')
                          }
                        }
                        for(i in seq_along(out)) {
                          child <- out[[i]]
                          label <- ''
                          if (!is.null(child$info[['in_transition']])) {
                            label <- paste(strwrap(child$info['in_transition'], 20), collapse='\n')
                          } else if (!is.null(edge.description)) {
                            description <- edge.description[name,child$name]
                            if (length(description) != 0 && !is.na(description)) {
                              label <- paste(strwrap(description, 20), collapse='\n')
                            }
                          }
                          if (length(actualProbs) > 0 && actualProbs[[i]] == 0) next         # If prob=0 we don't draw the edge
                          if (showLoops && id == child$id) next   # If loop, draw only when required
                          if (showProbs) {
                            if (length(actualProbs) > 0) {
                              if (length(actualProbs) > 1) {
                                if (showPrettyProbs) {
                                  prob <- ifelse(is.numeric(actualProbs[[i]]), paste0(formatC(actualProbs[[i]]*100, format='f', digits=2), '%'), actualProbs[[i]])
                                } else {
                                  prob <- ifelse(is.numeric(actualProbs[[i]]), format(round(actualProbs[[i]], digits=probPrecision), scientific=F), actualProbs[[i]])
                                }
                                label <- paste0(label, '\n[', prob, ']')
                              } else {
                                label <- paste0(label, '\n[', actualProbs, '(', i, ')', ']')
                              }
                            }
                          }
                          edges <- rbind(edges, data.frame(from=id, to=child$id, label=label, stringsAsFactors = F))
                          if (!is.null(prevalence)) {
                            prevalence <- prevalences[i]
                          }
                          if (recursive) {
                            edges <- rbind(edges, child$.getEdgeDisplayInfo(context=context, prevalence=prevalence, showProbs=showProbs, showLoops=showLoops, probPrecision=probPrecision, edge.description=edge.description))
                          }
                        }
                        return(edges)
                      }
                    ))

.parseValue <- function(value, context=list(), partial.eval=FALSE) {
  if (length(value) > 0 &&
      !is.null(value) && !is.na(value) &&
      tryCatch(is.na(as.numeric(value)), warning=function(c){TRUE})) {
    if (! value %in% names(context) || is.null(context[[value]])) {
      if (partial.eval) {
        return(value)
      } else {
        stop(paste0('"', value, '" is not defined in context'))
      }
    }
    retValue <- context[[value]]
  } else {retValue <- value}
  return(as.numeric(retValue))
}

.parseProbs <- function(probs, context=list(), partial.eval=FALSE, suffix=NULL, size=NULL) {
  if(length(probs) == 1 && grepl(',', probs)) {
    probs <- strsplit(probs, ',')[[1]]
    probs <- trimws(probs)
    probs <- ifelse(probs=='_', '#', probs)
    if (!is.null(suffix)) {
      probs <- ifelse(sapply(probs, function(p) {tryCatch(is.na(as.numeric(p)), warning=function(c){TRUE})} && p != '#'),
               paste(probs, paste0(suffix, collapse='_'), sep='___'),
               probs)
      names(probs) <- NULL
    }
  }

  actualOutProbs <- sapply(probs, function(p) {
    if (p == '#') return(p)
    else .parseValue(p, context, partial.eval)
  }, USE.NAMES = FALSE)


  if (any(actualOutProbs == '#') && all(suppressWarnings(!is.na(as.numeric(actualOutProbs[actualOutProbs != '#']))))) {
    actualOutProbs[actualOutProbs == '#'] = 1 - sum(as.numeric(actualOutProbs[actualOutProbs != '#']))
    actualOutProbs <- as.numeric(actualOutProbs)
  }

  if (!is.null(size) && length(actualOutProbs) < size)
    actualOutProbs <- c(actualOutProbs, 1-sum(actualOutProbs))

  EPSILON <- .01
  if (all(is.numeric(actualOutProbs)) && abs(1 - sum(actualOutProbs)) > EPSILON) {
    if (exists('name'))
      stop(paste0('Probabilities from node "', name, '" don\'t add up to one'))
    else
      stop('Probabilities don\'t add up to one')
  }

  return(actualOutProbs)
}

#' Base class for Cost-Effectiveness Analysis model
#'
#' @docType class
#' @export
CEAModel <- setRefClass('CEAModel',
                        fields=c('name', 'root'),
                        methods=list(
                          getExpectedCost = function(context=list()) {
                            return(root$getExpectedCost(context))
                          },
                          getExpectedEffectiveness = function(context=list()) {
                            return(root$getExpectedEffectiveness(context))
                          },
                          getCostEffectiveness = function(context=list()) {
                            return(root$getCostEffectiveness(context))
                          },
                          getNetMonetaryBenefit = function(wtp, context=list()) {
                            return(root$getNetMonetaryBeneefit(wtp, context))
                          },
                          getNetHealthBenefit = function(wtp, context=list()) {
                            return(root$getNetHealthBenefit(wtp, context))
                          },
                          getNodes = function(context=NULL, prevalence=NULL) {
                            return(root$getNodes(context, prevalence=prevalence))
                          },
                          getParameters = function() {
                            stop('getParameters should be implemented by subclasses')
                          }
                        )
)
