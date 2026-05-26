###############################################################################
#             Unidade 2: Modelos de regularizacao ou penalidade               #
#                         Secao 2.2: Regressao Ridge                          # 
###############################################################################

# Vamos evitar a notacao cientifica nos resultados
options(scipen = 999)

## Instala pacotes necessários (instala apenas os ausentes, sem prompt)
required_pkgs <- c("yarrr", "plyr", "readr", "dplyr", "caret", "ggplot2", "repr", "glmnet", "fastDummies", "tidyverse")
install_if_missing <- function(pkgs) {
  missing <- pkgs[!sapply(pkgs, requireNamespace, quietly = TRUE)]
  if(length(missing)) install.packages(missing, repos = "https://cloud.r-project.org")
}
install_if_missing(required_pkgs)

# Carregando os pacotes necessarios
library(plyr)
library(readr)
library(dplyr)
library(caret)
library(ggplot2)
library(repr)
library(glmnet)

# Carrega o arquivo .RData e atribui o primeiro objeto carregado a 'dat'
loaded_names <- load("trabalhosalarios.RData")
dat <- get(loaded_names[1])
# Mostrar quais objetos foram carregados (debug)
print(loaded_names)

View(dat)

# Vamos visualizar parte do dataset
glimpse(dat)

# Checar valores faltantes no dataset 'dat'
na_count <- sum(is.na(dat))

if (na_count > 0) {
  cat("Há", na_count, "valores faltantes\n")
  # Contagem de NA por coluna
  print(sapply(dat, function(x) sum(is.na(x))))
} else {
  cat("Não há valores faltantes\n")
}


library(fastDummies)

# Transformando colunas  em variaveis dummy (categóricas) 

#1. Transformar em colunas dummies ( “quebrar” a categoria em números 0/1 para o modelo enxergar.)
#Finalidade:
#deixar a variável utilizável por modelos que só aceitam números, como glmnet;
#evitar dar uma ordem falsa para categorias;
#representar cada categoria separadamente no modelo.

#2. Transformar em factor (usado no ElasticNet)
#informar ao R/caret que a variável é qualitativa;
#fazer com que a interface por fórmula trate essa coluna como categoria e gere a codificação apropriada internamente;
#preservar o significado categórico durante o ajuste, especialmente quando você usa train(..., method = "glmnet") com fórmula.

dat <- dummy_cols(dat, select_columns = c("husunion", "husblck", "hushisp", "kidge6", "black", "hispanic", "union", "kidlt6"), 
                  remove_most_frequent_dummy=FALSE, 
                  remove_selected_columns=TRUE)
str(dat)

# As colunas dummy precisam continuar numericas para o glmnet.
str(dat)


# Vamos jogar a semente para gerar numeros aleatorios
# Aqui no exemplo a semente eh "5", mas poderia
# ser qualquer outro numero, se todos usarem a mesma
# semente os resultados serao iguais.
# Essa semente de numeros aleatorios serve para
# particionar o dataset aleatoriamente
set.seed(5)  

# Vamos criar um indice para particionar o dataset em
# 50% para treinamento
index = sample(1:nrow(dat),0.5*nrow(dat))

# Vamos criar a base de dados de treinamento
train = dat[index,]  

# Vamos criar a base de dados de teste
test = dat[-index,] 

# Vamos checar as dimensoes das bases de treinamento e 
# teste
dim(train)
dim(test)
# A base de treinamento possui 75 linhas e 
# 10 colunas (variaveis)
# A base de teste possui 75 linhas e 10
# colunas (variaveis)

# Mostra um boxplot por variável para comparar escalas
# Facilita pra decidir se é necessário padronizar as variáveis

# Do enunciado, a variável dependente é "lwage" (log do salário), ou seja, já está padronizada

# Amplia só um pouco o tamanho do gráfico na saída do notebook
options(repr.plot.width = 9, repr.plot.height = 7)

