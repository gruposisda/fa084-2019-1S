'Considerando seu RA, crie 4 vetores: treino_x, treino_y, teste_x, teste_y.
Cada digito deve estar em um indice do vetor.

Os exemplos abaixo servem para o RA 123456:

treino_x deve conter os 3 primeiros digitos do seu RA (1, 2 e 3)
treino_y deve conter os 3 ultimos digitos do seu RA (4,5 e 6)

teste_x deve conter 2, 4 e 6
teste_y deve conter 1, 3 e 5

um conjunto de dados utilizando os dígitos para as coordenadas x1, y1, x2,y2, x3,y3.
Este será seu conjunto de treino e os pontos serão das classes Vermelho, Azul, Vermelho.
Considerando seu RA, crie outro conjunto de dados utilizando os dígitos para as coordenadas x1, x2, x3, y1, y2, y3.
Este será seu conjunto de teste e os pontos serão das classes Azul, Vermelho, Azul.'






Crie um gráfico para esses conjuntos utilizando os seguintes comandos no R:
  # cria gráfico do conjunto de treino usando pontos vazados
  plot(treino_x, treino_y, col = c('red', 'blue', 'red', xlim=c(0,9), ylim=c(0,9))
       # adiciona os pontos do conjunto de teste utilizando pontos cheios
       points(teste_x, teste_y, col = c('blue', 'red', 'blue'), pch=19)
       Baseado no gráfico, isto é, sem utilizar uma implementação de vizinhos próximos, responda:
         a) Como seriam classificados os pontos do conjunto de teste utilizando vizinhos mais próximos (considere apenas 1 vizinho)?
  b) Qual é a acurácia no conjunto de treino?
  
  c) Qual é a acurácia no conjunto de teste?