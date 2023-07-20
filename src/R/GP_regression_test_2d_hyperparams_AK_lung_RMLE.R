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
library(jsonlite)
library(optimParallel)

# Objective function
N_MATRICES <- 1
STARTING_MATRIX <- 1
source('../../models/lung/calibration_wrapper.R')
f <- function(pars) {
  calib.f <- make.calibration.func('','','')
  result <- fromJSON(calib.f(pars))
  expectation <- list(
    incidence=c(1.9, 9.0, 20.9, 39.7, 57.9, 68.8, 71.4, 70.4, 69.9),
    lc.mortality=c(0.29, 5.0, 13.4, 26.6, 42.5, 51.1, 52.0, 52.3, 53.9),
    other.mortality=c(39.8893, 64.0476, 114.6431, 188.9474, 289.2546 ,417.0061, 604.7883, 996.8391, 1871.6366)
  )
  expectation <- lapply(expectation, function(m) m[1:n.matrices])
  se <- sapply(1:3, function(i) (result[[i]] - expectation[[i]])^2)
  return(sum(unlist(se) * c(.45, .45, .1)))
}

# GP prior mean
prior.mu <- function(x) 0

# Model parameters
n.matrices <- 1
initial.guess <- c(0.0000014899094538366, 0.00005867, 0.0373025655099923, 
                   0.45001903545473, 0.0310692140027966, 2.06599720339873e-06, 
                   0.083259360316924, 0.0310687721751887, 2.50782481130141e-06, 
                   0.031069806, 1.47440016369862e-06,
                   
                   1.04877e-05, 0.00009628, 0.014591745, 0.481776189, 
                   0.031069873, 1.40669e-06, 0.050026676, 0.031069146, 
                   2.13361e-06, 0.031070341, 9.38951e-07,
                   
                   0.00001850743, 0.00018182, 0.009078452, 0.445602151, 
                   0.031940262, 1.36813e-06, 0.040413788, 0.031940366, 
                   1.2638e-06, 0.031940406, 1.22435e-06,
                   
                   3.37959e-05, 0.00033198, 0.216982823, 0.745686098, 
                   0.03193267, 8.96007e-06, 0.279118741, 0.031934889, 
                   6.74088e-06, 0.031930383, 1.12474e-05,
                   
                   0.000047266, 0.00054161, 0.587748693, 0.367077318, 
                   0.022454858, 0.012333952, 0.938189625, 0.025488122, 
                   0.009300688, 0.030911619, 0.003877191,
                   
                   0.000057056, 0.00082374, 0.014863212, 0.94528741, 
                   0.02701171,0.0077771, 0.945729932, 0.033553455, 
                   0.001235355, 0.031429049, 0.003359761,
                   
                   0.00029203, 0.00124249, 0.57293827, 0.071391822, 
                   0.040115762, 0.000770938, 0.922967658, 0.004939897, 
                   0.035946803, 0.031592197, 0.009294503,
                   
                   0.00005383, 0.00190251, 0.224558597, 0.349067177, 
                   0.040817026, 6.96743e-05, 0.071749361, 0.001859725, 
                   0.039026975, 0.037767242, 0.003119458,
                   
                   0.000058942, 0.00330943, 0.009683304, 0.414010634, 
                   0.022973067, 0.030664353, 0.60868601, 0.006745365, 
                   0.046892055, 0.067318463, 0.004318957)
initial.guess <- initial.guess[1:(11*n.matrices)]
lower.limits <- initial.guess * .5
upper.limits <- initial.guess * 1.5

# OAK parameters
input.means <- rep(.5, 11*n.matrices)
input.vars <- rep(.2, 11*n.matrices)

# Plot values
plot.gps <- FALSE
x.limits <- c(0, 10)
y.limits <- c(-3, 3)

# Other values
seed <- 935216
n.cores <- 12
n.points <- 100
n.points.test <- 1000
fixed.training <- FALSE
fixed.test <- FALSE
n.iters.per.paramset <- 20
optimize.only.sigmas <- FALSE
l.fixed.pars <- c(    2.33134449714195,1e-04,2.33134449714195,2.33134449714195,2.33134449714195,0.667197159326941,2.33134449714195,0.667197159326941,0.667197159326941,2.33134449714195,2.33134449714195)

