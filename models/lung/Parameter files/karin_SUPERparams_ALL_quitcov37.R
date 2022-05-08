ALL.PARAMETERS <- list(
  list(sim.name="1xBI @55 (37%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=55,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 240
                              # ), list(
                              #   # coverage     = .37*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 240+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
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
  
  
  list(sim.name="2xBI @55&60 (37%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=55,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              coverage     = .37*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 240+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
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
  
  
  list(sim.name="3xBI @55&60&65 (37%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=55,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              coverage     = .37*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 240+12*5
                            ), list(
                              coverage     = .37*(1-.2)*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977)*(1-.3977),
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
  
  
  list(sim.name="3xBI @55&56&57 (37%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=55,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              coverage     = .37*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 240+12*1
                            ), list(
                              coverage     = .37*(1-.2)*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977)*(1-.3977),
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
  ),
  
  ################################################################################ 
  
  
  list(sim.name="1xBI @35 (37%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=55,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 1
                              # ), list(
                              #   # coverage     = .37*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 240+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
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
  
  
  list(sim.name="2xBI @35&40 (37%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=55,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              coverage     = .37*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 1+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
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
  
  
  list(sim.name="2xBI @35&55 (37%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=55,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              coverage     = .37*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 1+12*20
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
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
  
  
  list(sim.name="3xBI @35&40&45 (37%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=55,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              coverage     = .37*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 1+12*5
                            ), list(
                              coverage     = .37*(1-.2)*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977)*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 1+12*10
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
  
  
  list(sim.name="1xII @55 (37%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=55,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 240
                              # ), list(
                              #   # coverage     = .37*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 240+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
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
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="2xII @55&60 (37%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=55,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              # coverage     = .37*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 240+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
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
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="3xII @55&60&65 (37%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=55,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              # coverage     = .37*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 240+12*5
                            ), list(
                              # coverage     = .37*(1-.2)*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977)*(1-.3977),
                              success_rate = .3977,
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
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="3xII @55&56&57 (37%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=55,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              # coverage     = .37*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 240+12*1
                            ), list(
                              # coverage     = .37*(1-.2)*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977)*(1-.3977),
                              success_rate = .3977,
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
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################ 
  
  
  list(sim.name="1xII @35 (37%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=55,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 1
                              # ), list(
                              #   # coverage     = .37*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 240+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
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
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="2xII @35&40 (37%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=55,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              # coverage     = .37*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 1+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
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
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="2xII @35&55 (37%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=55,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              # coverage     = .37*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 1+12*20
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
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
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="3xII @35&40&45 (37%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=55,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              # coverage     = .37*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 1+12*5
                            ), list(
                              # coverage     = .37*(1-.2)*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977)*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 1+12*10
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
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################ 
  
  
  list(sim.name="1xBI @55 (37%) + 1xSCR-HR @55 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=56,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 240
                              # ), list(
                              #   # coverage     = .37*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 240+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="2xBI @55&60 (37%) + 1xSCR-HR @55 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=56,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              coverage     = .37*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 240+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="3xBI @55&60&65 (37%) + 1xSCR-HR @55 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=56,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              coverage     = .37*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 240+12*5
                            ), list(
                              coverage     = .37*(1-.2)*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977)*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 240+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="3xBI @55&56&57 (37%) + 1xSCR-HR @55 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=56,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              coverage     = .37*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 240+12*1
                            ), list(
                              coverage     = .37*(1-.2)*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977)*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 240+12*2
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="1xBI @35 (37%) + 1xSCR-HR @55 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=56,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 1
                              # ), list(
                              #   # coverage     = .37*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 240+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="2xBI @35&40 (37%) + 1xSCR-HR @55 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=56,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              coverage     = .37*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 1+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="2xBI @35&55 (37%) + 1xSCR-HR @55 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=56,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              coverage     = .37*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 1+12*20
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="3xBI @35&40&45 (37%) + 1xSCR-HR @55 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=56,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              coverage     = .37*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 1+12*5
                            ), list(
                              coverage     = .37*(1-.2)*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977)*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="1xII @55 (37%) + 1xSCR-HR @55 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=56,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 240
                              # ), list(
                              #   # coverage     = .37*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 240+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="2xII @55&60 (37%) + 1xSCR-HR @55 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=56,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              # coverage     = .37*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 240+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="3xII @55&60&65 (37%) + 1xSCR-HR @55 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=56,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              # coverage     = .37*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 240+12*5
                            ), list(
                              # coverage     = .37*(1-.2)*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977)*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 240+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="3xII @55&56&57 (37%) + 1xSCR-HR @55 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=56,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              # coverage     = .37*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 240+12*1
                            ), list(
                              # coverage     = .37*(1-.2)*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977)*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 240+12*2
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################ 
  
  
  list(sim.name="1xII @35 (37%) + 1xSCR-HR @55 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=56,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 1
                              # ), list(
                              #   # coverage     = .37*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 240+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="2xII @35&40 (37%) + 1xSCR-HR @55 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=56,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              # coverage     = .37*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 1+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="2xII @35&55 (37%) + 1xSCR-HR @55 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=56,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              # coverage     = .37*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 1+12*20
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="3xII @35&40&45 (37%) + 1xSCR-HR @55 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=56,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              # coverage     = .37*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 1+12*5
                            ), list(
                              # coverage     = .37*(1-.2)*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977)*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################ 
  
  
  list(sim.name="1xBI @55 (37%) + 2xSCR-HR @55&56 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=57,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 240
                              # ), list(
                              #   # coverage     = .37*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 240+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="2xBI @55&60 (37%) + 2xSCR-HR @55&56 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=57,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              coverage     = .37*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 240+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="3xBI @55&60&65 (37%) + 2xSCR-HR @55&56 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=57,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              coverage     = .37*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 240+12*5
                            ), list(
                              coverage     = .37*(1-.2)*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977)*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 240+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="3xBI @55&56&57 (37%) + 2xSCR-HR @55&56 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=57,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              coverage     = .37*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 240+12*1
                            ), list(
                              coverage     = .37*(1-.2)*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977)*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 240+12*2
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="1xBI @35 (37%) + 2xSCR-HR @55&56 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=57,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 1
                              # ), list(
                              #   # coverage     = .37*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 240+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="2xBI @35&40 (37%) + 2xSCR-HR @55&56 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=57,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              coverage     = .37*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 1+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="2xBI @35&55 (37%) + 2xSCR-HR @55&56 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=57,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              coverage     = .37*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 1+12*20
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="3xBI @35&40&45 (37%) + 2xSCR-HR @55&56 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=57,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              coverage     = .37*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 1+12*5
                            ), list(
                              coverage     = .37*(1-.2)*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977)*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="1xII @55 (37%) + 2xSCR-HR @55&56 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=57,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 240
                              # ), list(
                              #   # coverage     = .37*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 240+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="2xII @55&60 (37%) + 2xSCR-HR @55&56 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=57,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              # coverage     = .37*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 240+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="3xII @55&60&65 (37%) + 2xSCR-HR @55&56 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=57,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              # coverage     = .37*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 240+12*5
                            ), list(
                              # coverage     = .37*(1-.2)*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977)*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 240+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="3xII @55&56&57 (37%) + 2xSCR-HR @55&56 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=57,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              # coverage     = .37*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 240+12*1
                            ), list(
                              # coverage     = .37*(1-.2)*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977)*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 240+12*2
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################ 
  
  
  list(sim.name="1xII @35 (37%) + 2xSCR-HR @55&56 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=57,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 1
                              # ), list(
                              #   # coverage     = .37*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 240+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="2xII @35&40 (37%) + 2xSCR-HR @55&56 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=57,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              # coverage     = .37*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 1+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="2xII @35&55 (37%) + 2xSCR-HR @55&56 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=57,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              # coverage     = .37*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 1+12*20
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="3xII @35&40&45 (37%) + 2xSCR-HR @55&56 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=57,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              # coverage     = .37*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 1+12*5
                            ), list(
                              # coverage     = .37*(1-.2)*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977)*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################ 
  
  
  list(sim.name="1xBI @55 (37%) + 3xSCR-HR @55&56&57 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=58,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 240
                              # ), list(
                              #   # coverage     = .37*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 240+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="2xBI @55&60 (37%) + 3xSCR-HR @55&56&57 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=58,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              coverage     = .37*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 240+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="3xBI @55&60&65 (37%) + 3xSCR-HR @55&56&57 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=58,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              coverage     = .37*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 240+12*5
                            ), list(
                              coverage     = .37*(1-.2)*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977)*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 240+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="3xBI @55&56&57 (37%) + 3xSCR-HR @55&56&57 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=58,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              coverage     = .37*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 240+12*1
                            ), list(
                              coverage     = .37*(1-.2)*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977)*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 240+12*2
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="1xBI @35 (37%) + 3xSCR-HR @55&56&57 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=58,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 1
                              # ), list(
                              #   # coverage     = .37*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 240+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="2xBI @35&40 (37%) + 3xSCR-HR @55&56&57 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=58,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              coverage     = .37*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 1+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="2xBI @35&55 (37%) + 3xSCR-HR @55&56&57 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=58,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              coverage     = .37*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 1+12*20
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="3xBI @35&40&45 (37%) + 3xSCR-HR @55&56&57 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=58,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              coverage     = .37*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 1+12*5
                            ), list(
                              coverage     = .37*(1-.2)*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977)*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="1xII @55 (37%) + 3xSCR-HR @55&56&57 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=58,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 240
                              # ), list(
                              #   # coverage     = .37*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 240+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="2xII @55&60 (37%) + 3xSCR-HR @55&56&57 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=58,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              # coverage     = .37*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 240+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="3xII @55&60&65 (37%) + 3xSCR-HR @55&56&57 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=58,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              # coverage     = .37*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 240+12*5
                            ), list(
                              # coverage     = .37*(1-.2)*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977)*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 240+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="3xII @55&56&57 (37%) + 3xSCR-HR @55&56&57 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=58,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              # coverage     = .37*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 240+12*1
                            ), list(
                              # coverage     = .37*(1-.2)*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977)*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 240+12*2
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################ 
  
  
  list(sim.name="1xII @35 (37%) + 3xSCR-HR @55&56&57 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=58,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 1
                              # ), list(
                              #   # coverage     = .37*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 240+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="2xII @35&40 (37%) + 3xSCR-HR @55&56&57 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=58,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              # coverage     = .37*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 1+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="2xII @35&55 (37%) + 3xSCR-HR @55&56&57 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=58,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              # coverage     = .37*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 1+12*20
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="3xII @35&40&45 (37%) + 3xSCR-HR @55&56&57 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=58,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              # coverage     = .37*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 1+12*5
                            ), list(
                              # coverage     = .37*(1-.2)*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977)*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################ 
  
  
  list(sim.name="1xBI @55 (37%) + 2xSCR-HR @55&60 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=61,
                            screening_periodicity=12*5,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 240
                              # ), list(
                              #   # coverage     = .37*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 240+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="2xBI @55&60 (37%) + 2xSCR-HR @55&60 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=61,
                            screening_periodicity=12*5,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              coverage     = .37*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 240+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="3xBI @55&60&65 (37%) + 2xSCR-HR @55&60 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=61,
                            screening_periodicity=12*5,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              coverage     = .37*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 240+12*5
                            ), list(
                              coverage     = .37*(1-.2)*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977)*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 240+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="3xBI @55&56&57 (37%) + 2xSCR-HR @55&60 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=61,
                            screening_periodicity=12*5,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              coverage     = .37*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 240+12*1
                            ), list(
                              coverage     = .37*(1-.2)*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977)*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 240+12*2
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="1xBI @35 (37%) + 2xSCR-HR @55&60 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=61,
                            screening_periodicity=12*5,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 1
                              # ), list(
                              #   # coverage     = .37*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 240+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="2xBI @35&40 (37%) + 2xSCR-HR @55&60 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=61,
                            screening_periodicity=12*5,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              coverage     = .37*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 1+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="2xBI @35&55 (37%) + 2xSCR-HR @55&60 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=61,
                            screening_periodicity=12*5,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              coverage     = .37*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 1+12*20
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="3xBI @35&40&45 (37%) + 2xSCR-HR @55&60 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=61,
                            screening_periodicity=12*5,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              coverage     = .37*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 1+12*5
                            ), list(
                              coverage     = .37*(1-.2)*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977)*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="1xII @55 (37%) + 2xSCR-HR @55&60 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=61,
                            screening_periodicity=12*5,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 240
                              # ), list(
                              #   # coverage     = .37*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 240+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="2xII @55&60 (37%) + 2xSCR-HR @55&60 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=61,
                            screening_periodicity=12*5,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              # coverage     = .37*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 240+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="3xII @55&60&65 (37%) + 2xSCR-HR @55&60 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=61,
                            screening_periodicity=12*5,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              # coverage     = .37*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 240+12*5
                            ), list(
                              # coverage     = .37*(1-.2)*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977)*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 240+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="3xII @55&56&57 (37%) + 2xSCR-HR @55&60 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=61,
                            screening_periodicity=12*5,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              # coverage     = .37*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 240+12*1
                            ), list(
                              # coverage     = .37*(1-.2)*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977)*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 240+12*2
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################ 
  
  
  list(sim.name="1xII @35 (37%) + 2xSCR-HR @55&60 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=61,
                            screening_periodicity=12*5,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 1
                              # ), list(
                              #   # coverage     = .37*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 240+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="2xII @35&40 (37%) + 2xSCR-HR @55&60 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=61,
                            screening_periodicity=12*5,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              # coverage     = .37*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 1+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="2xII @35&55 (37%) + 2xSCR-HR @55&60 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=61,
                            screening_periodicity=12*5,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              # coverage     = .37*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 1+12*20
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="3xII @35&40&45 (37%) + 2xSCR-HR @55&60 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=61,
                            screening_periodicity=12*5,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              # coverage     = .37*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 1+12*5
                            ), list(
                              # coverage     = .37*(1-.2)*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977)*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################ 
  
  
  list(sim.name="1xBI @55 (37%) + 3xSCR-HR @55&60&65 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=66,
                            screening_periodicity=12*5,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 240
                              # ), list(
                              #   # coverage     = .37*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 240+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="2xBI @55&60 (37%) + 3xSCR-HR @55&60&65 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=66,
                            screening_periodicity=12*5,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              coverage     = .37*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 240+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="3xBI @55&60&65 (37%) + 3xSCR-HR @55&60&65 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=66,
                            screening_periodicity=12*5,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              coverage     = .37*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 240+12*5
                            ), list(
                              coverage     = .37*(1-.2)*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977)*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 240+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="3xBI @55&56&57 (37%) + 3xSCR-HR @55&60&65 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=66,
                            screening_periodicity=12*5,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              coverage     = .37*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 240+12*1
                            ), list(
                              coverage     = .37*(1-.2)*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977)*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 240+12*2
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="1xBI @35 (37%) + 3xSCR-HR @55&60&65 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=66,
                            screening_periodicity=12*5,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 1
                              # ), list(
                              #   # coverage     = .37*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 240+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="2xBI @35&40 (37%) + 3xSCR-HR @55&60&65 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=66,
                            screening_periodicity=12*5,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              coverage     = .37*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 1+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="2xBI @35&55 (37%) + 3xSCR-HR @55&60&65 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=66,
                            screening_periodicity=12*5,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              coverage     = .37*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 1+12*20
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="3xBI @35&40&45 (37%) + 3xSCR-HR @55&60&65 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=66,
                            screening_periodicity=12*5,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              coverage     = .37*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 1+12*5
                            ), list(
                              coverage     = .37*(1-.2)*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977)*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="1xII @55 (37%) + 3xSCR-HR @55&60&65 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=66,
                            screening_periodicity=12*5,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 240
                              # ), list(
                              #   # coverage     = .37*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 240+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="2xII @55&60 (37%) + 3xSCR-HR @55&60&65 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=66,
                            screening_periodicity=12*5,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              # coverage     = .37*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 240+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="3xII @55&60&65 (37%) + 3xSCR-HR @55&60&65 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=66,
                            screening_periodicity=12*5,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              # coverage     = .37*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 240+12*5
                            ), list(
                              # coverage     = .37*(1-.2)*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977)*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 240+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="3xII @55&56&57 (37%) + 3xSCR-HR @55&60&65 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=66,
                            screening_periodicity=12*5,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              # coverage     = .37*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 240+12*1
                            ), list(
                              # coverage     = .37*(1-.2)*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977)*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 240+12*2
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################ 
  
  
  list(sim.name="1xII @35 (37%) + 3xSCR-HR @55&60&65 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=66,
                            screening_periodicity=12*5,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 1
                              # ), list(
                              #   # coverage     = .37*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 240+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="2xII @35&40 (37%) + 3xSCR-HR @55&60&65 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=66,
                            screening_periodicity=12*5,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              # coverage     = .37*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 1+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="2xII @35&55 (37%) + 3xSCR-HR @55&60&65 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=66,
                            screening_periodicity=12*5,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              # coverage     = .37*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 1+12*20
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="3xII @35&40&45 (37%) + 3xSCR-HR @55&60&65 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=66,
                            screening_periodicity=12*5,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              # coverage     = .37*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 1+12*5
                            ), list(
                              # coverage     = .37*(1-.2)*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977)*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################ 
  
  
  list(sim.name="1xBI @55 (37%) + 1y-xSCR-HR @55-65 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=65,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 240
                              # ), list(
                              #   # coverage     = .37*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 240+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="2xBI @55&60 (37%) + 1y-xSCR-HR @55-65 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=65,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              coverage     = .37*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 240+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="3xBI @55&60&65 (37%) + 1y-xSCR-HR @55-65 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=65,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              coverage     = .37*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 240+12*5
                            ), list(
                              coverage     = .37*(1-.2)*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977)*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 240+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="3xBI @55&56&57 (37%) + 1y-xSCR-HR @55-65 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=65,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              coverage     = .37*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 240+12*1
                            ), list(
                              coverage     = .37*(1-.2)*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977)*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 240+12*2
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="1xBI @35 (37%) + 1y-xSCR-HR @55-65 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=65,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 1
                              # ), list(
                              #   # coverage     = .37*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 240+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="2xBI @35&40 (37%) + 1y-xSCR-HR @55-65 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=65,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              coverage     = .37*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 1+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="2xBI @35&55 (37%) + 1y-xSCR-HR @55-65 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=65,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              coverage     = .37*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 1+12*20
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="3xBI @35&40&45 (37%) + 1y-xSCR-HR @55-65 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=65,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              coverage     = .37*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 1+12*5
                            ), list(
                              coverage     = .37*(1-.2)*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977)*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="1xII @55 (37%) + 1y-xSCR-HR @55-65 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=65,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 240
                              # ), list(
                              #   # coverage     = .37*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 240+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="2xII @55&60 (37%) + 1y-xSCR-HR @55-65 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=65,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              # coverage     = .37*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 240+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="3xII @55&60&65 (37%) + 1y-xSCR-HR @55-65 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=65,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              # coverage     = .37*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 240+12*5
                            ), list(
                              # coverage     = .37*(1-.2)*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977)*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 240+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="3xII @55&56&57 (37%) + 1y-xSCR-HR @55-65 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=65,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              # coverage     = .37*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 240+12*1
                            ), list(
                              # coverage     = .37*(1-.2)*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977)*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 240+12*2
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################ 
  
  
  list(sim.name="1xII @35 (37%) + 1y-xSCR-HR @55-65 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=65,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 1
                              # ), list(
                              #   # coverage     = .37*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 240+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="2xII @35&40 (37%) + 1y-xSCR-HR @55-65 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=65,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              # coverage     = .37*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 1+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="2xII @35&55 (37%) + 1y-xSCR-HR @55-65 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=65,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              # coverage     = .37*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 1+12*20
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="3xII @35&40&45 (37%) + 1y-xSCR-HR @55-65 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=65,
                            screening_periodicity=12*1,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              # coverage     = .37*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 1+12*5
                            ), list(
                              # coverage     = .37*(1-.2)*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977)*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################ 
  
  
  list(sim.name="1xBI @55 (37%) + 2y-xSCR-HR @55-65 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=65,
                            screening_periodicity=12*2,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 240
                              # ), list(
                              #   # coverage     = .37*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 240+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="2xBI @55&60 (37%) + 2y-xSCR-HR @55-65 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=65,
                            screening_periodicity=12*2,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              coverage     = .37*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 240+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="3xBI @55&60&65 (37%) + 2y-xSCR-HR @55-65 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=65,
                            screening_periodicity=12*2,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              coverage     = .37*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 240+12*5
                            ), list(
                              coverage     = .37*(1-.2)*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977)*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 240+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="3xBI @55&56&57 (37%) + 2y-xSCR-HR @55-65 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=65,
                            screening_periodicity=12*2,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              coverage     = .37*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 240+12*1
                            ), list(
                              coverage     = .37*(1-.2)*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977)*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 240+12*2
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="1xBI @35 (37%) + 2y-xSCR-HR @55-65 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=65,
                            screening_periodicity=12*2,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 1
                              # ), list(
                              #   # coverage     = .37*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 240+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="2xBI @35&40 (37%) + 2y-xSCR-HR @55-65 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=65,
                            screening_periodicity=12*2,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              coverage     = .37*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 1+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="2xBI @35&55 (37%) + 2y-xSCR-HR @55-65 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=65,
                            screening_periodicity=12*2,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              coverage     = .37*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 1+12*20
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="3xBI @35&40&45 (37%) + 2y-xSCR-HR @55-65 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=65,
                            screening_periodicity=12*2,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              coverage     = .37*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 1+12*5
                            ), list(
                              coverage     = .37*(1-.2)*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977)*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="1xII @55 (37%) + 2y-xSCR-HR @55-65 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=65,
                            screening_periodicity=12*2,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 240
                              # ), list(
                              #   # coverage     = .37*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 240+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="2xII @55&60 (37%) + 2y-xSCR-HR @55-65 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=65,
                            screening_periodicity=12*2,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              # coverage     = .37*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 240+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="3xII @55&60&65 (37%) + 2y-xSCR-HR @55-65 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=65,
                            screening_periodicity=12*2,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              # coverage     = .37*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 240+12*5
                            ), list(
                              # coverage     = .37*(1-.2)*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977)*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 240+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="3xII @55&56&57 (37%) + 2y-xSCR-HR @55-65 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=65,
                            screening_periodicity=12*2,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              # coverage     = .37*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 240+12*1
                            ), list(
                              # coverage     = .37*(1-.2)*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977)*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 240+12*2
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################ 
  
  
  list(sim.name="1xII @35 (37%) + 2y-xSCR-HR @55-65 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=65,
                            screening_periodicity=12*2,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 1
                              # ), list(
                              #   # coverage     = .37*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 240+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="2xII @35&40 (37%) + 2y-xSCR-HR @55-65 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=65,
                            screening_periodicity=12*2,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              # coverage     = .37*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 1+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="2xII @35&55 (37%) + 2y-xSCR-HR @55-65 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=65,
                            screening_periodicity=12*2,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              # coverage     = .37*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 1+12*20
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="3xII @35&40&45 (37%) + 2y-xSCR-HR @55-65 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=65,
                            screening_periodicity=12*2,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              # coverage     = .37*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 1+12*5
                            ), list(
                              # coverage     = .37*(1-.2)*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977)*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################ 
  
  
  list(sim.name="1xBI @55 (37%) + 3y-xSCR-HR @55-65 (18%)",
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
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 240
                              # ), list(
                              #   # coverage     = .37*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 240+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="2xBI @55&60 (37%) + 3y-xSCR-HR @55-65 (18%)",
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
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              coverage     = .37*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 240+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="3xBI @55&60&65 (37%) + 3y-xSCR-HR @55-65 (18%)",
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
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              coverage     = .37*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 240+12*5
                            ), list(
                              coverage     = .37*(1-.2)*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977)*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 240+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="3xBI @55&56&57 (37%) + 3y-xSCR-HR @55-65 (18%)",
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
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              coverage     = .37*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 240+12*1
                            ), list(
                              coverage     = .37*(1-.2)*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977)*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 240+12*2
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="1xBI @35 (37%) + 3y-xSCR-HR @55-65 (18%)",
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
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 1
                              # ), list(
                              #   # coverage     = .37*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 240+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="2xBI @35&40 (37%) + 3y-xSCR-HR @55-65 (18%)",
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
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              coverage     = .37*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 1+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="2xBI @35&55 (37%) + 3y-xSCR-HR @55-65 (18%)",
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
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              coverage     = .37*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 1+12*20
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="3xBI @35&40&45 (37%) + 3y-xSCR-HR @55-65 (18%)",
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
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              coverage     = .37*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 1+12*5
                            ), list(
                              coverage     = .37*(1-.2)*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977)*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="1xII @55 (37%) + 3y-xSCR-HR @55-65 (18%)",
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
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 240
                              # ), list(
                              #   # coverage     = .37*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 240+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="2xII @55&60 (37%) + 3y-xSCR-HR @55-65 (18%)",
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
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              # coverage     = .37*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 240+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="3xII @55&60&65 (37%) + 3y-xSCR-HR @55-65 (18%)",
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
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              # coverage     = .37*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 240+12*5
                            ), list(
                              # coverage     = .37*(1-.2)*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977)*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 240+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="3xII @55&56&57 (37%) + 3y-xSCR-HR @55-65 (18%)",
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
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              # coverage     = .37*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 240+12*1
                            ), list(
                              # coverage     = .37*(1-.2)*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977)*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 240+12*2
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################ 
  
  
  list(sim.name="1xII @35 (37%) + 3y-xSCR-HR @55-65 (18%)",
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
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 1
                              # ), list(
                              #   # coverage     = .37*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 240+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="2xII @35&40 (37%) + 3y-xSCR-HR @55-65 (18%)",
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
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              # coverage     = .37*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 1+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="2xII @35&55 (37%) + 3y-xSCR-HR @55-65 (18%)",
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
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              # coverage     = .37*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 1+12*20
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="3xII @35&40&45 (37%) + 3y-xSCR-HR @55-65 (18%)",
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
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              # coverage     = .37*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 1+12*5
                            ), list(
                              # coverage     = .37*(1-.2)*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977)*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################ 
  
  
  list(sim.name="1xBI @55 (37%) + 4y-xSCR-HR @55-65 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=65,
                            screening_periodicity=12*4,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 240
                              # ), list(
                              #   # coverage     = .37*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 240+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="2xBI @55&60 (37%) + 4y-xSCR-HR @55-65 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=65,
                            screening_periodicity=12*4,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              coverage     = .37*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 240+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="3xBI @55&60&65 (37%) + 4y-xSCR-HR @55-65 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=65,
                            screening_periodicity=12*4,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              coverage     = .37*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 240+12*5
                            ), list(
                              coverage     = .37*(1-.2)*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977)*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 240+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="3xBI @55&56&57 (37%) + 4y-xSCR-HR @55-65 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=65,
                            screening_periodicity=12*4,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              coverage     = .37*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 240+12*1
                            ), list(
                              coverage     = .37*(1-.2)*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977)*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 240+12*2
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="1xBI @35 (37%) + 4y-xSCR-HR @55-65 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=65,
                            screening_periodicity=12*4,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 1
                              # ), list(
                              #   # coverage     = .37*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 240+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="2xBI @35&40 (37%) + 4y-xSCR-HR @55-65 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=65,
                            screening_periodicity=12*4,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              coverage     = .37*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 1+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="2xBI @35&55 (37%) + 4y-xSCR-HR @55-65 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=65,
                            screening_periodicity=12*4,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              coverage     = .37*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 1+12*20
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="3xBI @35&40&45 (37%) + 4y-xSCR-HR @55-65 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=65,
                            screening_periodicity=12*4,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              coverage     = .37*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 1+12*5
                            ), list(
                              coverage     = .37*(1-.2)*(1-.2),
                              success_rate = .2,
                              # coverage     = .37*(1-.3977)*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
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
  
  
  list(sim.name="1xII @55 (37%) + 4y-xSCR-HR @55-65 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=65,
                            screening_periodicity=12*4,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 240
                              # ), list(
                              #   # coverage     = .37*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 240+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="2xII @55&60 (37%) + 4y-xSCR-HR @55-65 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=65,
                            screening_periodicity=12*4,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              # coverage     = .37*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 240+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="3xII @55&60&65 (37%) + 4y-xSCR-HR @55-65 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=65,
                            screening_periodicity=12*4,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              # coverage     = .37*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 240+12*5
                            ), list(
                              # coverage     = .37*(1-.2)*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977)*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 240+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="3xII @55&56&57 (37%) + 4y-xSCR-HR @55-65 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=65,
                            screening_periodicity=12*4,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              # coverage     = .37*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 240+12*1
                            ), list(
                              # coverage     = .37*(1-.2)*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977)*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 240+12*2
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################ 
  
  
  list(sim.name="1xII @35 (37%) + 4y-xSCR-HR @55-65 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=65,
                            screening_periodicity=12*4,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 1
                              # ), list(
                              #   # coverage     = .37*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 240+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="2xII @35&40 (37%) + 4y-xSCR-HR @55-65 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=65,
                            screening_periodicity=12*4,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              # coverage     = .37*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 1+12*5
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="2xII @35&55 (37%) + 4y-xSCR-HR @55-65 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=65,
                            screening_periodicity=12*4,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              # coverage     = .37*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 1+12*20
                              # ), list(
                              #   # coverage     = .37*(1-.2)*(1-.2),
                              #   # success_rate = .2,
                              #   coverage     = .37*(1-.3977)*(1-.3977),
                              #   success_rate = .3977,
                              #   interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="3xII @35&40&45 (37%) + 4y-xSCR-HR @55-65 (18%)",
       interventions_p=list(diag_screen=c(0,0.604,0.604,0.604,0,0,0),
                            diag_spont= c(5e-8,1e-5,1e-4,1e-3,0,0,0),
                            
                            screening_start_age=55,
                            screening_end_age=65,
                            screening_periodicity=12*4,
                            screening_coverage=0.1869,
                            screening_quitters_years=15,
                            survival_after_scr_dx=.3714,
                            
                            p_smoker=.313,
                            rr_smoker=32.67,
                            
                            quitting_interventions = list(list(
                              coverage     = .37,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              # coverage     = .37*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 1+12*5
                            ), list(
                              # coverage     = .37*(1-.2)*(1-.2),
                              # success_rate = .2,
                              coverage     = .37*(1-.3977)*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 1+12*10
                            )
                            ),
                            
                            
                            quitting_effect_type      = 'logistic',
                            quitting_ref_years        = 15,
                            quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
       ),
       costs_p=costs_p <- list(
         # screening=list(i=0),
         screening=list(i=175),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=26.84), # breu
         quitting.int=list(i=343.75), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  )
  
  ################################################################################ 
  
  
  
  
)
