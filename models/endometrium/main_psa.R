library(officer)
library(rvg)
library(magrittr)

source('load_models.R')
source('markov_psa.R')


PSA.SEED <- 1234
N.ITERS <- 1000
CHUNK.SIZE <- 1000
N.CORES <- 8
DISCOUNT.RATE <- .03
EXCLUDED.PARAMS <- c('p_stop_bleeding', 'p_survive',
                     '.p_start_bleeding', '.p_stop_bleeding', 'p_cancer___survive',
                     'p_death_cancer', 'p_death_cancer___lynch',
                     '.ly_no_cancer', '.ly_cancer', '.ly_cancer_delayed', '.ly_no_cancer_unnecessary_rx',
                     
                     # EXCLUDING NON-BLEEDING PARAMS
                     'u_lynch', '.sensitivity_hysteroscopy', '.specificity_hysteroscopy',
                     '.sensitivity_tvu_10mm', '.specificity_tvu_10mm', '.age_prophylactic_surgery',
                     '.hr_cancer___pms2', '.p_prophylactic_surgery', '.sensitivity_pipelle', 
                     # 'u_hysterectomy___lynch', 'u_prophylactic_hysterectomy___lynch',
                     '.p_nulliparous', '.c_prophylactic_hysterectomy',
                     
                     # EXCLUDING OBSOLETE PARAMS
                     'u_cancer', '.survival_5year', '.p_pipelle_success', 
                     '.sensitivity_molecular', '.specificity_molecular',
                     
                     # EXCLUDING PROBLEMATIC PARAMS
                     'p_cancer_stage_1', 'p_cancer_stage_2', 'p_cancer_stage_3',
                     'p_cancer_stage_1___delayed', 'p_cancer_stage_2___delayed', 'p_cancer_stage_3___delayed'
                     )

N.CHUNKS <- ceiling(N.ITERS / CHUNK.SIZE)

args <- commandArgs(trailingOnly=TRUE)
if (length(args) == 0) {
  n.cores <- N.CORES
} else {
  n.cores <- as.numeric(args[1])
}

