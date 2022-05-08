#' Decision Tree for Cost-Effectiveness Analysis
#'
#' @docType class
#' @export
DecisionTree <- setRefClass('DecisionTree',
                            contains='CEAModel',
                            # fields=c(),
                            methods=list(
                              show = function(context=NULL,
                                              prevalence=NULL,
                                              showDescription=TRUE,
                                              showProbs=TRUE,
                                              nodeInfoFields=c(),
                                              showID=FALSE,
                                              probPrecision=8,
                                              direction='LR',
                                              levelSeparation=NULL,
                                              spacing=NULL,
                                              height=1000,
                                              highlight=NULL,
                                              wrapping=FALSE,
                                              seed=0) {
                                if (is.character(context) && length(context) == 1)
                                  context <- loadContextFile(context)
                                if (is.character(prevalence)) {
                                  prevalence <- context[[prevalence]]
                                }
                                if (!is.null(context) && min(sapply(context, function(v) length(v))) > 1) {
                                  warning('Only one set of context values can be displayed, showing the first one.')
                                  context <- lapply(context, function(r)r[[1]])
                                }
                                nodes <- getNodes(context=context, prevalence=prevalence)
                                if (showDescription) {
                                  names <- sapply(nodes, function(n) {
                                    nm <- ''
                                    if (showID) {nm <- paste0('[', n$id, '] ')}
                                    if (is.null(n$info[['description']])) {nm <- paste0(nm, n$name)}
                                    else {nm <- paste0(nm, n$info[['description']])}
                                    if (length(nm) > 1) stop(paste0('Node malformed (', nm[1], '). Please check yaml file.'))
                                    return(nm)
                                  }
                                  )
                                } else {
                                  names <- sapply(nodes, function(n) n$name)
                                }
                                ids <- sapply(nodes, function(n) n$id)
                                nodeInfo <- data.frame(id=ids, label=names, name=sapply(nodes, function(n)n$name), stringsAsFactors = F)
                                for(field in nodeInfoFields) {
                                  fieldInfo <- sapply(nodes, function(n) {.parseValue(n$info[[field]], context, partial.eval = T)})
                                  if (field == 'path.prob.100k') {
                                    display.field <- 'n'
                                    display.fieldInfo <- formatC(fieldInfo, format='d', big.mark = ',')
                                  }
                                  else if (field == 'disease.100k') {
                                    display.field <- 'n.cancer'
                                    display.fieldInfo <- formatC(fieldInfo, format='d', big.mark = ',')
                                  } else {
                                    display.field <- field
                                    display.fieldInfo <- fieldInfo
                                  }
                                  nodeInfo$label <- ifelse(sapply(fieldInfo, function(x) {is.null(x) || length(x) == 0}),
                                                           nodeInfo$label,
                                                           paste0(nodeInfo$label, '\n[', display.field, ' = ', display.fieldInfo, ']'))
                                }
                                edges <- getEdgeDisplayInfo(context=context, prevalence=prevalence, showProbs=showProbs, probPrecision=probPrecision)
                                # Remove inaccessible nodes
                                nodeInfo <- nodeInfo[nodeInfo$id %in% edges$from | nodeInfo$id %in% edges$to,]
                                if (direction=='LR') {
                                  if (wrapping)
                                    nodeInfo$label <- sapply(nodeInfo$label, function(t) {paste0(strwrap(t, width=20), collapse='\n')})
                                  if (is.null(levelSeparation)) levelSeparation <- 200
                                  if (is.null(spacing)) spacing <- 100
                                } else {
                                  if (is.null(levelSeparation)) levelSeparation <- 100
                                  if (is.null(spacing)) spacing <- 400
                                }
                                nodeInfo$shape <- 'box'
                                nodeInfo$color <- ifelse(nodeInfo$id %in% edges$from, '#97c2fc', '#f49564')
                                nodeInfo$color <- ifelse(nodeInfo$name %in% highlight, '#e8ff0a', nodeInfo$color)
                                nodeInfo$x <- seq(nrow(nodeInfo))  # To preserve node order (in vertical tree)
                                nodeInfo$y <- seq(nrow(nodeInfo))  # To preserve node order (in horizontal tree)

                                p <- visNetwork::visNetwork(nodeInfo, edges, height=height, width='100%') %>%
                                  visNetwork::visEdges(arrows='to') %>%
                                  visNetwork::visIgraphLayout(randomSeed = seed) %>%
                                  visNetwork::visHierarchicalLayout(sortMethod = 'directed',
                                                                    nodeSpacing = spacing,
                                                                    direction=direction,
                                                                    levelSeparation=levelSeparation)
                                return(p)
                              },
                              calculate = function(context=list(), prevalence=NULL) {
                                if (is.character(prevalence)) {
                                  prevalence <- context[[prevalence]]
                                }
                                if (is.character(context) && length(context) == 1)
                                  context <- loadContextFile(context)
                                summary <- summarize(context, prevalence)
                                cost <- sum(summary$prob * summary$cost)
                                outcome <- sum(summary$prob * summary$outcome)
                                results <- data.frame(strategy=name, cost=cost, outcome=outcome, stringsAsFactors = F)
                                return(results)
                              },
                              summarize = function(context, prevalence=NULL) {
                                if (is.character(prevalence)) {
                                  prevalence <- context[[prevalence]]
                                }
                                pars <- root$getParameters()
                                if (!all(pars %in% names(context))) {
                                  missing.pars <- pars[!pars %in% names(context)]
                                  stop(paste0(paste0('"', missing.pars, '"', collapse=', '), ' not defined in context'))
                                }
                                outcomes <- root$getLeaves(context, prevalence=prevalence)
                                outcomes <- outcomes %>% dplyr::group_by(name) %>%
                                  dplyr::summarise(cost=weighted.mean(cost, prob),
                                                   outcome=weighted.mean(outcome, prob),
                                                   prob=sum(prob))
                                return(data.frame(outcomes))
                              },
                              getEdgeDisplayInfo = function(context=NULL, prevalence=NULL, showProbs=TRUE, showLoops=TRUE, probPrecision=8, edge.description=NULL) {
                                return(root$getEdgeDisplayInfo(context=context, prevalence=prevalence, showProbs=showProbs, showLoops=showLoops, probPrecision=probPrecision, edge.description=edge.description))
                              },
                              getParameters = function() {
                                return(root$getParameters())
                              },
                              singleRun = function(context, prevalence=NULL, seed=NULL) {
                                return(root$runIteration(context=context, prevalence=prevalence, seed=seed))
                              }
                            ))



