library(tidyverse)


arquivos_full = list.files('data/continentes/',pattern = 'csv',full.names = T)
getwd()


lista_arquivos = lapply(arquivos_full, read_csv)
dim(lista_arquivos[[1]])

lapply(lista_arquivos, dim)

x = lista_arquivos[[1]]
print_dims = function(x){
  dims = dim(x)
  print(paste0('Esse dataframe tem ',dims[1], ' e ', dims[2], ' colunas.'))
}

lapply(lista_arquivos, print_dims)

lapply(lista_arquivos, function(x) x %>% filter(year == 2007))

names(lista_arquivos)
arquivos_full
basename(arquivos_full)

nomes_lista = str_replace(basename(arquivos_full),'.csv','')
names(lista_arquivos) = nomes_lista
names(lista_arquivos)
lista_arquivos[['oceania']]

#verifica que tem 5 colunas
lapply(lista_arquivos, colnames) %>% unlist() %>% unique()

df =bind_rows(lista_arquivos,.id = 'continente')
dim(df)
head(df)



# strings ---------------------------------------------------------------

string1 = 'This is sparta'
string2 = 'Strings can have "quotes" as long as they are different'

#tamanho string
str_length(c('a','R for data science',NA,string1,string2))

#subset de strings
str_sub(string1,start = 1,end = 4)
str_sub(string1,start = -6,end = -1)


#combinacao de strings
str_c('a','b','c',sep=' * ')


str_to_lower(string2)
str_to_upper(string2)
str_to_title(string2)

cols = colnames(df)
cols

#BEM UTIL
dput(cols)

strings = c("continente", "country", "year", "lifeExp", "pop", "gdpPercap")

strings
str_detect(strings,"nt")
str_subset(strings,"E")


#regular expressions - regex
x = c("a", "ab", "acb", "accb", "acccb", "accccb","acccccccd")

str_subset(x, "ac+")

str_subset(x, "ac+b")

str_subset(x,'ac?b')

str_subset(x, 'a*b')

str_subset(x,'ac{2}b')
str_subset(x,'ac{5}b')

x = month.name

str_sort(x)

#match do começo da string
str_subset(x,'^J')
#pelo fim do string
str_subset(x,'er$')

str_subset(str_to_lower(x), "^[j|m]")

x = "1888 is the longest year in Roman numerals: MDCCCLXXXVIII, it's longer than 2000 which is MM"

str_extract(x, "XX?")

str_extract(x, "CC+")

str_extract(x, '8+')
str_extract(x, '0+')
str_extract(x, '1+')

y = "3 is the longest year in Roman numerals: 343242342 MDCCCLXXXVIII, it's longer than 3454353 which is MM"
str_extract_all(c(x,y), "[0-9]+",simplify = T)

str_extract_all(x,"[A-M]+")
str_extract_all(x,"[a-z]+")

#Extraia os DDDs dos telefones abaixo:
tels = c('19 999 888 777', '16 777 888 666', '11 989 898 889')
str_extract(tels,'[0-9]{2}')
str_extract(tels,'[0-9]{3}')
#extraia o primeiro grupo de 3 numeros

#transforme os numeros em ligacoes a cobrar
str_c('90XX ',tels)

sentences

colors <- c("red", "orange", "yellow", "green", "blue", "purple")
match = str_c(colors,collapse ='|')

colors_matched = str_subset(sentences,match)
colors_matched
str_extract(colors_matched, match)









