cluster.functions = makeClusterFunctionsSLURM(template.file = "lrz_parallel.tmpl", 
    list.jobs.cmd = c("squeue", "-h", "-o %i", "-u $USER", "--clusters=mpp2", "| tail -n +2"))
staged.queries = TRUE
raise.warnings = FALSE
debug = FALSE
