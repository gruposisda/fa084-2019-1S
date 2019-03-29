library(tidyverse)
#importe o conjunto de dados
df = read_csv('~/data/fa084/titanic/mod_titanic_2.csv')
head(df)

#divida em treino (75%) e teste (25%) NAO MUDE A SEED
set.seed(2903) #em 29-03-845 vikings saquearam Paris sob o comando de Ragnar Lothbrok 
rows_test = sample(nrow(df),0.25*nrow(df))
train = df[-rows_test,]
test = df[rows_test,]


#Usando apenas a coluna Survived do conjunto de treino, quais predicoes voce poderia fazer
#sobre os sobreviventes do conjunto de teste.
#Entenda a saida da funcao abaixo e use no conjunto de teste para tirar conclusoes
prop.table(table(train$Survived))

#Com base na saida anterior, que regra podemos criar usando apenas os dados de Survived?
#1.Qual a acurácia obtida usando apenas os dados da coluna Survived para prever se um passageiro no conjunto de teste sobrevive?
#R:Acc
mean(test$Survived == 0)

#vamos testar se essa predição pode ser melhorada usando os dados da coluna Sex.
#O comando abaixo retorna o cruzamento das colunas Sex e Survived.
table(train$Sex,train$Survived)
#A funcao prop.table retorna o mesmo de antes so que com os elementos de cada
#celula divididos pela soma de todos os elementos
prop.table(table(train$Sex,train$Survived))
#Se adicionarmos margin = 1, ele divide pela soma da linha
#O que a tabela abaixo nos informa?
prop.table(table(train$Sex,train$Survived),margin = 1)

#Crie uma regra de decisao usando apenas coluna Sex
#para prever Survived com base na tabela anterior.
#2.Qual a acurácia obtida quando usa-se os dados de Sex para prever se um passageiro do conjunto de teste sobrevive?

#R: Como 73% das mulheres sobreviveram, podemos criar if Sex = "female", survived == 1
#R: Como 80% dos homens morreram, a regra complementar vale também e terá a mesma acurácia
preds_based_on_sex = ifelse(test$Sex == 'female', 1,0)
mean(preds_based_on_sex == test$Survived)


#Faca o mesmo para a coluna Pclass. Avalie a prop.table() e crie uma regra para
#prever Survived em funcao de Pclass.
#3.Qual a acuracia de usarmos os dados de Pclass para prever se um passageiro do conjunto de teste sobrevive?
prop.table(table(train$Pclass,train$Survived),margin = 1)
preds_based_on_pclass = ifelse(test$Pclass == 1, 1, 0)
preds_based_on_pclass = ifelse(test$Pclass == 2, 0, 1)
mean(preds_based_on_pclass == test$Survived)

#4.Qual das duas colunas permite criarmos uma regra que mais diminui a entropia de survived?


#Usando as informacoes da saida abaixo, crie uma regra com duas condicoes
#Uma com base em "Sex" e outra com base em "Pclass".
#5.Qual a acuracia obtida quando usa-se dados da coluna Sex e Pclass
#para prever se um passageiro do conjunto de teste sobrevive?

prop.table(table(train$Pclass,train$Survived,train$Sex),margin = 1)
preds_on_both = ifelse(test$Sex == 'female' & test$Pclass == 1,1,0)
preds_on_both = ifelse(test$Sex == 'male' & test$Pclass == 2,0,1)
mean(preds_on_both == test$Survived)

#Adicionar uma condicao a mais foi melhor ou pior para apredicao?




#7.Usando apenas o atributo Age do conjunto de treino, qual o melhor 
#corte para prever Survived = 1 no conjunto de teste: 16, 18 ou 22?
age = 16
mean(ifelse(train$Age < age, 1, 0) == train$Survived)
mean(ifelse(test$Age < age, 1, 0) == test$Survived)


#8.Para esta idade, qual a acuracia (no conjunto de treino e de teste)
#da regra "Passageiros com idade menor do que (Idade) sobrevivem?"




acc_train = numeric()
for(age in 1:25){
  acc_train_age = mean(as.numeric(train$Age < age) == train$Survived)
  acc_train = c(acc_train,acc_train_age)
}
for(age in 1:25){
  acc_train_age = mean(as.numeric(test$Age < age) == test$Survived)
  acc_train = c(acc_train,acc_train_age)
}

names(acc_train) = rep(1:25,2)
acc_train


