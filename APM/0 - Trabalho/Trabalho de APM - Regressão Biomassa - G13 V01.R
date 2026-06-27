#' ---
#' titlte: ""
#' author: ""
#' date: ""
#' ---
#########################################
#                                       #
#     Trabalho de APM - T.2026 G13      #
#                                       #
#          Regressão Biomassa           #
#                                       #
#########################################
#       CRISTIANO JOSE DA SILVA         #
#    FRANCISCO DE ASSIS DE LIMA FILHO   #
#          JOSÉ PRADO LEITÃO            #
# MARLON MENDONÇA PEDERSOLI DE OLIVEIRA #
#    PEDRO BELLE MAGALHÃES DE CASTRO    #
#            RENATO MARTINS             #
#########################################



#install.packages("this.path")
library(this.path)
setwd(this.path::here())

### Instalação dos pacotes necessários
#install.packages("caret")
#install.packages("e1071")
library(caret)

### Pacote para cálculo das métricas (rmse)
#install.packages("Metrics")
library(Metrics)

##################
# Macro definições
##################
mySEED<-202613

DF_CSV<-"Biomassa - Dados.csv"
DF_NOVOS_CASOS<-"Biomassa - Novos Casos.csv"
CSV_NOVA_PRED <- "resultado_predicao_biomassa.csv"
DEL_COLUNA<-""
TARGET<-"biomassa"

TARGET_TIL <- as.formula(paste(TARGET, "~ ."))
resultados <- list()

CTRL_CV <- trainControl(method = "cv", number = 5)

##################
# Funções locais #
##################

# Função para avaliar, salvar e mostrar metricas
avaliar_modelo <- function(nome, modelo, teste, y_teste) {
  
  y_pred <- predict(modelo, teste)
  
  # Calcula RMSE
  rmse_calc <- rmse(y_teste, y_pred)
  
  # Calcula R2
  r2 <- R2(y_pred, y_teste)
  
  ### obtem os parametros ###
  param_str <- paste(
    names(modelo$bestTune),
    unlist(modelo$bestTune),
    sep = "=",
    collapse = " "
  )
  
 list_resultado <<- list(
    nome = nome,
    parametro = param_str,
    modelo = modelo,
    r2 = round(r2, 2),
    Syx = round(sd(y_teste - y_pred), 2),
    Pearson = round(cor(y_teste, y_pred), 2),
    rmse = round(rmse_calc,2),
    MAE = round(mae(y_teste, y_pred),2)
  )
  
 return(list_resultado)

}

######################################

### Obter os dados
dados <- read.csv(DF_CSV)
#View(dados)

### Retira coluna desnecessaria
dados[[DEL_COLUNA]] <- NULL

### Criar bases de Treino e Teste
set.seed(mySEED)
indices <- createDataPartition(dados[[TARGET]], p=0.80,list=FALSE)
treino <- dados[indices,]
teste <- dados[-indices,]

y_teste <-teste[[TARGET]]

#######
# KNN #
#######
cat("\n","Processando KNN")

### Treina o modelo e faz um search grid para o valor de K

tuneGrid <- expand.grid(k = c(1,3,5,7,9))

set.seed(mySEED)

modelo <- train(TARGET_TIL, 
                data = treino, 
                method = "knn",
                preProcess = c("center", "scale"),
                trControl = CTRL_CV,
                tuneGrid=tuneGrid)

### Verifica o resultado do Treinamento
print(modelo)

### Faz a predição e mostra a matriz de confusão
resultados[[length(resultados)+1]] <- avaliar_modelo("KNN", modelo,
                                                     teste, y_teste)

################
# RNA Hold-out #
################
cat("\n", "Processando RNA com Hold-out")

### Treina o modelo e faz um search grid para o valor de size e decay
tuneGrid = expand.grid(
  size = c(10, 30),
  decay = c(0.01, 0.1)
)

set.seed(mySEED)

modelo <- train(
  form = TARGET_TIL ,
  data = treino ,
  method = "nnet",
  linout = TRUE,
  preProcess = c("center", "scale"),
  tuneGrid = tuneGrid ,
  maxit = 300,
  trace=FALSE)

### Verifica o resultado do Treinamento
print(modelo)

### Faz a predição e mostra a matriz de confusão
resultados[[length(resultados)+1]] <-avaliar_modelo("RNA Hold-out", modelo,
                                                    teste, y_teste)


########################
# RNA Cross Validation #
########################
cat("\n","Processando RNA com Cross Validation")

### Treina o modelo e faz um search grid para o valor de size e decay
tuneGrid = expand.grid(
  size = c(10, 30),
  decay = c(0.01, 0.1)
)

set.seed(mySEED)

modelo <- train(
  form = TARGET_TIL ,
  data = treino ,
  method = "nnet" ,
  linout = TRUE,
  preProcess = c("center", "scale"),
  tuneGrid = tuneGrid ,
  maxit = 300,
  trace=FALSE,
  trControl = CTRL_CV)

### Verifica o resultado do Treinamento
print(modelo)

