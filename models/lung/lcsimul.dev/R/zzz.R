.onLoad <- function(libname, pkgname) {
  packageStartupMessage(paste0(
    "Loaded ", pkgname, " version compiled on ", lcsimul_dev_comp_time()))
}
