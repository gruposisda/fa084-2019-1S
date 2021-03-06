# install.packages("tidyverse")
# install.packages("mlr")
# install.packages("mlbench")
# install.packages("nnet")
# install.packages("e1071")
# install.packages("clue")ibrary(tidyverse)
library(mlr)
library(mlbench)
library(nnet)
library(e1071)
library(clue)

#Se nao tiver algum dos pacotes acima, basta instalar com
#install.packages("nome_do_pacote")

#Carregue o conjunto de dados 
df = read_csv()

#Questao 1 - Exploracao do conjunto de dados -----------------------------------

#Considere que vamos prever se um paciente tem ou nao problema cardiaco.

#A) Esta e uma tarefa de classificacao ou regressao?

#B) Quantos atributos preditores vamos usar?

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
normdf = 
normdf = 

#B) Converta a coluna cardio para factor


#Na questão 4 vamos comparar o desempenho de redes neurais e SVM para 
#classificar os pacientes em com ou sem problemas cardiacos.

#Questao 3 - Redes neurais -----------------------------------------------------

#A) Crie uma funcao sigmoide que tem como entrada um valor x e saída o valor da função sigmoide
sigmoid_function = 
  
#B) Crie um vetor detamanho 6 com os digitos do seu RA em cada indice.
ra_vec = 
  
#C) Crie um vetor w com pesos com valores entre -1 e 1 e defina um valor b para o bias
w = 
b = 

#Calcule a saida de um neuronio que tem como entrada ra_vec, pesos w  e bias b, 
# com a funcao de ativacao sigmoide. Quais os valores maximos e minimos da funcao?



#Questao 4 - Neural Networks vs SVM --------------------------------------------

#A) Crie uma task de treino (70%) e de teste. Use os procedimentos de "agora e sua vez",
#da aula 11(11_mlr_svm_base.html, baixe o arquivo e abra no navegador).
#Complete as lacunas abaixo. Crie mais variaveis se julgar adequado.
task = 

#A1)Defina o holdout. O argumento split corresponde a % de treino em decimal.
#Crie uma task de treino e uma task de teste.
#SEMPRE execute o set.seed(2019) junto com a linha que cria a variavel holdout.
set.seed(2019)
holdout = 
tsk_train = 
tsk_test =

#B) Defina os learners
svm_learner = 
nn_learner =

#C) Defina os parametros a serem ajustados.
#Para verificar os parametros de um learner, pode usar:
#getLearnerParamSet(variavel_do_learner)
#SVM:
#Custo é um hiperparametro numerico que deve variar entre 0.1 e 1.
#Gamma é um hiperparametro numerico que deve variar entre 0.1 e 2.

#NN:
#Size é um hiperparametro inteiro que deve variar de 2 a 5.
params_svm = 

params_nn = 
#D) Escolha um dos hiperparametros da SVM e explique seu significado

#E) Defina o controle: RandomSearch com 50 iteracoes
tune_control = 

#F) Ajuste os parametros das duas tecnicas.
# Use set.seed(2019) antes da linha de ajuste de parametros
# Selecione e execute as duas linhas juntas para resultados consistentes.
set.seed(2019)
tr_svm = 

set.seed(2019)
tr_nn = 


#G) Quais os melhores parâmetros de cada tecnica?


#H) Use setHyperPars para ajustar os parametros encontrados aos learners criados
tuned_svm =
tuned_nn = 

#I) Treine no conjunto completo com a funcao train()
tuned_svm = 
tuned_nn = 

#J) Faca as predicoes na task de teste. Qual a acuracia dos dois modelos?
preds_svm = 
preds_nn = 

#K) Preencha as matrizes de confusao de cada modelo. Use calculateConfusionMatrix()
#nas predicoes acima.


#Considere a premissa:
#"e melhor dizer que o paciente tem doenca cardiaca e o mesmo nao ter do que 
# dizer que ele nao tem e, na verdade, ter."
#Qual modelo seria melhor nesse caso? Justifique com suas palavras.

###############################################################################
######################-----------QUESTAO BONUS -----------#####################
###############################################################################
roc_svm = calculateROCMeasures(preds_svm)
roc_nn = calculateROCMeasures(preds_nn)
roc_svm
roc_nn

#construa o dataframe compare_results com as medidas nn_results e svm_results
#definidas acima. A saida deve ser igual ao arquivo compare_results.csv

#Se conseguir construir no mesmo formato, salve o arquivo como compare_results_bonus.csv
#e deixe o codigo abaixo. Para salvar, use write_csv().
#Salvar o arquivo é parte do bonus.
#Leia a documentacao da funcoes envolvidas, se necessario.

####################### FIM DO BONUS ###########################################

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
renamed_plot = 

  
#C) Salve o gráfico (renamed_plot) na pasta 'data' com a extensão .jpg



#D) O que podemos fazer para diminuir a diferenca de proporcao entre as barras pequenas
# e as grandes?


# Questao 6
#A) Clusterize os dados de USArrests (ja vem carregado no R). Use a rotina vista em aula
# para escolher o melhor numero de clusters. Teste valores de k de 1 a 20.
# Além do parametro k, no loop, use nstart=25 dentro de makeLearner para ter um resultado mais conciso.
# Use seed 2019 antes do loop

cluster_data = USArrests
# Use o comando abaixo para remover os row_names de cluster_data
rownames(cluster_data) = NULL

#normalize os dados de cluster_data
cluster_data = 

#Encontre o melhor K
  
  

#B) Crie uma coluna nova "clusters" em cluster_data, que recebe os clusters,
# obtidos com o melhor K


#C) Temos novas observacoes arquivo find_cluster.csv. 
# Novos dados de crimes de regioes. 
# Use uma rotina concisa para atribuir cada observacao do conjunto find_cluster
# a um cluster do conjunto cluster_data
find_cluster = 