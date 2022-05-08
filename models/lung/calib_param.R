N = 100000
Nsim=40
# show.band <- TRUE
show.band <- FALSE
show.overall <- TRUE
# show.overall <- FALSE



### no intervention

interventions_p=list(diag_screen=c(0,0,0,0,0,0,0),
                     diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                     
                     # no quitting nor screening
                     screening_start_age=55, screening_end_age=55, screening_periodicity=12, screening_coverage=0.1869, screening_quitters_years=15, survival_after_scr_dx=.3714,
                     quitting_interventions = list(list()), quitting_effect_type = 'logistic', quitting_ref_years = 15, quitting_rr_after_ref_years = .2, # reducció 80% als 15 anys
                     
                     
                     p_smoker=0,
                     rr_smoker=1
                     
)
costs_p <- list(
  screening=list(i=0),
  quitting.int=list(i=0), # dummy
  postdx_treatment=list(i=14160.4),
  
  #usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
  
  utilities=c(1,.705,.655,.530,0,0,0),
  
  discount.factor=0.03
)

options_p <- list(
  smoker_inc_type = "current"
)


