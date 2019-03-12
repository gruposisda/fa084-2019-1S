# Carregue o conjunto de dados
# Lembre-se de definir o diretorio corretamente
RA=123456
df = read.csv('../pre/data/fa084_cana_estagio.csv')

#divida em treino e teste:
set.seed(RA)
rows_train = sample(nrow(df), 0.75*nrow(df))
train = df[rows_train,]
test = df[-rows_train,]

#Crie as variaveis a e b, que representam o grau do polinomio a ser treinado em cada caso
set.seed(RA)
#Substitua essa linha pelo sample que cria a variavel a
a = sample(c(1,2,3),1)
set.seed(RA)
b = sample(c(4,5),1)
#Substitua essa linha pelo sample que cria a variavel b


#treine os dois modelos com a funcao lm() no conjunto de treino.
#Dica: A formula é TCH~poly(Estagio,grau) onde grau é o grau do polinomio.
#Devemos ter um modelo com grau a e outro com grau b
modelo_grau_a = lm(TCH~poly(Estagio,a),data = df)

modelo_grau_b = lm(TCH~poly(Estagio,b),data = df)


#Faca a predicao no conjunto de teste usando o modelo a e o modelo b.
#Use a funcao predict("modelo para fazer a previsao", newdata = "conjunto de dados de teste").
pred_a = predict(modelo_grau_a,newdata = test)
pred_b = predict(modelo_grau_b,newdata = test)
  
#Calcule o erro  medio absoluto (mae) em relacao a TCH do conjunto de teste para cada modelo.
mean(abs(pred_a - test$TCH))
mean(abs(pred_b - test$TCH))

#Agora pode responder a pergunta 1.
  

#Faca o grafico de TCH (eixo y) vs Estagio (eixo x) usando plot().