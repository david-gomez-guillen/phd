





library(GenSA)
demon=0
  
#DAN20, 35-39
conIni=c(0.0000014899094538366, 0.00005867, 0.0373025655099923, 0.45001903545473
         , 0.0310692140027966
         , 2.06599720339873E-06
         , 0.083259360316924
         , 0.0310687721751887
         , 2.50782481130141E-06
         , 0.031069806
         , 1.47440016369862E-06)

#alice
#conIni=c(2.96504E-06, 0.00005867,	0.011005058,	0.441989701, 0.033128834, 0.00000100,	0.008972016, 0.032909025,	0.00000100, 0.032990981, 0.00000100)

#bob
#conIni=c(7.46958E-05, 0.000556976, 0.147858908,	0.283417185, 0.014939932,	0.032374901,	0.351344813, 0.184421879,	0.047834855, 0.17218696, 0.074050839)

#carol
#conIni=c(1.8991E-06, 0.00001867, 0.027302566, 0.350019035, 0.081069214, 6.066E-06, 0.01325936, 0.071068772, 1.50782E-06, 0.01069806, 5.4744E-06)

##qualsevol
#conIni=c(1.46958E-05, 0.000856976, 0.47858908,	0.23417185, 0.010939932,	0.092374901,	0.251344813, 0.284421879,	0.017834855, 0.117218696, 0.014050839)



distgrup1<-function(par,verbose=TRUE){
  
  a=par[1] 
  b=par[2]
  c=par[3]
  d=par[4]
  e=par[5]
  f=par[6]
  g=par[7] 
  h=par[8] 
  l=par[9]
  m=par[10]
  n=par[11]
  

  
  x1=c(1-a-b,a,0,0,0,b,0,1-c-d-e-f,c,d,e,f,0,0,1-g-h-l,g,h,l,0,0,0,1-m-n,m,n,0,0,0,0,1,0,0,0,0,0,0,1)
  x=matrix(x1,nrow=6,ncol=6,byrow=T)

    P=diag(6)
  for(r in 1:60){
    P=P%*%x
  }
  i=0:60
  incidence=sum((x[1][1]^i)*a)*100000/5
  lcmort=P[1,5]*100000/5
  othermort=P[1,6]*100000/5
  #dist=0.49*abs(incidence-1.6)/1.6+0.49*abs(lcmort-1)+0.02*abs(othermort-70.3794)/70.3794 #homes
  dist=0.49*abs(incidence-1.3)/1.3+0.49*abs(lcmort-0.9)/0.9+0.02*abs(othermort-38.0972)/38.0972 #dones
  
  for(i in 1:36){
    if(x1[i]<0){
      dist=1e7
    }
  }
  
  if (verbose) {
    demon <<- demon+1
    cat(sprintf("%6d > %10.6f\n", demon, dist))
  }
  
  return(dist)
}



sol=optim(par = conIni
           , fn = distgrup1
           , control=list(trace=4, maxit=100000, verbose=TRUE))

a=sol$par[1] 
b=sol$par[2]
c=sol$par[3]
d=sol$par[4]
e=sol$par[5]
f=sol$par[6]
g=sol$par[7] 
h=sol$par[8] 
l=sol$par[9]
m=sol$par[10]
n=sol$par[11]
y=c(1-a-b,a,0,0,0,b,0,1-c-d-e-f,c,d,e,f,0,0,1-g-h-l,g,h,l,0,0,0,1-m-n,m,n,0,0,0,0,1,0,0,0,0,0,0,1)
tm=matrix(y,nrow=6,ncol=6,byrow=T)

P1=diag(6)
for(r in 1:60){
  P1=P1%*%tm
}
i=1:60
incidence=sum(tm[1][1]^i*a)*100000/5
lcmort=P1[1,5]*100000/5
othermort=P1[1,6]*100000/5
#dist1=0.49*abs(incidence-1.6)/1.6+0.49*abs(lcmort-1)+0.02*abs(othermort-70.3794)/70.3794 #homes
dist1=0.49*abs(incidence-1.3)/1.3+0.49*abs(lcmort-0.9)/0.9+0.02*abs(othermort-38.0972)/38.0972 #dones

for(i in 1:36){
  if(y[i]<0){
    dist1=1e7
  }
}


#sol1=optim(par = sol$par
#          , fn = distgrup1
#          , control=list(trace=4, maxit=100000, verbose=TRUE))
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
#sol2=optim(par = sol1$par
#           , fn = distgrup1
#           , control=list(trace=4, maxit=100000, verbose=TRUE))
#
#a=sol2$par[1] 
#b=sol2$par[2]
#c=sol2$par[3]
#d=sol2$par[4]
#e=sol2$par[5]
#f=sol2$par[6]
#g=sol2$par[7] 
#h=sol2$par[8] 
#i=sol2$par[9]
#j=sol2$par[10]
#k=sol2$par[11]
#y=c(1-a-b,a,0,0,0,b,0,1-c-d-e-f,c,d,e,f,0,0,1-g-h-i,g,h,i,0,0,0,1-j-k,j,k,0,0,0,0,1,0,0,0,0,0,0,1)
#tm2=matrix(y,nrow=6,ncol=6,byrow=T)
#
#P1=diag(6)
#for(r in 1:60){
#  P1=P1%*%tm2
#}
#i=1:60
#incidence=sum(tm2[1][1]^i*a)*100000/5
#lcmort=P1[1,5]*100000/5
#othermort=P1[1,6]*100000/5
##dist1=0.49*abs(incidence-1.6)/1.6+0.49*abs(lcmort-1)+0.02*abs(othermort-70.3794)/70.3794 #homes
#dist1=0.49*abs(incidence-1.3)/1.3+0.49*abs(lcmort-0.9)/0.9+0.02*abs(othermort-38.0972)/38.0972 #dones
#
#for(i in 1:36){
#  if(y[i]<0){
#    dist1=1e7
#  }
#}

#sol<- GenSA(par = conIni
#         , fn = distgrup1
#         , lower = rep(0, length(conIni))
#         , upper = rep(1, length(conIni))
#         , control=list(trace.mat=TRUE, threshold.stop=0.0007, verbose=TRUE))
#
#a=sol$par[1] 
#b=sol$par[2]
#c=sol$par[3]
#d=sol$par[4]
#e=sol$par[5]
#f=sol$par[6]
#g=sol$par[7] 
#h=sol$par[8] 
#i=sol$par[9]
#j=sol$par[10]
#k=sol$par[11]
#x=c(1-a-b,a,0,0,0,b,0,1-c-d-e-f,c,d,e,f,0,0,1-g-h-i,g,h,i,0,0,0,1-j-k,j,k,0,0,0,0,1,0,0,0,0,0,0,1)
#tm=matrix(x,nrow=6,ncol=6,byrow=T)
#
#sol1<- GenSA(par = sol$par
#            , fn = distgrup1
#            , lower = rep(0, length(conIni))
#            , upper = rep(1, length(conIni))
#            , control=list(trace.mat=TRUE, threshold.stop=0.0007, verbose=TRUE))
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
#x=c(1-a-b,a,0,0,0,b,0,1-c-d-e-f,c,d,e,f,0,0,1-g-h-i,g,h,i,0,0,0,1-j-k,j,k,0,0,0,0,1,0,0,0,0,0,0,1)
#tm1=matrix(x,nrow=6,ncol=6,byrow=T)







