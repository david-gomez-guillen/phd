# Constant definition by default
kStartAge <- 35L
kEndAge   <- 80L
kPeriods  <- 12L  # monthly
kHealthy  <- 1e5L
kAlive    <- 500L # Deprecated? Used in DistanceFunction
kDefaultGroupLength <- 5

kNsim <- 40
kNcores <- 8

kInterventionsDefaultParameters <- list(
  diag_screen = 0,  # ha de ser un vector de mida el nombre d'estats, o 0
  diag_spont  = 0,  # ha de ser un vector de mida el nombre d'estats, o 0
  p_smoker    = 0,
  rr_smoker   = 1,
  screening_start_age       = kStartAge,
  screening_end_age         = kEndAge,
  screening_periodicity     = 1,
  screening_coverage        = 0,
  screening_not_smokers     = 0,  # 0: no screening, 1: sí screening
  screening_quitters_years  = 0,  # n: screening for n years after quitting
  survival_after_scr_dx     = 0,
  
  quitting_effect_type      = 'constant',  # 'constant', 'exponential', 'logistic'
  quitting_ref_years        = 0,
  quitting_rr_after_ref_years = 1,
  quitting_interventions = list(
    list(
      coverage                  = 0,
      success_rate              = 0,
      interv_steps              = integer(0)
    )
  )
)

kOptionsDefaultIncidence <- list(from=0, to=list(c(1,2,3)))

age.weights <- list(crude=c(0.1641, 0.1544, 0.1450, 0.1283, 0.1079, 0.0953, 0.0845, 0.0619, 0.059), # crude age weights Spain 2013 from age 35 to 80
                    standard=c(0.1786, 0.1735, 0.1582, 0.1327, 0.1173, 0.0918, 0.0663, 0.0459, 0.0357) # standard age weights World 2013 from age 35 to 80
)
