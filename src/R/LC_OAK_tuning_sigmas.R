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
library(pbapply)

# Objective function
N_MATRICES <- 2
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
  se <- sapply(1:3, function(i) ((result[[i]] - expectation[[i]])^2)/expectation[[i]])
  return(sum(unlist(se) * c(.45, .45, .1)))
}
f.noise <- 1e-10

# GP prior mean
prior.mu <- function(x) 0

# Model parameters
n.matrices <- 2
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

# Plot values
plot.gps <- FALSE
x.limits <- c(0, 10)
y.limits <- c(-3, 3)

# OAK parameters
input.means <- initial.guess
input.sds <- sapply(initial.guess, function(x) (min(x,1-x) / 2))

# Other values
seed <- 945987
n.cores <- 12
n.iters.per.paramset <- 30

n.points <- 200
n.points.test <- 500
fixed.training <- TRUE
fixed.test <- FALSE
optimize.only.sigmas <- TRUE
l.fixed.pars <- c(1.425253e-11,1.128356e-08,6.446930e-07,3.780784e-05,4.487612e-07,1.176684e-10,3.072113e-07,3.399477e-07,1.829153e-11,5.486929e-08,4.435985e-12,7.842822e-10,3.357831e-09,3.797246e-07,1.114584e-05,6.058154e-06,3.656973e-12,3.994255e-06,1.218245e-07,2.164872e-10,2.283868e-07,4.919127e-12)
# Increased lengthscales to avoid problems when inverting K (small condition number)
# l.fixed.pars <- c(1e-6, 1e-4, 1e-1, 1e-2, 1e-1, 1e-6, 1e-1, 1e-1, 1e-5, 1e-1, 1e-7) 

set.seed(2342)
# fixed.training.data <- lapply(seq_along(initial.guess), function(i) rnorm(n.points, input.means[i], input.sds[i]))
fixed.training.data <- lapply(seq_along(initial.guess), function(i) runif(n.points, 
                                                                          input.means[i]-input.sds[i]*sqrt(12)/2, 
                                                                          input.means[i]+input.sds[i]*sqrt(12)/2))
set.seed(123)
# fixed.mse.test.data <- lapply(seq_along(initial.guess), function(i) rnorm(n.points.test, input.means[i], input.sds[i]))
fixed.mse.test.data <- lapply(seq_along(initial.guess), function(i) runif(n.points.test, 
                                                                          input.means[i]-input.sds[i]*sqrt(12)/2, 
                                                                          input.means[i]+input.sds[i]*sqrt(12)/2))

# Kernel types: se, ak, ak1, ak2, oak.gaussian
#kernel.type <- 'oak.gaussian'
color.breaks <- seq(-2,2,.25)

# Performance measures: loglikelihood, test.mse
performance.measure <- 'loglikelihood'

# Options
# options(matprod='internal')
options(matprod='default')
pboptions(type='none')
# pboptions(type='timer')

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
      initial.pars <- rep(0, n.matrices*11+1)
      initial.pars[1] <- 1000
      initial.pars[2] <- 42.7799728094933
      # initial.pars[3] <- 0.0890540569394103
      lower.bounds <- rep(0, n.matrices*11+1)
      upper.bounds <- c(10000, rep(100, n.matrices*11))
      # initial.pars <- c(50, 0.1)  # Optimize only for sigmas 0 and 1
      # initial.pars <- c(0, 2.29, 0)  # Optimize only for sigmas 0, 1 and 11
      # lower.bounds <- rep(0, 3)
      # upper.bounds <- rep(100, 3)
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
      initial.pars <- c(1e-04,1e-04,5,5,1e-04,5,5,5,5,1e-04,1e-04,10,7.08470680330204e-25,10,8.25016587939386e-25,10,0,10,10,1.84139574526754e-25,10,4.23074278969488e-25,1.77564280296908e-25)
      lower.bounds <- c(rep(.00001, n.matrices*11), rep(0, (n.matrices*11 + 1)))
      upper.bounds <- c(rep(100, n.matrices*11), rep(1000, (n.matrices*11 + 1)))
    }
    
    # initial.pars <- c(2.33134449714195,1e-04,2.33134449714195,2.33134449714195,2.33134449714195,0.667197159326941,2.33134449714195,0.667197159326941,0.667197159326941,2.33134449714195,2.33134449714195,0.667163875714512,16.6418062142744,6.67163875714512,0,0,0,0,6.67163875714512,23.3134449714195,23.3134449714195,0,16.6418062142744)
  }
  return(list(
    initial.pars=initial.pars,
    lower.bounds=lower.bounds,
    upper.bounds=upper.bounds
  ))
}

