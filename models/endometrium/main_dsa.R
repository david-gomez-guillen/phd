# library(Cairo)

source('load_models.R')
source('markov_dsa.R')

N.PARAM.POINTS.TORNADO <- 20
DISCOUNT.RATE <- .03
N.CORES <- 8
EXCLUDED.PARAMS <- c('p_stop_bleeding', 'p_survive',
                     '.p_start_bleeding', '.p_stop_bleeding',
                     'p_death_cancer', 'p_death_cancer___lynch',
                     '.ly_no_cancer', '.ly_cancer', '.ly_cancer_delayed', '.ly_no_cancer_unnecessary_rx',
                     
                     # EXCLUDING NON-BLEEDING PARAMS
                     'u_lynch', '.sensitivity_hysteroscopy', '.specificity_hysteroscopy',
                     '.sensitivity_tvu_10mm', '.specificity_tvu_10mm', '.age_prophylactic_surgery',
                     '.hr_cancer___pms2', 'p_prophylactic_surgery', '.p_cancer___premenopausal',
                     '.p_nulliparous', '.c_prophylactic_hysterectomy', '.p_pipelle_insertion_success___nulliparous',
                     
                     # EXCLUDING NON-LYNCH PARAMS
                     # 'u_bleeding', 'u_hysterectomy', '.sensitivity_hysteroscopy___bleeding',
                     # '.specificity_hysteroscopy___bleeding', '.sensitivity_pipelle___bleeding',
                     # 'p_bleeding___cancer', '.sensitivity_tvu_4mm', '.specificity_tvu_4mm',
                     # 'p_cancer___bleeding_pooled', '.p_bleeding', '.c_prophylactic_hysterectomy',
                     
                     
                     # EXCLUDING OBSOLETE PARAMS
                     '.p_pipelle_success', '.survival_5year',
                     
                     # EXCLUDING PROBLEMATIC PARAMS
                     'p_cancer_stage_1', 'p_cancer_stage_2', 'p_cancer_stage_3',
                     'p_cancer_stage_1___delayed', 'p_cancer_stage_2___delayed', 'p_cancer_stage_3___delayed',
                     '.age_prophylactic_surgery'
                     )

pars <- independent.pars
pars <- pars[!pars %in% EXCLUDED.PARAMS]

dsa.pars <- list(
  # costs=pars[startsWith(pars, '.c_') |
  #            startsWith(pars, 'c_')]
  # ,
  # utilities=pars[startsWith(pars, '.u_') |
  #                startsWith(pars, 'u_')]
  # ,
  # probs=pars[startsWith(pars, '.p_') |
  #              startsWith(pars, 'p_') |
  #              startsWith(pars, '.rate_') |
  #              startsWith(pars, '.sensitivity_') |
  #              startsWith(pars, '.specificity_') |
  #              startsWith(pars, '.survival_') |
  #              startsWith(pars, '.hr_')]
  # ,
  # ranged=pars[sapply(pars,
  #                    function(p)
  #                      any(full.strat.ctx$y25_29[[p]][2:3] != c(-1, -1)))]
  # ,
  not_ranged=pars[!sapply(pars,
                          function(p)
                            any(full.strat.ctx$y25_29[[p]][2:3] != c(-1, -1)))]
  # ,
  # test=c('.sensitivity_tvu_4mm', 
  #        '.specificity_hysteroscopy___bleeding', 
  #        'u_cancer_s1', 
  #        'u_cancer_s4', 
  #        '.p_pipelle_insertion_success',
  #        '.specificity_tvu_4mm',
  #        '.sensitivity_hysteroscopy___bleeding',
  #        'u_bleeding')
  # ,
  # test2=c('.sensitivity_pipelle___bleeding')
)

