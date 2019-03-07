treino_x = c(1,3,1)
treino_y = c(6,8,6)

teste_x = c(1,6,3)
teste_y = c(8,1,6)

# cria gráfico do conjunto de treino usando pontos vazados
plot(treino_x, treino_y, col = c('red', 'blue', 'red'), xlim=c(0,9), ylim=c(0,9))
# adiciona os pontos do conjunto de teste utilizando pontos cheios
points(teste_x, teste_y, col = c('blue', 'red', 'blue'), pch=19)
