library(MASS)
library(ggplot2)
library(cowplot)

### Kernel
k <- function(x,x2) exp(-(x-x2)^2)
# k <- function(x,x2) exp(-5*(x-x2)^2)

# Kernel for constraint model
k.c <- function(x,x2) exp(-(x-x2)^2)

# Objective function noise
f <- function(x) sin(1.2*x) + sin((10.0 / 3) * x)
# f <- function(x) sin(1.2*x) + sin((40.0 / 3) * x)
f.noise <- 0

# Constraint (constraint(x) < lambda)
constraint <- function(x) sin(1.3*(x-4.5))
c.lambda <- .6

# Constant prior value
prior.mu <- 0

calculate.regression.model <- function(X, y, cx) {
  # Function model
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
  
  # Constraint model
  
  K.c <- outer(X, X, k.c)
  # Same dimension as K
  if (d == 0) {
    Ki.c <- K.c
  } else if (d == 1) {
    Ki.c <- 1/K.c
  } else {
    Ki.c <- ginv(K.c)
  }
  
  fs.c <- function(Xs) {
    Ks.c <- outer(Xs, X, k.c)
    return(prior.mu + Ks.c %*% Ki.c %*% (cx - prior.mu))
  }
  
  sigma.c <- function(Xs) {
    Ks.c <- outer(Xs, X, k.c)
    Kss.c <- outer(Xs, Xs, k.c)
    S.c <- Kss.c - Ks.c %*% Ki.c %*% t(Ks.c)
    S.c <- apply(S.c, 1:2, function(x) max(x,0)) # Numerical instability, (small) negative values should be 0
    return(S.c)
  }
  
  if (d== 0) {
    best.x <- prior.mu
    best.y <- -Inf
  } else {
    feasable.index <- constraint(X) < c.lambda
    feasable.x <- X[feasable.index]
    feasable.y <- y[feasable.index]
    best.x <- feasable.x[which.max(feasable.y)]
    best.y <- max(feasable.y)
  }
  
  return(list(mean=fs, 
              cov=sigma, 
              mean.c=fs.c,
              cov.c=sigma.c,
              best.x=best.x, 
              best.y=best.y))
}

acq.func <- function(gp.model, x) {
  return(acq.func.cei(gp.model, x))
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

acq.func.pf <- function(gp.model, x) {
  return(pnorm(c.lambda, mean=gp.model$mean.c(x), sd=sqrt(gp.model$cov.c(x))))
}

acq.func.cei <- function(gp.model, x) {
  ei <- acq.func.ei(gp.model, x)
  pf <- acq.func.pf(gp.model, x)
  return(ei*pf)
}

x.limits <- c(0, 10)
y.limits <- c(-3, 3)
n.iterations <- 30

x.plt <- seq(0, 10, .01)
xx <- x.plt
yy <- f(xx)
df <- data.frame(x=xx, y=yy)

df.constraint <- data.frame(xmin=xx, ymin=-Inf, ymax=Inf, fill=constraint(xx)<c.lambda)
rect.bounds <- c(df.constraint$fill,T) != c(!df.constraint[1,'fill'],df.constraint$fill)
rect.bounds[nrow(df.constraint)] <- TRUE
df.constraint <- df.constraint[rect.bounds,]
df.constraint$xmax <- c(df.constraint[2:nrow(df.constraint),'xmin'], -1)
df.constraint <- df.constraint[1:(nrow(df.constraint)-2),]

plt.f <- ggplot(df, aes(x=x, y=y)) + 
  geom_rect(data=df.constraint, inherit.aes = FALSE, mapping=aes(xmin=xmin, xmax=xmax, ymin=ymin, ymax=ymax, fill=fill), alpha=.2) +
  geom_line(size=2, alpha=.3) +
  scale_fill_manual(name='Region', breaks=c(FALSE, TRUE), values=c('red', 'green'), labels=c('Unfeasable', 'Feasable')) +
  xlim(x.limits) +
  # ylim(y.limits)
  theme(legend.position = "none")
plt.f

observed.x <- numeric(0)
observed.y <- numeric(0)
observed.c <- numeric(0)

set.seed(1)

for(n in seq(n.iterations)) {
  gp.model <- calculate.regression.model(observed.x, observed.y, observed.c)
  
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
  
  plt <- plt +
    geom_line(data=df, linetype='solid', color='blue', size=2) +
    geom_ribbon(data=df, aes(ymin=ymin, ymax=ymax), fill='blue', alpha=.2) +
    geom_vline(xintercept = next.candidate, linetype='dashed') +
    geom_point(data=points.df, color='black', size=3)
  
  yy.ei <- sapply(xx, function(x) acq.func.ei(gp.model,x))
  df.ei <- data.frame(x=xx, y=yy.ei, ymin=yy.ei-ss, ymax=yy.ei+ss)
  ei.plt <- ggplot(df.ei, aes(x=x, y=y, ymin=ymin, ymax=ymax)) + 
    geom_line() +
    geom_vline(xintercept = next.candidate, linetype='dashed') +
    ylab('Expected Improvement')
  
  yy.c <- sapply(xx, function(x) acq.func.pf(gp.model,x))
  df.c <- data.frame(x=xx, y=yy.c, ymin=yy.c-ss, ymax=yy.c+ss, fill=yy.c > .5)
  df.c$xmin <- df.c$x
  df.c$xmax <- df.c$x + .01
  c.plt <- ggplot(df.c, aes(x=x, y=y, ymin=ymin, ymax=ymax)) + 
    geom_rect(inherit.aes = FALSE, mapping=aes(xmin=xmin, xmax=xmax, fill=fill, color=fill), ymin=-Inf, ymax=Inf, alpha=.1) +
    geom_line() +
    geom_vline(xintercept = next.candidate, linetype='dashed') +
    ylim(0,1) +
    ylab('Probability of Feasibility') +
    scale_fill_manual(name='Region', breaks=c(FALSE, TRUE), values=c('red', 'green'), labels=c('Unfeasable', 'Feasable')) +
    scale_color_manual(name='Region', breaks=c(FALSE, TRUE), values=c('red', 'green'), labels=c('Unfeasable', 'Feasable')) +
    theme(legend.position = "none")
  
  observed.x <- c(observed.x, next.candidate)
  observed.y <- c(observed.y, f(next.candidate))
  observed.c <- c(observed.c, constraint(next.candidate))
  
  df.acq <- data.frame(x=xx, y=yy.acq)
  acq.plt <- ggplot(df.acq, aes(x=x, y=y)) +
    geom_line() +
    geom_vline(xintercept = next.candidate, linetype='dashed') +
    ylab('Acquisition measure') +
    xlim(x.limits)
  
  plt2 <- plot_grid(plt, ei.plt, c.plt, acq.plt, nrow=4, align='v')
  print(plt2)
  
  browser()
}

