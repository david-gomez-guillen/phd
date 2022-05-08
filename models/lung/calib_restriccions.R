
library(GenSA)
demon=0

##DAN20, 35-39
#conIni=list()
#conIni[[1]]=c(0.0000014899094538366, 0.00005867, 0.0373025655099923, 0.45001903545473
#         , 0.0310692140027966
#         , 2.06599720339873E-06
#         , 0.083259360316924
#         , 0.0310687721751887
#         , 2.50782481130141E-06
#         , 0.031069806
#         , 1.47440016369862E-06)
#conIni[[2]]=c(1.04877E-05, 0.00009628, 0.014591745, 0.481776189, 0.031069873,
#              1.40669E-06, 0.050026676, 0.031069146, 2.13361E-06, 0.031070341, 9.38951E-07)
#conIni[[3]]=c(3.23534E-05, 0.00018182, 0.009078452, 0.445602151, 0.031940262, 1.36813E-06, 
#              0.040413788, 0.031940366, 1.2638E-06, 0.031940406, 1.22435E-06)
#conIni[[4]]=c(7.67959E-05, 0.00033198, 0.216982823, 0.745686098, 0.03193267, 8.96007E-06,
#              0.279118741, 0.031934889, 6.74088E-06, 0.031930383, 1.12474E-05)
#conIni[[5]]=c(0.000143266, 0.00054161, 0.587748693, 0.367077318, 0.022454858, 0.012333952, 
#              0.938189625, 0.025488122, 0.009300688, 0.030911619, 0.003877191)
#conIni[[6]]=c(0.000215056, 0.00082374, 0.014863212, 0.94528741, 0.02701171, 0.0077771, 
#              0.945729932, 0.033553455, 0.001235355, 0.031429049, 0.003359761)
#conIni[[7]]=c(0.00029203, 0.00124249, 0.57293827, 0.071391822, 0.040115762, 0.000770938, 
#              0.922967658, 0.004939897, 0.035946803, 0.031592197, 0.009294503)
#conIni[[8]]=c(0.000349383, 0.00190251, 0.224558597, 0.349067177, 0.040817026, 6.96743E-05,
#              0.071749361, 0.001859725, 0.039026975, 0.037767242, 0.003119458)
#conIni[[9]]=c(0.000358942, 0.00330943, 0.009683304, 0.414010634, 0.022973067, 0.030664353, 
#              0.60868601, 0.006745365, 0.046892055, 0.047318463, 0.006318957)


#calib1: dan20       
#conIni=c(0.0000014899094538366, 0.00005867, 0.0373025655099923, 0.45001903545473
#                 , 0.0310692140027966
#                 , 2.06599720339873E-06
#                 , 0.083259360316924
#                 , 0.0310687721751887
#                 , 2.50782481130141E-06
#                 , 0.031069806
#                 , 1.47440016369862E-06, 1.04877E-05, 0.00009628, 0.014591745, 0.481776189, 0.031069873,
#         1.40669E-06, 0.050026676, 0.031069146, 2.13361E-06, 0.031070341, 9.38951E-07,3.23534E-05, 0.00018182, 0.009078452, 0.445602151, 0.031940262, 1.36813E-06, 
#         0.040413788, 0.031940366, 1.2638E-06, 0.031940406, 1.22435E-06,7.67959E-05, 0.00033198, 0.216982823, 0.745686098, 0.03193267, 8.96007E-06,
#         0.279118741, 0.031934889, 6.74088E-06, 0.031930383, 1.12474E-05,0.000143266, 0.00054161, 0.587748693, 0.367077318, 0.022454858, 0.012333952, 
#         0.938189625, 0.025488122, 0.009300688, 0.030911619, 0.003877191,0.000215056, 0.00082374, 0.014863212, 0.94528741, 0.02701171, 0.0077771, 
#         0.945729932, 0.033553455, 0.001235355, 0.031429049, 0.003359761,0.00029203, 0.00124249, 0.57293827, 0.071391822, 0.040115762, 0.000770938, 
#         0.922967658, 0.004939897, 0.035946803, 0.031592197, 0.009294503,0.000349383, 0.00190251, 0.224558597, 0.349067177, 0.040817026, 6.96743E-05,
#         0.071749361, 0.001859725, 0.039026975, 0.037767242, 0.003119458,0.000358942, 0.00330943, 0.009683304, 0.414010634, 0.022973067, 0.030664353, 
#         0.60868601, 0.006745365, 0.046892055, 0.047318463, 0.006318957)      




