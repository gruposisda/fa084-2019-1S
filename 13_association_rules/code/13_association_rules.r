library("tidyverse")
library("arules")
library("arulesViz")
library("readxl")
library("lubridate")
library("RColorBrewer")
library("plotly")
library("ggcorrplot")


df = read_excel('../data/online_retail.xlsx')
#head(df)
dim(df)

df = df %>% mutate(Description = as.factor(Description),
                   Country = as.factor(Country),
                   InvoiceNo = as.numeric(InvoiceNo))
colnames(df) = tolower(colnames(df))


#FALAR SOBRE DATAS
df$invoicedate= as.POSIXct(df$invoicedate,format="%Y-%m-%d %H:%M:%S")
#mes escrito M, b, B, ano curto y
df$transaction_time = format(df$invoicedate,"%H:%M:%S")
df$date= format(df$invoicedate,"%Y-%m-%d")
head(df)


df =  df %>% mutate(week = week(invoicedate),
                    day_of_week = weekdays(invoicedate),
                    month = month(invoicedate, label=TRUE),
                    year = year(invoicedate))
df = df[complete.cases(df),] %>% filter(quantity < 50)
dim(df)

head(df)
table(df$month)
glimpse(df)


#qual o item mais vendido?

#qual a quantidade de itens por transacao?

#qual a media e mediana de itens por transacao?
df %>% group_by(invoiceno) %>% 
  summarise(no_itens = sum(quantity)) %>% 
  summarise(mean(no_itens),median(no_itens))

#qual a semana com mais clientes distintos?

df %>% group_by(week) %>%
  summarise(clientes = n_distinct(customerid)) %>%
  arrange(desc(clientes)) 

#qual ano e mês com mais clientes distintos?
df %>% group_by(month,year) %>%
  summarise(clientes = n_distinct(customerid)) %>%
  arrange(desc(clientes)) 

# efetivamente a partir daqui ---------------------------------------------
head(df)
transactions = read.transactions('../data/items.csv',format='basket',sep=',')
dim(transactions)

transactions
summary(transactions)

itemFrequencyPlot(transactions,topN=12,
                  type="absolute",
                  col=brewer.pal(12,'Paired'),
                  main="Absolute Item Frequency Plot")

association_rules = apriori(transactions,
                            parameter = list(supp=0.001, 
                                             conf=0.8,
                                             maxlen=10))
length(association_rules)
summary(association_rules)

inspect(association_rules[1:10])


shorter_association_rules = apriori(transactions, 
                                    parameter = list(supp=0.001,
                                                     conf=0.8,
                                                     maxlen=3))


# Filter rules with confidence greater than 0.4 or 40%
quality(association_rules) %>% head()
quality(association_rules) %>% dim()

quality(association_rules) %>% arrange(desc(support)) %>% head(10)

subRules = association_rules[quality(association_rules)$support>0.005]
dim(quality(subRules))
inspect(subRules)

#Plot SubRules
plot(subRules)


top10subRules = head(subRules, n = 10, by = "support")
plot(top10subRules, method = "graph",  engine = "htmlwidget")


# groceries dataset -------------------------------------------------------
groc = read_csv('./data/groceries.csv', col_names = F)
groc

groc = read.transactions('../data/groceries.csv')
groc

summary(groc)

itemFrequencyPlot(groc,topN=10,type="absolute",
                  col=brewer.pal(8,'Set3'), main="Frequência de itens")



association_rules = apriori(groc, parameter = list(supp=0.001,
                                                   conf=0.8,
                                                   maxlen=10))

association_rules

summary(association_rules)

inspect(association_rules[1:10])

quality(association_rules) %>% head()
quality(association_rules) %>% dim()

quality(association_rules) %>% arrange(desc(support)) %>% head(10)

subRules = association_rules[quality(association_rules)$support>0.005]
dim(quality(subRules))
inspect(subRules)

top10subRules = head(association_rules, n = 10, by = "support")
plot(top10subRules, method = "graph",  engine = "htmlwidget")



# Plotting ----------------------------------------------------------------
#Iris scatterplot basico
ggplot(iris, aes(x=Sepal.Length, y=Sepal.Width)) + 
  geom_point(size=6, alpha=0.6)

ggplot(iris, aes(x=Sepal.Length, y=Sepal.Width, color = Species)) + 
  geom_point(size=6, alpha=0.6)

#pode usar pipe \o\ %>% /o/
iris %>% ggplot(aes(x=Sepal.Length, y=Sepal.Width, 
                    color = Species, shape = Species)) + 
  geom_point(size=6, alpha=0.6)

#pode colocar o plot em uma variavel
p = ggplot(iris, aes(x=Sepal.Length, y=Sepal.Width, color = Species)) + 
   geom_point(size=6, alpha=0.6)

p + labs(x = 'Sepal Length', y = 'Sepal Width') + theme_classic() +
  theme(axis.title = element_text(size = 14, family = 'times',
                                  face = 'bold'),
        axis.text = element_text(size = 15, family = 'times'),
        legend.text = element_text(size = 15, family = 'times'),
        legend.title = element_text(size = 16, family =' times'))

ggsave('./iris_plot.jpg',p)

#tutorial com gapminder

#Graficos de 1D: Barras
table(gapminder$continent)
ggplot(gapminder, aes(x=continent)) + geom_bar()
ggplot(gapminder, aes(x=continent)) + geom_bar(color = 'black', fill = 'red')

#com mais cor:
ggplot(gapminder, aes(x=continent, fill=continent)) + geom_bar(color='black')

#sao 12 anos para cada pais, entao temos que divdir o y por 12, na verdade