set.seed(234)
fixed.training.data <- lapply(initial.guess, function(xi) runif(n.points.test, xi*.5, xi*1.5))
set.seed(123)
fixed.mse.test.data <- lapply(initial.guess, function(xi) runif(n.points.test, xi*.5, xi*1.5))

# Kernel types: se, ak, ak1, ak2, oak.gaussian
#kernel.type <- 'oak.gaussian'
color.breaks <- seq(-2,2,.25)

# Performance measures: loglikelihood, test.mse
performance.measure <- 'loglikelihood'

# Function definitions

get.init.params <- function(kernel.type) {
  if (kernel.type == 'se') {
    initial.pars <- c(1, 1)
    lower.bounds <- c(.01, .01)
    upper.bounds <- c(10, 10)
  } else if (kernel.type == 'ak') {
    # initial.pars <- c(rep(.5, n.matrices*11), rep(5   , n.matrices*11))
    initial.pars <- c(0.999999999993379,0.01,1,1,1,0.999999999996571,1,1,1,1,1,0,10,0,0,0,0,10,10,10,0,1.03305626037006e-11)
    lower.bounds <- c(rep(.0001, n.matrices*11), rep(0, n.matrices*11))
    upper.bounds <- c(rep(5, n.matrices*11), rep(50, n.matrices*11))
  } else if (kernel.type == 'oak.gaussian') {
    if (optimize.only.sigmas) {
      initial.pars <- c(0,5,5,5,0,0,5,0,0,0,5,0)
      lower.bounds <- rep(0, n.matrices*11)
      upper.bounds <- rep(10, n.matrices*11)
    } else {
      # initial.pars <- c(2.33134449714195,1e-04,2.33134449714195,2.33134449714195,2.33134449714195,
      #                   0.667197159326941,2.33134449714195,0.667197159326941,0.667197159326941,2.33134449714195,
      #                   2.33134449714195,0.667163875714512,16.6418062142744,6.67163875714512,0,
      #                   0,0,0,6.67163875714512,23.3134449714195,
      #                   23.3134449714195,0,16.6418062142744)
      # initial.pars <- c(2.33134449714195,1e-04,2.33134449714195,2.33134449714195,2.33134449714195,
      #                   0.667197159326941,2.33134449714195,0.667197159326941,0.667197159326941,2.33134449714195,
      #                   2.33134449714195,
      #                   0,5,5,5,0,0,5,0,0,0,5,0)
      initial.pars <- c(2.33134449714195,1e-04,2.33134449714195,2.33134449714195,2.33134449714195,
                        0.667197159326941,2.33134449714195,0.667197159326941,0.667197159326941,2.33134449714195,
                        2.33134449714195,
                        0,0,0,0,0,0,0,0,0,0,0,0)
      lower.bounds <- c(rep(.0001, n.matrices*11), rep(0, (n.matrices*11 + 1)))
      upper.bounds <- c(rep(5, n.matrices*11), rep(10, (n.matrices*11 + 1)))
    }
    
    # initial.pars <- c(2.33134449714195,1e-04,2.33134449714195,2.33134449714195,2.33134449714195,0.667197159326941,2.33134449714195,0.667197159326941,0.667197159326941,2.33134449714195,2.33134449714195,0.667163875714512,16.6418062142744,6.67163875714512,0,0,0,0,6.67163875714512,23.3134449714195,23.3134449714195,0,16.6418062142744)
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
      kernel.i <- function(i, x, x2) {
        ki <- rbfdot(sigma=1/(2*l[i]^2))
        return(kernelMatrix(ki, as.matrix(x[,i]), as.matrix(x2[,i])))
      }
      # Newton-Girard formula
      s <- lapply(seq_along(l), function(k) {
        Reduce('+', lapply(seq_along(l), function(i) {
          kernel.i(i,x,x2)^k
          }))
        })
      additive.kernel <- list()
      additive.kernel[[1]] <- matrix(rep(1,length(s[[1]])), nrow=nrow(s[[1]]))
      n <- 2
      for(n in seq(2,length(l)+1)) {
        additive.kernel[[n]] <- Reduce('+', lapply(seq(2,n), function(k) (-1)^(k-2)*additive.kernel[[n-k+1]]*s[[k-1]] / (n-1)))
      }
      return(Reduce('+', lapply(seq(1,length(sigma2)), function(i) sigma2[i] * additive.kernel[[i+1]])))
    }
    return(k)
  } else if (type == 'oak.gaussian') {
    k <- function(x,x2) {
      kernel.i <- function(x, x2, i) {
        # kerneld <- function(x1,x2) {
        #   -(2*crossprod(x1,x2) - crossprod(x1) - crossprod(x2))
        # }
        if (i == 0)
          return(matrix(rep(1, nrow(x)*nrow(x2)), nrow=nrow(x)))
        m1 <- as.matrix(x[,i])
        m2 <- as.matrix(x2[,i])
        
        ki <- rbfdot(sigma=1/(2*l[i]^2))
        ki <- kernelMatrix(ki, m1, m2)       
        # exp.numerator.i <- kernelMatrix(kerneld, m1-input.means[i], m2-input.means[i])
        exp.numerator.i <- log(kernelMatrix(rbfdot(1), m1-input.means[i], m2-input.means[i]))
        ki <- ki - 
          l[i]*sqrt(l[i]^2+2*input.vars[i]^2)/(l[i]^2+input.vars[i]^2) *
          exp(-exp.numerator.i/(2*(l[i]^2+input.vars[i]^2)))
        return(ki)
        # ki <- rbfdot(sigma=1/(2*l[i]^2))
        # ki <- kernelMatrix(ki, as.matrix(x[,i]), as.matrix(x2[,i]))
        # exp.numerator.i <- kernelMatrix(kerneld, m1-input.means[i], m2-input.means[i])
      }
      
      # m1 <- as.matrix(x[,i])
      # m2 <- as.matrix(x2[,i])
      m1c <- t(apply(x, 1, function(row) row-input.means))
      m2c <- t(apply(x2, 1, function(row) row-input.means))
      # Newton-Girard formula
      s <- lapply(seq(1,length(sigma2)), function(k) {
        Reduce('+', lapply(seq(1,length(sigma2)), function(i) {
          kernel.i(x,x2,i-1)^k
        }))
      })
      additive.kernel <- list()
      additive.kernel[[1]] <- matrix(rep(1,length(s[[1]])), nrow=nrow(s[[1]]))
      n <- 2
      for(n in seq(2,length(sigma2)+1)) {
        additive.kernel[[n]] <- 
          Reduce('+', 
                 lapply(seq(2,n), 
                        function(k) {
                          (-1)^(k-2)*additive.kernel[[n-k+1]]*s[[k-1]] / (n-1)
                           }
                        )
                 )
      }
      return(Reduce('+', lapply(seq(1,length(sigma2)), function(i) sigma2[i] * additive.kernel[[i+1]])))
    #   m1 <- as.matrix(x[,1])
    #   m2 <- as.matrix(x2[,1])
    #   
    #   kernel1 <- rbfdot(sigma=1/(2*l[1]^2))        
    #   kerneld <- function(x1,x2) {
    #     -(2*crossprod(x1,x2) - crossprod(x1) - crossprod(x2))
    #   }       
    #   
    #   k1 <- kernelMatrix(kernel1, m1, m2)       
    #   exp.numerator1 <- kernelMatrix(kerneld, m1-input.means[1], m2-input.means[1])
    #   #exp.numerator1 <- (x[,1]-input.means[1])^2 + (x2[,1]-input.means[1])^2
    #   k1 <- k1 - 
    #     l[1]*sqrt(l[1]^2+2*input.vars[1]^2)/(l[1]^2+input.vars[1]^2) *
    #     exp(-exp.numerator1/(2*(l[1]^2+input.vars[1]^2)))
    #   
    #   
    #   kernel2 <- rbfdot(sigma=1/(2*l[2]^2))
    #   k2 <- kernelMatrix(kernel2, as.matrix(x[,2]), as.matrix(x2[,2]))
    #   exp.numerator2 <- kernelMatrix(kerneld, m1-input.means[2], m2-input.means[2])
    #   #exp.numerator2 <- (x[,2]-input.means[2])^2 + (x2[,2]-input.means[2])^2
    #   k2 <- k2 - 
    #     l[2]*sqrt(l[2]^2+2*input.vars[2]^2)/(l[2]^2+input.vars[2]^2) *
    #     exp(-exp.numerator2/(2*(l[2]^2+input.vars[2]^2)))
    #   return(sigma2[1] + sigma2[2]*(k1 + k2) + sigma2[3]*k1*k2)
    # }
    # return(k)
    }
    return(k)
  }
}

