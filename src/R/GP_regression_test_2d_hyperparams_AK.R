library(plyr)
library(dplyr)
library(ggplot2)
library(cowplot)
library(hydroPSO)
library(data.table)
library(doParallel)
library(RColorBrewer)
library(MASS)
library(kernlab)

# Objective function
#f <- function(x) sin(.2*x[[1]]*x[[2]]) + sin(.5 * x[[1]])
#f <- function(x) 2*sin(.1*x[[1]]*x[[2]])
f <- function(x) sin(2*x[[1]]) - .1*x[[2]]*cos(3*x[[2]])
f.noise <- 1e-7

# GP prior mean
prior.mu <- function(x) 0

# OAK parameters
input.means <- c(5, 5)
input.vars <- c(2, 2)

# Plot values
plot.gps <- FALSE
x.limits <- c(0, 10)
y.limits <- c(-3, 3)

# Other values
seed <- 293526
n.cores <- 8
n.points <- 100
n.points.test <- 1000

# Kernel types: se, ak, ak1, ak2, oak.gaussian
#kernel.type <- 'oak.gaussian'
color.breaks <- seq(-2,2,.25)

# Performance measures: loglikelihood, test.mse
performance.measure <- 'test.mse'

# Function definitions

get.init.params <- function(kernel.type) {
  if (kernel.type == 'se') {
    initial.pars <- c(.5, 1)
    lower.bounds <- c(.01, .1)
    upper.bounds <- c(10, 10)
  } else if (kernel.type == 'ak') {
    initial.pars <- c(2,2,2,2)
    lower.bounds <- c(.01, .01, 0, 0)
    upper.bounds <- c(10, 10, 10, 10)
  } else if (kernel.type == 'ak1') {
    initial.pars <- c(.5, .5, 1)
    lower.bounds <- c(.01, .01, .1)
    upper.bounds <- c(10, 10, 10)
  } else if (kernel.type == 'ak2') {
    initial.pars <- c(.5, .5, 1)
    lower.bounds <- c(.01, .01, .1)
    upper.bounds <- c(10, 10, 10)
  } else if (kernel.type == 'oak.gaussian') {
    initial.pars <- c(5, 4, 3, 2, 1)
    lower.bounds <- c(.01, .01, 0, 0, 0)
    upper.bounds <- c(10, 10, 10, 10, 10)
  }
  return(list(
    initial.pars=initial.pars,
    lower.bounds=lower.bounds,
    upper.bounds=upper.bounds
  ))
}

