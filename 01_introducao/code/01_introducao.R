#01 - Introdução

#Atalhos
#https://github.com/rstudio/cheatsheets/raw/master/rstudio-ide.pdf

#foco no console vs script
#manipulação de linhas
#executar seleção, linhas e chunks

# Criar variáveis e ambientes

# 2. Tipos de variáveis
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


# 2. Vetores e dataframes
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

#Dataframes
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



# Explorar conjunto de dados:
iris
df = iris
class(df)

#principais funcoes head, tail, dim, nrow, ncol, str, colnames
head(df)
tail(df)
dim(df)
colnames(df)
str(df)

#histograma, plots, media, desvio padrao, boxplot

df = mtcars
head(df)
tail(df)
dim(df)
colnames(df)
str(df)

# 3. Estrutura de diretórios: Começamos colocando os arquivos em uma pasta chamada `code` (ou `codigos`) e os dados em outra, chamada `data` (ou `dados`).
# Evite acentos e espaços em nomes de pastas e arquivos.


