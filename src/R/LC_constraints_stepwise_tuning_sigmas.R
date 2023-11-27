library(MASS)
library(GenSA)
library(DEoptim)
library(ppso)
library(pso)
library(optimParallel)
library(ggplot2)
library(cowplot)
library(mvtnorm)
library(kernlab)

source('../../models/lung/calibration_wrapper.R')

SEED <- 4
INITIAL.OBSERVATIONS <- 20
N.ITERATIONS <- 50
CALIBRATION.RANGE <- 5
N.CONSTRAINTS <- 1
STARTING_MATRIX <- 1
MAX.SIMULATION.MATRICES <- 1
N.TUNING.DATASET <- 50
DELAY <- 0
PLOT.ITERATION.PLOTS <- F

TARGET <- list(
  incidence=c(1.9, 9.0, 20.9, 39.7, 57.9, 68.8, 71.4, 70.4, 69.9),
  lc.mortality=c(0.29, 5.0, 13.4, 26.6, 42.5, 51.1, 52.0, 52.3, 53.9),
  other.mortality=c(39.8893, 64.0476, 114.6431, 188.9474, 289.2546 ,417.0061, 604.7883, 996.8391, 1871.6366)
)

TARGET.POOLED <- 0.45 * TARGET$incidence + 0.45 * TARGET$lc.mortality + 0.1 * TARGET$other.mortality

# Model parameters
# Original initial guess
# initial.guess <- c(0.0000014899094538366, 0.00005867, 0.0373025655099923, 
#                    0.45001903545473, 0.0310692140027966, 2.06599720339873e-06, 
#                    0.083259360316924, 0.0310687721751887, 2.50782481130141e-06, 
#                    0.031069806, 1.47440016369862e-06,
#                    
#                    1.04877e-05, 0.00009628, 0.014591745, 0.481776189, 
#                    0.031069873, 1.40669e-06, 0.050026676, 0.031069146, 
#                    2.13361e-06, 0.031070341, 9.38951e-07,
#                    
#                    0.00001850743, 0.00018182, 0.009078452, 0.445602151, 
#                    0.031940262, 1.36813e-06, 0.040413788, 0.031940366, 
#                    1.2638e-06, 0.031940406, 1.22435e-06,
#                    
#                    3.37959e-05, 0.00033198, 0.216982823, 0.745686098, 
#                    0.03193267, 8.96007e-06, 0.279118741, 0.031934889, 
#                    6.74088e-06, 0.031930383, 1.12474e-05,
#                    
#                    0.000047266, 0.00054161, 0.587748693, 0.367077318, 
#                    0.022454858, 0.012333952, 0.938189625, 0.025488122, 
#                    0.009300688, 0.030911619, 0.003877191,
#                    
#                    0.000057056, 0.00082374, 0.014863212, 0.94528741, 
#                    0.02701171,0.0077771, 0.945729932, 0.033553455, 
#                    0.001235355, 0.031429049, 0.003359761,
#                    
#                    0.00029203, 0.00124249, 0.57293827, 0.071391822, 
#                    0.040115762, 0.000770938, 0.922967658, 0.004939897, 
#                    0.035946803, 0.031592197, 0.009294503,
#                    
#                    0.00005383, 0.00190251, 0.224558597, 0.349067177, 
#                    0.040817026, 6.96743e-05, 0.071749361, 0.001859725, 
#                    0.039026975, 0.037767242, 0.003119458,
#                    
#                    0.000058942, 0.00330943, 0.009683304, 0.414010634, 
#                    0.022973067, 0.030664353, 0.60868601, 0.006745365, 
#                    0.046892055, 0.067318463, 0.004318957)

