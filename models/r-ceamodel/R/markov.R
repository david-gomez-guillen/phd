#' Markov Model for Cost-Effectiveness Analysis
#'
#' @docType class
#' @export
MarkovModel <- setRefClass('MarkovModel',
                           contains='CEAModel',
                           fields=c('nodes', 'tpMatrix', 'tpDescription'),
                           methods=list(
                             show = function(context=NULL,
                                             matrixId=1,
                                             showProbs=TRUE,
                                             showLoops=TRUE,
                                             probPrecision=8,
                                             exclude.nodes=NULL,
                                             physics=TRUE) {
                               if (is.character(context) && length(context) == 1)
                                 context <- loadContextFile(context)
                               names <- sapply(nodes, function(n) {
                                 nm <- gsub('_', ' ', n$name)
                                 nm <- strwrap(nm, 15)
                                 if (length(nm) > 1) {
                                   nm[1:(length(nm)-1)] <- paste0(nm[1:(length(nm)-1)])
                                 }
                                 paste(nm, collapse='\n')
                               })
                               ids <- sapply(nodes, function(n) n$id)
                               dfNodes <- data.frame(id=ids, label=names, stringsAsFactors = F)
                               # edges <- getEdgeDisplayInfo(context=context, showProbs=showProbs, showLoops=showLoops, probPrecision=probPrecision, edge.description=tpDescription)
                               edges <- data.frame()
                               for(i in seq(nrow(dfNodes))) {
                                 for(j in seq(nrow(dfNodes))) {
                                   if (tpMatrix[[matrixId]][i,j] != 0) {
                                     if (i != j || showLoops) {
                                      edges <- rbind(edges, data.frame(from=i, to=j, label=tpDescription[i,j]))
                                     }
                                   }
                                 }
                               }
                               dfNodes$shape <- 'circle'
                               isSinkNode <- sapply(dfNodes$id, function(id){
                                 nodeEdges <- edges[edges$from==id,]
                                 isSink <- all((nrow(nodeEdges) == 1) & (nodeEdges$from == nodeEdges$to))
                                 return(isSink)
                               })
                               dfNodes$color <- ifelse(isSinkNode, '#f49564', '#97c2fc')
                               edges <- edges[!edges$from %in% dfNodes[isSinkNode,'id'],]  # Remove self loop from sink nodes

                               if (!is.null(exclude.nodes)) {
                                 exclude.ids <- dfNodes[row.names(dfNodes) %in% exclude.nodes, 'id']
                                 dfNodes <- dfNodes[!row.names(dfNodes) %in% exclude.nodes, ]
                               }

                               p <- visNetwork::visNetwork(dfNodes, edges) %>%
                                 visNetwork::visNodes(physics=physics) %>%
                                 visNetwork::visEdges(arrows='to', length=300) %>%
                                 visNetwork::visOptions(highlightNearest = TRUE) %>%
                                 visNetwork::visPhysics(solver = "repulsion")
                               return(p)
                             },
                             getEdgeDisplayInfo = function(context=NULL, showProbs=TRUE, showLoops=TRUE, probPrecision=8, edge.description=NULL) {
                               edges <- data.frame()
                               for(node in nodes) {
                                 edges <- rbind(edges, node$getEdgeDisplayInfo(context=context, showProbs=showProbs, showLoops=showLoops, probPrecision=probPrecision, edge.description=edge.description, recursive=FALSE))
                               }
                               return(edges)
                             },
                             copy = function(shallow = FALSE) {
                               nodesCopy <- list()

                               for(n in nodes) {
                                 nodesCopy[[n$name]] <- Node(
                                   id=n$id,
                                   name=n$name,
                                   info=rlang::duplicate(n$info),
                                   probs=n$probs,
                                   out=list()
                                 )
                               }

                               for(n in nodesCopy) {
                                 for(out.name in names(nodesCopy)) {
                                   n$out[[out.name]] <- nodesCopy[[out.name]]
                                 }
                               }
                               return(MarkovModel(
                                 name=rlang::duplicate(name),
                                 nodes=nodesCopy,
                                 root=nodesCopy[[1]],
                                 tpMatrix=rlang::duplicate(tpMatrix),
                                 tpDescription=rlang::duplicate(tpDescription)
                               ))
                             },
                             evaluateTpMatrix = function(context, partial.eval=TRUE) {
                               evaluatedTpMatrices <- lapply(tpMatrix, function(tpm) {
                                 evaluatedTpMatrix <- t(apply(tpm, MARGIN = 1, FUN = function(r) {
                                   tryCatch({
                                     .parseProbs(r, context, partial.eval=partial.eval)
                                   }, error=function(e) {
                                     r
                                   }
                                   )
                                 }))
                                 colnames(evaluatedTpMatrix) <- row.names(evaluatedTpMatrix)
                                 return(evaluatedTpMatrix)
                               })
                               return(evaluatedTpMatrices)
                             },
                             evaluate = function(context, fields=c('cost', 'outcome'), partial.eval=TRUE) {
                               modelCopy <- copy()
                               for(n in modelCopy$nodes) {
                                 n$probs <- .parseProbs(n$probs, context, partial.eval=partial.eval)
                                 for(item in names(n$info)) {
                                   if (item %in% fields) {
                                     tryCatch({
                                       n$info[[item]] <- n$parseNodeValue(n$info[[item]], context, partial.eval=partial.eval)
                                     }, error=function(e) {
                                       print(paste0(n$info[[item]], ' not found in context, skipping...'))
                                     }
                                     )
                                   }
                                 }
                               }
                               modelCopy$tpMatrix <- modelCopy$evaluateTpMatrix(context, partial.eval=partial.eval)
                               return(modelCopy)
                             },
                             simulateCohort = function(initialState,
                                                       start.age,
                                                       end.age,
                                                       discount.rate=0,
                                                       setup.matrices=NULL,
                                                       setup.data.collection.func=NULL,
                                                       setup.plot.states.func=NULL,
                                                       get.matrix.stratum=NULL,
                                                       strat.ctx=NULL) {
                               EPSILON <- 1e-7  # Maximum rounding error allowed for probabilities equal to zero

                               if (length(initialState) != length(nodes))
                                 stop('Initial state not valid')
                               if (is.character(strat.ctx) && length(strat.ctx) == 1)
                                 strat.ctx <- loadStratifiedContextFile(strat.ctx)

                               if (is.null(setup.matrices)) {
                                 # By default we evaluate the matrices with the context parameters with no further processing
                                 setup.matrices <- function(strat.ctx, ...) {
                                   return(lapply(names(strat.ctx), function(stratum) evaluateTpMatrix(strat.ctx[[stratum]])))
                                 }
                               }

                               if (is.null(setup.data.collection.func)) {
                                 setup.data.collection.func <- function(additional.info, states, ...) {
                                   return(additional.info)
                                 }
                               }

                               if (is.null(setup.plot.states.func)) {
                                 setup.plot.states.func <- function(states, ...) {
                                   return(states)
                                 }
                               }

                               if (is.null(get.matrix.stratum)) {
                                 # By default we consider only the first stratum
                                 get.matrix.stratum <- function(strat.ctx, ...) return(strat.ctx[[1]])
                               }

                               ctx <- get.matrix.stratum(strat.ctx, start.age)
                               ctx <- lapply(ctx, function(e) e[1]) # Base values

                               evaluated.markov <- lapply(markov, function(m)m$evaluate(ctx))
                               costs <- sapply(evaluated.markov[[1]]$nodes, function(n)n$info$cost)
                               # Custom costs
                               utilities <- sapply(evaluated.markov[[1]]$nodes, function(n)n$info$outcome)
                               # Custom utilities

                               current.state <- t(initial.state)
                               overall.cost <- 0
                               overall.eff <- 0
                               additional.info <- data.frame()
                               states <- data.frame()
                               for(year in seq(start.age, end.age)) {
                                 states <- rbind(states, current.state)
                                 tpMatrices <- get.matrix.stratum(tpMatrices, year)
                                 currentTpMatrix <- tpMatrices[[1]]
                                 for(i in seq(2,length(tpMatrices))) {
                                   currentTpMatrix <- currentTpMatrix %*% tpMatrices[[i]]
                                 }
                                 ctx <- get.context.stratum(strat.ctx, year)

                                 # Custom

                                 overall.cost <- overall.cost + sum(current.state * costs) * (1-discount.rate)^(year-start.age)
                                 overall.eff <- overall.eff + sum(current.state * utilities) * (1-discount.rate)^(year-start.age)

                                 # Custom data collection
                                 additional.info <- setup.data.collection.func(additional.info, states)

                                 current.state <- current.state %*% currentTpMatrix

                                 if (any(current.state < -EPSILON))
                                   stop('States with negative populations, probabilities might have errors.')
                                 else if (any(current.state < 0)) {
                                   # ASSUMPTION: Small rounding errors, renormalizing
                                   # TODO: Reconsider if other alternatives might be better
                                   current.state[current.state < 0] <- 0
                                   current.state <- current.state / sum(current.state)
                                 }
                               }

                               states$age <- as.numeric(row.names(states)) + start.age - 1
                               plot.states <- setup.plot.states.func(states)  # Custom states for plotting
                               melted.states <- reshape2::melt(plot.states, id.vars='age')

                               p <- ggplot(melted.states, aes(x=age, y=value, color=variable)) +
                                 geom_line() +
                                 ylim(0,1) +
                                 xlab('Age') +
                                 ylab('Cohort (%)')

                               results.df <- data.frame(C=overall.cost,
                                                        E=overall.eff,
                                                        stringsAsFactors = FALSE)
                               return(list(
                                 plot=p,
                                 states=states,
                                 additional.info=additional.info,
                                 summary=results.df
                               ))
                             },
                             getParameters = function() {
                               vars <- c()
                               for(node in nodes) {
                                 vars <- c(vars, node$getParameters(recursive=FALSE))
                               }
                               vars <- vars[!duplicated(vars)]
                               return(vars[order(vars)])
                             }
                           ))



