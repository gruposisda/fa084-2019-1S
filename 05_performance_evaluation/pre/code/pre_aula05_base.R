library(class)

create_fold_index = function(nrows, folds){
# cria um vetor com repeticao dos valores de 1 ate folds com tamanho nrows
  k_index = rep(1:folds, ceiling(nrows/folds))
# utilizaremos apenas as posicoes deste vetor para o numero de linhas
  k_index = k_index[1:nrows]    
  return(k_index)
}

#implemente as funcoes
tpr = function(preds, real){
  
}

fpr = function(preds, real){
 
}

#importe o conjunto, nao divida em treino e teste, isso eh feito no loop em cada cv
df = 

#remova a coluna PassengerId
df = 

seu_ra = # Substitua aqui os digitos do seu RA e use no set.seed na linha 35.


# a variavel fold_index e um indice para ser utilizado para
# split dos folds no cross_validation. Ele tem o mesmo
# numero de elementos que linhas no conjunto de treino
# e tem  valores de 1 a 5 (inteiros)
  
#crie a variavel usando a funcao fold index, folds deve ser 5
fold_index = create_fold_index(,)

set.seed(2203)#neste dia (22-03) em 1935 O primeiro programa regular de televisão no mundo foi transmitido através da antena no alto da Torre de Rádio de Berlim.
#embaralha o fold_index:
fold_index = sample(fold_index)

# criacao de um data.frame para armazenar os resultados do erro 
# em cada fold de test
eval_lr = data.frame(test_fold=1:5, 
                     acc = NA, 
                     tpr = NA, 
                     fpr = NA)

#em cada etapa do cross validation, variamos os dados de treino e teste de acordo com o fold

#Em cada iteracao, as linhas do df onde o fold é i, serao usadas para teste
#Ou seja, se temos K folds, teremos K acuracias, tpr e fpr no conjunto de teste
#Dica use i = 1 manualmente e execure cada linha DENTRO do for, se rodar tudo com i = 1, deve rodar para os outros, ai é só executar o loop todo

for(i in 1:nrow(eval_lr)){
  #variavel que contem o numero dos folds que serao usados para teste
  #dica: estão em eval_lr na coluna test_fold no indice i ;)
  test_fold = 

  #rows_test deve conter um vetor de trues e falses com true para as linhas usadas para teste.
  #Ou seja, onde fold_index eh igual a test_fold
  #Por exemplo, quanto test_fold é 1, as linhas usadas para teste serao as que tem fold_index igual a 1, 
  #e os indices 2,3,4,5 serao usados para treino.
  #Na proxima iteracao o test_fold sera 2, ai os indices 1,3,4,5 serao linhas de treino. Etc.
  #Assim, o conjunto de teste sempre eh menor que o de treino, pois usamos um fold para teste e quatro para treino.
  rows_test = 
  
  #faca os splits
  split_train = df[, ]
  split_test = df[, ] 
  
  #treine um modelo de reg. logistica no split train
  
  #faca as predicoes, ypred deve ser true para probabilidades maiores do que 0.5

  #transorme ypred em numerico
  
  #preencha  o eval_lr com as metricas corretas
  eval_lr$tpr[i] =
  eval_lr$fpr[i] =
  eval_lr$acc[i] =
}

#veja os resultados
eval_lr