# Modified original guess (so mortality: p[11*i+5]) increases each age group
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
                   0.03195267, 8.96007e-06, 0.279118741, 0.031934889, 
                   6.74088e-06, 0.031930383, 1.12474e-05,
                   
                   0.000047266, 0.00054161, 0.587748693, 0.367077318, 
                   0.0346737, 0.012333952, 0.938189625, 0.025488122, 
                   0.009300688, 0.030911619, 0.003877191,
                   
                   0.000057056, 0.00082374, 0.014863212, 0.94528741, 
                   0.03739473,0.0077771, 0.945729932, 0.033553455, 
                   0.001235355, 0.031429049, 0.003359761,
                   
                   0.00029203, 0.00124249, 0.57293827, 0.071391822, 
                   0.040115762, 0.000770938, 0.922967658, 0.004939897, 
                   0.035946803, 0.031592197, 0.009294503,
                   
                   0.00005383, 0.00190251, 0.224558597, 0.349067177, 
                   0.040817026, 6.96743e-05, 0.071749361, 0.001859725, 
                   0.039026975, 0.037767242, 0.003119458,
                   
                   0.000058942, 0.00330943, 0.009683304, 0.414010634, 
                   0.04151829, 0.030664353, 0.60868601, 0.006745365, 
                   0.046892055, 0.067318463, 0.004318957)
initial.guess <- initial.guess[1:(11*MAX.SIMULATION.MATRICES)]


# Constraint (constraint(x) < lambda)
make.constraint.func <- function(i, fixed.params) {
  if (i == 1) {
    cnst <- function(x) return(-1)
  } else {
    cnst <- function(x) {
      x <- c(fixed.params, x)
      mort.i <- x[(i-2)*11+5]
      mort.i2 <- x[(i-1)*11+5]
      return(mort.i - mort.i2)
    }
  }
  return(cnst)
}

# OAK parameters
input.means <- initial.guess
input.sds <- sapply(initial.guess, function(x) (min(x,1-x) / 2))
max.oak.sigma <- 1  # Truncate OAK, reject higher orders of interaction

# kernel.type <- 'se'
# l <- .065172
# sigma2 <- 0.0002154
# l.c <- 336.364
# sigma2.c <- 8016.67

### Kernel hyperparameters
kernel.type <- 'se'
l <- .065172
sigma2 <- 0.0002154
# kernel.type <- 'oak.gaussian'
# l <- c(1.425253e-11,1.128356e-08,6.446930e-07,3.780784e-05,4.487612e-07,1.176684e-10,3.072113e-07,3.399477e-07,1.829153e-11,5.486929e-08,4.435985e-12)
# sigma2 <- c(1585.39465361646,42.7746208718925,rep(0, 1*11-2))

### Kernel hyperparameters (constraints)
kernel.type.c <- 'se'
l.c <- .65172
sigma2.c <- 0.0002154
# kernel.type.c <- 'oak.gaussian'
# l.c <- c(1.425253e-11,1.128356e-08,6.446930e-07,3.780784e-05,4.487612e-07,1.176684e-10,3.072113e-07,3.399477e-07,1.829153e-11,5.486929e-08,4.435985e-12)
# l.c <- rep(1e-1, 11)
# sigma2.c <- c(1585.39465361646,42.7746208718925,rep(0, 1*11-2))

build.k <- function(type, l, sigma2) {
  if (type == 'se') {
    k <- function(x,x2) {
      kernel <- rbfdot(sigma=1/(2*l[1]^2))
      k <- kernelMatrix(kernel, as.matrix(x), as.matrix(x2))
      return(sigma2[1]*k)
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
      s <- lapply(seq(1,max.oak.sigma), function(k) {
        Reduce('+', lapply(seq(1,length(sigma2)), function(i) {
          kernel.list[[i]]^k
        }))
      })
      
      additive.kernel <- list()
      additive.kernel[[1]] <- matrix(rep(1,length(s[[1]])), nrow=nrow(s[[1]]))
      n <- 2
      for(n in seq(2,max.oak.sigma+1)) {
        additive.kernel[[n]] <- 
          Reduce('+', 
                 lapply(seq(2,n), 
                        function(k) {
                          (-1)^(k-2)*additive.kernel[[n-k+1]]*s[[k-1]] / (n-1)
                        }
                 )
          )
      }
      return(Reduce('+', lapply(seq(1,max.oak.sigma+1), function(i) sigma2[i] * additive.kernel[[i]])))
    }
    return(k)
  }
}