### Faz a predição e mostra a matriz de confusão
resultados[[length(resultados)+1]] <-avaliar_modelo("RNA Cross Validation",
                                                    modelo, teste, y_teste)

################
# SVM Hold-out #
################
cat("\n","Processando SVM com Hold-out")

### Treina o modelo e faz um search grid para o valor de Custo e Sigma
tuneGrid = expand.grid(C=c(10, 50, 100), 
                       sigma=c(0.01, 0.015, 0.02))

set.seed(mySEED)

modelo <- train(
  form = TARGET_TIL ,
  data = treino ,
  method = "svmRadial" ,
  preProcess = c("center", "scale"),
  tuneGrid = tuneGrid
)

### Verifica o resultado do Treinamento
print(modelo)

### Faz a predição e mostra a matriz de confusão
resultados[[length(resultados)+1]] <- avaliar_modelo("SVM Hold-out", modelo,
                                                     teste, y_teste)

########################
# SVM Cross-Validation #
########################
cat("\n","Processando SVM com Cross Validation")

### Treina o modelo e faz um search grid para o valor de Custo e Sigma

tuneGrid = expand.grid(C=c(10, 50, 100), 
                   sigma=c(0.01, 0.015, 0.02))
set.seed(mySEED)

modelo <- train(
  form = TARGET_TIL ,
  data = treino ,
  method = "svmRadial" ,
  preProcess = c("center", "scale"),
  tuneGrid = tuneGrid ,
  trControl = CTRL_CV)

### Verifica o resultado do Treinamento
print(modelo)

### Faz a predição e mostra a matriz de confusão
resultados[[length(resultados)+1]] <- avaliar_modelo("SVM Cross-Validation",
                                                     modelo, teste, y_teste)

##########################
# Random Forest Hold-out #
##########################
cat("\n","Processando Random Forest com Hold-out")

### Treina o modelo
set.seed(mySEED)



modelo <- train(
  form = TARGET_TIL ,
  data = treino ,
  method = "rf"
  )

### Verifica o resultado do Treinamento
print(modelo)

### Faz a predição e mostra a matriz de confusão
resultados[[length(resultados)+1]] <- avaliar_modelo("RF Hold-out", modelo,
                                                     teste, y_teste)

##################################
# Random Forest Cross-Validation #
##################################
cat("\n","Processando Random Forest com Cross Validation")

### Treina o modelo
set.seed(mySEED)

modelo <- train(
  form = TARGET_TIL ,
  data = treino ,
  method = "rf" ,
  trControl = CTRL_CV
)

### Verifica o resultado do Treinamento
print(modelo)

### Faz a predição e mostra a matriz de confusão
resultados[[length(resultados)+1]] <- avaliar_modelo("RF Cross-Validation",
                                                     modelo, teste, y_teste)

##########################
# Escolhe melhor modelo #
##########################

### montar o ranking dos modelos ###
ranking <- data.frame(
  Modelo = sapply(resultados, function(x) x$nome),
  Parametro = sapply(resultados, function(x) x$parametro),
  R2 = sapply(resultados, function(x) x$r2),
  Syx = sapply(resultados, function(x) x$Syx),
  Pearson = sapply(resultados, function(x) x$Pearson),
  RMSE = sapply(resultados, function(x) x$rmse),
  MAE = sapply(resultados, function(x) x$MAE)  )


ranking <- ranking[
  order(ranking$R2, decreasing = TRUE),
]

cat("# - Tecnica - Parametro - R2 - Syx - Pearson - RMSE - MAE","\n")

## exibir na ordem de classificação ##
for(i in seq_len(nrow(ranking))) {
  cat(
    i, "o", 
    ranking$Modelo[i],
    "-",
    ranking$Parametro[i],
    "-",
    ranking$R2[i],
    "-",
    ranking$Syx[i],
    "-",
    ranking$Pearson[i],
    "-",
    ranking$RMSE[i],
    "-",
    ranking$MAE[i],
    "\n"
  )
}

## Fazer predição com o melhor modelo ##
metricas <- sapply(resultados, function(x) x$r2)

melhor_indice <- which.max(metricas)

melhor_modelo <- resultados[[melhor_indice]]$modelo

cat("Melhor modelo:", resultados[[melhor_indice]]$nome, "\n")
cat("R2:", resultados[[melhor_indice]]$r2, "\n")

### PREDIÇÕES DE NOVOS CASOS
dados_novos_casos <- read.csv(DF_NOVOS_CASOS)

#View(dados_novos_casos)
predict.melhor_modelo <- round(predict(melhor_modelo, dados_novos_casos),2)

resultado_melhor_modelo <- cbind(dados_novos_casos, predict.melhor_modelo)

View(resultado_melhor_modelo)

#salva em um arquivo csv
write.csv(resultado_melhor_modelo, CSV_NOVA_PRED,
          row.names=FALSE)

# Grafico de residuos
y_pred = predict(melhor_modelo, newdata = teste)
residuos = y_teste - y_pred

plot(
  y_pred,
  residuos,
  xlab = "Predito",
  ylab = "Resíduo",
  main = "Resíduos"
)

abline(h = 0, lty = 2)

