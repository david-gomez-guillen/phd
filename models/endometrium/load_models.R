library(CEAModel)
library(xlsx)
library(tools)

source('distributions.R')
source('excel_params.R')

FORCE.LOAD <- F
MAX.CONTEXT.ROWS <- 10000

load.all.trees <- function() {
  trees <- list()
  for(f in list.files('models/')) {
    if (startsWith(f, 'tree_') && endsWith(f, '.yaml')) {
      name <- substr(f,1,(nchar(f) - 5))
      t <- loadDecisionTree(paste0('models/', f))
      assign(name, t, envir = .GlobalEnv)
      trees[[name]] <- t
    }
  }
  return(trees)
}

cat('Loading trees...\n')
trees <- load.all.trees()

strategies.asymptomatic <- list(tree_asymptomatic_current, tree_asymptomatic_molecular)
strategies.bleeding <- list(
                            # tree_bleeding_current,
                            tree_bleeding_current2,
                            # tree_bleeding_current_original,
                            # tree_bleeding_molecular,
                            tree_bleeding_molecular2
                            # tree_bleeding_molecular2_no_hystcp,
                            # tree_bleeding_molecular2_alt,
                            # tree_bleeding_molecular2_aggressive
                            # tree_bleeding_no_intervention,
                            # tree_bleeding_hysterectomy
                            )
strategies.lynch <- list(
                         tree_lynch_current, 
                         tree_lynch_current2, 
                         tree_lynch_molecular, 
                         # tree_lynch_molecular_b, 
                         tree_lynch_molecular2,
                         tree_lynch_no_intervention
                         )
strategies.all <- list(
                       tree_asymptomatic_current, 
                       tree_asymptomatic_molecular, 
                       tree_bleeding_current, 
                       # tree_bleeding_current_original,
                       tree_bleeding_molecular,
                       tree_bleeding_no_intervention,
                       tree_lynch_current, 
                       tree_lynch_current2, 
                       tree_lynch_molecular, 
                       tree_lynch_molecular_b, 
                       tree_lynch_molecular2,
                       tree_lynch_no_intervention)
strategies <- list(
  asymptomatic=strategies.asymptomatic,
  bleeding=strategies.bleeding,
  lynch=strategies.lynch
)

cat('Loading context...\n')

# Constraint check
constraint.check.ok <- function(ctx, stratum=NULL) {
  # if (!is.null(stratum))
  #   print(stratum)
  if (# Distribution of cancer stage must be valid
    ctx$p_cancer_stage_1 + ctx$p_cancer_stage_2 + ctx$p_cancer_stage_3 > 1
    # Overall probability of death must be <= 1
    || ctx$p_death_cancer_s1 + ctx$p_death_other > 1
    || ctx$p_death_cancer_s2 + ctx$p_death_other > 1
    || ctx$p_death_cancer_s3 + ctx$p_death_other > 1
    || ctx$p_death_cancer_s4 + ctx$p_death_other > 1
    || ctx$p_recurrence_s1 + ctx$p_death_other > 1
    || ctx$p_recurrence_s2 + ctx$p_death_other > 1
    || ctx$p_recurrence_s3 + ctx$p_death_other > 1
    || ctx$p_recurrence_s4 + ctx$p_death_other > 1
    # Recurrence rates for cancer stages must be non-decreasing
    # || ctx$.rate_recurrence_s1 > ctx$.rate_recurrence_s2
    # || ctx$.rate_recurrence_s2 > ctx$.rate_recurrence_s3
    # || ctx$.rate_recurrence_s3 > ctx$.rate_recurrence_s4 
    # Utilities must be coherent
    # || ctx$u_bleeding < ctx$u_hysterectomy
    # || ctx$u_hysterectomy < ctx$u_survive_s1
    # || ctx$u_cancer_s1 < ctx$u_cancer_s2
    # || ctx$u_cancer_s2 < ctx$u_cancer_s3
    # || ctx$u_cancer_s3 < ctx$u_cancer_s4
    # Survival rates for cancer stages must be non-increasing
    # || ctx$.survival_5year_s1 < ctx$.survival_5year_s2
    # || ctx$.survival_5year_s2 < ctx$.survival_5year_s3
    # || ctx$.survival_5year_s3 < ctx$.survival_5year_s4
  ) {
    return(FALSE)
  }
  return(TRUE)
}

# Context loading
context.setup <- function(strat.ctx) {
  strat.ctx <- lapply(strat.ctx, function(ctx) {
    # Assuming exponential distribution for cancer death
    # 5-year survival -> P(X>5)=exp(-5*lambda)
    ctx$._lambda_survival <- -log(ctx$`.survival_5year`[1])/5
    
    # Given memoryless property, conditional probability is constant and independent of cancer history
    # p_death_cancer = P(i-1 < X < i | X > i-1) = P(X < 1)
    ctx$p_death_cancer <- 1 - exp(-ctx$._lambda_survival)
    ctx$p_death_cancer__lynch <- ctx$p_death_cancer
    
    # ctx$p_death_cancer <- exp(-ctx$.survival_5year*5)
    
    if (constraint.check.ok(ctx)) {
      # print('Valid context')
      return(ctx)
    } else {
      # print('Invalid context, returning null')
      return(NULL)
    }
    return(ctx)
  })
  
  if (any(sapply(strat.ctx, is.null))) {
    return(NULL)
  } else {
    return(strat.ctx)
  }
}