calculate.lengthscale.ll <- function(par, i, kernel.type, train.data, func) {
  
  build.k.1 <- function(l, i) {
    k <- function(x,x2) {
      kernel <- rbfdot(sigma=1/(2*l^2))
      k <- kernelMatrix(kernel, as.matrix(x[,i]), as.matrix(x2[,i]))
      return(k)
    }
    return(k)
  }
  
  k <- build.k.1(par, i)
  
  start_time <- Sys.time()
  
  names(train.data) <- paste0('x', seq_along(train.data))
  observed.x <- data.frame(train.data)
  
  observed.y <- apply(observed.x, 1, func)
  gp.model <- tryCatch({
    calculate.regression.model(k, k, observed.x, observed.y, observed.y, function(x) -1, c())
    # k, k.c, X, y, cx, constraint.func, fixed.params
  },
  error=function(e) {
    if (grepl('system is computationally singular', e$message) && !fixed.training) {
      cat('Matrix is computationally singular, trying new matrices...\n')
      return(NULL)
    }
    else stop(e)
  })
  
  perfs <- calculate.loglik(gp.model, observed.x, observed.y)
  
  elapsed_time <- Sys.time() - start_time
  mean.perf <- mean(perfs)
  
  perf.name <- 'll'
  if  (length(perfs) > 1) {
    perf.sd <- 2*sd(perfs)/sqrt(length(perfs))
  } else {
    perf.sd <- 'NA'
  }
  # message(paste0('l=',par,
  #                ' (', perf.name, '=', mean.perf, ' +- ', perf.sd, '), time: ',
  #                elapsed_time), appendLF=TRUE )
  # cat(paste0(par, ': ', mean.perf))
  # cat('\n')
  return(list(mean=mean.perf, sd=sd(perfs)))
  # return(mean.perf)
}

calculate.loglik <- function(gp.model, observed.x, observed.y) {
  Lu <- NULL
  jitter <- f.noise
  while (is.null(Lu) && jitter < 1e10) {
    try(Lu <- matrix(chol(gp.model$K + jitter*diag(nrow(gp.model$K))), nrow=nrow(gp.model$K)), silent=TRUE)
    jitter <- jitter * 10
  }
  
  Ll <- t(Lu)
  S1 <- forwardsolve(Ll, observed.y)
  S2 <- backsolve(Lu, S1)
  
  log.lik <- -sum(log(diag(Ll))) - .5 * observed.y %*% S2 - 0.5 * nrow(observed.x) * log(2*pi)
  return(log.lik)
}

calculate.loglik.c <- function(gp.model, observed.x, observed.c) {
  Lu <- NULL
  jitter <- f.noise
  while (is.null(Lu) && jitter < 1e10) {
    try(Lu <- matrix(chol(gp.model$K.c + jitter*diag(nrow(gp.model$K.c))), nrow=nrow(gp.model$K.c)), silent=TRUE)
    jitter <- jitter * 10
  }
  
  Ll <- t(Lu)
  S1 <- forwardsolve(Ll, observed.c)
  S2 <- backsolve(Lu, S1)
  
  log.lik <- -sum(log(diag(Ll))) - .5 * observed.c %*% S2 - 0.5 * nrow(observed.x) * log(2*pi)
  return(log.lik)
}

# Objective function noise
f <- function(pars, fixed.params=c()) {
  n.matrices <- length(c(pars, fixed.params))/11
  result <- run.model(pars, fixed.params)
  expectation <- TARGET.POOLED[1:n.matrices]
  error <- sum((result-expectation)^2/expectation)
  return(error)
}

run.model <- function(pars, fixed.params=NULL) {
  n.matrices <- length(c(pars, fixed.params))/11
  calib.f <- make.calibration.func('','','', N_MATRICES=n.matrices)
  result <- fromJSON(calib.f(c(fixed.params, pars)))
  weighted.result <- 0.45 * result[[1]] + 0.45 * result[[2]] + 0.1 * result[[3]]
  return(weighted.result)
}

f.noise <- 1e-10

# GP prior means
prior.mu <- function(x) 0
prior.mu.c <- function(x) 0

# Optimization values
batch.size <- 1


# Function definitions

