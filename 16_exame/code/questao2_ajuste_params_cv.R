library(tidyverse)
library(rpart)

# Complete a funcao normalizar que normaliza um vetor x 
# para deixar os valores entre 0 e 1
normalizar = function(x){
  (x - min(x))/(max(x) - min(x))
}

# Complete a funcao tpr que recebe os vetores real e predito 
# e retorna a taxa de verdadeiros positivos
tpr = function(real,predito){
  sum(predito == 1 & real == 1)/sum(real == 1)
}

# Complete a funcao fpr que recebe os vetores real e predito
# e retorna a taxa de falsos positivos
fpr = function(real,predito){
  sum(predito == 1 & real == 0)/sum(real == 0)
}


# Não é necessario alterar a funcao create fold index abaixo
create_fold_index = function(nrows, folds){
  set.seed(2019)
  k_index = rep(1:folds, ceiling(nrows/folds))
  k_index = k_index[1:nrows]    
  k_index = sample(k_index)
  return(k_index)
}



#1. Importe os dados ----
df = read.csv('../data/weather_rain_tomorrow.csv')
df$RainTomorrow = as.factor(df$RainTomorrow)
# df = as.data.frame(apply(df,2,normalizar))
dim(df)
head(df)

#2. Divida em treino e teste
set.seed(2019)
rows_test = sample(nrow(df),0.30*nrow(df))
train = df[-rows_test,]
test = df[rows_test,]


# Arvore de decisao com 5-fold CV e regressao logistica ----

#HIPERPARAMETROS DA ARVORE
#minbucket: de 25 a 150 com passo de 25
#cp: 0.01, 0.1 e 0.15
#maxdepth: 2,3,4 e 5 

#3. Use cross validation com 5 folds para ajustar os hiperparâmetros acima
k = 5
rpart_tune = data.frame(
  expand.grid(minbucket = seq(from =25, to =150, by = 25),
              cp = c(0.01, 0.1, 0.15),
              maxdepth = 2:5,
              fold = 1:k),
  acc = NA
)


cv_index = create_fold_index(nrow(train),k)

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

#4. Qual a configuração que apresenta a melhor performance, de acordo com a acurácia? (1,0)
aggregate(acc ~ minbucket + cp + maxdepth ,rpart_tune, mean) %>% arrange(desc(acc)) %>% head()

#5. Treine um modelo (no conjunto de treino completo) com a configuração do item
#a e avalie acurácia, taxa de verdadeiros positivos (tpr) e taxa de falsos 
#positivos (fpr) no conjunto de teste. (0,5)

tree_model = rpart(RainTomorrow~.,train, 
                   control = rpart.control(minbucket = 25,
                                           cp = 0.01,
                                           maxdepth = 5),
                   method = 'class')

preds_tree = predict(tree_model, test, type = 'class')

test_label = test$RainTomorrow
table(preds_tree,test_label)
acc_tree = mean(preds_tree==test_label)
tpr_tree = tpr(test_label,preds_tree)
fpr_tree = fpr(test_label,preds_tree)

#REGRESSAO LOGISTICA
#6. Treine um modelo de regressão logística no conjunto de treino. Se probabilidade
#de chuva for maior do que 0,5, considere que choverá. Qual a acurácia, tpr e 
#fpr no conjunto de teste para este modelo? (0,5)
logit_model = glm(RainTomorrow ~., train, family = 'binomial')
coef(logit_model)
preds_logit = as.numeric(predict(logit_model, test, type='response') > 0.5)


table(preds_logit,test_label)
acc_logit = mean(preds_logit==test_label)
tpr_logit = tpr(test_label,preds_logit)
fpr_logit = fpr(test_label,preds_logit)


#7. Complete as matrizes de confusao abaixo e discuta qual modelo utilizar considerando a premissa:
# Custa menos dizer que não choverá e, na verdade, chova do que dizer que choverá e na verdade, não chova.
table(test_label,preds_tree)
table(test_label,preds_logit)


# Para checar a importância de variáveis na árvore, se seu modelo chama tree_model,
# use o comando: tree_model$variable.importance. 
# Para ver os valores de coeficientes para a regressao logistica use (coef(logit_model)) 
#8. Compare e discuta sucintamente a importância de atributos para a árvore e para a regressão logística. 
tree_model$variable.importance
coef(logit_model)