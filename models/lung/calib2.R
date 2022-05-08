

library(GenSA)
demon=0



conIni=list()
  
  conIni[[1]]=c(1.21394085430723E-06, 0.00005867, 0.654587204001507, 0.224627519
         , 0.023943083
         , 0.007128197
         , 0.596374421
         , 0.031069259
         , 2.02142e-06
         , 0.027943136
         , 0.003128144)
  
  for(i in 2:40){
      conIni[[i]]=conIni[[1]]+runif(11,min=-1,max=1)*conIni[[1]]/2
  }


#distgrup1<-function(par,verbose=TRUE){
#  
#  a=par[1] 
#  b=par[2]
#  c=par[3]
#  d=par[4]
#  e=par[5]
#  f=par[6]
#  g=par[7] 
#  h=par[8] 
#  i=par[9]
#  j=par[10]
#  k=par[11]
#  
#  
#  
#  x1=c(1-a-b,a,0,0,0,b,0,1-c-d-e-f,c,d,e,f,0,0,1-g-h-i,g,h,i,0,0,0,1-j-k,j,k,0,0,0,0,1,0,0,0,0,0,0,1)
#  x=matrix(x1,nrow=6,ncol=6,byrow=T)
#  
#  P=diag(6)
#  for(r in 1:60){
#    P=P%*%x
#  }
#  i=1:60
#  incidence=sum(x[1][1]^i*a)*100000
#  lcmort=P[1,5]*100000/5
#  othermort=P[1,6]*100000/5
#  dist=0.49*abs(incidence-1.6)/1.6+0.49*abs(lcmort-1)+0.02*abs(othermort-0.703794)/0.703794
#  for(i in 1:36){
#    if(x1[i]<0){
#      dist=1e7
#    }
#  }
#  
# # if (verbose) {
# #   demon <<- demon+1
# #   cat(sprintf("%6d > %10.6f\n", demon, dist))
# #}
#  
#  return(dist)
#}
  
  distgrup1<-function(par,verbose=TRUE){
    
    a=par[1] 
    b=par[2]
    c=par[3]
    d=par[4]
    e=par[5]
    f=par[6]
    g=par[7] 
    h=par[8] 
    i=par[9]
    j=par[10]
    k=par[11]
    
    
    
    x1=c(1-a-b,a,0,0,0,b,0,1-c-d-e-f,c,d,e,f,0,0,1-g-h-i,g,h,i,0,0,0,1-j-k,j,k,0,0,0,0,1,0,0,0,0,0,0,1)
    x=matrix(x1,nrow=6,ncol=6,byrow=T)
    
    P=diag(6)
    for(r in 1:60){
      P=P%*%x
    }
    i=1:60
    incidence=sum(x[1][1]^i*a)*100000
    lcmort=P[1,5]*100000/5
    othermort=P[1,6]*100000/5
    dist=0.49*abs(incidence-1.6)/1.6+0.49*abs(lcmort-1)+0.02*abs(othermort-0.703794)/0.703794
    
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
  
tm2=list()
for(t in 1:40){
    sol2=optim(par = conIni[[1]]
               , fn = distgrup1
               , control=list(trace=4, maxit=100000, verbose=TRUE))
    
    cat(sprintf("%d > %10.6f\n", t, distgrup1))
    a=sol2$par[1] 
    b=sol2$par[2]
    c=sol2$par[3]
    d=sol2$par[4]
    e=sol2$par[5]
    f=sol2$par[6]
    g=sol2$par[7] 
    h=sol2$par[8] 
    i=sol2$par[9]
    j=sol2$par[10]
    k=sol2$par[11]
    x=c(1-a-b,a,0,0,0,b,0,1-c-d-e-f,c,d,e,f,0,0,1-g-h-i,g,h,i,0,0,0,1-j-k,j,k,0,0,0,0,1,0,0,0,0,0,0,1)
    #tm2[[t]]=matrix(x,nrow=6,ncol=6,byrow=T)
}
