# defs.R
# File for all learners and anything which will be used in all Algorithms

LRN = makeLearner("classif.randomForest", predict.type = "prob", 
  fix.factors.prediction = TRUE, ntree = 5000)

NREP = 1