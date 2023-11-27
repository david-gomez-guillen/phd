library(ggplot2)
library(gridExtra)
library(ggpubr)
library(plotly)
library(svglite)
library(dplyr)

x.vals <- seq(0, 5, .05)

# df.p2 <- read.csv('output/plot_n1_figure.csv')
# 
# plt <- ggplot(df.p2, aes(x=index, y=error, color=alg)) +
#   geom_line() +
#   scale_x_continuous(limits=c(0,2000), labels=function(x) format(x, scientific=F, big.mark=',')) +
#   scale_y_continuous(limits=c(0.5,1.5)) +
#   scale_color_manual(breaks=c(
#     'nelder-mead_smoothed',
#     'annealing_smoothed',
#     'pso_smoothed',
#     'bayesian_smoothed'
#     ),
#                      labels=c(
#                        'Nelder-Mead',
#                        'Simulated Annealing',
#                        'PSO',
#                        'Bayesian optimization' ),
#                      values=c('black', 'blue', 'green', 'red'),
#                      name='Method') +
#   xlab('Number of model evaluations') +
#   ylab('Error') +
#   theme_bw()
# print(plt)
# # ggsave(file="methods_n1.pdf", plot=plt, width=3500, height=1500, units = 'px')


# clm <- function(formula, data, weights) {
#   lm(log10(y)~x, data=data, weight=weight)
# }

# 1 matrix
df.bo <- data.frame(tsim=seq(0,5,1),
                    t=c(142.14, 247.45, 352.55, 459.45, 567.51, 675.57)) # error=0.1128
df.bo$method <- 'bo'
df.nm <- data.frame(tsim=c(0, 2, 4, 6),
                    t=c(.95, 1681.5, 3361.36, 5041)) # error=0.1685
df.nm$method <- 'nm'
df.sa <- data.frame(tsim=c(0, 0.5, 1),
                    t=c(21.24,11409.5,22776.7)) # error=0.1129
df.sa$method <- 'sa'
df.pso <- data.frame(tsim=c(0, 2, 4, 6),
                     t=c(5.11, 10375.11, 20739.7, 31104.3)) # error=0.1127, 50 max iters and particles
df.pso$method <- 'pso'

df.pso.p <- df.pso
df.pso.p$method <- 'pso.p'
df.pso.p$t <- df.pso.p$t / 8

df <- bind_rows(
  df.bo, 
  df.nm, 
  #df.sa,
  # df.pso.p,
  #df.pso
  )

lm.nm <- lm((t)~tsim, data=df[df$method=='nm',])
# lm.sa <- lm((t)~tsim, data=df[df$method=='sa',])
# lm.pso <- lm((t)~tsim, data=df[df$method=='pso',])
# lm.pso.p <- lm.pso
# lm.pso.p$coefficients[2] <- lm.pso.p$coefficients[2] / 8
lm.bo <- lm((t)~tsim, data=df[df$method=='bo',])
lms <- list(nm=lm.nm, 
            # sa=lm.sa, 
            # pso=lm.pso, 
            # pso.p=lm.pso.p, 
            bo=lm.bo)

df.p <- data.frame()
for(m in c('nm', 
           #'sa', 
           #'pso', 
           # 'pso.p', 
           'bo')) {
  df.p <- rbind(df.p, data.frame(tsim=x.vals,
                                 t=predict(lms[[m]], data.frame(tsim=x.vals)),
                                 method=m))
}


plt1 <- ggplot(df.p, aes(x=tsim, y=log10(t/60), color=method, fill=method)) + 
  geom_line() +
  # geom_point() +
  # geom_smooth(data=df[df$method!='bo',],method=lm, fullrange=TRUE, se=FALSE) +
  # geom_smooth(data=df[df$method=='bo',],method=lm, fullrange=TRUE, se=TRUE) +
  coord_cartesian(xlim=range(x.vals), ylim=c(0,3)) +
  xlab('Model simulation time (seconds)') +
  ylab('Total calibration time (log minutes)') +
  ggtitle('Calibration of 1 age group\n (11 parameters)') +
  theme_minimal() +
  theme(legend.position='bottom', plot.title=element_text(hjust=0.5)) +
  scale_color_discrete(name='Method', 
                       breaks=c('nm', 
                                'sa', 
                                'pso', 
                                # 'pso.p', 
                                'bo'), 
                       labels=c('Best alternative',
                                'Simulated Annealing',
                                'Particle Swarm', 
                                # 'Particle Swarm (8 cores)', 
                                'Bayesian')) +
  scale_fill_discrete(name='Method', 
                      breaks=c('nm', 
                               'sa', 
                               'pso', 
                               # 'pso.p', 
                               'bo'), 
                      labels=c('Best alternative',
                               'Simulated Annealing',
                               'Particle Swarm', 
                               # 'Particle Swarm (8 cores)', 
                               'Bayesian'))
