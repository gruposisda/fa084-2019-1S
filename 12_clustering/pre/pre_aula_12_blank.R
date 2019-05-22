library(mlr)
library(clue)
library(tidyverse)

#crie uma variavel "df" que contenha o conjunto de dados 
df = 

#remova a coluna species de "df"

  
#normalize os dados
df = scale(df) %>% as.data.frame()

#crie uma task de cluster
#https://mlr.mlr-org.com/articles/tutorial/task.html#cluster-analysis
task = 
task

#crie um learner de com cl = "cluster.kmeans" com hiperparâmetro centers = 3
learner = 
learner

#crie a variavel tr que recebe a saida de train() usando o learner e a task
set.seed(2019)
tr = 


#acesse o valor de "tot.withinss" dentro de "learner.model" dentro de "tr"
#lembre de usar $
#qual o valor?


#Quantas observacoes existem em cada cluster?
#Procure esta informacao dentro de "learner.model" em "tr"


#Crie um dataframe com o vetor anterior em uma coluna e os dados da coluna "Species" do conjunto iris



#Use a funcção table() no dataframe anterior. Comente o resultado.
#O grafico pode ajudar



