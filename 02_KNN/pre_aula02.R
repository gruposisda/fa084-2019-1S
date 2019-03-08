treino_x = c(1,8,0)
treino_y = c(1,1,0)

teste_x = c(1,1,8)
teste_y = c(1,0,0)

# cria gráfico do conjunto de treino usando pontos vazados
plot(treino_x, treino_y, col = c('red', 'blue', 'red'), xlim=c(0,9), ylim=c(0,9))
# adiciona os pontos do conjunto de teste utilizando pontos cheios
points(teste_x, teste_y, col = c('blue', 'red', 'blue'), pch=19)
 