#calib4: dan20 canviant el valor 23 de 3.23534E-05 a 0.00001850743 i el 12 de 1.04877E-05 a 8.66004e-06 i igualant mortalitat per causa natural en cada grup (agafant parametres de mortalitat de la matriu calibrada 3)
m1=3.177318e-05 #+runif(1,-.1,.1)*m1
m2=5.798299e-05#+runif(1,-.1,.1)*m2
m3=0.0001000046#+runif(1,-.1,.1)*m3
m4=0.0001525289#+runif(1,-.1,.1)*m4
m5=0.00020520019#+runif(1,-.1,.1)*m5
m6=0.00030321590#+runif(1,-.1,.1)*m6
m7=0.00040909427#+runif(1,-.1,.1)*m7
m8=0.00050416228#+runif(1,-.1,.1)*m8
m9=0.00080434398#+runif(1,-.1,.1)*m9
conIni=c(0.0000014899094538366, m1, 0.0373025655099923, 0.45001903545473
         , 0.0310692140027966
         , 0.083259360316924
         , 0.031687721751887
         , 0.032069806
         , 8.66004e-06, m2, 0.014591745, 0.481776189, 0.031069873,
         0.050026676, 0.03169146, 0.032070341, 0.00001850743, m3, 0.009078452, 0.445602151, 0.031940262,
         0.040413788, 0.031980366, 0.032140406, 2.97959E-05, m4, 0.216982823, 0.745686098, 0.03193267,
         0.279118741, 0.031994889, 0.032130383, 0.00003643266, m5, 0.587748693, 0.367077318, 0.022454858, 
         0.938189625, 0.025488122, 0.030911619, 0.00003985056, m6, 0.014863212, 0.94528741, 0.02701171, 
         0.945729932, 0.033553455, 0.034429049, 0.00039203, m7, 0.57293827, 0.071391822, 0.040115762, 
         0.922967658, 0.040939897, 0.041592197, 0.000349383, m8, 0.224558597, 0.349067177, 0.040817026,
         0.071749361, 0.041859725, 0.042767242, 0.000358942, m9, 0.009683304, 0.414010634, 0.022973067, 
         0.60868601, 0.036745365, 0.047318463)      



