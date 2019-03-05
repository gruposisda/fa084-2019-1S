# Recomendar: Help das funcoes sample() e seq() e como fazer loops em R

# 0.Importar bibliotecas ----

library(class)
library(FNN)
library(ggplot2)

# 1.Importar dataset, dividir em treino e teste ----

setwd('~/data/fa084/02_KNN/')
dat = read.csv('data/dart_throws.csv')
str(dat)
summary(dat)
dim(dat)
head(dat)

#1.1 Comando sample

sample(x = 200,size = 20,replace = F)

set.seed(2)


tr = train[,c('XCoord','YCoord')]
tst = test[,c('XCoord','YCoord')]
trlab = train$Competitor

# 1.2 Dividir em treino e teste
set.seed(2)
rows_train=sample(x = nrow(dat), size = round(0.8*nrow(dat)), replace = F)
train = dat[rows_train,]
test = dat[-rows_train,]

dim(train)
dim(test)

head(train)
head(test)

table(train$Competitor)
table(test$Competitor)

# 1.3 Visualização do problema

ggplot(train, aes(x=XCoord, y=YCoord, color=Competitor))+
  geom_point(size=5) + 
  theme_classic()

ggplot(train, aes(x=XCoord, y=YCoord, color=Competitor))+
  geom_point(size=5) +
  geom_point(data=test,color='black',size = 7,shape='*',stroke=7)+
  theme_classic()

# 2.Classificacao com KNN ----

tr_xy = train[,c('XCoord','YCoord')]
tr_label = as.character(train$Competitor)  
tst_xy = test[,c('XCoord','YCoord')]
tst_label = as.character(test$Competitor)  

#Predicoes com k=1, k=3, etc.
mk1 = knn(train = tr_xy,test = tst_xy,cl = tr_label,k = 1)
mk1 = as.character(mk1)
mk1
tst_label

mk3 = knn(train = tr_xy,test = tst_xy,cl = tr_label,k = 3)
mk3 = as.character(mk3)
mk3
mk1
tst_label


#Qualidade do modelo: Acurácia de classificacao
mk1 == tst_label
sum(mk1 == tst_label)
length(tst_label)
length(mk1)
sum(mk1 == tst_label)/length(tst_label)
sum(mk3 == tst_label)/length(tst_label)

#Loop para encontrar o melhor K
acc = numeric()
for (k in c(1,3,5,7,15)){
  preds = knn(tr_xy,
              tst_xy,
              cl = tr_label,
              k = k)
  acc_k = sum(preds == test$Competitor)/dim(test)[1]
  acc = c(acc,acc_k)
}
acc

#Visualizacao dos resultados

final_preds = knn(tr_xy,
                  tst_xy,
                  cl = tr_label,
                  k = 3)
final_preds = as.character(final_preds)

test
test$pred = ''
test$pred = final_preds
sum(test$pred==test$Competitor)
test$correto = ifelse(test$pred==test$Competitor,TRUE,FALSE)
test$pred_errado = ''
test$pred_errado[!test$correto]=as.character(test$pred)[!test$correto]
test


ggplot(test, aes(x=XCoord, y=YCoord, colour=Competitor,shape=correto,label=pred_errado))+
  scale_shape_manual(values=c(4,1))+
  geom_point(lwd=2,stroke=3)+
  geom_text(fontface = 'bold',size=7,nudge_x = 0.1)+ 
  theme_classic()


# 3.Regressão com KNN ----
#Predicoes com K = 2
#Qualidade do modelo: RMSE e MAE
#Loop com varios K
#Visualizacao dos resultdados





# TESTES ------------------------------------------------------------------
# regression
library(FNN)
aula_2 = read.csv("~/Downloads/fa084_aula2dados.csv",
                  header = TRUE,
                  sep = ",",
                  row.names = 1)
head(aula_2)
tail(aula_2)
summary(aula_2)


#sample(c('cara','coroa'),1) 
#grep('c',c('a','b','c')) #procura c dentro do conjunto e retorna a posi??o

#criando os conjuntos de treino e teste
set.seed(42)
id_train = sample(nrow(aula_2),0.7*nrow(aula_2)) #seleciona aleatoriamente 70% das linhas
aula_2_train = aula_2[id_train,] #dados limpos para treino (70%)
aula_2_test = aula_2[-id_train,] # dados limpos para teste (30% restante)

#comando executado para selecionar a posicao do atributo meta
#busca a coluna "Y" em aula_2 e retorna, neste caso, a posi??o 6

pos_label = grep("Y", colnames(aula_2))
x_train = aula_2_train[,-pos_label]
y_train = aula_2_train[,pos_label]
x_test = aula_2_test[,-pos_label]
y_test = aula_2_test[,pos_label]

#cria modelo e testa no proprio conjunto de treino
m1 = knn.reg(train = x_train,
             y = y_train,
             test = x_train,
             k = 1)
ypred1 = m1$pred

m2 = knn.reg(train = x_train,
             y = y_train,
             test = x_test,
             k = 1)
ypred1 = m1$pred
ypred2 = m2$pred

plot(ypred1, y_train)
plot(ypred2, y_test)




dpred = tst

final_preds = knn(tr,
                  tst,
                  cl = train$Competitor,
                  k = 3,prob = TRUE)
final_preds=as.character(final_preds)
final_preds = paste(final_preds,'model',sep='_')
final_preds
prob = attr(final_preds,'prob')

dpred$Competidor = as.character(final_preds)
ggplot(dpred, aes(x=XCoord, y=YCoord, color=Competidor))+
  geom_point(size=5) + 
  theme_classic()

prob
dpred$prob = prob
head(dpred)
ggplot(dpred, aes(x=XCoord, y=YCoord, z = prob, group=Competidor,color=Competidor))+
  geom_contour(bins=2)


dpred$x = round(dpred$XCoord,10)
dpred$y = round(dpred$YCoord,1)

ggplot(dpred,aes(x=x, y=y, color=Competidor,z=prob)) +
  geom_contour()


ggplot(diamonds, aes(carat)) +
  geom_density2d()

dpred

head(dataf)

ggplot(dataf) +
  geom_contour(aes(x=x, y=y, z=prob_cls, group=cls, color=cls),
               bins=2,
               data=dataf) 

dataf