train[, c("husage", "husearns", "huseduc", "hushrs", "earns", "age", "educ", "exper", "lwage")] %>%  # escolhe colunas
  stack() %>%  # coloca em formato longo (variável/valor)
  ggplot(aes(x = ind, y = values)) +  # inicia o gráfico
  geom_boxplot(fill = "steelblue", alpha = 0.7, width = 0.15, linewidth = 0.3, outlier.size = 0.3) +  # desenha boxplots
  labs(x = "Variável", y = "Valor") +  # rótulos dos eixos
  theme_bw(base_size = 13) +
  theme(
    axis.line = element_line(color = "black"),
    panel.grid.major = element_line(color = "grey70", linewidth = 0.6),
    panel.grid.minor = element_line(color = "grey85", linewidth = 0.35)
  )

# Padronizando com z-score apenas os preditores numéricos: husage, husearns, huseduc, hushrs, earns, age, educ, exper.

# incluir lwage na padronização?
# se padronizar , lembrar de no final despadronizar e fazer exp(lwage)
cols <- c("husage", "husearns", "huseduc", "hushrs", "earns", "age", "educ", "exper", "lwage")
pre_proc_val <- caret::preProcess(train[,cols], 
                                  method = c("center", "scale")) # calcula média e desvio-padrão para cada coluna selecionada.

train1 <- train # necessário para criar uma cópia do dataset original e aplicar a padronização apenas nas colunas selecionadas, mantendo as outras colunas inalteradas.
train1[,cols] <- predict(pre_proc_val, train[,cols]) # realiza a padronização de fato nas colunas selecionadas

View(train1)

# Verificando os boxplots após a padronização, para confirmar que as variáveis numéricas estão na mesma escala.

# Amplia só um pouco o tamanho do gráfico na saída do notebook
options(repr.plot.width = 12, repr.plot.height = 7)

train1[, c("husage", "husearns", "huseduc", "hushrs", "earns", "age", "educ", "exper", "lwage")] %>%  # escolhe colunas
  stack() %>%  # coloca em formato longo (variável/valor)
  ggplot(aes(x = ind, y = values)) +  # inicia o gráfico com um único eixo x e um único eixo y
  geom_boxplot(fill = "steelblue", alpha = 0.7, width = 0.55, linewidth = 0.3, outlier.size = 0.3) +  # desenha boxplots
  labs(x = "Variável", y = "Valor padronizado (z-score)") +  # rótulos dos eixos
  theme_minimal(base_size = 13) +
  theme(
    panel.grid.major = element_line(color = "grey85", linewidth = 0.4),
    panel.grid.minor = element_line(color = "grey92", linewidth = 0.25)
  )

# Padronizando a base de teste usando os parâmetros calculados na base de treino
test1 <- test
test1[,cols] <- predict(pre_proc_val, test[,cols]) # aplica centro e escala calculados em 'train'


View(test1)

# Verificando os boxplots após a padronização, para confirmar que as variáveis numéricas estão na mesma escala.

# Amplia só um pouco o tamanho do gráfico na saída do notebook
options(repr.plot.width = 12, repr.plot.height = 7)

test1[, c("husage", "husearns", "huseduc", "hushrs", "earns", "age", "educ", "exper", "lwage")] %>%  # escolhe colunas
  stack() %>%  # coloca em formato longo (variável/valor)
  ggplot(aes(x = ind, y = values)) +  # inicia o gráfico com um único eixo x e um único eixo y
  geom_boxplot(fill = "steelblue", alpha = 0.7, width = 0.55, linewidth = 0.3, outlier.size = 0.3) +  # desenha boxplots
  labs(x = "Variável", y = "Valor padronizado (z-score)") +  # rótulos dos eixos
  theme_bw(base_size = 13) +
  theme(
    axis.line = element_line(color = "black"),
    panel.grid.major = element_line(color = "grey70", linewidth = 0.6),
    panel.grid.minor = element_line(color = "grey85", linewidth = 0.35)
  )

