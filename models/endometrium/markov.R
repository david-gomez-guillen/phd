library(CEAModel)
library(ggplot2)
library(reshape2)
library(plotly)
library(dplyr)

EPSILON <- 1e-7  # Maximum allowed error due to precision errors
DISCOUNT.RATE <- .03
PROPHYLACTIC.SURGERY.AGE <- 40  # 35-40
MENOPAUSE.AGE <- 50

LYNCH.START.AGE <- 30
LYNCH.MAX.AGE <- 70
ASYMPTOMATIC.START.AGE <- 50
ASYMPTOMATIC.MAX.AGE <- 85
BLEEDING.START.AGE <- 50
BLEEDING.MAX.AGE <- 85
COMBINED.START.AGE <- 25
COMBINED.MAX.AGE <- 80

DEFAULT.START.AGE <- list(
  asymptomatic=50,
  bleeding=50,
  lynch=25
)
DEFAULT.MAX.AGE <- list(
  asymptomatic=85,
  bleeding=85,
  lynch=60
)

POPULATION.REFERENCES <- list(
  asymptomatic='tree_asymptomatic_current',
  bleeding='tree_bleeding_current2',
  lynch='tree_lynch_current'
)

POPULATION.INITIAL.STATES <- list(
  asymptomatic='postmenopausal_asymptomatic',
  bleeding='postmenopausal_bleeding',
  lynch='lynch'
)

get.context.stratum <- function(strat.context, year) {
  ctx <- strat.context[[min(((year-25) %/% 5) + 1, length(strat.context))]]
  return(ctx)
}

get.matrix.stratum <- function(strat.matrices, year) {
  mtx <- strat.matrices[[min(((year-25) %/% 5) + 1, length(strat.matrices))]]
  return(mtx)
}

