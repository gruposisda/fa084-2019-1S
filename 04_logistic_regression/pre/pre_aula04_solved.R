###### EXERCICIO 1 ######
set.seed(123456)#use seu RA
d = sample(1:6,6)

#funcao para calcular p(x)
#Lembre do raciocinio da funcao "normalizar" da aula 03
#Esta funcao logistic function deve ter 3 argumentos: x (o vetor), b0 e b1 (numeros calculados em funcao do seu ra)
#Deve retornar um vetor que tera o mesmo tamanho de x
#Este vetor tem a saida da funcao logistica para cada valor de x 
logistic_function = function(x,b0,b1){
  logit = exp(b0+b1*x)/(1+exp(b0+b1*x))
}


B0_a = (d[3] + d[4])/10; B1_a = (d[5] + d[6])/10
px1 = logistic_function(x,B0,B1)
plot(x,px1,type = 'l')

B0 = (d[3]+ d[4])/10; B1 = - (d[5] + d[6])/10
px2 = logistic_function(x,B0,B1)
lines(x,px2)

B0 = (d[3] + d[4] + d[1] + d[2])/10; B1 = (d[5] + d[6])/10
px3 = logistic_function(x,B0,B1)
lines(x,px3)


###### EXERCICIO 2 ######
#Leia o modelo de predicao descrito no livro (secao 4.6.1)
seu_ra = 123456

#1. Importe o arquivo
df = read.csv('~/repos/fa084-2019-1S//04_logistic_regression/pre/fa084_dados_pre_aula4.csv')

#2. Divida em treino (75%) e teste (25%)
test_rows = sample(nrow(df),0.25*nrow(df))
test = df[test_rows,]
train = df[-test_rows,]

#3. Crie os 3 modelos, pode ser sem loop
first_model = glm(chuva~.,train, family = 'binomial')
second_model 
third_model 

#Veja as paginas 157 e 158 do livro, sao importantes para os passos 4 a 6.

#4. Faça as predicoes 
#As previsoes de chuva originais (test$choveu) sao TRUE ou FALSE
#O comanto predict(), com type = 'response', retorna as probabilidades de ser TRUE.
#Nos vamos considerar que se a probabilidae for maior que 0.5, sera um choveu
#Assim, se usarmos vetor_de_predicoes > 0.5 temos TRUE quanto eh e false quando nao eh maior
first_pred = predict(first_model,test,type='response')


#5. Calcule a matriz de confusao para a predicao de cada modelo usando a funcao table
#Os argumentos sao vetor_de_predicoes (com TRUE ou FALSE) e predicoes originais (test$choveu)
first_conf_matrix =
second_conf_matrix =
third_conf_matrix

#6. Calcule as acuracias

