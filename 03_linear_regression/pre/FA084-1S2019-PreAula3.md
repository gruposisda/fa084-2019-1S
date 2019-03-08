# FA084 / AP522 – Atividade Pré-Aula 2

O conjunto de dados ‘fa084_cana_estagio.csv’ contém a produtividade de diferentes talhões (uma divisão de área, um “campo”) de produção de cana-de-açúcar e o número de vezes que estes talhões foram colhidos.
A produtividade corresponde a coluna TCH (Toneladas de Cana-de-açúcar por Hectare) e o número de cortes corresponde a coluna Estágio.
Após carregar o conjunto de dados:

* Faça a divisão em conjunto de treino (75%) e teste (25%).
**Utilize o seu RA como seed** para garantir consistência entre splits.
Use o mesmo procedimento visto em sala na aula 02.
* Crie uma rotina para avaliar o uso de modelos lineares (de ordem 1 a 5, seção 3.6.5 do livro texto) para prever a produtividade em função do estágio (TCH~Estagio).
**Dica:** um modelo de primeira ordem um pode utilizar “TCH ~ poly(Estagio, 1)”, o modelo de quinta ordem utiliza “TCH ~ poly(Estagio, 5)”: ver exemplo na pag 117.


O arquivo fa084_aula3_funcoes.R, contém duas funções:

* `adjr2`: esta função calcula o R² ajustado para modelos com multiplas entradas.
Você deve utilizar como adjr2(ypred, yobs, n, p
  * `ypred` : Valores preditos (preditos no conjunto de treino)
  * `yobs`  : Valores observados (valores de TCH no conjunto de treino)
  * `n` = número de linhas no conjunto de treino
  * `p` = grau do polinômio utilizado

* `calc_mae`: você deve completar a função que calcula o erro médio absoluto visto na Aula 02.

Calcule o MAE para o conjunto de treino e de teste.

Apresente seus resultados utilizando uma tabela organizada como abaixo:

```
ordem mae_treino  mae_teste   rsqr   
1         x1          y1      r1
2   	  x2          y2      r2
.          .           .       .
.          .           .       .
5         x5          y5      r5

```


1. Qual modelo apresenta melhor resultado de acordo com o MAE? Justifique.

2. Qual modelo apresenta o melhor resultado de acordo com o R2? Justifique.

3. Construa um gráfico de TCH vs Estagio. É possível identificar o tipo de relação entre as variáveis? Você considera que os modelos escolhidos em A e B são adequados para representar a relação entre TCH e Estagio?

Apresente suas respostas em um arquivo pdf com o nome fa084_atividade3_RA_primeironome.pdf.
