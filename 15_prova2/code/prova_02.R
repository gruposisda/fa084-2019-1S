library(tidyverse)
library(mlr)
library(mlbench)
library(nnet)
library(e1071)

normalize = function(col){
  col = (col-min(col))/(max(col)-min(col))
}

#Se nao tiver algum dos pacotes acima, basta instalar com
#install.packages("nome_do_pacote")

#Carregue o conjunto de dados ele carrega sozinho ao carregar o pacote mlbench
set.seed(2019)
df = read_csv('../data/cardio.csv')


#Questao 1 - Exploracao do conjunto de dados -----------------------------------

#Considere que vamos prever se um paciente tem ou nao problema cardiaco.

#A) Esta e uma tarefa de classificacao ou regressao?

#B) Quantos atributos preditores vamos usar?
glimpse(df)
#C) Quantos pacientes com e sem problemas cardiacos temos no dataset?

#D) 1. Quantos homens e mulheres existem no dataset? Os gêneros estao divididos 
#em 0 e 1, assuma que, em media, mulheres sao mais leves e homens sao mais altos,
#e verifique qual gênero corresponde a quais números.

#E)Crie uma feature nova `bmi` que contem o indice de massa corporal, dado pela 
# massa dividida pela altura elevada ao quadrado. No conjunto, a altura (`height`)
# está em `cm` e a massa (`weight`) em `kg`. Com base nessa feature, 
# marque as corretas:


#1. A mediana do bmi esta num intervalo considerado normal (18.5-25)
#2. O bmi para mulheres e, em media, maior que o de homens
#3. Pessoas saudáveis (`cardio == 0`), tem, em media, bmi mais alto do que pessoas com doenca (`cardio == 1`)
#4. Para homens saudáveis, e que nao consomem álcool, o bmi medio e mais proximo do normal do que para mulheres saudáveis que nao consomem álcool


#Questao 2 - Preparacao do conjunto de dados------------------------------------
#A) Exclua a coluna bmi (obrigatoria) e outra(s) coluna(s) que nao considere 
# adequadas para modelagem.
# Justifique brevemente o porquê.
# Em seguida, normalize todas as colunas restantes para terem valores entre 0 e 1.
normdf = df %>% select(-id)
normdf = normdf %>% apply(.,2,normalize) %>% as.data.frame()

#B) Converta a coluna cardio para factor
normdf = mutate(normdf,cardio=as.factor(cardio))

#Na questão 3 vamos comparar o desempenho de redes neurais e SVM para 
#classificar os pacientes em com ou sem problemas cardiacos.

#Questao 3 - Redes neurais -----------------------------------------------------

#A) Crie uma funcao sigmoide que tem como entrada um valor x e saída o valor da função sigmoide
sigmoid = function(x){
  1/(1 +exp(-x))
}
#B) Crie um vetor detamanho 6 com os digitos do seu RA em cada indice.
ra_vec = c(1,1,8,1,0,0)
  
#C) Use o vetor w abaixo como pesos e o valor de b como vies.
w = c(0.5,0.8,-0.3,-0.6,-1,1)
b = 2

#Calcule a saida de um neuronio que tem como entrada ra_vec, pesos w  e bias b, 
# com a funcao de ativacao sigmoide. Quais os valores maximos e minimos da funcao?
sigmoid(sum(ra_vec*w)+b)


#Questao 4 - Neural Networks vs SVM --------------------------------------------

#A) Crie uma task de treino (70%) e de teste. Use os procedimentos de "agora e sua vez",
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

#C) Defina os parametros a serem ajustados.
#SVM:
#Custo é um hiperparametro numerico que deve variar entre 0.1 e 1.
#Gamma é um hiperparametro numerico que deve variar entre 0.1 e 2.

#NN:
#Size é um hiperparametro inteiro que deve variar de 2 a 5.



params_svm = makeParamSet(makeNumericParam("cost",lower = 0.1,
                                           upper = 1),
                          makeNumericParam("gamma", lower = 0.1,
                                           upper = 2))