real.inc = c(1.3,10.5,21.0,34.4,44.2,47.8,48.0,50.1,56.8) # WOMEN
real.lcmort= c(0.9,7.8,14.2,22.7,29.6,32.4,33.6,37.4,50.3)
real.othermort = c( 0.380972, 0.694827, 1.202252, 1.960304, 3.035235, 4.089336, 6.007853, 10.002099, 19.884787)*100


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
  for(q in 1:9){
    a[q]=par[8*count+1] 
    b[q]=par[8*count+2]
    c[q]=par[8*count+3]
    d[q]=par[8*count+4]
    e[q]=par[8*count+5]
    f[q]=b[q]
    g[q]=par[8*count+6] 
    h[q]=par[8*count+7] 
    l[q]=b[q]
    m[q]=par[8*count+8]
    n[q]=b[q]
    count=count+1
  }
  
  x1=list()
  x=list()
  for(q in 1:9){
    x1[[q]]=c(1-a[q]-b[q],a[q],0,0,0,b[q],0,1-c[q]-d[q]-e[q]-f[q],c[q],d[q],e[q],f[q],0,0,1-g[q]-h[q]-l[q],g[q],h[q],l[q],0,0,0,1-m[q]-n[q],m[q],n[q],0,0,0,0,1,0,0,0,0,0,0,1)
    x[[q]]=matrix(x1[[q]],nrow=6,ncol=6,byrow=T)
  }
  ###### fins aqui be
  P=list()
  for(q in 1:9){
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
  for(q in 2:9){
    
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
  dist=sum(0.45*abs(incidence-real.inc)/real.inc+0.45*abs(lcmort-real.lcmort)/real.lcmort+0.1*abs(othermort-real.othermort)/real.othermort) #dones
  #dist=0.49*abs(incidence-1.3)/1.3+0.49*abs(lcmort-0.9)/0.9+0.02*abs(othermort-38.0972)/38.0972 #dones
  
  #############################################################################################################
  
  ####################
  ### restriccions ###
  ####################
  
  # no pot haverhi probabilitats negatives
  
  for(q in 1:9){
    for(i in 1:36){
      if(x1[[q]][i]<0){
        dist=1e7
      }
    }
  }
  
  #el risc de morir de cancer ha d'augmentar en cada estat
  for(q in 1:9){
    if(x[[q]][2,5]>x[[q]][3,5] || x[[q]][3,5]>x[[q]][4,5]){
      dist=100000+runif(1,0,1000)
    }
  }
  
  
  
  if (verbose) {
    demon <<- demon+1
    cat(sprintf("%6d > %10.6f\n", demon, dist))
  }
  
  
  return(dist)
}


#################
### optimitzacio
#################
sol=optim(par = conIni
          , fn = distgrup1
          , control=list(trace=4, maxit=100000, verbose=TRUE))

          

#a=sol$par[1] 
#b=sol$par[2]
#c=sol$par[3]
#d=sol$par[4]
#e=sol$par[5]
#f=sol$par[6]
#g=sol$par[7] 
#h=sol$par[8] 
#l=sol$par[9]
#m=sol$par[10]
#n=sol$par[11]
#y=c(1-a-b,a,0,0,0,b,0,1-c-d-e-f,c,d,e,f,0,0,1-g-h-l,g,h,l,0,0,0,1-m-n,m,n,0,0,0,0,1,0,0,0,0,0,0,1)
#tm=matrix(y,nrow=6,ncol=6,byrow=T)
#
#P1=diag(6)
#for(r in 1:60){
#  P1=P1%*%tm
#}
#i=1:60
#incidence=sum(tm[1][1]^i*a)*100000/5
#lcmort=P1[1,5]*100000/5
#othermort=P1[1,6]*100000/5
#dist1=0.49*abs(incidence-1.6)/1.6+0.49*abs(lcmort-1)+0.02*abs(othermort-70.3794)/70.3794 #homes
##dist1=0.49*abs(incidence-1.3)/1.3+0.49*abs(lcmort-0.9)/0.9+0.02*abs(othermort-38.0972)/38.0972 #dones
#
#for(i in 1:36){
#  if(y[i]<0){
#    dist1=1e7
#  }
#}


sol1=optim(par = sol$par
           , fn = distgrup1
           , control=list(trace=4, maxit=100000, verbose=TRUE))
#
#a=sol1$par[1] 
#b=sol1$par[2]
#c=sol1$par[3]
#d=sol1$par[4]
#e=sol1$par[5]
#f=sol1$par[6]
#g=sol1$par[7] 
#h=sol1$par[8] 
#i=sol1$par[9]
#j=sol1$par[10]
#k=sol1$par[11]
#y=c(1-a-b,a,0,0,0,b,0,1-c-d-e-f,c,d,e,f,0,0,1-g-h-i,g,h,i,0,0,0,1-j-k,j,k,0,0,0,0,1,0,0,0,0,0,0,1)
#tm1=matrix(y,nrow=6,ncol=6,byrow=T)
#
#
#
#
sol2=optim(par = sol1$par
           , fn = distgrup1
           , control=list(trace=4, maxit=100000, verbose=TRUE))

sol3=optim(par = sol2$par
           , fn = distgrup1
           , control=list(trace=4, maxit=100000, verbose=TRUE))
#sol4=optim(par = sol3$par
#           , fn = distgrup1
#           , control=list(trace=4, maxit=100000, verbose=TRUE))
#sol5=optim(par = sol4$par
#           , fn = distgrup1
#           , control=list(trace=4, maxit=100000, verbose=TRUE))
#
#sol6=optim(par = sol5$par
#           , fn = distgrup1
#           , control=list(trace=4, maxit=100000, verbose=TRUE))
#sol7=optim(par = sol6$par
#           , fn = distgrup1
#           , control=list(trace=4, maxit=100000, verbose=TRUE))
#sol8=optim(par = sol7$par
#           , fn = distgrup1
#           , control=list(trace=4, maxit=100000, verbose=TRUE))
#sol9=optim(par = sol8$par
#           , fn = distgrup1
#           , control=list(trace=4, maxit=100000, verbose=TRUE))
#sol10=optim(par = sol9$par
#           , fn = distgrup1
#           , control=list(trace=4, maxit=100000, verbose=TRUE))
#sol11=optim(par = sol10$par
#           , fn = distgrup1
#           , control=list(trace=4, maxit=100, verbose=TRUE))
#sol12=optim(par = sol11$par
#            , fn = distgrup1
#            , control=list(trace=4, maxit=100, verbose=TRUE))
#sol13=optim(par = sol12$par
#            , fn = distgrup1
#            , control=list(trace=4, maxit=100, verbose=TRUE))
#sol14=optim(par = sol13$par
#            , fn = distgrup1
#            , control=list(trace=4, maxit=100, verbose=TRUE))
#sol15=optim(par = sol14$par
#            , fn = distgrup1
#            , control=list(trace=4, maxit=100, verbose=TRUE))
#sol16=optim(par = sol15$par
#            , fn = distgrup1
#            , control=list(trace=4, maxit=100, verbose=TRUE))
#sol17=optim(par = sol16$par
#            , fn = distgrup1
#            , control=list(trace=4, maxit=100, verbose=TRUE))
#sol18=optim(par = sol17$par
#            , fn = distgrup1
#            , control=list(trace=4, maxit=100, verbose=TRUE))
#sol19=optim(par = sol18$par
#            , fn = distgrup1
#            , control=list(trace=4, maxit=100, verbose=TRUE))
#sol20=optim(par = sol19$par
#            , fn = distgrup1
#            , control=list(trace=4, maxit=100, verbose=TRUE))
#sol21=optim(par = sol20$par
#            , fn = distgrup1
#            , control=list(trace=4, maxit=100, verbose=TRUE))
#sol22=optim(par = sol21$par
#            , fn = distgrup1
#            , control=list(trace=4, maxit=100, verbose=TRUE))
#sol23=optim(par = sol22$par
#            , fn = distgrup1
#            , control=list(trace=4, maxit=100, verbose=TRUE))
#sol24=optim(par = sol23$par
#            , fn = distgrup1
#            , control=list(trace=4, maxit=100, verbose=TRUE))
#sol25=optim(par = sol24$par
#            , fn = distgrup1
#            , control=list(trace=4, maxit=100, verbose=TRUE))
#sol26=optim(par = sol25$par
#            , fn = distgrup1
#            , control=list(trace=4, maxit=100, verbose=TRUE))
#sol27=optim(par = sol26$par
#            , fn = distgrup1
#            , control=list(trace=4, maxit=100, verbose=TRUE))
#sol28=optim(par = sol27$par
#            , fn = distgrup1
#            , control=list(trace=4, maxit=100, verbose=TRUE))


##calculem incidencia i mortalitats per sol$4
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
for(q in 1:9){
  a[q]=sol10$par[8*count+1] 
  b[q]=sol10$par[8*count+2]
  c[q]=sol10$par[8*count+3]
  d[q]=sol10$par[8*count+4]
  e[q]=sol10$par[8*count+5]
  f[q]=b[q]
  g[q]=sol10$par[8*count+6] 
  h[q]=sol10$par[8*count+7] 
  l[q]=b[q]
  m[q]=sol10$par[8*count+8]
  n[q]=b[q]
  count=count+1
}

x1=list()
x=list()
for(q in 1:9){
  x1[[q]]=c(1-a[q]-b[q],a[q],0,0,0,b[q],0,1-c[q]-d[q]-e[q]-f[q],c[q],d[q],e[q],f[q],0,0,1-g[q]-h[q]-l[q],g[q],h[q],l[q],0,0,0,1-m[q]-n[q],m[q],n[q],0,0,0,0,1,0,0,0,0,0,0,1)
  x[[q]]=matrix(x1[[q]],nrow=6,ncol=6,byrow=T)
}

P=list()
for(q in 1:9){
  P[[q]]=diag(6)
  for(r in 1:60){
    P[[q]]=P[[q]]%*%x[[q]]
  }
}

incidence=vector()
lcmort=vector()
othermort=vector()

i=0:60
incidence[1]=sum((x[[1]][1,1]^i)*a[1])*100000/5
lcmort[1]=P[[1]][1,5]*100000/5
othermort[1]=P[[1]][1,6]*100000/5
p=P[[1]]
for(q in 2:9){
  
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
dist=sum(0.45*abs(incidence-real.inc)/real.inc+0.45*abs(lcmort-real.lcmort)/real.lcmort+0.1*abs(othermort-real.othermort)/real.othermort) #dones

y=1:9
names(y)=c("35-39","40-44","45-49","50-54","55-59","60-64","65-69","70-74","75-79")
par(mfrow=c(1,3))
plot(y,incidence,"o",col="red", xlab="age group", ylab="incidence")
lines(y,real.inc,"o",col="blue")#, xlab="age group", ylab="incidence")

plot(y,lcmort,"o",col="red", xlab="age group", ylab="lc.mortality")
lines(y,real.lcmort,"o",col="blue")#, xlab="age group", ylab="incidence")

plot(y,othermort,"o",col="red", xlab="age group", ylab="tot.mortality")
lines(y,real.othermort,"o",col="blue")#, xlab="age group", ylab="incidence")