###############################################################################
#                               REGRESSAO RIDGE                               #
###############################################################################

# A regressao Ridge "encolhe os valores dos coeficientes"

# Vamos guardar a matriz de dados de treinamento das 
# variaveis explicativas para o modelo em um objeto 
# chamado "x"
library(dplyr)

View(train1)

# reordenando o dataset porque a coluna "lwage" esta no meio do dataset
train1 <- train1 %>% select(lwage, everything()) # train1 é a base de treino padronizada
View(train1)


# Guardando os valores das variáveis explicativas em 'x'
# colunas 2 a última de train1 convertidas para uma matriz: é a matriz de preditores
x <- as.matrix(train1[,2:ncol(train1)])
ncol(train1)
View(x)

# Vamos guardar o vetor de dados de treinamento da 
# variavel dependente para o modelo em um objeto
# chamado "y_train"
y_train = train1$lwage
View(y_train)

# reordenando o dataset porque a coluna "lwage" esta no meio do dataset
test1 <- test1 %>% select(lwage, everything()) # teste1 é a base de teste padronizada
View(test1)

# Vamos guardar a matriz de dados de teste das variaveis
# explicativas para o modelo em um objeto chamado
# "x_test"
x_test = as.matrix(test1[,2:ncol(test1)]) # test1 é a base de teste padronizada
ncol(test1)
View(x_test)

# Vamos guardar o vetor de dados de teste da variavel
# dependente para o modelo em um objeto chamado "y_test"
y_test = test1$lwage

# Vamos calcular o valor otimo de lambda; 
# alpha = "0", eh para regressao Ridge
# Vamos testar os lambdas de 10^-3 ate 10^2, a cada 0.1
lambdas <- 10^seq(2, -3, by = -.1)
# Calculando o lambda:
ridge_lamb <- cv.glmnet(x, y_train, alpha = 0, # cross-validation para encontrar o melhor lambda
                        lambda = lambdas, standardize = FALSE) #standardize = TRUE por padrão, mas já padronizamos manualmente
# Vamos ver qual o lambda otimo 
best_lambda_ridge <- ridge_lamb$lambda.min
best_lambda_ridge

# Estimando o modelo Ridge
ridge_reg = glmnet(x, y_train, alpha = 0, 
                   family = 'gaussian', 
                   lambda = best_lambda_ridge,
                   standardize = FALSE) #standardize = TRUE por padrão, mas já padronizamos manualmente

# Vamos ver o resultado (valores) da estimativa 
# (coeficientes)
ridge_reg[["beta"]]

# Vamos calcular o R^2 dos valores verdadeiros e 
# preditos conforme a seguinte funcao:
eval_results <- function(true, predicted, df) {
  SSE <- sum((predicted - true)^2)
  SST <- sum((true - mean(true))^2)
  R_square <- 1 - SSE / SST
  RMSE = sqrt(SSE/nrow(df))
  
  # As metricas de performace do modelo:
  data.frame(
    RMSE = RMSE,
    Rsquare = R_square
  )
}

# Predicao e avaliacao nos dados de treinamento:
predictions_train <- predict(ridge_reg, # modelo estimado
                             s = best_lambda_ridge,
                             newx = x)



# As metricas da base de treinamento sao:
ridge_result_train <- eval_results(y_train, predictions_train, train1)
ridge_result_train

# Predicao e avaliacao nos dados de teste:
predictions_test <- predict(ridge_reg, 
                            s = best_lambda_ridge, 
                            newx = x_test)


# As metricas da base de teste sao:
ridge_result_test <- eval_results(y_test, predictions_test, test1)
ridge_result_test
# Se compararmos as metricas de treinamento e teste
# vemos que o tamanho dos erros de treinamento e teste
# e os R^2 sao parecidos, o que descarta a hipotese
# de overfitting e underfitting. 

