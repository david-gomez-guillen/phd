library(doParallel)
library(pbapply)

source('load_models.R')
source('markov.R')
source('utils.R')

WTP <- 20000
DISCOUNT.RATE <- .03

do.parameter.sweep <- function(strat.ctx, 
                               excel.strata.df,
                               parameter, 
                               values, 
                               markov, 
                               cohort, 
                               target, 
                               reference, 
                               wtp=WTP, 
                               n.cores=7) {
  INITIAL.STATES <- list(
    asymptomatic=sapply(markov$nodes,
                        function(n) if (n$name=='postmenopausal_asymptomatic') 1 else 0),
    bleeding=sapply(markov$nodes,
                    function(n) if (n$name=='postmenopausal_bleeding') 1 else 0),
    lynch=sapply(markov$nodes,
                 function(n) if (n$name=='lynch') 1 else 0)
  )
  
  STRATEGIES <- list(
    asymptomatic=strategies.asymptomatic,
    bleeding=strategies.bleeding,
    lynch=strategies.lynch
  )
  
  cl <- makeCluster(n.cores)
  registerDoParallel(cl)
  clusterExport(cl=cl,varlist=ls(pos=1),
                envir=environment())
  clusterEvalQ(cl=cl,{
    library(data.table)
    library(stringr)
    library(ggplot2)
    library(plotly)
  })
  
  sweep <- pblapply(cl=cl, X=values, FUN=function(val) {
    strat.ctx.sweep <- lapply(strat.ctx, function(ctx) {ctx[parameter] <- val; ctx;})
    strat.ctx.sweep <- refresh.context(parameter, strat.ctx.sweep, excel.strata.df, context.setup)
    results <- simulate(cohort,
                        STRATEGIES[[cohort]],
                        markov,
                        strat.ctx.sweep,
                        INITIAL.STATES[[cohort]],
                        start.age=BLEEDING.START.AGE,
                        max.age=BLEEDING.MAX.AGE,
                        discount.rate=DISCOUNT.RATE)$summary
    strategy <- results[results$strategy==paste0('tree_', cohort, '_', target),]
    reference <- results[results$strategy==paste0('tree_', cohort, '_', reference),]
    icer <- (strategy$C - reference$C) / (strategy$E - reference$E)
    data.frame(par.value=val, icer=icer)
  }) %>% bind_rows()
  
  stopCluster(cl)
  
  slope <- (sweep[2,'icer'] - sweep[1,'icer']) / (sweep[2,'par.value'] - sweep[1,'par.value'])
  y.int <- sweep[1,'icer'] - slope * sweep[1,'par.value']
  max.cost <- (wtp - y.int) / slope
  
  hjust <- ifelse(max.cost > diff(range(values))/2, 1, 0)
  
  p <- ggplot(sweep, aes(x=par.value, y=icer)) +
             geom_hline(yintercept = wtp, color='red', linetype=2) +
             geom_line() +
             geom_segment(x=max.cost, y=0, xend=max.cost, yend=wtp, linetype=2) +
             geom_label(x=max.cost, y=0, label=paste0('Max cost: ', round(max.cost), ' €'), hjust=hjust, vjust=-.25) +
             # geom_point() +
             # scale_y_continuous(breaks=seq(20000, 30000, 2000)) +
             xlab(parameter) +
             ylab('ICER') +
             ggtitle(paste0(parameter, ' sweep on ', cohort, ' ', target, ' (tree)'))
  p
  return(p)
}





# do.parameter.sweep(strat.ctx=strat.ctx,
#                    parameter='.c_molecular_test',
#                    values=seq(0, 500, 25),
#                    markov=markov,
#                    cohort='asymptomatic',
#                    target='molecular',
#                    reference='current',
#                    n.cores=1)

