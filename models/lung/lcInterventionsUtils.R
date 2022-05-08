# Returns a list of calibration parameters with the default values for each
# parameters, except for those parameters already present in calib.parameters
GetAllInterventionsParameters <- function(interventions_p=list()) {

  # General
  real.params <- kInterventionsDefaultParameters
  
  allowed.nams <- names(real.params)
  
  real.params[nams.provided <- names(interventions_p)] <- interventions_p
  if (length(new.nams <- nams.provided[!nams.provided %in% allowed.nams])) 
    warning("unknown parameters: ", paste(new.nams, collapse = ", "))
  
  
  # Particular case: quitting_interventions is a list of lists
  allowed.q.params <- names(kInterventionsDefaultParameters[["quitting_interventions"]][[1]])
  for (i in 1:length(real.params[["quitting_interventions"]])) {
    real.q.params <- kInterventionsDefaultParameters[["quitting_interventions"]][[1]]
    real.q.params[nams.provided <- names(real.params[["quitting_interventions"]][[i]])] <- real.params[["quitting_interventions"]][[i]]
    if (length(new.nams <- nams.provided[!nams.provided %in% allowed.q.params]))
      warning("unknown parameters in quitting intervention: ", paste(new.nams, collapse = ", "))
    
    real.params[["quitting_interventions"]][[i]] <- real.q.params
  }
  
  return(real.params)
}