#' Load decision tree from YAML file
#'
#' Generates a decision tree as specified by the YAML file.
#'
#' TODO: Document tree specification format.
#'
#' @param filePath path to YAML file with the tree specification
#'
#' @return DecisionTree
#'
#' @examples
#' library(CEAModel)
#' tree <- loadDecisionTree('example.yaml')
#' print(tree)
#'
#' @export
loadDecisionTree <- function(filePath) {
  root <- .loadDecisionTreeNode(filePath)$tree
  tree <- DecisionTree(name=tools::file_path_sans_ext(basename(filePath)),
                       root=root)

  return(tree)
}

.loadDecisionTreeNode <- function(filePath, nextId=0, suffix=NULL) {
  treeDir <- dirname(filePath)
  treeSpec <- yaml::yaml.load_file(filePath)
  nodes <- list()

  parseNode <- function(node, nextId=0, suffix=NULL) {
    name <- names(node)
    node <- node[[1]]
    attributes <- names(node)
    attributes <- attributes[!attributes %in% c('name', 'children', 'probs', 'include', 'suffix')]
    newNode <- Node(id=nextId,
                    name=name,
                    info=list(),
                    probs=node$probs)
    nextId <- nextId + 1
    if (!is.null(node$suffix) && node$suffix != '') {
      suffix <- c(suffix, node$suffix)
    }
    for(val in attributes) {
      if (tryCatch(!is.na(as.numeric(node[val])), warning=function(c){TRUE}) &&
          !is.null(suffix) && !is.null(node$suffix) && node$suffix != '' &&
          val %in% c('outcome')) {
        newNode$info[val] <- paste(node[val], paste0(suffix, collapse='_'), sep='___')
      } else {
        newNode$info[val] <- node[val]
      }
    }

    if (length(node$children) > 0) {
      prob.suffix <- suffix
      if (!is.null(node$suffix) && node$suffix == '')
        prob.suffix <- NULL
      newNode$probs <- .parseProbs(node$probs, suffix=prob.suffix, partial.eval=T)
      newNode$out <- lapply(node$children, function(child) {
        isIncluded <- 'include' %in% names(child[[1]]) &&
          !is.null(child[[1]][['include']]) &&
          !is.na(child[[1]][['include']])
        nodeInfo <- parseNode(child, nextId=nextId, suffix=suffix)
        childNode <- nodeInfo$node
        nextId <<- nodeInfo$nextId
        info <- childNode$info
        if (isIncluded) {
          if ('suffix' %in% names(child[[1]]) && child[[1]][['suffix']] != '')
            suffix <- c(suffix, child[[1]][['suffix']])
          treeResult <- .loadDecisionTreeNode(paste0(treeDir, '/', child[[1]]['include'][[1]]),
                                              nextId=nextId,
                                              suffix=suffix)
          childNode <- treeResult$tree
          nextId <<- treeResult$nextId
        }
        childNode$info <- modifyList(childNode$info, info)
        return(childNode)
      })
      names(newNode$out) <- lapply(newNode$out, function(child) {child$name})
    } else {
      newNode$probs <- numeric(0)
      newNode$out <- list()
    }
    return(list(
      node=newNode,
      nextId=nextId)
    )
  }

  nodeInfo <- parseNode(treeSpec, nextId=nextId, suffix=suffix)
  return(list(
    tree=nodeInfo$node,
    nextId=nodeInfo$nextId)
  )
}