print(plt1)
# print(ggplotly(plt1))
# ggsave('C:/Users/47873315B/OneDrive - Generalitat de Catalunya/PhD/docs/CCIA2023/figs/sim_times_t1.pdf', plt1, units='px', height=1000, width = 2000)



# 2 matrices
# df.bo <- data.frame(method=rep('bo', 7),
#                     tsim=c(0.5,1,1.5,2,2.5,3,3.5),
#                     t=c(594.58,657.53,722.06,732.29,814.84,886.18,897.85))
df.bo <- data.frame(tsim=c(0, 1, 2, 3, 4, 5),
                    t=c(689.38, 672.74, 889.9, 960.96, 1077, 1306.8)) # error=0.11506
df.bo$method <- 'bo'
df.nm <- data.frame(tsim=c(0,1,2,3),
                    t=c(5.983, 1966.98,3930.09,5893.29)) # error=0.1129
df.nm$method <- 'nm'
df.sa <- data.frame(tsim=c(1,2),
                    t=c(47538,94962)) # error=0.1133
df.sa$method <- 'sa'
df.pso <- data.frame(tsim=c(0, 2, 4, 6),
                     t=c(6.01, 12199.6, 24385.9, 36572.5)) # error=0.117, 100 max iters and particles
df.pso$method <- 'pso'

df.pso.p <- df.pso
df.pso.p$method <- 'pso.p'
df.pso.p$t <- df.pso.p$t / 8

df <- bind_rows(
  df.bo, 
  df.nm, 
  #df.sa,
  # df.pso.p,
  #df.pso
)

lm.nm <- lm((t)~tsim, data=df[df$method=='nm',])
# lm.sa <- lm((t)~tsim, data=df[df$method=='sa',])
# lm.pso <- lm((t)~tsim, data=df[df$method=='pso',])
# lm.pso.p <- lm.pso
# lm.pso.p$coefficients[2] <- lm.pso.p$coefficients[2] / 8
lm.bo <- lm((t)~tsim, data=df[df$method=='bo',])
lms <- list(
  nm=lm.nm, 
  #sa=lm.sa, 
  #pso=lm.pso, 
  #pso.p=lm.pso.p, 
  bo=lm.bo
  )

df.p <- data.frame()
for(m in c('nm', 
           #'sa', 
           #'pso', 
           # 'pso.p', 
           'bo')) {
  df.p <- rbind(df.p, data.frame(tsim=x.vals,
                                 t=predict(lms[[m]], data.frame(tsim=x.vals)),
                                 method=m))
}

plt2 <- ggplot(df.p, aes(x=tsim,y=log10(t/60), color=method)) + 
  geom_line() +
  # geom_point() +
  # geom_smooth(data=df[df$method!='bo',],method=lm, fullrange=TRUE, se=FALSE) +
  # geom_smooth(data=df[df$method=='bo',],method=lm, fullrange=TRUE, se=TRUE) +
  coord_cartesian(xlim=range(x.vals), ylim=c(0,3)) +
  xlab('Model simulation time (seconds)') +
  ylab('Total calibration time (log minutes)') +
  ggtitle('Calibration of 2 age groups\n (22 parameters)') +
  theme_minimal() +
  theme(legend.position='bottom', plot.title=element_text(hjust=0.5)) +
  scale_color_discrete(name='Method', 
                       breaks=c('nm', 
                                'sa', 
                                'pso', 
                                # 'pso.p', 
                                'bo'), 
                       labels=c('Best alternative',
                                'Simulated Annealing',
                                'Particle Swarm', 
                                # 'Particle Swarm (8 cores)', 
                                'Bayesian')) +
  scale_fill_discrete(name='Method', 
                      breaks=c('nm', 
                               'sa', 
                               'pso', 
                               # 'pso.p', 
                               'bo'), 
                      labels=c('Best alternative',
                               'Simulated Annealing',
                               'Particle Swarm', 
                               # 'Particle Swarm (8 cores)', 
                               'Bayesian'))
