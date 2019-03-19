alunos = c("aliny","christy","elaine","fernando camargo","fernando daniel","gisela","joaquim","joao paulo",
           "marcelle","marianna","olavo","rodrigo","wagner","bruno","ana flavia","anderson","bruno","daniel",
           "diogo","douglas","fernando cunha","gabriel","gustavo rocha","gustavo pereira","juliana","kelly","lais","paulo","rafael","rafella","sabrina","samuel","stefani")
#1.Importar libraries e arquivo ----
library(ggplot2)

#2. Explorar atributos ----

#remover categoricos

#explorar features
df %>% select(contains('ppt')) %>% gather('ppt','mm_chuva') %>% 
  ggplot(aes(mm_chuva,color=ppt)) + geom_density(size = 1.5) + theme_classic()+
  theme(axis.text=element_text(size=12),
        axis.title=element_text(size=14,face="bold")) + ylab('')

df %>% select(contains('lst')) %>% gather('temp','Kelvin') %>% 
  ggplot(aes(Kelvin,color=temp)) + geom_density(size = 1.5) + theme_classic()+
  theme(axis.text=element_text(size=12),
        axis.title=element_text(size=14,face="bold")) + ylab('')

#3. Construir features ----
#total de ppt do periodo todo

#temperatura media do periodo todo


#4. Normalizacao ----

#funcao para normalizacao

#apply no df todo

#5. Treino e teste raw vs. norm ----

#modelo

#https://stats.stackexchange.com/questions/25804/why-would-r-return-na-as-a-lm-coefficient

coef_df$variavel = rownames(coef_df)
rownames(coef_df) = NULL
coef_df %>% ggplot(aes(x=variavel,y=coef_norm)) + geom_bar(stat='identity', fill='steelblue') + theme_classic() +coord_flip()
coef_df %>% filter(variavel != '(Intercept)') %>% ggplot(aes(x=variavel,y=coef)) + geom_bar(stat='identity', fill='steelblue') + theme_classic() +coord_flip()


#funcao para calcular o mae


#"desnormaliza"

#atentar diferença entre desnormalizar ou não


#6. Tunar graus e formulas ----
#loop para variar o grau
#o que podemos variar?
# grau do polinomio

