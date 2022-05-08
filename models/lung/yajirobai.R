library(colorspace)
library(cowplot)
library(tidyr)

qualitative.pal <- function (n) {rainbow_hcl(n, c=60, l=65, start=30, end=300)}

MakeGraphTriplet <- function(data, age.groups, show.band=TRUE, show.overall=TRUE,
                                  title="Generic Graph Title", 
                                  subtitle="",
                                  filename=""
                            ) {
  if (length(data) > 10) warning("color support for more than 10 simulations not implemented")
  pal <- qualitative.pal(10)
  pal2 <- pal[(3*1:10)%%11]
  
  # INCIDÈNCIA LC
  lc.inc.res  <- lapply(data, function(x) apply(as.matrix(x$lc.incidence, nrow=length(age.groups)),  1, mean))
  
  d <- aggregate(do.call(cbind, lc.inc.res)~age.groups, FUN=mean)
  dd <- gather(d, value="rate", key="Origen",-age.groups)
  
  # INCIDÈNCIA LC: MIN-MAX band
  lc.inc.min  <- lapply(data, function(x) apply(as.matrix(x$lc.incidence, nrow=length(age.groups)),  1, min))
  d.min <- aggregate(do.call(cbind, lc.inc.min)~age.groups, FUN=mean)
  dd.min <- gather(d.min, value="min.rate", key="Origen",-age.groups)
  dd$min.rate <- dd.min$min.rate
  
  lc.inc.max  <- lapply(data, function(x) apply(as.matrix(x$lc.incidence, nrow=length(age.groups)),  1, max))
  d.max <- aggregate(do.call(cbind, lc.inc.max)~age.groups, FUN=mean)
  dd.max <- gather(d.max, value="max.rate", key="Origen",-age.groups)
  dd$max.rate <- dd.max$max.rate
  
  rm(lc.inc.res, lc.inc.min, lc.inc.max, d.min, dd.min, d.max, dd.max)
  
  
  p1 <- ggplot(dd, aes(x=age.groups, y=rate, color=Origen)) +
    geom_point(aes(group=Origen)) +
    geom_line(aes(group=Origen)) +
    expand_limits(y=c(0,450)) + # MEN
    # expand_limits(y=c(0,120)) + # WOMEN
    scale_color_manual(values=pal2) +
    scale_fill_manual(values=pal2) +
    theme(legend.position = "bottom") + ## TODO això és un parche i pot no ser correcte
    ggtitle("LC Incidence")
  if (show.band) {
    p1 <- p1 + geom_ribbon(aes(group=Origen, ymin=min.rate, ymax=max.rate, fill=Origen), linetype=0, alpha=0.15)
  }
  
  
  # MORTALITAT LC
  lc.mort.res  <- lapply(data, function(x) apply(as.matrix(x$lc.mortality, nrow=length(age.groups)),  1, mean))
  
  d <- aggregate(do.call(cbind, lc.mort.res)~age.groups, FUN=mean)
  dd <- gather(d, value="rate", key="Origen",-age.groups)
  
  # MORTALITAT LC: MIN-MAX band
  lc.mort.min  <- lapply(data, function(x) apply(as.matrix(x$lc.mortality, nrow=length(age.groups)),  1, min))
  d.min <- aggregate(do.call(cbind, lc.mort.min)~age.groups, FUN=mean)
  dd.min <- gather(d.min, value="min.rate", key="Origen",-age.groups)
  dd$min.rate <- dd.min$min.rate
  
  lc.mort.max  <- lapply(data, function(x) apply(as.matrix(x$lc.mortality, nrow=length(age.groups)),  1, max))
  d.max <- aggregate(do.call(cbind, lc.mort.max)~age.groups, FUN=mean)
  dd.max <- gather(d.max, value="max.rate", key="Origen",-age.groups)
  dd$max.rate <- dd.max$max.rate
  
  rm(lc.mort.res, lc.mort.min, lc.mort.max, d.min, dd.min, d.max, dd.max)
  
  
  p2 <- ggplot(dd, aes(x=age.groups, y=rate, color=Origen)) +
    geom_point(aes(group=Origen)) +
    geom_line(aes(group=Origen)) +
    expand_limits(y=c(0,450)) + # MEN
    # expand_limits(y=c(0,120)) + # WOMEN
    scale_color_manual(values=pal2) +
    scale_fill_manual(values=pal2) +
    theme(legend.position = "none") + ## TODO això és un parche i pot no ser correcte
    ggtitle("LC Mortality")
  if (show.band) {
    p2 <- p2 + geom_ribbon(aes(group=Origen, ymin=min.rate, ymax=max.rate, fill=Origen), linetype=0, alpha=0.15)
  }
  
  
  # MORTALITAT GENERAL
  
  tot.mort.res  <- lapply(data, function(x) apply(as.matrix(x$tot.mortality, nrow=length(age.groups)),  1, mean))
  
  d <- aggregate(do.call(cbind, tot.mort.res)~age.groups, FUN=mean)
  dd <- gather(d, value="rate", key="Origen",-age.groups)
  
  # MORTALITAT GENERAL: MIN-MAX band
  tot.mort.min  <- lapply(data, function(x) apply(as.matrix(x$tot.mortality, nrow=length(age.groups)),  1, min))
  d.min <- aggregate(do.call(cbind, tot.mort.min)~age.groups, FUN=mean)
  dd.min <- gather(d.min, value="min.rate", key="Origen",-age.groups)
  dd$min.rate <- dd.min$min.rate
  
  tot.mort.max  <- lapply(data, function(x) apply(as.matrix(x$tot.mortality, nrow=length(age.groups)),  1, max))
  d.max <- aggregate(do.call(cbind, tot.mort.max)~age.groups, FUN=mean)
  dd.max <- gather(d.max, value="max.rate", key="Origen",-age.groups)
  dd$max.rate <- dd.max$max.rate
  
  rm(tot.mort.res, tot.mort.min, tot.mort.max, d.min, dd.min, d.max, dd.max)
  
  
  p3 <- ggplot(dd, aes(x=age.groups, y=rate, color=Origen)) +
    geom_point(aes(group=Origen)) +
    geom_line(aes(group=Origen)) +
    expand_limits(y=c(0,450)) +
    scale_color_manual(values=pal2) +
    scale_fill_manual(values=pal2) +
    theme(legend.position = "none") + ## TODO això és un parche i pot no ser correcte
    ggtitle("Overall mortality")
  if (show.band) {
    p3 <- p3 + geom_ribbon(aes(group=Origen, ymin=min.rate, ymax=max.rate, fill=Origen), linetype=0, alpha=0.15)
  }
  
  # GRÀFICA CONJUNTA
  
  legend <- get_legend(p1)
  
  if (show.overall) {
    pg <- plot_grid(p1+theme(legend.position = "none"),p2,p3,ncol=3)
    wfact <- 1
  } else {
    pg <- plot_grid(p1+theme(legend.position = "none"),p2,ncol=2)
    wfact <- 2/3
  }
  
  title1 <- ggdraw() +
    draw_label(title, fontface='bold')
  title2 <- ggdraw() +
    draw_label(subtitle)
  
  pg <- plot_grid(title1, title2, pg, legend, ncol=1, rel_heights = c(1,1,12,2))
  
  if (filename == "") {
    filename <- paste0(gsub(" ", "", title, fixed=TRUE), "_", as.integer(Sys.time())%%1e7)
  }
  ggsave(filename = paste0("results/", filename, ".png"), plot = pg, width = 16*wfact, height = 5.67)
  
}
