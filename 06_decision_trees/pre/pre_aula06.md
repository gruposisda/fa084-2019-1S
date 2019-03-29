# FA084 - Pre Aula 06

#### Use o script `pre_aula06_base.R`.
#### Não serão aceitos envios que não usem o script.

A entrega consiste:

* na resposta do google forms: https://forms.gle/MpyU5o7A8AsAHRao8

  **USE O MESMO EMAIL CADASTRADO NO MOODLE**

  Só envie quando estiver certo(a) dos resultados.

* Um arquivo  `pre_aula06_RA_primeironome.zip` contendo:
  * Uma pasta `code` com:
    * Um arquivo `pre_aula06_RA_primeironome.R`(originado do script `pre_aula06_base.R`)
  * Uma pasta `data` com os dados do df importado no script

É necessário responder o form e entregar o arquivo:
` ifelse(respondeu form & entregou o arquivo, "OK", "Não aceito")`

## Criação de regras de decisão

Neste pré aula, vamos criar regras intuitivamente para prever se um passageiro sobreviveu ou não ao acidente do Titanic. Não usaremos técnicas de modelagem, apenas o raciocínio. Para resolver este pré aula, basta saber criar vetores com a lógica correta.

Em todas as questões do cálculo de acurácia de uma regra, avaliamos as informações do conjunto de treino para inferir sobre o conjunto de teste.

As regras criadas durante o raciocínio da questão servem para gerarmos um vetor de predições.
Por exemplo, para um `df` com a coluna `profissao` de cada pessoa no `df` e outra coluna `rico` com 1 se é rico e 0 se não é, podemos analisar as informações e criar a regra:
```
Se a profissao for engenheiro agrícola entao ele é rico, se não for, não é.
```

Nesse caso, um vetor de predições para o df é:

```
preds_based_on_profession = ifelse(df$profissao == 'engenheiro agrícola', 1, 0)
```

Para calcular a acurácia, verificamos com:

```
mean(preds_based_on_profession == df$rico)
```

#### As instruções do pré aula estão no script base


Dicas:

1. Na primeira questão, por exemplo, contamos quantos passageiros sobreviveram no conjunto de treino e, com base nisso, criamos uma regra para o conjunto de teste.
Por exemplo, se a maioria dos passageiros do conjunto de treino morreu, o que é razoavel inferir sobre um passageiro do conjunto de teste?

2. Na questão 2 e nas seguintes o processo de raciocínio é o mesmo: vamos verificar os dados de treino, ver o que é razoável assumir, criar uma regra com comandos similares aos explicados acima e calcular acurácia das regras.
