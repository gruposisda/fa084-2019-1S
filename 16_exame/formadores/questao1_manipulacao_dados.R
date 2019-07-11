library(tidyverse)

#Importe o conjunto de dados adult.data.csv


# 1.Quantos homens e mulheres existem no dataset ( coluna sex)?

#2.a) Qual a média de idade (coluna age) das mulheres?
#b) E dos homens?

#3. Qual a idade da pessoa mais nova que nunca trabalhou antes ?
# (status `Never-worked` na coluna `workclass`)

#4. Qual a idade da pessoa mais velha que nunca trabalhou antes
# (status `Never-worked` na coluna `workclass`)

#5. Qual a porcentagem de alemães (native_country é Germany) no conjunto de dados?

#7. Qual a média e desvio padrão da idade daqueles que ganham mais de 50K por ano 
# (coluna salary maior do que 50K) e dos que ganham menos (coluna salary menor ou igual a 50K)?

#8. Mostre os valores máximos e mínimos de idade para cada raça (coluna race) e sexo (coluna sex). 
# Use group_by() e summarise(). Qual a idade máxima e mínima de homens da raça Amer-Indian-Eskimo?

#9.Qual a média de horas trabalhadas (hours_per_week) no japão (native_country é Japan) 
#para aqueles que ganham mais do que 50k e para aqueles que ganham menos de 50k