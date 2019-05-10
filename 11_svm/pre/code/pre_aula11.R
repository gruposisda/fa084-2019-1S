# pre_aula_11 -------------------------------------------------------------
create_fold_index = function(nrows, folds){
  k_index = rep(1:folds, ceiling(nrows/folds))
  k_index = k_index[1:nrows]    
  k_index = sample(k_index)
  return(k_index)
}

#Siga as instruções abaixo e responda as perguntas ao longo do script
#Não use o pacote caret
#Sempre escreva os comandos referentes aos comentarios logo abaixo dos comentarios

# Ler o arquivo "satelite_data.csv";
# Dividir em treino (70%) e teste (30%)
# Modelar "Class" em funcao das demais variaveis, implementando SVM;
# Variar "cost" = 1e-01 1e+00 1e+01 1e+02 1e+03;
# gamma = 0.001 0.010 0.100;
# Obter a melhor combinacao de hiperparametros usando validacao cruzada com 7 folds
# Criar um modelo com a melhor combinacao e calcular a acuracia no teste;
# Dica: O atributo meta deve ser uma varavel do tipo "factor"

#install.packages("e1071"), este pacote contem a funcao svm
library(e1071)
library(tidyverse)


#importe o conjunto de dados

df = 


#Verifique os dados e veja se alguma coluna precisa ser excluida e/ou convertida



  

#Use as funcoes gather, group_by e summarise para chegar a um dataframe igual
#ao do arquivo "df_summary.csv"



#Normalize as variaveis para ficarem com valores entre 0 e 1


#Divida em treino e teste
set.seed(1)
id_train = sample(nrow(df), 0.7*nrow(df))






#  crie os fold index para validacao cruzada --------------------------------

k_fold_index = create_fold_index()


#Crie o dataframe para avaliacao -----------------------------------------------

tune_svm = data.frame(expand.grid(fold = ,
                          cost = ,
                          gamma = 
                        
))

tune_svm$acc = 

for(i in 1:nrow(tune_svm)){
  k = 
  split_train = 
  split_test= 
  m = svm()
  ypred = predict()
  tune_svm$acc[i] = 
}

tune_svm_final = tune_svm %>% select(-fold) %>%
  group_by(cost, gamma) %>% 
  summarise(acc_train = mean(acc)) %>% 
  arrange(desc(acc_train)) #chique

#Qual a diferrenca entre a maior e menor acurácias?

#Utilize a melhor combinacao de hiperparametros para criar o modelo final

tuned_model = svm(Class~.,data =,
                  cost = ,
                  gamma = )
#Faca as predicoes e obtenha a acuracia final do modelo no conjunto de teste
ypred = 

#Bonus: Imprima a frase "A melhor acuracia foi de (acc), com gama (tal) e cost (tal)"
  #Dica: Precisa usar o comando paste0
x = 10
y = 15
paste0('Exemplo de como dizer que x vale ', x, ' e y vale ', y, ' e a soma dos dois é ', x + y)
