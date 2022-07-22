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

### Bayesian outputs

dfb <- dff[dff$alg=='bayesian',]
dfb$label <- paste0(dfb$n_matrices, ' (', dfb$type, ')')

dfbs <- dfb.cpu %>% group_by(n_matrices) %>% summarise(avg.time=mean(time), median.time=median(time))
dfbs$n_matrices <- as.numeric(dfbs$n_matrices)

dfb.cpu <- dfb[dfb$type=='cpu',]
dfbs.cpu <- dfb.cpu %>% group_by(n_matrices) %>% summarise(avg.time=mean(time), median.time=median(time))
dfbs.cpu$n_matrices <- as.numeric(dfbs.cpu$n_matrices)

dfb.gpu <- dfb[dfb$type=='gpu',]
dfbs.gpu <- dfb.gpu %>% group_by(n_matrices) %>% summarise(avg.time=mean(time), median.time=median(time))
dfbs.gpu$n_matrices <- as.numeric(dfbs.gpu$n_matrices)

# m.mean.exp <- lm(log(avg.time)~n_matrices, dfbs)
# dfbs$expected.avg.time.exp <- exp(predict(m.mean.exp, list(n_matrices=dfbs$n_matrices)))
# 
# m.median <- lm(median.time~exp(n_matrices), dfbs)
# dfbs$expected.median.time <- exp(predict(m.median, list(n_matrices=dfbs$n_matrices)))
# 
# m.mean.squared <- lm(avg.time^(1/2)~n_matrices, dfbs)
# dfbs$expected.avg.time.squared <- exp(predict(m.mean.squared, list(n_matrices=dfbs$n_matrices)))
# 
# m.mean.cubic <- lm(avg.time^(1/3)~n_matrices, dfbs)
# dfbs$expected.avg.time.cubic <- exp(predict(m.mean.cubic, list(n_matrices=dfbs$n_matrices)))

# BO time plots by n_matrices
plt <- ggplot(dfb, aes(x=index, y=time, color=n_matrices, linetype=type)) + 
  geom_line() +
  xlab('Iteration') +
  ylab('Time (s)') +
  ggtitle('BO (CPU) iteration time by iteration and n_matrices')
print(plt)


# BO time boxplots (CPU & GPU)
plt <- ggplot(dfb, aes(x=n_matrices, y=time, fill=type)) + 
  geom_boxplot() +
  xlab('Number of matrices') +
  ylab('Time (s)') +
  ggtitle('BO (CPU) iteration time boxplot by n_matrices')
# scale_color_manual('', breaks=c('Exponential', 'Quadratic', 'Cubic'), values = c('red', 'blue', 'green'))
print(plt)


# BO time boxplots (CPU)
plt <- ggplot(dfb.cpu, aes(x=n_matrices, y=time)) + 
  geom_boxplot() +
  geom_point(data=dfbs.cpu, aes(x=n_matrices, y=avg.time), color='red', pch=18, size=4) +
  geom_smooth(data=dfbs.cpu, method='lm', formula=y~exp(x), aes(x=n_matrices, y=avg.time), color='red') +
  geom_smooth(data=dfbs.cpu, method='lm', formula=y~poly(x,2), aes(x=n_matrices, y=avg.time), color='blue') +
  geom_smooth(data=dfbs.cpu, method='lm', formula=y~poly(x,3), aes(x=n_matrices, y=avg.time), color='green') +
  xlab('Number of matrices') +
  ylab('Time (s)') +
  ggtitle('BO (CPU) iteration time boxplot by n_matrices')
# scale_color_manual('', breaks=c('Exponential', 'Quadratic', 'Cubic'), values = c('red', 'blue', 'green'))
print(plt)


# BO time boxplots (GPU)
plt <- ggplot(dfb.gpu, aes(x=n_matrices, y=time)) + 
  geom_boxplot() +
  geom_point(data=dfbs.gpu, aes(x=n_matrices, y=avg.time), color='red', pch=18, size=4) +
  geom_smooth(data=dfbs.gpu, method='lm', formula=y~exp(x), aes(x=n_matrices, y=avg.time), color='red') +
  geom_smooth(data=dfbs.gpu, method='lm', formula=y~poly(x,2), aes(x=n_matrices, y=avg.time), color='blue') +
  geom_smooth(data=dfbs.gpu, method='lm', formula=y~poly(x,3), aes(x=n_matrices, y=avg.time), color='green') +
  xlab('Number of matrices') +
  ylab('Time (s)') +
  ggtitle('BO (GPU Quadro P620) iteration time boxplot by n_matrices')
# scale_color_manual('', breaks=c('Exponential', 'Quadratic', 'Cubic'), values = c('red', 'blue', 'green'))
print(plt)
