library(MASS)
library(plyr)
library(dplyr)
library(ggplot2)
library(cowplot)
library(hydroPSO)
library(doParallel)
library(data.table)
library(plotly)
library(htmlwidgets)
library(RColorBrewer)
library(optimParallel)

### Kernel
build.k <- function(l, sigma2=1.15816) {
  # sigma2 = MSE relative to prior (=0)
  k <- function(x,x2) {
    sigma2*exp(-1/(l^2)*norm(x-x2,'2'))
  }
  return(k)
}

# Objective function noise
f <- function(x) sin(.2*x[[1]]*x[[2]]) + sin(.5 * x[[1]])
f.noise <- 0

# GP prior mean
prior.mu <- function(x) 0

# Plot values
x.limits <- c(0, 10)
y.limits <- c(-3, 3)

# Optimization values
n.cores.global <- 3
n.cores.task <- 2
n.iterations <- 10
batch.size <- 1
use.optimization <- FALSE
n.pso.particles <- 10

# Function definitions

calculate.regression.model <- function(X, y, k) {
  if (nrow(X) == 0) {
    K <- numeric(0)
    Ki <- K
  } else {
    K <- outer(1:nrow(X), 1:nrow(X), Vectorize(function(i,j) {
      k(X[i,], X[j,])
    }))
    if (nrow(X) == 1) {
      Ki <- 1/(K + f.noise)
    } else {
      Ki <- ginv(K + f.noise*diag(K))
    }
  }
  
  fs <- function(Xs) {
    if (nrow(X) == 0)
      return(prior.mu(Xs))
    
    # Ks <- outer(Xs, X, k)
    Ks <- outer(1:nrow(Xs), 1:nrow(X), Vectorize(function(i,j) {
      k(Xs[i,], X[j,])
    }))
    return(prior.mu(Xs) + Ks %*% Ki %*% (y - prior.mu(Xs)))
  }
  
  
  sigma <- function(Xs) {
    Kss <- outer(1:nrow(Xs), 1:nrow(Xs), Vectorize(function(i,j) {
      k(Xs[i,], Xs[j,])
    }))
    # Kss <- apply(Xs, 1, function(r) k(r,r))
    
    if (nrow(X) == 0)
      return(Kss)
    
    # Ks <- outer(Xs, X, k)
    Ks <- outer(1:nrow(Xs), 1:nrow(X), Vectorize(function(i,j) {
      k(Xs[i,], X[j,])
    }))
    S <- Kss - Ks %*% Ki %*% t(Ks)
    # if (Xs %in% observed.x && f.noise == 0)
    #   S <- matrix(0) # Due to numerical instability values already observed haved a non-zero sigma, forcing 0 here
    S <- apply(S, 1:2, function(x) max(x,0)) # Numerical instability, (small) negative values should be 0
    return(S)
  }
  
  if (nrow(X) == 0) {
    best.x <- c(0,0)
    best.y <- prior.mu(c(0,0))
  } else {
    best.x <- X[which.max(y),]
    best.y <- max(y)
  }
  
  return(list(mean=fs, cov=sigma, best.x=best.x, best.y=best.y, K=K))
}

if (use.optimization) {
  choose.next.evaluation.points <- function(x, y.acq, observed.x, gp.model) {
    optim.func <- function(x) -acq.func(gp.model, x)
    # sink('/dev/null')
    best <- tryCatch(suppressMessages(
      hydroPSO(fn=optim.func,
               lower=c(0,0),
               upper=c(10,10),
               control=list(
                 npart=n.pso.particles
               )))
      # ,finally=sink()
    )
    names(best$par) <- c('x1', 'x2')
    return(best$par)
  }
} else {
  choose.next.evaluation.points <- function(x, y.acq, observed.x, gp.model) {
    selected.rows <- !rownames(xx) %in% rownames(match_df(x, observed.x, on=c('x1', 'x2')))
    y2 <- y.acq[selected.rows]
    x2 <- x[selected.rows,]
    order.index <- order(y2, decreasing = T)
    y2 <- y2[order.index]
    x2 <- x2[order.index,]
    n.best <- sum(y2==y2[1])
    if (n.best == 1) {
      best.x <- 1
    } else {best.x <- sample(1:n.best, 1)}
    permutation <- c(best.x,sample(2:nrow(x2)))
    x2 <- x2[permutation,]
    y2 <- y2[permutation]
    next.evaluation.points <- unlist(x2[1:batch.size,])
    return(next.evaluation.points)
  }
}

acq.func <- function(gp.model, x) {
  return(acq.func.ei(gp.model, x))
}