setup.markov <- function(trees, strat.ctx, costs, utilities) {
  tpMatrices <- list()
  extended.strat.ctx <- list()
  for(stratum in names(strat.ctx)) {
    context.full <- strat.ctx[[stratum]]
    context <- lapply(context.full, function(e) e[1]) # Base values
    # Assign markov probabilities according to tree outcomes
    if ('lynch' %in% names(trees)) {
      prevalence <- strat.ctx[[stratum]]$.p_cancer___lynch
      outcomes <- trees$lynch$summarize(context, prevalence=prevalence)
      
      context.undetected <- context
      context.undetected$p_cancer_stage_1 <- context.undetected$p_cancer_stage_1___delayed
      context.undetected$p_cancer_stage_2 <- context.undetected$p_cancer_stage_2___delayed
      context.undetected$p_cancer_stage_3 <- context.undetected$p_cancer_stage_3___delayed
      
      outcomes.undetected <- trees$lynch$summarize(context.undetected, prevalence=1)
# browser()      
      strat.ctx[[stratum]]$._p_hysterectomy_unnecessary_lynch <- outcomes[outcomes$name == 'no_cancer_hysterectomy', 'prob']
      if (length(strat.ctx[[stratum]]$._p_hysterectomy_unnecessary_lynch) == 0)
        strat.ctx[[stratum]]$._p_hysterectomy_unnecessary_lynch <- 0
      strat.ctx[[stratum]]$._p_hysterectomy_necessary_lynch <- sum(outcomes[outcomes$name %in% c('cancer_removed', 'cancer_s1', 'cancer_s2', 'cancer_s3', 'cancer_s4'), 'prob'])
      strat.ctx[[stratum]]$._p_hysterectomy_necessary_lynch_undetected <- sum(outcomes.undetected[outcomes.undetected$name %in% c('cancer_removed', 'cancer_s1', 'cancer_s2', 'cancer_s3', 'cancer_s4'), 'prob'])
      if (length(strat.ctx[[stratum]]$._p_hysterectomy_necessary_lynch) == 0)
        strat.ctx[[stratum]]$._p_hysterectomy_necessary_lynch <- 0
      context$p_hysterectomy_lynch <- strat.ctx[[stratum]]$._p_hysterectomy_unnecessary_lynch
      
      cancer.states <- c('cancer', 
                         'cancer_s1',
                         'cancer_s2',
                         'cancer_s3',
                         'cancer_s4'
      )
      context$p_cancer_lynch <- sum(outcomes[outcomes$name %in% cancer.states, 'prob'])
      if (length(context$p_cancer_lynch) == 0) context$p_cancer_lynch <- 0
      context$p_cancer_lynch_s1 <- sum(outcomes[outcomes$name %in% 'cancer_s1', 'prob'])
      if (length(context$p_cancer_lynch_s1) == 0) context$p_cancer_lynch_s1 <- 0
      context$p_cancer_lynch_s2 <- sum(outcomes[outcomes$name %in% 'cancer_s2', 'prob'])
      if (length(context$p_cancer_lynch_s2) == 0) context$p_cancer_lynch_s2 <- 0
      context$p_cancer_lynch_s3 <- sum(outcomes[outcomes$name %in% 'cancer_s3', 'prob'])
      if (length(context$p_cancer_lynch_s3) == 0) context$p_cancer_lynch_s3 <- 0
      context$p_cancer_lynch_s4 <- sum(outcomes[outcomes$name %in% 'cancer_s4', 'prob'])
      if (length(context$p_cancer_lynch_s4) == 0) context$p_cancer_lynch_s4 <- 0
      
      # Calculate probabilities for cancer detection in previously undetected cancers
      context$p_cancer_lynch_s1_undetected <- sum(outcomes.undetected[outcomes.undetected$name %in% 'cancer_s1', 'prob'])
      if (length(context$p_cancer_lynch_s1_undetected) == 0) context$p_cancer_lynch_s1_undetected <- 0
      context$p_cancer_lynch_s2_undetected <- sum(outcomes.undetected[outcomes.undetected$name %in% 'cancer_s2', 'prob'])
      if (length(context$p_cancer_lynch_s2_undetected) == 0) context$p_cancer_lynch_s2_undetected <- 0
      context$p_cancer_lynch_s3_undetected <- sum(outcomes.undetected[outcomes.undetected$name %in% 'cancer_s3', 'prob'])
      if (length(context$p_cancer_lynch_s3_undetected) == 0) context$p_cancer_lynch_s3_undetected <- 0
      context$p_cancer_lynch_s4_undetected <- sum(outcomes.undetected[outcomes.undetected$name %in% 'cancer_s4', 'prob'])
      if (length(context$p_cancer_lynch_s4_undetected) == 0) context$p_cancer_lynch_s4_undetected <- 0
      context$p_cancer_lynch_undetected <- sum(outcomes.undetected[outcomes.undetected$name %in% cancer.states, 'prob'])
      if (length(context$p_cancer_lynch_undetected) == 0) context$p_cancer_lynch_undetected <- 0
      
      context$p_undetected_cancer_lynch <- sum(outcomes[outcomes$name %in% c('undetected_cancer_discharge', 
                                                                                'undetected_cancer_evaluation'), 'prob'])
      if (length(context$p_undetected_cancer_lynch) == 0) context$p_undetected_cancer_lynch <- 0
      
      context$p_discharge <- 0 # Only discharged for three years in asymptomatic
      context$p_death_cancer_bleeding <- 0
      context$p_undetected_cancer_bleeding <- 0
      context$p_undetected_cancer_bleeding_endo_thin <- 0
      context$p_evaluation_bleeding_endo_thin_undetected <- 0
      lynch.cost <- weighted.mean(outcomes$cost, outcomes$prob)
    } else {
      context$p_hysterectomy_lynch <- 0
      context$p_cancer_lynch <- 0
      context$p_cancer_lynch_s1 <- 0
      context$p_cancer_lynch_s2 <- 0
      context$p_cancer_lynch_s3 <- 0
      context$p_cancer_lynch_s4 <- 0
      context$p_death_cancer_lynch <- 0
      context$p_evaluation_bleeding_endo_thin <- 0
      context$p_cancer_bleeding_endo_thin <- 0
      context$p_hysterectomy_bleeding_endo_thin <- 0
      lynch.cost <- 0
    } 
    if ('asymptomatic' %in% names(trees)) {
      prevalence <- strat.ctx[[stratum]]$.p_cancer___asymptomatic
      outcomes <- trees$asymptomatic$summarize(context, prevalence=prevalence)
      strat.ctx[[stratum]]$._p_hysterectomy_unnecessary_asymptomatic <- outcomes[outcomes$name == 'no_cancer_hysterectomy', 'prob']
      strat.ctx[[stratum]]$._p_hysterectomy_necessary_asymptomatic <- outcomes[outcomes$name == 'cancer_removed', 'prob']
      context$p_hysterectomy_asymptomatic <- strat.ctx[[stratum]]$._p_hysterectomy_unnecessary_asymptomatic + strat.ctx[[stratum]]$._p_hysterectomy_necessary_asymptomatic
      
      cancer.states <- c('cancer', 'undetected_cancer_discharge', 'undetected_cancer_evaluation')
      context$p_cancer_asymptomatic <- sum(outcomes[outcomes$name %in% cancer.states, 'prob'])
      context$p_cancer_asymptomatic_s1 <- sum(outcomes[outcomes$name %in% 'cancer_removed', 'prob'])
      context$p_cancer_asymptomatic_s2 <- sum(outcomes[outcomes$name %in% 'cancer', 'prob']) * context$.p_cancer_stage_2 / p_cancer_s2_4
      context$p_cancer_asymptomatic_s3 <- sum(outcomes[outcomes$name %in% 'cancer', 'prob']) * context$.p_cancer_stage_3 / p_cancer_s2_4
      context$p_cancer_asymptomatic_s4 <- sum(outcomes[outcomes$name %in% 'cancer', 'prob']) * (1 - (context$.p_cancer_stage_2 +
                                                                                                       context$.p_cancer_stage_3) / p_cancer_s2_4)
      
      discharge.states <- c('no_cancer_discharge')
      context$p_discharge <- sum(outcomes[outcomes$name %in% discharge.states, 'prob'])
      context$p_death_cancer_asymptomatic <- 0
      asymptomatic.cost <- weighted.mean(outcomes$cost, outcomes$prob)
    } else {
      context$p_hysterectomy_asymptomatic <- 0
      context$p_cancer_asymptomatic <- 0
      context$p_cancer_asymptomatic_s1 <- 0
      context$p_cancer_asymptomatic_s2 <- 0
      context$p_cancer_asymptomatic_s3 <- 0
      context$p_cancer_asymptomatic_s4 <- 0
      context$p_death_cancer_asymptomatic <- 0
      context$p_evaluation_bleeding_endo_thin <- 0
      context$p_cancer_bleeding_endo_thin <- 0
      context$p_hysterectomy_bleeding_endo_thin <- 0
      asymptomatic.cost <- 0
    }
    if ('bleeding' %in% names(trees)) {
      prevalence <- strat.ctx[[stratum]]$.p_cancer___bleeding
      if (trees$bleeding$name == 'tree_bleeding_molecular2_perfect') {
        outcomes <- tree_bleeding_molecular2$summarize(context, prevalence=prevalence)
        outcomes[outcomes$name == 'no_cancer_evaluation', 'prob'] <-
          outcomes[outcomes$name == 'no_cancer_evaluation', 'prob'] +
          outcomes[outcomes$name == 'no_cancer_hysterectomy', 'prob']
        outcomes[outcomes$name == 'no_cancer_hysterectomy', 'prob'] <- 0
      } else {
        outcomes <- trees$bleeding$summarize(context, prevalence=prevalence)
      }
      context.undetected <- context
      context.undetected$p_cancer_stage_1 <- context.undetected$p_cancer_stage_1___delayed
      context.undetected$p_cancer_stage_2 <- context.undetected$p_cancer_stage_2___delayed
      context.undetected$p_cancer_stage_3 <- context.undetected$p_cancer_stage_3___delayed
      if (trees$bleeding$name == 'tree_bleeding_molecular2_perfect') {
        outcomes.undetected <- tree_bleeding_molecular2$summarize(context.undetected, prevalence=1) # Outcomes for the previously undetected cancers (so prevalence=100%)
      } else {
        outcomes.undetected <- trees$bleeding$summarize(context.undetected, prevalence=1) # Outcomes for the previously undetected cancers (so prevalence=100%)
      }
      # TODO: Replicate for other populations
      strat.ctx[[stratum]]$._p_hysterectomy_unnecessary_bleeding <- outcomes[outcomes$name == 'no_cancer_hysterectomy', 'prob']
      if (length(strat.ctx[[stratum]]$._p_hysterectomy_unnecessary_bleeding) == 0)
        strat.ctx[[stratum]]$._p_hysterectomy_unnecessary_bleeding <- 0
      strat.ctx[[stratum]]$._p_hysterectomy_necessary_bleeding <- sum(outcomes[outcomes$name %in% c('cancer_removed', 'cancer_s1', 'cancer_s2', 'cancer_s3', 'cancer_s4'), 'prob'])
      strat.ctx[[stratum]]$._p_hysterectomy_necessary_bleeding_undetected <- sum(outcomes.undetected[outcomes.undetected$name %in% c('cancer_removed', 'cancer_s1', 'cancer_s2', 'cancer_s3', 'cancer_s4'), 'prob'])
      if (length(strat.ctx[[stratum]]$._p_hysterectomy_necessary_bleeding) == 0)
        strat.ctx[[stratum]]$._p_hysterectomy_necessary_bleeding <- 0
      context$p_hysterectomy_bleeding <- strat.ctx[[stratum]]$._p_hysterectomy_unnecessary_bleeding
      
      cancer.states <- c('cancer', 
                         'cancer_s1',
                         'cancer_s2',
                         'cancer_s3',
                         'cancer_s4'
                         # 'undetected_cancer_discharge', 
                         # 'undetected_cancer_evaluation', 
                         # 'undetected_cancer_evaluation_bleeding_endo_thin'
                         )
      context$p_cancer_bleeding <- sum(outcomes[outcomes$name %in% cancer.states, 'prob'])
      if (length(context$p_cancer_bleeding) == 0) context$p_cancer_bleeding <- 0
      context$p_cancer_bleeding_s1 <- sum(outcomes[outcomes$name %in% 'cancer_s1', 'prob'])
      if (length(context$p_cancer_bleeding_s1) == 0) context$p_cancer_bleeding_s1 <- 0
      context$p_cancer_bleeding_s2 <- sum(outcomes[outcomes$name %in% 'cancer_s2', 'prob'])
      if (length(context$p_cancer_bleeding_s2) == 0) context$p_cancer_bleeding_s2 <- 0
      context$p_cancer_bleeding_s3 <- sum(outcomes[outcomes$name %in% 'cancer_s3', 'prob'])
      if (length(context$p_cancer_bleeding_s3) == 0) context$p_cancer_bleeding_s3 <- 0
      context$p_cancer_bleeding_s4 <- sum(outcomes[outcomes$name %in% 'cancer_s4', 'prob'])
      if (length(context$p_cancer_bleeding_s4) == 0) context$p_cancer_bleeding_s4 <- 0
      
      # Calculate probabilities for cancer detection in previously undetected cancers
      context$p_cancer_bleeding_s1_undetected <- sum(outcomes.undetected[outcomes.undetected$name %in% 'cancer_s1', 'prob'])
      if (length(context$p_cancer_bleeding_s1_undetected) == 0) context$p_cancer_bleeding_s1_undetected <- 0
      context$p_cancer_bleeding_s2_undetected <- sum(outcomes.undetected[outcomes.undetected$name %in% 'cancer_s2', 'prob'])
      if (length(context$p_cancer_bleeding_s2_undetected) == 0) context$p_cancer_bleeding_s2_undetected <- 0
      context$p_cancer_bleeding_s3_undetected <- sum(outcomes.undetected[outcomes.undetected$name %in% 'cancer_s3', 'prob'])
      if (length(context$p_cancer_bleeding_s3_undetected) == 0) context$p_cancer_bleeding_s3_undetected <- 0
      context$p_cancer_bleeding_s4_undetected <- sum(outcomes.undetected[outcomes.undetected$name %in% 'cancer_s4', 'prob'])
      if (length(context$p_cancer_bleeding_s4_undetected) == 0) context$p_cancer_bleeding_s4_undetected <- 0
      context$p_cancer_bleeding_undetected <- sum(outcomes.undetected[outcomes.undetected$name %in% cancer.states, 'prob'])
      if (length(context$p_cancer_bleeding_undetected) == 0) context$p_cancer_bleeding_undetected <- 0
      
      context$p_undetected_cancer_bleeding <- sum(outcomes[outcomes$name %in% c('undetected_cancer_discharge', 
                                                                                'undetected_cancer_evaluation', 
                                                                                'undetected_cancer_evaluation_bleeding_endo_thin'), 'prob'])
      if (length(context$p_undetected_cancer_bleeding) == 0) context$p_undetected_cancer_bleeding <- 0
      
      context$p_discharge <- 0 # Only discharged for three years in asymptomatic
      context$p_evaluation_bleeding_endo_thin <- outcomes[outcomes$name=='no_cancer_evaluation_bleeding_endo_thin', 'prob']
      if (length(context$p_evaluation_bleeding_endo_thin) == 0) context$p_evaluation_bleeding_endo_thin <- 0
      context$p_evaluation_bleeding_endo_thin_undetected <- outcomes.undetected[outcomes.undetected$name=='no_cancer_evaluation_bleeding_endo_thin', 'prob']
      if (length(context$p_evaluation_bleeding_endo_thin_undetected) == 0) context$p_evaluation_bleeding_endo_thin_undetected <- 0
      context$p_death_cancer_bleeding <- 0
      bleeding.cost <- weighted.mean(outcomes$cost, outcomes$prob)
      
      if (trees$bleeding$name == 'tree_bleeding_current') {
        # TODO: Generalize
        tree_endo_thin <- tree_bleeding_current_endo_thin
        tn <- outcomes[outcomes$name == 'no_cancer_evaluation_bleeding_endo_thin',]
        fp <- outcomes[outcomes$name == 'undetected_cancer_evaluation_bleeding_endo_thin',]
        prevalence <- fp / (fp + tn)
        outcomes <- tree_endo_thin$summarize(context, prevalence=prevalence)
        outcomes.undetected <- tree_endo_thin$summarize(context.undetected, prevalence=1) # Outcomes for the previously undetected cancers (so prevalence=100%)
        strat.ctx[[stratum]]$._p_hysterectomy_unnecessary_bleeding_endo_thin <- outcomes[outcomes$name == 'no_cancer_hysterectomy', 'prob']
        strat.ctx[[stratum]]$._p_hysterectomy_necessary_bleeding_endo_thin <- sum(outcomes[outcomes$name %in% c('cancer_removed', 'cancer_s1', 'cancer_s2', 'cancer_s3', 'cancer_s4'), 'prob'])
        strat.ctx[[stratum]]$._p_hysterectomy_necessary_bleeding_endo_thin_undetected <- sum(outcomes.undetected[outcomes.undetected$name %in% c('cancer_removed', 'cancer_s1', 'cancer_s2', 'cancer_s3', 'cancer_s4'), 'prob'])
        context$p_hysterectomy_bleeding_endo_thin <- strat.ctx[[stratum]]$._p_hysterectomy_unnecessary_bleeding_endo_thin #+ strat.ctx[[stratum]]$._p_hysterectomy_necessary_bleeding_endo_thin
        
        # cancer.states <- c('cancer', 'undetected_cancer_discharge', 'undetected_cancer_evaluation')
        context$p_cancer_bleeding_endo_thin <- sum(outcomes[outcomes$name %in% cancer.states, 'prob'])
        context$p_cancer_bleeding_endo_thin_s1 <- sum(outcomes[outcomes$name %in% 'cancer_s1', 'prob'])
        context$p_cancer_bleeding_endo_thin_s2 <- sum(outcomes[outcomes$name %in% 'cancer_s2', 'prob'])
        context$p_cancer_bleeding_endo_thin_s3 <- sum(outcomes[outcomes$name %in% 'cancer_s3', 'prob'])
        context$p_cancer_bleeding_endo_thin_s4 <- sum(outcomes[outcomes$name %in% 'cancer_s4', 'prob'])
        context$p_undetected_cancer_bleeding_endo_thin <- sum(outcomes[outcomes$name %in% c('undetected_cancer_discharge', 
                                                                                            'undetected_cancer_evaluation', 
                                                                                            'undetected_cancer_evaluation_bleeding_endo_thin'), 'prob'])
        context$p_cancer_bleeding_endo_thin_undetected <- sum(outcomes.undetected[outcomes.undetected$name %in% cancer.states, 'prob'])
        context$p_cancer_bleeding_endo_thin_s1_undetected <- sum(outcomes.undetected[outcomes.undetected$name %in% 'cancer_s1', 'prob'])
        context$p_cancer_bleeding_endo_thin_s2_undetected <- sum(outcomes.undetected[outcomes.undetected$name %in% 'cancer_s2', 'prob'])
        context$p_cancer_bleeding_endo_thin_s3_undetected <- sum(outcomes.undetected[outcomes.undetected$name %in% 'cancer_s3', 'prob'])
        context$p_cancer_bleeding_endo_thin_s4_undetected <- sum(outcomes.undetected[outcomes.undetected$name %in% 'cancer_s4', 'prob'])
        
        context$p_death_cancer_bleeding <- 0
        bleeding.cost <- bleeding.cost + weighted.mean(outcomes$cost, outcomes$prob)
      } else if (trees$bleeding$name == 'tree_bleeding_current2') {
        # TODO: Generalize
        tree_endo_thin2 <- tree_bleeding_current_endo_thin2
        tn <- outcomes[outcomes$name == 'no_cancer_evaluation_bleeding_endo_thin','prob']
        fp <- outcomes[outcomes$name == 'undetected_cancer_evaluation_bleeding_endo_thin','prob']
        prevalence <- fp / (fp + tn)
        outcomes <- tree_endo_thin2$summarize(context, prevalence=prevalence)
        outcomes.undetected <- tree_endo_thin2$summarize(context.undetected, prevalence=1) # Outcomes for the previously undetected cancers (so prevalence=100%)
        strat.ctx[[stratum]]$._p_hysterectomy_unnecessary_bleeding_endo_thin <- outcomes[outcomes$name == 'no_cancer_hysterectomy', 'prob']
        strat.ctx[[stratum]]$._p_hysterectomy_necessary_bleeding_endo_thin <- sum(outcomes[outcomes$name %in% c('cancer_removed', 'cancer_s1', 'cancer_s2', 'cancer_s3', 'cancer_s4'), 'prob'])
        strat.ctx[[stratum]]$._p_hysterectomy_necessary_bleeding_endo_thin_undetected <- sum(outcomes.undetected[outcomes.undetected$name %in% c('cancer_removed', 'cancer_s1', 'cancer_s2', 'cancer_s3', 'cancer_s4'), 'prob'])
        context$p_hysterectomy_bleeding_endo_thin <- strat.ctx[[stratum]]$._p_hysterectomy_unnecessary_bleeding_endo_thin #+ strat.ctx[[stratum]]$._p_hysterectomy_necessary_bleeding_endo_thin
        
        # cancer.states <- c('cancer', 'undetected_cancer_discharge', 'undetected_cancer_evaluation')
        context$p_cancer_bleeding_endo_thin <- sum(outcomes[outcomes$name %in% cancer.states, 'prob'])
        context$p_cancer_bleeding_endo_thin_s1 <- sum(outcomes[outcomes$name %in% 'cancer_s1', 'prob'])
        context$p_cancer_bleeding_endo_thin_s2 <- sum(outcomes[outcomes$name %in% 'cancer_s2', 'prob'])
        context$p_cancer_bleeding_endo_thin_s3 <- sum(outcomes[outcomes$name %in% 'cancer_s3', 'prob'])
        context$p_cancer_bleeding_endo_thin_s4 <- sum(outcomes[outcomes$name %in% 'cancer_s4', 'prob'])
        context$p_undetected_cancer_bleeding_endo_thin <- sum(outcomes[outcomes$name %in% c('undetected_cancer_discharge', 
                                                                                            'undetected_cancer_evaluation', 
                                                                                            'undetected_cancer_evaluation_bleeding_endo_thin'), 'prob'])
        context$p_cancer_bleeding_endo_thin_undetected <- sum(outcomes.undetected[outcomes.undetected$name %in% cancer.states, 'prob'])
        context$p_cancer_bleeding_endo_thin_s1_undetected <- sum(outcomes.undetected[outcomes.undetected$name %in% 'cancer_s1', 'prob'])
        context$p_cancer_bleeding_endo_thin_s2_undetected <- sum(outcomes.undetected[outcomes.undetected$name %in% 'cancer_s2', 'prob'])
        context$p_cancer_bleeding_endo_thin_s3_undetected <- sum(outcomes.undetected[outcomes.undetected$name %in% 'cancer_s3', 'prob'])
        context$p_cancer_bleeding_endo_thin_s4_undetected <- sum(outcomes.undetected[outcomes.undetected$name %in% 'cancer_s4', 'prob'])
        
        context$p_death_cancer_bleeding <- 0
        bleeding.cost <- bleeding.cost + weighted.mean(outcomes$cost, outcomes$prob)
      } else{
        context$p_cancer_bleeding_endo_thin <- 0
        context$p_cancer_bleeding_endo_thin_s1 <- 0
        context$p_cancer_bleeding_endo_thin_s2 <- 0
        context$p_cancer_bleeding_endo_thin_s3 <- 0
        context$p_cancer_bleeding_endo_thin_s4 <- 0
        context$p_cancer_bleeding_endo_thin_undetected <- 0
        context$p_cancer_bleeding_endo_thin_s1_undetected <- 0
        context$p_cancer_bleeding_endo_thin_s2_undetected <- 0
        context$p_cancer_bleeding_endo_thin_s3_undetected <- 0
        context$p_cancer_bleeding_endo_thin_s4_undetected <- 0
        context$p_undetected_cancer_bleeding_endo_thin <- 0
        context$p_hysterectomy_bleeding_endo_thin <- 0
        context$._p_hysterectomy_unnecessary_bleeding_endo_thin <- 0
        context$._p_hysterectomy_necessary_bleeding_endo_thin <- 0
        context$._p_hysterectomy_necessary_bleeding_endo_thin_undetected <- 0
      }
    } else {
      context$p_hysterectomy_bleeding <- 0
      context$._p_hysterectomy_necessary_bleeding_undetected <- 0
      context$p_hysterectomy_bleeding_endo_thin <- 0
      context$._p_hysterectomy_necessary_bleeding_endo_thin_undetected <- 0
      context$p_cancer_bleeding <- 0
      context$p_cancer_bleeding_s1 <- 0
      context$p_cancer_bleeding_s2 <- 0
      context$p_cancer_bleeding_s3 <- 0
      context$p_cancer_bleeding_s4 <- 0
      context$p_cancer_bleeding_undetected <- 0
      context$p_cancer_bleeding_s1_undetected <- 0
      context$p_cancer_bleeding_s2_undetected <- 0
      context$p_cancer_bleeding_s3_undetected <- 0
      context$p_cancer_bleeding_s4_undetected <- 0
      context$p_cancer_bleeding_endo_thin <- 0
      context$p_cancer_bleeding_endo_thin_s1 <- 0
      context$p_cancer_bleeding_endo_thin_s2 <- 0
      context$p_cancer_bleeding_endo_thin_s3 <- 0
      context$p_cancer_bleeding_endo_thin_s4 <- 0
      context$p_cancer_bleeding_endo_thin_undetected <- 0
      context$p_cancer_bleeding_endo_thin_s1_undetected <- 0
      context$p_cancer_bleeding_endo_thin_s2_undetected <- 0
      context$p_cancer_bleeding_endo_thin_s3_undetected <- 0
      context$p_cancer_bleeding_endo_thin_s4_undetected <- 0
      context$p_undetected_cancer_bleeding_endo_thin <- 0
      context$p_death_cancer_bleeding <- 0
      context$p_cancer_bleeding_endo_thin <- 0
      bleeding.cost <- 0
    }
    
    ####### TEMPORARY
    context$p_bleeding <- 0
    context$p_stop_bleeding <- 0
    #######
    extended.strat.ctx[[stratum]] <- context
    tpMatrices[[stratum]] <- markov$evaluateTpMatrix(context)
    costs[[stratum]]['postmenopausal_asymptomatic'] <- asymptomatic.cost
    costs[[stratum]]['postmenopausal_bleeding'] <- bleeding.cost
    costs[[stratum]]['lynch'] <- lynch.cost
    
    # if (trees$bleeding$name == 'tree_bleeding_hysterectomy') {
    #   row <- tpMatrices[[stratum]]$strategies['postmenopausal_bleeding',]
    #   excess.prob <- sum(row[!names(row) %in% 'postmenopausal_bleeding']) - 1
    #   tpMatrices[[stratum]]$strategies['postmenopausal_bleeding','postmenopausal_bleeding'] <- 0
    #   tpMatrices[[stratum]]$strategies['postmenopausal_bleeding','postmenopausal_hysterectomy'] <- tpMatrices[[stratum]]$strategies['postmenopausal_bleeding','postmenopausal_hysterectomy'] - excess.prob
    # }
    
    for(matrix.name in names(tpMatrices)) {
      missing.names <- mapply(function(e){if (is.na(as.numeric(e)) && e != '#') e else NA}, tpMatrices[[matrix.name]][[stratum]])
      missing.names <- missing.names[!is.na(missing.names)]
      missing.names <- missing.names[!duplicated(missing.names)]
      if (length(missing.names) > 0)
        stop(paste0('Variables are missing in matrix: ', paste0(missing.names, collapse=', ')))
    }
  }
  
  return(list(tpMatrices=tpMatrices,
              strat.ctx=extended.strat.ctx,
              costs=costs,
              utilities=utilities))
}