RANGE.ESTIMATE.FUNCTIONS <- list(
  # standard=function(par.name, val, strat.name) {
  #   # If the original excel dataframe exists, check if there is a valid range:
  #   # a numeric value (not excel formula) different to (-1, -1).
  #   # Otherwise fall back to estimates.
  #   if (exists('excel.strata.df.full')) {
  #     df <- excel.strata.df.full[[strat.name]]
  #     lower <- as.character(df[df$variable == par.name,'lower'])
  #     if (length(lower) == 0) {
  #       # If ranges are not found in current stratum, look in the first
  #       df <- excel.strata.df.full[[1]]
  #       lower <- as.character(df[df$variable == par.name,'lower'])
  #     }
  #     if (length(lower) > 0 && !is.na(suppressWarnings(as.numeric(lower)))) {
  #       upper <- as.character(df[df$variable == par.name,'upper'])
  #       if (lower != '-1' || upper != '-1')
  #         return(c(as.numeric(lower), as.numeric(upper)))
  #     }
  #   }
  #   if (any(startsWith(par.name, c('p_', '.p_', '.rate', '.sensitivity_', '.specificity_', '.survival_', '.u_', 'u')))) {
  #     # These parameters are considered less trustworthy than the rest
  #     if (par.name %in% c('.pipelle_success', '.sensitivity_hysteroscopy_bleeding', '.sensitivity_molecular', '.sensitivity_pipelle')) {
  #       return(c(val*.5, min(1, val*1.5)))
  #     } else {
  #       return(c(val*.75, min(1, val*1.25)))
  #     }
  #   } else if (any(startsWith(par.name, c('c_', '.c_',  'ly_', '.ly_', '.hr_', '.age_')))) {
  #     return(c(val*.75, val*1.25))
  #   }
  # }
  # ,
  not_ranged_5=function(par.name, val, strat.name) {
    if (any(startsWith(par.name, c('p_', '.p_', '.rate', '.sensitivity_', '.specificity_', '.survival_', '.u_', 'u')))) {
      return(c(val*.95, min(1, val*1.05)))
    } else if (any(startsWith(par.name, c('c_', '.c_',  'ly_', '.ly_', '.hr_', '.age_')))) {
      return(c(val*.95, val*1.05))
    }
  }
  # ,
  # not_ranged_10=function(par.name, val, strat.name) {
  #   if (any(startsWith(par.name, c('p_', '.p_', '.rate', '.sensitivity_', '.specificity_', '.survival_', '.u_', 'u')))) {
  #     return(c(val*.9, min(1, val*1.1)))
  #   } else if (any(startsWith(par.name, c('c_', '.c_',  'ly_', '.ly_', '.hr_', '.age_')))) {
  #     return(c(val*.9, val*1.1))
  #   }
  # }
  # ,
  # not_ranged_20=function(par.name, val, strat.name) {
  #   if (any(startsWith(par.name, c('p_', '.p_', '.rate', '.sensitivity_', '.specificity_', '.survival_', '.u_', 'u')))) {
  #     return(c(val*.8, min(1, val*1.2)))
  #   } else if (any(startsWith(par.name, c('c_', '.c_',  'ly_', '.ly_', '.hr_', '.age_')))) {
  #     return(c(val*.8, val*1.2))
  #   }
  # }
  # ,
  # not_ranged_50=function(par.name, val, strat.name) {
  #   if (any(startsWith(par.name, c('p_', '.p_', '.rate', '.sensitivity_', '.specificity_', '.survival_', '.u_', 'u')))) {
  #     return(c(val*.5, min(1, val*1.5)))
  #   } else if (any(startsWith(par.name, c('c_', '.c_',  'ly_', '.ly_', '.hr_', '.age_')))) {
  #     return(c(val*.5, val*1.5))
  #   }
  # }
  # ,
  # not_ranged_25=function(par.name, val, strat.name) {
  #   if (any(startsWith(par.name, c('p_', '.p_', '.rate', '.sensitivity_', '.specificity_', '.survival_', '.u_', 'u')))) {
  #     return(c(val*.75, min(1, val*1.25)))
  #   } else if (any(startsWith(par.name, c('c_', '.c_',  'ly_', '.ly_', '.hr_', '.age_')))) {
  #     return(c(val*.75, val*1.25))
  #   }
  # }
  # ,
  # u_hyst_p_bleeding=function(par.name, val, strat.name) {
  #   if (par.name == '.p_bleeding') return(c(0,1))
  #   else if (par.name == 'u_hysterectomy') return(c(.75, .9))
  # }
  # ,
  # survive_range=function(par.name, val, strat.name) {
  #   if (par.name == 'p_survive') {
  #     return(c(0,.1))
  #   } else if (par.name == 'p_cancer___survive') {
  #     return(c(0,.05))
  #   }
  # }
  # ,
  # test=function(par.name, val, strat.name) {
  #   return(c(.8, 1))
  # }
)