print(plt2)
# print(ggplotly(p<lt2))
# ggsave('C:/Users/47873315B/OneDrive - Generalitat de Catalunya/PhD/docs/CCIA2023/figs/sim_times_t2.pdf', plt2, units='px', height=1000, width = 2000)






# 3 matrices
df.bo <- data.frame(tsim=c(0,1,2),
                    t=c(4003.4,4627.8,4697)) # error=0.149
df.bo$method <- 'bo'
df.nm <- data.frame(tsim=c(0,2,4,6),
                    t=c(5.16, 9400.7,18790.4,28179.8)) # error=0.1132
df.nm$method <- 'nm'
df.sa <- data.frame(tsim=c(0, .5, 1),
                    t=c(82.5, 39787, 79410)) # error=0.1134
df.sa$method <- 'sa'
df.pso <- data.frame(tsim=c(0,2),
                     t=c(36.38, 69063)) # error=0.1174, 750 particles
df.pso$method <- 'pso'

df.pso.p <- df.pso
df.pso.p$method <- 'pso.p'
df.pso.p$t <- df.pso.p$t / 8

df <- bind_rows(
  df.bo, 
  df.nm, 
  #df.sa,
  # df.pso.p,
  #df.pso
)

lm.nm <- lm((t)~tsim, data=df[df$method=='nm',])
# lm.sa <- lm((t)~tsim, data=df[df$method=='sa',])
# lm.pso <- lm((t)~tsim, data=df[df$method=='pso',])
# lm.pso.p <- lm.pso
# lm.pso.p$coefficients[2] <- lm.pso.p$coefficients[2] / 8
lm.bo <- lm((t)~tsim, data=df[df$method=='bo',])
lms <- list(
  nm=lm.nm, 
  # sa=lm.sa, 
  # pso=lm.pso, 
  # pso.p=lm.pso.p, 
  bo=lm.bo
  )

df.p <- data.frame()
for(m in c('nm', 
           #'sa', 
           #'pso', 
           # 'pso.p', 
           'bo')) {
  df.p <- rbind(df.p, data.frame(tsim=x.vals,
                                 t=predict(lms[[m]], data.frame(tsim=x.vals)),
                                 method=m))
}

plt3 <- ggplot(df.p, aes(x=tsim,y=log10(t/60), color=method)) + 
  geom_line() +
  # geom_point() +
  # geom_smooth(data=df[df$method!='bo',],method=lm, fullrange=TRUE, se=FALSE) +
  # geom_smooth(data=df[df$method=='bo',],method=lm, fullrange=TRUE, se=TRUE) +
  coord_cartesian(xlim=range(x.vals), ylim=c(0,3)) +
  xlab('Model simulation time (seconds)') +
  ylab('Total calibration time (log minutes)') +
  ggtitle('Calibration of 3 age groups\n (33 parameters)') +
  theme_minimal() +
  theme(legend.position='bottom', plot.title=element_text(hjust=0.5)) +
  scale_color_discrete(name='Method', 
                       breaks=c('nm', 
                                'sa', 
                                'pso', 
                                # 'pso.p', 
                                'bo'), 
                       labels=c('Best alternative',
                                'Simulated Annealing',
                                'Particle Swarm', 
                                # 'Particle Swarm (8 cores)', 
                                'Bayesian')) +
  scale_fill_discrete(name='Method', 
                      breaks=c('nm', 
                               'sa', 
                               'pso', 
                               # 'pso.p', 
                               'bo'), 
                      labels=c('Best alternative',
                               'Simulated Annealing',
                               'Particle Swarm', 
                               # 'Particle Swarm (8 cores)', 
                               'Bayesian'))
print(plt3)
# print(ggplotly(plt3))
# ggsave('C:/Users/47873315B/OneDrive - Generalitat de Catalunya/PhD/docs/CCIA2023/figs/sim_times_t3.pdf', plt3, units='px', height=1000, width = 2000)






