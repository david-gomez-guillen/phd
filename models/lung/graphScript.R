library(ggplot2)
library(cowplot)
library(tidyr)

MakeCalibrationGraphs <- function(observed.data, sim.pre, sim.post, age.groups,
                                  tstamp, weights_list) {
  # INCIDÈNCIA LC
  lc.inc.obs  <- observed.data$lc.incidence
  lc.inc.pre  <- apply(sim.pre$lc.incidence,  1, mean)
  lc.inc.post <- apply(sim.post$lc.incidence, 1, mean)

  d <- aggregate(cbind(lc.inc.obs,
                       lc.inc.pre,
                       lc.inc.post)
                 ~age.groups, FUN=mean)

  dd <- gather(d, value="rate", key="Origen", lc.inc.obs, lc.inc.pre, lc.inc.post)
  p1 <- ggplot(dd, aes(x=age.groups, y=rate, color=Origen)) +
    geom_line(aes(group=Origen)) +
    geom_point(aes(group=Origen)) +
    expand_limits(y=c(0,450)) +
    scale_colour_discrete(name="Pato",
                          breaks=c("lc.inc.obs", "lc.inc.pre", "lc.inc.post"),
                          labels=c("Observed", "Uncalibrated", "Calibrated")) +
    theme(legend.title = element_blank()) +
    ggtitle("LC Incidence")


  # MORTALITAT LC
  lc.mort.obs  <- observed.data$lc.mortality
  lc.mort.pre  <- apply(sim.pre$lc.mortality,  1, mean)
  lc.mort.post <- apply(sim.post$lc.mortality, 1, mean)

  d <- aggregate(cbind(lc.mort.obs,
                       lc.mort.pre,
                       lc.mort.post)
                 ~age.groups, FUN=mean)
  dd <- gather(d, value="rate", key="Origen", lc.mort.obs, lc.mort.pre, lc.mort.post)
  p2 <- ggplot(dd, aes(x=age.groups, y=rate, color=Origen)) +
    geom_line(aes(group=Origen)) +
    geom_point(aes(group=Origen)) +
    expand_limits(y=c(0,450)) +
    scale_colour_discrete(name="Pato",
                          breaks=c("lc.mort.obs", "lc.mort.pre", "lc.mort.post"),
                          labels=c("Observed", "Uncalibrated", "Calibrated")) +
    theme(legend.title = element_blank()) +
    ggtitle("LC Mortality")

  # MORTALITAT GENERAL
  tot.mort.obs  <- observed.data$tot.mortality
  tot.mort.pre  <- apply(sim.pre$tot.mortality,  1, mean)
  tot.mort.post <- apply(sim.post$tot.mortality, 1, mean)

  d <- aggregate(cbind(tot.mort.obs,
                       tot.mort.pre,
                       tot.mort.post)
                 ~age.groups, FUN=mean)
  dd <- gather(d, value="rate", key="Origen", tot.mort.obs, tot.mort.pre, tot.mort.post)
  p3 <- ggplot(dd, aes(x=age.groups, y=rate, color=Origen)) +
    geom_line(aes(group=Origen)) +
    geom_point(aes(group=Origen)) +
    expand_limits(y=c(0,4500)) +
    scale_colour_discrete(name="Pato",
                          breaks=c("tot.mort.obs", "tot.mort.pre", "tot.mort.post"),
                          labels=c("Observed", "Uncalibrated", "Calibrated")) +
    theme(legend.title = element_blank()) +
    ggtitle("Overall mortality")

  pg <- plot_grid(p1,p2,p3,ncol=3)
  title1 <- ggdraw() +
    draw_label(paste0("Calibration results (timestamp = ", tstamp, ")"), fontface='bold')
  title2 <- ggdraw() +
    draw_label(paste0("Calibration parameters: ",
                      paste(sapply(weights_list,
                                   function(v) {
                                     if (typeof(v) == "double") {
                                       return(paste(round(100*v/sum(v)), collapse = '-'))
                                     }
                                     else {
                                       return(paste(v, collapse = '-'))
                                     }
                                   }),
                            collapse=' + ')))
  pg <- plot_grid(title1, title2, pg, ncol=1, rel_heights = c(1,1,12))
  ggsave(filename = paste0("results/calibration_", tstamp, ".png"), plot = pg, width = 20, height = 5.67)

}