calculate.regression.model <- function(k, k.c, X, y, cx, constraint.func, fixed.params) {
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
      while (is.null(Ki) && jitter < 1e10) {
        try(Ki <- solve(Kmat + jitter*diag(nrow(K))), silent=TRUE)
        jitter <- jitter * 10
      }
      if (is.null(Ki)) {
        browser()
        stop('Singular matrix, numerical instability problems')
    }
  }
  
  d <- dim(K)[1]
  
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
  
  # Constraint model
  
  
  if (nrow(X) == 0) {
    K.c <- numeric(0)
    Ki.c <- K.c
  } else {
    K.c <- k.c(X,X)
    if (nrow(X) == 1) {
      Ki.c <- 1/(K.c + f.noise)
    } else {
      # ginv vs solve
      Kmat.c <- matrix(unlist(K.c),nrow=nrow(K.c))
      Ki.c <- NULL
      jitter <- f.noise
      while (is.null(Ki.c) && jitter < 1e10) {
        try(Ki.c <- solve(Kmat.c + jitter*diag(nrow(K.c))), silent=TRUE)
        jitter <- jitter * 10
      }
      if (is.null(Ki.c)) {
        browser()
        stop('Singular matrix, numerical instability problems')
      }
    }
  }
  }
  
  fs.c <- function(Xs) {
    if (nrow(X) == 0)
      return(prior.mu.c(Xs))
    
    # Ks.c <- outer(Xs, X, k.c)
    # mu.c <- apply(cx, 2, function(cx.i) {
    #   prior.mu.c(Xs) + Ks.c %*% Ki.c %*% (cx.i - prior.mu.c(X))
    # })
    # return(mu.c)
    
    Ks.c <- outer(1:nrow(Xs), 1:nrow(X), Vectorize(function(i,j) {
      k.c(Xs[i,], X[j,])
    }))
    return(prior.mu.c(Xs) + Ks.c %*% Ki.c %*% (cx - prior.mu.c(Xs)))
    
    # if (nrow(X) == 0)
    #   return(prior.mu(Xs))
    # 
    # # Ks <- outer(Xs, X, k)
    # Ks.c <- outer(1:nrow(Xs), 1:nrow(X), Vectorize(function(i,j) {
    #   k.c(Xs[i,], X[j,])
    # }))
    # return(prior.mu(Xs) + Ks.c %*% Ki %*% (y - prior.mu(Xs)))
  }
  
  sigma.c <- function(Xs) {
    Ks.c <- k.c(Xs, X)
    Kss.c <- k.c(Xs, Xs)
    S.c <- Kss.c - Ks.c %*% Ki.c %*% t(Ks.c)
    
    # if (Xs %in% observed.x && f.noise == 0)
    #   S.c <- matrix(rep(0,ncol(cx)^2), nrow=ncol(cx)) # Due to numerical instability values already observed haved a non-zero sigma, forcing 0 here
    
    # S.c <- diag(ncol(cx)) * c(apply(S.c, 1:2, function(x) max(x,0))) # Numerical instability, (small) negative values should be 0
    sapply(seq_along(diag(S.c)), function(i) S.c[i,i] <<- max(0, S.c[i,i])) # Numerical instability, (small) negative values should be 0
    
    return(S.c)
    
    
    # Kss <- k(Xs, Xs)
    # # Kss <- apply(Xs, 1, function(r) k(r,r))
    # 
    # if (nrow(X) == 0)
    #   return(Kss)
    # 
    # Ks <- k(Xs, X)
    # S <- Kss - Ks %*% Ki %*% t(Ks)
    # # if (Xs %in% observed.x && f.noise == 0)
    # #   S <- matrix(0) # Due to numerical instability values already observed haved a non-zero sigma, forcing 0 here
    # S <- apply(S, 1:2, function(x) max(x,0)) # Numerical instability, (small) negative values should be 0
    # return(S)
  }
  
  feasible.index <- apply(X, 1, function(x) all(constraint.func(x) < 0))
  
  if (d== 0 || sum(feasible.index) == 0) {
    best.x <- prior.mu(0)
    best.y <- -1e10
  } else {
    feasible.x <- X[feasible.index,]
    feasible.y <- y[feasible.index]
    best.x <- feasible.x[which.min(feasible.y),]
    best.y <- min(feasible.y)
  }
  
  # if (nrow(X) == 0) {
  #   best.x <- c(0,0)
  #   best.y <- prior.mu(c(0,0))
  # } else {
  #   best.x <- X[which.max(y),]
  #   best.y <- max(y)
  # }
  
  return(list(mean=fs, 
              cov=sigma, 
              mean.c=fs.c,
              cov.c=sigma.c,
              best.x=best.x, 
              best.y=best.y, 
              K=K,
              K.c=K.c,
              observed.x=X,
              observed.y=y,
              observed.c=cx))
}

