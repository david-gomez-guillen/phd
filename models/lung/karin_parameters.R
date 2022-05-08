N = 100000
Nsim=40
# show.band <- TRUE
show.band <- FALSE
show.overall <- TRUE
# show.overall <- FALSE

#interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
#                     diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
#                     
#                     screening_start_age=55,
#                     screening_end_age=65, 
#                     screening_periodicity=12,
#                     screening_coverage=0.1869,
#                    screening_quitters_years=15,
#                    survival_after_scr_dx=.3714,
#                    
#                    # p_smoker=.313,
#                    p_smoker=.271,
#                    # rr_smoker=32.67,
#                    rr_smoker=21.9,
#                    # p_smoker=0,
#                     # rr_smoker=1,
#                     
#                     
#                     quitting_interventions = list(list(
#                       # coverage     = .1869,
#                       # success_rate = .2,
#                       # # success_rate = .3977,
#                       # interv_steps = 240
#                     # ), list(
#                     #   # coverage     = .1869*(1-.2),
#                     #   # success_rate = .2,
#                     #   coverage     = .1869*(1-.3977),
#                     #   success_rate = .3977,
#                     #   interv_steps = 240+12*5
#                     # ), list(
#                     #   # coverage     = .1869*(1-.2)*(1-.2),
#                     #   # success_rate = .2,
#                     #   coverage     = .1869*(1-.3977)*(1-.3977),
#                     #   success_rate = .3977,
#                     #   interv_steps = 1+12*10
#                     )
#                     ),
#                     
#                     
#                     quitting_effect_type      = 'logistic',
#                     quitting_ref_years        = 15,
#                     quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
#)






#costs_p <- list(
#  screening=list(i=0),
#  # screening=list(i=175),
#  
#  # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
#  
#  quitting.int=list(i=0), # dummy
#  # quitting.int=list(i=26.84), # breu
#  # quitting.int=list(i=343.75), # intensiva
#  
#  # postdx_treatment=list(i=0),
#  postdx_treatment=list(i=14160.4),
#  
#  utilities=c(1,.705,.655,.530,0,0,0),
#  discount.factor=0.03
#)
#
#options_p <- list(
#  # print = TRUE,
#  #mpst_computation_states = c(1,2,3),
#  smoker_inc_type = "current"
#)
#



### no intervention

#interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
#                     diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
#                     
#                     # no quitting nor screening
#                     screening_start_age=55, screening_end_age=55, screening_periodicity=12, screening_coverage=0.1869, screening_quitters_years=15, survival_after_scr_dx=.3714,
#                     quitting_interventions = list(list()), quitting_effect_type = 'logistic', quitting_ref_years = 15, quitting_rr_after_ref_years = .2, # reducció 80% als 15 anys
#                     
#                     
#                     p_smoker=0,
#                     rr_smoker=1
#                     
#)
#costs_p <- list(
#  screening=list(i=0),
#  quitting.int=list(i=0), # dummy
#  postdx_treatment=list(i=14160.4),
#  
#  #usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
#  
#  utilities=c(1,.705,.655,.530,0,0,0),
#  
#  discount.factor=0.03
#)
#
#options_p <- list(
#  smoker_inc_type = "current"
#)


interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                     diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                     
                     screening_start_age=55,
                     screening_end_age=65,
                     screening_periodicity=12*3,
                     screening_coverage=0.1869,
                     screening_quitters_years=15,
                     survival_after_scr_dx=.3714,
                     
                     p_smoker=.313,
                     rr_smoker=32.67,
                     
                     quitting_interventions = list(list(
                       coverage     = .1869,
                       success_rate = .2,
                       #success_rate = .0994,
                       interv_steps = 1
                     ), list(
                       coverage     = .1869*(1-.2),
                       success_rate = .2,
                       #coverage     = .1869*(1-.0994),
                       #success_rate = .0994,
                       interv_steps = 1+12*5
                     ), list(
                       coverage     = .1869*(1-.2)*(1-.2),
                       success_rate = .2,
                       #coverage     = .1869*(1-.0994)*(1-.0994),
                       #success_rate = .0994,
                       interv_steps = 1+12*10
                     )
                     ),
                     
                     
                     quitting_effect_type      = 'logistic',
                     quitting_ref_years        = 15,
                     quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
)
costs_p=costs_p <- list(
  # screening=list(i=0),
  screening=list(i=175),
  
  # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
  
  # quitting.int=list(i=0), # dummy
  # quitting.int=list(i=26.84), # breu
  quitting.int=list(i=343.75), # intensiva
  
  # postdx_treatment=list(i=0),
  postdx_treatment=list(i=14160.4),#14160.7?
  
  utilities=c(1,.705,.655,.530,0,0,0),
  discount.factor=0.03
)
options_p <- list(
  smoker_inc_type = "current"
)



#### "3xII @35&40&45 (18%,)"

#interventions_p=list(diag_screen=c(0,0,0,0,0,0,0),
#                     diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
#                     
#                     screening_start_age=55,
#                     screening_end_age=55,
#                     screening_periodicity=12*3,
#                     screening_coverage=0,
#                     screening_quitters_years=15,
#                     survival_after_scr_dx=.3714,
#                     
#                     p_smoker=.313,
#                     rr_smoker=32.67,
#                     
#                     quitting_interventions = list(list(
#                       coverage     = .1869,
#                       success_rate = .2,
#                       interv_steps = 1
#                     ), list(
#                       coverage     = .1869*(1-.2),
#                       success_rate = .2,
#                       interv_steps = 1+12*5
#                     ), list(
#                       coverage     = .1869*(1-.2)*(1-.2),
#                       success_rate = .2,
#                       interv_steps = 1+12*10
#                     )
#                     ),
#                     
#                     
#                     quitting_effect_type      = 'logistic',
#                     quitting_ref_years        = 15,
#                     quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
#)
#costs_p=costs_p <- list(
#  # screening=list(i=0),
#  screening=list(i=175),
#  
#  # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
#  
#  # quitting.int=list(i=0), # dummy
#  # quitting.int=list(i=26.84), # breu
#  quitting.int=list(i=343.75), # intensiva
#  
#  # postdx_treatment=list(i=0),
#  postdx_treatment=list(i=14160.4),
#  
#  utilities=c(1,.705,.655,.530,0,0,0),
#  discount.factor=0.03
#)