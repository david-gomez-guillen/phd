


## Fixem les primeres vuit matrius calibrades i calibrem la ultima sola


library(GenSA)
demon=0

calib_mat9=function(x,incidence,lcmort,othermort){

pa=c(x[[1]][1,2],x[[1]][1,6],x[[1]][2,3],x[[1]][2,4],x[[1]][2,5],x[[1]][2,6],x[[1]][3,4],x[[1]][3,5],x[[1]][3,6],x[[1]][4,5],x[[1]][4,6])
for(q in 2:8){
  pa=c(pa,x[[q]][1,2],x[[q]][1,6],x[[q]][2,3],x[[q]][2,4],x[[q]][2,5],x[[q]][2,6],x[[q]][3,4],x[[q]][3,5],x[[q]][3,6],x[[q]][4,5],x[[q]][4,6])
}
conIni=c(x[[9]][1,2],x[[9]][1,6],x[[9]][2,3],x[[9]][2,4],x[[9]][2,5],x[[9]][2,6],x[[9]][3,4],x[[9]][3,5],x[[9]][3,6],x[[9]][4,5],x[[9]][4,6])
#hem canviat un parametre per 0.001

real.inc = c(1.9,9.0,20.9,39.7,57.9,68.8,71.4,70.4,69.9) # WOMEN
real.lcmort= c(0.29,5.0,13.4,26.6,42.5,51.1,52.0,52.3,53.9)
real.othermort = c( 0.398893, 0.640476, 1.146431, 1.889474, 2.892546, 4.170061, 6.047883, 9.968391, 18.716366)*100

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
for(q in 1:8){
  a[q]=pa[11*count+1] 
  b[q]=pa[11*count+2]
  c[q]=pa[11*count+3]
  d[q]=pa[11*count+4]
  e[q]=pa[11*count+5]
  f[q]=pa[11*count+6]
  g[q]=pa[11*count+7] 
  h[q]=pa[11*count+8] 
  l[q]=pa[11*count+9]
  m[q]=pa[11*count+10]
  n[q]=pa[11*count+11]
  count=count+1
}

x2=list()
x3=list()
for(q in 1:8){
  x2[[q]]=c(1-a[q]-b[q],a[q],0,0,0,b[q],0,1-c[q]-d[q]-e[q]-f[q],c[q],d[q],e[q],f[q],0,0,1-g[q]-h[q]-l[q],g[q],h[q],l[q],0,0,0,1-m[q]-n[q],m[q],n[q],0,0,0,0,1,0,0,0,0,0,0,1)
  x3[[q]]=matrix(x2[[q]],nrow=6,ncol=6,byrow=T)
}
P=list()
for(q in 1:8){
  P[[q]]=diag(6)
  for(r in 1:60){
    P[[q]]=P[[q]]%*%x3[[q]]
  }
}
p=diag(6)
for(q in 1:8){
  p=p%*%P[[q]]
}
####################
### funcio distancia
###################

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
   
  
    x4=c(1-a-b,a,0,0,0,b,0,1-c-d-e-f,c,d,e,f,0,0,1-g-h-l,g,h,l,0,0,0,1-m-n,m,n,0,0,0,0,1,0,0,0,0,0,0,1)
    x5=matrix(x4,nrow=6,ncol=6,byrow=T)
    
    P1=diag(6)
    for(r in 1:60){
      P1=P1%*%x5
    }
    p1=p[1,1]
    p2=p[1,2]
    p3=p[1,3]
    p4=p[1,4]
    pt=p1+p2+p3+p4
    i=0:60
    incidence9=sum((x5[1][1]^i)*a)*100000/5
    lcmort9=(P1[1,5]*(p1/pt)+P1[2,5]*(p2/pt)+P1[3,5]*(p3/pt)+P1[4,5]*(p4/pt))*100000/5
    othermort9=(P1[1,6]*(p1/pt)+P1[2,6]*(p2/pt)+P1[3,6]*(p3/pt)+P1[4,6]*(p4/pt))*100000/5
    #dist=0.49*abs(incidence-1.6)/1.6+0.49*abs(lcmort-1)+0.02*abs(othermort-70.3794)/70.3794 #homes
    dist=0.45*abs(incidence9-real.inc[9])/real.inc[9]+0.45*abs(lcmort9-real.lcmort[9])/real.lcmort[9]+0.1*abs(othermort9-real.othermort[9])/real.othermort[9] #dones
    
  
  ##############################################################################################################
  #####pensar be com calcular la incidencia i mortalitats
  
  #p1=probabilitat health
  #p2=probabilitat estar en estat 2
  #p3=probabilitat estar en estat 3
  #p4=probabilitat estar en estat4
  #p1+p2+p3+p4= probabilitat estar viu
  #pt=p1+p2+p3+p4
  
    for(i in 1:36){
      if(x4[i]<0){
        dist=1e7
      }
    }
  
  #if (verbose) {
  #  demon <<- demon+1
  #  cat(sprintf("%6d > %10.6f\n", demon, dist))
  #}
  
  
  return(dist)
}