SIMULATION.OPTIONS <- list(
  # asymptomatic=list(
  #   population='asymptomatic',
  #   tree='tree_asymptomatic_molecular',
  #   strategy.name='asymptomatic',
  #   display.name='Asymptomatic molecular'
  # )
  # ,
  bleeding=list(
    population='bleeding',
    tree='tree_bleeding_molecular2',
    reference='tree_bleeding_current2',
    strategy.name='bleeding2',
    display.name='Bleeding molecular 2'
  )
  # ,
  # lynch=list(
  #   population='lynch',
  #   tree='tree_lynch_molecular',
  #   strategy.name='lynch',
  #   display.name='Lynch molecular'
  # )
  # ,
  # lynch_b=list(
  #   population='lynch',
  #   tree='tree_lynch_molecular_b',
  #   strategy.name='lynch_b',
  #   display.name='Lynch molecular (alternative)'
  # )
  # ,
  # lynch2=list(
  #   population='lynch',
  #   tree='tree_lynch_molecular2',
  #   strategy.name='lynch2',
  #   display.name='Lynch molecular 2'
  # )
)

store.results.dsa <- function(results, dsa.type, population, display.name, filename) {
  time.preffix <- format(Sys.time(), "%Y_%m_%d__%H_%M_")
  output.dir <- paste0(getwd(), '/output/dsa_', dsa.type, '/', population)
  suppressWarnings(dir.create(output.dir, recursive=TRUE))
  write.csv(results$summary, paste0(output.dir, '/', filename, '.csv'), row.names = F)
  ggsave(paste0(output.dir, '/', filename, '.pdf'), 
         plot = results$plot,
         width = 300,
         height = 200,
         units = 'mm',
         device = 'pdf'#cairo_pdf
  )
  if (dsa.type == 'univariate') {
    for(par in names(results$plot.curves)) {
      ggsave(paste0(output.dir, '/', filename, '__', par, '.pdf'), 
             plot = results$plot.curves[[par]],
             width = 300,
             height = 200,
             units = 'mm',
             device = 'pdf'#cairo_pdf
      )
    }
  }
  if (dsa.type != 'bivariate') {
    htmlwidgets::saveWidget(ggplotly(results$plot),
                            paste0(output.dir, '/', filename, '.html'),
                            title=display.name,
                            libdir=paste0(output.dir, '/lib'))
  }
  
}

######################## Univariate DSA

args <- commandArgs(trailingOnly=TRUE)
if (length(args) == 0) {
  n.cores <- N.CORES
} else {
  n.cores <- as.numeric(args[1])
}
cluster <- makeForkCluster(n.cores)
registerDoParallel(cluster)

for(param.set.name in names(dsa.pars)) {
  param.set <- dsa.pars[[param.set.name]]
  for(option.name in names(SIMULATION.OPTIONS)) {
    options <- SIMULATION.OPTIONS[[option.name]]
    for(range.estimate.name in names(RANGE.ESTIMATE.FUNCTIONS)) {
      range.estimate.func <- RANGE.ESTIMATE.FUNCTIONS[[range.estimate.name]]
      results <- dsa.1(param.set, strat.ctx,
                       options$population, options$tree,
                       markov,
                       reference=options$reference,
                       excel.file = 'params/context.xlsx',
                       n.param.points = N.PARAM.POINTS.TORNADO,
                       n.cores = n.cores,
                       cluster=cluster,
                       range.estimate=range.estimate.func,
                       context.setup.func=context.setup,
                       discount.rate = DISCOUNT.RATE)
      filename <- paste0(options$strategy.name, '__range_', range.estimate.name, '_params_', param.set.name)
      store.results.dsa(results, 'univariate', options$population, options$display.name, filename)
    }
  }
}

stopCluster(cluster)

######################## Bivariate DSA

N.PARAM.POINTS.HEATMAP <- 50