# 4 matrices
df.bo <- data.frame(tsim=c(0,1,2),
                    t=c(17123,17754,20077)) # error=0.224
df.bo$method <- 'bo'
df.nm <- data.frame(tsim=c(0,2,4,6),
                    t=c(7.57, 13408, 26799, 40191)) # error=0.1557
df.nm$method <- 'nm'
df.sa <- data.frame(tsim=c(0, 1),
                    t=c(158.7, 158.7+146411)) # error=0.156
df.sa$method <- 'sa'
df.pso <- data.frame(tsim=c(0,0.5,1),
                     t=c(52.7, 24109, 48115)) # error=0.157
df.pso$method <- 'pso'

df.pso.p <- df.pso
df.pso.p$method <- 'pso.p'
df.pso.p$t <- df.pso.p$t / 8

df <- bind_rows(
  df.bo, 
  df.nm, 
  #df.sa,
  # df.pso.p,
  #df.pso
)

lm.nm <- lm((t)~tsim, data=df[df$method=='nm',])
# lm.sa <- lm((t)~tsim, data=df[df$method=='sa',])
# lm.pso <- lm((t)~tsim, data=df[df$method=='pso',])
# lm.pso.p <- lm.pso
# lm.pso.p$coefficients[2] <- lm.pso.p$coefficients[2] / 8
lm.bo <- lm((t)~tsim, data=df[df$method=='bo',])
lms <- list(
  nm=lm.nm, 
  # sa=lm.sa, 
  # pso=lm.pso, 
  # pso.p=lm.pso.p, 
  bo=lm.bo)

df.p <- data.frame()
for(m in c('nm', 
           #'sa', 
           #'pso', 
           # 'pso.p', 
           'bo')) {
  df.p <- rbind(df.p, data.frame(tsim=x.vals,
                                 t=predict(lms[[m]], data.frame(tsim=x.vals)),
                                 method=m))
}

plt4 <- ggplot(df.p, aes(x=tsim,y=log10(t/60), color=method)) + 
  geom_line() +
  # geom_point() +
  # geom_smooth(data=df[df$method!='bo',],method=lm, fullrange=TRUE, se=FALSE) +
  # geom_smooth(data=df[df$method=='bo',],method=lm, fullrange=TRUE, se=TRUE) +
  # geom_smooth(method=lm, fullrange=TRUE, se=TRUE) +
  # stat_function(fun=function(x){
  #   coef <- lm.bo$coefficients
  #   return(log10(coef[1] + coef[2]*x))
  # }) +
  coord_cartesian(xlim=range(x.vals), ylim=c(0,3)) +
  xlab('Model simulation time (seconds)') +
  ylab('Total calibration time (log minutes)') +
  ggtitle('Calibration of 4 age groups\n (44 parameters)') +
  theme_minimal() +
  theme(legend.position='bottom', plot.title=element_text(hjust=0.5)) +
  scale_color_discrete(name='Method', 
                       breaks=c('nm', 
                                'sa', 
                                'pso', 
                                # 'pso.p', 
                                'bo'), 
                       labels=c('Best alternative',
                                'Simulated Annealing',
                                'Particle Swarm', 
                                # 'Particle Swarm (8 cores)', 
                                'Bayesian')) +
  scale_fill_discrete(name='Method', 
                      breaks=c('nm', 
                               'sa', 
                               'pso', 
                               # 'pso.p', 
                               'bo'), 
                      labels=c('Best alternative',
                               'Simulated Annealing',
                               'Particle Swarm', 
                               # 'Particle Swarm (8 cores)', 
                               'Bayesian'))
print(plt4)
# print(ggplotly(plt4))
# ggsave('C:/Users/47873315B/OneDrive - Generalitat de Catalunya/PhD/docs/CCIA2023/figs/sim_times_t3.pdf', plt3, units='px', height=1000, width = 2000)







