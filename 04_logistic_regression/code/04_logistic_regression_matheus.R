library(ggplot2)

na_per_column = function(df){
  apply(df,2,function(x){sum(is.na(x))})
}

#Aquecimento ----

#Conjunto de dados: age vs. claim
set.seed(51)
insurance =  data.frame(
  claim = c(rep(1, 20), rep(0, 20)),
  age = c(rnorm(20, mean = 25, sd = 5), rnorm(20, mean = 37, sd = 7)))

# plot the insurance data
ggplot(data = insurance, aes(x = age, y = claim))+
  geom_point() 

#regressão linear
lmmod = lm(claim~age, insurance)
coefs = coef(lmmod)

#equacao da reta: ax + b
a = coefs[2]
b = coefs[1]

# plot the data and the regression line
ggplot(data = insurance, aes(x = age, y = claim))+
  geom_point() +
  geom_abline(intercept = b,slope = a)

#sigmoid function
sigmoid = function(x){
  1/(1 + exp(-x))
}

sigmoid(10)
sigmoid(1000)
sigmoid(-5)
sigmoid(-100)

x = -5:5
sigmoid(x)

# regressao logistica
logmod = glm(claim~age, insurance, family = 'binomial')
coef(logmod)


# predicao no conjunto de treino (para visualizacao, apenas)
insurance$probs = predict(logmod,type = 'response')


# grafico dos resultados
ggplot(data = insurance, aes(x = age, y = claim)) + 
  geom_point() + 
  geom_line(aes(x = age, y = probs), color = 'blue', size = 1) + 
  geom_abline(intercept = b, slope = a, color = 'red', size = 1) +
  theme_classic()

# Importar conjunto de dados ---- 
# Titanic competition kernel
# https://www.kaggle.com/c/titanic

train = read.csv('~/data/fa084/04_regressao_logistica/data/train.csv')
test = read.csv('~/data/fa084/04_regressao_logistica/data/test_labelled.csv')

library(dplyr)
df = bind_rows(train,test)
glimpse(df)
summary(df)

#Age tem muitos NA

#podemos preencher com valores aleatórios
avg_age = round(mean(df$Age,na.rm = T))
sd_age = round(sd(df$Age,na.rm = T))
random_ages = sample(avg_age - sd_age : avg_age+sd_age,
                     263, replace = T)
sum(is.na(df$Age))

df$Age[is.na(df$Age)] = random_ages


#Substituir duas colunas parch e sibsp por has_family_member
table(df$SibSp)
table(df$Parch)
df$has_family_member = 0
df$has_family_member[df$SibSp + df$Parch > 0] = 1
df$has_family_member[df$SibSp>0 | df$Parch > 0] = 1
table(df$has_family_member)

#Substituir Sex (male ou female) por Person (male,female ou children)
table(df$Sex)
df$person = as.character(df$Sex)
df$person[df$Age <=16] = 'child'
table(df$person)

#variaveis dummy
glimpse(df)

#Pclass
table(df$Pclass)
df$pclass_1 = ifelse(df$Pclass == 1,1,0)
df$pclass_2 = ifelse(df$Pclass == 2,1,0)
df$pclass_3 = ifelse(df$Pclass == 3,1,0)


#Person
df$person_male = ifelse(df$person == 'male',1,0)
df$person_female = ifelse(df$person == 'female',1,0)
df$person_child = ifelse(df$person == 'child',1,0)

#check consistency
table(df$person)
sum(df$person_male)
sum(df$person_female)
sum(df$person_child)

#remover colunas que nao usaremos com dplyr
mod = select(df,-c(Name,Ticket,SibSp,Parch,Cabin,Embarked,
                   person,pclass_3,person_male))
glimpse(mod)
write.csv(x = mod,file = '~/data/fa084/titanic/mod_titanic_2.csv',row.names = F)

#treino e teste do conjunto limpo e preparacao para modelagem
sum(mod$PassengerId %in% train$PassengerId)
sum(mod$PassengerId %in% test$PassengerId)

mod_train = mod[mod$PassengerId %in% train$PassengerId,]
mod_test = mod[mod$PassengerId %in% test$PassengerId,]
sum(is.na(mod_train$Fare))
sum(is.na(mod_test$Fare))

mod_test = na.omit(mod_test)

mod_train=select(mod_train,-PassengerId)
mod_test=select(mod_test,-PassengerId)

glimpse(mod_train)

lrmodel = glm(formula = Survived~., mod_train, family = 'binomial')
coef(lrmodel)

probs = predict(lrmodel,mod_test,type='response')
preds = as.numeric(probs > 0.5)

real = mod_test$Survived
table(preds,real)
sum(real)
sum(preds)
tpr = sum(preds == 1 & real == 1)/sum(real == 1)
fpr = sum(preds == 1 & real == 0)/sum(real == 0)

thresholds = seq(0,0.9,0.1)
roc_data = data.frame(
  thresholds,
  tpr = NA,
  fpr = NA
)

for(i in 1:nrow(roc_data)){
  thres = roc_data$thresholds[i]
  preds = as.numeric(probs>thres)
  tpr_thres = sum(preds == 1 & real == 1)/sum(real == 1)
  fpr_thres = sum(preds == 1 & real == 0)/sum(real == 0)
  roc_data$tpr[i] = tpr_thres
  roc_data$fpr[i] = fpr_thres
}

ggplot(roc_data,aes(x = fpr, y = tpr)) +
  geom_point(size = 2, color='steelblue') + 
  geom_abline(slope = 1, intercept = 0, color = 'darkred', size = 1) +
  ylim(c(0,1)) + xlim(c(0,1)) +
  theme_bw()


