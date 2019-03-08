
adjr2 = function(ypred, yobs, p, n){
  r2 = cor(ypred, yobs)^2
  ar2 = r2 - (1 - r2)*p/(n - p -1)
  return(ar2)
}

frmse = function(yped, yobs) {
##################################################
####### PREENCHA AQUI A FUNCAO PARA RMSE #########
##################################################
  return(rmse)
}
