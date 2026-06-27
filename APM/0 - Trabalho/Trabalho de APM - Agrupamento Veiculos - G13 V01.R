#' ---
#' titlte: ""
#' author: ""
#' date: ""
#' ---
#########################################
#                                       #
#     Trabalho de APM - T.2026 G13      #
#                                       #
#         Agrupamento Veiculos          #
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
#library(caret)



##################
# Macro definições
##################
mySEED<-202613

DF_CSV<-"Veiculos - Dados.csv"
DF_NOVOS_CASOS<-"Veiculos - Novos Casos.csv"
DEL_COLUNA<-"a"
TARGET<-"tipo"
CSV_RESULTADO <- "resultado_agrupamento.csv"

NUM_CLUSTERS <- 10

######################################

### Obter os dados
dados <- read.csv(DF_CSV)
#View(dados)

### Retira coluna desnecessaria
dados[[DEL_COLUNA]] <- NULL

### Retira coluna target
dados[[TARGET]] <- NULL


##########
# Kmeans #
##########

km.res = kmeans(dados, NUM_CLUSTERS, nstart=25)

print(km.res)

### Associa o resultado a cada observação
resultado <- cbind(dados, km.res$cluster)


### Exibe as 10 primeiras linhas
primeiras_10 <-head(resultado, 10)

### Salva resultado das 10 primeiras linhas em um arquivo
write.csv(primeiras_10, CSV_RESULTADO,
          row.names=FALSE)
