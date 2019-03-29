library(tidyverse)
#importe o conjunto de dados
df = read_csv()
head(df)

#divida em treino (75%) e teste (25%) NAO MUDE A SEED
set.seed(2903) #em 29-03-845 vikings saquearam Paris sob o comando de Ragnar Lothbrok 
rows_test = sample(,)
train = df[,]
test = df[,]


#Usando apenas a coluna Survived do conjunto de treino, quais predicoes voce poderia fazer
#sobre os sobreviventes do conjunto de teste.
#Entenda a saida da funcao abaixo e use o conjunto de teste para tirar conclusoes
prop.table(table(train$Survived))

#1.Qual a acurácia obtida usando apenas os dados da coluna Survived para prever se um passageiro no conjunto de teste sobrevive?


#vamos testar se essa predição pode ser melhorada usando os dados da coluna Sex.
#O comando abaixo retorna o cruzamento das colunas Sex e Survived.
table(train$Sex,train$Survived)
#A funcao prop.table retorna o mesmo de antes so que com os elementos de cada
#celula divididos pela soma de todos os elementos
prop.table(table(train$Sex,train$Survived))
#Se adicionarmos margin = 1, ele divide pela soma da linha
#A tabela abaixo nos fornece informacoes sobre quantos passageiros sobreviveram em funcao da coluna Sex
prop.table(table(train$Sex,train$Survived),margin = 1)

#Crie uma regra de decisao usando apenas a coluna Sex
#para prever Survived com base na tabela anterior.
#2.Qual a acurácia obtida quando usa-se os dados de Sex para prever se um passageiro do conjunto de teste sobrevive?
preds_based_on_sex = ifelse()
mean(preds_based_on_sex == )


#Faca o mesmo para a coluna Pclass. Avalie a prop.table(preencha voce mesmo(a)) e crie uma regra para
#prever Survived em funcao de Pclass.
#3.Qual a acuracia de usarmos os dados de Pclass para prever se um passageiro do conjunto de teste sobrevive?
prop.table()
preds_based_on_pclass = ifelse()
mean(preds_based_on_pclass == )

#4.Qual das duas colunas permite criarmos uma regra que mais diminui a entropia de survived?


#Usando as informacoes da saida abaixo, crie uma regra com duas condicoes
#Uma condicao com base em "Sex" e outra com base em "Pclass".
#5.Qual a acuracia obtida quando usa-se dados da coluna Sex e Pclass
#para prever se um passageiro do conjunto de teste sobrevive?
prop.table(table(train$Pclass,train$Survived,train$Sex),margin = 1)
preds_on_both = ifelse()
mean(preds_on_both == )

#6.Adicionar uma condicao a mais foi melhor ou pior para a predicao?

#7.Usando apenas o atributo Age do conjunto de treino, qual o melhor 
#corte para prever Survived = 1 no conjunto de teste: 16, 18 ou 22?


#8.Para esta idade, qual a acuracia, no conjunto de teste,
#da regra "Passageiros com idade menor do que (Idade) sobrevivem?"