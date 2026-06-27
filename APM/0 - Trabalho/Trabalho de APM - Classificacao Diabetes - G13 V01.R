#' ---
#' titlte: ""
#' author: ""
#' date: ""
#' ---
#########################################
#                                       #
#     Trabalho de APM - T.2026 G13      #
#                                       #
#        Classificacao Diabetes         #
#                                       #
#########################################
#       CRISTIANO JOSE DA SILVA         #
#    FRANCISCO DE ASSIS DE LIMA FILHO   #
#          JOSE PRADO LEITAO            #
# MARLON MENDONCA PEDERSOLI DE OLIVEIRA #
#    PEDRO BELLE MAGALHAES DE CASTRO    #
#            RENATO MARTINS             #
#########################################



#install.packages("this.path")
library(this.path)
setwd(this.path::here())

### Instalação dos pacotes necessários
#install.packages("caret")
#install.packages("e1071")
library(caret)


##################
# Macro definições
##################
mySEED<-202613

DF_CSV<-"Diabetes - Dados.csv"
DF_NOVOS_CASOS<-"Diabetes - Novos Casos.csv"
CSV_NOVA_PRED <- "resultado_predicao_diabetes.csv"
DEL_COLUNA<-"num"
TARGET<-"diabetes"

TARGET_TIL <- as.formula(paste(TARGET, "~ ."))
resultados <- list()

CTRL_CV <- trainControl(method = "cv", number = 5)

##################
# Funcoes locais #
##################

