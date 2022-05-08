#' Load a XLSX file to a context list for CEA models
#'
#' Generates a context list for CEA models from an excel file.
#'
#' @param filename Filename of the xlsx file
#' @param only.base.value TRUE if only the first column of the values should be loaded
#'
#' @return list with context variables
#'
#' @examples
#' library(CEAModel)
#' ctx <- loadContextFile('context.xlsx')
#' tree1 <- loadDecisionTree('tree1.yaml')
#' tree2 <- loadDecisionTree('tree2.yaml')
#' outputs <- analyzeCE(tree1=tree1, tree2=tree2, context=ctx)
#'
#' @export
loadContextFile <- function(filename, sheet=1, only.base.values=FALSE) {
  f <- as.data.frame(readxl::read_excel(filename, sheet=sheet))
  values <- f[2:(ncol(f)-1)]  # Last column reserved for notes
  names(values) <- NULL
  values <- apply(values, 1, function(r){as.list(r)})
  names(values) <- f[[1]]
  values <- lapply(values, function(r)unlist(r))
  values <- lapply(values, function(r)as.numeric(r))
  if (only.base.values) {
    values <- lapply(values, function(v) v[1])
  }
  return(values)
}



#' Load a XLSX file to a stratified context list for CEA models
#'
#' Generates a stratified context list for CEA models from an excel file.
#'
#' @param filename Filename of the xlsx file
#' @param only.base.value TRUE if only the first column of the values should be loaded
#'
#' @return list of strata, each with context variables
#'
#' @examples
#' library(CEAModel)
#' ctx <- loadStratifiedContextFile('context.xlsx')
#' tree1 <- loadDecisionTree('tree1.yaml')
#' tree2 <- loadDecisionTree('tree2.yaml')
#' outputs1 <- analyzeCE(tree1=tree1, tree2=tree2, context=ctx$stratum1)
#' outputs2 <- analyzeCE(tree1=tree1, tree2=tree2, context=ctx$stratum2)
#'
#' @export
loadStratifiedContextFile <- function(filename, only.base.values=FALSE) {
  strata <- readxl::excel_sheets(filename)
  ctx <- list()
  for(stratum in strata) {
    values <- loadContextFile(filename, sheet=stratum, only.base.values=only.base.values)
    if (stratum == strata[[1]])
      base.values <- values
    values <- modifyList(base.values, values)
    ctx[[stratum]] <- values
  }
  return(ctx)
}



#' Save a context list for CEA models to a XLSX file
#'
#' Generates an excel file from a context list for CEA models.
#'
#' @param context Named list with context variables and their values
#' @param filename Filename of the xlsx file
#'
#' @examples
#' library(CEAModel)
#' ctx <- list(var1=12, var2=34)
#' saveContextFile(ctx, 'context.xlsx')
#'
#' @export
saveContextFile <- function(context, filename) {
  df <- as.data.frame(t(as.data.frame(context)))
  df$variable <- row.names(df)
  df <- df[,c(ncol(df),seq(ncol(df)-1))]
  names(df) <- c('variable', paste0('value', seq(ncol(df)-1)))
  df$notes <- ''

  wb <- xlsx::createWorkbook()
  header.style <- xlsx::CellStyle(wb) + xlsx::Font(wb, isBold=TRUE)
  sheet <- xlsx::createSheet(wb)
  xlsx::addDataFrame(df, sheet = sheet, row.names = FALSE, colnamesStyle = header.style)
  xlsx::autoSizeColumn(xlsx::getSheets(wb)[[1]], colIndex=1:ncol(df))
  xlsx::saveWorkbook(wb, filename)
}



