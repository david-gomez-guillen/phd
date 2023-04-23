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
n.pars <- n.matrices * 11
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
initial.guess <- initial.guess[1:n.pars]
lower.limits <- initial.guess * .5
upper.limits <- initial.guess * 1.5

# OAK parameters
input.means <- initial.guess
input.vars <- sapply(initial.guess, function(x) (min(x,1-x) / 10)^2)

# Plot values
plot.gps <- FALSE
x.limits <- c(0, 10)
y.limits <- c(-3, 3)

# Other values
seed <- 935
n.cores <- 8
n.iters.per.paramset <- 15

n.points <- 200
n.points.test <- 500
fixed.training <- TRUE
fixed.test <- FALSE
optimize.only.sigmas <- FALSE
l.fixed.pars <- c(    2.33134449714195,1e-04,2.33134449714195,2.33134449714195,2.33134449714195,0.667197159326941,2.33134449714195,0.667197159326941,0.667197159326941,2.33134449714195,2.33134449714195)

set.seed(234)
fixed.training.data <- lapply(seq_along(initial.guess), function(i) rnorm(n.points, input.means[i], sqrt(input.vars[i])))
set.seed(123)
fixed.mse.test.data <- lapply(seq_along(initial.guess), function(i) rnorm(n.points.test, input.means[i], sqrt(input.vars[i])))

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
    lower.bounds <- c(rep(.0001, n.pars), rep(0, n.pars))
    upper.bounds <- c(rep(5, n.pars), rep(50, n.pars))
  } else if (kernel.type == 'oak.gaussian') {
    initial.pars <- rep(5, n.pars)
    lower.bounds <- rep(1e-10, n.pars)
    upper.bounds <- rep(10, n.pars)
    # initial.pars <- c(2.33134449714195,1e-04,2.33134449714195,2.33134449714195,2.33134449714195,0.667197159326941,2.33134449714195,0.667197159326941,0.667197159326941,2.33134449714195,2.33134449714195,0.667163875714512,16.6418062142744,6.67163875714512,0,0,0,0,6.67163875714512,23.3134449714195,23.3134449714195,0,16.6418062142744)
  }
  return(list(
    initial.pars=initial.pars,
    lower.bounds=lower.bounds,
    upper.bounds=upper.bounds
  ))
}

build.k <- function(l, i) {
  k <- function(x,x2) {
    kernel <- rbfdot(sigma=1/(2*l^2))
    k <- kernelMatrix(kernel, as.matrix(x[,i]), as.matrix(x2[,i]))
    return(k)
  }
  return(k)
}