build.k <- function(type, l, sigma2) {
  if (type == 'se') {
    k <- function(x,x2) {
      kernel <- rbfdot(sigma=1/(2*l^2))
      k <- kernelMatrix(kernel, as.matrix(x), as.matrix(x2))
      return(sigma2*k)
    }
    return(k)
  } else if (type == 'ak') {
    k <- function(x,x2) {
      kernel1 <- rbfdot(sigma=1/(2*l[1]^2))
      kernel2 <- rbfdot(sigma=1/(2*l[2]^2))
      k1 <- kernelMatrix(kernel1, as.matrix(x[,1]), as.matrix(x2[,1]))
      k2 <- kernelMatrix(kernel2, as.matrix(x[,2]), as.matrix(x2[,2]))
      return(sigma2[1]*(k1 + k2) + sigma2[2]*k1*k2)
    }
    return(k)
  } else if (type == 'ak1') {
    k <- function(x,x2) {
      kernel1 <- rbfdot(sigma=1/(2*l[1]^2))
      kernel2 <- rbfdot(sigma=1/(2*l[2]^2))
      k1 <- kernelMatrix(kernel1, as.matrix(x[,1]), as.matrix(x2[,1]))
      k2 <- kernelMatrix(kernel2, as.matrix(x[,2]), as.matrix(x2[,2]))
      return(sigma2[1]*(k1 + k2))
    }
    return(k)
  } else if (type == 'ak2') {
    k <- function(x,x2) {
      kernel1 <- rbfdot(sigma=1/(2*l[1]^2))
      kernel2 <- rbfdot(sigma=1/(2*l[2]^2))
      k1 <- kernelMatrix(kernel1, as.matrix(x[,1]), as.matrix(x2[,1]))
      k2 <- kernelMatrix(kernel2, as.matrix(x[,2]), as.matrix(x2[,2]))
      return(sigma2[2]*k1*k2)
    }
    return(k)
  } else if (type == 'oak.gaussian') {
    k <- function(x,x2) {
      kerneld <- function(x1,x2) {
        -(2*crossprod(x1,x2) - crossprod(x1) - crossprod(x2))
      }      
      
      m1 <- as.matrix(x[,1])
      m2 <- as.matrix(x2[,1])
      
      kernel1 <- rbfdot(sigma=1/(2*l[1]^2))
      k1 <- kernelMatrix(kernel1, m1, m2)       
      exp.numerator1 <- kernelMatrix(kerneld, m1-input.means[1], m2-input.means[1])
      #exp.numerator1 <- (x[,1]-input.means[1])^2 + (x2[,1]-input.means[1])^2
      k1 <- k1 - 
        l[1]*sqrt(l[1]^2+2*input.vars[1]^2)/(l[1]^2+input.vars[1]^2) *
        exp(-exp.numerator1/(2*(l[1]^2+input.vars[1]^2)))
      
      m1 <- as.matrix(x[,2])
      m2 <- as.matrix(x2[,2])
      
      kernel2 <- rbfdot(sigma=1/(2*l[2]^2))
      k2 <- kernelMatrix(kernel2, m1, m2)
      exp.numerator2 <- kernelMatrix(kerneld, m1-input.means[2], m2-input.means[2])
      #exp.numerator2 <- (x[,2]-input.means[2])^2 + (x2[,2]-input.means[2])^2
      k2 <- k2 - 
        l[2]*sqrt(l[2]^2+2*input.vars[2]^2)/(l[2]^2+input.vars[2]^2) *
        exp(-exp.numerator2/(2*(l[2]^2+input.vars[2]^2)))
      
      return(sigma2[1] + sigma2[2]*(k1 + k2) + sigma2[3]*k1*k2)
    }
    return(k)
  } else if (type == 'oak.gaussian0') {
    k <- function(x,x2) {
      return(sigma2[1])
    }
    return(k)
  } else if (type == 'oak.gaussian1') {
    k <- function(x,x2) {
      m1 <- as.matrix(x[,1])
      m2 <- as.matrix(x2[,1])
      
      kernel1 <- rbfdot(sigma=1/(2*l[1]^2))        
      kerneld <- function(x1,x2) {
        -(2*crossprod(x1,x2) - crossprod(x1) - crossprod(x2))
      }       
      
      k1 <- kernelMatrix(kernel1, m1, m2)       
      exp.numerator1 <- kernelMatrix(kerneld, m1-input.means[1], m2-input.means[1])
      #exp.numerator1 <- (x[,1]-input.means[1])^2 + (x2[,1]-input.means[1])^2
      k1 <- k1 - 
        l[1]*sqrt(l[1]^2+2*input.vars[1]^2)/(l[1]^2+input.vars[1]^2) *
        exp(-exp.numerator1/(2*(l[1]^2+input.vars[1]^2)))
      
      
      kernel2 <- rbfdot(sigma=1/(2*l[2]^2))
      k2 <- kernelMatrix(kernel2, as.matrix(x[,2]), as.matrix(x2[,2]))
      exp.numerator2 <- kernelMatrix(kerneld, m1-input.means[2], m2-input.means[2])
      #exp.numerator2 <- (x[,2]-input.means[2])^2 + (x2[,2]-input.means[2])^2
      k2 <- k2 - 
        l[2]*sqrt(l[2]^2+2*input.vars[2]^2)/(l[2]^2+input.vars[2]^2) *
        exp(-exp.numerator2/(2*(l[2]^2+input.vars[2]^2)))
      return(sigma2[2]*(k1 + k2))
    }
    return(k)
  } else if (type == 'oak.gaussian2') {
    k <- function(x,x2) {
      m1 <- as.matrix(x[,1])
      m2 <- as.matrix(x2[,1])
      
      kernel1 <- rbfdot(sigma=1/(2*l[1]^2))        
      kerneld <- function(x1,x2) {
        -(2*crossprod(x1,x2) - crossprod(x1) - crossprod(x2))
      }       
      
      k1 <- kernelMatrix(kernel1, m1, m2)       
      exp.numerator1 <- kernelMatrix(kerneld, m1-input.means[1], m2-input.means[1])
      #exp.numerator1 <- (x[,1]-input.means[1])^2 + (x2[,1]-input.means[1])^2
      k1 <- k1 - 
        l[1]*sqrt(l[1]^2+2*input.vars[1]^2)/(l[1]^2+input.vars[1]^2) *
        exp(-exp.numerator1/(2*(l[1]^2+input.vars[1]^2)))
      
      
      kernel2 <- rbfdot(sigma=1/(2*l[2]^2))
      k2 <- kernelMatrix(kernel2, as.matrix(x[,2]), as.matrix(x2[,2]))
      exp.numerator2 <- kernelMatrix(kerneld, m1-input.means[2], m2-input.means[2])
      #exp.numerator2 <- (x[,2]-input.means[2])^2 + (x2[,2]-input.means[2])^2
      k2 <- k2 - 
        l[2]*sqrt(l[2]^2+2*input.vars[2]^2)/(l[2]^2+input.vars[2]^2) *
        exp(-exp.numerator2/(2*(l[2]^2+input.vars[2]^2)))
      return(sigma2[3]*k1*k2)
    }
    return(k)
  }
}

