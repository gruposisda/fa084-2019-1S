library(tidyverse)
library(mlr)

#Defina a funcao normalizar:
normalizar = function(x){
  (x - min(x))/(max(x) - min(x))
}


#1) Crie uma funcao sigmoide que tem como entrada um valor x e saída o valor da função sigmoide
sigmoid = function(x){
  1/(1 +exp(-x))
}
#2) Crie um vetor detamanho 6 com os digitos do seu RA em cada indice.
ra_vec = c(1,1,8,1,0,0)
  
#3) Crie um vetor w com pesos com valores entre -1 e 1 e defina um valor b para o bias
w = c(0.5,0.8,-0.3,-0.6,-1,1)
b = 2

#4)Calcule a saida de um neuronio que tem como entrada ra_vec, pesos w  e bias b, 
# com a funcao de ativacao sigmoide. 
sigmoid(sum(ra_vec*w)+b)

#5)Faca um gráfico da funcao sigmoide com os valores de -100 a 100 como entrada.
# Salve o gráfico na pasta data em formato .jpg
# Quais os valores maximos e minimos da funcao?
qplot(-10:10,sigmoid(-10:10)) + geom_line()
plot(-10:10,sigmoid(-10:10))



#6 - Random Forest vs SVM --------------------------------------------
# Importe os dados de 'cardio.csv', exclua coluna(s) irrelevantes para a modelagem 
# e normalize os dados, e converta a coluna 'cardio' para factor
df = read.csv('../data/cardio.csv')
df = df %>% select(-id)
normdf = df  %>% lapply(., normalizar) %>% as.data.frame()
normdf$cardio = as.factor(normdf$cardio)

#A) Crie uma task de treino (70%) e de teste. Use os procedimentos de "agora e sua vez",
#da aula 11(11_mlr_svm_base.html, baixe o arquivo e abra no navegador).
#Complete as lacunas abaixo. Crie mais variaveis se julgar adequado.
task = makeClassifTask(data = normdf, target = 'cardio')
task

#A1)Defina o holdout. O argumento split corresponde a % de treino em decimal.
#Crie uma task de treino e uma task de teste.
#SEMPRE execute o set.seed(2019) junto com a linha que cria a variavel holdout.
set.seed(2019)
holdout = makeResampleInstance("Holdout",task, split = 0.7)
tsk_train = subsetTask(task, holdout$train.inds[[1]])
tsk_test = subsetTask(task, holdout$test.inds[[1]])

#B) Defina os learners
svm_learner = makeLearner("classif.svm")
rf_learner = makeLearner('classif.randomForest')

#C) Defina os parametros a serem ajustados.
#Para verificar os parametros de um learner, pode usar:
#getLearnerParamSet(variavel_do_learner)
#SVM:
#Custo é um hiperparametro numerico que deve variar entre 0.1 e 1.
#Gamma é um hiperparametro numerico que deve variar entre 0.1 e 2.

#NN:
#Size é um hiperparametro inteiro que deve variar de 2 a 5.
params_svm = makeParamSet(makeNumericParam("cost",lower = 0.1,
                                           upper = 1),
                          makeNumericParam("gamma", lower = 0.1,
                                           upper = 2))

params_rf = makeParamSet(makeIntegerParam('ntree',lower=100,upper=500),
                        makeIntegerParam('mtry', lower = 2, upper = 5))

#D) Escolha um dos hiperparametros da Random Forest e explique seu significado

#E) Defina o controle: RandomSearch com 20 iteracoes
tune_control = makeTuneControlRandom(maxit=20)

#F) Ajuste os parametros das duas tecnicas.
# Use set.seed(2019) antes da linha de ajuste de parametros
# Selecione e execute as duas linhas juntas para resultados consistentes.
set.seed(2019)
tr_svm = tuneParams(svm_learner,tsk_train,cv5,list(acc),
                    params_svm,tune_control)

set.seed(2019)
tr_rf = tuneParams(rf_learner,tsk_train,cv5,list(acc),params_rf,tune_control)


#G) Quais os melhores parâmetros de cada tecnica?
tr_svm$x
tr_rf$x

#H) Use setHyperPars para ajustar os parametros encontrados aos learners criados
tuned_svm = setHyperPars(svm_learner,par.vals = tr_svm$x)
tuned_rf = setHyperPars(rf_learner,par.vals = tr_rf$x)

#I) Treine no conjunto completo com a funcao train()
tuned_svm = train(tuned_svm, tsk_train)
tuned_rf = train(tuned_rf, tsk_train)

#J) Faca as predicoes na task de teste. Qual a acuracia dos dois modelos?
preds_svm = predict(tuned_svm,tsk_test)
preds_rf = predict(tuned_rf,tsk_test)

#K) Preencha as matrizes de confusao de cada modelo. Use calculateConfusionMatrix()
#nas predicoes acima.
calculateConfusionMatrix(preds_svm)
calculateConfusionMatrix(preds_rf)


#Considere a premissa:
#"e melhor dizer que o paciente tem doenca cardiaca e o mesmo nao ter do que 
# dizer que ele nao tem e, na verdade, ter."
#Qual modelo seria melhor nesse caso? Justifique com suas palavras.





