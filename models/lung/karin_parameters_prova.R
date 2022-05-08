
params=list()

randscr=list()
randquit=list()
randpostdx=list()
randutil1=list()  #es podria posar mes maco
randutil2=list()
randutil3=list()

for(j in 1:1000){
  ## primer simulem els par‡metres aleatoris
  #per les distribucions gamma
  #costos: alpha=1, beta=mitjana (rate=1/beta)
  randscr[[j]]=175#rgamma(1,1,1/175)
  randquit[[j]]=343.75#rgamma(1,1,1/343.75)
  randpostdx[[j]]=14160.4#rgamma(1,1,1/14160.4)
  #utilities: alpha=std^2/mitjana^2, beta=mitjana^2/std
  #util1
#  mean=.705
#  std=.02
#  alpha=(std^2/mean^2)
#  beta=mean^2/std
#  randutil1[[j]]=rgamma(1,shape=alpha,scale=beta)
  #util2
#  mean=.655
#  std=.02
#  alpha=(std^2/mean^2)
#  beta=mean^2/std
#  randutil2[[j]]=rgamma(1,shape=alpha,scale=beta)
  #util3
#  mean=.530
#  std=.02
#  alpha=(std^2/mean^2)
#  beta=mean^2/std
#  randutil3[[j]]=rgamma(1,shape=alpha,scale=beta)
  
  params[[j]]=list(sim.name="3xII @35&40&45 (18%, eff -75%) + 3y-xSCR-HR @55 (18%)",
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
                                        quitting_rr_after_ref_years = .2 # reducci√≥ 80% als 15 anys
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
                   ),
                   options_p <- list(
                     smoker_inc_type = "current"
                   )
  )
}
  
  ################################################################################ 
  
