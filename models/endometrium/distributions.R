BETA.PREFFIXES <- c('p_', '.p_', '.sensitivity_', '.specificity_', '.survival_', '.u_', 'u_', '.rate_')
GAMMA.PREFFIXES <- c('c_', '.c_',  'ly_', '.ly_', '.hr_', '.age_')

fit.parameter <- function(par, mean, sd, dist=NULL) {
  if (!is.null(dist)) {
    if (dist == 'beta') return(fit.beta(mean, sd))
    else if (dist == 'lognormal') return(fit.lognormal(mean,sd))
    else if (dist == 'gamma') return(fit.gamma(mean,sd))
    else if (dist == 'exponential') return(fit.exponential(mean))
    else stop(paste0('Distribution "', dist, '" not recognized'))
  }
  if (any(startsWith(par, BETA.PREFFIXES))) {
    if (mean %in% c(0,1))
      stop(paste0("A beta distribution cannot be fitted with mean ", mean, " ('", par, "')"))
    return(fit.beta(mean, sd))
  } else if (any(startsWith(par, GAMMA.PREFFIXES))) {
    return(fit.gamma(mean, sd))
  } else {
    stop(paste0('Distribution must be specified for parameter "', par, '"'))
  }
}

sample.parameter <- function(par, dist.params, dist=NULL) {
  if (!is.null(dist)) {
    if (dist == 'beta') return(rbeta(1, shape1=dist.params$alpha, shape2=dist.params$beta))
    else if (dist == 'lognormal') return(exp(rnorm(1, dist.params$mean, dist.params$sd)))
    else if (dist == 'gamma') return(rgamma(1, shape=dist.params$alpha, scale=dist.params$beta))
    else if (dist == 'exponential') return(rexp(1, rate=dist.params$lambda))
    else stop(paste0('Distribution "', dist, '" not recognized'))
  }
  if (any(startsWith(par, BETA.PREFFIXES))) {
    return(rbeta(1, shape1=dist.params$alpha, shape2=dist.params$beta))
  } else if (any(startsWith(par, GAMMA.PREFFIXES))) {
    return(rgamma(1, shape=dist.params$alpha, scale=dist.params$beta))
  } else {
    stop(paste0('Distribution must be specified for parameter "', par, '"'))
  }
}

fit.exponential <- function(mean) {
  return(list(lambda=1/mean))
}

fit.beta <- function(mean, sd) {
  if (sd^2 > mean*(1-mean)) {
    # TODO: Fix somehow
    # warning('Deviation too high for beta distribution, setting to (arbitrarily) [mean*(1-mean)/2]')
    sd <- sqrt(mean*(1-mean))/2
  }
  alpha_p_beta <- mean*(1-mean)/sd^2 - 1
  alpha <- mean*alpha_p_beta
  beta <- alpha_p_beta - alpha
  return(list(alpha=alpha, beta=beta))
}

fit.gamma <- function(mean, sd) {
  alpha <- mean^2/(sd^2)
  beta <- sd^2/mean
  return(list(alpha=alpha, beta=beta))
}

fit.lognormal <- function(mean, sd) {
  norm.mean <- 2*log(mean) - .5*log(sd^2+mean^2)
  norm.var <- -2*log(mean)+log(sd^2+mean^2)
  return(list(mean=norm.mean, sd=sqrt(norm.var)))
}