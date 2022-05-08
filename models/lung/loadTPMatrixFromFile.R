library(gdata)

# Column 1 is ignored
# Column 2 has age groups formatted as "aa-bb" or "aa+"
# Columns 3+ have transition probabilities
# Last three states must be "Survival", "LC death" and "Other death"
# Returns a list: tpm, age.groups, N.states, tp.limits
LoadTPMatrixFromFile <- function(path, sheet=1) {
  force(path)
  if (!file.exists(path)) stop("Couldn't load file")
  # TODO check permissions to make a package

  all.transitions <- read.xls(path,sheet = sheet)

  ret <- list()

  ret$tpm        <- list()
  ret$age.groups <- unique(all.transitions[,2])
  ret$N.states   <- dim(all.transitions)[2]-2

  pos <- 1
  for (i in 1:length(ret$age.groups)) {
    ret$tpm[[ret$age.groups[i]]] <-
      as.matrix(all.transitions[pos:(pos+ret$N.states-1),
                                3:(dim(all.transitions)[2])])
    pos <- pos + ret$N.states
  }

  names(ret$tpm) <- ret$age.groups
  ret$tp.limits  <- as.integer(substr(ret$age.groups,1,2))

  return(ret)
}







