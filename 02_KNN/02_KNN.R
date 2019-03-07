# Recomendar: Help das funcoes sample() e seq() e como fazer loops em R

# 0.Importar bibliotecas ----
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
?sample
set.seed(10)
sample(x = 200,size = 20,replace = F)

# 1.2 Dividir em treino e teste
set.seed(2)
nrow(dat)
rows_train=sample(x = nrow(dat), size = ceiling(0.8*nrow(dat)))
train = dat[rows_train,]
test = dat[-rows_train,]

summary(train)
summary(test)


# 1.3 Visualização do problema

ggplot(train, aes(x=XCoord, y=YCoord, color=Competitor))+
  geom_point(size=5) + 
  coord_cartesian(xlim = c(-1,1), ylim = c(-1,1)) +
  theme_classic()

ggplot(train, aes(x=XCoord, y=YCoord, color=Competitor))+
  geom_point(size=5) +
  geom_point(data=test,size = 7,shape='*',stroke=7)+
  coord_cartesian(xlim = c(-1,1), ylim = c(-1,1)) +
  theme_classic()

# 2.Classificacao com KNN ----
?knn
tr_xy = train[,c('XCoord','YCoord')]
tr_label = train$Competitor  
tst_xy = test[,c('XCoord','YCoord')]
tst_label = test$Competitor

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
mk_test = knn(train = tr_xy,test = tr_xy,cl = tr_label,k = 1)
mk_test = as.character(mk_test)
mk_test
sum(mk_test == tr_label)/length(tr_label)

sum(mk1 == tst_label)
length(tst_label)
length(mk1)
sum(mk1 == tst_label)/length(tst_label)
sum(mk3 == tst_label)/length(tst_label)

#Loop para encontrar o melhor K
acc = numeric()
tr_acc = numeric()
ks = c(1,3,5,7,15,21,25,27)
for (k in ks){
  print(paste('k é',k))
  tr_preds = knn(tr_xy,
                 tr_xy,
                 cl = tr_label,
                 k = k)
    
  preds = knn(tr_xy,
              tst_xy,
              cl = tr_label,
              k = k)
  tr_acc_k = sum(tr_preds == tr_label)/length(tr_label)
  acc_k = sum(preds == test$Competitor)/dim(test)[1]
  acc_k = round(acc_k,2  )
  print(paste('acc é', acc_k))
  acc = c(acc,acc_k)
  tr_acc = c(tr_acc,tr_acc_k)
}

classif_results = data.frame(k = ks, tr_acc,tst_acc = acc)
classif_results

#Visualizacao dos resultados
plot(classif_results$k, classif_results$tr_acc, type = 'b',
     ylim = c(0,1.5), col = 'blue')
lines(classif_results$k, classif_results$tst_acc, type = 'b', 
      col = 'red')


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

test
ggplot(test, aes(x=XCoord, y=YCoord, colour=Competitor,shape=correto,label=pred_errado))+
  scale_shape_manual(values=c(4,1))+
  geom_point(lwd=2,stroke=3)+
  #geom_point(data=test,color='black',size = 7,shape='*',stroke=7)+
  geom_text(fontface = 'bold',size=7,nudge_x = 0.1)+ 
  coord_cartesian(xlim = c(-1,1), ylim = c(-1,1)) +
  theme_classic()

# 3.Regressão com KNN ----
#Visualização
df_chick = read.csv('data/chickweight.csv')
id_test = c(3,6,9,11)
df_chick_train = df_chick[-id_test,]
df_chick_test = df_chick[id_test,]
mk2 = knn.reg(train = df_chick_train$time,test = as.data.frame(df_chick_test$time),y = df_chick_train$weight,k=2)
yk2 = mk2$pred
mk3 = knn.reg(train = df_chick_train$time,test = as.data.frame(df_chick_test$time),y = df_chick_train$weight,k=3)
yk3 = mk3$pred
reg_preds = data.frame(time_test = df_chick_test$time, pred_weight2 = yk2, pred_weight3 = yk3)
reg_preds

mae2 = mean(abs(reg_preds$pred_weight2 - df_chick_test$weight))
mae3 = mean(abs(reg_preds$pred_weight3 - df_chick_test$weight))
mae2
mae3

ggplot(df_chick, aes(x = time, y= weight)) +
  geom_point(size = 5)  +
  geom_point(data = reg_preds, aes(x = time_test, y = pred_weight2, colour = 'K = 2'), size = 5) + 
  geom_point(data = reg_preds, aes(x = time_test, y = pred_weight3, colour = 'K = 3'), size = 5) + 
  theme_classic()


#importar conjunto de dados
dat = read.csv('data/regression_data.csv')
dim(dat)
str(dat)
summary(dat)

set.seed(2)
rows_train=sample(x = nrow(dat), size = round(0.8*nrow(dat)), replace = F)
train = dat[rows_train,]
test = dat[-rows_train,]

label_col = which(colnames(dat) == 'Y')
tr_x = train[,-label_col]
tr_label = train[,label_col]  
tst_x = test[,-label_col]
tst_label = test[,label_col] 

head(tst_x)
head(tst_label)

#Loop com varios K
k_candidate = c(1, seq(5,20, by = 5), seq(30, 70, by =10))

#dataframe para avaliacao
eval_knn = data.frame(k = k_candidate,
                      mse_train = NA,
                      mse_test = NA)
eval_knn


for (i in 1:nrow(eval_knn)){
  m_train = knn.reg(train = tr_x,
                   y = tr_label,
                   test = tr_x,
                   k = eval_knn$k[i])
  m_test = knn.reg(train = tr_x,
                   y = tr_label,
                   test = tst_x,
                   k = eval_knn$k[i])
  # para atribuir valor ? coluna do dataframe (antes sem valor)
  eval_knn$mse_train[i] = mean(abs(tr_label-m_train$pred))
  eval_knn$mse_test[i] = mean(abs(tst_label-m_test$pred))
  print(paste0('Avaliando K =', eval_knn$k[i]))
}
eval_knn
#Visualizacao dos resultdados
plot(eval_knn$k, eval_knn$mse_test, type = 'b',
     ylim = c(0,1.5), col = 'blue')
lines(eval_knn$k, eval_knn$mse_train, type = 'b', 
      col = 'red')