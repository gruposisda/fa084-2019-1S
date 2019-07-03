library(tidyverse)
library(rpart)

# Complete a funcao normalizar que normaliza um vetor x 
# para deixar os valores entre 0 e 1
normalizar = function(x){
}

# Complete a funcao tpr que recebe os vetores real e predito 
# e retorna a taxa de verdadeiros positivos
tpr = function(real,predito){
}

# Complete a funcao fpr que recebe os vetores real e predito
# e retorna a taxa de falsos positivos
fpr = function(real,predito){
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
df = read.csv('')
#Converta a coluna RainTomorrow para factor
df$RainTomorrow = 


#2. Divida em treino e teste (30%)
set.seed(2019)
rows_test = 
train =
test = 


# Arvore de decisao com 5-fold CV e regressao logistica ----

#HIPERPARAMETROS DA ARVORE
#minbucket: de 25 a 150 com passo de 25
#cp: 0.01, 0.1 e 0.15
#maxdepth: 2,3,4 e 5 

#3. Use cross validation com 5 folds para ajustar os hiperparâmetros acima

rpart_tune = 


cv_index = 

for(i in 1:nrow(rpart_tune)){
  fold = 
  
  
  split_train = 
  split_test = 
  
  m = 

  
  ypred = 
  rpart_tune$acc[i] = 
}


#4. Qual a configuração que apresenta a melhor performance, de acordo com a acurácia? (1,0)

#5. Treine um modelo (no conjunto de treino completo) com a configuração do item
#a e avalie acurácia, taxa de verdadeiros positivos (tpr) e taxa de falsos 
#positivos (fpr) no conjunto de teste. (0,5)

tree_model = rpart()

preds_tree = predict()

test_label = test$RainTomorrow
acc_tree = mean)
tpr_tree = tpr()
fpr_tree = fpr()

#REGRESSAO LOGISTICA
#6. Treine um modelo de regressão logística no conjunto de treino. Se probabilidade
#de chuva for maior do que 0,5, considere que choverá. Qual a acurácia, tpr e 
#fpr no conjunto de teste para este modelo? 
logit_model = 
preds_logit = 


table(preds_logit,test_label)
acc_logit = 
tpr_logit = 
fpr_logit = 

#Use a funcao table, junto com preds_tree e preds_logit para obter as matrizes de confusao dos modelos.
#7. Complete as matrizes de confusao abaixo e discuta qual modelo utilizar considerando a premissa:
# Custa menos dizer que não choverá e, na verdade, chova do que dizer que choverá e na verdade, não chova.
table()
table()


# Para checar a importância de variáveis na árvore, se seu modelo chama tree_model,
# use o comando: tree_model$variable.importance. 
# Para ver os valores de coeficientes para a regressao logistica use (coef(logit_model)) 
#8. Compare e discuta sucintamente a importância de atributos para a árvore e para a regressão logística. 
