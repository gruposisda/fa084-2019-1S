#install.packages('neuralnet')
library(neuralnet)
library(NeuralNetTools)
library(caret)

library(devtools)
source_url('https://gist.githubusercontent.com/fawda123/7471137/raw/466c1474d0a505ff044412703516c34f1a4684a5/nnet_plot_update.r')
source_url('https://gist.github.com/fawda123/6206737/raw/2e1bc9cbc48d1a56d2a79dd1d33f414213f5f1b1/gar_fun.r')
 
# creating training data set
TKS=c(20,10,30,20,80,30)
CSS=c(90,20,40,50,50,80)
Placed=c(1,0,0,0,1,1)
# Here, you will combine multiple columns or features into a single set of data
df=data.frame(TKS,CSS,Placed)
df

# fit neural network
nn=neuralnet(Placed~TKS+CSS,data=df, hidden=3,act.fct = "logistic",
             linear.output = FALSE)


TKS=c(30,40,85)
CSS=c(85,50,40)
test=data.frame(TKS,CSS)

Predict=neuralnet::compute(nn,test)
Predict$net.result

plot(nn)
plotnet(nn)
nn$weights

olden(nn)

# dividend info -----------------------------------------------------------
setwd('~/repos/fa084-2019-1S/10_neural_networks/')
df = read.csv('../data/dividendinfo.csv')

normalize = function(x) {
  return ((x - min(x)) / (max(x) - min(x)))
}

normdf = as.data.frame(lapply(df, normalize))
head(normdf)


# Training and Test Data
trainset = normdf[1:160, ]
testset = normdf[161:200, ]

nn = neuralnet(dividend ~ fcfps + earnings_growth + de + mcap + current_ratio, data=trainset, hidden=c(2,1), linear.output=FALSE, threshold=0.01)
plot(nn)
plotnet(nn)
nn$weights

olden(nn)


#Test the resulting output
temp_test = subset(testset, select = c("fcfps","earnings_growth", "de", "mcap", "current_ratio"))
head(temp_test)
nn.results = neuralnet::compute(nn, temp_test)
results = data.frame(actual = testset$dividend, prediction = nn.results$net.result)
results
results$prediction = round(results$prediction,digits = 0)
table(actual = results$actual,predicted = results$prediction)

# using caret -------------------------------------------------------------
# an old friend
library(tidyverse)
titanic_df = read_csv('../data/mod_titanic.csv') %>% select(-PassengerId)
head(titanic_df)

normdf = as.data.frame(lapply(titanic_df, normalize))
head(normdf)

test_rows = sample(nrow(normdf),0.2*nrow(normdf))
train = normdf[-test_rows,]
test = normdf[test_rows,]

nn = neuralnet(Survived ~ ., data=train, hidden=c(2,1), linear.output=FALSE, threshold=0.01)
plot(nn)
plotnet(nn)
nn$weights
olden(nn)

nn.results = neuralnet::compute(nn,test)
results = data.frame(actual = test$Survived, prediction = nn.results$net.result)
#results
results$prediction = round(results$prediction,digits = 0)
table(actual = results$actual,predicted = results$prediction)


data(iris)
TrainData = iris[,1:4]
TrainClasses = iris[,5]
 
nnetFit = train(as.factor(Survived) ~ ., data=train,
                 method = "nnet",hidden=c(2,1), act.fct='logistic', threshold=0.01)
 
nncaret = nnetFit$finalModel
olden(nncaret)
plotnet(nncaret)
nncaret$wts


nn.results = predict(nnetFit,test)
results = data.frame(actual = test$Survived, prediction = nn.results)
#results
#results$prediction = round(results$prediction,digits = 0)
table(actual = results$actual,predicted = results$prediction)
