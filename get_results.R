library(BatchExperiments)
library(dplyr)
reg = loadRegistry("bmrparallel-files")
showStatus(reg)

# reduce results
res = reduceResultsExperiments(reg, ids = findDone(reg), fun = function(job, res) res$aggr)