calculate.regression.model <- function(X, y, k) {
  if (nrow(X) == 0) {
    K <- numeric(0)
    Ki <- K
  } else {
    K <- k(X,X)
    # TODO: Decide if worth it to include
    # if (any(eigen(K)$values < 0)) {
    #   # Fix negative eigenvalues
    #   browser()
    #   eig <- eigen(K)
    #   print(eig$values)
    #   eig$values[eig$values < 1e-7] <- 1e-7
    #   K <- t(eig$vectors) %*% diag(eig$values) %*% eig$vectors
    # }
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
    # Fix: If infinities show up the actual results should be 0: 
    #    exp(-1/(2l^2)*0-) -> Infinite for small ls and very small negative norm (numerical instability)
    #    exp(-1/(2l^2)*0+) -> 0 for small ls and very small positive norm
    Ks[is.infinite(Ks)] <- 0
    return(prior.mu(Xs) + Ks %*% Ki %*% (y - prior.mu(Xs)))
  }
  
  
  sigma <- function(Xs) {
    Kss <- k(Xs, Xs)
    # Kss <- apply(Xs, 1, function(r) k(r,r))
    
    if (nrow(X) == 0)
      return(Kss)
    
    Ks <- k(Xs, X)
    # Fix: If infinities show up the actual results should be 0: 
    #    exp(-1/(2l^2)*0-) -> Infinite for small ls and very small negative norm (numerical instability)
    #    exp(-1/(2l^2)*0+) -> 0 for small ls and very small positive norm
    Ks[is.infinite(Ks)] <- 0
    
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
    # test.data <- lapply(initial.guess, function(xi) runif(n.points.test, xi*.5, xi*1.5))
    test.data <- lapply(seq_along(initial.guess), function(i) rnorm(n.points.test, input.means[i], sqrt(input.vars[i])))
  }
  names(test.data) <- paste0('x', seq_along(test.data))
  x.test <- data.frame(test.data)
  
  y.test <- apply(x.test, 1, f)
  y.model <- gp.model$mean(x.test)
  if (any(is.na(y.test)) || any(is.na(y.model))) browser()
  
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

calculate.lengthscale.ll <- function(par, i, kernel.type) {
  k <- build.k(par, i)
  
  start_time <- Sys.time()
  
  if (fixed.training) {
    train.data <- fixed.training.data
    names(train.data) <- paste0('x', seq_along(train.data))
    observed.x <- data.frame(train.data)
    
    observed.y <- apply(observed.x, 1, f)
    gp.model <- tryCatch({
      calculate.regression.model(observed.x, observed.y, k)
    },
    error=function(e) {
      if (grepl('system is computationally singular', e$message) && !fixed.training) {
        cat('Matrix is computationally singular, trying new matrices...\n')
        return(NULL)
      }
      else stop(e)
    })
    
    perfs <- calculate.performance(gp.model, kernel.type, observed.x, observed.y)
  } else {
    cl <- makeForkCluster(n.cores, outfile='')
    # clusterExport(cl, c('i'))
    perfs <- pbsapply(cl=cl, X=seq(n.iters.per.paramset), FUN=function(i) {
    # perfs <- sapply(seq(n.iters.per.paramset), FUN=function(i) {
    gp.model <- NULL
    while (is.null(gp.model)) {
      train.data <- lapply(seq_along(initial.guess), function(i) rnorm(n.points, input.means[i], sqrt(input.vars[i])))
      
      names(train.data) <- paste0('x', seq_along(train.data))
      observed.x <- data.frame(train.data)
      
      observed.y <- apply(observed.x, 1, f)
      gp.model <- tryCatch({
        calculate.regression.model(observed.x, observed.y, k)
      },
      error=function(e) {
        if (grepl('system is computationally singular', e$message) && !fixed.training) {
          cat('Matrix is computationally singular, trying new matrices...\n')
          return(NULL)
        }
        else stop(e)
      })
    }
    
    stopCluster(cl)
    
    perf <- calculate.performance(gp.model, kernel.type, observed.x, observed.y)
    if (is.na(perf)) browser()
    return(perf)
  })
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
  # message(paste0('l=',par,
  #                ' (', perf.name, '=', mean.perf, ' +- ', perf.sd, '), time: ',
  #                elapsed_time), appendLF=TRUE )
  cat(paste0(par, ': ', mean.perf))
  cat('\n')
  return(list(mean=mean.perf, sd=sd(perfs)))
  # return(mean.perf)
}


set.seed(seed)
kernel.type <- 'oak.gaussian'
optim.params <- get.init.params(kernel.type)

try(stopCluster(cl), silent=TRUE)

# clusterExport(cl, ls(-1))
# clusterEvalQ(cl, {
#   library(kernlab)
#   library(jsonlite)
#   library(foreach)
# })
# registerDoParallel(cl)
maxima <- c()
for(i in seq(1,n.pars)) {
  # x <- lapply(seq(n.pars), function(p) {
  #   10^seq(-12,0,length.out=200)
  # })
  
  x <- c(1.431966e-11,
         1.123066e-08,
         6.477296e-07,
         3.763059e-05,
         4.466573e-07,
         1.182226e-10,
         3.057711e-07,
         3.383540e-07,
         1.837769e-11,
         5.512774e-08,
         4.456879e-12,
         7.806054e-10,
         3.342089e-09,
         3.815132e-07,
         1.109359e-05,
         6.086689e-06,
         3.674198e-12,
         3.975529e-06,
         1.223983e-07,
         2.154723e-10,
         2.294625e-07,
         4.896065e-12)
  x <- lapply(x, function(xx) {
    xxx <- log(xx, 10)
    10^seq(xxx-.1,xxx+.1,length.out=50)
    # 10^seq(xxx-2,xxx+2,length.out=50)
  })
  
  cat(paste0('\n\nDimension ', i, '\n'))
  errors <- list()
  for(j in seq_along(x[[i]])) {
    l <- x[[i]][j]
    err <- calculate.lengthscale.ll(l, i, 'oak.gaussian')
    err$x <- l
    if (err$mean < -34000) break
    errors[[j]] <- err
  }
  
  max.index <- which.max(sapply(errors, function(e)e$mean))
  maximum <- errors[[max.index]]$x
  maxima <- c(maxima, maximum)
  
  df <- data.frame(x=sapply(errors, function(e)e$x), error=sapply(errors, function(e)e$mean), sd=sapply(errors, function(e)e$sd))
  df$ymin <- df$error - df$sd
  df$ymax <- df$error + df$sd
  plt <- ggplot(df, aes(x=x, y=error, ymin=ymin, ymax=ymax)) +
    geom_line() +
    geom_ribbon(color='blue', alpha=.2, ) +
    scale_x_log10(name='lengthscale') +
    # scale_y_continuous(limits=c(-36000,-29000)) +
    # scale_y_continuous(limits=c(0,2.5)) +
    ylab('Loglikelihood') +
    ggtitle(paste0('Dimension ', i))
  print(plt)
  ggsave(paste0('../../output/zoom_lengthscale', i, '.png'), plt, width=2400, height=1600, units = 'px')
}

print(maxima)
