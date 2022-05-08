ALL.PARAMETERS <- list(
  list(sim.name="FEM Base-No intervention",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=55,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.271,
                            rr_smoker=21.88,
                            
                            quitting_interventions = list(list(
                              # coverage     = .1869,
                              # success_rate = .2,
                              # success_rate = .3977,
                              # interv_steps = 240
                              # ), list(
                              #   # coverage     = .1869*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .1869*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 240+12*5
                              # ), list(
                              #   # coverage     = .1869*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .1869*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         screening=list(i=0),
         # screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         # quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="FEM 1xBI @55 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=55,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.271,
                            rr_smoker=21.88,
                            
                            quitting_interventions = list(list(
                              coverage     = .1869,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 240
                              # ), list(
                              #   # coverage     = .1869*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .1869*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 240+12*5
                              # ), list(
                              #   # coverage     = .1869*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .1869*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         screening=list(i=0),
         # screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         quitting.int=list(i=26.84), # breu
         # quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="FEM 2xBI @55&60 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=55,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.271,
                            rr_smoker=21.88,
                            
                            quitting_interventions = list(list(
                              coverage     = .1869,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              coverage     = .1869*(1-.2),
                              success_rate = .2,
                              # coverage     = .1869*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 240+12*5
                              # ), list(
                              #   # coverage     = .1869*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .1869*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         screening=list(i=0),
         # screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         quitting.int=list(i=26.84), # breu
         # quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="FEM 3xBI @55&60&65 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=55,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.271,
                            rr_smoker=21.88,
                            
                            quitting_interventions = list(list(
                              coverage     = .1869,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              coverage     = .1869*(1-.2),
                              success_rate = .2,
                              # coverage     = .1869*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 240+12*5
                            ), list(
                              coverage     = .1869*(1-.2)*(1-.2),
                              success_rate = .2,
                              # coverage     = .1869*(1-.3977)*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 240+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         screening=list(i=0),
         # screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         quitting.int=list(i=26.84), # breu
         # quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="FEM 3xBI @55&56&57 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=55,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.271,
                            rr_smoker=21.88,
                            
                            quitting_interventions = list(list(
                              coverage     = .1869,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              coverage     = .1869*(1-.2),
                              success_rate = .2,
                              # coverage     = .1869*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 240+12*1
                            ), list(
                              coverage     = .1869*(1-.2)*(1-.2),
                              success_rate = .2,
                              # coverage     = .1869*(1-.3977)*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 240+12*2
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         screening=list(i=0),
         # screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         quitting.int=list(i=26.84), # breu
         # quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  )
  
  ################################################################################ 
  
  
)