acq.func.ei <- function(gp.model, x) {
  x2 <- data.frame(x)
  mu <- gp.model$mean(x2)
  tryCatch(
    sigma <- sqrt(gp.model$cov(x2)[1,1]),
    warning=function(e) {
      browser()})
  best.y <- gp.model$best.y
  if (sigma > 0) {
    return((mu-best.y)*pnorm((mu-best.y)/sigma) + sigma*dnorm((mu-best.y)/sigma))
  } else { # Observed value, no uncertainty
    return(max(mu-best.y,0))
  }
}

calculate.loglik <- function(gp.model, observed.x, observed.y) {
  Lu <- chol(gp.model$K)
  Ll <- t(Lu)
  S1 <- forwardsolve(Ll, observed.y)
  S2 <- backsolve(Lu, S1)
  
  log.lik <- -sum(log(diag(Ll))) - .5 * observed.y %*% S2 - 0.5 * nrow(observed.x) + log(2*pi)
  return(log.lik)
}


# Build target function plot

x1.plt <- seq(0, 10, .1)
x2.plt <- seq(0, 10, .1)
df.f <- expand.grid(x1.plt, x2.plt)
names(df.f) <- c('x', 'y')
x.plt <- df.f
df.f$z <- apply(df.f, 1, f)
names(x.plt) <- c('x1', 'x2')
xx <- x.plt

color.breaks <- seq(-2,2,.4)

plt.f <- ggplot(df.f, aes(x=x, y=y, z=z)) + 
  geom_contour_filled(
    breaks=color.breaks
  ) +
  scale_fill_viridis_d(drop=FALSE) +
  theme(legend.position = "bottom") +
  xlab('') +
  ylab('') +
  ggtitle('Target function')
plt.f


# Start optimization

calculate.params.ll <- function(l) {
  library(doParallel)
  library(plyr)
  library(dplyr)
  library(MASS)
  library(data.table)
  
  k <- build.k(l)
  
  observed.x <- data.frame(matrix(ncol=2,nrow=0))
  colnames(observed.x) <- c('x1', 'x2')
  observed.y <- numeric(0)
  
  set.seed(1)
  
  cl <- makeCluster(n.cores.task)
  clusterExport(cl, ls(1))
  registerDoParallel(cl)
  
  for(n in seq(n.iterations)) {
    gp.model <- calculate.regression.model(observed.x, observed.y, k)
    
    # xx <- x.plt
    yy.acq <- foreach(x=iter(xx, by='row'), .combine = 'c') %dopar% {
      acq.func(gp.model, x)
    }
    
    next.evaluation.points <- choose.next.evaluation.points(xx, yy.acq, observed.x, gp.model)
    # Forcing a starting point near a non-global maximum
    if (n == 1) {
      next.evaluation.points[1] <- 4
      next.evaluation.points[2] <- 9
    }  
    
    yy <- foreach(x=iter(xx, by='row'), .combine='c') %dopar% {
      gp.model$mean(data.frame(x))
    }
    ss <- foreach(x=iter(xx, by='row'), .combine='c') %dopar% {
      sqrt(max(gp.model$cov(data.frame(x))[1,1], 0))
    }
    
    df <- data.frame(x=xx$x1, y=xx$x2, z=yy)
    points.df <- data.frame(x=observed.x$x1, y=observed.x$x2, z=observed.y)
    next.points.df <- data.frame(x=next.evaluation.points[[1]], y=next.evaluation.points[[2]], z=f(next.evaluation.points))
    if (nrow(observed.x) > 0)
      best.point.df <- data.frame(x=gp.model$best.x[[1]], y=gp.model$best.x[[2]], z=f(gp.model$best.x))
    else
      best.point.df <- data.frame(x=numeric(0), y=numeric(0), z=numeric(0))
    
    if (n < n.iterations) {
      observed.x <- rbind(observed.x, data.frame(t(next.evaluation.points)))
      observed.y <- c(observed.y, f(next.evaluation.points))
    }
  }
  
  stopCluster(cl)
  
  ll <- calculate.loglik(gp.model, observed.x, observed.y)
  
  cat(paste0('l=',l,': ', ll, '\n'))
  return(ll)
}

cl.global <- makeCluster(n.cores.global, outfile='gp_output.log')
clusterExport(cl.global, ls(1))
registerDoParallel(cl.global)

optim.result <- optimParallel(par=1,
                              fn=calculate.params.ll,
                              lower=.2,
                              upper=5
                              ,control=list(pgtol=0)
                              ,parallel=list(cl=cl.global)
                              )

print(optim.result)

stopCluster(cl.global)
