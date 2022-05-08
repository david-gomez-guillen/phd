#' Compare Cost-Effectiveness strategies
#'
#' Compares cost-effectiveness of different models, generating a comparison table and
#' a efficiency curve plot.
#'
#' @param ... CEAModel list of the strategies to be evaluated and compared
#' @param context context with values of variables
#'
#' @return list with keys: 'summary' (comparison table) and 'plot' (efficiency curve)
#'
#' @examples
#' library(CEAModel)
#' tree1 <- loadDecisionTree('tree1.yaml')
#' tree2 <- loadDecisionTree('tree2.yaml')
#' tree3 <- loadDecisionTree('tree3.yaml')
#' ctx <- list( ... )
#' outputs <- analyzeCE(tree1=tree1, tree2=tree2, tree3=tree3, context=ctx)
#'
#' @export
analyzeCE <- function(..., context=list(), cost.label=NULL, eff.label=NULL, nudge.x.icer=-.03, nudge.y.icer=.02, plot=FALSE) {
  arg <- list(...)
  if (length(arg) == 1 && is.data.frame(arg[[1]])) {
    fields <- c('strategy', 'C', 'IC', 'E', 'IE', 'ICER')
    fullResults <- data.frame(arg[[1]], stringsAsFactors = FALSE)
    names(fullResults)[names(fullResults) == 'cost'] <- 'C'
    names(fullResults)[names(fullResults) == 'outcome'] <- 'E'
    fullResults[,fields[!fields %in% names(fullResults)]] <- NA
  } else if (length(arg) >= 2) {
    strategies <- arg
    if (length(context) > 0) {
      samples <- length(context[[1]])
      ls <- lapply(context, function(v) {
        if (!is.null(nrow(v))) {
          return(nrow(v))
        } else {
          length(v)
        }
      })
      if (any(ls != samples)) {
        stop('Context variables are not all equal in length')
      }
    } else {
      samples <- 1
    }

    fullResults <- data.frame()
    num_samples <- sapply(context, function(v) length(v))
    for(i in seq(samples)) {
      currentContext <- sapply(context, function(v) {
        if (is.matrix(v) || (length(v) != num_samples)) {
          return(v[i,])
        } else {
          return(v[[i]])
        }
      })

      displayedContext <- lapply(currentContext, function(e) {if (length(e) == 1) e else {paste(e, collapse = ', ')}})

      results <- data.frame(
      )
      for (strategy in names(strategies)) {
        model <- strategies[[strategy]]
        c <- model$getExpectedCost(currentContext)
        e <- model$getExpectedEffectiveness(currentContext)
        modelResults <- data.frame(
          append(
            displayedContext,
            list(
              strategy=strategy,
              C=c,
              IC=NA,
              E=e,
              IE=NA,
              ICER=NA
            )))
        results <- rbind(results, modelResults)
      }
      fullResults <- rbind(fullResults, results)
    }
  } else {
    stop('A results dataframe or more than one tree must be provided')
  }

  fullSummary <- fullResults[,c('strategy', 'C', 'IC', 'E', 'IE', 'ICER')]
  fullSummary <- aggregate(fullSummary, by=list(group=fullSummary$strategy), function(g) {
    if (!any(is.numeric(g))) NA else mean(g)
  })
  fullSummary$strategy <- fullSummary$group
  fullSummary$group <- NULL

  fullSummary <- fullSummary[order(fullSummary$C),]
  row.names(fullSummary) <- seq(nrow(fullSummary))
  fullSummary$domination <- 'undominated'
  if (nrow(fullSummary) > 1)
    for(index in seq(2,nrow(fullSummary))) {
      ic <- fullSummary[index, 'C'] - fullSummary[index-1, 'C']
      ie <- fullSummary[index, 'E'] - fullSummary[index-1, 'E']
      fullSummary[index, 'IC'] <- ic
      fullSummary[index, 'IE'] <- ie
    }

  for(index in seq(1,nrow(fullSummary))) {
    posterior.rows <- seq(nrow(fullSummary)) > index
    lower.e <- fullSummary[,'E'] <= fullSummary[index,'E']
    fullSummary[posterior.rows & lower.e, 'domination'] <- 'absolute'
  }

  fullSummary.undominated <- fullSummary[fullSummary$domination != 'absolute',]
  no.more.extended.dominance <- FALSE
  while (!no.more.extended.dominance) {
    no.more.extended.dominance <- TRUE
    if (nrow(fullSummary.undominated) > 1) {
      for(index in seq(2,nrow(fullSummary.undominated))) {
        ic <- fullSummary.undominated[index, 'C'] - fullSummary.undominated[index-1, 'C']
        ie <- fullSummary.undominated[index, 'E'] - fullSummary.undominated[index-1, 'E']
        fullSummary.undominated[index, 'IC'] <- ic
        fullSummary.undominated[index, 'IE'] <- ie
        fullSummary.undominated[index, 'ICER'] <- ic / ie
      }
    }

    if (nrow(fullSummary.undominated) > 2) {
      for(index in seq(2,nrow(fullSummary.undominated)-1)) {
        prev.strat <- fullSummary.undominated[index-1,]
        current.strat <- fullSummary.undominated[index,]
        next.strat <- fullSummary.undominated[index+1,]
        icer <- current.strat$ICER
        next.icer <- next.strat$ICER
        if (is.na(next.icer)) next  # This is the last, can't be extended-dominated
        if (icer > next.icer) {
          fullSummary.undominated[index, 'domination'] <- 'extended'
          strat <- fullSummary.undominated[index, 'strategy']
          fullSummary[fullSummary$strategy==strat,] <- fullSummary.undominated[index,]
          fullSummary.undominated <- fullSummary.undominated[-index,]
          no.more.extended.dominance <- FALSE
        }
      }
    }
  }

  fullSummary[row.names(fullSummary.undominated),] <- fullSummary.undominated

  if (plot) {
    x.label <- ifelse(is.null(cost.label), 'Cost', paste0('Cost [', cost.label, ']'))
    y.label <- ifelse(is.null(eff.label), 'Effectiveness', paste0('Effectiveness [', eff.label, ']'))
    ce.label <- ifelse(is.null(cost.label) && is.null(eff.label), '', paste0(' ', cost.label, '/', eff.label))

    plot.df <- fullSummary
    undominated.df <- fullSummary[fullSummary$domination=='undominated',]
    undominated.df$label <- paste0('ICER=',
                                   formatC(round(undominated.df$ICER, digits = 2), big.mark=',', format='d'),
                                   ce.label)
    undominated.df[1,'label'] <- ''

    y.range <- diff(range(plot.df$E))
    x.range <- diff(range(plot.df$C))

    plt <- ggplot2::ggplot(plot.df, ggplot2::aes(x=C, y=E)) +
      ggplot2::geom_line(
        data=undominated.df
      ) +
      ggplot2::geom_text(
        data=undominated.df,
        mapping = ggplot2::aes(label=label),
        nudge_x=-nudge.x.icer*x.range,
        nudge_y=nudge.y.icer*y.range
      ) +
      ggplot2::geom_point(
        data=fullSummary, size=3, ggplot2::aes(color=strategy, shape=domination)
      ) +
      ggplot2::xlab(x.label) +
      ggplot2::ylab(y.label)
  } else {
    plt <- NULL
  }

  return(list(summary=fullSummary,
              plot=plt))
}
