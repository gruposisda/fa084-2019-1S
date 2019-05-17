
library(tidyverse)
library(mlr)
library(mlbench)
library(e1071)
library(xgboost)
library(parallelMap)

count_na = function(df){
    sapply(df, function(x){sum(is.na(x))})
    }

library(mlbench)
library(tidyverse)
library(mlr)

data(BostonHousing)
df = BostonHousing
head(df)

?BostonHousing

regr.task = makeRegrTask(data = df, target = 'medv')

regr.task

svm_learner = makeLearner(cl='regr.svm', cost = 1)

svm_learner

holdout = makeResampleDesc(method = 'Holdout', split = 0.7)
cv = makeResampleDesc(method = 'CV', iters = 8)

cv

holdout
cv

res_holdout = resample(learner = svm_learner,task = regr.task,
                       resampling = holdout, list(mae, mse) )

set.seed(2019)
res_cv = resample(svm_learner, regr.task, cv, mae)

parameters_svm = makeParamSet(makeNumericParam("cost",lower = 0.1,
                                              upper = 1),
                             makeNumericParam("gamma", lower = 0.1,
                                              upper = 1))

parameters_svm

ctrl  = makeTuneControlRandom(maxit = 100)

tr$x

tr$resampling

getLearnerParamSet(svm_learner)

set.seed(2019)
tr = tuneParams(svm_learner, regr.task, cv, mae, parameters_svm, 
               ctrl)

tr$x

























data(Soybean,package = 'mlbench')
soy = createDummyFeatures(Soybean,target = "Class")
dim(Soybean)
dim(soy)


table(soy$Class)

dim(drop_na(soy))

task = makeClassifTask(data = drop_na(soy), target = 'Class')
set.seed(25)
holdout = makeResampleInstance("Holdout",task, split = 0.7)
tsk_train = subsetTask(task, holdout$train.inds[[1]])
tsk_test = subsetTask(task, holdout$test.inds[[1]])

task

tsk_test

holdout$test.inds[[1]]

length(holdout$train.inds[[1]])

library(e1071)
library(xgboost)

xgb_learner = makeLearner("classif.xgboost")
#Warning: https://stackoverflow.com/questions/55545145/what-does-the-warning-na-used-as-a-default-value-for-learner-parameter-missing
svm_learner = makeLearner("classif.svm")

parameters_svm

parameters_sxgb = makeParamSet(
                makeNumericParam("eta",0,1),
                makeNumericParam("lambda",0,200),
                makeIntegerParam("max_depth",1,20))
parameters_sxgb

getLearnerParamSet(xgb_learner)

tune_control = makeTuneControlRandom(maxit=100)

cv5

set.seed(10)
tr_xgb = tuneParams(xgb_learner, tsk_train, cv5,acc,parameters_sxgb,tune_control)

tr_xgb$y

t0 = Sys.time()
tr_svm = tuneParams(svm_learner,tsk_train,cv5,list(acc),parameters_svm,tune_control)
t1 = Sys.time()

tr_xgb$x

tr_svm$x

tuned_xgb = setHyperPars(xgb_learner,par.vals = tr_xgb$x)
tuned_svm = setHyperPars(svm_learner,par.vals = tr_svm$x)

tuned_xgb
tuned_svm

xgb_model = train(tuned_xgb, tsk_train)
svm_model = train(tuned_svm, tsk_train)

xgb_pred = predict(xgb_model, tsk_test)

svm_pred = predict(svm_model, tsk_test)

mean(xgb_pred$data$response == xgb_pred$data$truth)

mean(svm_pred$data$response == svm_pred$data$truth)

calculateConfusionMatrix(xgb_pred)

cm = calculateConfusionMatrix(svm_pred,relative = TRUE)

cm$result
