library(WriteXLS)

tstamp <- "20170509_150528"

# setwd("C:/Users/45790702w/Documents/Model LC/")
# load(paste0("results_pcdavid/calibration_results_", tstamp))

setwd("S:/GRUPS/MODELING/Albert/LC-tests/")
load(paste0("results/calibration_results_", tstamp))

if (exists("tp.post")) {
  tp <- tp.post 
} else {
  tpm <- LoadTPMatrixFromFile("LC Excel model_mds_v02_ASB.xlsx", sheet = "11")
  nt.info <- TPMatricesToNonTrivialVector(tpm$tpm, TRUE)
  
  optimized.full.vector <- c(fixed.pre, opt.pars$par, fixed.post)
  
  tp <- TPMatricesFromVector(tpm$N.states, optimized.full.vector, nt.info$nt.idxs, nt.info$mort)
}



tp.single.matrix <- do.call(rbind, tp)
tp.single.matrix <- cbind(rep('', nrow(tp.single.matrix)),
                          as.character(rep(tpm$age.groups, each=tpm$N.states)),
                          tp.single.matrix)

WriteXLS(x=as.data.frame(tp.single.matrix), 
         ExcelFileName = paste0("calib_tp_matrix_",
                                tstamp,
                                ".xls"), SheetNames = "Calibrated matrix")


####################################################################################

