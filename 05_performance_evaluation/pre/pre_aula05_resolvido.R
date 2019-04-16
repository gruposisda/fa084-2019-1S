create_fold_index = function(nrows, folds){
# cria um vetor com repeticao dos valores de 1 ate folds e repete isso 
# um numero de vezes o numero de linhas dividido pelo numero de folds
  # arredondado para cima. para 10 linhas e 3 folds, o exemplo e:
# 123123123123 rep(1:3, 4)
  k_index = rep(1:folds, ceiling(nrows/folds))
# utilizaremos apenas as posicoes deste vetor para o numero de linhas
  k_index = k_index[1:nrows]    
  return(k_index)
}

tpr = function(preds, real){
  sum(preds == 1 & real == 1)/sum(real == 1)
}

fpr = function(preds, real){
  sum(preds == 1 & real == 0)/sum(real == 0)
}

df = read.csv('~/data/fa084/titanic/mod_titanic.csv')

#remova a coluna PassengerId
df = df %>% select(-PassengerId)

seu_ra = 118100 # Substitua aqui os digitos do seu RA


# a variavel fold_index e um indice para ser utilizado para
# split dos folds no cross_validation. Ele tem o mesmo
# numero de elementos que linhas no conjunto de treino
# e tem  valores de 1 a 5 (inteiros)
fold_index = create_fold_index(nrow(df), 5)

#embaralha o fold index
set.seed(223)#neste dia 22-03 em 1935 O primeiro programa regular de televisão no mundo é transmitido através da antena no alto da Torre de Rádio de Berlim.
fold_index = sample(fold_index)

# criacao de um data.frame para armazenar os resultados do erro 
# em cada fold de test
eval_lr = data.frame(test_fold=1:5, acc = NA, tpr = NA, fpr = NA)


#em cada etapa do cross validation, variamos os dados de treino e teste de acordo com o fold

#Em cada iteracao, as linhas do df onde o fold é i, serao usadas para teste
#Ou seja, se temos K folds, teremos K acuracias, tpr e fpr no conjunto de teste
#Dica use i = 1 manualmente e execure cada linha DENTRO do for, se rodar tudo com i = 1, deve rodar para os outros, ai é só executar o loop todo

for(i in 1:nrow(eval_lr)){
  #variavel que contem o numero dos folds que serao usados para teste
  #estão em eval_lr na coluna test_fold no indice i ;)
  test_fold = eval_lr$test_fold[i]

  #rows_test deve conter um vetor de trues e falses com true para as linhas usadas para treino.
  #Ou seja, onde fold_index eh igual a test_fold
  #Por exemplo, quanto test_fold é 1, as linhas usadas para teste serao as que tem fold_index igual a 1.
  #Assim, o conjunto de teste sempre eh menor que o de treino, pois usamos um fold para teste e quatro para treino
  rows_test = fold_index == test_fold
  
  #note que aqui ambos os splits sao derivados do conjunto de treino
  split_train = df[!rows_test, ] #as linhas aqui NAO(!) devem estar em rows_test
  split_test = df[rows_test, ]
  
  #treine um modelo de reg. logistica
  fold_model =  glm(Survived~.,split_train,family = 'binomial')
  #faca as predicoes, ypred deve ser true para probabilidades maiores do que 0.5
  ypred = predict(fold_model, split_test, type = 'response') > 0.5 
  #transorme ypred em numerico
  ypred = as.numeric(ypred)
  
  eval_lr$tpr[i] = tpr(ypred,split_test$Survived)
  eval_lr$fpr[i] = fpr(ypred,split_test$Survived)
  eval_lr$acc[i] = mean(ypred == split_test$Survived)
}


eval_lr
