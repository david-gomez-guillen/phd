library(MASS)
library(ggplot2)
# library(PrevMap)
library(cowplot)

### Kernel
k <- function(x,x2) exp(-(x-x2)^2)
# k <- function(x,x2) exp(-5*(x-x2)^2)

# Objective function noise
f <- function(x) sin(1.2*x) + sin((10.0 / 3) * x)
# f <- function(x) sin(1.2*x) + sin((40.0 / 3) * x)
f.noise <- 0

# Constant prior value
prior.mu <- 0

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
    return(prior.mu + Ks %*% Ki %*% (y - prior.mu))
  }
  
  sigma <- function(Xs) {
    Ks <- outer(Xs, X, k)
    Kss <- outer(Xs, Xs, k)
    S <- Kss - Ks %*% Ki %*% t(Ks)
    S <- apply(S, 1:2, function(x) max(x,0)) # Numerical instability, (small) negative values should be 0
    return(S)
  }
  
  if (d== 0) {
    best.x <- prior.mu
    best.y <- prior.mu
  } else {
    best.x <- X[which.max(y)]
    best.y <- max(y)
  }
  
  return(list(mean=fs, cov=sigma, best.x=best.x, best.y=best.y))
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
  
  return((mu-best.y)*pnorm((mu-best.y)/sigma) + sigma*dnorm((mu-best.y)/sigma))
}

x.limits <- c(0, 10)
y.limits <- c(-3, 3)
n.iterations <- 30

x.plt <- seq(0, 10, .01)
xx <- x.plt
yy <- f(xx)
df <- data.frame(x=xx, y=yy)

plt.f <- ggplot(df, aes(x=x, y=y)) + 
  geom_line(size=2, alpha=.3) +
  xlim(x.limits)
  # ylim(y.limits)
plt.f

observed.x <- numeric(0)
observed.y <- numeric(0)

set.seed(1)

for(n in seq(n.iterations)) {
  gp.model <- calculate.regression.model(observed.x, observed.y)
  
  yy.acq <- sapply(xx, function(x) acq.func(gp.model, x))
  yy2 <- yy.acq[!xx %in% observed.x]
  xx2 <- xx[!xx %in% observed.x]
  best.y.acq <- max(yy2)
  candidates <- xx2[yy2==best.y.acq]
  if (length(candidates) == 1) next.candidate <- candidates
  else next.candidate <- sample(candidates, 1)
  
  xx <- c(x.plt, observed.x)
  xx <- xx[!duplicated(xx)]
  xx <- xx[order(xx)]
  yy <- sapply(xx, function(x) gp.model$mean(x))
  ss <- sapply(xx, function(x) sqrt(max(gp.model$cov(x)[1,1], 0)))
  
  plt <- plt.f + geom_point(x=next.candidate, y=f(next.candidate), color='red', size=3)
  
  df <- data.frame(x=xx, y=yy, ymin=yy-ss, ymax=yy+ss)
  points.df <- data.frame(x=observed.x, y=observed.y)
  
  # plt.gp <- ggplot(df, aes(x=x, y=y)) +
  plt <- plt +
    geom_line(data=df, linetype='solid', color='blue', size=2) +
    geom_ribbon(data=df, aes(ymin=ymin, ymax=ymax), fill='blue', alpha=.2) +
    geom_vline(xintercept = next.candidate, linetype='dashed') +
    geom_point(data=points.df, color='black', size=3)
  
  observed.x <- c(observed.x, next.candidate)
  observed.y <- c(observed.y, f(next.candidate))
  
  df.acq <- data.frame(x=xx, y=yy.acq)
  acq.plt <- ggplot(df.acq, aes(x=x, y=y)) +
    geom_line() +
    geom_vline(xintercept = next.candidate, linetype='dashed') +
    ylab('Acquisition measure') +
    xlim(x.limits)
  
  plt2 <- plot_grid(plt, acq.plt, nrow=2, align='v')
  print(plt2)
  
  # browser()
}

