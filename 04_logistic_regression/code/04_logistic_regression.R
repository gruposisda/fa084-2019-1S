library(ggplot2)

na_per_column = function(df){
  apply(df,2,function(x){sum(is.na(x))})
}

#Aquecimento ----

#Conjunto de dados: age vs. claim
set.seed(12)
insurance =  data.frame(
  claim = c(rep(1, 20), rep(0, 20)),
  age = c(rnorm(20, mean = 25, sd = 5), rnorm(20, mean = 37, sd = 7)))

# plot the insurance data
ggplot(data = insurance, aes(x = age, y = claim)) +
  geom_point(color = 'black') + 
  theme_bw()

#regressão linear
lmmod = lm(claim ~ age, data = insurance)
#equacao da reta: ax + b
coef(lmmod)
a = coef(lmmod)[2]
b = coef(lmmod)[1]

# plot the data and the regression line
ggplot(data = insurance, aes(x = age, y = claim)) +
  geom_point(color = 'grey50') + 
  geom_abline(intercept = b, slope = a, color = 'red') + 
  theme_bw()


#sigmoid function
sigmoid = function(x){ 
  1 / (1 + exp(-x)) 
}
sigmoid(-10)
sigmoid(10)
sigmoid(-5:5)

df_sigmoid = data.frame(x = -5:5,
                        y = sigmoid(-5:5))
df_sigmoid

ggplot(df_sigmoid, aes(x = x, y = y)) + 
  geom_line(color = 'red', size = 0.3) + 
  theme_bw()


# regressao logistica
logmod = glm(claim ~ age, data = insurance, family = 'binomial')
coef(logmod)
coef(lmmod)

# predicao no conjunto de treino (para visualizacao, apenas)
insurance$preds = predict(logmod, type = 'response')
insurance


# grafico dos resultados
ggplot(data = insurance, aes(x = age, y = claim)) + 
  geom_point() + 
  geom_line(aes(x = age, y = preds), color = 'blue', size = 1) + 
  geom_abline(intercept = b, slope = a, color = 'red', size = 1) +
  theme_bw()


# Importar conjunto de dados ---- 
# Titanic competition kernel
# https://www.kaggle.com/c/titanic

train = read.csv('~/data/fa084/titanic/train.csv')
test = read.csv('~/data/fa084/titanic/test_labelled.csv')

df = bind_rows(train,test)

dim(df)
head(df)

glimpse(df)
summary(df)

#Age tem muitos NA
sum(is.na(df$Age))

#podemos preencher com valores aleatórios
avg_age = round(mean(df$Age,na.rm = T))
sd_age = round(sd(df$Age,na.rm = T))

random_ages = sample(avg_age-sd_age:avg_age+sd_age,263,replace = TRUE)
df$Age[is.na(df$Age)] = random_ages
sum(is.na(df$Age))

#Substituir duas colunas parch e sibsp por has_family_member
table(df$SibSp)
table(df$Parch)
df$has_member = 0
df$has_member[df$SibSp > 0 | df$Parch > 0] = 1 
table(df$has_member)


#Substituir Sex (male ou female) por Person (male,female ou children)
table(df$Sex)
df$person = 'female'
df$person[df$Sex == 'male'] = 'male'
table(df$person)
df$person[df$Age<=16] = 'child'
table(df$person)

#variaveis dummy
table(df$Pclass)

#Pclass
df$pclass_1 = ifelse(df$Pclass==1,1,0)
df$pclass_2 = ifelse(df$Pclass==2,1,0)
df$pclass_3 = ifelse(df$Pclass==3,1,0)

#Person
df$child = ifelse(df$person=='child',1,0)
df$female = ifelse(df$person=='female',1,0)
df$male = ifelse(df$person=='male',1,0)



#check consistency
sum(df$pclass_1,df$pclass_2,df$pclass_3)
sum(df$male,df$female,df$child)

#remover colunas que nao usaremos com dplyr
mod = select(df,-c(Pclass,Name,Ticket,SibSp,Parch,Sex,Cabin,Embarked,person,pclass_3,male))

mod_train = mod[mod$PassengerId %in% train$PassengerId,]
mod_train = select(mod_train,-PassengerId)
mod_test = mod[mod$PassengerId %in% test$PassengerId,]
summary(mod_test)
mod_test = na.omit(mod_test)
real = mod_test$Survived
mod_test = select(mod_test,c(-PassengerId,-Survived))


lregmodel= glm(formula = Survived~.,mod_train,family = 'binomial')
coef(lregmodel)

probs = predict(lregmodel,mod_test,type = 'response')
preds = as.numeric(probs >= 0.5)

conf_matrix = table(preds,real)
tpr = sum(preds == 1 & real == 1)/sum(real == 1)
fpr = sum(preds == 1 & real == 0)/sum(real == 0)

threshold = seq(0,0.9,0.1)
roc_data = data.frame(threshold,
                      tpr = NA,
                      fpr = NA)


for(i in 1:nrow(roc_data)){
  thresh = roc_data$threshold[i]
  preds = as.numeric(probs > thresh)
  conf_matrix = table(preds,real)
  roc_data$tpr[i] = sum(preds == 1 & real == 1)/sum(real == 1)
  roc_data$fpr[i] = sum(preds == 1 & real == 0)/sum(real == 0)
}


plot(roc_data$fpr,roc_data$tpr,
     ylim = c(0,1),xlim = c(0,1),
     col='steelblue',pch=19)
abline(a = 0,b=1, 
       col = 'darkred', lwd = '2',lty='dashed')

ggplot(roc_data,aes(x=fpr,y=tpr)) + 
  geom_point(size=2,color = 'steelblue') +
  geom_abline(slope = 1,intercept = 0,color = 'darkred',size = 1,linetype='dashed') +
  xlim(c(0,1)) + ylim(c(0,1)) + theme_classic()
