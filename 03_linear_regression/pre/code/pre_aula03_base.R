# Carregue o conjunto de dados
# Lembre-se de definir o diretorio corretamente
RA=123456
df = read.csv('../data/fa084_cana_estagio.csv')
library(ggplot2)
df %>% group_by(Estagio) %>% summarise(tch = mean(TCH)) %>% ggplot(.,aes(x = Estagio, y = tch)) + geom_point(size = 5)

#divida em treino e teste:
set.seed(RA)
rows_train = 
train = 
test = 

#Crie as variaveis a e b, que representam o grau do polinomio a ser treinado em cada caso
set.seed(RA)
#Substitua essa linha pelo sample que cria a variavel a
set.seed(RA)
#Substitua essa linha pelo sample que cria a variavel b


#treine os dois modelos com a funcao lm() no conjunto de treino.
#Dica: A formula é TCH~poly(Estagio,grau) onde grau é o grau do polinomio.
#Devemos ter um modelo com grau a e outro com grau b
modelo_grau_a = 

modelo_grau_b = 


#Faca a predicao no conjunto de teste usando o modelo a e o modelo b.
#Use a funcao predict("modelo para fazer a previsao", newdata = "conjunto de dados de teste").
pred_a = 
pred_b =
  
#Calcule o erro  medio absoluto (mae) em relacao a TCH do conjunto de teste para cada modelo.


#Agora pode responder a pergunta 1.
  

#Faca o grafico de TCH (eixo y) vs Estagio (eixo x) usando plot().