MakeComparativeGraphs <- function(observed.data, results, age.groups,
                                  title="Generic Graph Title", 
                                  subtitle=paste0("Observed data vs ", paste(names(results), collapse=", "))) {
  # INCIDÈNCIA LC
  lc.inc.obs  <- observed.data$lc.incidence
  lc.inc.res  <- lapply(results, function(x) apply(x$lc.incidence,  1, mean))

  d <- aggregate(cbind(lc.inc.obs,
                       do.call(cbind, lc.inc.res))
                 ~age.groups, FUN=mean)
  
  dd <- gather(d, value="rate", key="Origen",-age.groups)
  
  # INCIDÈNCIA LC: MIN-MAX band
  lc.inc.min  <- lapply(results, function(x) apply(x$lc.incidence,  1, min))
  d.min <- aggregate(cbind(lc.inc.obs,
                           do.call(cbind, lc.inc.min))
                     ~age.groups, FUN=mean)
  dd.min <- gather(d.min, value="min.rate", key="Origen",-age.groups)
  dd$min.rate <- dd.min$min.rate

  lc.inc.max  <- lapply(results, function(x) apply(x$lc.incidence,  1, max))
  d.max <- aggregate(cbind(lc.inc.obs,
                           do.call(cbind, lc.inc.max))
                     ~age.groups, FUN=mean)
  dd.max <- gather(d.max, value="max.rate", key="Origen",-age.groups)
  dd$max.rate <- dd.max$max.rate
  rm(d.min, dd.min, d.max, dd.max)

  p1 <- ggplot(dd, aes(x=age.groups, y=rate, color=Origen)) +
    geom_point(aes(group=Origen)) +
    geom_line(aes(group=Origen)) +
    geom_ribbon(aes(group=Origen, ymin=min.rate, ymax=max.rate), linetype=0, alpha=0.1) +
    expand_limits(y=c(0,450)) +
    scale_colour_discrete(name="Unnamed",
                          breaks=c("lc.inc.obs", names(results)),
                          labels=c("Observed", names(results))) +
    theme(legend.title = element_blank()) +
    ggtitle("LC Incidence")
  
  
  # MORTALITAT LC
  lc.mort.obs  <- observed.data$lc.mortality
  lc.mort.res  <- lapply(results, function(x) apply(x$lc.mortality,  1, mean))
  
  d <- aggregate(cbind(lc.mort.obs,
                       do.call(cbind, lc.mort.res))
                 ~age.groups, FUN=mean)
  
  dd <- gather(d, value="rate", key="Origen",-age.groups)

  # MORTALITAT LC: MIN-MAX band
  lc.mort.min  <- lapply(results, function(x) apply(x$lc.mortality,  1, min))
  d.min <- aggregate(cbind(lc.mort.obs,
                           do.call(cbind, lc.mort.min))
                     ~age.groups, FUN=mean)
  dd.min <- gather(d.min, value="min.rate", key="Origen",-age.groups)
  dd$min.rate <- dd.min$min.rate
  
  lc.mort.max  <- lapply(results, function(x) apply(x$lc.mortality,  1, max))
  d.max <- aggregate(cbind(lc.mort.obs,
                           do.call(cbind, lc.mort.max))
                     ~age.groups, FUN=mean)
  dd.max <- gather(d.max, value="max.rate", key="Origen",-age.groups)
  dd$max.rate <- dd.max$max.rate
  rm(d.min, dd.min, d.max, dd.max)
  
  p2 <- ggplot(dd, aes(x=age.groups, y=rate, color=Origen)) +
    geom_point(aes(group=Origen)) +
    geom_line(aes(group=Origen)) +
    geom_ribbon(aes(group=Origen, ymin=min.rate, ymax=max.rate), linetype=0, alpha=0.1) +
    expand_limits(y=c(0,450)) +
    scale_colour_discrete(name="Unnamed",
                          breaks=c("lc.mort.obs", names(results)),
                          labels=c("Observed", names(results))) +
    theme(legend.title = element_blank()) +
    ggtitle("LC Mortality")
  
  # MORTALITAT GENERAL
  tot.mort.obs  <- observed.data$tot.mortality
  tot.mort.res  <- lapply(results, function(x) apply(x$tot.mortality,  1, mean))
  
  d <- aggregate(cbind(tot.mort.obs,
                       do.call(cbind, tot.mort.res))
                 ~age.groups, FUN=mean)
  
  dd <- gather(d, value="rate", key="Origen",-age.groups)

  # MORTALITAT GENERAL: MIN-MAX band
  tot.mort.min  <- lapply(results, function(x) apply(x$tot.mortality,  1, min))
  d.min <- aggregate(cbind(tot.mort.obs,
                           do.call(cbind, tot.mort.min))
                     ~age.groups, FUN=mean)
  dd.min <- gather(d.min, value="min.rate", key="Origen",-age.groups)
  dd$min.rate <- dd.min$min.rate
  
  tot.mort.max  <- lapply(results, function(x) apply(x$tot.mortality,  1, max))
  d.max <- aggregate(cbind(tot.mort.obs,
                           do.call(cbind, tot.mort.max))
                     ~age.groups, FUN=mean)
  dd.max <- gather(d.max, value="max.rate", key="Origen",-age.groups)
  dd$max.rate <- dd.max$max.rate
  rm(d.min, dd.min, d.max, dd.max)
  
  p3 <- ggplot(dd, aes(x=age.groups, y=rate, color=Origen)) +
    geom_point(aes(group=Origen)) +
    geom_line(aes(group=Origen)) +
    geom_ribbon(aes(group=Origen, ymin=min.rate, ymax=max.rate), linetype=0, alpha=0.1) +
    expand_limits(y=c(0,4500)) +
    scale_colour_discrete(name="Unnamed",
                          breaks=c("tot.mort.obs", names(results)),
                          labels=c("Observed", names(results))) +
    theme(legend.title = element_blank()) +
    ggtitle("Overall mortality")
  
  pg <- plot_grid(p1,p2,p3,ncol=3)
  title1 <- ggdraw() +
    draw_label(title, fontface='bold')
  title2 <- ggdraw() +
    draw_label(subtitle)
  
  pg <- plot_grid(title1, title2, pg, ncol=1, rel_heights = c(1,1,12))
  ggsave(filename = paste0("results/", gsub(" ", "", title, fixed=TRUE), "_", as.integer(Sys.time())%%1e7, ".png"), plot = pg, width = 20, height = 5.67)
  
}
