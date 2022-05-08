# Returns a NxN matrix where "idxs" positions are filled with values from vector
# values, starting at position start. Remaining positions are filled with 0s
TPMatrixFromVector <- function(N, values, start, idxs, mort=NULL) {
  warning("Function TPMatrixFromVector is DEPRECATED and its use it's not recommended")
  m <- matrix(data=0, nrow=N, ncol=N)
  m[idxs] <- values[start + 0:(length(idxs)-1)]
  
  if (!is.null(mort)) {
    m[,N] <- mort-m[,N-1]
  }

  return(m)
}


# Returns a list of NxN transition probability matrices
# All values in returned matrices will be 0, except for
# (1) for each entry in idxs, provided position are filled with "values"
# (2) diagonal entries are filled with 1-rowSum
# If mort (a list of vectors of mortalities) is provided, last two columns of
# each returned matrix are forced to sum itscorresponding "mort" vector
# by setting the value on the last column
TPMatricesFromVector <- function(N, values, idxs, mort=NULL) {
  warning("Function TPMatricesFromVector is DEPRECATED and its use it's not recommended")
  if (length(values) != sum(sapply(idxs, length)))
    stop("Length of values vector must be equal to the number of indices provided")
  
  if (!is.null(mort) && (length(idxs) != length(mort)))
    stop("List of indices and list of fixed mortalities must have the same length")
  
  TPMatrices  <- list()
  used.values <- 0

  for (i in 1:length(idxs)) {
    if(is.null(mort)) {
      aux.mort <- NULL
    } else {
      aux.mort <- mort[[i]]
    }
      
    TPMatrices[[i]] <- TPMatrixFromVector(N,values,used.values+1,idxs[[i]], aux.mort)
    diag(TPMatrices[[i]]) <- 1-rowSums(TPMatrices[[i]])

    used.values <- used.values+length(idxs[[i]])
  }

  return(TPMatrices)
}

TPMatricesFromCalibrableVector <- function(v.info, calib.parameters) {
  TPMatrices <- list()
  calib.parameters <- GetAllCalibrationParameters(calib.parameters)
  
  up.idxs    <- which(upper.tri(matrix(ncol=v.info$N, nrow=v.info$N)))
  fixed.idxs <- setdiff(up.idxs, v.info$var.idxs)
  
  used.values <- 0
  current.group <- 1
  
  for (current.group in 1:length(v.info$fixed)) {
    # TP Base matrix
    m <- matrix(data=0, nrow=v.info$N, ncol=v.info$N)
    
    if (is.null(calib.parameters$age.groups) 
        || current.group %in% calib.parameters$age.groups) {
      # Add variable values
      m[v.info$var.idxs] <- v.info$var[used.values + 1:length(v.info$var.idxs)]
      used.values <- used.values + length(v.info$var.idxs)
      # Add fixed values
      m[fixed.idxs] <- v.info$fixed[[current.group]]
    } else {
      # Add fixed values
      m[up.idxs] <- v.info$fixed[[current.group]]
    }
    
    
    # Mortality, if needed
    if (calib.parameters$pin.any.to.death.totals) {
      if (calib.parameters$cancer.to.lc.death) {
        m[,v.info$N] <- v.info$mort[[current.group]] - m[,v.info$N-1]
        m[v.info$N-1, v.info$N] <- m[v.info$N, v.info$N] <- 0
      } else if (calib.parameters$any.to.other.death) {
        m[,v.info$N-1] <- v.info$mort[[current.group]] - m[,v.info$N]
        m[v.info$N-1, v.info$N] <- m[v.info$N, v.info$N] <- 0
      } else {
        warning("Calibration parameters - Pinning transition totals to death states makes no sense")
      }
    }
    
    # Diagonal values
    diag(m) <- 1-rowSums(m)
    
    
    
    TPMatrices[[current.group]] <- m
    current.group <- current.group + 1
  }
  
  return(TPMatrices)
  
}
