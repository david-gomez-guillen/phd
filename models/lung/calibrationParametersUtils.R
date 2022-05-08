# Returns a list of calibration parameters with the default values for each
# parameters, except for those parameters already present in calib.parameters
GetAllCalibrationParameters <- function(calib.parameters=list()) {
  real.params <- list(
    well.to.cancer = TRUE,
    cancer.to.cancer = TRUE,
    cancer.to.lc.death = TRUE,
    any.to.other.death = TRUE,
    pin.any.to.death.totals = FALSE,
    pin.zeros = TRUE,
    age.groups = NULL
  )
  
  allowed.nams <- names(real.params)
  
  real.params[nams.provided <- names(calib.parameters)] <- calib.parameters
  if (length(new.nams <- nams.provided[!nams.provided %in% allowed.nams])) 
    warning("unknown parameters: ", paste(new.nams, collapse = ", "))
  
  return(real.params)
}