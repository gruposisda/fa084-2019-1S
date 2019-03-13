#visualizacao/explicacao do conjunto de dados
library(ggplot2)
library(readxl)

#df vs tibble
df = read.csv('~/data/fa084/03_regressao_linear/data/fa084_tch_mult.csv')
tib = read_xlsx('~/data/fa084/03_regressao_linear/data/fa084_dados_cana_acucar.xlsx')
dim(df)
head(df)
colnames(df)

#df = select(df,contains('_i'),estagio,variedade, solo, espac, tch)
#write.csv(df,'~/data/fa084/03_regressao_linear/data/fa084_tch_mult.csv',row.names =F)

#remover features
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

#construir features #deixar eles fazerem
#total de ppt do periodo todo
colnames(df)
df$ppt_total = df$ppt_i + df$ppt_ii + df$ppt_iii

#temperatura media do periodo todo
colnames(df)
df$temp_media_total = (df$lstd_i + df$lstd_ii + df$lstd_iii)/3

#Normalizacao
#sorteia quem escolhe
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

#verificar que os graficos no comeco nao mudam

#separar treino e teste
dim(norm_df)
set.seed(42)
test_rows = sample(nrow(df),0.25*nrow(df))

test = df[test_rows,]
train = df[-test_rows,]

test_norm = norm_df[test_rows,]
train_norm = norm_df[-test_rows]
colnames(train)

#modelo
model = lm(tch~.,train_norm %>% select(-ppt_total))
model$coefficients

preds = predict(model,test_norm)
preds 
#desnormaliza
preds = preds * (max(test$tch)-min(test$tch)) + min(test$tch)
preds

calc_mae(test$tch,preds)

summary(model)
sort((model$coefficients))


#funcao para calcular o mae
calc_mae = function(real,preds){
  mean(abs(real - preds))
}

#loop para variar o grau
#o que podemos variar?
# grau do polinomio
graus = c(2,3,4)
mae_varia_grau = numeric()

for(grau in graus){
  mod = lm(tch~poly(estagio,grau),train)
  preds = predict(mod,test)
  mae_grau = calc_mae(test$tch,train)
  mae_varia_grau = c(mae_varia_grau,mae_grau)
}



# features na formula
# dataframe com diferentes graus e formulas
formulas = c('tch~estagio','tch~estagio+ppt_i')




#features numericos ainda