#' Load markov model from XLSX file
#'
#' Generates a markov model as specified by the XLSX file.
#'
#' TODO: Document markov model specification format.
#'
#' @param filePath path to XLSX file with the markov model specification
#'
#' @return MarkovModel
#'
#' @examples
#' library(CEAModel)
#' markov <- loadMarkovModels('example.xlsx')
#' print(markov)
#'
#' @export
loadMarkovModels <- function(filePath) {
  models <- list()
  # for(filePath in filePaths) {
    wb <- xlsx::loadWorkbook(filePath)
    sheetnames <- names(xlsx::getSheets(wb))

    nodeInfo <- as.data.frame(readxl::read_excel(filePath, sheet = 'nodes'))

    nodes <- list()
    for(i in row.names(nodeInfo)) {
      node <- nodeInfo[i,]
      info <- as.list(node)
      info$name <- NULL
      newNode <- Node(id=i,
                      name=node$name,
                      info=info,
                      out=list(),
                      probs=node$probs)
      nodes[[node$name]] <- newNode
    }

    # for(i in seq_along(nodes)) {
    #   for(j in seq_along(nodes)) {
    #     nodes[[i]]$probs[j] <- edges[i,j]
    #     nodes[[i]]$out[[nodes[[j]]$name]] <- nodes[[j]]
    #   }
    # }

    edge.description <- as.data.frame(readxl::read_excel(filePath, sheet = 'edge_description', col_names = c('_', nodeInfo$name), skip = 1))
    if (any(names(edge.description)[2:length(names(edge.description))] != edge.description[[1]]))
      stop('Row and column states are not equal in transition descriptions')
    row.names(edge.description) <- unlist(edge.description[1])
    edge.description[1] <- NULL

    tpMatrices <- list()
    edge_sheets <- sheetnames[!sheetnames %in% c('nodes', 'edge_description')]
    for (net in edge_sheets) {
      suppressWarnings(edges <- as.data.frame(readxl::read_excel(filePath, sheet = net, col_names = c('_', nodeInfo$name), skip = 1)))
      if (any(names(edges)[2:length(names(edges))] != edges[[1]]))
        stop('Row and column states are not equal in transition probabilities')
      row.names(edges) <- unlist(edges[1])
      edges[1] <- NULL
      tpMatrices[[net]] <- edges

      # networks <- list()
      # networks <- append(networks, nodes[[1]])
    }

    model <- MarkovModel(name=tools::file_path_sans_ext(basename(filePath)),
                         root=nodes[[1]],
                         nodes=nodes,
                         tpMatrix=tpMatrices,
                         tpDescription=edge.description)
    # models[[net]] <- model
  # }

  # if (length(models) == 1) {
  #   return(models[[1]])
  # } else
    return(model)
}