calculate.regression.model <- function(X, y, k) {
  if (nrow(X) == 0) {
    K <- numeric(0)
    Ki <- K
  } else {
    K <- k(X,X)
    if (nrow(X) == 1) {
      Ki <- 1/(K + f.noise)
    } else {
      # ginv vs solve
      Ki <- solve(matrix(unlist(K),nrow=nrow(K)) + f.noise*diag(nrow(K)))
    }
  }
  
  fs <- function(Xs) {
    if (nrow(X) == 0)
      return(prior.mu(Xs))
    
    Ks <- k(Xs, X)
    # Ks <- matrix(unlist(Ks),nrow=nrow(Ks))
    return(prior.mu(Xs) + Ks %*% Ki %*% (y - prior.mu(Xs)))
  }
  
  
  sigma <- function(Xs) {
    Kss <- k(Xs, Xs)
    # Kss <- apply(Xs, 1, function(r) k(r,r))
    
    if (nrow(X) == 0)
      return(Kss)
    
    Ks <- k(Xs, X)
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

calculate.loglik <- function(gp.model, observed.x, observed.y) {
  Lu <- matrix(chol(gp.model$K), nrow=nrow(gp.model$K))
  Ll <- t(Lu)
  S1 <- forwardsolve(Ll, observed.y)
  S2 <- backsolve(Lu, S1)
  
  log.lik <- -sum(log(diag(Ll))) - .5 * observed.y %*% S2 - 0.5 * nrow(observed.x) + log(2*pi)
  return(log.lik)
}

calculate.test.mse <- function(gp.model, observed.x, observed.y) {
  set.seed(234)
  x.test <- data.frame(x1=runif(n.points.test, 0, 10), x2=runif(n.points.test, 0, 10))
  
  y.test <- apply(x.test, 1, f)
  y.model <- gp.model$mean(x.test)
  
  mse <- mean((y.test - y.model)^2)
  return(mse)
} 

if (performance.measure == 'loglikelihood') {
  calculate.performance <- calculate.loglik
  fnscale <- -1
} else if (performance.measure == 'test.mse') {
  calculate.performance <- calculate.test.mse
  fnscale <- 1
}

# Build target function plot

x1.plt <- seq(0, 10, .25)
x2.plt <- seq(0, 10, .25)
df.f <- expand.grid(x1.plt, x2.plt)
names(df.f) <- c('x', 'y')
x.plt <- df.f
df.f$z <- apply(df.f, 1, f)
names(x.plt) <- c('x1', 'x2')
xx <- x.plt

plt.f <- ggplot(df.f, aes(x=x, y=y, z=z)) + 
  geom_contour_filled(
    breaks=color.breaks
  ) +
  scale_fill_viridis_d(drop=FALSE) +
  theme(legend.position = "none") +
  xlab('') +
  ylab('') +
  ggtitle('Target function')
plt.f


# Define hyperparameter optimization

calculate.params.ll <- function(pars, kernel.type) {
  if (kernel.type == 'se') {
    l <- pars[1]
    sigma2 <- pars[2]
  } else if (kernel.type == 'ak') {
    l <- pars[1:2]
    sigma2 <- pars[3:4]
  } else if (kernel.type == 'ak1') {
    l <- pars[1:2]
    sigma2 <- pars[3]
  } else if (kernel.type == 'ak2') {
    l <- pars[1:2]
    sigma2 <- pars[3]
  } else if (kernel.type == 'oak.gaussian') {
    l <- pars[1:2]
    sigma2 <- pars[3:5]
  }
  
  k <- build.k(kernel.type, l, sigma2)
  
  observed.x <- data.frame(x1=runif(n.points, 0, 10), x2=runif(n.points, 0, 10))
  observed.y <- apply(observed.x, 1, f)
  
  gp.model <- calculate.regression.model(observed.x, observed.y, k)
  
  perf <- calculate.performance(gp.model, observed.x, observed.y)
  
  if (plot.gps) {
    cl <- makeCluster(n.cores)
    clusterExport(cl, ls(1))
    registerDoParallel(cl)
    
    df.f.model <- df.f
    df.f.model$z <- foreach(x=iter(xx, by='row'), .combine='c') %dopar% {
      gp.model$mean(data.frame(x))
    }
    
    stopCluster(cl)
    
    plt <- ggplot(df.f.model, aes(x=x, y=y, z=z)) +
      geom_contour_filled(
        breaks=color.breaks
      ) +
      geom_point(data=observed.x, aes(x=x1, y=x2, z=NULL)) +
      scale_fill_viridis_d(drop=FALSE) +
      theme(legend.position = "none") +
      xlab('') +
      ylab('') +
      ggtitle(paste0('Gaussian process (Log-likelihood: ', perf, ')'))
    
    plt2 <- plot_grid(plt.f, plt, ncol=2, align='h')
    print(plt2)
  }
  
  if (performance.measure == 'loglikelihood') perf.name <- 'll'
  else if (performance.measure == 'test.mse') perf.name <- 'mse'
  message(paste0('l=',paste0(l, collapse=','),
                 ', sigma2=', paste0(sigma2, collapse=','), ' (', perf.name, '=', perf, ')'), appendLF=TRUE )
  return(perf)
}


set.seed(123)
kernel.type <- 'oak.gaussian'
optim.params <- get.init.params(kernel.type)

optim.result <- optim(par=optim.params$initial.pars,
                      method='SAN',
                      #method='L-BFGS-B',
                      fn=calculate.params.ll,
                      lower=optim.params$lower.bounds,
                      upper=optim.params$upper.bounds,
                      control=list(
                        pgtol=0,
                        fnscale=fnscale,
                        temp=1000,
                        tmax=1000,
                        maxit=10000
                      ),
                      kernel.type=kernel.type
)
cat('\nOptimization results:', sep='\n')
cat(paste0(' Params=', paste0(optim.result$par, collapse=',')), sep='\n')
cat(paste0(' Performance=', optim.result$value), sep='\n')
cat(paste0(' Variance: ', 
           paste0(formatC(optim.result$par[3:5]*100/sum(optim.result$par[3:5]), 
                          format='f', digits=2), '%', collapse = ', '), 
           sep='\n'))

l <- optim.result$par[1:2]
sigma2 <- optim.result$par[3:4]
