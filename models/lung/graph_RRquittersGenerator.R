
library(ggplot2)
library(RColorBrewer)

n.time.steps <- 30.5*12
time.steps   <- (1:n.time.steps-1)/12

rr.smokers <- 20
quit.effect.years <- 15
quit.rr.after.years <- 0.2
quit.rr.monthly <- quit.rr.after.years^(1/(quit.effect.years*12)) # reducció 80% als 15 anys

brewer.colors=c('#66c2a5','#8da0cb','#e78ac3','#a6d854','#fc8d62')

df.smoker <- data.frame(smoker="current",
                 time=time.steps,
                 risk=rr.smokers)

df.aux <- data.frame(smoker="never",
                     time=time.steps,
                     risk=1)
df <- rbind(df.smoker, df.aux)
df.logist <- df


pbase <- ggplot(df, aes(x=time, y=risk, color=smoker)) +
  geom_line(aes(group=smoker), size=1) +
  scale_x_continuous() +
  scale_y_continuous(limits = c(0,rr.smokers)) +
  theme(axis.text.y = element_blank(),
        legend.title = element_blank(),
        legend.position = 'bottom',
        legend.background = element_rect(fill="gray90")) +
  scale_colour_manual(values=brewer.colors[c(1,2)],
                      labels=c(' current    ', ' never'))

### CONSTANT
risk.constant <- c(rep(rr.smokers, quit.effect.years*12), rep(quit.rr.after.years*rr.smokers, (n.time.steps-quit.effect.years*12)))
df.constant <- data.frame(smoker="former-const",
                          time=time.steps,
                          risk=risk.constant)

df.const.plot <- rbind(df.smoker, df.constant, df.aux)


### LINEAL
risk.linear <- c((rr.smokers*(quit.rr.after.years-1)/(quit.effect.years*12))*(1:(quit.effect.years*12)-1)+rr.smokers,
                 rep(rr.smokers*quit.rr.after.years,n.time.steps-quit.effect.years*12))
hit.point <- floor((1-rr.smokers)*12*quit.effect.years/(rr.smokers*(quit.rr.after.years-1)))
risk.linear.ref <- c((rr.smokers*(quit.rr.after.years-1)/(quit.effect.years*12))*(1:(hit.point+1)-1)+rr.smokers,
                    rep(1,n.time.steps-hit.point-1))
df.linear <- data.frame(smoker="former-lin",
                        time=time.steps,
                        risk=risk.linear)
df.linref <- data.frame(smoker="former-lin",
                        time=time.steps,
                        risk=risk.linear.ref)
df.lin.plot <- rbind(df.smoker, df.linear, df.aux)
df.linref.plot <- rbind(df.smoker, df.aux, df.linear, df.linref)


### EXPONENCIAL
risk.exponential <- rr.smokers*(quit.rr.monthly^(1:n.time.steps-1))
risk.exponential <- ifelse(risk.exponential > 1, risk.exponential, 1)
df.exponential <- data.frame(smoker="former-exp",
                             time=time.steps,
                             risk=risk.exponential)
df.exp.plot <- rbind(df.smoker, df.exponential, df.aux)


### LOGISTIC (combined)
X <- time.steps
y0 <- rr.smokers*(quit.rr.after.years*exp(quit.effect.years/6)+quit.rr.after.years-1)/exp(quit.effect.years/6)
Y <- y0 + (rr.smokers-y0)/(1+exp((X-2*quit.effect.years/3)/2))
df.risk.new <- data.frame(smoker='logistic', time=X[1:(12*quit.effect.years)], risk=Y[1:(12*quit.effect.years)])
df.risk.new <- rbind(df.risk.new, data.frame(smoker='logistic', time=X[(12*quit.effect.years+1):360], risk=risk.exponential[(12*quit.effect.years+1):360]))
df.new.plot <- rbind(df.smoker, df.risk.new, df.aux)


### PLOT ATTRIBUTES
plot.generic <- ggplot(df.const.plot[0,], aes(x=time, y=risk, color=smoker)) +
  geom_line(aes(group=smoker), size=1) +
  theme_bw(base_size = 16) +
  theme(axis.title.y = element_text(size=14),
        axis.title.x = element_text(size=14, margin= margin(12,0,0,0)),
        axis.text.y = element_text(size=12),
        axis.text.x = element_text(size=11),
        axis.line = element_line(), #legend.title = element_blank(),
        legend.position = 'bottom',
        legend.background = element_rect(linetype = 'solid', colour='black'),
        legend.margin = margin(8,8,8,8),
        legend.key.width = unit(1.4,'cm'),
        legend.box.margin = margin(10,0,0,0),
        legend.title = element_text(size=12, face = 'bold'),
        legend.text = element_text(size=12),
        panel.border = element_blank(),
        panel.grid.minor.y = element_blank()) +
  scale_x_continuous(name='time since quitting (years)', limits = c(0,30.5), expand = c(0,0),
                     breaks = seq(0,30,10), minor_breaks = seq(0,30,5)) +
  scale_y_continuous(name='relative risk of developing LC',limits = c(0,rr.smokers+1), expand = c(0,0),
                     breaks = c(1,rr.smokers/5,rr.smokers/2,rr.smokers),
                     labels = c('ref. risk',expression(0.2*' R'), expression(0.5*' R'),'R')) +
  scale_colour_manual(values=brewer.colors[c(2,5,1)],
                      labels=c('Current  ', 'Former  ', 'Never'),
                      name='Smoking status:    ')


pconst <- plot.generic
pconst$data <- df.const.plot

plin <- plot.generic
plin$data <- df.lin.plot

pnew <- plot.generic
pnew$data <- df.new.plot


#setwd("C:/Users/45790702w/Documents/TFM calaix/Figures no provisionals")
ggsave(filename = "quittingEffectConst.png"   , pconst, width = 16, height = 12, units = "cm")
ggsave(filename = "quittingEffectLin.png"     , plin  , width = 16, height = 12, units = "cm")
ggsave(filename = "quittingEffectLogistic.png", pnew  , width = 16, height = 12, units = "cm")




X <- seq(0.01,2,0.01)
Ye <- exp(X)
Yl <- log(X)
df <- data.frame()
df <- rbind(df, data.frame(z='exp', x=X, y=Ye))
df <- rbind(df, data.frame(z='log', x=X, y=Yl))
df <- rbind(df, data.frame(z='ref', x=X, y=X))
ptest <- ggplot(df, aes(x=x, y=y, color=z)) +
  geom_line(aes(group=z))
ptest

# polynomial approximation
lambda <- -1
M <- matrix(c(1003, 100.2, 10.01, 1,
              3375, 225, 15, 1,
              675, 30, 1, 0,
              300.6, 20.02, 1, 0), nrow = 4, byrow = TRUE)
b <- c(12.42, 4, -0.02127, -1)
pol <- solve(M, b)

Xpol <- seq(10, 15, 0.1)
Ypol <- pol[1]*Xpol^3 + pol[2]*Xpol^2 + pol[3]*Xpol + pol[4]
df <- rbind(df, data.frame(z='pol', x=Xpol, y=Ypol))





