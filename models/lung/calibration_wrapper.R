library(jsonlite)
library(GenSA)
demon=0

make.calibration.func <- function(population, param.names, param.strata) {

## Triem la condici� inicial

# conIni=c(0.0000014899094538366
#          , 0.00005867
#          , 0.0373025655099923
#          , 0.45001903545473
#          , 0.0310692140027966
#          , 2.06599720339873E-06
#          , 0.083259360316924
#          , 0.0310687721751887
#          , 2.50782481130141E-06
#          , 0.031069806
#          , 1.47440016369862E-06
#          # ,1.04877E-05, 0.00009628, 0.014591745, 0.481776189, 0.031069873,
#          # 1.40669E-06, 0.050026676, 0.031069146, 2.13361E-06, 0.031070341, 9.38951E-07,0.00001850743, 0.00018182, 0.009078452, 0.445602151, 0.031940262, 1.36813E-06, 
#          # 0.040413788, 0.031940366, 1.2638E-06, 0.031940406, 1.22435E-06,3.37959E-05, 0.00033198, 0.216982823, 0.745686098, 0.03193267, 8.96007E-06,
#          # 0.279118741, 0.031934889, 6.74088E-06, 0.031930383, 1.12474E-05,0.000047266, 0.00054161, 0.587748693, 0.367077318, 0.022454858, 0.012333952, 
#          # 0.938189625, 0.025488122, 0.009300688, 0.030911619, 0.003877191,0.000057056, 0.00082374, 0.014863212, 0.94528741, 0.02701171, 0.0077771, 
#          # 0.945729932, 0.033553455, 0.001235355, 0.031429049, 0.003359761,0.00029203, 0.00124249, 0.57293827, 0.071391822, 0.040115762, 0.000770938, 
#          # 0.922967658, 0.004939897, 0.035946803, 0.031592197, 0.009294503,0.00005383, 0.00190251, 0.224558597, 0.349067177, 0.040817026, 6.96743E-05,
#          # 0.071749361, 0.001859725, 0.039026975, 0.037767242, 0.003119458,0.000058942, 0.00330943, 0.009683304, 0.414010634, 0.022973067, 0.030664353, 
#          # 0.60868601, 0.006745365, 0.046892055, 0.067318463, 0.004318957
#          )     

## Les dades reals  

# real.inc = c(1.9,9.0,20.9,39.7,57.9,68.8,71.4,70.4,69.9) # WOMEN
# real.lcmort= c(0.29,5.0,13.4,26.6,42.5,51.1,52.0,52.3,53.9)
# real.othermort = c( 0.398893, 0.640476, 1.146431, 1.889474, 2.892546, 4.170061, 6.047883, 9.968391, 18.716366)*100

##Definim la funci� distancia

####################
### funcio distancia
###################

distgrup1<-function(par,verbose=TRUE){
  
  a=vector()
  b=vector()
  c=vector()
  d=vector()
  e=vector()
  f=vector()
  g=vector()
  h=vector()
  l=vector()
  m=vector()
  n=vector()
  
  count=0
  for(q in 1:N_MATRICES){
    a[q]=par[11*count+1] 
    b[q]=par[11*count+2]
    c[q]=par[11*count+3]
    d[q]=par[11*count+4]
    e[q]=par[11*count+5]
    f[q]=par[11*count+6]
    g[q]=par[11*count+7] 
    h[q]=par[11*count+8] 
    l[q]=par[11*count+9]
    m[q]=par[11*count+10]
    n[q]=par[11*count+11]
    count=count+1
  }
  
  x1=list()
  x=list()
  for(q in 1:N_MATRICES){
    x1[[q]]=c(1-a[q]-b[q],a[q],0,0,0,b[q],
              0,1-c[q]-d[q]-e[q]-f[q],c[q],d[q],e[q],f[q],
              0,0,1-g[q]-h[q]-l[q],g[q],h[q],l[q],
              0,0,0,1-m[q]-n[q],m[q],n[q],
              0,0,0,0,1,0,
              0,0,0,0,0,1)
    x[[q]]=matrix(x1[[q]],nrow=6,ncol=6,byrow=T)
  }
  ###### fins aqui be
  P=list()
  for(q in 1:N_MATRICES){
    P[[q]]=diag(6)
    for(r in 1:60){
      P[[q]]=P[[q]]%*%x[[q]]
    }
  }
  incidence=vector()
  lcmort=vector()
  othermort=vector()
 
  ##############################################################################################################
  #####pensar be com calcular la incidencia i mortalitats
  
  #p1=probabilitat health
  #p2=probabilitat estar en estat 2
  #p3=probabilitat estar en estat 3
  #p4=probabilitat estar en estat4
  #p1+p2+p3+p4= probabilitat estar viu
  #pt=p1+p2+p3+p4
  
  
  i=0:60
  incidence[1]=sum((x[[1]][1,1]^i)*a[1])*100000/5
  lcmort[1]=P[[1]][1,5]*100000/5
  othermort[1]=P[[1]][1,6]*100000/5
  p=P[[1]]
  if (N_MATRICES > 1) {
    for(q in 2:N_MATRICES){
  
      p1=p[1,1]
      p2=p[1,2]
      p3=p[1,3]
      p4=p[1,4]
      pt=p1+p2+p3+p4
      i=0:60
      incidence[q]=sum((x[[q]][1,1]^i)*a[q])*100000/5
      lcmort[q]=(P[[q]][1,5]*(p1/pt)+P[[q]][2,5]*(p2/pt)+P[[q]][3,5]*(p3/pt)+P[[q]][4,5]*(p4/pt))*100000/5
      othermort[q]=(P[[q]][1,6]*(p1/pt)+P[[q]][2,6]*(p2/pt)+P[[q]][3,6]*(p3/pt)+P[[q]][4,6]*(p4/pt))*100000/5
  
      p=p%*%P[[q]]
    }
  }
  dist <- 0
  # dist=sum(0.45*abs(incidence-real.inc)/real.inc+0.45*abs(lcmort-real.lcmort)/real.lcmort+0.1*abs(othermort-real.othermort)/real.othermort) #dones
  
  #############################################################################################################

####################
### restriccions ###
####################
  
  # no pot haverhi probabilitats negatives

    for(q in 1:N_MATRICES){
    for(i in 1:36){
      if(x1[[q]][i]<0){
        #dist = 1e7
        dist <- dist - x1[[q]][i] * 1e7  # Modificat per forçar distancia derivable
      }
    }
  }
  
  #el risc de morir de cancer ha d'augmentar en cada estat
 # for(q in 1:N_MATRICES){
 #   if(x[[q]][2,5]>x[[q]][3,5] || x[[q]][3,5]>x[[q]][4,5]){
 #     dist=100000+runif(1,0,1000)
 #   }
 # }
  
  
  
  #if (verbose) {
  #  demon <<- demon+1
  #  cat(sprintf("%6d > %10.6f\n", demon, dist))
  #}
 
  if (dist > 1e6) {
    incidence <- incidence * dist
    lc_mortality <- lcmort * dist
    other_mortality <- othermort * dist
  }
  result <- list(incidence=incidence,
                 lc_mortality=lcmort,
                 other_mortality=othermort)
  return(toJSON(result))
  # return(dist)
}
return (distgrup1)
}
