library(tidyverse)
library(class)
library(rpart)

tpr = function(real,predito){
  sum(predito == 1 & real == 1)/sum(real == 1)
}

fpr = function(real,predito){
  sum(predito == 1 & real == 0)/sum(real == 0)
}

create_fold_index = function(nrows, folds){
  k_index = rep(1:folds, ceiling(nrows/folds))
  k_index = k_index[1:nrows]    
  k_index = sample(k_index)
  return(k_index)
}

#importe os dados

df = read.csv('~/data/fa084/weatherAUS.csv')
features = c('MinTemp','MaxTemp','Rainfall','Humidity9am','Humidity3pm','RainToday','RainTomorrow')
set.seed(2019)
df = df %>% select(features) %>% na.omit() %>% sample_n(5000)
table(df$RainTomorrow)
head(df)
df$RainToday = ifelse(df$RainToday == 'No',0,1)
df$RainTomorrow = ifelse(df$RainTomorrow == 'No',0,1)
df = df %>% select(-RainToday)
write.csv(df,'~/data/fa084/weather_rain_tomorrow.csv',row.names = FALSE)
df = read.csv('~/data/fa084/weather_rain_tomorrow.csv')
dim(df)
head(df)




#Divida em treino e teste
set.seed(2019)
rows_test = sample(nrow(df),0.30*nrow(df))
train = df[-rows_test,]
test = df[rows_test,]

table(train$RainToday)
table(test$RainTomorrow)
prop.table(table(test$RainTomorrow))

head(df)
#Normalize todas as colunas

#Modelagem com knn ----
train_knn = train
train_knn$RainTomorrow = NULL
train_label = train$RainTomorrow
test_knn = test
test_knn$RainTomorrow = NULL
test_label  = test$RainTomorrow


preds_knn = knn(train = train_knn,
                test = test_knn,
                cl = train_label,k = 10)

table(preds_knn,test_label)
mean(preds_knn==test_label)
tpr(test_label,preds_knn)
fpr(test_label,preds_knn)

preds_knn = knn(train = train_knn,
                test = test_knn,
                cl = train_label,k = 5)

table(preds_knn,test_label)
acc_knn = mean(preds_knn==test_label)
tpr_knn = tpr(test_label,preds_knn)
fpr_knn = fpr(test_label,preds_knn)

# Regressao logistica e arvore de decisao com 5-fold CV ----

rpart_tune = data.frame(
  expand.grid(minbucket = seq(from =25, to =100, by = 25),
              cp = c(0.01, 0.1),
              maxdepth = 2:4,
              fold = 1:5),
  acc = NA
)


cv_index = create_fold_index(nrow(train),5)



t0 = Sys.time()
for(i in 1:nrow(rpart_tune)){
  fold = rpart_tune$fold[i]
  
  
  split_train = train[cv_index != fold,]
  split_test = train[cv_index == fold,]
  
  m = rpart( RainTomorrow ~.,
             split_train,
             control = rpart.control(
               minbucket = rpart_tune$minbucket[i],
               maxdepth = rpart_tune$maxdepth[i],
               cp = rpart_tune$cp[i]),
             method='class')
  t2 = Sys.time()
  
  ypred = predict(m, split_test, type = 'class')
  rpart_tune$acc[i] = mean(ypred == split_test$RainTomorrow)
}
t1 = Sys.time()
t1 - t0

aggregate(acc ~ minbucket + cp + maxdepth ,rpart_tune, mean) %>% arrange(desc(acc)) %>% head()


tree_model = rpart(RainTomorrow~.,train, control = rpart.control(minbucket = 25,
                                                                 cp = 0.01,
                                                                 maxdepth = 3), method = 'class')
preds_tree = predict(tree_model, test, type = 'class')

table(preds_tree,test_label)
acc_tree = mean(preds_tree==test_label)
tpr_tree = tpr(test_label,preds_tree)
fpr_tree = fpr(test_label,preds_tree)

logit_model = glm(RainTomorrow ~., train, family = 'binomial')
coef(logit_model)
preds_logit = as.numeric(predict(logit_model, test, type='response') > 0.5)


table(preds_logit,test_label)
acc_logit = mean(preds_logit==test_label)
tpr_logit = tpr(test_label,preds_logit)
fpr_logit = fpr(test_label,preds_logit)


# Random forest e boosting com caret ----
library(caret)
# caret_rf = train(RainTomorrow~.,
#                  data = train, method = 'rf', 
#                  trControl = trainControl(method = 'cv', number = 5))

gbmGrid <-  expand.grid(interaction.depth = c(1, 5, 9), 
                        n.trees = c(50,100,200,300,400),
                        shrinkage = 0.1,
                        n.minobsinnode = 20)


caret_boost = train(as.factor(RainTomorrow)~.,
                    data = train, method='gbm', 
                    trControl = trainControl(method = 'cv',number =5),tuneGrid = gbmGrid)
preds_boost = predict(caret_boost,test)
table(preds_boost,test_label)
acc_boost = mean(preds_boost==test_label)
tpr_boost = tpr(test_label,preds_boost)
fpr_boost = fpr(test_label,preds_boost)

real = test$RainTomorrow
table(real,preds_knn)
table(real,preds_logit)
table(real,preds_tree)
table(real,preds_boost)

data.frame(algoritmo = c('knn','logit','tree','boost'),
           acc = c(acc_knn,acc_logit,acc_tree,acc_boost),
           tpr = c(tpr_knn,tpr_logit,tpr_tree,tpr_boost),
           fpr = c(fpr_knn,fpr_logit,fpr_tree,fpr_boost))

