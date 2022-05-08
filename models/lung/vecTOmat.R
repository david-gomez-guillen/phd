get_matrix=function(v){
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
    a[q]=v[11*count+1] 
    b[q]=v[11*count+2]
    c[q]=v[11*count+3]
    d[q]=v[11*count+4]
    e[q]=v[11*count+5]
    f[q]=v[11*count+6]
    g[q]=v[11*count+7] 
    h[q]=v[11*count+8] 
    l[q]=v[11*count+9]
    m[q]=v[11*count+10]
    n[q]=v[11*count+11]
    count=count+1
  }
  
  ma1=list()
  ma=list()
  for(q in 1:9){
    ma1[[q]]=c(1-a[q]-b[q],a[q],0,0,0,b[q],0,1-c[q]-d[q]-e[q]-f[q],c[q],d[q],e[q],f[q],0,0,1-g[q]-h[q]-l[q],g[q],h[q],l[q],0,0,0,1-m[q]-n[q],m[q],n[q],0,0,0,0,1,0,0,0,0,0,0,1)
    ma[[q]]=matrix(ma1[[q]],nrow=6,ncol=6,byrow=T)
  }
  
  P=list()
  for(q in 1:9){
    P[[q]]=diag(6)
    for(r in 1:60){
      P[[q]]=P[[q]]%*%ma[[q]]
    }
  }
  
  incidence=vector()
  lcmort=vector()
  othermort=vector()
  
  i=0:60
  incidence[1]=sum((ma[[1]][1,1]^i)*a[1])*100000/5
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
    incidence[q]=sum((ma[[q]][1,1]^i)*a[q])*100000/5
    lcmort[q]=(P[[q]][1,5]*(p1/pt)+P[[q]][2,5]*(p2/pt)+P[[q]][3,5]*(p3/pt)+P[[q]][4,5]*(p4/pt))*100000/5
    othermort[q]=(P[[q]][1,6]*(p1/pt)+P[[q]][2,6]*(p2/pt)+P[[q]][3,6]*(p3/pt)+P[[q]][4,6]*(p4/pt))*100000/5
    
    p=p%*%P[[q]]
  }
  ret=list()
  ret$mat=ma
  ret$inc=incidence
  ret$lcm=lcmort
  ret$om=othermort
  return(ret)
}




get_inf=function(x){
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
    a[q]=sol3$par[11*count+1] 
    b[q]=sol3$par[11*count+2]
    c[q]=sol3$par[11*count+3]
    d[q]=sol3$par[11*count+4]
    e[q]=sol3$par[11*count+5]
    f[q]=sol3$par[11*count+6]
    g[q]=sol3$par[11*count+7] 
    h[q]=sol3$par[11*count+8] 
    l[q]=sol3$par[11*count+9]
    m[q]=sol3$par[11*count+10]
    n[q]=sol3$par[11*count+11]
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
  ret=list()
  ret$inc=incidence
  ret$lcm=lcmort
  ret$othm=othermort
  return(ret)
}