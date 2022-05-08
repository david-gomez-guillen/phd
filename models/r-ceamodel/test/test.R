library(CEAModel)

trees <- list()
for(f in list.files('test/modelSpecs')) {
  if (!startsWith(f, '_') && endsWith(f, '.yaml')) {
    name <- substr(f,1,(nchar(f) - 5))
    print(name)
    t <- loadDecisionTree(paste0('test/modelSpecs/',f))
    assign(name, t)
    trees[[name]] <- t
  }
}

m <- loadMarkovModels('test/modelSpecs/markov_test.xlsx')
res <- m$model1$simulateCohort(c(1,0,0,0),
                               context=list(
                                 p_hc=.1,
                                 p_ch=.05,
                                 p_cd=.7,
                                 p_hd=.1,
                                 c_healthy=0,
                                 c_death=0,
                                 c_cancer=1000,
                                 c_survive=200,
                                 u_healthy=1,
                                 u_cancer=.5,
                                 u_survive=.9))
print(res)

compareStrategies(conventional=conventional, arnme6e7=arnme6e7, context=list(
  p_cyto_benign=.4,
  c_cyto=100,
  p_hra_and_cyto_no_hsil=.4,
  p_hra_or_cyto_hsil=.4,
  c_followup=10,
  u_cyto_benign=.8,
  dist_hra=matrix(c(.2,.4,.4), nrow=1),
  c_hra=100,
  u_no_hsil=.7,
  p_regression=.5,
  u_hsil=.8,
  c_surgery=100,
  u_surgery=.8,
  p_cyto_benign_ascus_lsil_arnm_neg=.7,
  c_cyto_arnm=20))