#' Save markov model to XLSX file
#'
#' Generates a XLSX file from a markov model (or list of markov models).
#'
#' TODO: Document markov model specification format.
#'
#' @param markov markov model (or named list of markov models)
#' @param filePath path to XLSX file with the markov model specification
#'
#' @examples
#' library(CEAModel)
#' markov <- loadMarkovModels('example.xlsx')
#' ...
#' saveMarkovModel(markov, 'example.modified.xlsx')
#'
#' @export
saveMarkovModel <- function(markov, filePath) {
  wb <- xlsx::createWorkbook()
  header.style <- xlsx::CellStyle(wb) + xlsx::Font(wb, isBold=TRUE)

  node.sheet <- xlsx::createSheet(wb, sheetName='nodes')

  node.data <- data.frame(name=names(markov$nodes))

  for(field in names(markov$nodes[[1]]$info)) {
    node.data[field] <- sapply(markov$nodes, function(n) n$info[[field]])
  }

  xlsx::addDataFrame(node.data, node.sheet, row.names = FALSE, colnamesStyle = header.style)
  xlsx::autoSizeColumn(node.sheet, 1:ncol(node.data))

  edge.description.sheet <- xlsx::createSheet(wb, sheetName='edge_description')
  edge.description.data <- markov$tpDescription
  xlsx::addDataFrame(edge.description.data,
                     edge.description.sheet,
                     rownamesStyle =  header.style,
                     colnamesStyle = header.style)
  xlsx::autoSizeColumn(edge.description.sheet, 1:(ncol(edge.description.data)+1))

  for(name in names(markov$tpMatrix)) {
    edge.sheet <- xlsx::createSheet(wb, sheetName=name)
    edge.data <- markov$tpMatrix[[name]]
    xlsx::addDataFrame(edge.data,
                       edge.sheet,
                       rownamesStyle =  header.style,
                       colnamesStyle = header.style)
    xlsx::autoSizeColumn(edge.sheet, 1:(ncol(edge.data)+1))
  }
  xlsx::saveWorkbook(wb, filePath)
}