calculate.regression.model <- function(X, y, k, f.noise) {
  if (nrow(X) == 0) {
    K <- numeric(0)
    Ki <- K
  } else {
    K <- k(X,X)
    if (any(eigen(K)$values < 0)) {
      # Fix negative eigenvalues
      eig <- eigen(K)
      eig$values[eig$values < 1e-10] <- 1e-10
      K <- t(eig$vectors) %*% diag(eig$values) %*% eig$vectors
    }
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
  
  return(list(mean=fs, cov=sigma, best.x=best.x, best.y=best.y, K=K, Ki=Ki))
}

calculate.loglik <- function(gp.model, kernel.type, observed.x, observed.y, f.noise) {
  # if (kernel.type == 'se') {
    Lu <- matrix(chol(gp.model$K), nrow=nrow(gp.model$K))
    Ll <- t(Lu)
    S1 <- forwardsolve(Ll, observed.y)
    S2 <- backsolve(Lu, S1)
    
    log.lik <- -sum(log(diag(Ll))) - .5 * observed.y %*% S2 - 0.5 * nrow(observed.x) + log(2*pi)
  # } else {
  #   detm <- det(gp.model$K + f.noise*diag(nrow(observed.x)))
  #   browser()
  #   if (detm < -1e10) stop('Negative determinant')
  #   if (detm < 0) detm <- 0
  #   log.lik <- -log(detm) - 
  #     t(observed.y) %*% gp.model$Ki  %*% observed.y
  # }
  # if (log.lik == Inf) {browser(); log.lik = -1e10}
  return(log.lik)
}

calculate.test.mse <- function(gp.model, kernel.type, observed.x, observed.y, f.noise) {
  if (fixed.test) {
    test.data <- fixed.mse.test.data
  } else {
    test.data <- lapply(initial.guess, function(xi) runif(n.points.test, xi*.5, xi*1.5))
  }
  names(test.data) <- paste0('x', seq_along(test.data))
  x.test <- data.frame(test.data)
  
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

# Define hyperparameter optimization

calculate.params.ll <- function(pars, kernel.type, i, all.pars) {
  print(pars)
  if (i == 0) {
    all.pars[11*n.matrices+1] <- pars[1]
    f.noise <- pars[2]
  } else {
    all.pars[c(i,11*n.matrices+1+i)] <- pars[1:2]
    f.noise <- pars[3]
  }
  
  if (kernel.type == 'se') {
    l <- all.pars[1]
    sigma2 <- all.pars[2]
  } else if (kernel.type == 'ak') {
    l <- all.pars[1:(n.matrices*11)]
    sigma2 <- all.pars[(n.matrices*11+1):(length(pars))]
  } else if (kernel.type == 'oak.gaussian') {
    if (optimize.only.sigmas) {
      l <- l.fixed.pars
      sigma2 <- all.pars
    } else {
      l <- all.pars[1:(n.matrices*11)]
      sigma2 <- all.pars[(n.matrices*11+1):(length(pars))]
    }
  }
  
  k <- build.k(kernel.type, l, sigma2)
  
  start_time <- Sys.time()
  perfs <- foreach(i=seq(n.iters.per.paramset), .combine = 'c') %do% {
    gp.model <- NULL
    while (is.null(gp.model)) {
      if (fixed.training) {
        train.data <- fixed.training.data
      } else {
        train.data <- lapply(initial.guess, function(xi) runif(n.points, xi*.5, xi*1.5))
      }
    
      names(train.data) <- paste0('x', seq_along(train.data))
      observed.x <- data.frame(train.data)
      
      observed.y <- apply(observed.x, 1, f)
      gp.model <- tryCatch({calculate.regression.model(observed.x, observed.y, k, f.noise)},
                           error=function(e) {
                             if (grepl('system is computationally singular', e$message) && !fixed.training) {
                               cat('Matrix is computationally singular, trying new matrices...\n')
                               return(NULL)
                             }
                             else stop(e)
                           })
    }
    
    perf <- calculate.performance(gp.model, kernel.type, observed.x, observed.y, f.noise)
    return(perf)
  }
  elapsed_time <- Sys.time() - start_time
  
  mean.perf <- mean(perfs)
  
  if (performance.measure == 'loglikelihood') perf.name <- 'll'
  else if (performance.measure == 'test.mse') perf.name <- 'mse'
  if  (length(perfs) > 1) {
    perf.sd <- 2*sd(perfs)/sqrt(length(perfs))
  } else {
    perf.sd <- 'NA'
  }
  if (optimize.only.sigmas) {
    message(paste0('sigma2=', paste0(sigma2, collapse=','),
                   ' (', perf.name, '=', mean.perf, ' +- ', perf.sd, '), f.noise=', f.noise, ', time: ',
                   elapsed_time), appendLF=TRUE )
  } else {
    message(paste0('l=',paste0(l, collapse=','),
                   ', sigma2=', paste0(sigma2, collapse=','),
                   ' (', perf.name, '=', mean.perf, ' +- ', perf.sd, '), f.noise=', f.noise, ', time: ',
                   elapsed_time), appendLF=TRUE )
  }
  return(mean.perf)
}


set.seed(seed)
kernel.type <- 'oak.gaussian'
optim.params <- get.init.params(kernel.type)

try(stopCluster(cl), silent=TRUE)

cl <- makeCluster(n.cores, outfile='')
clusterExport(cl, ls(-1))
clusterEvalQ(cl, {
  library(kernlab)
  library(jsonlite)
  library(foreach)
})
registerDoParallel(cl)
pars <- optim.params$initial.pars
f.noise <- 1e-1
for(k in seq(1,2)) {
  for(l in seq(0,11*n.matrices)) {
    if (l == 0) {
      indices <- 11*n.matrices+1
    } else {
      indices <- c(l, 11*n.matrices+l+1)
    }
    i.pars <- c(pars[indices], f.noise)
    optim.result <- optim(par=i.pars,
                          # method='SAN',
                          method='L-BFGS-B',
                          fn=calculate.params.ll,
                          lower=c(optim.params$lower.bounds[indices], 1e-3),
                          upper=c(optim.params$upper.bounds[indices], 5),
                          control=list(
                            pgtol=0,
                            fnscale=fnscale,
                            parscale=rep(100,length(indices)+1),
                            temp=100,
                            tmax=100,
                            maxit=100,
                            npart=1000
                          ),
                          kernel.type=kernel.type,
                          i=l,
                          all.pars=pars
    )
    if (l == 0) {
      pars[11*n.matrices+1] <- optim.result$par[1]
      f.noise <- optim.result$par[2]
    } else {
      pars[c(l,11*n.matrices+1+l)] <- optim.result$par[1:2]
      f.noise <- optim.result$par[3]
    }
  }
}

stopCluster(cl)
cat('\nOptimization results:', sep='\n')
cat(paste0(' Params=', paste0(optim.result$par, collapse=',')), sep='\n')
cat(paste0(' Performance=', optim.result$value), sep='\n')
if (optimize.only.sigmas) {
  cat(paste0(' Variance: ', 
             paste0(formatC(optim.result$par*100/sum(optim.result$par), 
                            format='f', digits=2), '%', collapse = ', '), 
             sep='\n'))
  
} else {
  cat(paste0(' Variance: ', 
             paste0(formatC(optim.result$par[(n.matrices+1):length(optim.result$par)]*100/sum(optim.result$par[(n.matrices+1):length(optim.result$par)]), 
                            format='f', digits=2), '%', collapse = ', '), 
             sep='\n'))
}