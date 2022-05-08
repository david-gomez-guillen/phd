ALL.PARAMETERS <- list(
  list(sim.name="3xII @55&60&65 (18%)[$+100%] + 1y-xSCR-HR @55 (18%)[$+100%]",
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
                              coverage     = .1869,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              # coverage     = .1869*(1-.2),
                              # success_rate = .2,
                              coverage     = .1869*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 240+12*5
                            ), list(
                              # coverage     = .1869*(1-.2)*(1-.2),
                              # success_rate = .2,
                              coverage     = .1869*(1-.3977)*(1-.3977),
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
         screening=list(i=350),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=53.68), # breu
         quitting.int=list(i=687.50), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="3xII @55&56&57 (18%)[$+100%] + 1y-xSCR-HR @55 (18%)[$+100%]",
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
                              coverage     = .1869,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              # coverage     = .1869*(1-.2),
                              # success_rate = .2,
                              coverage     = .1869*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 240+12*1
                            ), list(
                              # coverage     = .1869*(1-.2)*(1-.2),
                              # success_rate = .2,
                              coverage     = .1869*(1-.3977)*(1-.3977),
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
         screening=list(i=350),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=53.68), # breu
         quitting.int=list(i=687.50), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################ 
  
  
  list(sim.name="1xII @35 (18%)[$+100%] + 1y-xSCR-HR @55 (18%)[$+100%]",
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
                              coverage     = .1869,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 1
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
         # screening=list(i=0),
         screening=list(i=350),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=53.68), # breu
         quitting.int=list(i=687.50), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="2xII @35&40 (18%)[$+100%] + 1y-xSCR-HR @55 (18%)[$+100%]",
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
                              coverage     = .1869,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              # coverage     = .1869*(1-.2),
                              # success_rate = .2,
                              coverage     = .1869*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 1+12*5
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
         # screening=list(i=0),
         screening=list(i=350),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=53.68), # breu
         quitting.int=list(i=687.50), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="2xII @35&55 (18%)[$+100%] + 1y-xSCR-HR @55 (18%)[$+100%]",
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
                              coverage     = .1869,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              # coverage     = .1869*(1-.2),
                              # success_rate = .2,
                              coverage     = .1869*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 1+12*20
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
         # screening=list(i=0),
         screening=list(i=350),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=53.68), # breu
         quitting.int=list(i=687.50), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="3xII @35&40&45 (18%)[$+100%] + 1y-xSCR-HR @55 (18%)[$+100%]",
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
                              coverage     = .1869,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              # coverage     = .1869*(1-.2),
                              # success_rate = .2,
                              coverage     = .1869*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 1+12*5
                            ), list(
                              # coverage     = .1869*(1-.2)*(1-.2),
                              # success_rate = .2,
                              coverage     = .1869*(1-.3977)*(1-.3977),
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
         screening=list(i=350),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=53.68), # breu
         quitting.int=list(i=687.50), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################ 
  
  
  list(sim.name="1xBI @55 (18%)[$+100%] + 2y-xSCR-HR @55 (18%)[$+100%]",
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
         # screening=list(i=0),
         screening=list(i=350),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         quitting.int=list(i=53.68), # breu
         # quitting.int=list(i=687.50), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="2xBI @55&60 (18%)[$+100%] + 2y-xSCR-HR @55 (18%)[$+100%]",
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
         # screening=list(i=0),
         screening=list(i=350),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         quitting.int=list(i=53.68), # breu
         # quitting.int=list(i=687.50), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="3xBI @55&60&65 (18%)[$+100%] + 2y-xSCR-HR @55 (18%)[$+100%]",
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
         # screening=list(i=0),
         screening=list(i=350),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         quitting.int=list(i=53.68), # breu
         # quitting.int=list(i=687.50), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="3xBI @55&56&57 (18%)[$+100%] + 2y-xSCR-HR @55 (18%)[$+100%]",
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
         # screening=list(i=0),
         screening=list(i=350),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         quitting.int=list(i=53.68), # breu
         # quitting.int=list(i=687.50), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################ 
  
  
  list(sim.name="1xBI @35 (18%)[$+100%] + 2y-xSCR-HR @55 (18%)[$+100%]",
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
                              coverage     = .1869,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 1
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
         # screening=list(i=0),
         screening=list(i=350),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         quitting.int=list(i=53.68), # breu
         # quitting.int=list(i=687.50), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="2xBI @35&40 (18%)[$+100%] + 2y-xSCR-HR @55 (18%)[$+100%]",
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
                              coverage     = .1869,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              coverage     = .1869*(1-.2),
                              success_rate = .2,
                              # coverage     = .1869*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 1+12*5
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
         # screening=list(i=0),
         screening=list(i=350),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         quitting.int=list(i=53.68), # breu
         # quitting.int=list(i=687.50), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="2xBI @35&55 (18%)[$+100%] + 2y-xSCR-HR @55 (18%)[$+100%]",
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
                              coverage     = .1869,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              coverage     = .1869*(1-.2),
                              success_rate = .2,
                              # coverage     = .1869*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 1+12*20
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
         # screening=list(i=0),
         screening=list(i=350),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         quitting.int=list(i=53.68), # breu
         # quitting.int=list(i=687.50), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="3xBI @35&40&45 (18%)[$+100%] + 2y-xSCR-HR @55 (18%)[$+100%]",
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
                              coverage     = .1869,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              coverage     = .1869*(1-.2),
                              success_rate = .2,
                              # coverage     = .1869*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 1+12*5
                            ), list(
                              coverage     = .1869*(1-.2)*(1-.2),
                              success_rate = .2,
                              # coverage     = .1869*(1-.3977)*(1-.3977),
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
         screening=list(i=350),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         quitting.int=list(i=53.68), # breu
         # quitting.int=list(i=687.50), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################ 
  
  
  list(sim.name="1xII @55 (18%)[$+100%] + 2y-xSCR-HR @55 (18%)[$+100%]",
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
                              coverage     = .1869,
                              # success_rate = .2,
                              success_rate = .3977,
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
         # screening=list(i=0),
         screening=list(i=350),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=53.68), # breu
         quitting.int=list(i=687.50), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="2xII @55&60 (18%)[$+100%] + 2y-xSCR-HR @55 (18%)[$+100%]",
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
                              coverage     = .1869,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              # coverage     = .1869*(1-.2),
                              # success_rate = .2,
                              coverage     = .1869*(1-.3977),
                              success_rate = .3977,
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
         # screening=list(i=0),
         screening=list(i=350),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=53.68), # breu
         quitting.int=list(i=687.50), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="3xII @55&60&65 (18%)[$+100%] + 2y-xSCR-HR @55 (18%)[$+100%]",
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
                              coverage     = .1869,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              # coverage     = .1869*(1-.2),
                              # success_rate = .2,
                              coverage     = .1869*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 240+12*5
                            ), list(
                              # coverage     = .1869*(1-.2)*(1-.2),
                              # success_rate = .2,
                              coverage     = .1869*(1-.3977)*(1-.3977),
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
         screening=list(i=350),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=53.68), # breu
         quitting.int=list(i=687.50), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="3xII @55&56&57 (18%)[$+100%] + 2y-xSCR-HR @55 (18%)[$+100%]",
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
                              coverage     = .1869,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              # coverage     = .1869*(1-.2),
                              # success_rate = .2,
                              coverage     = .1869*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 240+12*1
                            ), list(
                              # coverage     = .1869*(1-.2)*(1-.2),
                              # success_rate = .2,
                              coverage     = .1869*(1-.3977)*(1-.3977),
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
         screening=list(i=350),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=53.68), # breu
         quitting.int=list(i=687.50), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################ 
  
  
  list(sim.name="1xII @35 (18%)[$+100%] + 2y-xSCR-HR @55 (18%)[$+100%]",
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
                              coverage     = .1869,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 1
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
         # screening=list(i=0),
         screening=list(i=350),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=53.68), # breu
         quitting.int=list(i=687.50), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="2xII @35&40 (18%)[$+100%] + 2y-xSCR-HR @55 (18%)[$+100%]",
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
                              coverage     = .1869,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              # coverage     = .1869*(1-.2),
                              # success_rate = .2,
                              coverage     = .1869*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 1+12*5
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
         # screening=list(i=0),
         screening=list(i=350),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=53.68), # breu
         quitting.int=list(i=687.50), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="2xII @35&55 (18%)[$+100%] + 2y-xSCR-HR @55 (18%)[$+100%]",
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
                              coverage     = .1869,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              # coverage     = .1869*(1-.2),
                              # success_rate = .2,
                              coverage     = .1869*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 1+12*20
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
         # screening=list(i=0),
         screening=list(i=350),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=53.68), # breu
         quitting.int=list(i=687.50), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="3xII @35&40&45 (18%)[$+100%] + 2y-xSCR-HR @55 (18%)[$+100%]",
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
                              coverage     = .1869,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              # coverage     = .1869*(1-.2),
                              # success_rate = .2,
                              coverage     = .1869*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 1+12*5
                            ), list(
                              # coverage     = .1869*(1-.2)*(1-.2),
                              # success_rate = .2,
                              coverage     = .1869*(1-.3977)*(1-.3977),
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
         screening=list(i=350),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=53.68), # breu
         quitting.int=list(i=687.50), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################ 
  
  
  list(sim.name="1xBI @55 (18%)[$+100%] + 3y-xSCR-HR @55 (18%)[$+100%]",
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
         # screening=list(i=0),
         screening=list(i=350),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         quitting.int=list(i=53.68), # breu
         # quitting.int=list(i=687.50), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="2xBI @55&60 (18%)[$+100%] + 3y-xSCR-HR @55 (18%)[$+100%]",
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
         # screening=list(i=0),
         screening=list(i=350),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         quitting.int=list(i=53.68), # breu
         # quitting.int=list(i=687.50), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="3xBI @55&60&65 (18%)[$+100%] + 3y-xSCR-HR @55 (18%)[$+100%]",
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
         # screening=list(i=0),
         screening=list(i=350),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         quitting.int=list(i=53.68), # breu
         # quitting.int=list(i=687.50), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="3xBI @55&56&57 (18%)[$+100%] + 3y-xSCR-HR @55 (18%)[$+100%]",
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
         # screening=list(i=0),
         screening=list(i=350),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         quitting.int=list(i=53.68), # breu
         # quitting.int=list(i=687.50), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################ 
  
  
  list(sim.name="1xBI @35 (18%)[$+100%] + 3y-xSCR-HR @55 (18%)[$+100%]",
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
                              # success_rate = .3977,
                              interv_steps = 1
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
         # screening=list(i=0),
         screening=list(i=350),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         quitting.int=list(i=53.68), # breu
         # quitting.int=list(i=687.50), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="2xBI @35&40 (18%)[$+100%] + 3y-xSCR-HR @55 (18%)[$+100%]",
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
                              # success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              coverage     = .1869*(1-.2),
                              success_rate = .2,
                              # coverage     = .1869*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 1+12*5
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
         # screening=list(i=0),
         screening=list(i=350),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         quitting.int=list(i=53.68), # breu
         # quitting.int=list(i=687.50), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="2xBI @35&55 (18%)[$+100%] + 3y-xSCR-HR @55 (18%)[$+100%]",
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
                              # success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              coverage     = .1869*(1-.2),
                              success_rate = .2,
                              # coverage     = .1869*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 1+12*20
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
         # screening=list(i=0),
         screening=list(i=350),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         quitting.int=list(i=53.68), # breu
         # quitting.int=list(i=687.50), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="3xBI @35&40&45 (18%)[$+100%] + 3y-xSCR-HR @55 (18%)[$+100%]",
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
                              # success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              coverage     = .1869*(1-.2),
                              success_rate = .2,
                              # coverage     = .1869*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 1+12*5
                            ), list(
                              coverage     = .1869*(1-.2)*(1-.2),
                              success_rate = .2,
                              # coverage     = .1869*(1-.3977)*(1-.3977),
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
         screening=list(i=350),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         quitting.int=list(i=53.68), # breu
         # quitting.int=list(i=687.50), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################ 
  
  
  list(sim.name="1xII @55 (18%)[$+100%] + 3y-xSCR-HR @55 (18%)[$+100%]",
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
                              # success_rate = .2,
                              success_rate = .3977,
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
         # screening=list(i=0),
         screening=list(i=350),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=53.68), # breu
         quitting.int=list(i=687.50), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="2xII @55&60 (18%)[$+100%] + 3y-xSCR-HR @55 (18%)[$+100%]",
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
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              # coverage     = .1869*(1-.2),
                              # success_rate = .2,
                              coverage     = .1869*(1-.3977),
                              success_rate = .3977,
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
         # screening=list(i=0),
         screening=list(i=350),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=53.68), # breu
         quitting.int=list(i=687.50), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="3xII @55&60&65 (18%)[$+100%] + 3y-xSCR-HR @55 (18%)[$+100%]",
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
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              # coverage     = .1869*(1-.2),
                              # success_rate = .2,
                              coverage     = .1869*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 240+12*5
                            ), list(
                              # coverage     = .1869*(1-.2)*(1-.2),
                              # success_rate = .2,
                              coverage     = .1869*(1-.3977)*(1-.3977),
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
         screening=list(i=350),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=53.68), # breu
         quitting.int=list(i=687.50), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="3xII @55&56&57 (18%)[$+100%] + 3y-xSCR-HR @55 (18%)[$+100%]",
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
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              # coverage     = .1869*(1-.2),
                              # success_rate = .2,
                              coverage     = .1869*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 240+12*1
                            ), list(
                              # coverage     = .1869*(1-.2)*(1-.2),
                              # success_rate = .2,
                              coverage     = .1869*(1-.3977)*(1-.3977),
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
         screening=list(i=350),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=53.68), # breu
         quitting.int=list(i=687.50), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################ 
  
  
  list(sim.name="1xII @35 (18%)[$+100%] + 3y-xSCR-HR @55 (18%)[$+100%]",
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
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 1
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
         # screening=list(i=0),
         screening=list(i=350),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=53.68), # breu
         quitting.int=list(i=687.50), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="2xII @35&40 (18%)[$+100%] + 3y-xSCR-HR @55 (18%)[$+100%]",
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
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              # coverage     = .1869*(1-.2),
                              # success_rate = .2,
                              coverage     = .1869*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 1+12*5
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
         # screening=list(i=0),
         screening=list(i=350),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=53.68), # breu
         quitting.int=list(i=687.50), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="2xII @35&55 (18%)[$+100%] + 3y-xSCR-HR @55 (18%)[$+100%]",
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
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              # coverage     = .1869*(1-.2),
                              # success_rate = .2,
                              coverage     = .1869*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 1+12*20
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
         # screening=list(i=0),
         screening=list(i=350),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=53.68), # breu
         quitting.int=list(i=687.50), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="3xII @35&40&45 (18%)[$+100%] + 3y-xSCR-HR @55 (18%)[$+100%]",
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
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              # coverage     = .1869*(1-.2),
                              # success_rate = .2,
                              coverage     = .1869*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 1+12*5
                            ), list(
                              # coverage     = .1869*(1-.2)*(1-.2),
                              # success_rate = .2,
                              coverage     = .1869*(1-.3977)*(1-.3977),
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
         screening=list(i=350),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=53.68), # breu
         quitting.int=list(i=687.50), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################ 
  
  
  list(sim.name="1xBI @55 (18%)[$+100%] + 4y-xSCR-HR @55 (18%)[$+100%]",
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
         # screening=list(i=0),
         screening=list(i=350),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         quitting.int=list(i=53.68), # breu
         # quitting.int=list(i=687.50), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="2xBI @55&60 (18%)[$+100%] + 4y-xSCR-HR @55 (18%)[$+100%]",
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
         # screening=list(i=0),
         screening=list(i=350),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         quitting.int=list(i=53.68), # breu
         # quitting.int=list(i=687.50), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="3xBI @55&60&65 (18%)[$+100%] + 4y-xSCR-HR @55 (18%)[$+100%]",
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
         # screening=list(i=0),
         screening=list(i=350),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         quitting.int=list(i=53.68), # breu
         # quitting.int=list(i=687.50), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="3xBI @55&56&57 (18%)[$+100%] + 4y-xSCR-HR @55 (18%)[$+100%]",
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
         # screening=list(i=0),
         screening=list(i=350),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         quitting.int=list(i=53.68), # breu
         # quitting.int=list(i=687.50), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################ 
  
  
  list(sim.name="1xBI @35 (18%)[$+100%] + 4y-xSCR-HR @55 (18%)[$+100%]",
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
                              coverage     = .1869,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 1
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
         # screening=list(i=0),
         screening=list(i=350),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         quitting.int=list(i=53.68), # breu
         # quitting.int=list(i=687.50), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="2xBI @35&40 (18%)[$+100%] + 4y-xSCR-HR @55 (18%)[$+100%]",
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
                              coverage     = .1869,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              coverage     = .1869*(1-.2),
                              success_rate = .2,
                              # coverage     = .1869*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 1+12*5
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
         # screening=list(i=0),
         screening=list(i=350),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         quitting.int=list(i=53.68), # breu
         # quitting.int=list(i=687.50), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="2xBI @35&55 (18%)[$+100%] + 4y-xSCR-HR @55 (18%)[$+100%]",
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
                              coverage     = .1869,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              coverage     = .1869*(1-.2),
                              success_rate = .2,
                              # coverage     = .1869*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 1+12*20
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
         # screening=list(i=0),
         screening=list(i=350),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         quitting.int=list(i=53.68), # breu
         # quitting.int=list(i=687.50), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="3xBI @35&40&45 (18%)[$+100%] + 4y-xSCR-HR @55 (18%)[$+100%]",
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
                              coverage     = .1869,
                              success_rate = .2,
                              # success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              coverage     = .1869*(1-.2),
                              success_rate = .2,
                              # coverage     = .1869*(1-.3977),
                              # success_rate = .3977,
                              interv_steps = 1+12*5
                            ), list(
                              coverage     = .1869*(1-.2)*(1-.2),
                              success_rate = .2,
                              # coverage     = .1869*(1-.3977)*(1-.3977),
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
         screening=list(i=350),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         quitting.int=list(i=53.68), # breu
         # quitting.int=list(i=687.50), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################ 
  
  
  list(sim.name="1xII @55 (18%)[$+100%] + 4y-xSCR-HR @55 (18%)[$+100%]",
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
                              coverage     = .1869,
                              # success_rate = .2,
                              success_rate = .3977,
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
         # screening=list(i=0),
         screening=list(i=350),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=53.68), # breu
         quitting.int=list(i=687.50), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="2xII @55&60 (18%)[$+100%] + 4y-xSCR-HR @55 (18%)[$+100%]",
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
                              coverage     = .1869,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              # coverage     = .1869*(1-.2),
                              # success_rate = .2,
                              coverage     = .1869*(1-.3977),
                              success_rate = .3977,
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
         # screening=list(i=0),
         screening=list(i=350),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=53.68), # breu
         quitting.int=list(i=687.50), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="3xII @55&60&65 (18%)[$+100%] + 4y-xSCR-HR @55 (18%)[$+100%]",
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
                              coverage     = .1869,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              # coverage     = .1869*(1-.2),
                              # success_rate = .2,
                              coverage     = .1869*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 240+12*5
                            ), list(
                              # coverage     = .1869*(1-.2)*(1-.2),
                              # success_rate = .2,
                              coverage     = .1869*(1-.3977)*(1-.3977),
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
         screening=list(i=350),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=53.68), # breu
         quitting.int=list(i=687.50), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="3xII @55&56&57 (18%)[$+100%] + 4y-xSCR-HR @55 (18%)[$+100%]",
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
                              coverage     = .1869,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 240
                            ), list(
                              # coverage     = .1869*(1-.2),
                              # success_rate = .2,
                              coverage     = .1869*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 240+12*1
                            ), list(
                              # coverage     = .1869*(1-.2)*(1-.2),
                              # success_rate = .2,
                              coverage     = .1869*(1-.3977)*(1-.3977),
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
         screening=list(i=350),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=53.68), # breu
         quitting.int=list(i=687.50), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################ 
  
  
  list(sim.name="1xII @35 (18%)[$+100%] + 4y-xSCR-HR @55 (18%)[$+100%]",
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
                              coverage     = .1869,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 1
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
         # screening=list(i=0),
         screening=list(i=350),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=53.68), # breu
         quitting.int=list(i=687.50), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="2xII @35&40 (18%)[$+100%] + 4y-xSCR-HR @55 (18%)[$+100%]",
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
                              coverage     = .1869,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              # coverage     = .1869*(1-.2),
                              # success_rate = .2,
                              coverage     = .1869*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 1+12*5
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
         # screening=list(i=0),
         screening=list(i=350),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=53.68), # breu
         quitting.int=list(i=687.50), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="2xII @35&55 (18%)[$+100%] + 4y-xSCR-HR @55 (18%)[$+100%]",
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
                              coverage     = .1869,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              # coverage     = .1869*(1-.2),
                              # success_rate = .2,
                              coverage     = .1869*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 1+12*20
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
         # screening=list(i=0),
         screening=list(i=350),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=53.68), # breu
         quitting.int=list(i=687.50), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  ),
  
  ################################################################################
  
  
  list(sim.name="3xII @35&40&45 (18%)[$+100%] + 4y-xSCR-HR @55 (18%)[$+100%]",
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
                              coverage     = .1869,
                              # success_rate = .2,
                              success_rate = .3977,
                              interv_steps = 1
                            ), list(
                              # coverage     = .1869*(1-.2),
                              # success_rate = .2,
                              coverage     = .1869*(1-.3977),
                              success_rate = .3977,
                              interv_steps = 1+12*5
                            ), list(
                              # coverage     = .1869*(1-.2)*(1-.2),
                              # success_rate = .2,
                              coverage     = .1869*(1-.3977)*(1-.3977),
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
         screening=list(i=350),
         
         # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
         
         # quitting.int=list(i=0), # dummy
         # quitting.int=list(i=53.68), # breu
         quitting.int=list(i=687.50), # intensiva
         
         # postdx_treatment=list(i=0),
         postdx_treatment=list(i=14160.4),
         
         utilities=c(1,.705,.655,.530,0,0,0),
         discount.factor=0.03
       )
  )
  
  ################################################################################ 
  
  
  
  
  
  
)
