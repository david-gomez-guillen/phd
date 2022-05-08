library(xlsx)
library(dplyr)

excel.filename <- "results/0-lc_excelresults_scrcov37.xlsx"

cat("Updating results file: ")
cat(excel.filename)
cat("\n")

# Create first dataframe
# df <- data.frame(matrix(1:48,nrow=1))
# names(df) <- c("sim.name",
#                "start.age", "end.age", "N", "periods.per.year", "Nsim", "Ncores",
#               "p_smoker", "rr_smoker",
#               "utility_1", "utility_2", "utility_3", 
#               "discount",
#               "quit.type", "quit.refyears", "quit.riskred",
#               "Nquit.interventions",
#               "quit1.cov", "quit1.eff", "quit1.age",
#               "quit2.cov", "quit2.eff", "quit2.age",
#               "quit3.cov", "quit3.eff", "quit3.age",
#               "quit4.cov", "quit4.eff", "quit4.age",
#               "screen.cov", "screen.eff_1", "screen.eff_2", "screen.eff_3", 
#               "screen.start.age", "screen.end.age", "screen.period",
#               "screen.survival",
#               
#               "cost.postdiag",
#               "cost.quit1", "cost.quit2", "cost.quit3", "cost.quit4", 
#               "cost.screen",
#               
#               "spont.diag_1", "spont.diag_2", "spont.diag_3",
#               "time",
#               "seed"
# )
# df <- df[-1,]

#df <- read.xlsx(file=excel.filename,
#                sheetName="execdata")
#df %>% mutate_if(is.factor, as.character) -> df
if(sim.counter!=1){
  df <- read.xlsx(file=excel.filename,
                  sheetName="execdata")
  df %>% mutate_if(is.factor, as.character) -> df
}else{df=data.frame()}

# Add info to dataframe

#r <- nrow(df)+1 # set row to update
if(sim.counter==1){r=1}else{
  r <- nrow(df)+1} # set row to update

df[r, "sim.name"] <- sim.name

# RESULTS
df[r, "QALY"] <- mean(sim[["qaly"]])
df[r, "sd.QALY"] <- sd(sim[["qaly"]])
# df[r, "Cost"] <- mean(costpperson.vector)
# df[r, "sd.Cost"] <- sd(costpperson.vector)
df[r, "Cost"] <- mean(sim[["costs_person"]]["i",])
df[r, "sd.Cost"] <- sd(sim[["costs_person"]]["i",])
df[r, "Undisc.QALY"] <- mean(sim[["undisc_qaly"]])
df[r, "sd.Undisc.QALY"] <- sd(sim[["undisc_qaly"]])
df[r, "Undisc.cost"] <- mean(sim[["undisc_costs_person"]]["i",])
df[r, "sd.Undisc.cost"] <- sd(sim[["undisc_costs_person"]]["i",])
df[r, "Inc.Global.sim"] <- mean(sim[["lc.globalsim.inc"]])
df[r, "sd.Inc.Global.sim"] <- sd(sim[["lc.globalsim.inc"]])
df[r, "Inc.65.sim"] <- mean(sim[["lc.last15y.inc"]])
df[r, "sd.Inc.65.sim"] <- sd(sim[["lc.last15y.inc"]])
df[r, "Inc.Global.crude"] <- mean(sim[["lc.globalsim.crude.inc"]])
df[r, "sd.Inc.Global.crude"] <- sd(sim[["lc.globalsim.crude.inc"]])
df[r, "Inc.65.crude"] <- mean(sim[["lc.last15y.crude.inc"]])
df[r, "sd.Inc.65.crude"] <- sd(sim[["lc.last15y.crude.inc"]])
df[r, "Inc.Global.asr"] <- mean(sim[["lc.globalsim.asr.inc"]])
df[r, "sd.Inc.Global.asr"] <- sd(sim[["lc.globalsim.asr.inc"]])
df[r, "Inc.65.asr"] <- mean(sim[["lc.last15y.asr.inc"]])
df[r, "sd.Inc.65.asr"] <- sd(sim[["lc.last15y.asr.inc"]])

