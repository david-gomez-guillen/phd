scrstats <- datasim[[7]]$scr.stats
scrstats.lc <- datasim[[7]]$scr.stats.lc


M <- apply(simplify2array(scrstats), c(1,2), mean)
dx.states <- c("2.dx+OK","3.dx+KO","4.no dx","1.well","5.dead")

dfm <- data.frame(M)
names(dfm) <- c("4.surv <1y", "3.surv <5y", "2.surv <10y", "1.surv >=10y", "0.survived")
dfm["SC.result"] <- dx.states
dfm <- dfm %>% gather(surv.time, count, 1:5)
dfm["barwidth"] <- .9
pl <- ggplot(dfm) +
  geom_col(aes(x=SC.result, y=count, fill=surv.time)) +
  scale_fill_manual(values=qualitative.pal(5))
pl.zoom <- ggplot(dfm) + 
  geom_col(aes(x=SC.result, y=count, fill=surv.time)) +
  scale_fill_manual(values=qualitative.pal(5)) +
  coord_cartesian(ylim=c(0,100))

LC <- apply(simplify2array(scrstats.lc), c(1,2), mean)
lc.deaths <- count <- rowSums(LC)
dflc <- data.frame(count)
lcnames <- c("2b", "3b", "4b", "1b", "5b")
dflc["SC.result"] <- lcnames
dflc["surv.time"] <- "5.lc death"
dflc["barwidth"] <- .3

dfm2 <- rbind(dfm, dflc)

pl.lc.10k <- ggplot(dfm2) + 
  geom_bar(aes(x=SC.result, y=count, fill=surv.time, width=barwidth), stat = "identity") + 
  theme(axis.text.x = element_text(angle = -45, vjust=1, hjust=0), legend.position = "bottom") +
  scale_fill_manual(values=c(qualitative.pal(5), "grey30")) + 
  ggtitle("Screening stats (zoom 10k)")

pl.lc.1k <- ggplot(dfm2) + 
  geom_bar(aes(x=SC.result, y=count, fill=surv.time, width=barwidth), stat = "identity") + 
  theme(axis.text.x = element_text(angle = -45, vjust=1, hjust=0), legend.position = "bottom") +
  scale_fill_manual(values=c(qualitative.pal(5), "grey30")) + 
  ggtitle("Screening stats (zoom 1k)") +
  coord_cartesian(ylim=c(0,2000))

pl.lc.50 <- ggplot(dfm2) + 
  geom_bar(aes(x=SC.result, y=count, fill=surv.time, width=barwidth), stat = "identity") + 
  theme(axis.text.x = element_text(angle = -45, vjust=1, hjust=0), legend.position = "bottom") +
  scale_fill_manual(values=c(qualitative.pal(5), "grey30")) + 
  ggtitle("Screening stats (zoom 50)") +
  coord_cartesian(ylim=c(0,100))

ggsave(filename = "1-screening_stats_10k_6.png", pl.lc.10k, width = 6, height = 6)
ggsave(filename = "2-screening_stats_1k_6.png", pl.lc.1k, width = 6, height = 6)
ggsave(filename = "3-screening_stats_50_6.png", pl.lc.50, width = 6, height = 6)



