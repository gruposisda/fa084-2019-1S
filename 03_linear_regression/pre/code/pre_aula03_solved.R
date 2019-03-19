# Carregue o conjunto de dados
# Lembre-se de definir o diretorio corretamente
RA=123456
library(dplyr)

df = read.csv('~/repos/fa084/03_linear_regression/pre/data/fa084_cana_estagio.csv')
df = df %>% group_by(Estagio) %>% summarise(TCH = mean(TCH))
df = group_by(df,Estagio)
summarise(df,TCH=mean(TCH))

#divida em treino e teste:
set.seed(RA)
rows_train = sample(nrow(df), 0.75*nrow(df))
train = df[rows_train,]
test = df[-rows_train,]

#Crie as variaveis a e b, que representam o grau do polinomio a ser treinado em cada caso
set.seed(RA)
#Substitua essa linha pelo sample que cria a variavel a
a = sample(1:3,1)
set.seed(RA)
b = sample(c(4,5),1)
#Substitua essa linha pelo sample que cria a variavel b
df

#treine os dois modelos com a funcao lm() no conjunto de treino.
#Dica: A formula é TCH~poly(Estagio,grau) onde grau é o grau do polinomio.
#Devemos ter um modelo com grau a e outro com grau b
modelo_grau_a = lm(TCH~poly(Estagio,1),data = train)
modelo_grau_b = lm(TCH~poly(Estagio,5),data = train)
summary(modelo_grau_a)
modelo_grau_a$coefficients
modelo_grau_b$coefficients


predicted_a <- predict(modelo_grau_a,train)
predicted_b <- predict(modelo_grau_b,train)

plot(df$Estagio,df$TCH)
lines(train$Estagio,predicted_a,col='green',lwd=3)
points(train$Estagio,predicted_b,col='red',lwd=3)



#Faca a predicao no conjunto de teste usando o modelo a e o modelo b.
#Use a funcao predict("modelo para fazer a previsao", newdata = "conjunto de dados de teste").
pred_a = predict(modelo_grau_a,newdata = test)
pred_b = predict(modelo_grau_b,newdata = test)

#Calcule o erro  medio absoluto (mae) em relacao a TCH do conjunto de teste para cada modelo.
mean(abs(pred_a - test$TCH))
mean(abs(pred_b - test$TCH))

#Agora pode responder a pergunta 1.
  

#Faca o grafico de TCH (eixo y) vs Estagio (eixo x) usando plot().



# OUTRO EXEMPLO -----------------------------------------------------------
p = 0.5
q = seq(0,100,1)
y = p*q
plot(q,y,type='l',col='red',main='Linear relationship')

y = -450 + p*(q-10)^3
plot(q,y,type='l',col='navy',main='Nonlinear relationship',lwd=3)

set.seed(20)
q = seq(from=0, to=20, by=0.1)
y = 500 + 0.4*(q-10)^3
noise = rnorm(length(q), mean=10, sd=80)
noisy.y = y + noise

plot(q,noisy.y,col='blue',xlab='q',main='Observed data')
lines(q,y,col='red',lwd=3)


model3 = lm(noisy.y ~ poly(q,3))
model1 = lm(noisy.y ~ q)

pred3 = predict(model3)
pred1 = predict(model1)

lines(q,pred1,col='green',lwd=3)
lines(q,pred3,col='black',lwd=3)
lines(q,y,col='red',lwd=3)
