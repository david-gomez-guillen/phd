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
library(kernlab)
library(optimParallel)
library(ppso)

# Objective function
N_MATRICES <- 9
STARTING_MATRIX <- 1
DELAY <- 0
source('../../models/lung/calibration_wrapper.R')
f <- function(pars) {
  calib.f <- make.calibration.func('','','')
  result <- fromJSON(calib.f(pars))
  expectation <- list(
    incidence=c(1.9, 9.0, 20.9, 39.7, 57.9, 68.8, 71.4, 70.4, 69.9),
    lc.mortality=c(0.29, 5.0, 13.4, 26.6, 42.5, 51.1, 52.0, 52.3, 53.9),
    other.mortality=c(39.8893, 64.0476, 114.6431, 188.9474, 289.2546 ,417.0061, 604.7883, 996.8391, 1871.6366)
  )
  expectation <- lapply(expectation, function(m) m[1:N_MATRICES])
  se <- sapply(1:3, function(i) ((result[[i]] - expectation[[i]])^2)/expectation[[i]])
  error <- sum(unlist(se) * c(.45, .45, .1))
  return(error)
}
f.noise <- 1e-12

# GP prior mean
prior.mu <- function(x) 0

# Model parameters
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
initial.guess <- initial.guess[1:(11*N_MATRICES)]

# OAK parameters
input.means <- initial.guess
input.sds <- sapply(initial.guess, function(x) (min(x,1-x) / 2))
max.oak.sigma <- 1  # Truncate OAK, reject higher orders of interaction

# Limits of uniform distribution given mean and sd
lower.limits <- input.means - input.sds*sqrt(12)/2  
upper.limits <- input.means + input.sds*sqrt(12)/2


# Plot values
x.limits <- c(0, 10)
y.limits <- c(-3, 3)

# Optimization values
n.iterations <- 100
batch.size <- 1
n.cores <- 15
n.pso.particles <- 50
n.pso.iters <- 100
use.optimization <- FALSE
seed <- commandArgs(trailingOnly=TRUE)[1]
if (is.na(seed)) seed <- 123

# Function definitions