PARAMETER.PAIRS <- list(
  # asymptomatic=list(
  #   c('.sensitivity_pipelle', '.specificity_pipelle'),
  #   c('.sensitivity_molecular', '.specificity_molecular'),
  #   c('.sensitivity_hysteroscopy', '.specificity_hysteroscopy'),
  #   c('.sensitivity_tvu_4mm', '.specificity_tvu_4mm'),
  #   c('.c_molecular_test', '.sensitivity_molecular'),
  #   c('.c_molecular_test', '.specificity_molecular'),
  #   c('.c_molecular_test', '.p_cancer__asymptomatic')
  # )
  # ,
  bleeding=list(
  #   c('.sensitivity_pipelle', '.specificity_pipelle'),
  #   c('.sensitivity_molecular', '.specificity_molecular'),
  #   c('.sensitivity_hysteroscopy___bleeding', '.specificity_hysteroscopy___bleeding'),
  #   c('.sensitivity_tvu_4mm', '.specificity_tvu_4mm'),
  #   c('.c_molecular_test', '.sensitivity_molecular'),
  #   c('.c_molecular_test', '.specificity_molecular'),
  #   c('.c_molecular_test', '.p_cancer__bleeding'),
  #   c('p_survive', 'p_cancer___survive')
    c('.p_bleeding', 'u_hysterectomy')
  )
  # ,
  # lynch=list(
  #   c('.sensitivity_pipelle', '.specificity_pipelle'),
  #   c('.sensitivity_molecular', '.specificity_molecular'),
  #   c('.sensitivity_hysteroscopy', '.specificity_hysteroscopy'),
  #   c('.sensitivity_tvu_10mm', '.specificity_tvu_10mm'),
  #   c('.c_molecular_test', '.sensitivity_molecular'),
  #   c('.c_molecular_test', '.specificity_molecular'),
  #   c('.c_molecular_test', '.p_cancer__lynch')
  # )
)

# for(option.name in names(SIMULATION.OPTIONS)) {
#   options <- SIMULATION.OPTIONS[[option.name]]
#   for(parameter.pair in PARAMETER.PAIRS[[options$population]]) {
#     for(range.estimate.name in names(RANGE.ESTIMATE.FUNCTIONS)) {
#       range.estimate.func <- RANGE.ESTIMATE.FUNCTIONS[[range.estimate.name]]
#       results <- dsa.n(parameter.pair, strat.ctx,
#                        options$population, options$tree,
#                        markov,
#                        excel.file = 'params/context.xlsx',
#                        n.param.points = N.PARAM.POINTS.HEATMAP,
#                        # n.cores = 1,
#                        range.estimate=range.estimate.func,
#                        context.setup.func=context.setup,
#                        discount.rate = DISCOUNT.RATE)
#       filename <- paste0(options$strategy.name, '__range_', range.estimate.name, '__params_', paste0(parameter.pair, collapse='_'))
#       store.results.dsa(results, 'bivariate', options$population, options$display.name, filename)
#     }
#   }
# }



######################## Multivariate DSA

N.PARAM.POINTS.SCATTER <- 2

# PARAMETER.SETS <- list(
#   asymptomatic=list(
#     c('.sensitivity_pipelle', '.specificity_pipelle', '.sensitivity_molecular'),
#   )
#   ,
#   bleeding=list(
#   )
#   ,
#   lynch=list(
#   )
# )

# for(option.name in names(SIMULATION.OPTIONS)) {
#   options <- SIMULATION.OPTIONS[[option.name]]
#   for(parameter.pair in PARAMETER.SETS[[options$population]]) {
#     for(range.estimate.name in names(RANGE.ESTIMATE.FUNCTIONS)) {
#       range.estimate.func <- RANGE.ESTIMATE.FUNCTIONS[[range.estimate.name]]
#       results <- dsa.n(parameter.pair, strat.ctx,
#                        options$population, options$tree,
#                        markov,
#                        excel.file = 'params/context.xlsx',
#                        n.param.points = N.PARAM.POINTS.SCATTER,
#                        # n.cores = 1,
#                        range.estimate=range.estimate.func,
#                        context.setup.func=context.setup,
#                        discount.rate = DISCOUNT.RATE))
#       filename <- paste0(options$strategy.name, '__range_', range.estimate.name, '__params_', paste0(parameter.pair, collapse='_'))
#       store.results.dsa(results, 'multivariate', options$population, options$display.name, filename)
#     }
#   }
# }