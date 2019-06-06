library(mlr)
library(tidyverse)
library(dendextend)

df1 = read.csv('./data/first_data.csv')
df2 = read.csv('./data/second_data.csv')
df3 = read.csv('./data/third_data.csv')
l1 = read.csv('./data/first_labels.csv')[,1] +1
l2 = read.csv('./data/second_labels.csv')[,1] + 1
l3 = read.csv('./data/third_labels.csv')[,1] + 1


#Encontrar o melhor numero de cluster para os dados df1 e df2
task1 = makeClusterTask('cluster',df1)
task2 = makeClusterTask('cluster',df2)
task3 = makeClusterTask('cluster',df3)

k_to_test = c(1:20)

#first data ----

#second data ----

#third data ----




#Hieranquical clustering cereal data ----
library(cluster)
cereals = read_csv('./data/cereals.csv')

#Existem cereais com o mesmo nome?
#Qual o min, maximo, med, de rating?

#categorizar usando cut
category = 

#select numeric only
num_cereals = cereals
labels = 
num_cereals = 
head(num_cereals)

#scale numeric variables
num_cereals = 
# como arredondar?

  
#Calculate distances
dist_cereals = 
#attr(dist_cereals,'Labels') = as.character(labels)
hc_cereals_complete = 

dend_cereals_comp = 
dend_colored_comp = 
plot(dend_colored_comp)

#Selecting two clusters
clusters = 
#Appending the clusters to all the dataset
clustered_cereals = 