gapminder %>% group_by(continent) %>% summarise(n_paises = n_distinct(year))

country_count  = ggplot(gapminder %>% filter(year==2007), aes(x=continent, fill=continent)) + 
  geom_bar() +
  labs(y="Number of countries")


#pode adicionar à variavel
country_count + coord_trans(y='sqrt')
country_count + guides(fill=F) + theme_grey()

#trocar de posicao:
country_count + coord_flip()

#e muito mais:
country_count + coord_polar() + theme_bw()

#para considerar um outro valor, alem da contagem, devemos adicionar
#stat='identity' ou mudar o geom para geom_col()

#gpd medio para o ano de 2007, para cada continente
gapminder %>% group_by(continent, year) %>% summarise(mean_gdp = mean(gdpPercap)) %>% 
       filter(year == 2007) %>% 
ggplot(aes(x=continent, y = mean_gdp,fill=continent)) + geom_col()

#mais de um dado por continente
gapminder %>% group_by(continent, year) %>% 
  summarise(mean_gdp = mean(gdpPercap), mean_life = mean(lifeExp)) %>%
  #filter(year == 2007) %>% 
  ggplot(aes(x=continent, y = mean_gdp,size = mean_life,
             color = as.factor(year))) + geom_point(alpha = 0.8)

#paises por continente
table(gapminder$continent)/12

#comportamento dentro de um continente
p =gapminder %>% filter(continent=='Europe') %>% 
  group_by(country, year) %>% summarise(mean_gdp = mean(gdpPercap), mean_life = mean(lifeExp)) %>% 
  filter(year == 2007) %>% 
  ggplot(aes(x=country, y = mean_gdp,
             size = mean_life,
             color = country)) + geom_point(alpha = 0.8) + 
  theme_bw()+
  theme(axis.text.x = element_text(angle = 90, hjust = 0,vjust=0))

ggplotly(p)

#install.packages('ggcorrplot')
library(ggcorrplot)
data("mtcars")
mtcars
corrleation_matrix = round(cor(mtcars),1)
ggcorrplot(corrleation_matrix)
?ggcorrplot
ggcorrplot(corrleation_matrix, method = 'circle', 
           colors = c('steelblue','white','tomato3'))

ggcorrplot(corrleation_matrix, method = 'circle', 
           colors = c('springgreen','white','tomato3'),
           ggtheme = theme_classic())


#Dados da aula
#itens por transacao
df %>% group_by(invoiceno) %>% 
  summarise(no_itens = sum(quantity)) %>% 
  ggplot(aes(no_itens)) + geom_histogram(bins=30) + theme_minimal()

#itens por transacao por mes
df %>% group_by(invoiceno,month) %>% 
  summarise(no_itens = sum(quantity)) %>% 
  ggplot(aes(no_itens,fill=month)) + geom_histogram(bins=30) + theme_minimal()


weekly_customers = df %>% group_by(week) %>%
  summarise(clientes = n_distinct(customerid)) %>%
  arrange(desc(clientes)) 
weekly_customers


ggplot(weekly_customers,aes(x=week,y=clientes)) + 
  geom_line(group=1,color = 'red')+
  labs(x = 'CLIENTES', y = 'SEMANA')+
  theme(axis.text = element_text(size=15, face = 'bold'),
        axis.title = element_text(size = 20, face = 'bold'),
        axis.line = element_line(color = 'black',size=0.5))
  

ggplot(weekly_customers,aes(x=week,y=clientes)) + 
  geom_col(color='black',fill='steelblue')+
  labs(x = 'CLIENTES', y = 'SEMANA') +
  theme(axis.text = element_text(size=15, face = 'bold'),
        axis.title = element_text(size = 20, face = 'bold'),
        axis.line = element_line(color = 'black')) + 
  theme_bw()

df %>% group_by(month) %>%
  summarise(clientes = n_distinct(customerid)) %>%
  arrange(desc(clientes)) %>% 
  #grafico a partir daqui:
  ggplot(aes(x=month,y=clientes)) + 
  geom_bar(stat = 'identity',color='black',fill='steelblue')+
  labs(x = 'CLIENTES', y = 'SEMANA') +
  theme(axis.text = element_text(size=15, face = 'bold'),
        axis.title = element_text(size = 20, face = 'bold'),
        axis.line = element_line(color = 'black')) + 
  theme_bw()

#TBT
load('../data/tbt_data.RData')

ggplot(train,aes(x=XCoord, y=YCoord, color=Competitor))+
  geom_point(size=5) +
  coord_cartesian(xlim = c(-1, 1), ylim = c(-1, 1)) + 
  theme_classic()

test
ggplot(test, aes(x=XCoord, y=YCoord,
                 colour=Competitor,
                 shape=correto,
                 label=pred_errado))+
  scale_shape_manual(values=c(4,1))+
  geom_point(lwd=2,stroke=3)+
  geom_text(fontface = 'bold',size=7,nudge_x = -0.2)+
  coord_cartesian(xlim = c(-1, 1), ylim = c(-1, 1)) +  
  theme_classic() 


ggplot(gapminder, aes(gdpPercap, lifeExp, color = continent, frame = year)) +
  geom_point(aes(size = pop, ids = country)) +
  geom_smooth(se = FALSE, method = "lm") +
  scale_x_log10()

library(plotly)
g <- crosstalk::SharedData$new(gapminder, ~continent)
gg <- ggplot(g, aes(gdpPercap, lifeExp, color = continent, frame = year)) +
  geom_point(aes(size = pop, ids = country)) +
  geom_smooth(se = FALSE, method = "lm") +
  scale_x_log10()
ggplotly(gg) %>% 
  highlight("plotly_hover")