# Como os valores do dataset sao padronizados, nos temos
# de padronizar tambem os dados que vamos fazer a predicao.
# Note que as variaveis dummies nao devem ser padronizadas.

# Valores fornecidos no enunciado
husage <- 40
husunion <- 0
husearns <- 600
huseduc <- 13
husblck <- 1
hushisp <- 0
hushrs <- 40
kidge6 <- 1
# 'earns' usará a média da variável 'earns' na base de treinamento,
# já que não foi fornecido um valor específico para essa variável no enunciado.
# Autorizado via email do professor Razer, dia 5 de Abril
earns <- mean(train$earns)
age <- 38
black <- 0
educ <- 13
hispanic <- 1
union <- 0
exper <- 18
kidlt6 <- 1

## Padronizando usando os mesmos parametros da base de treino

# As variaveis numericas serao padronizadas com media e desvio da base de treino
# As variaveis dummy (0/1) serao mantidas sem padronizacao

# Dummies: manter como estao
# husunion, husblck, hushisp, kidge6, black, hispanic, union, kidlt6

# Montar data.frame com a mesma ordem e nomes das colunas usadas no treino
# (as dummies foram criadas com sufixo _0 e _1 pelo fastDummies)

our_pred = as.matrix(data.frame(
  husage = (husage - mean(train$husage)) / sd(train$husage),
  husearns = (husearns - mean(train$husearns)) / sd(train$husearns),
  huseduc = (huseduc - mean(train$huseduc)) / sd(train$huseduc),
  hushrs = (hushrs - mean(train$hushrs)) / sd(train$hushrs),
  earns = (earns - mean(train$earns)) / sd(train$earns),
  age = (age - mean(train$age)) / sd(train$age),
  educ = (educ - mean(train$educ)) / sd(train$educ),
  exper = (exper - mean(train$exper)) / sd(train$exper),
  husunion_0 = as.integer(husunion == 0),
  husunion_1 = as.integer(husunion == 1),
  husblck_0 = as.integer(husblck == 0),
  husblck_1 = as.integer(husblck == 1),
  hushisp_0 = as.integer(hushisp == 0),
  hushisp_1 = as.integer(hushisp == 1),
  kidge6_0 = as.integer(kidge6 == 0),
  kidge6_1 = as.integer(kidge6 == 1),
  black_0 = as.integer(black == 0),
  black_1 = as.integer(black == 1),
  hispanic_0 = as.integer(hispanic == 0),
  hispanic_1 = as.integer(hispanic == 1),
  union_0 = as.integer(union == 0),
  union_1 = as.integer(union == 1),
  kidlt6_0 = as.integer(kidlt6 == 0), # se kidlt6 eh 0, kidlt6_0 eh 1; se kidlt6 eh 1, kidlt6_0 eh 0
  kidlt6_1 = as.integer(kidlt6 == 1) # se kidlt6 eh 1, kidlt6_1 eh 1; caso contrario, eh 0
))


# Fazendo a predicao:
predict_our_ridge <- predict(ridge_reg, 
                             s = best_lambda_ridge, 
                             newx = our_pred)
# O resultado da predicao eh:
predict_our_ridge

# s=0.1 -> o valor de lambda usado na predição 
# valor (na escala padronizada) -> 0.2340868

# O resultado eh padronizado; primeiro voltamos para a escala de lwage
# e, como lwage ja eh o log do salario, aplicamos exp no final
lwage_pred_ridge_log <- (predict_our_ridge * sd(train$lwage) + mean(train$lwage))

# O resultado eh:
lwage_pred_ridge <- exp(lwage_pred_ridge_log)
lwage_pred_ridge
# Este eh o valor predito do salario nominal, segundo as caracteristicas que atribuimos