build.k <- function(type, l, sigma2, gradient=FALSE) {
  if (type == 'se') {
    k <- function(x,x2) {
      kernel <- rbfdot(sigma=1/(2*l^2))
      k <- kernelMatrix(kernel, as.matrix(x), as.matrix(x2))
      return(sigma2*k)
    }
    return(k)
  } else if (type == 'ak') {
    k <- function(x,x2) {
      kernel.i <- function(x, x2, i) {
        base.kernel <- rbfdot(sigma=1/(2*l[i]^2))
        return(kernelMatrix(base.kernel, as.matrix(x[,i]), as.matrix(x2[,i])))
      }
      # Newton-Girard formula
      kernel.list <- lapply(seq(1,length(sigma2)), function(i) {
        kernel.i(x,x2,i)
      })
      s <- lapply(seq(1,length(sigma2)), function(k) {
        Reduce('+', lapply(seq(1,length(sigma2)), function(i) {
          kernel.list[[i]]^k
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
        if (i == 0)
          return(matrix(rep(1, nrow(x)*nrow(x2)), nrow=nrow(x)))
        m1 <- as.matrix(x[,i])
        m2 <- as.matrix(x2[,i])
        
        ki <- rbfdot(sigma=1/(2*l[i]^2))
        ki <- kernelMatrix(ki, m1, m2)       
        exp.numerator.i <- log(kernelMatrix(rbfdot(1), m1-input.means[i], m2-input.means[i]))
        ki <- ki - 
          l[i]*sqrt(l[i]^2+2*input.sds[i]^2)/(l[i]^2+input.sds[i]^2) *
          exp(-exp.numerator.i/(2*(l[i]^2+input.sds[i]^2)))
        return(ki)
      }
      
      m1c <- t(apply(x, 1, function(row) row-input.means))
      m2c <- t(apply(x2, 1, function(row) row-input.means))
      
      # Newton-Girard formula
      kernel.list <- lapply(seq(1,length(sigma2)), function(i) {
        kernel.i(x,x2,i-1)
      })
      # if (is.null(diff)) {
        s <- lapply(seq(1,length(sigma2)), function(k) {
          Reduce('+', lapply(seq(1,length(sigma2)), function(i) {
            kernel.list[[i]]^k
          }))
        })
      # } else {
        # s <- lapply(seq(1,length(sigma2)), function(k) {
        #   Reduce('+', lapply(seq(1,length(sigma2)), function(i) {
        #     if (i == diff) 0  # Removing component to calculate derivative
        #     else kernel.list[[i]]^k
        #   }))
        # })
      # }
      
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
      if (gradient) {
        return(additive.kernel[2:(length(sigma2)+1)])
      } else {
        return(Reduce('+', lapply(seq(1,length(sigma2)), function(i) sigma2[i] * additive.kernel[[i]])))
      }
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
      Kmat <- matrix(unlist(K),nrow=nrow(K))
      Ki <- NULL
      jitter <- f.noise
      while (is.null(Ki) && jitter < 1) {
        try(Ki <- solve(Kmat + jitter*diag(nrow(K))), silent=TRUE)
        jitter <- jitter * 10
      }
      if (is.null(Ki)) stop('Singular matrix, numerical instability problems')
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

calculate.regression.model.gradients <- function(X, k) {
  if (nrow(X) == 0) {
    K <- numeric(0)
    Ki <- K
  } else {
    K <- k(X,X)
  }
  
  return(lapply(K, function(KK) {list(K=KK)}))
}

calculate.loglik <- function(gp.model, kernel.type, observed.x, observed.y) {
  Lu <- NULL
  jitter <- f.noise
  while (is.null(Lu) && jitter < 1) {
    try(Lu <- matrix(chol(gp.model$K + jitter*diag(nrow(gp.model$K))), nrow=nrow(gp.model$K)), silent=TRUE)
    jitter <- jitter * 10
  }
  
  Ll <- t(Lu)
  S1 <- forwardsolve(Ll, observed.y)
  S2 <- backsolve(Lu, S1)
  
  log.lik <- -sum(log(diag(Ll))) - .5 * observed.y %*% S2 - 0.5 * nrow(observed.x) * log(2*pi)
  return(log.lik)
}

calculate.test.mse <- function(gp.model, kernel.type, observed.x, observed.y) {
  if (fixed.test) {
    test.data <- fixed.mse.test.data
  } else {
    test.data <- lapply(seq_along(initial.guess), function(i) runif(n.points.test,
                                                                    input.means[i]-input.sds[i]*sqrt(12)/2, 
                                                                    input.means[i]+input.sds[i]*sqrt(12)/2))
    # test.data <- lapply(seq_along(initial.guess), function(i) {
    #   x <- rnorm(n.points.test, input.means[i], input.sds[i])
    #   oob <- x < 0 | x > 1
    #   while (sum(oob) > 0) {
    #     # message(sum(oob), ' points out of bounds, resampling...')
    #     x <- c(x[!oob], rnorm(sum(oob), input.means[i], input.sds[i]))
    #     oob <- x < 0 | x > 1
    #   }
    #   return(x)
    #   })
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

calculate.params.ll <- function(pars, kernel.type, gradient=FALSE) {
  if (kernel.type == 'se') {
    l <- pars[1]
    sigma2 <- pars[2]
  } else if (kernel.type == 'ak') {
    l <- pars[1:(n.matrices*11)]
    sigma2 <- pars[(n.matrices*11+1):(length(pars))]
  } else if (kernel.type == 'oak.gaussian') {
    if (optimize.only.sigmas) {
      l <- l.fixed.pars
      sigma2 <- c(pars, rep(0, 11*n.matrices+1-length(pars)))
      # if (length(pars) == 2) { # Optimize for sigmas 0 and 1, 0 for the rest
      #   sigma2 <- c(pars[1], pars[2], rep(0, 10))
      # } else if (length(pars) == 3) { # Optimize for sigmas 0, 1 and 11, 0 for the rest
      #   sigma2 <- c(pars[1], pars[2], rep(0, 9), pars[3])
      # } else {
      #   sigma2 <- pars
      # }
    } else {
      l <- pars[1:(n.matrices*11)]
      sigma2 <- pars[(n.matrices*11+1):(length(pars))]
    }
  }
  
  k <- build.k(kernel.type, l, sigma2, gradient=gradient)
  
  start_time <- Sys.time()
  
  train.data <- fixed.training.data
  names(train.data) <- paste0('x', seq_along(train.data))
  observed.x <- data.frame(train.data)
  
  observed.y <- apply(observed.x, 1, f)
  if (!gradient) {
    gp.model <- calculate.regression.model(observed.x, observed.y, k)
    perfs <- calculate.performance(gp.model, kernel.type, observed.x, observed.y)
    
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
      message(paste0('sigma2=', paste0(sigma2, collapse=',')), appendLF=TRUE )
      message(paste0(' ', perf.name, '=', mean.perf, ' +- ', perf.sd, ', time: ',
                     elapsed_time), appendLF=TRUE )
      # message(mean.perf, appendLF=TRUE)
    } else {
      message(paste0('l=',paste0(l, collapse=','),
                     ', sigma2=', paste0(sigma2, collapse=','),
                     ' (', perf.name, '=', mean.perf, ' +- ', perf.sd, '), time: ',
                     elapsed_time), appendLF=TRUE )
    }
    return(mean.perf)
  } else {
    gp.models <- calculate.regression.model.gradients(observed.x, k)
    perfs <- sapply(gp.models, function(m) {
      calculate.performance(m, kernel.type, observed.x, observed.y)
    })
    
    return(perfs)
  }
}


set.seed(seed)
kernel.type <- 'oak.gaussian'
optim.params <- get.init.params(kernel.type)

try(stopCluster(cl), silent=TRUE)

# cl <- makeForkCluster(n.cores, outfile='')
# clusterExport(cl, ls(-1))
# clusterEvalQ(cl, {
#   library(kernlab)
#   library(jsonlite)
#   library(foreach)
# })
# registerDoParallel(cl)

gradient <- function(sigmas, kernel.type) {
  gr <- calculate.params.ll(sigmas, kernel.type, gradient=TRUE)
  print(gr)
  return(gr)
}

# Only optimize sigma_0, sigma_1 and sigma_2
optim.params <- lapply(optim.params, function(l) l[1:2])

optim.result <- GenSA::GenSA(par=optim.params$initial.pars,
                      fn=function(p, kernel.type) -calculate.params.ll(p,kernel.type),
                      lower=optim.params$lower.bounds,
                      upper=optim.params$upper.bounds,
                      control=list(
                        maxit=1000
                      ),
                      # parallel=list(
                      #   # cl=cl,
                      #   loginfo=TRUE
                      # ),
                      kernel.type=kernel.type
                )
# stopCluster(cl)
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
             paste0(formatC(optim.result$par[(n.matrices*11+1):length(optim.result$par)]*100/sum(optim.result$par[(n.matrices*11+1):length(optim.result$par)]), 
                            format='f', digits=2), '%', collapse = ', '), 
             sep='\n'))
}