df[r, "LCMort.Global.sim"] <- mean(sim[["lc.globalmort.inc"]])
df[r, "sd.LCMort.Global.sim"] <- sd(sim[["lc.globalmort.inc"]])
df[r, "LCMort.Global.crude"] <- mean(sim[["lc.globalmort.crude.inc"]])
df[r, "sd.LCMort.Global.crude"] <- sd(sim[["lc.globalmort.crude.inc"]])
df[r, "LCMort.Global.asr"] <- mean(sim[["lc.globalmort.asr.inc"]])
df[r, "sd.LCMort.Global.asr"] <- sd(sim[["lc.globalmort.asr.inc"]])

lc.deaths.origin <- rowMeans(sim[["lc.deaths.origin"]])
df[r, "lc.deaths_1"] <- lc.deaths.origin[2]
df[r, "lc.deaths_2"] <- lc.deaths.origin[3]
df[r, "lc.deaths_3"] <- lc.deaths.origin[4]
df[r, "lc.deaths.total"] <- mean(colSums(sim[["lc.deaths.origin"]]))
df[r, "sd.lc.deaths.total"] <- sd(colSums(sim[["lc.deaths.origin"]]))

scr.diag.stage <- rowMeans(sim[["scr.diag.state"]])
df[r, "scr.diag.stage_1"] <- scr.diag.stage[2]
df[r, "scr.diag.stage_2"] <- scr.diag.stage[3]
df[r, "scr.diag.stage_3"] <- scr.diag.stage[4]
df[r, "scr.diag.total"] <- mean(colSums(sim[["scr.diag.state"]]))
df[r, "sd.scr.diag.total"] <- sd(colSums(sim[["scr.diag.state"]]))
df[r, "screened.total"] <- mean(sim[["total.screens"]])
df[r, "sd.screened.total"] <- sd(sim[["total.screens"]])


# EXEC PARAMS
df[r, "start.age"] <- kStartAge #warning
df[r, "end.age"] <- kEndAge #warning
df[r, "N"] <- N
df[r, "periods.per.year"] <- kPeriods #warning
df[r, "Nsim"] <- Nsim
df[r, "Ncores"] <- n.cores

# NH PARAMS
df[r, "p_smoker"] <- interventions_p$p_smoker
df[r, "rr_smoker"] <- interventions_p$rr_smoker
df[r, "utility_1"] <- costs_p$utilities[2]
df[r, "utility_2"] <- costs_p$utilities[3]
df[r, "utility_3"] <- costs_p$utilities[4]
df[r, "discount"] <- costs_p$discount.factor

# QUITTING PARAMS
df[r, "quit.type"] <- interventions_p$quitting_effect_type
df[r, "quit.refyears"] <- interventions_p$quitting_ref_years
df[r, "quit.riskred"] <- interventions_p$quitting_rr_after_ref_years