# O intervalo de confianca contra a base de treino (nao havia sido padronizada ainda)
n <- nrow(train) # tamanho da amostra
m <- lwage_pred_ridge_log # valor medio predito
s <- sd(train$lwage) # desvio padrao
dam <- s/sqrt(n) # erro padrão da media
CIlwr_ridge_log <- m + (qnorm(0.025))*dam # intervalo inferior
CIupr_ridge_log <- m - (qnorm(0.025))*dam # intervalo superior

# Os valores sao:
CIlwr_ridge <- exp(CIlwr_ridge_log)
CIupr_ridge <- exp(CIupr_ridge_log)

CIlwr_ridge
CIupr_ridge


# Resumo final do Ridge (treino e teste)
ridge_result_train
ridge_result_test

###############################################################################
#           Unidade 2: Modelos de regularizacao ou penalidade                 #
#                         Secao 2.3: Regressao Lasso                          #
###############################################################################

library(glmnet)
library(dplyr)

# Reutilizando os objetos criados na secao de Ridge:
# train, test, train1, test1
dim(train1)
dim(test1)

# Reordenando para manter a variavel resposta na 1a coluna
train1 <- train1 %>% select(lwage, everything())
View(train1)

# Matriz de preditores e vetor resposta da base de treino
x <- as.matrix(train1[, 2:ncol(train1)])
y_train <- train1$lwage

ncol(x)
length(y_train)

# Reordenando a base de teste no mesmo formato da base de treino
test1 <- test1 %>% select(lwage, everything())

# Matriz de preditores e vetor resposta da base de teste
x_test <- as.matrix(test1[, 2:ncol(test1)])
y_test <- test1$lwage

dim(x_test)
length(y_test)

# Busca do melhor lambda via validacao cruzada
lambdas <- 10^seq(2, -3, by = -0.1)

lasso_lamb <- cv.glmnet(
  x, y_train,
  alpha = 1,
  lambda = lambdas,
  standardize = FALSE
)

best_lambda_lasso <- lasso_lamb$lambda.min
best_lambda_lasso

# Estimando o modelo Lasso
lasso_reg <- glmnet(
  x, y_train,
  alpha = 1,
  family = "gaussian",
  lambda = best_lambda_lasso,
  standardize = FALSE
)

# Coeficientes estimados
lasso_reg[["beta"]]

# Predicoes e avaliacao nos dados de treinamento
predictions_train_lasso <- predict(
  lasso_reg,
  s = best_lambda_lasso,
  newx = x
)

lasso_result_train <- eval_results(y_train, predictions_train_lasso, train1)
lasso_result_train

# Predicoes e avaliacao nos dados de teste
predictions_test_lasso <- predict(
  lasso_reg,
  s = best_lambda_lasso,
  newx = x_test
)

lasso_result_test <- eval_results(y_test, predictions_test_lasso, test1)
lasso_result_test

# Vamos usar o mesmo perfil de predicao adotado na secao de Ridge
husage <- 40
husunion <- 0
husearns <- 600
huseduc <- 13
husblck <- 1
hushisp <- 0
hushrs <- 40
kidge6 <- 1
earns <- mean(train$earns)
age <- 38
black <- 0
educ <- 13
hispanic <- 1
union <- 0
exper <- 18
kidlt6 <- 1

# Monta a matriz de predicao com o mesmo padrao da Ridge
our_pred <- as.matrix(data.frame(
  husage = (husage - mean(train$husage)) / sd(train$husage),
  husearns = (husearns - mean(train$husearns)) / sd(train$husearns),
  huseduc = (huseduc - mean(train$huseduc)) / sd(train$huseduc),
  hushrs = (hushrs - mean(train$hushrs)) / sd(train$hushrs),
  earns = (earns - mean(train$earns)) / sd(train$earns),
  age = (age - mean(train$age)) / sd(train$age),
  educ = (educ - mean(train$educ)) / sd(train$educ),
  exper = (exper - mean(train$exper)) / sd(train$exper),
  husunion_0 = as.integer(husunion == 0),
  husunion_1 = as.integer(husunion == 1),
  husblck_0 = as.integer(husblck == 0),
  husblck_1 = as.integer(husblck == 1),
  hushisp_0 = as.integer(hushisp == 0),
  hushisp_1 = as.integer(hushisp == 1),
  kidge6_0 = as.integer(kidge6 == 0),
  kidge6_1 = as.integer(kidge6 == 1),
  black_0 = as.integer(black == 0),
  black_1 = as.integer(black == 1),
  hispanic_0 = as.integer(hispanic == 0),
  hispanic_1 = as.integer(hispanic == 1),
  union_0 = as.integer(union == 0),
  union_1 = as.integer(union == 1),
  kidlt6_0 = as.integer(kidlt6 == 0),
  kidlt6_1 = as.integer(kidlt6 == 1)
))