choose.next.evaluation.points <- function(gp.model, initial.group.guess) {
  optim.func <- function(x) {
    acq.func(gp.model, x)
  }
  
  random.obs <- as.data.frame(lapply(initial.group.guess, function(x) {
    runif(1, max(0, x*(1-CALIBRATION.RANGE)), min(1, x*(1+CALIBRATION.RANGE)))
  }))
  colnames(random.obs) <- paste0('x', seq_along(initial.group.guess))
  random.obs <- rbind(random.obs, gp.model$observed.x)
  
  bests <- apply(random.obs, 1, function(obs) {
    best <- optim(obs,
                  optim.func,
                  method='L-BFGS-B',
                  lower=initial.group.guess * (1-CALIBRATION.RANGE),
                  upper=pmin(1, initial.group.guess * (1+CALIBRATION.RANGE)))
    return(best$value)
  })
  best <- optim(random.obs,
                optim.func,
                method='L-BFGS-B',
                lower=initial.group.guess * (1-CALIBRATION.RANGE),
                upper=pmin(1, initial.group.guess * (1+CALIBRATION.RANGE)))
  # cl <- makeForkCluster(6)
  # best <- optim_dds(optim.func, 
  #                           number_of_parameters = 11, 
  #                           # max_number_of_iterations = 20,
  #                           parameter_bounds = data.frame(
  #                             l=pmax(0, initial.group.guess * (1-CALIBRATION.RANGE)),
  #                             h=pmin(1, initial.group.guess * (1+CALIBRATION.RANGE))
  #                             )
  #                           )
  # best <- psoptim(unlist(random.obs, use.names=FALSE),
  #                 optim.func,
  #                 lower=pmax(0, initial.group.guess * (1-CALIBRATION.RANGE)),
  #                 upper=pmin(1, initial.group.guess * (1+CALIBRATION.RANGE)))
  # best <- optimParallel(unlist(random.obs, use.names=FALSE),
  #               optim.func,
  #               lower=pmax(0, initial.group.guess * (1-CALIBRATION.RANGE)),
  #               upper=pmin(1, initial.group.guess * (1+CALIBRATION.RANGE)),
  #               parallel=list(
  #                 cl=cl
  #               ),
  #               control=list(
  #               ))
  # best <- DEoptim(optim.func,
  #         lower=pmax(0, initial.group.guess * (1-CALIBRATION.RANGE)),
  #         upper=pmin(1, initial.group.guess * (1+CALIBRATION.RANGE)),
  #         control = DEoptim.control(
  #           cluster=cl,
  #           itermax=50
  #         )
  #         )
  # best <- best$optim$bestmem
  # stopCluster(cl)
  # names(best) <- paste0('x', seq_along(best))
  # return(best)
  # best <- GenSA(unlist(random.obs, use.names=FALSE),
  #               optim.func, 
  #               lower=initial.group.guess * (1-CALIBRATION.RANGE), 
  #               upper=pmin(1, initial.group.guess * (1+CALIBRATION.RANGE)))
  # names(best$par) <- paste0('x', seq_along(best$par))
  # return(best$par)
}

acq.func <- function(gp.model, x) {
  # print(x)
  cei <- acq.func.cei(gp.model, x)
  # print(cei)
  return(cei)
}
acq.func.ei <- function(gp.model, x) {
  x2 <- data.frame(t(x))
  mu <- gp.model$mean(x2)
  # if (mu != 0) browser()
  tryCatch({
    sigma <- sqrt(gp.model$cov(x2)[1,1])
    },
    warning=function(e) {
      browser()})
  best.y <- gp.model$best.y
  if (is.na(sigma)) browser()
  if (sigma > 0) {
    ei <- (mu-best.y)*pnorm((mu-best.y)/sigma) + sigma*dnorm((mu-best.y)/sigma)
  } else { # Initial value, no uncertainty
    ei <- max(mu-best.y,0)
  }
  if (is.na(ei)) browser()
  # print(x)
  # print(sum(x))
  # if (length(gp.model$K) > 0) browser()
  return(ei)
}
acq.func.pf <- function(gp.model, x) {
  x2 <- data.frame(t(x))
  means <- gp.model$mean.c(x2)
  sd <- sqrt(gp.model$cov.c(x2))
  # pf <- pnorm(c.lambda, mean=gp.model$mean.c(x2), sd=sqrt(gp.model$cov.c(x2)))
  pf <- sapply(seq_along(means), function(i) pnorm(0, mean=means[i], sd=sd))
  pf <- Reduce('*', pf)
  # return(suppressWarnings(pmvnorm(lower=rep(-Inf, length(c.lambda)), upper=c.lambda, mean=gp.model$mean.c(x), sigma=sqrt(gp.model$cov.c(x)))[1]))
  
  if (is.na(pf)) browser()
  return(pf)
}
acq.func.cei <- function(gp.model, x) {
  ei <- acq.func.ei(gp.model, x)
  pf <- acq.func.pf(gp.model, x)
  return(ei*pf)
}

