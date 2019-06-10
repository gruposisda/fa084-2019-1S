library(tidyverse)
library(mlr)
library(mlbench)
library(neuralnet)
library(e1071)

normalize = function(col){
  col = (col-min(col))/(max(col)-min(col))
}

#Se nao tiver algum dos pacotes acima, basta instalar com
#install.packages("nome_do_pacote")

#Carregue o conjunto de dados ele carrega sozinho ao carregar o pacote mlbench
data(PimaIndiansDiabetes)
df = PimaIndiansDiabetes
set.seed(2019)
df = read_csv('../data/cardio_data.csv') %>% sample_n(1000)

# id  =	Patient ID
# age =	Age in days
# gender =	Male or female
# age = Age in days
# height =	Height in cm
# weight =	Weight in kg
# ap_hi =	Arterial Pressure (high)
# ap_lo =	Arterial Pressure (low)
# cholesterol =	Cholesterol Level
# gluc =	Glucose Level
# smoke =	Smoking or not
# alco =	Drinks alco or not
# active =	Practices physical acitivity at least 3 times a week
# cardio =	Has cardio probem or not

#Questão 1 - Exploração do conjunto de dados

#Considere que vamos prever se um paciente tem ou nao problema cardiaco.

#A) Esta e uma tarefa de classificacao ou regressao?

#B) Quantos atributos preditores vamos usar?

#C) Quantos pacientes com e sem problemas cardiacos temos no dataset?

#D) 1. Quantos homens e mulheres existem no dataset?Os gêneros estão divididos 
#em 0 e 1, assuma que, em média, mulheres são mais leves e homens são mais altos,
#e verifique qual gênero corresponde a quais números.

#E)Crie uma feature nova `bmi` que contem o indice de massa corporal, dado pela 
# massa dividida pela altura elevada ao quadrado. No conjunto, a altura (`height`)
# está em `cm` e a massa (`weight`) em `kg`. Com base nessa feature, 
# marque as corretas:


#1. A mediana do bmi esta num intervalo considerado normal (18.5-25)
#2. O bmi para mulheres é, em média, maior que o de homens
#3. Pessoas saudáveis (`cardio == 0`), tem, em média, bmi mais alto do que pessoas com doença (`cardio == 1`)
#4. Para homens saudáveis, e que não consomem álcool, o bmi médio é mais proximo do normal do que para mulheres saudáveis que não consomem álcool

#Questão 2 - Preparacao do conjunto de dados
#A) Exclua coluna(s) que não será(ão) Considere inadequadas para modelagem.
# Justifique brevemente o porquê.
# Em seguida, normalize todas as colunas restantespara terem valores entre 0 e 1.
normdf = df %>% select(-id)
normdf = df %>% apply(.,2,normalize) %>% as.data.frame()

#B) Converta a coluna cardio para factor
normdf = mutate(normdf,cardio=as.factor(cardio))

#Nas questões 3 e 4 vamos comparar o desempenho de redes neurais e SVM para 
#classificar os pacientes em com ou sem problemas cardiacos.

#Questão 3 - Neural Networks vs SVM

#A) Crie uma task de treino (70%) e de teste. Use os procedimentos de "agora é sua vez",
#da aula 11(11_mlr_svm_base.html, baixe o arquivo e abra no navegador).
#Complete as lacunas abaixo. Crie mais variaveis se julgar adequado.
task = makeClassifTask(data = normdf, target = 'cardio')
task
set.seed(2019)
#A1)Defina o holdout. O argumento split corresponde a % de treino em decimal
holdout = makeResampleInstance("Holdout",task, split = 0.7)
#A2)task de treino
tsk_train = subsetTask(task, holdout$train.inds[[1]])
#A3)task de teste
tsk_test = subsetTask(task, holdout$test.inds[[1]])

#B) Defina os learners
svm_learner = makeLearner("classif.svm")
nn_learner = makeLearner('classif.nnet')

#C) Defina os parametros a serem ajustados
params_svm = makeParamSet(makeNumericParam("cost",lower = 0.1,
                                           upper = 1),
                          makeNumericParam("gamma", lower = 0.1,
                                           upper = 1))

params_nn = makeParamSet(makeIntegerParam("size",lower = 2,
                                         upper = 5))

#E) Defina o controle: RandomSearch com 50 iteracoes
tune_control = makeTuneControlRandom(maxit=50)

