#Carregue as bibliotecas necessarias
library(tidyverse)
library(class)
library(rpart)
library(caret)

#Funcoes utilizadas
normalizar = function(x){
  (x - min(x))/(max(x) - min(x))
}


tpr = function(real,predito){
  sum(predito == 1 & real == 1)/sum(real == 1)
}

fpr = function(real,predito){
  sum(predito == 1 & real == 0)/sum(real == 0)
}

create_fold_index = function(nrows, folds){
  set.seed(2019)
  k_index = rep(1:folds, ceiling(nrows/folds))
  k_index = k_index[1:nrows]    
  k_index = sample(k_index)
  return(k_index)
}


#Importe os dados ----
df = read.csv('~/data/fa084/weather_rain_tomorrow.csv')
df$RainTomorrow = as.factor(df$RainTomorrow)
#df = as.data.frame(apply(df,2,normalizar))
dim(df)
head(df)

#Divida em treino e teste
set.seed(2019)
rows_test = sample(nrow(df),0.30*nrow(df))
train = df[-rows_test,]
test = df[rows_test,]

table(test$RainTomorrow)
prop.table(table(test$RainTomorrow))

head(df)

#Modelagem com knn ----
#a)Estruture os dados de treino e teste para serem usados para uma modelagem 
#usando a função knn() do pacote class. (0,5)

train_knn = train
train_knn$RainTomorrow = NULL
train_label = train$RainTomorrow
test_knn = test
test_knn$RainTomorrow = NULL
test_label  = test$RainTomorrow

#b)Use a função knn()  para criar dois vetores de predições para o conjunto 
#de teste, um com k = 5 e outro com k = 10. (0,5) 

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

# Crie um dataframe com os dados:  (1,0)
# # k: número de vizinhos usados
# # acc: acurácia obtida para cada k
# # tpr:  taxa de verdadeiros positivos  para cada k
# # fpr: taxa de falsos positivos para cada k
# O dataframe terá 2 linhas e 4 colunas.


# Arvore de decisao com 5-fold CV e regressao logistica ----

#HIPERPARAMETROS DA ARVORE
#minbucket: 25, 50, 75 e 100
#cp: 0.01 e 0.1
#maxdepth: 2,3 e 4 

#ARVORE DE DECISAO

#Use cross validation com 5 folds para ajustar os hiperparâmetros especificados no script.
rpart_tune = data.frame(
  expand.grid(minbucket = seq(from =25, to =100, by = 25),
              cp = c(0.01, 0.1),
              maxdepth = 2:4,
              fold = 1:3),
  acc = NA
)


cv_index = create_fold_index(nrow(train),3)

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
#a)Qual a configuração que apresenta a melhor performance, de acordo com a acurácia? (1,0)
aggregate(acc ~ minbucket + cp + maxdepth ,rpart_tune, mean) %>% arrange(desc(acc)) %>% head()

#b)Treine um modelo (no conjunto de treino completo) com a configuração do item
#a e avalie acurácia, taxa de verdadeiros positivos (tpr) e taxa de falsos 
#positivos (fpr) no conjunto de teste. (0,5)

tree_model = rpart(RainTomorrow~.,train, 
                   control = rpart.control(minbucket = 50,
                                           cp = 0.01,
                                           maxdepth = 3),
                   method = 'class')

preds_tree = predict(tree_model, test, type = 'class')

table(preds_tree,test_label)
acc_tree = mean(preds_tree==test_label)
tpr_tree = tpr(test_label,preds_tree)
fpr_tree = fpr(test_label,preds_tree)

#REGRESSAO LOGISTICA
#c)Treine um modelo de regressão logística no conjunto de treino. Se probabilidade
#de chuva for maior do que 0,5, considere que choverá. Qual a acurácia, tpr e 
#fpr no conjunto de teste para este modelo? (0,5)
logit_model = glm(RainTomorrow ~., train, family = 'binomial')
coef(logit_model)
preds_logit = as.numeric(predict(logit_model, test, type='response') > 0.5)


table(preds_logit,test_label)
acc_logit = mean(preds_logit==test_label)
tpr_logit = tpr(test_label,preds_logit)
fpr_logit = fpr(test_label,preds_logit)


# Boosting com caret ----

# interaction.depth: 1, 5 e 9.
# n.trees = de 50 a 250 com passo de 50
# shrinkage = 0.1
# n.minobsinnode = 20


gbmGrid = expand.grid(interaction.depth = c(1, 5, 9), 
                      n.trees = c(50,100,150,200,250),
                      shrinkage = 0.1,
                      n.minobsinnode = 20)


caret_boost = train(RainTomorrow~.,
                    data = train, method='gbm', 
                    trControl = trainControl(method = 'cv',number =5),tuneGrid = gbmGrid)
caret_boost
preds_boost = predict(caret_boost,test)
table(preds_boost,test_label)
acc_boost = mean(preds_boost==test_label)
tpr_boost = tpr(test_label,preds_boost)
fpr_boost = fpr(test_label,preds_boost)
caret_boost


real = test$RainTomorrow
table(real,preds_knn)
table(real,preds_logit)
table(real,preds_tree)
table(real,preds_boost)

data.frame(algoritmo = c('knn','logit','tree','boost'),
           acc = c(acc_knn,acc_logit,acc_tree,acc_boost),
           tpr = c(tpr_knn,tpr_logit,tpr_tree,tpr_boost),
           fpr = c(fpr_knn,fpr_logit,fpr_tree,fpr_boost))

tree_model$variable.importance
