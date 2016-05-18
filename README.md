# Example-Parallel-SLURM
 Example Code for Parallel Batch Jobs using BatchJobs and BatchExperiments on LRZ Linux-Cluster 


## Result

```
> getJobInfo(reg)
  id       prob        algo repl      time.submitted        time.started
1  1 calhousing RF_parallel    1 2016-05-18 15:42:56 2016-05-18 15:43:07
2  2 calhousing RF_parallel    1 2016-05-18 15:42:56 2016-05-18 15:43:05
3  3 calhousing   RF_serial    1 2016-05-18 15:42:57 2016-05-18 15:43:07
            time.done time.running memory time.queued error.msg      nodename
1 2016-05-18 15:46:50          223   47.4          11      <NA> mpp2r03c02s08
2 2016-05-18 15:44:06           61   47.6           9      <NA> mpp2r07c01s01
3 2016-05-18 15:50:05          418 4454.1          10      <NA> mpp2r08c03s11
  batch.id r.pid     seed
1    91610  5633 45680646
2    91611 25895 45680647
3    91612  1585 45680648
> res = reduceResultsExperiments(reg, ids = findDone(reg), fun = function(job, res) res$aggr)
Reducing 3 results...
reduceResultsExperiments |+++++++++++++++++++++++++++++++++++| 100% (00:00:00)
> res
  id       prob        algo n_cores repl mmce.test.mean
1  1 calhousing RF_parallel       2    1         0.1084
2  2 calhousing RF_parallel      10    1         0.1071
3  3 calhousing   RF_serial      NA    1         0.1079
```
