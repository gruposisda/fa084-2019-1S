# Review estrutura de diretórios
## getwd(), setwd(), list.files()
## caminho absoluto vs caminho relativo
getwd()
setwd('repos/fa084/tutorials/')
setwd('code/')
setwd('../')
getwd()

#R BASE
#leitura de arquivos
#read.table, read.csv, read.tsv
#read.csv
df = read.csv('data/iris.csv')
df = read.table(file = 'data/iris2.csv',sep = ';',header = TRUE)
df = read.table(file = 'data/iris.tsv',sep = '\t',header = TRUE)

#READR
#install.packages('readr')
library(readr)
#o que é
#funções para leitura de arquivos mais rápidas
df = read_csv('data/iris.csv')
df = read_delim('data/iris.csv',delim = ',')


#read_csv vs read.csv para um arquivo grande
t0 = Sys.time()
df = read.csv('~/data/fa084/01_introdução/data/Accident_Information.csv')
t1 = Sys.time()
t1-t0

t2 = Sys.time()
fast_df = read_csv('~/data/fa084/01_introdução/data/Accident_Information.csv')
t3 = Sys.time()
t3-t2

df1 = read_csv('data/iris.csv')
df2 = iris
df3 = ChickWeight
df4 = mtcars

#lista
df_list = list(df1,df2,df3,df4)

head(df_list[[3]])
dim(df2)
dim(df_list[[2]])
dim(df3)
dim(df_list[[3]])

#como ler vários arquivos de uma vez
?list.files
#1.listar os arquivos a serem importados
setwd('data/many_files/')
list.files()
files = list.files()



#loop que imprime (print) o conteudo de uma variavel
for(file in files){
  print(file)
}

#listas com indices com nome
lista = list()
lista[['iris']] = iris
lista[['mtcars']] = mtcars
lista[['chicks']] = ChickWeight

#13 dataframes em uma lista
arquivos = list()
for(file in files){
  print(file)
  arquivos[[file]] = read.csv(file,header=FALSE)
}

library(dplyr)
todos_arquivos = bind_rows(arquivos)


names(arquivos)
dim(arquivos[[1]])
dim(arquivos[['file01.csv']])

dim(arquivos[[13]])
dim(arquivos[['mod.csv']])