# QUITTING INTS
Nquit <- length(interventions_p$quitting_interventions)
df[r, "Nquit.interventions"] <- Nquit
if (Nquit > 0) {
  # QUIT 1
  df[r, "quit1.cov"] <- ifelse(is.null(interventions_p$quitting_interventions[[1]]$coverage), NA, interventions_p$quitting_interventions[[1]]$coverage)
  df[r, "quit1.eff"] <- ifelse(is.null(interventions_p$quitting_interventions[[1]]$success_rate), NA, interventions_p$quitting_interventions[[1]]$success_rate)
  df[r, "quit1.age"] <- ifelse(is.null(interventions_p$quitting_interventions[[1]]$interv_steps), NA, interventions_p$quitting_interventions[[1]]$interv_steps[1]/df[r, "periods.per.year"]+df[r, "start.age"])
  
  if (Nquit > 1) {
    # QUIT 2
    df[r, "quit2.cov"] <- interventions_p$quitting_interventions[[2]]$coverage
    df[r, "quit2.eff"] <- interventions_p$quitting_interventions[[2]]$success_rate
    df[r, "quit2.age"] <- interventions_p$quitting_interventions[[2]]$interv_steps[1]/df[r, "periods.per.year"]+df[r, "start.age"]
    
    if (Nquit > 2) {
      # QUIT 3
      df[r, "quit3.cov"] <- interventions_p$quitting_interventions[[3]]$coverage
      df[r, "quit3.eff"] <- interventions_p$quitting_interventions[[3]]$success_rate
      df[r, "quit3.age"] <- interventions_p$quitting_interventions[[3]]$interv_steps[1]/df[r, "periods.per.year"]+df[r, "start.age"]
      
      if (Nquit > 3) {
        # QUIT 4
        df[r, "quit4.cov"] <- interventions_p$quitting_interventions[[4]]$coverage
        df[r, "quit4.eff"] <- interventions_p$quitting_interventions[[4]]$success_rate
        df[r, "quit4.age"] <- interventions_p$quitting_interventions[[4]]$interv_steps[1]/df[r, "periods.per.year"]+df[r, "start.age"]
        
      } else {
        df[r, "quit4.cov"] <- df[r, "quit4.eff"] <- df[r, "quit4.age"] <- NA
      }
    } else {
      df[r, "quit3.cov"] <- df[r, "quit3.eff"] <- df[r, "quit3.age"] <- NA
      df[r, "quit4.cov"] <- df[r, "quit4.eff"] <- df[r, "quit4.age"] <- NA
    }
  } else {
    df[r, "quit2.cov"] <- df[r, "quit2.eff"] <- df[r, "quit2.age"] <- NA
    df[r, "quit3.cov"] <- df[r, "quit3.eff"] <- df[r, "quit3.age"] <- NA
    df[r, "quit4.cov"] <- df[r, "quit4.eff"] <- df[r, "quit4.age"] <- NA
  }
} else {
  df[r, "quit1.cov"] <- df[r, "quit1.eff"] <- df[r, "quit1.age"] <- NA
  df[r, "quit2.cov"] <- df[r, "quit2.eff"] <- df[r, "quit2.age"] <- NA
  df[r, "quit3.cov"] <- df[r, "quit3.eff"] <- df[r, "quit3.age"] <- NA
  df[r, "quit4.cov"] <- df[r, "quit4.eff"] <- df[r, "quit4.age"] <- NA
}


# SCREEN PARAMS
df[r, "screen.cov"] <- interventions_p$screening_coverage
df[r, "screen.eff_1"] <- interventions_p$diag_screen[2]
df[r, "screen.eff_2"] <- interventions_p$diag_screen[3]
df[r, "screen.eff_3"] <- interventions_p$diag_screen[4]
df[r, "screen.start.age"] <- interventions_p$screening_start_age
df[r, "screen.end.age"] <- interventions_p$screening_end_age
df[r, "screen.period"] <- interventions_p$screening_periodicity
df[r, "screen.survival"] <- interventions_p$survival_after_scr_dx
df[r, "cost.postdiag"] <- costs_p$postdx_treatment$i
df[r, "cost.quit1"] <- costs_p$quitting.int$i #warning
df[r, "cost.quit2"] <- costs_p$quitting.int$i #warning
df[r, "cost.quit3"] <- costs_p$quitting.int$i #warning
df[r, "cost.quit4"] <- costs_p$quitting.int$i #warning
df[r, "cost.screen"] <- costs_p$screening$i #warning
df[r, "spont.diag_1"] <- 0.182
df[r, "spont.diag_2"] <- 0.401-0.182
df[r, "spont.diag_3"] <- 0.934-0.401
df[r, "time"] <- tstamp
df[r, "seed"] <- seed


write.xlsx(df, file=excel.filename, sheetName="execdata", row.names = FALSE)
