library(MASS)
library(ggplot2)
library(cowplot)
library(mvtnorm)
library(kernlab)

source('../../models/lung/calibration_wrapper.R')

INITIAL.OBSERVATIONS <- 10
N.ITERATIONS <- 45
CALIBRATION.RANGE <- .5
N.CONSTRAINTS <- 8
N_MATRICES <- 9
STARTING_MATRIX <- 1
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
initial.guess <- initial.guess[1:(11*N_MATRICES)]


# Constraint (constraint(x) < lambda)
constraint <- function(x) {
  # No constraints
  # cs <- rep(0, N.CONSTRAINTS)
  
  cs <- sapply(1:(N_MATRICES-1), function(i) {
    mort.i <- x[(i-1)*11+5]
    mort.i2 <- x[i*11+5]
    mort.i - mort.i2
  })
  
  return(cs)
}
c.lambda <- rep(1e-10, N.CONSTRAINTS)


l <- .065172
sigma2 <- 0.0002154

l.c <- 336.364
sigma2.c <- 8016.67


build.k <- function(l, sigma2) {
  kernel <- rbfdot(sigma=1/(2*l[1]^2))
  k <- function(x,x2) {
    k <- kernelMatrix(kernel, as.matrix(x), as.matrix(x2))
    return(sigma2[1]*k)
  }
  return(k)
}

# Objective function noise
f <- function(pars) {
  result <- run.model(pars)
  expectation <- TARGET.POOLED[1:N_MATRICES]
  error <- sum((result-expectation)^2/expectation)
  return(error)
}

run.model <- function(pars) {
  calib.f <- make.calibration.func('','','', N_MATRICES = N_MATRICES)
  result <- fromJSON(calib.f(pars))
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

calculate.regression.model <- function(k, k.c, X, y, cx) {
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
      while (is.null(Ki.c) && jitter < 1) {
        try(Ki.c <- solve(Kmat.c + jitter*diag(nrow(K.c))), silent=TRUE)
        jitter <- jitter * 10
      }
      if (is.null(Ki.c)) stop('Singular matrix, numerical instability problems')
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
  
  feasible.index <- apply(X, 1, function(x) all(constraint(x) < c.lambda))
  
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
              K.c=K.c))
}

choose.next.evaluation.points <- function(gp.model) {
  optim.func <- function(x) {
    acq.func(gp.model, x)
  }
  
  # best <- pso::psoptim(par=initial.guess,
  #                fn=optim.func,
  #                lower=0,
  #                upper=1,
  #                control=list(
  #                   s=2
  #               ))
  random.obs <- as.data.frame(lapply(initial.guess, function(x) {
    runif(1, x*(1-CALIBRATION.RANGE), min(1, x*(1+CALIBRATION.RANGE)))
  }))
  colnames(random.obs) <- paste0('x', seq_along(initial.guess))
  
  best <- optim(random.obs, 
                optim.func, 
                method='L-BFGS-B', 
                lower=initial.guess * (1-CALIBRATION.RANGE), 
                upper=pmin(1, initial.guess * (1+CALIBRATION.RANGE)))
  names(best$par) <- paste0('x', seq_along(best$par))
  return(best$par)
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
  # return(as.integer(constraint(x)<c.lambda))
  means <- gp.model$mean.c(x2)
  sd <- sqrt(gp.model$cov.c(x2))
  # pf <- pnorm(c.lambda, mean=gp.model$mean.c(x2), sd=sqrt(gp.model$cov.c(x2)))
  pf <- sapply(seq_along(means), function(i) pnorm(c.lambda[i], mean=means[i], sd=sd))
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

plot.calibration <- function(gp.model) {
  current.outcome <- run.model(gp.model$best.x)
  x.labels <- STARTING_MATRIX:(STARTING_MATRIX+N_MATRICES-1)
  df.target.prev <- data.frame(x=x.labels, y=TARGET.POOLED[x.labels], type='Target')
  df <- rbind(df.target.prev, data.frame(x=x.labels, y=initial.guess.outcome, type='Initial'))
  df <- rbind(df, data.frame(x=x.labels, y=current.outcome, type='Current'))
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
    ggtitle('Calibration')
  plt
}

# Start optimization

set.seed(1)

cat('Initializing BO observations...\n')
observed.x <- as.data.frame(lapply(initial.guess, function(x) {
  runif(INITIAL.OBSERVATIONS, x*(1-CALIBRATION.RANGE), min(1, x*(1+CALIBRATION.RANGE)))
}))
observed.x <- rbind(observed.x, initial.guess)
initial.guess.outcome <- run.model(initial.guess)
colnames(observed.x) <- paste0('x', seq_along(initial.guess))
observed.y <- apply(observed.x, 1, f)
if (N.CONSTRAINTS == 1) {
  observed.c <- matrix(apply(observed.x, 1, constraint), ncol=1)
} else {
  observed.c <- t(apply(observed.x, 1, constraint))
}
cat('Initial errors:\n')
cat(paste0(observed.y, ' ', ifelse(apply(observed.c, 1, function(x) all(x < c.lambda)), '', 'NOT VALID'), collapse='\n'))
cat('\n')
# observed.c <- matrix(nrow=0, ncol=length(c.lambda))

k <- build.k(l, sigma2)
k.c <- build.k(l.c, sigma2.c)

cat('Starting optimization...\n')
print(Sys.time())
trace.df <- data.frame()
for(n in seq(N.ITERATIONS)) {
  start.time <- Sys.time()
  gp.model <- calculate.regression.model(k, k.c, observed.x, observed.y, observed.c)
  
  next.evaluation.point <- choose.next.evaluation.points(gp.model)
  
  evaluated.value <- f(next.evaluation.point)
  is.valid <- t(apply(t(next.evaluation.point), 1, constraint))
  
  observed.x <- rbind(observed.x, data.frame(t(next.evaluation.point)))
  observed.y <- c(observed.y, evaluated.value)
  observed.c <- rbind(observed.c, is.valid)
  
  end.time <- Sys.time()
  cat(paste0('Iteration ',n,': Error=', evaluated.value, ' [', formatC(difftime(end.time, start.time, units='secs')[[1]], format='d'), 's]'))
  trace.df <<- rbind(trace.df, data.frame(iter=n, error=evaluated.value, time=difftime(end.time, start.time, units='secs')[[1]]))
  if (!all(is.valid < c.lambda)) cat(' [NOT VALID]')
  cat('\n')
  
  current.outcome <- run.model(next.evaluation.point)
  x.labels <- STARTING_MATRIX:(STARTING_MATRIX+N_MATRICES-1)
  df.target.prev <- data.frame(x=x.labels, y=TARGET.POOLED[x.labels], type='Target')
  df <- rbind(df.target.prev, data.frame(x=x.labels, y=initial.guess.outcome, type='Initial'))
  df <- rbind(df, data.frame(x=x.labels, y=current.outcome, type='Current'))
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
    ggtitle(paste0('Iteration ', n))
  if (PLOT.ITERATION.PLOTS)
    print(plt)
}

cat('Optimization done:\n')
cat(paste0(' Best error (', min(trace.df$error), ') in ', sum(trace.df$time), 's\n'))

print(unlist(unname(gp.model$best.x)))
print(gp.model$best.y)
print(Sys.time())

print(plot.calibration(gp.model))