# Predicao com Lasso na escala padronizada de lwage
predict_our_lasso <- predict(
  lasso_reg,
  s = best_lambda_lasso,
  newx = our_pred
)
predict_our_lasso

# Convertendo para a escala original de salario
lwage_pred_lasso_log <- (predict_our_lasso * sd(train$lwage) + mean(train$lwage))
lwage_pred_lasso <- exp(lwage_pred_lasso_log)

lwage_pred_lasso

# Intervalo de confianca para o valor predito (via escala log)
n <- nrow(train)
m <- lwage_pred_lasso_log
s <- sd(train$lwage)
dam <- s / sqrt(n)

CIlwr_lasso_log <- m + (qnorm(0.025)) * dam
CIupr_lasso_log <- m - (qnorm(0.025)) * dam

CIlwr_lasso <- exp(CIlwr_lasso_log)
CIupr_lasso <- exp(CIupr_lasso_log)

CIlwr_lasso
CIupr_lasso

# Resumo final do Lasso (treino e teste)
lasso_result_train
lasso_result_test

###############################################################################
#            Unidade 2: Modelos de regularizacao ou penalidade                #
#                     Secao 2.4: Regressao ElasticNet                         # 
###############################################################################

# Carregando os pacotes necessarios
library(plyr)
library(readr)
library(dplyr)
library(ggplot2)
library(repr)
library(glmnet)
library(caret)

# Vamos reutilizar a mesma base de dados da Ridge/Lasso
# (objetos: dat, train, test, train1, test1)

# Vamos visualizar parte da base padronizada
glimpse(train1)

# As colunas dummy precisam continuar numericas para o glmnet.
str(train1)

# Vamos checar as dimensoes das bases de treinamento e teste
dim(train1)
dim(test1)

# As bases train1 e test1 ja estao padronizadas com os mesmos parametros
# da secao de Ridge/Lasso.

# Conferindo rapidamente as primeiras linhas
head(train1)

###############################################################################
#                              REGRESSAO ELASTICNET                           #
###############################################################################

# Elastic Net combina Ridge e Lasso e escolhe alpha e lambda por CV.

# Reordenando para manter a variavel resposta na 1a coluna
train1 <- train1 %>% select(lwage, everything())
test1 <- test1 %>% select(lwage, everything())

View(train1)

# Matriz de preditores e vetor resposta da base de treino
x <- as.matrix(train1[, 2:ncol(train1)])
y_train <- train1$lwage

# Matriz de preditores e vetor resposta da base de teste
x_test <- as.matrix(test1[, 2:ncol(test1)])
y_test <- test1$lwage

dim(x)
length(y_train)
dim(x_test)
length(y_test)

# Vamos configurar o treinamento do modelo por 
# cross validation, com 10 folders, 5 repeticoes
# e busca aleatoria dos componentes das amostras
# de treinamento, o "verboseIter" eh soh para 
# mostrar o processamento.

# por que aqui foi usado trainControl ao inves de cv.glmnet?
# trainControl (usado com caret::train) permite buscar simultaneamente por alpha e lambda usando CV configurável
#
# cv.glmnet: faz cross‑validation eficiente sobre a sequência de lambda gerada pelo glmnet, 
#mas não escolhe alpha automaticamente.