#################
### optimitzacio
#################
sol=optim(par = conIni
          , fn = distgrup1
          , control=list(trace=0, maxit=100000, verbose=TRUE))

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
           , control=list(trace=0, maxit=100000, verbose=TRUE))

a=sol1$par[1] 
b=sol1$par[2]
c=sol1$par[3]
d=sol1$par[4]
e=sol1$par[5]
f=sol1$par[6]
g=sol1$par[7] 
h=sol1$par[8] 
i=sol1$par[9]
j=sol1$par[10]
k=sol1$par[11]
y=c(1-a-b,a,0,0,0,b,0,1-c-d-e-f,c,d,e,f,0,0,1-g-h-i,g,h,i,0,0,0,1-j-k,j,k,0,0,0,0,1,0,0,0,0,0,0,1)
tm1=matrix(y,nrow=6,ncol=6,byrow=T)

P1=diag(6)
for(r in 1:60){
  P1=P1%*%tm1
}
p1=p[1,1]
p2=p[1,2]
p3=p[1,3]
p4=p[1,4]
pt=p1+p2+p3+p4
i=0:60
incidence9=sum((tm1[1][1]^i)*a)*100000/5
lcmort9=(P1[1,5]*(p1/pt)+P1[2,5]*(p2/pt)+P1[3,5]*(p3/pt)+P1[4,5]*(p4/pt))*100000/5
othermort9=(P1[1,6]*(p1/pt)+P1[2,6]*(p2/pt)+P1[3,6]*(p3/pt)+P1[4,6]*(p4/pt))*100000/5
#
#
#
#
#sol2=optim(par = sol1$par
#           , fn = distgrup1
#           , control=list(trace=4, maxit=100000, verbose=TRUE))
#
#sol3=optim(par = sol2$par
#           , fn = distgrup1
#           , control=list(trace=4, maxit=100000, verbose=TRUE))
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
#            , fn = distgrup1
#            , control=list(trace=4, maxit=100000, verbose=TRUE))
#sol11=optim(par = sol10$par
#            , fn = distgrup1
#            , control=list(trace=4, maxit=100000, verbose=TRUE))
#sol12=optim(par = sol11$par
#            , fn = distgrup1
#            , control=list(trace=4, maxit=100000, verbose=TRUE))
#sol13=optim(par = sol12$par
#            , fn = distgrup1
#            , control=list(trace=4, maxit=100000, verbose=TRUE))