plot.calibration <- function(gp.model=NULL, outcome=NULL, group=NULL, iteration=NULL, fixed.params=NULL) {
  if (!is.null(gp.model)) outcome <- run.model(gp.model$best.x, fixed.params=fixed.params)
  if (is.null(group)) {
    starting.matrix <- STARTING_MATRIX
    n.matrices <- MAX.SIMULATION.MATRICES
  } else {
    starting.matrix <- 1
    n.matrices <- group
  }
  
  initial.outcome <- run.model(initial.guess)[STARTING_MATRIX:group]
  
  if (is.null(iteration)) {
    title <- paste0('Calibration (age group ', group, ')')
  } else {
    title <- paste0('Iteration ', iteration, ' (age group ', group, ')')
  }
  
  x.labels <- starting.matrix:(starting.matrix+n.matrices-1)
  df.target.prev <- data.frame(x=x.labels, y=TARGET.POOLED[x.labels], type='Target')
  df <- rbind(df.target.prev, data.frame(x=x.labels, y=initial.outcome, type='Initial'))
  df <- rbind(df, data.frame(x=x.labels, y=outcome, type='Current'))
  df$type <- factor(df$type, levels=c('Target', 'Initial', 'Current'))
  plt <- ggplot(df, aes(x=x, y=y, color=type, linetype=type)) +
    geom_line(size=2) +
    geom_point(size=5) +
    # scale_x_continuous(breaks=x.labels, minor_breaks=0, labels=function(i) paste0(30+(i-1)*5, '-', 30+(i)*5-1)) +
    scale_linetype_manual(name='', limits=c('Target', 'Initial', 'Current'), breaks=c('Target', 'Initial', 'Current'), values=c(1,1,2)) +
    scale_color_manual(name='', limits=c('Target', 'Initial', 'Current'), breaks=c('Target', 'Initial', 'Current'), values=c('red', 'blue', '#00bb00')) +
    # ylim(0, .04) +
    xlab('Age group') +
    ylab('Weighted output') +
    ggtitle(title)
  print(plt)
}

# Start optimization

set.seed(SEED)

