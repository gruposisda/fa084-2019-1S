library(class)
setwd('~/data/fa084/02_KNN/')
train = read.csv('data/train.csv')
test = read.csv('data/test.csv')

head(train)
head(test)

dim(train)
dim(test)


tr = train[,c('XCoord','YCoord')]
tst = test[,c('XCoord','YCoord')]
trlab = train$Competitor


dim(test)
?knn

ggplot(train, aes(x=XCoord, y=YCoord, color=Competitor))+
  geom_point(size=5) + 
  theme_classic()
ggplot(train, aes(x=XCoord, y=YCoord, color=Competitor))+
  geom_point(size=5) +
  geom_point(data=test,color='black',size = 5,shape='*',stroke=5)+
  theme_classic()

acc = numeric()
for (k in c(1,3,5,7,15)){
  preds = knn(train[,c('XCoord','YCoord')],
              test[,c('XCoord','YCoord')],
              cl = train$Competitor,
              k = k)
  acc_k = sum(preds == test$Competitor)/dim(test)[1]
  acc = c(acc,acc_k)
}
acc


ggplot(test, aes(x=XCoord, y=YCoord, color=''))+
  geom_point(size=5) + 
  theme_classic()




dpred = tst
final_preds = knn(tr,
                  tst,
                  cl = train$Competitor,
                  k = 10,prob = TRUE)
#final_preds=as.character(final_preds)
#final_preds = paste(final_preds,'model',sep='_')
final_preds
prob = attr(final_preds,'prob')
sum(final_preds == test$Competitor)/nrow(tst)
dpred$Correto = ifelse(final_preds==test$Competitor,TRUE,FALSE)

dpred$Competitor = as.character(final_preds)
dpred
dpred$Real = ''
dpred$Real[!dpred$Correto]=as.character(test$Competitor)[!dpred$Correto]
dpred


ggplot(dpred, aes(x=XCoord, y=YCoord, colour=Competitor,shape=Correto,label=Real))+
  scale_shape_manual(values=c(4,1))+
  geom_point(lwd=2,stroke=3) +
  geom_text(nudge_y=0.08)+
  theme_classic() 



# TESTES ------------------------------------------------------------------


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


# CONTOURS ----------------------------------------------------------------

train <- rbind(iris3[1:25,1:2,1],
               iris3[1:25,1:2,2],
               iris3[1:25,1:2,3])
cl <- factor(c(rep("s",25), rep("c",25), rep("v",25)))
require(MASS)

head(mutate(test, cls=classif))

test <- expand.grid(x=seq(min(train[,1]-1), max(train[,1]+1),
                          by=0.1),
                    y=seq(min(train[,2]-1), max(train[,2]+1), 
                          by=0.1))

classif <- knn(train, test, cl, k = 3, prob=TRUE)
prob <- attr(classif, "prob")

head(dataf)
tail(dataf)
table(dataf$cls)
table(dataf$prob_cls)


library(dplyr)
dataf <- bind_rows(mutate(test,
                          prob=prob,
                          cls="c",
                          prob_cls=ifelse(classif==cls,
                                          1, 0)),
                   mutate(test,
                          prob=prob,
                          cls="v",
                          prob_cls=ifelse(classif==cls,
                                          1, 0)),
                   mutate(test,
                          prob=prob,
                          cls="s",
                          prob_cls=ifelse(classif==cls,
                                          1, 0)))

str(dpred)
ggplot(dataf) +
  geom_point(aes(x=x, y=y, col=cls),
             data = mutate(test, cls=classif),
             size=1.2) + 
  geom_contour(aes(x=x, y=y, z=prob_cls, group=cls, color=cls),
               bins=2,
               data=dataf) +
  geom_point(aes(x=x, y=y, col=cls),
             size=3,
             data=data.frame(x=train[,1], y=train[,2], cls=cl))