SD.ESTIMATE.FUNCTIONS <- list(
  # high=function(p.name, value) value/2
  # ,
  `base_10`=function(p.name, value) value/10
  # ,
  # sd_5=function(p.name, value) value/5
  # ,
  # sd_2=function(p.name, value) value/2
  # ,
  # sd=function(p.name, value) value
  # ,
  # medium=function(par.name, value) {
  #   # These parameters are considered less trustworthy than the rest
  #   if (par.name %in% c('.pipelle_success',
  #                  '.sensitivity_hysteroscopy_bleeding',
  #                  '.sensitivity_molecular',
  #                  '.sensitivity_pipelle')) {
  #     return(value/10)
  #   } else {
  #     return(value/20)
  #   }
  # }
  # ,
  # low=function(p.name, value) value/5
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
    strategy.name='bleeding',
    display.name='Bleeding molecular'
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

pars <- independent.pars
pars <- pars[!pars %in% EXCLUDED.PARAMS]
eligible.pars <- sapply(pars, function(p) {
  val <- strat.ctx[[1]][[p]][1]
  if ((startsWith(p, '.p_') || startsWith(p, 'p_') ||
       startsWith(p, '.rate_')) && val %in% c(0,1)) {
    # Excluding parameters with probabilities equal to 0, since they cannot
    # be represented by a beta distribution.
    warning(paste0('Parameter "', p, '" = ', val, ' excluded from PSA'))
    return(FALSE)
  }
  return(TRUE)
  })
pars <- pars[eligible.pars]
pars <- pars[order(pars)]

# FILTER OUT NON-BLEEDING PARAMS
pars <- pars[!grepl('lynch', pars)]

psa.pars <- list(
  all=pars
  # ,
  # sensitivities=c('.sensitivity_pipelle', '.sensitivity_tvu_4mm', '.sensitivity_molecular'),
  # relevant=c('.sensitivity_pipelle', '.sensitivity_tvu_4mm', '.sensitivity_molecular',
  #            '.specificity_molecular', '.survival_5year', 'u_hysterectomy', 'u_cancer', '.c_treatment')
  # ,
  # sensititivites_survival=c('.sensitivity_pipelle', '.sensitivity_tvu_4mm', '.sensitivity_molecular', '.survival_5year')
  # ,
  # costs=pars[startsWith(pars, '.c_')]
  # ,
  # utilities=pars[startsWith(pars, '.u_')]
  # ,
  # probs=pars[startsWith(pars, '.p_') |
  #              startsWith(pars, 'p_') |
  #              startsWith(pars, '.sensitivity_') |
  #              startsWith(pars, '.specificity_') |
  #              startsWith(pars, '.survival_') |
  #              startsWith(pars, '.hr_')]
  # ,
  # cost='.c_molecular_test'
  # ,
  # less_ce_2=c('.hr_bleeding', '.p_cancer_stage_1', '.sensitivity_molecular',
  #             '.sensitivity_pipelle', '.sensitivity_tvu_4mm', '.specificity_molecular',
  #             '.survival_5year', 'u_hysterectomy')
  # ,
  # survive=c('p_survive')
  # ,
  # utilities_cancer=pars[startsWith(pars, 'u_cancer_')]
  # ,
  # critical=c('.p_bleeding', 
  #            '.sensitivity_tvu_4mm',
  #            '.specificity_tvu_4mm',
  #            'u_cancer_s1',
  #            'u_cancer_s4')
)

param.names <- c(
  .specificity_molecular='Molecular test specificity',
  .sensitivity_molecular='Molecular test sensitivity',
  .specificity_molecular_cyto='Specificity of molecular test (cytology)',
  .sensitivity_molecular_cyto='Sensitivity of molecular test (cytology)',
  .specificity_molecular_pipelle='Specificity of molecular test (pipelle)',
  .sensitivity_molecular_pipelle='Sensitivity of molecular test (pipelle)',
  u_hysterectomy='Non-cancer hysterectomy utility',
  .p_cancer___bleeding='Prevalence of EC in women with PMB',
  .sensitivity_tvu='Sensitivity of TVU',
  .sensitivity_pipelle___bleeding='Sensitivity of pipelle',
  .c_molecular_test='Cost of molecular test',
  u_cancer='EC utility',
  u_bleeding='PMB utility',
  .specificity_pipelle='Specificity of pipelle',
  .p_cancer___asymptomatic='Prevalence of EC',
  .specificity_tvu='Specificity of TVU',
  # .survival_5year___stage1='5-year survival (stage 1)',
  .survival_5year='5-year EC survival',
  .p_pipelle_success='Pipelle success probability',
  .p_cancer_stage_1='Percentage of EC cases at stage 1',
  .specificity_hysteroscopy___bleeding='Specificity of hysteroscopy',
  .sensitivity_hysteroscopy___bleeding='Sensitivity of hysteroscopy',
  .p_bmi_high='Proportion of obese women (BMI > 30)',
  .c_tvu='Cost of TVU',
  .c_hysterectomy___stage_1='Cost of hysterectomy, EC stage I (€)',
  .c_hysterectomy___stage_2_4='Cost of hysterectomy, EC stage II-IV (€)',
  c_phone_visit='Cost of phone visit',
  .c_pipelle='Cost of pipelle',
  .p_bleeding__cancer='Prevalence of PMB in women with EC',
  .c_hysteroscopy='Cost of hysteroscopy',
  .c_visit='Cost of visit',
  .c_treatment='Cost of treatment (€)',
  u_cancer_s1='EC utility (stage I)',
  u_cancer_s2='EC utility (stage II)',
  u_cancer_s3='EC utility (stage III)',
  u_cancer_s4='EC utility (stage IV)',
  u_undetected_cancer='Undetected EC utility',
  .survival_5year_s1='5-year survival (stage I)',
  .survival_5year_s2='5-year survival (stage II)',
  .survival_5year_s3='5-year survival (stage III)',
  .survival_5year_s4='5-year survival (stage IV)',
  .p_bleeding='Probability of bleeding persistence',
  .p_pipelle_tissue_success='Probability of pipelle success (tissue)',
  .p_pipelle_insertion_success='Probability of pipelle success (insertion)',
  .p_pipelle_insertion_success___parous='Probability of pipelle success (insertion)',
  .rate_recurrence_s1='Recurrence rate (stage I)',
  .rate_recurrence_s2='Recurrence rate (stage II)',
  .rate_recurrence_s3='Recurrence rate (stage III)',
  .rate_recurrence_s4='Recurrence rate (stage IV)',
  .p_progression_cancer_s1_2='Annual cancer progression (stage I-II)',
  .p_progression_cancer_s2_3='Annual cancer progression (stage II-III)',
  .p_progression_cancer_s3_4='Annual cancer progression (stage III-IV)',
  .p_death_other='Probability of death from other causes',
  .c_cytology='Cost of cytology',
  .c_first_visit='Cost of first visit',
  .rate_prevalence='Prevalence rate of EC (global)',
  p_death_other='Probability of death from other causes',
  .p_bleeding___cancer='Prevalence of PMB in women with EC',
  .hr_bmi='HR BMI',
  .p_cancer___bleeding_pooled='Probability of EC in PMB',
  .p_cancer___postmenopausal='Probability of EC in postmenopausal women',
  Discount='Discount'
)

store.results.psa <- function(results, psa.type, population, display.name, filename) {
  time.preffix <- format(Sys.time(), "%Y_%m_%d__%H_%M_")
  output.dir <- paste0(getwd(), '/output/psa_', psa.type, '/', population)
  suppressWarnings(dir.create(output.dir, recursive=TRUE))
  write.csv(results$summary, paste0(output.dir, '/', filename, '.csv'), row.names = F)
  
  htmlwidgets::saveWidget(ggplotly(results$plot.scatter),
                          paste0(output.dir, '/', filename, '.html'),
                          title=display.name,
                          libdir=paste0(getwd(), paste0('/output/psa_', psa.type, '/', population, '/lib')))
  htmlwidgets::saveWidget(ggplotly(results$plot.scatter.j),
                          paste0(output.dir, '/', filename, '_jitter.html'),
                          title=paste0(display.name, ' [jitter]'),
                          libdir=paste0(getwd(), paste0('/output/psa_', psa.type, '/', population, '/lib')))
  htmlwidgets::saveWidget(ggplotly(results$plot.acceptability),
                          paste0(output.dir, '/', filename, '_acceptability.html'),
                          title=display.name,
                          libdir=paste0(getwd(), paste0('/output/psa_', psa.type, '/', population, '/lib')))
  ggsave(paste0(output.dir, '/', filename, '.pdf'), 
         results$plot.scatter,
         width = 300,
         height = 200,
         units = 'mm',
         device = cairo_pdf
  )
  ggsave(paste0(output.dir, '/', filename, '_jitter.pdf'), 
         results$plot.scatter.j,
         width = 300,
         height = 200,
         units = 'mm',
         device = cairo_pdf
  )
  ggsave(paste0(output.dir, '/', filename, '_acceptability.pdf'), 
         results$plot.acceptability,
         width = 300,
         height = 200,
         units = 'mm',
         device = cairo_pdf
  )
}

######################## Multivariate PSA

# for(param.set.name in names(psa.pars)) {
#   param.set <- psa.pars[[param.set.name]]
#   for(option.name in names(SIMULATION.OPTIONS)) {
#     options <- SIMULATION.OPTIONS[[option.name]]
#     output.dir <- paste0(getwd(), '/output/psa_multivariate/', options$population)
#     for(sd.estimate.name in names(SD.ESTIMATE.FUNCTIONS)) {
#       sd.estimate.func <- SD.ESTIMATE.FUNCTIONS[[sd.estimate.name]]
#       csv.data <- data.frame()
#       filename.preffix <- paste0(options$strategy.name, '__sd_', sd.estimate.name, '__params_', param.set.name, '__')
#       for(i in seq(1,N.CHUNKS)) {
#         results <- psa.n(param.set, strat.ctx,
#                          options$population, options$tree,
#                          markov,
#                          excel.file = 'params/context.xlsx',
#                          sd.estimate.func=sd.estimate.func,
#                          context.setup.func=context.setup,
#                          n.cores = n.cores,
#                          n.iters=CHUNK.SIZE,
#                          seed=PSA.SEED * i * 7877 %% 102161,  # Quick pseudorandom seed generation (prime numbers)
#                          discount.rate=DISCOUNT.RATE)
#         cat(paste0('Chunk ', i, ' completed\n'))
#         # Remove constant parameters
#         for(col in names(results$summary)) {
#           if (length(unique(results$summary[[col]])) == 1)
#             results$summary[[col]] <- NULL
#         }
#         # Remove all strata buy one for non-stratified parameters
#         par.cols <- names(results$summary)
#         for(p in param.set) {
#           p.cols <- par.cols[endsWith(par.cols, paste0('_',p))]
#           p.df <- results$summary[p.cols]
#           p.is.stratified <- !all(sapply(1:ncol(p.df), function(c) all(p.df[1]==p.df[c])))
#           if (!p.is.stratified)
#             results$summary[p.cols[2:length(p.cols)]] <- NULL
#         }
#         filename <- paste0(output.dir, '/', filename.preffix, i, '.csv')
#         write.csv(results$summary, filename)
#         results <- NULL
#       }
#       
#       df.results <- data.frame()
#       for(f in list.files(output.dir, pattern = paste0(filename.preffix, '\\d*.csv'))) {
#         df.results <- rbind(df.results, read.csv(paste0(output.dir, '/', f)))
#         unlink(paste0(output.dir, '/', f))
#       }
#       results <- generate.psa.summary(df.results, options$tree, options$population, POPULATION.REFERENCES[[options$population]], strat.ctx, param.set)
#       filename <- paste0(options$strategy.name, '__sd_', sd.estimate.name, '__params_', param.set.name)
#       store.results.psa(results, 'multivariate', options$population, options$display.name, filename)
#     }
#   }
# }



######################## Univariate PSA

add.results.to.slide <- function(slides, results, par) {
  perc.ce <- mean(results$summary$IE > results$summary$IC / 25000)
  par.name <- unname(ifelse(is.na(param.names[par]), par, param.names[par]))
  
  plot.scatter.j <- results$plot.scatter.j +
    coord_cartesian(xlim=c(-3500,500), ylim=c(-1,2)) +
    ggtitle(paste0('Univariate PSA (', par.name, ') SD=', sd.estimate.name)) +
    scale_x_continuous(labels=scales::number_format(big.mark=',')) +
    xlab(paste0('Incremental cost\n\nWTP = 25,000 €/QALY\n(', 
                formatC(perc.ce*100, format='f', digits=1), 
                '% cost-effective)')) +
    ylab('Incremental QALY') +
    theme_classic() +
    theme(legend.position = 'none',
          axis.title.x = element_text(margin = margin(t = 10, r = 0, b = 0, l = 0)))
  
  plot.acceptability <- results$plot.acceptability +
    ggtitle('') +
    scale_x_continuous(labels=scales::number_format(big.mark=',')) +
    scale_color_manual(name='Strategy',
                       breaks=c('tree_bleeding_current2', 'tree_bleeding_molecular2'), 
                       labels=c('Current', 'Molecular'),
                       values=c('#002fff', '#ff9d00')) +
    xlab('WTP (€/QALY)\n\n\n') +
    ylab('Probability of cost-effective simulations (%)') +
    theme_classic() +
    theme(legend.position = c(.8,.9), 
          panel.grid.major = element_line(color='#f2f2f2', linetype='dashed'),
          axis.title.x = element_text(margin = margin(t = 10, r = 0, b = 0, l = 0)))
  
  
  slides <- slides %>%
    add_slide(layout='Titulo y objetos', master='Plantilla ICO') %>%
    #ph_with(paste0('Univariate PSA (', par, ') SD=', sd.estimate.name), ph_location_type('title')) %>%
    ph_with(rvg::dml(ggobj=plot.scatter.j), ph_location_type('body', id=1))
    # ph_with('Sepal width vs length', ph_location_type('body', id=2)) %>%
    # ph_with(rvg::dml(ggobj=plot.acceptability), ph_location_type('body', id=3))
  # ph_with('Sepal vs Petal width', ph_location_type('body', id=4))
  
  return(slides)
}

# RESUME.FROM.PAR <- ''
# 
# if (is.null(RESUME.FROM.PAR) || RESUME.FROM.PAR == '') {
#   run <- TRUE
# } else {
#   run <- FALSE
# }
# 
# for(param.set.name in names(psa.pars)) {
#   param.set <- psa.pars[[param.set.name]]
#   for(option.name in names(SIMULATION.OPTIONS)) {
#     options <- SIMULATION.OPTIONS[[option.name]]
#     for(sd.estimate.name in names(SD.ESTIMATE.FUNCTIONS)) {
#       sd.estimate.func <- SD.ESTIMATE.FUNCTIONS[[sd.estimate.name]]
#       for(par in param.set) {
#         if (!run && RESUME.FROM.PAR == par)
#           run <- TRUE
#         if (!run) next
#         results <- psa.1(par, strat.ctx,
#                          options$population, options$tree,
#                          markov,
#                          excel.file = 'params/context.xlsx',
#                          sd.estimate.func=sd.estimate.func,
#                          context.setup.func=context.setup,
#                          n.cores = n.cores,
#                          n.iters=N.ITERS,
#                          seed=PSA.SEED,
#                          discount.rate=DISCOUNT.RATE)
#         filename <- paste0(
#           options$strategy.name, '__sd_', sd.estimate.name, '__par_', par)
#         store.results.psa(results[[par]], 'univariate', options$population, options$display.name, filename)
#         results <- NULL
#       }
#     }
#   }
# }


RESUME.PAR <- ''
JITTER.X <- .05
JITTER.Y <- 1

for(param.set.name in names(psa.pars)) {
  slides <- read_pptx('Plantilla_HPVinformationCentre.pptx')
  
  param.set <- psa.pars[[param.set.name]]
  if (RESUME.PAR != '')
	param.set <- param.set[match(RESUME.PAR, param.set):length(param.set)]
  for(option.name in names(SIMULATION.OPTIONS)) {
    options <- SIMULATION.OPTIONS[[option.name]]
    output.dir <- paste0(getwd(), '/output/psa_univariate/', options$population)
    for(sd.estimate.name in names(SD.ESTIMATE.FUNCTIONS)) {
      sd.estimate.func <- SD.ESTIMATE.FUNCTIONS[[sd.estimate.name]]
      for(par in param.set) {
        csv.data <- data.frame()
        filename.preffix <- paste0(options$strategy.name, '__sd_', sd.estimate.name, '__par_', par, '__')
        for(i in seq(1,N.CHUNKS)) {
          results <- psa.n(par, strat.ctx,
                           options$population, options$tree,
                           markov,
                           excel.file = 'params/context.xlsx',
                           sd.estimate.func=sd.estimate.func,
                           context.setup.func=context.setup,
                           n.cores = n.cores,
                           n.iters=CHUNK.SIZE,
                           seed=PSA.SEED * i * 7877 %% 102161,  # Quick pseudorandom seed generation (prime numbers)
                           discount.rate=DISCOUNT.RATE,
	  		   jitter.x=JITTER.X,
	  		   jitter.y=JITTER.Y)
          cat(paste0('Chunk ', i, ' completed\n'))
          # Remove constant parameters
          # for(col in names(results$summary)) {n 
          #   if (length(unique(results$summary[[col]])) == 1)
          #     results$summary[[col]] <- NULL
          # }
          # Remove all strata but one for non-stratified parameters
          # par.cols <- names(results$summary)
          # for(p in param.set) {
          #   p.cols <- par.cols[endsWith(par.cols, paste0('_',p))]
          #   p.df <- results$summary[p.cols]
          #   p.is.stratified <- !all(sapply(1:ncol(p.df), function(c) all(p.df[1]==p.df[c])))
          #   if (!p.is.stratified)
          #     results$summary[p.cols[2:length(p.cols)]] <- NULL
          # }
          filename <- paste0(output.dir, '/', filename.preffix, i, '.csv')
          write.csv(results$summary, filename)
          results <- NULL
        }
  
        df.results <- data.frame()
        for(f in list.files(output.dir, pattern = paste0(filename.preffix, '\\d*.csv'))) {
          df.results <- rbind(df.results, read.csv(paste0(output.dir, '/', f)))
          unlink(paste0(output.dir, '/', f))
        }
        results <- generate.psa.summary(df.results, options$tree, options$population, POPULATION.REFERENCES[[options$population]], strat.ctx, param.set, jitter.x=JITTER.X, jitter.y=JITTER.Y)
        
        slides <- add.results.to.slide(slides, results, par)
	slides %>% print(paste0('output/psa_univariate/', options$population, '/', param.set.name, '__sd_', sd.estimate.name, '.pptx'))
          
        filename <- paste0(options$strategy.name, '__sd_', sd.estimate.name, '__par_', par)
        store.results.psa(results, 'univariate', options$population, options$display.name, filename)
      }
      
      slides %>% print(paste0('output/psa_univariate/', options$population, '/', param.set.name, '__sd_', sd.estimate.name, '.pptx'))
    }
  }
}
