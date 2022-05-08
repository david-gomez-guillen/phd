
# li passem les entrades d'una matriu de transici? i ens torna la incidencia i mortalitats al cap de 5 anys
distgrup1 <-function(p){
  a=p[1] 
  b=p[2]
  c=p[3]
  d=p[4]
  e=p[5]
  f=p[6]
  g=p[7] 
  h=p[8] 
  i=p[9]
  j=p[10]
  k=p[11]
  
  x=c(1-a-b,a,0,0,0,b,0,1-c-d-e-f,c,d,e,f,0,0,1-g-h-i,g,h,i,0,0,0,1-j-k,j,k,0,0,0,0,1,0,0,0,0,0,0,1)
  x=matrix(x,nrow=6,ncol=6,byrow=T)
  P=x%*%x%*%x%*%x%*%x%*%x%*%x%*%x%*%x%*%x%*%x%*%x
  P=P%*%P%*%P%*%P%*%P
  i=1:60
  incidence=sum(x[1][1]^i*a)*100000
  lcmort=P[1][6]*100000
  othermort=P[1][7]*100000
  dist=0.49*abs(incidence-1.6)/1.6+0.49*abs(lcmort-1)-0.02*abs(othermort-0.703794)/0.703794
  return(dist)
}