strat.ctx.path <- 'params/context.xlsx'
strat.ctx.hash.file <- paste0(strat.ctx.path, '.hash')
if (!FORCE.LOAD && file.exists(strat.ctx.hash.file) && readLines(strat.ctx.hash.file) == md5sum(strat.ctx.path)) {
  full.strat.ctx <- readRDS('params/_full.strat.ctx.RData')
  excel.strata.df <- readRDS('params/_excel.strata.df.RData')
  excel.strata.df.full <- readRDS('params/_excel.strata.df.full.RData')
  strat.ctx <- readRDS('params/_strat.ctx.RData')
} else {
  full.strat.ctx <- loadStratifiedContextFile(strat.ctx.path)
  excel.strata.df <- list()
  excel.strata.df.full <- list()
  .strata <- names(xlsx::getSheets(xlsx::loadWorkbook(strat.ctx.path)))
  cat(' Loading strata: ')
  for(stratum in .strata) {
    cat(stratum)
    if (stratum != .strata[length(.strata)]) cat(', ')
    excel.strata.df.full[[stratum]] <- read.xlsx(strat.ctx.path, sheetName = stratum, keepFormulas = T, endRow=MAX.CONTEXT.ROWS)
    excel.strata.df[[stratum]] <- excel.strata.df.full[[stratum]][,c(1,2)]
  }
  cat('\n')
  strat.ctx <- refresh.context(c(), full.strat.ctx, excel.strata.df, context.setup)
  
  # Save data for faster loading next time if unchanged
  saveRDS(full.strat.ctx, file='params/_full.strat.ctx.RData')
  saveRDS(excel.strata.df, file='params/_excel.strata.df.RData')
  saveRDS(excel.strata.df.full, file='params/_excel.strata.df.full.RData')
  saveRDS(strat.ctx, file='params/_strat.ctx.RData')
  cat(paste0(md5sum(strat.ctx.path), '\n'), file=strat.ctx.hash.file)
}

calib.strat.ctx.path <- 'params/context_calib.xlsx'
calib.strat.ctx.hash.file <- paste0(calib.strat.ctx.path, '.hash')
if (file.exists(calib.strat.ctx.path)) {
  if (file.exists(calib.strat.ctx.hash.file) && readLines(calib.strat.ctx.hash.file) == md5sum(calib.strat.ctx.path)) {
    calib.full.strat.ctx <- readRDS('params/_calib.full.strat.ctx.RData')
    calib.excel.strata.df <- readRDS('params/_calib.excel.strata.df.RData')
    calib.excel.strata.df.full <- readRDS('params/_calib.excel.strata.df.full.RData')
    calib.strat.ctx <- readRDS('params/_calib.strat.ctx.RData')
  } else {
    calib.full.strat.ctx <- loadStratifiedContextFile(calib.strat.ctx.path)
    calib.excel.strata.df <- list()
    calib.excel.strata.df.full <- list()
    .strata <- names(xlsx::getSheets(xlsx::loadWorkbook(calib.strat.ctx.path)))
    for(stratum in .strata) {
      calib.excel.strata.df.full[[stratum]] <- read.xlsx(calib.strat.ctx.path, sheetName = stratum, keepFormulas = T, endRow=MAX.CONTEXT.ROWS)
      calib.excel.strata.df[[stratum]] <- calib.excel.strata.df.full[[stratum]][,c(1,2)]
    }
    calib.strat.ctx <- refresh.context(c(), calib.full.strat.ctx, calib.excel.strata.df, context.setup)
    
    # Save data for faster loading next time if unchanged
    saveRDS(calib.full.strat.ctx, file='params/_calib.full.strat.ctx.RData')
    saveRDS(calib.excel.strata.df, file='params/_calib.excel.strata.df.RData')
    saveRDS(calib.excel.strata.df.full, file='params/_calib.excel.strata.df.full.RData')
    saveRDS(calib.strat.ctx, file='params/_calib.strat.ctx.RData')
    cat(paste0(md5sum(calib.strat.ctx.path), '\n'), file=calib.strat.ctx.hash.file)
  }
} else {
  suppressWarnings({
    rm('calib.full.strat.ctx')
    rm('calib.excel.strata.df')
    rm('calib.excel.strata.df.full')
    rm('calib.strat.ctx')
  })
}

base.ctx <- lapply(strat.ctx[[1]], function(l)l[1])

independent.pars <- getIndependentParameters(strat.ctx.path)

cat('Loading markov model...\n')
markov <- loadMarkovModels('models/markov.xlsx')
