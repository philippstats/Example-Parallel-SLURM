# Benchmarks

library(mlr)
library(BatchExperiments)

setwd("/home/hpc/ua341/di25kaq/Example-Parallel-SLURM/")

loadConfig()
getConfig()
unlink("bmrparallel-files/", recursive = TRUE) # CAUTION! ?unlink

# probably you don't need Rmpi
reg = makeExperimentRegistry("bmrparallel", packages = c("mlr", "parallelMap", "Rmpi"), src.files = "defs.R")

#
# Problem
#

# here just one task:
load("calhousing.RData")
tasks = list(calhousing.task = subsetTask(calhousing.task, 1:10000))

for (i in seq_along(tasks)) {
  tk = tasks[[i]]
  static = list(task = tk)
  addProblem(reg, id = getTaskId(tk), 
    static = static, 
    dynamic = function(static) {
      rdesc = makeResampleDesc("CV", iters = 10, stratify = TRUE)
      rin = makeResampleInstance(desc = rdesc, task = static$task)
      list(rin = rin)
    }, 
    seed = i, overwrite = TRUE)
}


#
# Algorithm w/ parallelization 
#


addAlgorithm(reg, 
  id = "RF_parallel", 
  fun = function(static, dynamic, n_cores) {
    parallelStartMPI(cpus = n_cores, logging = FALSE, level = "mlr.resample", show.info = TRUE)
    r = resample(LRN, static$task, resampling = dynamic$rin, show.info = TRUE)
    parallelStop()
    print(r)
    r
  },
  overwrite = TRUE
)
n_cores = c(2, 10)
design = makeDesign("RF_parallel", exhaustive = list(n_cores = n_cores))
addExperiments(reg, rep = NREP, algo.designs = design)

#
# Algorihm w/o parallelization
#

addAlgorithm(reg, 
  id = "RF_serial", 
  fun = function(static, dynamic) {
    r = resample(LRN, static$task, resampling = dynamic$rin, show.info = TRUE)
    print(r)
    r
  },
  overwrite = TRUE
)
design = makeDesign("RF_serial", design = data.frame())
addExperiments(reg, rep = NREP, algo.designs = design)

#
# Test
#

summarizeExperiments(reg)

#
# Submit
#

ids_parallel = 1:2
ids_serial = 3

messagef("Submitting %s:", ids_parallel)
submitJobs(reg, ids_parallel, resources = list(walltime = 60L*60L*0.2, memory = 1000L, ntasks = 28))
messagef("Submitting %s:", ids_serial)
submitJobs(reg, ids = ids_serial, resources = list(walltime = 60L*60L*0.2, memory = 1000L, ntasks = 1))
