###### EXERCICIO 1 ######
set.seed(123456)#use seu RA
d = sample()

#funcao para calcular p(x)
#Lembre do raciocinio da funcao "normalizar" da aula 03
#Esta funcao logistic function deve ter 3 argumentos: x (o vetor), b0 e b1 (numeros calculados em funcao do seu ra)
#Deve retornar um vetor que tera o mesmo tamanho de x
#Este vetor tem a saida da funcao logistica para cada valor de x 
logistic_function = function(x,b0,b1){
  logit = 
  return(logit)
}


B0_a = (d[3] + d[4])/10; B1_a = (d[5] + d[6])/10
px1 = logistic_function(x,B0_a,B1_a)
plot()

#faça para os outros


###### EXERCICIO 2 ######
#Leia o modelo de predicao descrito no livro (secao 4.6.1)
seu_ra = 123456

#1. Importe o arquivo e crie os 3 atributos novos
df = read.csv()


#2. Divida em treino (75%) e teste (25%)
test_rows = 

#3. Crie os 3 modelos, pode ser sem loop
first_model = 
second_model 
third_model 

#Veja as paginas 157 e 158 do livro, sao importantes para os passos 4 a 6.

#4. Faça as predicoes 
#As previsoes de chuva originais (test$choveu) sao TRUE ou FALSE
#O comanto predict(), com type = 'response', retorna as probabilidades de ser TRUE.
#Nos vamos considerar que se a probabilidae for maior que 0.5, sera um choveu
#Assim, se usarmos vetor_de_predicoes > 0.5 temos TRUE quanto eh e false quando nao eh maior
first_probs = predict()
#...
first_preds = #faca a comparacao com 0.5
#repita para os outros
  
  
#5. Calcule a matriz de confusao para a predicao de cada modelo usando a funcao table
#Os argumentos sao vetor_de_predicoes (com TRUE ou FALSE) e predicoes originais (test$choveu)
first_conf_matrix = table()
second_conf_matrix =
third_conf_matrix

#6. Calcule as acuracias