#F) Ajuste os parametros das duas tecnicas
t0 = Sys.time()
set.seed(2019)
tr_svm = tuneParams(svm_learner,tsk_train,cv5,list(acc),
                    params_svm,tune_control)
t1 = Sys.time()


t0 = Sys.time()
set.seed(2019)
tr_nn = tuneParams(nn_learner,tsk_train,cv5,list(acc),params_nn,tune_control)
t1 = Sys.time()

#G) Quais os melhores parâmetros de cada técnica?
tr_svm$x
tr_nn$x

#H) Use setHyperPars para ajustar os parametros encontrados aos learners criados
tuned_svm = setHyperPars(svm_learner,par.vals = tr_svm$x)
tuned_nn = setHyperPars(nn_learner,par.vals = tr_nn$x)

#I) Treine no conjunto completo com a funcao train()
tuned_svm = train(tuned_svm, tsk_train)
tuned_nn = train(tuned_nn, tsk_train)

#J) Faca as predicoes na task de teste. Qual a acuracia dos dois modelos?
preds_svm = predict(tuned_svm,tsk_test)
preds_nn = predict(tuned_nn,tsk_test)

#K) Considere a premissa:
#"É melhor dizer que o paciente tem doenca cardiaca e o mesmo não ter do que 
# dizer que ele não tem e, na verdade, ter."
#Qual modelo seria melhor nesse caso? Justifique com suas palavras.


#Bonus:
roc_svm = calculateROCMeasures(preds_svm)
roc_nn = calculateROCMeasures(preds_nn)
roc_svm
roc_nn

nn_results = roc_nn$measures %>% unlist() 
svm_results = roc_svm$measures %>% unlist() 

#construa o dataframe compare_results com as medidas nn_results e svm_results
#definidas acima. A saida deve ser igual ao arquivo compare_results.csv

#Se conseguir construir no mesmo formato, salve o arquivo como compare_results_bonus 
#e deixe o codigo abaixo. Para salvar, use write_csv(). 
#Leia a documentacao da funcoes envolvidas, se necessario.
compare_results = data.frame(nn_results,svm_results)
colnames(compare_results) = c('nn','svm')
compare_results = compare_results %>% rownames_to_column('measure') %>%
  write_csv('../data/compare_results.csv')

#Se nao conseguir construi o dataframe, importe o arquivo.
#As medidas do arquivo nao necessariamente refletem as encontradas acima.

#Questão 4: Use o compare_results como entrada do pipe abaixo para produzir o gráfico.
#A) Explique o que a funcao "gather" faz, na linha abaixo.
compare_results %>% gather("model","value",-measure) %>% 
  ggplot(aes(x=measure,y=value,group=model,fill=model)) + 
  geom_col(position='dodge')
#B) Mude nomes dos eixos x e y para "Measure" e "Value" e adicone o título "NN vs SVM
renamed_plot = compare_results %>% gather("model","value",-measure) %>% 
  ggplot(aes(x=measure,y=value,group=model,fill=model)) + 
  geom_col(position='dodge')
  
#C) Salve o gráfico na mesma pasta do script
renamed_plot

#D) O que podemos fazer para diminuir a diferenca de proporcao entre as barras pequenas
# e as grandes?

# Questao 5
#A) use os dados de USArrests (ja vem carregado no R).
cluster_data = USArrests
cluster_data
# Use o comando abaixo para remover os row_names de cluster_data
rownames(cluster_data) = NULL

cluster_task = makeClusterTask('cluster',cluster_data)

k_to_test = c(1:20)
wssvec = numeric()
set.seed(2019)
for(k in k_to_test){
  learner = makeLearner('cluster.kmeans',centers=k,nstart=25)
  tr = train(learner,cluster_task)
  wss = tr$learner.model$tot.withinss
  wssvec = c(wssvec,wss)
}
plot(k_to_test,wssvec)

learner = makeLearner('cluster.kmeans',centers=3)
tr = train(learner,cluster_task)
clusters =tr$learner.model$cluster


#B) Crie uma coluna nova "clusters" em cluster_data, que recebe os clusters.
cluster_data$clusters = clusters
head(cluster_data)

#C) Temos 3 novas observacoes arquivo find_cluster.csv. 
# Use uma rotina concisa para predizer a qual cluster cada uma pertence.



