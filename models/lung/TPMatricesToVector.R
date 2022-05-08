# LEGACY transformation to calibrable vector
TPMatricesToNonTrivialVector <- function(tpm, mort.fixed=FALSE) {
  warning("Function TPMatricesToNonTrivialVector is DEPRECATED and its use it's not recommended")
  ret <- list(
    v=double(),
    nt.idxs=list()
  )
  
  if (mort.fixed) ret$mort <- list()

  for (tp in tpm) {
    diag(tp) <- 0
    
    if (mort.fixed) {
      ret$mort[[length(ret$mort)+1]] <- tp[,ncol(tp)-1] + tp[,ncol(tp)]
      tp[,ncol(tp)] <- 0
    }
    
    ret$v <- c(ret$v, tp[tp != 0])
    ret$nt.idxs[[length(ret$nt.idxs)+1]] <- which(tp != 0)
  }

  return(ret)
}


# Transforms list of matrices in a calibrable vector
# Returns a list with entries:
#   var: Vector of variable values
#   var.idxs: Vector of variable positions in each matrix
#   fixed: List of fixed values (one entry for each matrix)
#   mort: List of total mortality values (only if pin.any.to.death.totals is set)
TPMatricesToCalibrableVector <- function(tpm, calib.parameters=list()) {
  ret <- list(
    var=double(),
    var.idxs=double(),
    fixed=list(),
    N=ncol(tpm[[1]])
  )

  tp <- tpm[[1]]
  calib.parameters <- GetAllCalibrationParameters(calib.parameters)
  select <- upper.tri(tp)
  up.idxs <- which(select)
  
  if (calib.parameters$pin.zeros) {
    select <- select & (tp!=0)
  }
  if (!calib.parameters$well.to.cancer) {
    select[1, 2:(ncol(tp)-3)] <- FALSE
  }
  if (!calib.parameters$cancer.to.cancer) {
    select[2:(nrow(tp)-3), 2:(ncol(tp)-3)] <- FALSE
  }
  if (!calib.parameters$cancer.to.lc.death) {
    select[,ncol(tp)-1] <- FALSE
  }
  if ((!calib.parameters$any.to.other.death) 
        || (calib.parameters$cancer.to.lc.death +
            calib.parameters$any.to.other.death + 
            calib.parameters$pin.any.to.death.totals == 3)) {
    select[,ncol(tp)] <- FALSE
  }
  
  if (calib.parameters$pin.any.to.death.totals) {
    if (!calib.parameters$cancer.to.lc.death && !calib.parameters$any.to.other.death) {
      warning("Calibration parameters - Pinning transition totals to death states makes no sense")
    }
    ret$mort <- list()
  }
  
  ret$var.idxs <- which(select)
  fixed.idxs   <- setdiff(up.idxs, ret$var.idxs)
  
  for (i in 1:length(tpm)) {
    tp <- tpm[[i]]
    
    if (is.null(calib.parameters$age.groups) || i %in% calib.parameters$age.groups) {
      ret$var <- c(ret$var, tp[ret$var.idxs])
      ret$fixed[[length(ret$fixed)+1]] <- tp[fixed.idxs]
    } else {
      ret$fixed[[length(ret$fixed)+1]] <- tp[up.idxs]
    }
    
    if (calib.parameters$pin.any.to.death.totals) {
      ret$mort[[length(ret$mort)+1]] <- tp[,ncol(tp)-1] + tp[,ncol(tp)]
    }
  }
  
  return(ret)
}


