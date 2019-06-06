library(mlr)
library(tidyverse)
library(dendextend)
library(cluster)

#nstart
#variaveis categorias
#k-modes


df1 = read.csv('../data/first_data.csv')
df2 = read.csv('../data/second_data.csv')
df3 = read.csv('../data/third_data.csv')
l1 = read.csv('../data/first_labels.csv')[,1] +1
l2 = read.csv('../data/second_labels.csv')[,1] + 1
l3 = read.csv('../data/third_labels.csv')[,1] + 1


#Encontrar o melhor numero de cluster para os dados df1 e df2
task1 = makeClusterTask('cluster',df1)
task2 = makeClusterTask('cluster',df2)
task3 = makeClusterTask('cluster',df3)

k_to_test = c(1:20)

#plot dos dados
plot(df1$X,df1$Y)
plot(df2$X,df2$Y)
plot(df3$X,df3$Y)

kmeans(nstart = )

#first data ----
wssvec = numeric()
set.seed(10)
for(k in k_to_test){
  learner = makeLearner('cluster.kmeans',centers=k)
  tr = train(learner,task1)
  wss = tr$learner.model$tot.withinss
  wssvec = c(wssvec,wss)
}
plot(k_to_test,wssvec)

learner = makeLearner('cluster.kmeans',centers=5,nstart=1)
tr = train(learner,task1)
clusters =tr$learner.model$cluster
table(clusters,l1)

plot(df1$X,df1$Y,col=l1)
plot(df1$X,df1$Y,col=clusters)

#second data ----
wssvec2 = numeric()
set.seed(10)
for(k in k_to_test){
  learner = makeLearner('cluster.kmeans',centers=k,nstart=1)
  tr = train(learner,task2)
  wss = tr$learner.model$tot.withinss
  wssvec2 = c(wssvec2,wss)
}
plot(k_to_test,wssvec2)

learner = makeLearner('cluster.kmeans',centers=5,nstart=1)
tr = train(learner,task2)
clusters2 =tr$learner.model$cluster
table(clusters2,l2)

plot(df2$X,df2$Y,col=l2)
plot(df2$X,df2$Y,col=clusters2)

?kmeans()
#third data ----
wssvec3 = numeric()
set.seed(10)
for(k in k_to_test){
  learner = makeLearner('cluster.kmeans',centers=k)
  tr = train(learner,task3)
  wss = tr$learner.model$tot.withinss
  wssvec3 = c(wssvec3,wss)
}
plot(k_to_test,wssvec3)

learner = makeLearner('cluster.kmeans',centers=5)
tr = train(learner,task3)
clusters3 =tr$learner.model$cluster
table(clusters3,l3)

plot(df3$X,df3$Y,col=l3)
plot(df3$X,df3$Y,col=clusters)

#Hieranquical clustering cereal data
library(cluster)
cereals = read_csv('./data/cereals.csv')
head(cereals)
#Existem cereais com o mesmo nome?
#Qual o min, maximo, med, de rating?
summary(cereals)

category = cut(cereals$rating,
               breaks = fivenum(cereals$rating),
               labels = c('low','med','above','high'))
category2 = cut(cereals$rating,
               breaks = c(0,25,50,75,100),
               labels = c('low','med','above','high'))
table(category)
table(category2)

#select numeric only
head(cereals)
num_cereals = cereals %>% select_if(is.numeric) %>% select(-shelf,-rating)
head(num_cereals)

#scale numeric variables
num_cereals = scale(num_cereals)
# e se eu quisesse arredondar?
head(num_cereals)
#Calculate distances
dist_cereals = dist(num_cereals, method = "euclidean")
#attr(dist_cereals,'Labels') = as.character(labels)
hc_cereals_complete = hclust(dist_cereals, method = "complete")

dend_cereals_comp = as.dendrogram(hc_cereals_complete)
dend_colored_comp = color_branches(dend_cereals_comp, k=10)
plot(dend_colored_comp)

#Selecting two clusters
clusters = cutree(hc_cereals_complete, k=4)
#Appending the clusters to all the dataset
clustered_cereals = mutate(cereals, cluster=clusters)
clustered_cereals$cluster %>% table()

table(clusters,category)


