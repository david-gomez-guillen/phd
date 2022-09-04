library(MASS)
library(ggplot2)
library(cowplot)
library(hydroPSO)

### Kernel
k <- function(x,x2) 2*exp(-10*(x-x2)^2)
# k <- function(x,x2) exp(-5*(x-x2)^2)

# Objective function noise
f <- function(x) sin(1.2*x) + sin((10.0 / 3) * x)
# f <- function(x) -exp(-x)*sin(2*pi*x)
f.noise <- 0

# GP prior mean
prior.mu <- function(x) 0

# Plot values
x.limits <- c(0, 10)
y.limits <- c(-3, 3)

# Optimization values
n.iterations <- 50
batch.size <- 1



# Function definitions

calculate.regression.model <- function(X, y) {
  K <- outer(X, X, k)
  d <- dim(K)[1]
  if (d == 0) {
    Ki <- K
  } else if (d == 1) {
    Ki <- 1/(K + f.noise)
  } else {
    Ki <- ginv(K + f.noise*diag(K))
  }
  
  fs <- function(Xs) {
    Ks <- outer(Xs, X, k)
    return(prior.mu(Xs) + Ks %*% Ki %*% (y - prior.mu(Xs)))
  }
  
  sigma <- function(Xs) {
    Ks <- outer(Xs, X, k)
    Kss <- outer(Xs, Xs, k)
    S <- Kss - Ks %*% Ki %*% t(Ks)
    if (Xs %in% observed.x && f.noise == 0)
      S <- matrix(0) # Due to numerical instability values already observed haved a non-zero sigma, forcing 0 here
    S <- apply(S, 1:2, function(x) max(x,0)) # Numerical instability, (small) negative values should be 0
    return(S)
  }
  
  if (d== 0) {
    best.x <- prior.mu(0)
    best.y <- -1e10
  } else {
    best.x <- X[which.max(y)]
    best.y <- max(y)
  }
  
  return(list(mean=fs, cov=sigma, best.x=best.x, best.y=best.y))
}

choose.next.evaluation.points <- function(x, y.acq, observed.x, gp.model) {
  optim.func <- function(x) -acq.func(gp.model, x)
  best <- tryCatch(suppressMessages(
    hydroPSO(fn=optim.func,
             lower=0, 
             upper=10, 
             control=list(
               npart=10
               )))
    # ,finally=sink()
    )
  return(best$par)
}

acq.func <- function(gp.model, x) {
  return(acq.func.ei(gp.model, x))
}

acq.func.ucb <- function(gp.model, x) {
  mu <- gp.model$mean(x)
  sigma <- sqrt(gp.model$cov(x)[1,1])
  lambda <- 1
  
  return(mu + lambda * sigma)
}

acq.func.pi <- function(gp.model, x) {
  mu <- gp.model$mean(x)
  sigma <- sqrt(gp.model$cov(x)[1,1])
  best.y <- gp.model$best.y
  
  return(pnorm((mu-best.y)/sigma))
}

acq.func.ei <- function(gp.model, x) {
  mu <- gp.model$mean(x)
  sigma <- sqrt(gp.model$cov(x)[1,1])
  best.y <- gp.model$best.y
  if (sigma > 0) {
    # return(max((mu-best.y)*pnorm((mu-best.y)/sigma) + sigma*dnorm((mu-best.y)/sigma), 0))
    return((mu-best.y)*pnorm((mu-best.y)/sigma) + sigma*dnorm((mu-best.y)/sigma))
  } else { # Observed value, no uncertainty
    return(max(mu-best.y,0))
  }
}



# Build target function plot

x.plt <- seq(0, 10, .01)
xx <- x.plt
yy <- f(xx)
df <- data.frame(x=xx, y=yy)

plt.f <- ggplot(df, aes(x=x, y=y)) + 
  geom_line(size=2, alpha=.3) +
  xlim(x.limits) +
  ylab('Gaussian process estimate')
plt.f



# Start optimization

observed.x <- numeric(0)
observed.y <- numeric(0)

set.seed(1)

for(n in seq(n.iterations)) {
  gp.model <- calculate.regression.model(observed.x, observed.y)
  
  xx <- c(x.plt, observed.x)
  xx <- xx[!duplicated(xx)]
  xx <- xx[order(xx)]
  yy.acq <- sapply(xx, function(x) acq.func(gp.model, x))
  
  next.evaluation.points <- choose.next.evaluation.points(xx, yy.acq, observed.x, gp.model)
  
  yy <- sapply(xx, function(x) gp.model$mean(x))
  ss <- sapply(xx, function(x) sqrt(max(gp.model$cov(x)[1,1], 0)))
  
  
  df <- data.frame(x=xx, y=yy, ymin=yy-ss, ymax=yy+ss)
  points.df <- data.frame(x=observed.x, y=observed.y)
  next.points.df <- data.frame(x=next.evaluation.points, y=f(next.evaluation.points))
  
  plt <- plt.f +
    geom_line(data=df, linetype='solid', color='blue', size=2) +
    geom_ribbon(data=df, aes(ymin=ymin, ymax=ymax), fill='blue', alpha=.2) +
    geom_vline(xintercept = next.evaluation.points, linetype='dashed') +
    geom_point(data=points.df, color='black', size=3) +
    geom_point(data=next.points.df, color='red', size=3) +
    geom_point(x=gp.model$best.x, y=gp.model$best.y, color='green', size=3)
  
  observed.x <- c(observed.x, next.evaluation.points)
  observed.y <- c(observed.y, f(next.evaluation.points))
  
  df.acq <- data.frame(x=xx, y=yy.acq)
  acq.plt <- ggplot(df.acq, aes(x=x, y=y)) +
    geom_line() +
    geom_vline(xintercept = next.evaluation.points, linetype='dashed') +
    ylab('Expected Improvement') +
    xlim(x.limits)
  
  log.acq.plt <- ggplot(df.acq, aes(x=x, y=log(y))) +
    geom_line() +
    geom_vline(xintercept = next.evaluation.points, linetype='dashed') +
    ylab('Log Expected Improvement') +
    xlim(x.limits)
  
  plt2 <- plot_grid(plt, acq.plt, log.acq.plt, nrow=3, align='v')
  
  # print(plt2)
  # browser()
  
  png(paste0('output/gp/optim_', n, '.png'), width=1700, height = 1000)
  print(plt2)
  dev.off()
  cat(paste('Iteration',n,'\n'))
}

