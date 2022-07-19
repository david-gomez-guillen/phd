library(ggplot2)
library(dplyr)
library(plotly)

algs <- c(
  'nelder-mead'
  ,'annealing'
  ,'pso'
  # ,'bayesian'
  )

dff <- data.frame()
for(n in seq(9)) {
  for(alg in algs) {
    df <- read.csv(paste0('output/', alg, '_', n, '_trace.csv'))
    df$alg <- alg
    df$n_matrices <- as.character(n)
    dff <- bind_rows(dff, df)
    
    df2 <- df
    df2$alg <- paste0(alg, '_smoothed')
    df2$error <- cummin(df2$error)
    dff <- bind_rows(dff, df2)
    cat(paste0(alg, ' n=', n, '\n'))
  }
  
  df <- read.csv(paste0('output/gpu/bayesian_', n, '_trace.csv'))
  df$alg <- 'bayesian'
  df$n_matrices <- as.character(n)
  df$type <- 'gpu'
  dff <- bind_rows(dff, df)
  
  df2 <- df
  df2$alg <- paste0('bayesian_smoothed')
  df2$error <- cummin(df2$error)
  dff <- bind_rows(dff, df2)
  
  df <- read.csv(paste0('output/cpu/bayesian_', n, '_trace.csv'))
  df$alg <- 'bayesian'
  df$n_matrices <- as.character(n)
  df$type <- 'cpu'
  dff <- bind_rows(dff, df)
  
  df2 <- df
  df2$alg <- paste0('bayesian_smoothed')
  df2$error <- cummin(df2$error)
  dff <- bind_rows(dff, df2)
  
  cat(paste0('bayesian n=', n, '\n'))
}

# Error plots by algorithm
for(alg in algs) {
  png(paste0('output/alg_', alg, '.png'), width=1000, height=600)
  plt <- ggplot(dff[dff$alg==alg,], aes(x=index, y=error, color=n_matrices)) + 
    geom_line() +
    scale_x_continuous(labels=function(x) format(x, scientific=F, big.mark=',')) +
    scale_y_continuous(limits=c(0,10)) +
    xlab('Evaluations') +
    ylab('Error') +
    ggtitle(paste0(alg, ' by n_matrices'))
  # ggsave(plot=plt, filename=paste0('output/alg_', alg, '.png'), width = 10, height=10)
  print(plt)
  dev.off()
  
  png(paste0('output/alg_', alg, '_smoothed.png'), width=1000, height=600)
  plt <- ggplot(dff[dff$alg==paste0(alg, '_smoothed'),], aes(x=index, y=error, color=n_matrices)) + 
    geom_line() +
    scale_x_continuous(labels=function(x) format(x, scientific=F, big.mark=',')) +
    scale_y_continuous(limits=c(0,10)) +
    xlab('Evaluations') +
    ylab('Error') +
    ggtitle(paste0(alg, '(smoothed) by n_matrices'))
  # ggsave(plot=plt, filename=paste0('output/alg_', alg, '_smoothed.png'), width = 10, height=10)
  print(plt)
  dev.off()
}

# Plots by n_matrices
for(n in seq(9)) {
  png(paste0('output/n_', n, '.png'), width=1000, height=600)
  df.p <- dff[dff$n_matrices==n,]
  plt <- ggplot(df.p[!endsWith(df.p$alg, '_smoothed'),], aes(x=index, y=error, color=alg)) + 
    geom_line() +
    scale_x_continuous(labels=function(x) format(x, scientific=F, big.mark=',')) +
    scale_y_continuous(limits=c(0,max(df.p$error))) +
    xlab('Evaluation') +
    ylab('Error') +
    ggtitle(paste0('n_matrices = ', n, ' by method'))
  # ggsave(plot=plt, filename=paste0('output/alg_', alg, '.png'), width = 10, height=10)
  print(plt)
  dev.off()
  
  png(paste0('output/n_', n, '_smoothed.png'), width=1000, height=600)
  plt <- ggplot(df.p[endsWith(df.p$alg, '_smoothed'),], aes(x=index, y=error, color=alg)) + 
    geom_line() +
    scale_x_continuous(labels=function(x) format(x, scientific=F, big.mark=',')) +
    scale_y_continuous(limits=c(0,max(df.p$error))) +
    xlab('Evaluation') +
    ylab('Error') +
    ggtitle(paste0('n_matrices = ', n, ' by method (smoothed)'))
  # ggsave(plot=plt, filename=paste0('output/alg_', alg, '.png'), width = 10, height=10)
  print(plt)
  dev.off()
}

# BO time boxplots
plt <- ggplot(dff[dff$alg=='bayesian',], aes(x=index, y=time, color=n_matrices)) + 
  geom_boxplot() +
  xlab('Evaluation') +
  ylab('Time (s)') +
  ggtitle('BO iteration time boxplot by n_matrices')
print(plt)

# BO time plots by n_matrices
plt <- ggplot(dff[dff$alg=='bayesian',], aes(x=index, y=time, color=n_matrices, linetype=type)) + 
  geom_line() +
  xlab('Iteration') +
  ylab('Time (s)') +
  ggtitle('BO iteration time by iteration and n_matrices')
print(plt)

