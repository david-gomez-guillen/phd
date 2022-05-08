cat("Name: ")
sim.name <- readline()

cat("Calling script karin.R...\n")
if (exists("datasim")) old.datasim <- datasim else old.datasim <- list()
source('S:/grups/MODELING/Lung_AECC_Gerard/3_ModelAECC_Gerard/ModelLC/Git_LC/karin.R', encoding = 'UTF-8')


cat("Skipping plotting step.\n")
cat("Plotting...\n")
# graph.title <- "Calibration (Men)"
graph.title <- "Calibration (Women)"
MakeGraphTriplet(datasim, tpm$age.groups, title=graph.title, filename=paste0("triplet_plot_", tstamp), show.band = show.band, show.overall = show.overall)
shell(paste0('%SystemRoot%\\System32\\rundll32.exe "%ProgramFiles%\\Windows Photo Viewer\\PhotoViewer.dll", ImageView_Fullscreen ',
              gsub("/", "\\", getwd(), fixed=TRUE), '\\results\\', 'triplet_plot_', tstamp, '.png'))

cat("Erasing previous sims data. \n")
datasim <- list()

cat("Save results of simulation \"")
cat(sim.name)
cat("\" ? [y/N]\n")
xxx <- readline()
if (xxx != "y") {
  datasim <- old.datasim
} else {
  source("saver.R")
  
  cat("\nNOT saving in Rdata file\n")
  # cat("\nSaving in Rdata file\n")
  # sim.filename <- "results/savedSimulations.Rdata"
  # load(sim.filename)
  # 
  # if (!is.null(saved.datasim[[sim.name]])) {
  #   cat("Overwriting entry ")
  #   cat(sim.name)
  #   cat("\n")
  # }
  # sim$costs_m <- NULL # TODO parche, ocupa massa.
  # saved.datasim[[sim.name]] <- sim
  # save(saved.datasim, file=sim.filename)
  # 
  # cat("Saved in Rdata file as ")
  # cat(sim.name)
  # cat("\n")
}

# rm(datasim)



