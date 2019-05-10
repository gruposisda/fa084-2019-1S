# pre_aula_11 -------------------------------------------------------------

#Siga as instruções abaixo e responda as perguntas ao longo do script
#Não use o pacote caret

# Ler o arquivo "satelite_data.csv";
# Dividir em treino (70%) e teste (30%)
# Modelar "Class" em funcao das demais variaveis, implementando SVM;
# Variar "cost" = 1e-01 1e+00 1e+01 1e+02 1e+03;
# gamma = 0.001 0.010 0.100;
# Obter a melhor combinacao de hiperparametros usando validacao cruzada com 7 folds
# Criar um modelo com a melhor combinacao e calcular a acuracia no teste;
# Dica: O atributo meta deve ser uma varavel do tipo "factor"

#install.packages("e1071")
library(e1071)
library(tidyverse)

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

#importe o conjunto de dados

df = read_csv('../data/satelite_data.csv')

df$Class = as.factor(df$Class)

#Verifique os dados e veja se alguma coluna precisa ser excluida e/ou convertida

df = df %>% select(-X1) %>% mutate(Class = as.factor(Class))

#Use as funcoes gather, group_by e summarise para chegar a um dataframe igual
#ao do arquivo "df_summary.csv"

df %>% gather(-Class,key='type',value = 'valor') %>%
  group_by(Class,type) %>% 
  summarise(media = mean(valor), min = min(valor), max = max(valor), mediana = median(valor)) #%>%
  #write_csv('../data/df_summary.csv')


#Divida em treino e teste
set.seed(1)
id_train = sample(nrow(df), 0.7*nrow(df))

df_train = df[id_train, ]
df_test = df[-id_train, ]

#Normalize as variaveis para ficarem com valores entre 0 e 1

#  criando os fold index para validacao cruzada --------------------------------


create_fold_index = function(nrows, folds){
  k_index = rep(1:folds, ceiling(nrows/folds))
  k_index = k_index[1:nrows]    
  k_index = sample(k_index)
  return(k_index)
}

k_fold_index = create_fold_index(nrow(df_train),7)


#  Dataframe para avaliacao -----------------------------------------------

tune_svm = data.frame(expand.grid(fold = 1:7,
                          cost = 10^(-1:3),
                          gamma = 10^(-3:-1)
                        
))

tune_svm$acc = NA

for(i in 1:nrow(tune_svm)){
  k = tune_svm$fold[i]
  split_train = df_train[k_fold_index != k, ]
  split_test= df_train[k_fold_index == k, ]
  m = svm(Class~.,split_train,
          cost = tune_svm$cost[i],
          gamma = tune_svm$gamma[i])
  ypred = predict(m, split_test)
  tune_svm$acc[i] = mean(ypred == split_test$Class)
  
}

tune_svm_final = tune_svm %>% select(-fold) %>% group_by(cost, gamma) %>% 
  summarise(acc_train = mean(acc)) %>% arrange(desc(acc_train))


#  Utilizando a melhor combinacao de hiperparametros ----------------------

m1 = svm(Class~.,df_train,
        cost = tune_svm_final$cost[1],
        gamma = tune_svm_final$gamma[1])
ypred = predict(m1, df_test)

(acc_test = mean(ypred == df_test$Class))

