library(mlr)
library(tidyverse)
library(dendextend)

df1 = read.csv('./data/first_data.csv')
df2 = read.csv('./data/second_data.csv')
df3 = read.csv('./data/third_data.csv')

#Encontrar o melhor numero de cluster para os dados df1 e df2
task1 = makeClusterTask('cluster',df1)
task2 = makeClusterTask('cluster',df2)
task3 = makeClusterTask('cluster',df3)

k_to_test = c(1:20)

wssvec = numeric()
set.seed(10)
for(k in k_to_test){
  learner = makeLearner('cluster.kmeans',centers=k)
  tr = train(learner,task1)
  wss = tr$learner.model$tot.withinss
  wssvec = c(wssvec,wss)
}
plot(k_to_test,wssvec)

wssvec2 = numeric()
set.seed(10)
for(k in k_to_test){
  learner = makeLearner('cluster.kmeans',centers=k)
  tr = train(learner,task2)
  wss = tr$learner.model$tot.withinss
  wssvec2 = c(wssvec2,wss)
}
plot(k_to_test,wssvec2)

wssvec3 = numeric()
set.seed(10)
for(k in k_to_test){
  learner = makeLearner('cluster.kmeans',centers=k)
  tr = train(learner,task3)
  wss = tr$learner.model$tot.withinss
  wssvec3 = c(wssvec3,wss)
}
plot(k_to_test,wssvec3)


#Hieranquical clustering cereal data
library(cluster)
cereals = read.csv('./data/cereals.csv')

#Remove categorical variables
cereals = cereals[1:45,]

num_cereals = cereals
labels = cereals$name
num_cereals = select(num_cereals,4:16)

#Remove shelf
num_cereals$shelf = NULL
#scale numeric variables
num_cereals = scale(num_cereals)
#Calculate distances
dist_cereals = dist(num_cereals, method = "euclidean")
#attr(dist_cereals,'Labels') = as.character(labels)
hc_cereals_complete = hclust(dist_cereals, method = "complete")

#Selecting two clusters
clusters = cutree(hc_cereals_complete, k=10)
#Appending the clusters to all the dataset
clustered_cereals = mutate(cereals, cluster=clusters)
clustered_cereals$cluster %>% table()


dend_cereals_comp = as.dendrogram(hc_cereals_complete)
dend_colored_comp = color_branches(dend_cereals_comp, k=2)
plot(dend_colored_comp)