#calculem incidencia i mortalitats per sol$4
#a=vector()
#b=vector()
#c=vector()
#d=vector()
#e=vector()
#f=vector()
#g=vector()
#h=vector()
#l=vector()
#m=vector()
#n=vector()
#count=0
#for(q in 1:9){
#  a[q]=sol13$par[11*count+1] 
#  b[q]=sol13$par[11*count+2]
#  c[q]=sol13$par[11*count+3]
#  d[q]=sol13$par[11*count+4]
#  e[q]=sol13$par[11*count+5]
#  f[q]=sol13$par[11*count+6]
#  g[q]=sol13$par[11*count+7] 
#  h[q]=sol13$par[11*count+8] 
#  l[q]=sol13$par[11*count+9]
#  m[q]=sol13$par[11*count+10]
#  n[q]=sol13$par[11*count+11]
#  count=count+1
#}
#
#x1=list()
#x=list()
#for(q in 1:9){
#  x1[[q]]=c(1-a[q]-b[q],a[q],0,0,0,b[q],0,1-c[q]-d[q]-e[q]-f[q],c[q],d[q],e[q],f[q],0,0,1-g[q]-h[q]-l[q],g[q],h[q],l[q],0,0,0,1-m[q]-n[q],m[q],n[q],0,0,0,0,1,0,0,0,0,0,0,1)
#  x[[q]]=matrix(x1[[q]],nrow=6,ncol=6,byrow=T)
#}
#
#P=list()
#for(q in 1:9){
#  P[[q]]=diag(6)
#  for(r in 1:60){
#    P[[q]]=P[[q]]%*%x[[q]]
#  }
#}
#
#incidence=vector()
#lcmort=vector()
#othermort=vector()
#
#i=0:60
#incidence[1]=sum((x[[1]][1,1]^i)*a[1])*100000/5
#lcmort[1]=P[[1]][1,5]*100000/5
#othermort[1]=P[[1]][1,6]*100000/5
#p=P[[1]]
#for(q in 2:9){
#  
#  p1=p[1,1]
#  p2=p[1,2]
#  p3=p[1,3]
#  p4=p[1,4]
#  pt=p1+p2+p3+p4
#  i=0:60
#  incidence[q]=sum((x[[q]][1,1]^i)*a[q])*100000/5
#  lcmort[q]=(P[[q]][1,5]*(p1/pt)+P[[q]][2,5]*(p2/pt)+P[[q]][3,5]*(p3/pt)+P[[q]][4,5]*(p4/pt))*100000/5
#  othermort[q]=(P[[q]][1,6]*(p1/pt)+P[[q]][2,6]*(p2/pt)+P[[q]][3,6]*(p3/pt)+P[[q]][4,6]*(p4/pt))*100000/5
#  
#  p=p%*%P[[q]]
#}
#dist=sum(0.45*abs(incidence-real.inc)/real.inc+0.45*abs(lcmort-real.lcmort)/real.lcmort+0.1*abs(othermort-real.othermort)/real.othermort) #dones
#
#




##### plots

#y=c("35-39","40-44","45-49","50-54","55-59","60-64","65-69","70-74","75-79")
x[[9]]=tm1
incidence[9]=incidence9
lcmort[9]=lcmort9
othermort[9]=othermort9

ret=list()
ret$mat=x
ret$inc=incidence
ret$lcm=lcmort
ret$othm=othermort

return(ret)
}




##### plots
#x[[9]]=tm1
#incidence[[9]]=incidence9
#lcmort[[9]]=lcmort9
#othermort[[9]]=othermort9
#y=1:9
#names(y)=c("35-39","40-44","45-49","50-54","55-59","60-64","65-69","70-74","75-79")
#par(mfrow=c(1,3))
#plot(y,incidence,"o",col="red", xlab="age group", ylab="incidence")
#lines(y,real.inc,"o",col="blue")#, xlab="age group", ylab="incidence")
#
#plot(y,lcmort,"o",col="red", xlab="age group", ylab="lc.mortality")
#lines(y,real.lcmort,"o",col="blue")#, xlab="age group", ylab="incidence")
#
#plot(y,othermort,"o",col="red", xlab="age group", ylab="tot.mortality")
#lines(y,real.othermort,"o",col="blue")#, xlab="age group", ylab="incidence")
