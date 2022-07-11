library(ggplot2)

algs <- c(
  'nelder-mead',
  'annealing', 
  'pso'
  )

dff <- data.frame()
for(alg in algs) {
  for(n in seq(9)) {
    df <- read.csv(paste0('output/', alg, '_', n, '_trace.csv'))
    df$alg <- alg
    df$n_matrices <- as.character(n)
    dff <- rbind(dff, df)
    
    df2 <- df
    df2$alg <- paste0(alg, '_smoothed')
    df2$error <- cummin(df2$error)
    dff <- rbind(dff, df2)
    cat(paste0(alg, ' n=', n, '\n'))
  }
}

# Plots by algorithm
for(alg in algs) {
  png(paste0('output/alg_', alg, '.png'), width=1000, height=600)
  plt <- ggplot(dff[dff$alg==alg,], aes(x=index, y=error, color=n_matrices)) + 
    geom_line() +
    scale_x_continuous(labels=function(x) format(x, scientific=F, big.mark=',')) +
    scale_y_continuous(limits=c(0,10)) +
    xlab('Evaluations') +
    ylab('Error')
  # ggsave(plot=plt, filename=paste0('output/alg_', alg, '.png'), width = 10, height=10)
  print(plt)
  dev.off()
  
  png(paste0('output/alg_', alg, '_smoothed.png'), width=1000, height=600)
  plt <- ggplot(dff[dff$alg==paste0(alg, '_smoothed'),], aes(x=index, y=error, color=n_matrices)) + 
    geom_line() +
    scale_x_continuous(labels=function(x) format(x, scientific=F, big.mark=',')) +
    scale_y_continuous(limits=c(0,10)) +
    xlab('Evaluations') +
    ylab('Error')
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
    xlab('Evaluations') +
    ylab('Error')
  # ggsave(plot=plt, filename=paste0('output/alg_', alg, '.png'), width = 10, height=10)
  print(plt)
  dev.off()
  
  png(paste0('output/n_', n, '_smoothed.png'), width=1000, height=600)
  plt <- ggplot(df.p[endsWith(df.p$alg, '_smoothed'),], aes(x=index, y=error, color=alg)) + 
    geom_line() +
    scale_x_continuous(labels=function(x) format(x, scientific=F, big.mark=',')) +
    scale_y_continuous(limits=c(0,max(df.p$error))) +
    xlab('Evaluations') +
    ylab('Error')
  # ggsave(plot=plt, filename=paste0('output/alg_', alg, '.png'), width = 10, height=10)
  print(plt)
  dev.off()
}