# 9 matrices
# df.bo <- data.frame(tsim=c(0.5,1,1.5,2,2.5,3,3.5),
#                     t=c(594.58,657.53,722.06,732.29,814.84,886.18,897.85))
# df.bo$method <- 'bo'
# df.nm <- data.frame(tsim=c(0, 5),
#                     t=c(214.66, 214.66+5*151334)) # error = 78.87
# df.nm$method <- 'nm'
# df.sa <- data.frame(tsim=c(0, 5),
#                     t=c(1331.73, 1331.73+5*971401)) # error = 78.5
# df.sa$method <- 'sa'
# df.pso <- data.frame(tsim=c(0, 2, 4, 6),
#                      t=c(14.64,  20250.19, 40471.2, 60692)) # error=97.67
# df.pso$method <- 'pso'
# 
# df.pso.p <- df.pso
# df.pso.p$method <- 'pso.p'
# df.pso.p$t <- df.pso.p$t / 8
# 
# df <- bind_rows(
#   # df.bo, 
#   df.nm, 
#   df.sa,
#   df.pso, 
#   df.pso.p
#   )
# 
# plt9 <- ggplot(df, aes(x=tsim,y=t/60, color=method)) + 
#   # geom_point() +
#   geom_smooth(method=lm, fullrange=TRUE) +
#   coord_cartesian(xlim=c(0,2), ylim=c(0,500)) +
#   xlab('Model simulation time (seconds)') +
#   ylab('Total calibration time (minutes)') +
#   ggtitle('Calibration of 9 age groups (99 parameters)') +
#   theme_minimal() +
#   theme(legend.position='bottom') +
#   scale_color_discrete(name='Method', 
#                        breaks=c('nm', 'sa', 'pso', 'pso.p', 'bo'), 
#                        labels=c('Nelder-Mead',
#                                 'Simulated Annealing',
#                                 'Particle Swarm', 
#                                 'Particle Swarm (8 cores)', 
#                                 'Bayesian'))
# print(plt9)
# print(ggplotly(plt9))
# ggsave('C:/Users/47873315B/OneDrive - Generalitat de Catalunya/PhD/docs/CCIA2023/figs/sim_times_t9.pdf', plt9, units='px', height=1000, width = 2000)




plt <- ggarrange(plt1, 
                 plt2 + ylab(''), 
                 plt3 + ylab(''), 
                 plt4 + ylab(''),
                 nrow=1, 
                 common.legend=TRUE, 
                 legend='bottom',
                 label.x = 'Model simulation time (seconds)',
                 label.y = 'Total calibration time (minutes)')
# plt <- ggarrange(plt1, plt2,
#                  nrow=1, 
#                  common.legend=TRUE, 
#                  legend='bottom',
#                  label.x = 'Model simulation time (seconds)',
#                  label.y = 'Total calibration time (minutes)')
print(plt)
# ggsave('output/sim_times.pdf', plt, units='px', height=1200, width = 3200)


df.tcrit <- data.frame(n.mat=c(11,22,33,44), tcrit=c(.2, .35, .95, 3.25))
lm.tcrit <- lm(log10(tcrit)~n.mat, data=df.tcrit)

df.p <- data.frame(n.mat=seq(11,99,11/2),
                   tcrit=10^(predict(lm.tcrit, data.frame(n.mat=seq(11,99,11/2)))))

plt <- ggplot(df.tcrit, aes(x=n.mat, y=log10(tcrit))) +
  geom_point() +
  geom_line(data=df.p) +
  theme_minimal() +
  coord_cartesian(xlim=c(11,99), ylim=c(-1,2.5)) +
  scale_x_continuous(breaks=seq(11,99,11)) +
  xlab('Number of parameters') +
  ylab('Critical time (log s)')
print(plt)
# ggsave('C:/Users/47873315B/OneDrive - Generalitat de Catalunya/PhD/docs/CCIA2023/figs/crit_times_log.pdf', plt, units='px', height=1000, width = 2000)

plt <- ggplot(df.tcrit, aes(x=n.mat, y=tcrit)) +
  geom_point() +
  geom_line(data=df.p) +
  theme_minimal() +
  scale_x_continuous(breaks=1:9) +
  xlab('Age groups') +
  ylab('Critical time (s)')
print(plt)
# ggsave('C:/Users/47873315B/OneDrive - Generalitat de Catalunya/PhD/docs/CCIA2023/figs/crit_times.pdf', plt, units='px', height=1000, width = 2000)