calibration.step <- function(group, initial.group.guess) {
  cat('Initializing BO observations...\n')
  if (group > 1) {
    fixed.params <- initial.group.guess[1:((group-1)*11)]
  } else {
    fixed.params <- numeric()
  }
  tunable.params <- initial.group.guess[((group-1)*11+1):(group*11)]
  
  observed.x <- as.data.frame(lapply(tunable.params, function(x) {
      runif(INITIAL.OBSERVATIONS, max(0,x*(1-CALIBRATION.RANGE)), min(1, x*(1+CALIBRATION.RANGE)))
  }))
  
  observed.x <- rbind(observed.x, tunable.params)
  initial.guess.outcome <- run.model(tunable.params, fixed.params)
  colnames(observed.x) <- paste0('x', seq_along(tunable.params))
  observed.y <- apply(observed.x, 1, f, fixed.params=fixed.params)
  
  constraint <- make.constraint.func(group, fixed.params)
  
  if (N.CONSTRAINTS == 1) {
    observed.c <- matrix(apply(observed.x, 1, constraint), ncol=1)
  } else {
    observed.c <- t(apply(observed.x, 1, constraint))
  }
  cat('Initial errors:\n')
  cat(paste0(observed.y, ' ', ifelse(apply(observed.c, 1, function(x) all(x < 0)), '', 'NOT VALID'), collapse='\n'))
  cat('\n')
  # observed.c <- matrix(nrow=0, ncol=length(c.lambda))
  
  k <- build.k(kernel.type, l, sigma2)
  k.c <- build.k(kernel.type.c, l.c, sigma2.c)
  
  cat(paste0('Starting optimization (group ', group, ')\n'))
  print(Sys.time())
  for(n in seq(N.ITERATIONS)) {
    start.time <- Sys.time()
    gp.model <- calculate.regression.model(k, k.c, observed.x, observed.y, observed.c, constraint, fixed.params)
    
    next.evaluation.point <- choose.next.evaluation.points(gp.model, tunable.params)
    
    evaluated.value <- f(next.evaluation.point, fixed.params=fixed.params)
    is.valid <- t(apply(t(next.evaluation.point), 1, constraint))
    
    observed.x <- rbind(observed.x, data.frame(t(next.evaluation.point)))
    observed.y <- c(observed.y, evaluated.value)
    observed.c <- rbind(observed.c, is.valid)
    
    end.time <- Sys.time()
    cat(paste0('Iteration ',n,': Error=', evaluated.value, ' [', formatC(difftime(end.time, start.time, units='secs')[[1]], format='d'), 's]'))
    trace.df <<- rbind(trace.df, 
                      data.frame(iter=n,
                                 group=group,
                                 error=evaluated.value, 
                                 time=difftime(end.time, start.time, units='secs')[[1]]))
    if (!all(is.valid < 0)) cat(' [NOT VALID]')
    cat('\n')
    
    current.outcome <- run.model(next.evaluation.point, fixed.params)
    if (PLOT.ITERATION.PLOTS)
      plot.calibration(outcome = current.outcome, fixed.params = fixed.params, group=group, iteration=n)
  }
  
  cat('Optimization done:\n')
  cat(paste0(' Best error (', min(trace.df$error), ') in ', sum(trace.df$time), 's\n'))
  
  # best.x.group <- gp.model$best.x[((group-1)*11+1):(group*11)]
  print(unlist(unname(gp.model$best.x)))
  print(gp.model$best.y)
  print(Sys.time())
  
  plot.calibration(gp.model, group=group, fixed.params=fixed.params)
  return(gp.model$best.x)
}



calculate.params.ll <- function(pars, kernel.type, gradient=FALSE) {
  n.matrices <- MAX.SIMULATION.MATRICES
  if (kernel.type == 'se') {
    l <- pars[1]
    sigma2 <- pars[2]
  } else if (kernel.type == 'ak') {
    l <- pars[1:(n.matrices*11)]
    sigma2 <- pars[(n.matrices*11+1):(length(pars))]
  } else if (kernel.type == 'oak.gaussian') {
    l <- ls
    sigma2 <- c(pars, rep(0, 11*n.matrices+1-length(pars)))
    # if (length(pars) == 2) { # Optimize for sigmas 0 and 1, 0 for the rest
    #   sigma2 <- c(pars[1], pars[2], rep(0, 10))
    # } else if (length(pars) == 3) { # Optimize for sigmas 0, 1 and 11, 0 for the rest
    #   sigma2 <- c(pars[1], pars[2], rep(0, 9), pars[3])
    # } else {
    #   sigma2 <- pars
    # }
  }
  
  k <- build.k(kernel.type, l, sigma2)
  
  start_time <- Sys.time()
  
  train.data <- fixed.training.data
  names(train.data) <- paste0('x', seq_along(train.data))
  observed.x <- data.frame(train.data)
  
  observed.y <- apply(observed.x, 1, f)
  if (!gradient) {
    gp.model <- calculate.regression.model(k, k, observed.x, observed.y, observed.y, function(x) -1, c())
    perfs <- calculate.loglik(gp.model, observed.x, observed.y)
    
    elapsed_time <- Sys.time() - start_time
    
    mean.perf <- mean(perfs)
    
    perf.name <- 'll'
    if  (length(perfs) > 1) {
      perf.sd <- 2*sd(perfs)/sqrt(length(perfs))
    } else {
      perf.sd <- 'NA'
    }
    message(paste0('sigma2=', paste0(sigma2, collapse=',')), appendLF=TRUE )
    message(paste0(' ', perf.name, '=', mean.perf, ' +- ', perf.sd, ', time: ',
                   elapsed_time), appendLF=TRUE )
    # message(mean.perf, appendLF=TRUE)
    return(mean.perf)
  } else {
    gp.models <- calculate.regression.model.gradients(observed.x, k)
    perfs <- sapply(gp.models, function(m) {
      calculate.loglik(m, observed.x, observed.y)
    })
    
    return(perfs)
  }
}


