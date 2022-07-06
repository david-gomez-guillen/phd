library(jsonlite)

make.calibration.func <- function(population, param.names, param.strata) {

calibration.func<-function(par,verbose=TRUE){
  
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
  
  # Assemble vectors for matrices
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
  
  # Assemble matrices
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
  
  # Multiply matrices
  P=list()
  for(q in 1:N_MATRICES){
    P[[q]]=diag(6)
    for(r in 1:60){
      P[[q]]=P[[q]]%*%x[[q]]
    }
  }

  # Calculate outputs
  incidence=vector()
  lcmort=vector()
  othermort=vector()
  
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
  
  # No negative probabilities
    alpha <- 1  # Factor to multiply outputs when constraints not met
    for(q in 1:N_MATRICES){
    for(i in 1:36){
      if(x1[[q]][i]<0){
        alpha <- alpha - x1[[q]][i] * 1e1  # Modificat per forçar distancia derivable
      }
    }
  }

  #el risc de morir de cancer ha d'augmentar en cada estat
 # for(q in 1:N_MATRICES){
 #   if(x[[q]][2,5]>x[[q]][3,5] || x[[q]][3,5]>x[[q]][4,5]){
 #     dist=100000+runif(1,0,1000)
 #   }
 # }

  incidence <- incidence * alpha
  lc_mortality <- lcmort * alpha
  other_mortality <- othermort * alpha

  result <- list(incidence=incidence,
                 lc_mortality=lcmort,
                 other_mortality=othermort)
  return(toJSON(result))
}
return (calibration.func)
}