# Funcao para avaliar, salvar os dados
avaliar_modelo <- function(nome, modelo, teste, y_teste) {
  y_pred <- predict(modelo, teste)
  
  cm <- confusionMatrix(y_pred, y_teste)
  
  ### obtem os parametros ###
  param_str <- paste(
    names(modelo$bestTune),
    unlist(modelo$bestTune),
    sep = "=",
    collapse = " "
  )
  
  list_resultado <- list(
    nome = nome,
    parametro = param_str,
    modelo = modelo,
    acuracia = round(cm$overall["Accuracy"],2),
    cm = cm
  )
  
  #print(cm$table)
  
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
indices <- createDataPartition(dados[[TARGET]], p = 0.80, list = FALSE)
treino <- dados[indices, ]
teste <- dados[-indices, ]

y_teste <- as.factor(teste[[TARGET]])

#######
# KNN #
#######
cat("\n","Processando KNN")

### Treina o modelo e faz um search grid para o valor de K

tuneGrid <- expand.grid(k = c(1, 3, 5, 7, 9))

set.seed(mySEED)

modelo <- train(
  TARGET_TIL,
  data = treino,
  method = "knn",
  preProcess = c("center", "scale"),
  tuneGrid = tuneGrid
)

### Verifica o resultado do Treinamento
print(modelo)

### Faz a predicao e mostra a matriz de confusao
resultados[[length(resultados) + 1]] <- avaliar_modelo("KNN", modelo, teste, y_teste)

################
# RNA Hold-out #
################
cat("\n", "Processando RNA com Hold-out")

### Treina o modelo e faz um search grid para o valor de size e decay
tuneGrid = expand.grid(size = c(10, 30), decay = c(0.01, 0.1))

set.seed(mySEED)

modelo <- train(
  form = TARGET_TIL ,
  data = treino ,
  method = "nnet" ,
  preProcess = c("center", "scale"),
  tuneGrid = tuneGrid ,
  maxit = 300,
  trace = FALSE
)

### Verifica o resultado do Treinamento
print(modelo)

### Faz a predicao e mostra a matriz de confusao
resultados[[length(resultados) + 1]] <- avaliar_modelo("RNA Hold-out", 
                                                       modelo, teste, y_teste)


########################
# RNA Cross Validation #
########################
cat("\n","Processando RNA com Cross Validation")

### Treina o modelo e faz um search grid para o valor de size e decay
tuneGrid = expand.grid(size = c(10, 30), decay = c(0.01, 0.1))

set.seed(mySEED)

modelo <- train(
  form = TARGET_TIL ,
  data = treino ,
  method = "nnet" ,
  preProcess = c("center", "scale"),
  tuneGrid = tuneGrid ,
  maxit = 300,
  trace = FALSE,
  trControl = CTRL_CV
)

### Verifica o resultado do Treinamento
print(modelo)

### Faz a predicao e mostra a matriz de confusao
resultados[[length(resultados) + 1]] <- avaliar_modelo("RNA Cross Validation",
                                                       modelo, teste, y_teste)

################
# SVM Hold-out #
################
cat("\n","Processando SVM com Hold-out")

### Treina o modelo e faz um search grid para o valor de Custo e Sigma
tuneGrid = expand.grid(C = c(10, 50, 100), sigma = c(0.01, 0.015, 0.02))

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

### Faz a predicao e mostra a matriz de confusao
resultados[[length(resultados) + 1]] <- avaliar_modelo("SVM Hold-out", modelo,
                                                       teste, y_teste)

########################
# SVM Cross-Validation #
########################
cat("\n","Processando SVM com Cross Validation")

### Treina o modelo e faz um search grid para o valor de Custo e Sigma

tuneGrid = expand.grid(C = c(10, 50, 100), sigma = c(0.01, 0.015, 0.02))
set.seed(mySEED)

modelo <- train(
  form = TARGET_TIL ,
  data = treino ,
  method = "svmRadial" ,
  preProcess = c("center", "scale"),
  tuneGrid = tuneGrid ,
  trControl = CTRL_CV
)

### Verifica o resultado do Treinamento
print(modelo)

### Faz a predicao e mostra a matriz de confusao
resultados[[length(resultados) + 1]] <- avaliar_modelo("SVM Cross-Validation", 
                                                       modelo, teste, y_teste)

##########################
# Random Forest Hold-out #
##########################
cat("\n","Processando Random Forest com Hold-out")

### Treina o modelo
set.seed(mySEED)

modelo <- train(form = TARGET_TIL ,
                data = treino ,
                method = "rf")

### Verifica o resultado do Treinamento
print(modelo)

### Faz a predicao e mostra a matriz de confusao
resultados[[length(resultados) + 1]] <- avaliar_modelo("RF Hold-out", modelo, 
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

### Faz a predicao e mostra a matriz de confusao
resultados[[length(resultados) + 1]] <- avaliar_modelo("RF Cross-Validation",
                                                       modelo, teste, y_teste)

##########################
# Escolhe melhor modelo #
##########################

### montar o ranking dos modelos ###
ranking <- data.frame(
  Modelo = sapply(resultados, function(x)
    x$nome),
  Parametro = sapply(resultados, function(x)
    x$parametro),
  Acuracia = as.numeric(sapply(resultados, function(x)
    x$acuracia))
)

ranking <- ranking[order(ranking$Acuracia, decreasing = TRUE), ]


## exibir na ordem de classificacao ##
for (i in seq_len(nrow(ranking))) {
  cat(
    i,
    "o", "\n",
    "Tecnica: ",
    ranking$Modelo[i], "\n",
    "Parametro: ",
    ranking$Parametro[i], "\n",
    "Acuracia: ",
    round(ranking$Acuracia[i], 4),"\n",
    "Matriz de Confusao:", "\n")
  print(resultados[[i]]$cm$table)
  cat('------', "\n", "\n")
    
}

## Fazer predicao com o melhor modelo ##
metricas <- sapply(resultados, function(x)
  x$acuracia)

melhor_indice <- which.max(metricas)

melhor_modelo <- resultados[[melhor_indice]]$modelo

cat("Melhor modelo:", resultados[[melhor_indice]]$nome, "\n")
cat("Acuracia:", resultados[[melhor_indice]]$acuracia, "\n")

### PREDICOES DE NOVOS CASOS
dados_novos_casos <- read.csv(DF_NOVOS_CASOS)

#View(dados_novos_casos)
predict.melhor_modelo <- predict(melhor_modelo, dados_novos_casos)

resultado_melhor_modelo <- cbind(dados_novos_casos, predict.melhor_modelo)

View(resultado_melhor_modelo)

#salva em um arquivo csv
write.csv(resultado_melhor_modelo, CSV_NOVA_PRED,
          row.names=FALSE)

