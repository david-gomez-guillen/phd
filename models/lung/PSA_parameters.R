
params=list()

randscr=list()
randquit=list()
randpostdx=list()
randutil1=list()  #es podria posar mes maco
randutil2=list()
randutil3=list()
scr_ef=list()
quit_ef=list()

for(j in 1:20){
  
  
  ###costos###
  ############
  
  ### scr cost
  
   #lognormal distribution 
   #mean=175
   #std=175*0.75
   #logm=log(mean^2 / sqrt(std^2 + mean^2))
   #logs=sqrt(log(1 + (std^2 / mean^2)))
   #randscr[[j]]=rlnorm(1,meanlog=logm, sdlog=logs)
  
   #gamma distribution 
   mean=175
   std=175*0.15
   
   alpha=(std^2/mean^2)
   beta=mean^2/std
   randscr[[j]]=rgamma(1,shape=alpha,scale=beta)

  ### postdx cost 
  
   #gamma distribution
   mean=14160.4
   std=14160.4*0.15
   
   alpha=(std^2/mean^2)
   beta=mean^2/std
   randpostdx[[j]]=rgamma(1,shape=alpha,scale=beta)
   
   #lognormal distribution
   #mean=14160.4
   #std=14160.4
   #logm=log(mean^2 / sqrt(std^2 + mean^2))
   #logs=sqrt(log(1 + (std^2 / mean^2)))
   #randpostdx[[j]]=rlnorm(1,meanlog=logm, sdlog=logs)
   
   ### quit int cost
   
   #lognormal distribution
   #mean=343.75
   #std=343.75*0.5
   #logm=log(mean^2 / sqrt(std^2 + mean^2))
   #logs=sqrt(log(1 + (std^2 / mean^2)))
   #randquit[[j]]=rlnorm(1,meanlog=logm, sdlog=logs)
   
   #gamma distribution
   mean=343.75
   std=343.75*0.15
   alpha=(std^2/mean^2)
   beta=mean^2/std
   randquit[[j]]=rgamma(1,shape=alpha,scale=beta)
   
   #randscr[[j]]=175
   #randquit[[j]]=343.75
   #randpostdx[[j]]=14160.4
   


  
  #utilities gamma: alpha=std^2/mitjana^2, beta=mitjana^2/std
  
  #util1
  
  #mean=.705
  #std=.02
  ##gamma distr
  #alpha=(std^2/mean^2)
  #beta=mean^2/std
  #randutil1[[j]]=.705#rgamma(1,shape=alpha,scale=beta)
  #
  ##util2
#
  #mean=.655
  #std=.02
  ##gamma distr
  #alpha=(std^2/mean^2)
  #beta=mean^2/std
  #randutil2[[j]]=.655#rgamma(1,shape=alpha,scale=beta)
  #
  ##util3
#
  #mean=.530
  #std=.02
  ##gamma distr
  #alpha=(std^2/mean^2)
  #beta=mean^2/std
  #randutil3[[j]]=.530#rgamma(1,shape=alpha,scale=beta)
  
  
  #utilities beta distribution:
  
  #util1
  
  mean=0.705
  std=0.02
  alpha = ((1 - mean) / std^2 - 1 / mean) * mean ^ 2
  beta = alpha * (1 / mean - 1)
  randutil1[[j]]=rbeta(1,alpha,beta)
  
  #util2
  
  mean=0.655
  std=0.02
  alpha = ((1 - mean) / std^2 - 1 / mean) * mean ^ 2
  beta = alpha * (1 / mean - 1)
  randutil2[[j]]=rbeta(1,alpha,beta)
  
  #util3
  
  mean=0.530
  std=0.02
  alpha = ((1 - mean) / std^2 - 1 / mean) * mean ^ 2
  beta = alpha * (1 / mean - 1)
  randutil3[[j]]=rbeta(1,alpha,beta)
  
   #randutil1[[j]]=0.705
   #randutil2[[j]]=0.655
   #randutil3[[j]]=0.530
  ## screening effectiveness
  
  # deterministic
  #scr_ef[[j]]=0.604
  
  #beta distribution
  mean=0.604
  std=0.1*0.604
  alpha = ((1 - mean) / std^2 - 1 / mean) * mean ^ 2
  beta = alpha * (1 / mean - 1)
  scr_ef[[j]]=rbeta(1,alpha,beta)
  
  ## smoking cessation effectiveness
  
  #deterministic
  #quit_ef[[j]]=0.2
  
  #beta distribution
  mean=0.2
  std=0.1*0.2
  alpha = ((1 - mean) / std^2 - 1 / mean) * mean ^ 2
  beta = alpha * (1 / mean - 1)
  quit_ef[[j]]=rbeta(1,alpha,beta)
  
  params[[j]]=list(sim.name="3xII @35&40&45 (18%, eff -75%) + 3y-xSCR-HR @55 (18%)",
                   interventions_p=list(diag_screen=c(0,scr_ef[[j]],scr_ef[[j]],scr_ef[[j]],0,0,0),
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
                                           success_rate = quit_ef[[j]],
                                          #success_rate = .0994,
                                          interv_steps = 1
                                        ), list(
                                           coverage     = .1869*(1-quit_ef[[j]]),
                                           success_rate = quit_ef[[j]],
                                          #coverage     = .1869*(1-.0994),
                                          #success_rate = .0994,
                                          interv_steps = 1+12*5
                                        ), list(
                                           coverage     = .1869*(1-quit_ef[[j]])*(1-quit_ef[[j]]),
                                           success_rate = quit_ef[[j]],
                                          #coverage     = .1869*(1-.0994)*(1-.0994),
                                          #success_rate = .0994,
                                          interv_steps = 1+12*10
                                        )
                                        ),
                                        
                                        
                                        quitting_effect_type      = 'logistic',
                                        quitting_ref_years        = 15,
                                        quitting_rr_after_ref_years = .2 # reducció 80% als 15 anys
                   ),
                   costs_p=costs_p <- list(
                     # screening=list(i=0),
                     screening=list(i=randscr[[j]]),
                     
                     # usual.care=list(md=c(0, 1,5,10,0.2,0,0)),
                     
                     # quitting.int=list(i=0), # dummy
                     # quitting.int=list(i=26.84), # breu
                     quitting.int=list(i=randquit[[j]]), # intensiva
                     
                     # postdx_treatment=list(i=0),
                     postdx_treatment=list(i=randpostdx[[j]]),
                     
                     utilities=c(1,randutil1[[j]],randutil2[[j]],randutil3[[j]],0,0,0),
                     discount.factor=0.03
                   ),
                   options_p <- list(
                     smoker_inc_type = "current"
                   )
  )
}
  
  ################################################################################ 
  
