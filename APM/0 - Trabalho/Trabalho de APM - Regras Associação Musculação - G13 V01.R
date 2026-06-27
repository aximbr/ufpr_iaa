#' ---
#' titlte: ""
#' author: ""
#' date: ""
#' ---
#########################################
#                                       #
#     Trabalho de APM - T.2026 G13      #
#                                       #
#    Regras de Associação Musculação    #
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
#install.packages('arules', dep=T)
library(arules)

##################
# Macro definições
##################
mySEED<-202613

DF_CSV<-"Musculacao - Dados.csv"

######################################

### Obter os dados
dados <- read.transactions(file=DF_CSV,format="basket",sep=";")

### Visualiza 4 primeiras linhas
inspect(dados[1:4])

###########
# Apriori #
###########

### Extrai as regras
set.seed(mySEED)
rules <- apriori(dados, 
                 parameter=list(supp=0.001,conf = 0.1,minlen=2),
                 appearance = list(default='rhs',lhs='LegPress'),
                 control = list(verbose=F))

inspect(sort(rules, by='confidence', decreasing=T))




