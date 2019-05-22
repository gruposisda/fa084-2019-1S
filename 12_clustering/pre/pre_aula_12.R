library(mlr)
library(clue)
library(dplyr)
library(clValid)
library(clusterSim)

#crie uma variavel "df" que contenha o conjunto de dados 
df = iris %>% select(-Species)

#remova a coluna species de "df"
dim(df)
df = scale(df) %>% as.data.frame()

#crie uma task de cluster
#https://mlr.mlr-org.com/articles/tutorial/task.html#cluster-analysis
task = makeClusterTask('cluster',df)
task

#crie um learner de com cl = "cluster.kmeans" com hiperparâmetro centers = 3
learner = makeLearner(cl = 'cluster.kmeans', centers = 3)
learner

#crie a variavel tr que recebe a saida de train() usando o learner e a task
set.seed(2019)
tr = train(learner,task)


#acesse o valor de "tot.withinss" dentro de "learner.model" dentro de "tr"
#qual o valor?
tr$learner.model$tot.withinss

#Quantas observacoes existem em cada cluster?
#Procure esta informacao dentro de "learner.model" em "tr"
tr$learner.model$cluster

#Crie um dataframe com o vetor anterior em uma coluna e os dados da coluna "Species" do conjunto iris
cl = tr$learner.model$cluster
data.frame(cl,iris$Species) %>% table


#Use a funcção table() no dataframe anterior. Comente o resultado.

cluster_params = makeParamSet(makeNumericParam("centers",2,20))



plotLearnerPrediction(learner, task = task, features = c("Murder", "Assault"), cv = 0)


performance(tr,measures = withinss)

control = makeTuneControlGrid(maxit = 100)
tst = tuneParams(learner,task,cv2,par.set = cluster_params,control = control,measures = withinss)


getLearnerType(learner)

f = function(task, model)
f = function(task, model, pred,feats, extra.args){
  return(model$learner.model$tot.withinss)
}
withinss = makeMeasure(id = "withinss", minimize = TRUE, properties = c("cluster"), fun = f,aggr = )


ggplot(iris, aes(Petal.Length, Petal.Width, color = Species)) + geom_point()