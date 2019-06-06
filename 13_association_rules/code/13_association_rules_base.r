library("tidyverse")
library("arules")
library("arulesViz")
library("readxl")
library("lubridate")
library("RColorBrewer")
library("plotly")
library("ggcorrplot")


df = read_excel('../data/online_retail.xlsx')
dim(df)

df = 
colnames(df) = tolower(colnames(df))


#FALAR SOBRE DATAS



#variaveis derivadas das datas
df =  df %>% mutate(week = week(invoicedate),
                    day_of_week = weekdays(invoicedate),
                    month = month(invoicedate, label=TRUE),
                    year = year(invoicedate))
df = df[complete.cases(df),] %>% filter(quantity < 50)
dim(df)
glimpse(df)

#qual a quantidade de itens por transacao?

#qual a media e mediana de itens por transacao?


#qual a semana com mais clientes distintos?


#qual ano e mês com mais clientes distintos?


# efetivamente a partir daqui ---------------------------------------------
head(df)
transactions = read.transactions('../data/items.csv',format='basket',sep=',')
transactions
dim(transactions)
summary(transactions)

itemFrequencyPlot(transactions,topN=12,
                  type="absolute",
                  col=brewer.pal(12,'Paired'),
                  main="Absolute Item Frequency Plot")

association_rules = 
length(association_rules)
summary(association_rules)

inspect()

# Filter rules with confidence greater than 0.4 or 40%
quality(association_rules) %>% head()
quality(association_rules) %>% dim()

quality(association_rules) %>% arrange(desc(support)) %>% head(10)

subRules =

#Plot SubRules
plot()


top10subRules =
  
# groceries dataset -------------------------------------------------------
# repita os passos acima para os dados groceries.csv
# sem medo de copiar e colar
#read_csv é errado, mas permite ver melhoro com o esta organizado

groc = read.transactions('../data/groceries.csv')
sparse = arules::labels(groc)

summary(groc)

itemFrequencyPlot()


association_rules = 
association_rules

summary(association_rules)

inspect()

quality(association_rules) %>% arrange() %>% head()

subRules = 
inspect(subRules)

top10subRules = 



# Plotting ----------------------------------------------------------------
#Iris scatterplot basico

#pode usar pipe \o\ %>% /o/

#pode colocar o plot em uma variavel

##e ajustar o texto

##e salvar os dados


#tutorial com gapminder
head(gapminder)
gapminder %>% sample_n(100)

#Graficos de 1D: Barras

#com mais cor:

#sao 12 anos para cada pais, entao temos que divdir o y por 12, na verdade
gapminder %>% group_by(continent) %>% summarise(n_paises = n_distinct(year))

#pode adicionar à variavel

#trocar de posicao:


#para considerar um outro valor, alem da contagem, devemos adicionar
#stat='identity' ou mudar o geom para geom_col()

#gpd medio para o ano de 2007, para cada continente


#mais de um dado por continente, para mais de um ano


#paises por continente
table(gapminder$continent)/12

#comportamento dentro de um continente


#install.packages('ggcorrplot')
library(ggcorrplot)
data("mtcars")
mtcars

ggcorrplot(correlation_matrix, method = 'square', 
           colors = c('steelblue','white','tomato3'))


#Dados da aula
#itens por transacao

#itens por transacao por mes

#clientes por semana - geom_line()

#clientes por semana - geom_col()

#mesma coisa por mês


#TBT
load('../data/tbt_data.RData')



#pra fechar: plotly