simulate.markov <- function(trees, 
                            markov,
                            initial.state, 
                            strat.ctx, 
                            start.age=25, 
                            max.age=60,
                            prophylactic.surgery.age=PROPHYLACTIC.SURGERY.AGE,
                            menopause.age=MENOPAUSE.AGE,
                            discount.rate=DISCOUNT.RATE,
                            plot=FALSE) {
  additional.info <- data.frame(year=start.age-1, 
                                cost=0,
                                eff=0,
                                non_cancer_hysterectomies_bleeding=0, 
                                non_cancer_hysterectomies_lynch=0, 
                                # necessary_hysterectomies=0, 
                                total_hysterectomies_bleeding=0,
                                incidence_bleeding=0,
                                incidence_s1_bleeding=0,
                                incidence_s2_bleeding=0,
                                incidence_s3_bleeding=0,
                                incidence_s4_bleeding=0,
                                undetected_cancer_bleeding=0,
                                total_hysterectomies_lynch=0,
                                incidence_lynch=0,
                                incidence_s1_lynch=0,
                                incidence_s2_lynch=0,
                                incidence_s3_lynch=0,
                                incidence_s4_lynch=0,
                                incidence_asymptomatic=0,
                                incidence_s1_asymptomatic=0,
                                incidence_s2_asymptomatic=0,
                                incidence_s3_asymptomatic=0,
                                incidence_s4_asymptomatic=0,
                                mortality=0,
                                mortality_s1=0,
                                mortality_s2=0,
                                mortality_s3=0,
                                mortality_s4=0)
  
  # ASSUMPTION: all node info is equal for all strata
  ctx <- get.context.stratum(strat.ctx, start.age)
  ctx <- lapply(ctx, function(e) e[1]) # Base values
  evaluated.markov <- markov$evaluate(ctx)
  costs <- sapply(names(strat.ctx), function(stratum) sapply(evaluated.markov$nodes, function(n)n$info$cost), simplify=FALSE, USE.NAMES=TRUE)
  utilities <- sapply(names(strat.ctx), function(stratum) sapply(evaluated.markov$nodes, function(n)n$info$outcome), simplify=FALSE, USE.NAMES=TRUE)
  
  setup.result <- setup.markov(trees, strat.ctx, costs, utilities)
  tpMatrices <- setup.result$tpMatrices
  strat.ctx <- setup.result$strat.ctx
  costs <- setup.result$costs
  utilities <- setup.result$utilities
  
  current.state <- t(initial.state)
  overall.cost <- 0
  overall.eff <- 0
  states <- data.frame()
  
  calculate.prophylactic.surgery.prob <- function(a, b, c) {
    # Using (conditional) discrete triangular distribution
    # a: lower limit
    # b: upper limit
    # c: mode
    fx <- function(x) { ifelse(x<c, ((2*(x-a))/((b-a)*(c-a))), (2*(b-x))/((b-a)*(b-c)))}
    fx.c <- rep(0, max.age)
    
    prev.p <- 0
    for(i in seq(a,b)) {
      fx.c[i] <- fx(i) / (1 - prev.p)
      prev.p <- prev.p + fx(i)
    }
    fx.c[b:max.age] <- 1
    return(fx.c)
  }
  prophylactic.ages <- full.strat.ctx$y25_29$.age_prophylactic_surgery
  prophylactic.surgery.prob <- calculate.prophylactic.surgery.prob(prophylactic.ages[2],
                                                                   prophylactic.ages[3],
                                                                   prophylactic.ages[1])
  
  for(year in seq(start.age, max.age)) {
    states <- rbind(states, current.state)
    tpMatrix <- get.matrix.stratum(tpMatrices, year)
    ctx <- get.context.stratum(strat.ctx, year)
    
    year.costs <- get.context.stratum(costs, year)
    year.utilities <- get.context.stratum(utilities, year)
    if (year == start.age) {
      year.costs['postmenopausal_bleeding'] <- year.costs['postmenopausal_bleeding'] - ctx$.c_visit + ctx$.c_first_visit
    }
    
    # if (year == ctx$.age_prophylactic_surgery) {
    #   tpMatrix$other['lynch', 'lynch_prophylactic_hysterectomy'] <- tpMatrix$other['lynch', 'lynch']
    #   tpMatrix$other['lynch', 'lynch'] <- 0
    # }
    
    if (year == menopause.age) {
      tpMatrix$other['premenopausal_asymptomatic', 'postmenopausal_asymptomatic'] <- tpMatrix$other['premenopausal_asymptomatic', 'premenopausal_asymptomatic']
      tpMatrix$other['premenopausal_asymptomatic', 'premenopausal_asymptomatic'] <- 0
    }
    
    if (strat.ctx$y25_29$.age_prophylactic_surgery != 0) {
      p_death_prophylactic_surgery <- ctx$p_death_prophylactic_surgery___lynch
      prophylactic.surgery.mortality <- prophylactic.surgery.prob[year] * p_death_prophylactic_surgery
      tpMatrix$other['lynch', 'death_other'] <- prophylactic.surgery.mortality
      tpMatrix$other['lynch', 'lynch_prophylactic_hysterectomy'] <- prophylactic.surgery.prob[year] * (1 - p_death_prophylactic_surgery)
      tpMatrix$other['lynch', 'lynch_prophylactic_hysterectomy'] <- 
        tpMatrix$other['lynch', 'lynch_prophylactic_hysterectomy'] * (1 - tpMatrix$other['lynch', 'death_other'])
      tpMatrix$other['lynch', 'lynch'] <- 1 - sum(tpMatrix$other['lynch', c('lynch_prophylactic_hysterectomy', 'death_other')])
      year.costs['lynch'] <- year.costs['lynch'] + 
        ctx$.c_prophylactic_hysterectomy * tpMatrix$other['lynch', 'lynch_prophylactic_hysterectomy'] * current.state[1,'lynch']
    }
    
    current.cost <- sum(current.state * year.costs) * (1-discount.rate)^(year-start.age)
    overall.cost <- overall.cost + current.cost
    current.eff <- sum(current.state * year.utilities) * (1-discount.rate)^(year-start.age)
    overall.eff <- overall.eff + current.eff
    
# TODO: Generalize
custom.data.extractor <- function(additional.info, current.state, tpMatrix, cost, eff, ctx) {
  non_cancer_hysterectomies_bleeding <- current.state[,'postmenopausal_bleeding'][[1]] * ctx$p_hysterectomy_bleeding +
             current.state[,'postmenopausal_bleeding_endo_thin'][[1]] * ctx$p_hysterectomy_bleeding_endo_thin
  # necessary_hysterectomies <- current.state[,'postmenopausal_bleeding'][[1]] * ctx$p_cancer_bleeding +
  #     current.state[,'postmenopausal_bleeding_endo_thin'][[1]] * ctx$p_cancer_bleeding_endo_thin +
  #     current.state[,'undetected_cancer_bleeding'][[1]] * ctx$p_cancer_bleeding_undetected +
  #     current.state[,'undetected_cancer_bleeding_endo_thin'][[1]] * ctx$p_cancer_bleeding_endo_thin_undetected
  
  non_cancer_hysterectomies_lynch <- current.state[,'lynch'][[1]] * ctx$p_hysterectomy_lynch
  
  if ('endometrial_cancer' %in% colnames(tpMatrix$strategies)) {
    incidence_bleeding <- current.state[, 'postmenopausal_bleeding'] * tpMatrix$strategies['postmenopausal_bleeding', 'endometrial_cancer'] +
      current.state[, 'postmenopausal_bleeding_endo_thin'] * tpMatrix$strategies['postmenopausal_bleeding_endo_thin', 'endometrial_cancer']
    incidence_s1_bleeding <- NULL
    incidence_s2_bleeding <- NULL
    incidence_s3_bleeding <- NULL
    incidence_s4_bleeding <- NULL
    
    mortality_bleeding <- current.state[, 'endometrial_cancer'] * tpMatrix$strategies['endometrial_cancer', 'death_cancer']
    mortality_s1_bleeding <- NULL
    mortality_s2_bleeding <- NULL
    mortality_s3_bleeding <- NULL
    mortality_s4_bleeding <- NULL
  } else {
    # BLEEDING
    incidence_s1_bleeding <- current.state[, 'postmenopausal_bleeding'][[1]] * sum(tpMatrix$strategies['postmenopausal_bleeding', 'endometrial_cancer_s1']) +
      current.state[, 'postmenopausal_bleeding_endo_thin'][[1]] * sum(tpMatrix$strategies['postmenopausal_bleeding_endo_thin', 'endometrial_cancer_s1']) +
      current.state[, 'undetected_cancer_bleeding'][[1]] * sum(tpMatrix$strategies['undetected_cancer_bleeding', 'endometrial_cancer_s1']) +
      current.state[, 'undetected_cancer_bleeding_endo_thin'][[1]] * sum(tpMatrix$strategies['undetected_cancer_bleeding_endo_thin', 'endometrial_cancer_s1'])
    
    incidence_s2_bleeding <- current.state[, 'postmenopausal_bleeding'][[1]] * sum(tpMatrix$strategies['postmenopausal_bleeding', 'endometrial_cancer_s2']) +
      current.state[, 'postmenopausal_bleeding_endo_thin'][[1]] * sum(tpMatrix$strategies['postmenopausal_bleeding_endo_thin', 'endometrial_cancer_s2']) +
      current.state[, 'undetected_cancer_bleeding'][[1]] * sum(tpMatrix$strategies['undetected_cancer_bleeding', 'endometrial_cancer_s2']) +
      current.state[, 'undetected_cancer_bleeding_endo_thin'][[1]] * sum(tpMatrix$strategies['undetected_cancer_bleeding_endo_thin', 'endometrial_cancer_s2'])
    
    incidence_s3_bleeding <- current.state[, 'postmenopausal_bleeding'][[1]] * sum(tpMatrix$strategies['postmenopausal_bleeding', 'endometrial_cancer_s3']) +
      current.state[, 'postmenopausal_bleeding_endo_thin'][[1]] * sum(tpMatrix$strategies['postmenopausal_bleeding_endo_thin', 'endometrial_cancer_s3']) +
      current.state[, 'undetected_cancer_bleeding'][[1]] * sum(tpMatrix$strategies['undetected_cancer_bleeding', 'endometrial_cancer_s3']) +
      current.state[, 'undetected_cancer_bleeding_endo_thin'][[1]] * sum(tpMatrix$strategies['undetected_cancer_bleeding_endo_thin', 'endometrial_cancer_s3'])
    
    incidence_s4_bleeding <- current.state[, 'postmenopausal_bleeding'][[1]] * sum(tpMatrix$strategies['postmenopausal_bleeding', 'endometrial_cancer_s4']) +
      current.state[, 'postmenopausal_bleeding_endo_thin'][[1]] * sum(tpMatrix$strategies['postmenopausal_bleeding_endo_thin', 'endometrial_cancer_s4']) +
      current.state[, 'undetected_cancer_bleeding'][[1]] * sum(tpMatrix$strategies['undetected_cancer_bleeding', 'endometrial_cancer_s4']) +
      current.state[, 'undetected_cancer_bleeding_endo_thin'][[1]] * sum(tpMatrix$strategies['undetected_cancer_bleeding_endo_thin', 'endometrial_cancer_s4'])
    
    incidence_bleeding <- incidence_s1_bleeding + incidence_s2_bleeding + incidence_s3_bleeding + incidence_s4_bleeding
    
    undetected_cancer_bleeding <- current.state[, 'postmenopausal_bleeding'][[1]] * sum(tpMatrix$strategies['postmenopausal_bleeding', 'undetected_cancer_bleeding']) +
      current.state[, 'postmenopausal_bleeding_endo_thin'][[1]] * sum(tpMatrix$strategies['postmenopausal_bleeding_endo_thin', 'undetected_cancer_bleeding_endo_thin'])
    
    total_hysterectomies_bleeding <- non_cancer_hysterectomies_bleeding + incidence_bleeding
    
    # LYNCH
    incidence_s1_lynch <- current.state[, 'lynch'][[1]] * sum(tpMatrix$strategies['lynch', 'endometrial_cancer_s1']) 
    incidence_s2_lynch <- current.state[, 'lynch'][[1]] * sum(tpMatrix$strategies['lynch', 'endometrial_cancer_s2'])
    incidence_s3_lynch <- current.state[, 'lynch'][[1]] * sum(tpMatrix$strategies['lynch', 'endometrial_cancer_s3'])
    incidence_s4_lynch <- current.state[, 'lynch'][[1]] * sum(tpMatrix$strategies['lynch', 'endometrial_cancer_s4'])
    incidence_lynch <- incidence_s1_lynch + incidence_s2_lynch + incidence_s3_lynch + incidence_s4_lynch
    total_hysterectomies_lynch <- non_cancer_hysterectomies_lynch + incidence_lynch
    
    # ASYMPTOMATIC
    incidence_s1_asymptomatic <- current.state[, 'postmenopausal_asymptomatic'][[1]] * sum(tpMatrix$strategies['postmenopausal_asymptomatic', 'endometrial_cancer_s1'])
    incidence_s2_asymptomatic <- current.state[, 'postmenopausal_asymptomatic'][[1]] * sum(tpMatrix$strategies['postmenopausal_asymptomatic', 'endometrial_cancer_s2'])
    incidence_s3_asymptomatic <- current.state[, 'postmenopausal_asymptomatic'][[1]] * sum(tpMatrix$strategies['postmenopausal_asymptomatic', 'endometrial_cancer_s3'])
    incidence_s4_asymptomatic <- current.state[, 'postmenopausal_asymptomatic'][[1]] * sum(tpMatrix$strategies['postmenopausal_asymptomatic', 'endometrial_cancer_s4'])
    incidence_asymptomatic <- incidence_s1_asymptomatic + incidence_s2_asymptomatic + incidence_s3_asymptomatic + incidence_s4_asymptomatic
    
    # POOLED MORTALITY
    mortality_s1 <- current.state[, 'endometrial_cancer_s1'][[1]] * tpMatrix$other['endometrial_cancer_s1', 'death_cancer']
    mortality_s2 <- current.state[, 'endometrial_cancer_s2'][[1]] * tpMatrix$other['endometrial_cancer_s2', 'death_cancer']
    mortality_s3 <- current.state[, 'endometrial_cancer_s3'][[1]] * tpMatrix$other['endometrial_cancer_s3', 'death_cancer']
    mortality_s4 <- current.state[, 'endometrial_cancer_s4'][[1]] * tpMatrix$other['endometrial_cancer_s4', 'death_cancer']
    mortality <- mortality_s1 + mortality_s2 + mortality_s3 + mortality_s4
  }
  additional.info <- rbind(additional.info,
                           list(
                             year=year,
                             cost=cost,
                             eff=eff,
                             non_cancer_hysterectomies_bleeding=non_cancer_hysterectomies_bleeding,
                             non_cancer_hysterectomies_lynch=non_cancer_hysterectomies_lynch,
                             total_hysterectomies_bleeding=total_hysterectomies_bleeding,
                             total_hysterectomies_lynch=total_hysterectomies_lynch,
                             incidence_bleeding=incidence_bleeding,
                             incidence_s1_bleeding=incidence_s1_bleeding,
                             incidence_s2_bleeding=incidence_s2_bleeding,
                             incidence_s3_bleeding=incidence_s3_bleeding,
                             incidence_s4_bleeding=incidence_s4_bleeding,
                             undetected_cancer_bleeding=undetected_cancer_bleeding,
                             incidence_lynch=incidence_lynch,
                             incidence_s1_lynch=incidence_s1_lynch,
                             incidence_s2_lynch=incidence_s2_lynch,
                             incidence_s3_lynch=incidence_s3_lynch,
                             incidence_s4_lynch=incidence_s4_lynch,
                             incidence_asymptomatic=incidence_asymptomatic,
                             incidence_s1_asymptomatic=incidence_s1_asymptomatic,
                             incidence_s2_asymptomatic=incidence_s2_asymptomatic,
                             incidence_s3_asymptomatic=incidence_s3_asymptomatic,
                             incidence_s4_asymptomatic=incidence_s4_asymptomatic,
                             mortality=mortality,
                             mortality_s1=mortality_s1,
                             mortality_s2=mortality_s2,
                             mortality_s3=mortality_s3,
                             mortality_s4=mortality_s4))
  return(additional.info)
}

  additional.info <- custom.data.extractor(additional.info, current.state, tpMatrix, current.cost, current.eff, ctx)
    next.state <- current.state %*% tpMatrix$time_pass %*% tpMatrix$other %*% tpMatrix$strategies
    # browser()
    if (any(next.state < -EPSILON)) {
      # browser()
      print(tpMatrix)
      stop('States with negative populations, probabilities might have errors')
    }
    else if (any(next.state < 0)) {
      # ASSUMPTION: Small rounding errors, renormalize
      # TODO: Reconsider if other alternative might be better
      next.state[next.state < 0] <- 0
      next.state <- next.state / sum(next.state)
    }
    current.state <- next.state
  }
  states$age <- as.numeric(row.names(states)) + start.age - 1
  # states$postmenopausal_asymptomatic_healthy <- states$postmenopausal_asymptomatic + states$postmenopausal_asymptomatic_1y + states$postmenopausal_asymptomatic_2y
  # states$postmenopausal_asymptomatic <- NULL
  # states$postmenopausal_asymptomatic_1y <- NULL
  # states$postmenopausal_asymptomatic_2y <- NULL
  # states$survive_all <- states$survive_s1 + states$survive_s2 + states$survive_s3 + states$survive_s4
  # states$endometrial_cancer_all <- states$endometrial_cancer_s1 + states$endometrial_cancer_s2 + states$endometrial_cancer_s3 + states$endometrial_cancer_s4
  # states$death_all <- states$death_cancer + states$death_other
  # states$postmenopausal_bleeding_all <- states$postmenopausal_bleeding + states$postmenopausal_bleeding_endo_thin
  # states$postmenopausal_bleeding <- NULL
  # states$postmenopausal_bleeding_endo_thin <- NULL
  melted.states <- reshape2::melt(states, id.vars='age')
  
  strategy.name <- paste0(sapply(trees, function(t) t$name), collapse = '-')
  if (plot) {
    p <- ggplot(melted.states, aes(x=age, y=value, color=variable)) + 
      geom_line() + 
      ylim(0,1) + 
      xlab('Age') + 
      ylab('Cohort (%)') +
      ggtitle(strategy.name)
    p <- ggplotly(p)
  } else {
    p <- NULL
  }
  
  results.df <- data.frame(strategy=strategy.name,
                           C=overall.cost,
                           E=overall.eff, stringsAsFactors = FALSE)
  return(list(
    plot=p,
    states=states,
    additional.info=additional.info,
    summary=results.df
  )
  )
}

simulate <- function(type, 
                     strategies, 
                     markov, 
                     strat.ctx, 
                     initial.state, 
                     start.age, 
                     max.age, 
                     discount.rate=DISCOUNT.RATE,
                     plot=TRUE) {
  results.df <- data.frame()
  markov.outputs <- list()
  additional.info <- list()
  for(tree in strategies) {
    trees <- list()
    trees[[type]] <- tree
    result <- simulate.markov(trees, markov, initial.state, strat.ctx,
                              start.age=start.age, max.age=max.age,
                              discount.rate=discount.rate,
                              plot=plot)
    markov.outputs[[tree$name]] <- result
    additional.info[[tree$name]] <- result$additional.info
    results.df <- rbind(results.df, result$summary)
  }
  
  r <- CEAModel::analyzeCE(results.df, cost.label='€', eff.label='QALY', plot=plot)
  r$info <- markov.outputs
  return(r)
}
