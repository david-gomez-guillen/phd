library(foreach)
library(doParallel)
library(doRNG)
library(itertools)

# Requires a cluster registered by registerDoParallel
# Requires all variables used in f to be available in each cluster node
# (exported with clusterExport)
# Requires the function DistanceFunction defined in the workspace
# Returns gradient of f at point big.x
# Gradient is computed using a finite difference approximation,
# with provided step
DistanceParallelGradient <- function(big.x, f=DistanceFunction,
                                     step=1e-4, l=0, h=1,
                                     nc=getDoParWorkers(), ...) {

  force(big.x)
  force(f)

  foreach(I=isplitIndices(length(big.x),chunks=nc)
          , .combine = c) %dorng% {

    x <- big.x[I]
    # Creem els valors lower i higher, per a cada component
    lower.x  <- ifelse(x-step < l, l, x-step)
    higher.x <- ifelse(x+step > h, h, x+step)

    # Creem els 2*length(I) vectors que caldrà avaluar per calcular el gradient
    # Es fa en 2 fases, primer es creen les dues matrius amb length(I) columnes
    lower.vecs  <- matrix(big.x,nrow=length(big.x),ncol=length(I))
    higher.vecs <- matrix(big.x,nrow=length(big.x),ncol=length(I))

    # Després s'assignen els valors lower i higher on correspon
    lower.vecs [(I-I[1])*length(big.x)+I] <- lower.x
    higher.vecs[(I-I[1])*length(big.x)+I] <- higher.x

    # S'avalua la funció als vectors modificats
    pid <- Sys.getpid()
    sprintf("[ Worker %4d ] [BEGIN] GRADIENT EVALUATION", pid)
    lower.f  <- apply(lower.vecs , 2, f, ...)
    higher.f <- apply(higher.vecs, 2, f, ...)
    sprintf("[ Worker %4d ] [BEGIN] GRADIENT EVALUATION", pid)

    # Es retorna l'aproximació de la derivada
    (higher.f-lower.f)/(higher.x-lower.x)
  }

}

