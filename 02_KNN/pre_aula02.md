  # FA084 / AP522 – Atividade Pré-Aula 2

  ### Assunto: k-NN (k Nearest Neighbours) – k Vizinhos Mais Próximos

  **1)** Considere as perguntas a seguir tanto para problemas de Classificação quanto RegressãoQuando pertinente, as respostas devem ser dadas para cada um dos casos.
  **É possível responder com apenas um parágrafo com até 10 linhas em cada questão.**

   ```
  a) Quais as implicações de utilizar k=1?
  b) Quais as implicações de utilizar um k muito grande?
     Por exemplo, k = N, onde N é o número de registros do conjunto de dados.
   ```

  **2)** Considere seu RA e crie um conjunto de treino e um de teste.

  * Para o conjunto de treino: utilizando os dígitos considere as coordenadas x1, y1, x2,y2, x3, y3. Crie os vetores x_treino e y_treino com os digitos correspondentes. Estes pontos serão das classes Vermelho, Azul, Vermelho.

  * Para o conjunto de teste, utilize os dígitos do seu RA para as cordenadas x1,x2,x3,y1,y2,y3. Crie os vetores x_teste e y_teste com os digitos correspondentes. Estes pontos serão das classes Azul, Vermelho e Azul.

  Exemplo para RA 123456:

  ```
  Treino:
  X    Y    Classe
  1    2    Vermelho
  3    4    Azul
  5    6    Vermelho

  Teste:
  x    y    classe
  1    4    Azul
  2    5    Vermelho
  3    6    Azul
  ```

  Crie um gráfico para esses conjuntos utilizando os seguintes comandos no R:

  ```
  # cria gráfico do conjunto de treino usando pontos vazados
  plot(treino_x, treino_y, col = c('red', 'blue', 'red', xlim=c(0,9), ylim=c(0,9))

  # adiciona os pontos do conjunto de teste utilizando pontos cheios
  points(teste_x, teste_y, col = c('blue', 'red', 'blue'), pch=19)
  ```

  Com base no gráfico, isto é, sem utilizar uma implementação de vizinhos próximos, responda:
  ```
   a) Como seriam classificados os pontos do conjunto de teste utilizando vizinhos mais próximos (considere apenas 1 vizinho)?
   b) Qual é a acurácia no conjunto de treino?
   c) Qual é a acurácia no conjunto de teste?
  ```
  OBS: A atividade deve ser enviada para o Moodle como um arquivo PDF.
       O arquivo deve ser nomeado como fa084_preaula02_RA_primeiro_nome.pdf
       Exemplo: fa084_preaula02_800584_luiz_henrique