params_nn = makeParamSet(makeIntegerParam('size',lower=2,upper=5))
#D) Escolha um dos hiperparametros da SVM e explique seu significado

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

#G) Quais os melhores parâmetros de cada tecnica?
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

#K) Preencha as matrizes de confusao de cada modelo. Use calculateConfusionMatrix()
#nas predicoes acima.
calculateConfusionMatrix(preds_svm)
calculateConfusionMatrix(preds_nn)


#Considere a premissa:
#"e melhor dizer que o paciente tem doenca cardiaca e o mesmo nao ter do que 
# dizer que ele nao tem e, na verdade, ter."
#Qual modelo seria melhor nesse caso? Justifique com suas palavras.


#Questao Bonus ----------------------------------------------------------------
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
#Não há meio certo para o bonus, salvar o arquivo é parte do bonus.
#Leia a documentacao da funcoes envolvidas, se necessario.
compare_results = data.frame(nn_results,svm_results)
colnames(compare_results) = c('nn','svm')
compare_results = compare_results %>% rownames_to_column('measure') 

#Questao 5: ggplot --------------------------------------------------------------
#Independentemente de conseguir construir o dataframe, importe o arquivo compare_results.csv.
#As medidas do arquivo nao necessariamente refletem as encontradas acima.
#Use o compare_results como entrada do pipe abaixo para produzir o gráfico.

#A) Explique o que a funcao "gather" faz, na linha abaixo.
compare_results %>% gather("model","value",-measure) %>% 
  ggplot(aes(x=measure,y=value,fill=model)) + 
  geom_col(position='dodge')
#B) Mude nomes dos eixos x e y para "Measures" e "Value",respectivamente. 
# Adicone o titulo "NN vs SVM"
# Salve o novo plot na variavel "renamed_plot".
renamed_plot = compare_results %>% gather("model","value",-measure) %>% 
  ggplot(aes(x=measure,y=value,group=model,fill=model)) + 
  geom_col(position = 'dodge') +
  labs(x = "Measures",y="Value",title='NN vs SVM')
renamed_plot
  
#C) Salve o gráfico (renamed_plot) na pasta 'data' com a extensão .jpg
ggsave('../data/questao4_C.jpg',renamed_plot)


#D) O que podemos fazer para diminuir a diferenca de proporcao entre as barras pequenas
# e as grandes?
renamed_plot + coord_trans(y='sqrt')

# Questao 6
#A) Clusterize os dados de USArrests (ja vem carregado no R). Use a rotina vista em aula
# para escolher o melhor numero de clusters. Teste valores de k de 1 a 20.
# Além do parametro k, no loop, use nstart=25 dentro de makeLearner para ter um resultado mais consciso.
# Use seed 2019 antes do loop

cluster_data = USArrests
cluster_data = as.data.frame(apply(cluster_data,2,normalize))
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

learner = makeLearner('cluster.kmeans',centers=4)
tr = train(learner,cluster_task)
clusters =tr$learner.model$cluster


#B) Crie uma coluna nova "clusters" em cluster_data, que recebe os clusters.
cluster_data$clusters = clusters
head(cluster_data)
table(cluster_data$clusters)

set.seed(2019)
cluster_data = cluster_data %>% group_by(clusters) %>% summarise_all(mean) %>% sample_n(4)
cluster_data
cluster_data %>% 
  select(-clusters) %>% write_csv('../data/find_cluster.csv')


#C) Temos novas observacoes arquivo find_cluster.csv. 
# Novos dados de crimes de regioes. 
# Use uma rotina concisa para atribuir cada observacao a um cluster.
find_cluster = read_csv('../data/find_cluster.csv')
cl_learner = makeLearner('classif.svm')
cl_task = makeClassifTask('cluster',cluster_data,target='clusters')

cl_mod = train(cl_learner,cl_task)
predict(cl_mod$learner.model,find_cluster) %>% unname()
