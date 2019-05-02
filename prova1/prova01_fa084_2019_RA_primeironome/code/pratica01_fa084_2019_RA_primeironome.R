#Carregue as bibliotecas necessarias
library(tidyverse)
library(class)
library(rpart)
library(caret)
library(gbm)

#Funcoes utilizadas
#implmente as funcoes tpr e fpr
tpr = function(real,predito)

fpr = function(real,predito){
}

#não altere a funcao create_fold_index
create_fold_index = function(nrows, folds){
  set.seed(2019)
  k_index = rep(1:folds, ceiling(nrows/folds))
  k_index = k_index[1:nrows]    
  k_index = sample(k_index)
  return(k_index)
}


#Importe os dados ----
df = 
#converta o atributo meta para fator
df$RainTomorrow = as.factor(df$RainTomorrow)

#Divida em treino e teste
rows_test = 
train = 
test = 

#Modelagem com knn ----
#a)Estruture os dados de treino e teste para serem usados para uma modelagem 
#usando a função knn() do pacote class. (0,5)

train_knn = 

test_knn = 


#b)Use a função knn()  para criar dois vetores de predições para o conjunto 
#de teste, um com k = 5 e outro com k = 11. (0,5) 

preds_knn11= 
acc_knn11 = 
tpr_knn11 = 
fpr_knn11 = 

preds_knn5 =

acc_knn5 = 
tpr_knn5 = 
fpr_knn5 = 

# Crie um dataframe com os dados:  (1,0)
# # k: número de vizinhos usados
# # acc: acurácia obtida para cada k
# # tpr:  taxa de verdadeiros positivos  para cada k
# # fpr: taxa de falsos positivos para cada k
# O dataframe terá 2 linhas e 4 colunas.
knn_metrics = data.frame()



# Arvore de decisao com 5-fold CV e regressao logistica ----

#HIPERPARAMETROS DA ARVORE
#minbucket: 25, 50, 75 e 100
#cp: 0.01 e 0.1
#maxdepth: 2,3 e 4 

#ARVORE DE DECISAO

#Use cross validation com 5 folds para ajustar os hiperparâmetros especificados no script.
rpart_tune = data.frame()


cv_index = 

#a)Qual a configuração que apresenta a melhor performance, de acordo com a acurácia? (1,0)

#b)Treine um modelo (no conjunto de treino completo) com a configuração do item
#a e avalie acurácia, taxa de verdadeiros positivos (tpr) e taxa de falsos 
#positivos (fpr) no conjunto de teste. (0,5)

preds_tree = 


acc_tree = 
tpr_tree = 
fpr_tree = 

#REGRESSAO LOGISTICA
#c)Treine um modelo de regressão logística no conjunto de treino. Se probabilidade
#de chuva for maior do que 0,5, considere que choverá. Qual a acurácia, tpr e 
#fpr no conjunto de teste para este modelo? (0,5)

preds_logit = 

acc_logit = 
tpr_logit = 
fpr_logit =


# Boosting com caret ----

# interaction.depth: 1, 5 e 9.
# n.trees = de 50 a 250 com passo de 50
# shrinkage = 0.1
# n.minobsinnode = 20


gbmGrid =

preds_boost = 

acc_boost = 
tpr_boost = 
fpr_boost = 


#data frame para comparar os modelos:
tree_model$variable.importance
coef(logit_model)