train_cont <- trainControl(method = "repeatedcv",
                           number = 10,
                           repeats = 5,
                           search = "random",
                           verboseIter = TRUE)

# Nos nao temos o parametro "alpha", porque a regressao
# ElasticNet vai encontra-lo automaticamente, cujo valor
# estara entre 0 e 1 (para Ridge ==> alpha = 0; e
# para Lasso ==> alpha = 1).
# O parametro "lambda" tambem eh escolhido por
# cross-validation

# Vamos treinar o modelo

# No glmnet puro, voce eh obrigado a escolher um alpha fixo (ex: 0.5)
# modelo_en <- glmnet(X, y, alpha = 0.5)
# O glmnet puro eh excelente quando voce ja sabe o valor de alpha que quer usar 
# (0 para Ridge, 1 para Lasso, ou um valor fixo como 0.5).
# Mas o ElasticNet exige encontrar o melhor equilibrio de 
# dois parametros ao mesmo tempo:
# o alpha (o mix entre Ridge/Lasso) e o lambda (o tamanho da multa).

elastic_reg <- train(
  x = x,
  y = y_train,
  method = "glmnet",
  tuneLength = 10,
  trControl = train_cont,
  standardize = FALSE
)


# O melhor parametro alpha escolhido eh:
elastic_reg$bestTune

# E os parametros sao:
elastic_reg[["finalModel"]][["beta"]]

# Vamos fazer as predicoes e avaliar a performance do
# modelo

# Vamos fazer as predicoes no modelo de treinamento:
predictions_train <- predict(elastic_reg, x)

# Vamos calcular o R^2 dos valores verdadeiros e 
# preditos conforme a seguinte funcao:
eval_results <- function(true, predicted, df) {
  SSE <- sum((predicted - true)^2)
  SST <- sum((true - mean(true))^2)
  R_square <- 1 - SSE / SST
  RMSE = sqrt(SSE/nrow(df))
  
  # As metricas de performace do modelo:
  data.frame(
    RMSE = RMSE,
    Rsquare = R_square
  )
}


# As metricas de performance na base de treinamento
# sao:
elasticnet_result_train <- eval_results(y_train, predictions_train, train1) 
elasticnet_result_train

# Vamos fazer as predicoes na base de teste
predictions_test <- predict(elastic_reg, x_test)

# As metricas de performance na base de teste sao:
elasticnet_result_test <- eval_results(y_test, predictions_test, test1)
elasticnet_result_test

# Vamos agora fazer a predicao para o mesmo perfil usado na Ridge/Lasso

# Valores fornecidos no enunciado
husage <- 40
husunion <- 0
husearns <- 600
huseduc <- 13
husblck <- 1
hushisp <- 0
hushrs <- 40
kidge6 <- 1
# 'earns' usa a media da variavel 'earns' na base de treinamento
earns <- mean(train$earns)
age <- 38
black <- 0
educ <- 13
hispanic <- 1
union <- 0
exper <- 18
kidlt6 <- 1

# Monta a matriz de predicao com o mesmo padrao da Ridge/Lasso
our_pred <- as.matrix(data.frame(
  husage = (husage - mean(train$husage)) / sd(train$husage),
  husearns = (husearns - mean(train$husearns)) / sd(train$husearns),
  huseduc = (huseduc - mean(train$huseduc)) / sd(train$huseduc),
  hushrs = (hushrs - mean(train$hushrs)) / sd(train$hushrs),
  earns = (earns - mean(train$earns)) / sd(train$earns),
  age = (age - mean(train$age)) / sd(train$age),
  educ = (educ - mean(train$educ)) / sd(train$educ),
  exper = (exper - mean(train$exper)) / sd(train$exper),
  husunion_0 = as.integer(husunion == 0),
  husunion_1 = as.integer(husunion == 1),
  husblck_0 = as.integer(husblck == 0),
  husblck_1 = as.integer(husblck == 1),
  hushisp_0 = as.integer(hushisp == 0),
  hushisp_1 = as.integer(hushisp == 1),
  kidge6_0 = as.integer(kidge6 == 0),
  kidge6_1 = as.integer(kidge6 == 1),
  black_0 = as.integer(black == 0),
  black_1 = as.integer(black == 1),
  hispanic_0 = as.integer(hispanic == 0),
  hispanic_1 = as.integer(hispanic == 1),
  union_0 = as.integer(union == 0),
  union_1 = as.integer(union == 1),
  kidlt6_0 = as.integer(kidlt6 == 0),
  kidlt6_1 = as.integer(kidlt6 == 1)
) )