#' Save a stratified context list for CEA models to a XLSX file
#'
#' Generates an excel file from a stratified context list for CEA models.
#'
#' @param strat.context Named list with strata, each of them with context variables and their values
#' @param filename Filename of the xlsx file
#'
#' @examples
#' library(CEAModel)
#' ctx <- list(
#'         stratum1=list(var1=12, var2=34),
#'         stratum2=list(var1=23, var2=45)
#'        )
#' saveStratifiedContextFile(ctx, 'context.xlsx')
#'
#' @export
saveStratifiedContextFile <- function(strat.context, filename) {
  wb <- xlsx::createWorkbook()
  header.style <- xlsx::CellStyle(wb) + xlsx::Font(wb, isBold=TRUE)

  for(stratum in names(strat.context)) {
    df <- as.data.frame(t(as.data.frame(strat.context[[stratum]])))
    df$variable <- row.names(df)
    df <- df[,c(ncol(df),seq(ncol(df)-1))]
    names(df) <- c('variable', paste0('value', seq(ncol(df)-1)))
    df$notes <- ''

    sheet <- xlsx::createSheet(wb, sheetName=stratum)
    xlsx::addDataFrame(df, sheet = sheet, row.names = FALSE, colnamesStyle = header.style)
    xlsx::autoSizeColumn(xlsx::getSheets(wb)[[stratum]], colIndex=1:ncol(df))
  }
  xlsx::saveWorkbook(wb, filename)
}



#' Generates a stratified context XLSX file
#'
#' Generates a stratified context XLSX file for the parameters required by the specified CEA models.
#'
#' @param ... CEAModel(s)
#' @param filename Filename of the xlsx file
#' @param strata Names of the strata
#'
#' @examples
#' library(CEAModel)
#' tree <- loadDecisionTree('tree.yaml')
#' markov <- loadMarkovModel('markov.xlsx')
#' generateContextTemplate(tree, markov, 'context.xlsx')
#'
#' @export
generateContextTemplate <- function(..., filename, strata='base') {
  ctx <- generateEmptyContextFromModels(...)
  strat.context <- lapply(strata, function(s) {ctx})
  names(strat.context) <- strata
  saveStratifiedContextFile(strat.context, filename)
}



#' Generates a context list from CEA models
#'
#' Generates a context list from CEA models such as decision trees, markov or microsimulation models,
#' all of them initialized to 0.
#'
#' @param ... CEAModel(s)
#'
#' @examples
#' library(CEAModel)
#' tree <- loadDecisionTree('tree.yaml')
#' markov <- loadMarkovModel('markov.xlsx')
#' generateEmptyContextFromModels(tree, markov)
#'
#' @export
generateEmptyContextFromModels <- function(...) {
  models <- list(...)
  params <- c()
  for(model in models) {
    params <- c(params, model$getParameters())
  }
  params <- params[!duplicated(params)]
  params <- params[order(params)]
  ctx <- list()
  ctx <- as.list(sapply(params, function(e) 0, USE.NAMES=TRUE))
  return(ctx)
}



#' Get all independent parameter names from context XLSX file
#'
#' Returns the names of all parameters not dependent on other values (i.e. excel cells).
#'
#' @param filename Filename of the xlsx file
#'
#' @examples
#' library(CEAModel)
#' ctx.filename <- 'context.xlsx'
#' ctx <- loadStratifiedContextFile(ctx.filename)
#' independent.params <- getIndependentParameters(ctx.filename)
#' @export
getIndependentParameters <- function(filename, range.available=NULL) {
  # Return params not dependent on other values (i.e. excel cells)
  # If range.available is defined (TRUE/FALSE) only the ranged/not ranged independent
  # parameters are considered, otherwise all are returned.

  # Faster to trim empty rows later using read.xlsx2 than using read.xlsx
  df <- xlsx::read.xlsx2(filename, sheetIndex = 1, colIndex = seq(4), keepFormulas = T)
  df <- df[df$variable!='',]
  if (!is.null(range.available)) {
    ranged <- df$lower != '-1' | df$upper != '-1'
    if (range.available) df <- df[ranged,]
    else df <- df[!ranged,]
  }
  df[,2] <- as.character(df[,2])
  return(as.character(df[!is.na(suppressWarnings(as.numeric(df[[2]]))), 1]))
}