### Hyperparameter tuning (sigmas)

kernel.type <- 'oak.gaussian'

fixed.training.data <- lapply(initial.guess, 
                             function(x) runif(N.TUNING.DATASET,
                                               max(0, (1 - CALIBRATION.RANGE) * x),
                                               min(1, (1 + CALIBRATION.RANGE) * x)))
ls <- c(3.19263053399432e-10, 2.25655689472368e-08, 6.64563643812739e-06, 0.000187807444767429, 6.88354601537867e-06, 1.86988396270035e-08, 6.21548667488005e-05, 3.51986663872253e-07, 2.27749290241549e-09, 1.06052371649415e-05, 1.55987143878955e-09, 1.91481866954399e-08, 1.5455221544201e-07, 2.70514604141581e-05, 0.000477744596139961, 9.83729028021942e-06, 1.09223050051605e-10, 3.04332690882098e-05, 3.91507451020907e-05, 1.06194184322618e-08, 2.98932454969764e-06, 1.85648566084716e-09, 6.17924276046903e-10, 7.79125327849169e-08, 6.18011624903239e-06, 3.95139800386945e-06, 5.61405397644439e-05, 2.33222275621921e-09, 2.51811314265332e-06, 1.31809385378934e-05, 7.91385611774674e-10, 0.000147062035392791, 2.01674685863289e-09, 2.7668084728606e-08, 9.71636298069475e-07, 0.000297149241910651, 4.77747706014873e-05, 2.23189552584245e-05, 8.75232583333979e-09, 0.00035579057500788, 1.73826507735265e-05, 7.8187395129719e-09, 2.52530055343229e-05, 3.06033198666166e-09, 6.31678745982666e-08, 4.01686656375849e-07, 0.000176084198626235, 5.05206634822968e-05, 1.02528279539419e-06, 1.13836854484974e-06, 8.15593306131732e-05, 1.6297703531228e-06, 2.54899776417647e-05, 6.47460868961926e-07, 4.2720500845732e-06, 1.66618400180104e-08, 1.15945283068724e-07, 3.64277813699702e-05, 6.64563643812739e-06, 5.33266966523321e-05, 2.12173774967845e-07, 5.0556757318348e-05, 4.64190105844156e-07, 2.05262591017016e-06, 3.69764137854056e-06, 9.0778267514743e-06, 1.61586260231405e-06, 4.15989796269662e-06, 0.000139367218778578, 0.000312535558896922, 2.79385775890922e-06, 1.28434422721586e-06, 0.000240914848729135, 6.23745447153791e-07, 4.88767697159816e-06, 2.86816997898185e-05, 2.94707485737165e-05, 7.30491057761927e-08, 1.35525612016e-06, 1.42099069224334e-05, 0.000178776898175787, 0.000102027048185841, 2.07166987575516e-07, 0.000314326327945371, 4.03699826051274e-07, 2.78403614644364e-05, 0.000177885373813257, 7.36778403966249e-08, 6.39363250310587e-09, 3.26671395539292e-06, 6.26454863294583e-06, 0.000104622337104124, 0.000128538850744029, 8.62475793350968e-06, 2.21284950089477e-05, 1.05895779084354e-06, 4.36768651664127e-06, 0.000152653480135542, 9.08392370063349e-08)
ls <- ls * 1e5


# Only optimize sigma_0, sigma_1 and sigma_2
sigmas <- c(rep(1e-7, 3), rep(0,99-2))

optim.params <- sigmas[1:2]
lower.bounds <- rep(1e-10, length(optim.params))
upper.bounds <- rep(100, length(optim.params))

optim.result <- GenSA::GenSA(par=optim.params,
                             fn=function(p, kernel.type) -calculate.params.ll(p,kernel.type),
                             lower=lower.bounds,
                             upper=upper.bounds,
                             control=list(
                               maxit=500
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

cat(paste0(' Variance: ', 
           paste0(formatC(optim.result$par*100/sum(optim.result$par), 
                          format='f', digits=2), '%', collapse = ', '), 
           sep='\n'))