get.init.params <- function(kernel.type) {
  if (kernel.type == 'se') {
    initial.pars <- c(1, 1)
    lower.bounds <- c(.01, .01)
    upper.bounds <- c(10, 10)
  } else if (kernel.type == 'ak') {
    # initial.pars <- c(rep(.5, N_MATRICES*11), rep(5   , N_MATRICES*11))
    initial.pars <- c(0.999999999993379,0.01,1,1,1,0.999999999996571,1,1,1,1,1,0,10,0,0,0,0,10,10,10,0,1.03305626037006e-11)
    lower.bounds <- c(rep(.0001, N_MATRICES*11), rep(0, N_MATRICES*11))
    upper.bounds <- c(rep(5, N_MATRICES*11), rep(50, N_MATRICES*11))
  } else if (kernel.type == 'oak.gaussian') {
    initial.pars <- c(50, 0.1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
    lower.bounds <- c(rep(.00001, N_MATRICES*11), rep(0, (N_MATRICES*11 + 1)))
    upper.bounds <- c(rep(100, N_MATRICES*11), rep(1000, (N_MATRICES*11 + 1)))
    # initial.pars <- c(2.33134449714195,1e-04,2.33134449714195,2.33134449714195,2.33134449714195,0.667197159326941,2.33134449714195,0.667197159326941,0.667197159326941,2.33134449714195,2.33134449714195,0.667163875714512,16.6418062142744,6.67163875714512,0,0,0,0,6.67163875714512,23.3134449714195,23.3134449714195,0,16.6418062142744)
  }
  return(list(
    initial.pars=initial.pars,
    lower.bounds=lower.bounds,
    upper.bounds=upper.bounds
  ))
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
    # Ks <- matrix(unlist(Ks),nrow=nrow(Ks))
    m <- prior.mu(Xs) + Ks %*% Ki %*% (y - prior.mu(Xs))
    # print(Xs)
    # print(m)
    # print('------')
    return(m)
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

build.k <- function(type, l, sigma2) {
  if (type == 'se') {
    k <- function(x,x2) {
      kernel <- rbfdot(sigma=1/(2*l[1]^2))
      k <- kernelMatrix(kernel, as.matrix(x), as.matrix(x2))
      return(sigma2[1]*k)
    }
    return(k)
  } else if (type == 'se.2') {
    k <- function(x,x2) {
      kernel <- rbfdot(sigma=1/(2*l[1]^2))
      k <- kernelMatrix(kernel, as.matrix(x[,2]), as.matrix(x2[,2]))
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
          l[i]*sqrt(l[i]^2+2*input.sds[i]^2)/(l[i]^2+input.sds[i]^2) *
          exp(-exp.numerator.i/(2*(l[i]^2+input.sds[i]^2)))
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

choose.next.evaluation.points <- function(gp.model) {
  optim.func <- function(x) {
    y <- acq.func(gp.model, x)
    return(y)
  }
  best <- suppressMessages(
    hydroPSO(fn=optim.func,
             lower=lower.limits,
             upper=upper.limits,
             control=list(
               npart=n.pso.particles,
               maxit=n.pso.iters,
               parallel='parallel',
               par.nnodes=n.cores,
               write2disk=FALSE,
               verbose=FALSE
             )))
  stopImplicitCluster()
  
  # best <- optim(par=initial.guess,
  #               method='SAN',
  #               # method='L-BFGS-B',
  #               fn=optim.func,
  #               lower=lower.limits,
  #               upper=upper.limits,
  #               control=list(
  #                 fnscale=-1,
  #                 parscale=rep(10,length(initial.guess)),
  #                 temp=100,
  #                 tmax=100,
  #                 maxit=100,
  #                 npart=100
  #               )
  #               # parallel=list(
  #               #   # cl=cl,
  #               #   loginfo=TRUE
  #               # ),
  # )
  
  # best <- optimParallel(par=initial.guess,
  #               fn=optim.func,
  #               method='SAN',
  #               lower=lower.limits,
  #               upper=upper.limits,
  #               control=list(
  #                 # pgtol=1e-20,
  #                 temp=100,
  #                 tmax=100,
  #                 maxit=100,
  #                 fnscale=-1,
  #                 trace=20,
  #                 parscale=rep(10,length(initial.guess))
  #               )
  # )
  
  # print(abs(best$par - initial.guess))
  # print(best$value)
  return(best$par)
}

acq.func <- function(gp.model, x) {
  return(acq.func.ei(gp.model, x))
}

acq.func.ei <- function(gp.model, x) {
  x2 <- t(data.frame(x))
  mu <- gp.model$mean(x2)
  # if (mu != 0) browser()
  tryCatch(
    sigma <- sqrt(gp.model$cov(x2)[1,1]),
    warning=function(e) {
      browser()})
  best.y <- gp.model$best.y
  if (is.na(sigma)) browser()
  if (sigma > 0) {
    ei <- (mu-best.y)*pnorm((mu-best.y)/sigma) + sigma*dnorm((mu-best.y)/sigma)
  } else { # Observed value, no uncertainty
    ei <- max(mu-best.y,0)
  }
  # print(ei)
  # print(x)
  # print(sum(x))
  # if (length(gp.model$K) > 0) browser()
  return(ei)
}

# try(stopCluster(cl))
# cl <- makeForkCluster(n.cores)
# clusterExport(cl, c('prior.mu', 'k'))
# registerDoParallel(cl)

l.oak <- c(1.425253e-11,1.128356e-08,6.446930e-07,3.780784e-05,4.487612e-07,1.176684e-10,3.072113e-07,3.399477e-07,1.829153e-11,5.486929e-08,4.435985e-12
           # 7.842822e-10,3.357831e-09,3.797246e-07,1.114584e-05,6.058154e-06,3.656973e-12,3.994255e-06,1.218245e-07,2.164872e-10,2.283868e-07,4.919127e-12
           )
sigma2.oak <- c(1585.39465361646,42.7746208718925,rep(0, N_MATRICES*11-2))

# summary.df <- read.csv('../../output/lc_1m_oak.csv')
summary.df <- data.frame()
for(kernel.type in c(
  # 'se', 
  # 'se.2', 
  'oak.gaussian'
  )) {
  k <- build.k(kernel.type, l.oak, sigma2.oak)
  # k <- build.k('se', l.oak, 1)
  
  results.df <- data.frame()
  for(seed in seq(from=1, length.out=30)) {
    # Start optimization
    
    print(Sys.time())
    set.seed(seed)
    observed.x <- data.frame(matrix(ncol=length(initial.guess),nrow=0))
    colnames(observed.x) <- seq(paste0('x', seq_along(initial.guess)))
    observed.y <- numeric(0)
    
    for(n in seq(n.iterations)) {
      # cat('Building GP...\n')
      # cat(system.time({
        gp.model <- NULL
        while (is.null(gp.model)) {
          try(
            gp.model <- calculate.regression.model(observed.x, observed.y, k)
          )
        }
      # }))
      
      # cat('Optimizing acquisition function...\n')
      # print(system.time({
        next.evaluation.points <- choose.next.evaluation.points(gp.model)
      # }), '\n')
      
      evaluated.values <- f(next.evaluation.points)
      
      observed.x <- rbind(observed.x, data.frame(t(next.evaluation.points)))
      observed.y <- c(observed.y, evaluated.values)
      
      # cat(next.evaluation.points, '\n')
      cat(paste0('Iteration ', n, ' error: ', evaluated.values, '\n'))
      # cat('\n')
    }
    # warnings()
    # cat('Observed errors:')
    # cat(observed.y, '\n')
    # cat('Best solution:\n')
    # print(observed.x[which.min(observed.y),])
    # cat('Minimum error:')
    # cat(min(observed.y), '\n')
    
    # write.csv(observed.y, paste0('../../output/lc_1m_', kernel.type, '_', seed, '.csv'))
    results.df <- rbind(results.df, observed.y)
    # stopCluster(cl)
    print(Sys.time())
    # browser()
  }
  
  current.df <- data.frame(y=apply(results.df, 2, mean), sd=apply(results.df, 2, sd))
  current.df$kernel <- kernel.type
  current.df$ymin <- current.df$y - 2*current.df$sd
  current.df$ymax <- current.df$y + 2*current.df$sd
  current.df$x <- seq(nrow(current.df))
  
  summary.df <- rbind(summary.df, current.df)
}

# write.csv(summary.df, '../../output/oak_results_mat', N_MATRICES, '.csv')


df <- read.csv('output/oak_results.csv', sep=';')

q1 <- function(x) return(quantile(x, .25))
q2 <- function(x) return(quantile(x, .5))
q3 <- function(x) return(quantile(x, .75))

# df.ma5 <- data.frame()
# for(kernel in unique(df$kernel)) {
#   for(seed in unique(df$seed)) {
#     ma <- rollmean(df[df$kernel==kernel & df$seed==seed,'y'], 5)
#     df.ma5 <- rbind(df.ma5, data.frame(seed=seed, y=ma, kernel=kernel, iter=seq_along(ma)))
#   }
# }
# df.ma5 <- df.ma5 %>% group_by(kernel, iter) %>% summarise_at(vars(y), c(mean, sd))
# names(df.ma5) <- c('kernel', 'x', 'y', 'sd')
# df.ma5$ymin <- df.ma5$y - 2*df.ma5$sd
# df.ma5$ymax <- df.ma5$y + 2*df.ma5$sd
# 
# ggplot(df.ma5, aes(x=x, y=y, ymin=ymin, ymax=ymax, color=kernel, fill=kernel)) +
#   geom_line() +
#   geom_ribbon(alpha=.2, linetype=3) +
#   xlab('Iteration') +
#   ylab('Error') +
#   coord_cartesian(xlim=c(1,100), ylim=c(-10,35))
# 
# 
# 
# df.ma10 <- data.frame()
# for(kernel in unique(df$kernel)) {
#   for(seed in unique(df$seed)) {
#     ma <- rollmean(df[df$kernel==kernel & df$seed==seed,'y'], 10)
#     df.ma10 <- rbind(df.ma10, data.frame(seed=seed, y=ma, kernel=kernel, iter=seq_along(ma)))
#   }
# }
# df.ma10 <- df.ma10 %>% group_by(kernel, iter) %>% summarise_at(vars(y), c(mean, sd))
# names(df.ma10) <- c('kernel', 'x', 'y', 'sd')
# df.ma10$ymin <- df.ma10$y - 2*df.ma10$sd
# df.ma10$ymax <- df.ma10$y + 2*df.ma10$sd
# 
# ggplot(df.ma10, aes(x=x, y=y, ymin=ymin, ymax=ymax, color=kernel, fill=kernel)) + 
#   geom_line() +
#   geom_ribbon(alpha=.2, linetype=3) +
#   xlab('Iteration') +
#   ylab('Error') +
#   coord_cartesian(xlim=c(1,100), ylim=c(-10,35))
# 
# 
# 
df2 <- df %>% group_by(kernel, iter) %>% summarise_at(vars(y), c(mean, sd))
names(df2) <- c('kernel', 'x', 'y', 'sd')
df2$ymin <- df2$y - 2*df2$sd
df2$ymax <- df2$y + 2*df2$sd
df2$ycum <- ave(df2$y, df2$kernel, FUN=cummin)
df2$ycuml <- ave(df2$ymin, df2$kernel, FUN=cummin)
df2$ycumu <- ave(df2$ymax, df2$kernel, FUN=cummin)

# Remove univariate if necessary
df2 <- df2[df2$kernel!='se2',]

plt <- ggplot(df2, aes(x=x, y=y, ymin=max(0,ymin), ymax=ymax, color=kernel, fill=kernel)) +
  geom_line() +
  geom_ribbon(alpha=.2, linetype=3) +
  scale_color_discrete(name='Kernel',
                     breaks=c('se',
                              'se2',
                              'oak.gaussian'),
                     labels=c('SE',
                              'Univariate SE\n(most significant variable)',
                              'OAK')) +
  scale_fill_discrete(name='Kernel',
                       breaks=c('se',
                                'se2',
                                'oak.gaussian'),
                       labels=c('SE',
                                'Univariate SE\n(most significant variable)',
                                'OAK')) +
  theme_minimal() +
  theme(legend.position='bottom') +
  xlab('Iteration') +
  ylab('Error') +
  coord_cartesian(xlim=c(1,100), ylim=c(0,35))
plt


pltm <- ggplot(df2, aes(x=x, y=ycum, ymin=max(0,ycuml), ymax=ycumu, color=kernel, fill=kernel)) +
  geom_line() +
  # geom_ribbon(alpha=.2, linetype=3) +
  scale_color_discrete(name='Kernel',
                       breaks=c('se',
                                'se2',
                                'oak.gaussian'),
                       labels=c('SE',
                                'Univariate SE\n(most significant variable)',
                                'OAK')) +
  scale_fill_discrete(name='Kernel',
                      breaks=c('se',
                               'se2',
                               'oak.gaussian'),
                      labels=c('SE',
                               'Univariate SE\n(most significant variable)',
                               'OAK')) +
  theme_minimal() +
  theme(legend.position='bottom') +
  xlab('Iteration') +
  ylab('Error') +
  coord_cartesian(xlim=c(1,100), ylim=c(0,15))
pltm


df3 <- df %>% group_by(kernel, iter) %>% summarise_at(vars(y), c(q1, q2, q3))
names(df3) <- c('kernel', 'x', 'q1', 'q2', 'q3')

# Remove univariate if necessary
df3 <- df3[df3$kernel!='se2',]

plt <- ggplot(df3, aes(x=x, y=q2, ymin=q1, ymax=q3, color=kernel, fill=kernel)) +
  geom_line() +
  # geom_ribbon(alpha=.2, linetype=3) +
  scale_color_discrete(name='Kernel',
                       breaks=c('se',
                                'se2',
                                'oak.gaussian'),
                       labels=c('Squared Exponential',
                                'Univariate SE\n(most significant variable)',
                                'Orthogonal Additive Kernel')) +
  scale_fill_discrete(name='Kernel',
                      breaks=c('se',
                               'se2',
                               'oak.gaussian'),
                      labels=c('Squared Exponential',
                               'Univariate SE\n(most significant variable)',
                               'Orthogonal Additive Kernel')) +
  theme_minimal() +
  theme(legend.position='bottom') +
  xlab('Iteration') +
  ylab('Error') +
  coord_cartesian(xlim=c(1,100), ylim=c(0,25))
plt


df3$q1 <- ave(df3$q1, df3$kernel, FUN=cummin)
df3$q2 <- ave(df3$q2, df3$kernel, FUN=cummin)
df3$q3 <- ave(df3$q3, df3$kernel, FUN=cummin)

pltm <- ggplot(df3, aes(x=x, y=q2, ymin=q1, ymax=q3, color=kernel, fill=kernel)) +
  geom_line() +
  # geom_ribbon(alpha=.2, linetype=3) +
  scale_color_discrete(name='Kernel',
                       breaks=c('se',
                                'se2',
                                'oak.gaussian'),
                       labels=c('Squared Exponential',
                                'Univariate SE\n(most significant variable)',
                                'Orthogonal Additive Kernel')) +
  scale_fill_discrete(name='Kernel',
                      breaks=c('se',
                               'se2',
                               'oak.gaussian'),
                      labels=c('Squared Exponential',
                               'Univariate SE\n(most significant variable)',
                               'Orthogonal Additive Kernel')) +
  theme_minimal() +
  theme(legend.position='bottom') +
  xlab('Iterations') +
  ylab('Median cumulative minimum error') +
  coord_cartesian(xlim=c(1,100), ylim=c(0,10))
pltm