# Vamos fazer a predicao com base nos parametros que
# selecionamos
predict_our_elastic <- predict(elastic_reg, newdata = our_pred)
predict_our_elastic

# O resultado esta na escala padronizada de lwage; vamos retornar a escala original
lwage_pred_elastic_log <- (predict_our_elastic * sd(train$lwage) + mean(train$lwage))
lwage_pred_elastic <- exp(lwage_pred_elastic_log)
lwage_pred_elastic


# Vamos criar o intervalo de confianca para o nosso
# exemplo (via escala log)
n <- nrow(train)
m <- lwage_pred_elastic_log
s <- sd(train$lwage)
dam <- s / sqrt(n)
CIlwr_elastic_log <- m + (qnorm(0.025)) * dam
CIupr_elastic_log <- m - (qnorm(0.025)) * dam

CIlwr_elastic <- exp(CIlwr_elastic_log)
CIupr_elastic <- exp(CIupr_elastic_log)

# Os valores minimo e maximo sao:
CIlwr_elastic
CIupr_elastic

###############################################################################

elasticnet_result_train
elasticnet_result_test

# Resultado final:
# Tabela com RMSE e R2 (base de teste)
model_metrics <- rbind(
  data.frame(Model = "Ridge", Dataset = "Teste", RMSE = ridge_result_test$RMSE, Rsquare = ridge_result_test$Rsquare),
  data.frame(Model = "Lasso", Dataset = "Teste", RMSE = lasso_result_test$RMSE, Rsquare = lasso_result_test$Rsquare),
  data.frame(Model = "ElasticNet", Dataset = "Teste", RMSE = elasticnet_result_test$RMSE, Rsquare = elasticnet_result_test$Rsquare)
)

# ordena por RMSE decrescente
#model_metrics <- model_metrics[order(model_metrics$RMSE, -model_metrics$Rsquare), ] 
model_metrics

# Predicoes com intervalos de confianca
pred_table <- rbind(
  data.frame(Model = "Ridge", Predicao = as.numeric(lwage_pred_ridge), CI_Lower = as.numeric(CIlwr_ridge), CI_Upper = as.numeric(CIupr_ridge)),
  data.frame(Model = "Lasso", Predicao = as.numeric(lwage_pred_lasso), CI_Lower = as.numeric(CIlwr_lasso), CI_Upper = as.numeric(CIupr_lasso)),
  data.frame(Model = "ElasticNet", Predicao = as.numeric(lwage_pred_elastic), CI_Lower = as.numeric(CIlwr_elastic), CI_Upper = as.numeric(CIupr_elastic))
)

#pred_table <- data.frame(
#  Model = c("Ridge", "Lasso", "ElasticNet"),
#  Predicao = c(as.numeric(lwage_pred_ridge), as.numeric(lwage_pred_lasso), as.numeric(lwage_pred_elastic)),
#  CI_Lower = c(as.numeric(CIlwr_ridge), as.numeric(CIlwr_lasso), as.numeric(CIlwr_elastic)),
#  CI_Upper = c(as.numeric(CIupr_ridge), as.numeric(CIupr_lasso), as.numeric(CIupr_elastic))
#)
pred_table


