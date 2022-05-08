library(xlsx)
library(stringr)
library(data.table)

get.recalculated.params <- function(df, param, value) {
  # TODO: Optimize
  # df <- xlsx::read.xlsx(file, sheetIndex = 1, keepFormulas = T)
  df[,2] <- as.character(df[,2])
  names(df) <- c('par', 'value')
  df[df$par %in% param, 2] <- value
  
  df <- recalculate.formulas(df)
  return(df[,c('par', 'value')])
}

recalculate.formulas <- function(df) {
  # TODO: Optimize!!!
  ls <- str_extract_all(df$value, '([a-zA-Z]+?)')
  ns <- str_extract_all(df$value, '([0-9]+)')
  vs <- str_extract_all(df$value, '\\$?([a-zA-Z]+)\\$?([0-9]+)')
  
  n.formulas.to.solve <- sum(sapply(vs, function(x)length(x)))
  while (n.formulas.to.solve > 0) {
    for (i in seq_along(vs)) {
      if (length(vs[[i]]) > 0) {
        for(j in seq_along(vs[[i]])) {
          col <- match(toupper(str_extract(vs[[i]][j], '[a-zA-Z]+')), LETTERS)
          row <- as.numeric(str_extract(vs[[i]][j], '[0-9]+')) - 1 
          value <- df[row, col]
          df$value[i] <- gsub(paste0(gsub('\\$', '\\\\$', vs[[i]][j]), '(?=[^0-9]|$)'), paste0('(', value, ')'), df$value[i], perl=TRUE)
        }
      }
    }
    
    ls <- str_extract_all(df$value, '([a-zA-Z]+?)')
    ns <- str_extract_all(df$value, '([0-9]+)')
    vs <- str_extract_all(df$value, '\\$?([a-zA-Z]+)\\$?([0-9]+)')
    if (n.formulas.to.solve == sum(sapply(vs, function(x)length(x)))) {
      stop('Can\'t solve some formulas, please check the excel file')
    } else {
      n.formulas.to.solve <- sum(sapply(vs, function(x)length(x)))
    }
  }
  
  for (i in seq_along(df$value)) {
    fml <- tolower(df$value[i])  # tolower to parse excel functions (MAX -> max)
    tryCatch(df$value[i] <- eval(parse(text=fml)), error=function(e) {
      # TODO: Handle more generally
      df$value[i] <<- 0
      warning(paste0('Formula on parameter ', df$par[i], ' cannot be evaluated. Check if the formula ',
                   'is correct first, otherwise maybe the value does not make sense given the sampled ',
                   'parameters (e.g. p(A|B) given p(B)=0). For now we assume 0 for this last case.'))
    })
  }
  df$value <- as.numeric(df$value)
  return(df)
}

refresh.context <- function(pars, strat.ctx, excel.strata.df, context.setup.func=NULL) {
  refreshed.strat.ctx <- list()
  df.first <- excel.strata.df[[1]]
  df.first <- df.first[c(1,2)]
  df.first[,1] <- as.character(df.first[,1])
  df.first[,2] <- as.character(df.first[,2])
  df.first <- data.table(df.first)
  names(df.first) <- c('par', 'value')
  for(stratum in names(excel.strata.df)) {
    df <- excel.strata.df[[stratum]]
    df <- df[c(1,2)]
    df[,1] <- as.character(df[,1])
    df[,2] <- as.character(df[,2])
    names(df) <- c('par', 'value')
    if (stratum != names(excel.strata.df)[1])
      df <- recalculate.formulas(as.data.frame(df)) # Recalculating formulas inside sheet
    for(p in pars) {
      if (nrow(df[df$par==p,]) == 1) {
        df[df$par==p, 'value'] <- strat.ctx[[stratum]][[p]][1]
      } else {
        df <- rbind(df, data.frame(par=p, value=strat.ctx[[stratum]][[p]][1]))
      }
    }
    df <- recalculate.formulas(as.data.frame(df)) # Recalculating formulas inside sheet
    df <- copy(df.first)[df, on='par', value:=i.value]
    df <- as.data.frame(df)
    df <- recalculate.formulas(df) # Recalculating formulas once substituted in merged sheet
    refreshed.strat.ctx[[stratum]] <- as.list(df$value)
    names(refreshed.strat.ctx[[stratum]]) <- df$par
    
    # Adding non-excel parameters (e.g. those calculated in code after excel import)
    non.excel.params <- names(strat.ctx[[stratum]])[!names(strat.ctx[[stratum]]) %in% names(refreshed.strat.ctx[[stratum]])]
    for(p in non.excel.params) {
      refreshed.strat.ctx[[stratum]][p] <- strat.ctx[[stratum]][p]
    }
  }
  if (!is.null(context.setup.func))
    refreshed.strat.ctx <- context.setup.func(refreshed.strat.ctx)
  return(refreshed.strat.ctx)
}
