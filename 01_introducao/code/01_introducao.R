#01 - Introdução

#Atalhos
#https://github.com/rstudio/cheatsheets/raw/master/rstudio-ide.pdf

#foco no console vs script
#manipulação de linhas
#executar seleção, linhas e chunks

# Criar variáveis e ambientes

# 1. Tipos de variáveis -----
# numeric, character e boolean
# https://swcarpentry.github.io/r-novice-inflammation/13-supp-data-structures/
a = 1
b = 1
class(a)
class(b)
a + b

x = '1'
class(x)
a + x
x = 'texto'
class(x)
x = 'uma frase'
class(x)

d = TRUE
class(d)
a + d


# 2. Vetores -----
#Vetores armazenam valores DO MESMO TIPO e são definidos com a função c().
(2,1)
c(2,1)
numeros = c(5,7,9)
class(numeros)

letras = c('A','B','C')
class(letras)
chars = c('5','7','9')
class(chars)
chars = c('5','7',9)
class(chars)

bool = c(TRUE,FALSE,TRUE)
class(bool)
bool = c(T,F,T)
class(bool)

#Vetores tem uma dimensao, so precisamos saber o indice do elemento que queremos isolar
#tamanho do vetor
length(numeros) #tem 3 elementos
length(chars)


numeros[1] #elemento 1 do vetor numeros (ou seja , o numero 5)
letras[2] #elemento 2 do vetor letras (ou seja , o caractere "B")
chars[10] # se nao existe, retorna na

#se quisermos mais de um elemento:

vec = letters
vec[4:10]

#subset logico
vec == 'a'
vec == 'c'
vec[(vec == 'c' | vec == 'd')]

# 3. Dataframes -----
#tipo de estrutura mais comum entre os dados, a classica tabela
#pode-se pensar em um dataframe como muitos vetores um ao lado do outro e todos do mesmo tamanho
numeros
chars
bool

df =data.frame(numeric = numeros, logicals = bool)
df
#dataframes tem duas dimensoes: linhas e colunas
#df[linha,coluna]
df
df[2,1]
df[2,2]
df[1,]
df[,2]
df[,1]


# Explorar conjunto de dados 
iris
df = iris
class(df)

#subset do iris
df[50:100,]

#principais funcoes head, tail, dim, nrow, ncol, str, colnames 
head(df)
tail(df)
dim(df)
colnames(df)
str(df)

# 4. Histograma, plots, boxplot -----
df = iris
dados = df[,1]
hist(dados)
hist(dados,breaks = 20)
hist(dados,breaks = 30, col='blue')
hist(dados,breaks = 30, col='blue',main='Histograma de Sepal Length')
hist(dados,breaks = 30, col='blue',main='Histograma de Sepal Length',
     xlab = 'Sepal Length', ylab= 'Frequência')

#plot de densidade
dados_dens = density(df[,1])

plot(dados_dens,main='Histograma de Sepal Length',
     xlab = 'Sepal Length', ylab= 'Frequência',col='red')
lines(density(df[,3]))


#plot x vs y
df = cars
help(cars)
colnames(df)
head(df)
plot(df$speed,df$dist,xlab ='Speed (mph) ',ylab='Distance to stop (ft)')
reg = lm(dist~speed,data = df)
reg
abline(reg,col='blue')

#boxplots
boxplot(iris[,c(1,2,3,4)],col=terrain.colors(4),main = 'Boxplot Iris')
1:4


# 5. Big dataset -----
#https://www.kaggle.com/tsiaras/uk-road-safety-accidents-and-vehicles
t0 = Sys.time()
bigdf = read.csv('./data/uk-road-safety-accidents-and-vehicles/Accident_Information.csv')
t1 = Sys.time()
t1-t0
dim(bigdf)
colnames(bigdf)

road_cond_acc_sev = table(bigdf$Road_Surface_Conditions,bigdf$Accident_Severity)

road_cond_acc_sev
dat = as.data.frame(prop.table(road_cond_acc_sev,margin = 1)[2:6,])
dat

library(ggplot2)
ggplot(dat, aes(x=Var1,y=Freq,fill=Var2)) + 
  geom_bar(stat='identity', position = 'dodge', alpha = 2/3)

ggplot(dat[dat$Var2!='Slight',], aes(x=Var1,y=Freq,fill=Var2)) + 
  geom_bar(stat='identity', position = 'dodge', alpha = 2/3)

speed_lim_acc_sev = table(bigdf$Speed_limit,bigdf$Accident_Severity)
speed_lim_acc_sev
as.data.frame(prop.table(speed_lim_acc_sev,margin = 1))




# 6. Estrutura de diretórios -----




#code, data etc

#kaggle?