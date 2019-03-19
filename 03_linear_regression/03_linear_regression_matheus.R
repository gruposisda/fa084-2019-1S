#1.Importar arquivo ----
library(ggplot2)
library(dplyr)
library(tidyr)
library(GGally)
df = read.csv('~/data/fa084/03_regressao_linear/data/fa084_tch_mult.csv')

#2. Explorar atributos ----
dim(df)
head(df)
colnames(df)
str(df)
glimpse(df)
summary(df)

#remover categoricos
cols_to_remove_name = c('variedade', 'solo','espac')
cols_to_remove_number = match(cols_to_remove_name,colnames(df))
df = df[,-cols_to_remove_number]

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
colnames(df)
df$ppt_total = df$ppt_i + df$ppt_ii + df$ppt_iii

#temperatura media do periodo todo
colnames(df)
df$lstd_mean = (df$lstd_i + df$lstd_ii + df$lstd_iii)/3

#4. Normalizacao ----
pptmax = max(df$ppt_total)
pptmin = min(df$ppt_total)

pptnorm = (df$ppt_total - pptmin)/(pptmax - pptmin)
par(mfrow=c(1,2))
plot(density(pptnorm))
plot(density(df$ppt_total))
par(mfrow=c(1,1))


#funcao para normalizacao
normalizar = function(x){
  norm_x = (x - min(x))/(max(x)-min(x))
  return(norm_x)
}

#apply no df todo
norm_df = apply(df, 2, normalizar)
norm_df = as.data.frame(norm_df)

#5. Treino e teste raw vs. norm ----
dim(norm_df)
set.seed(42)
test_rows = sample(nrow(df),0.25*nrow(df))

test = df[test_rows,]
train = df[-test_rows,]

test_norm = norm_df[test_rows,]
train_norm = norm_df[-test_rows,]
colnames(train)

#modelo
model = lm(tch~.,train)
coef = model$coefficients

model_norm = lm(tch~.,train_norm)
coef_norm = model_norm$coefficients

preds = predict(model,test)
preds_norm = predict(model_norm,test_norm)
#https://stats.stackexchange.com/questions/25804/why-would-r-return-na-as-a-lm-coefficient

cor(norm_df)
ggcorr(norm_df)



coef_df = data.frame(coef,coef_norm)
coef_df$variavel = rownames(coef_df)
rownames(coef_df) = NULL
coef_df %>% ggplot(aes(x=variavel,y=coef_norm)) + geom_bar(stat='identity', fill='steelblue') + theme_classic() +coord_flip()
coef_df %>% filter(variavel != '(Intercept)') %>% ggplot(aes(x=variavel,y=coef)) + geom_bar(stat='identity', fill='steelblue') + theme_classic() +coord_flip()

#funcao para calcular o mae
calc_mae = function(real,preds){
  mean(abs(real - preds))
}

#"desnormaliza"
preds_norm = preds_norm * (max(test$tch)-min(test$tch)) + min(test$tch)
preds

calc_mae(test$tch,preds)
calc_mae(test$tch,preds_norm)
#atentar diferença entre desnormalizar ou não


summary(model)
sort((model$coefficients))




#6. Tunar graus e formulas ----
#loop para variar o grau
#o que podemos variar?
# grau do polinomio
graus = c(2,3,4)
mae_varia_grau = numeric()
grau = 2
for(grau in graus){
  mod = lm(tch~poly(estagio,grau),train_norm)
  preds = predict(mod,test_norm)
  preds = preds*(max(test$tch)-min(test$tch)) + min(test$tch)
  mae_grau = calc_mae(test$tch,preds)
  mae_varia_grau = c(mae_varia_grau,mae_grau)
}
mae_varia_grau

formula_tune = data.frame(formulas = as.character(c('tch~estagio+ppt_iii',
                              'tch~estagio+ppt_iii+lstd_iii',
                              'tch~estagio+ppt_ii+lstd_ii+lstn_i+lstd_iii',
                              'tch~.')),
                          mae=NA,stringsAsFactors = F)
for(i in 1:nrow(formula_tune)){
  mod = lm(formula_tune$formulas[i],train_norm)
  preds = predict(mod,test_norm)
  preds = preds*(max(test$tch)-min(test$tch)) + min(test$tch)
  formula_tune$mae[i] = calc_mae(test$tch,preds)
}
formula_tune

