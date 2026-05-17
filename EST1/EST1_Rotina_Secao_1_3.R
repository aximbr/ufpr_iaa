#################################################################
#                      Unidade 1: Introducao                    #
#       Secao 1.3: Series estatisticas, graficos e tabelas      #
#################################################################

#################################################################
#                        Grafico de linhas                      #
#################################################################

# Coloque todos os arquivos das rotinas e bases de dados em um
# diretorio de facil acesso

# Configurando o diretorio base de trabalho do R (coloque o 
# endereco de diretorio da sua maquina)
# setwd("C:/iaa/Estat I 2023")
setwd("EST1")
# Instalando o pacote para ler arquivos excel, retire o "#" para
# executar o comando, o "#" a frente serve para comentar o que 
# esta escrito apos
# install.packages("readxl")

# Cada pacote vc deve instalar uma unica vez, mas pode instalar
# novamente caso tenha alguma atualizacao no pacote

# Carregando o pacote que le o arquivo excel. Toda vez que 
# iniciar o Rstudio e executar uma rotina deve-se carregar os
# pacotes necessarios
library(readxl)

# Lendo o arquivo e criando um objeto a partir do arquivo excel 
economics <- read_excel("economics.xlsx", 
                        col_types = c("date", 
                                      "numeric",
                                      "numeric", 
                                      "numeric", 
                                      "numeric", 
                                      "numeric"))
# Visualizando o conteudo do objeto
View (economics)

# Instalando pacote manipula bases de dados (esse 
# pacote funciona junto ao pacote - abaixo - 
# ggplot2 que gera graficos)
# install.packages("tidyverse")

# Instalando pacote que produz graficos
# install.packages("ggplot2")

# Carregando os pacotes
library(ggplot2)
library(tidyverse)

# Gerando o grafico
ggplot(economics, aes(x = date, y = unemploy)) + 
  geom_line() + geom_smooth(se = TRUE)

##################### Outro exemplo ####################

# Instalando pacote
# install.packages(plotly)

# Carregando pacote que gera o grafico
library(plotly)

# Vamos utilizar a base de dados "basepatr4.xlsx"

# Importanto arquivo de dados temporais
basepetr4<-read_excel("basepetr4.xlsx")

# Gerando o grafico
ggplotly(
  basepetr4 %>%
    mutate(Data = as.Date(Data)) %>%
    ggplot() +
    geom_line(aes(x = Data, y = Fechamento, 
                  color = "série")) +
    scale_color_viridis_d() +
    scale_x_date(date_labels = "%m-%Y", 
                 date_breaks = "1 month") +
    theme(axis.text.x = element_text(angle = 90, 
                                     vjust = 0.4),
          panel.background = element_rect(fill = "white",
                                          color = "black"),
          panel.grid = element_line(color = "grey90"),
          panel.border = element_rect(color = "black", 
                                      fill = NA),
          legend.position = "none")
)

################################################################
#         Grafico de dispersao entre X e Y (scaterplot)        #
################################################################

# Instalando o pacote que gera o grafico
# install.packages("lattice")

# Carregando o pacote que gera o grafico
library (lattice)

# Vamos utilizar a base de dados "ceo.txt"
# Importanto o dataset e criando um objeto (ceo) para guardar 
# essa base
ceo <- read.table("ceo.txt", header = TRUE, sep = "", 
                  na.strings = "NA", 
                  dec = ".", strip.white = TRUE)

# salvando o objeto "ceo" em um dataset no formato "R"
save(ceo, file = "ceo.RData")

# Criando o grafico de dispersao 
xyplot(comten ~ age, type="p", pch=16, 
       auto.key=list(border=TRUE), 
       par.settings=simpleTheme(pch=16), 
       scales=list(x=list(relation='same'),
                   y=list(relation='same')), data=ceo)

################################################################
#                        Histograma                            #   
################################################################

# Vamos utilizar o dataset "salarios.RData" que eh em formato
# nativo do R

# Carregando a base de dados "salarios" em formato R
load("salarios.RData")

# visualizando algumas estatisticas e informacoes das variaveis
summary(salarios)

# Vamos desenhar o histograma com o metodo de sturges (para a 
# quantidade de quebras) da variavel "husage" que eh a idade
# dos maridos
hist(salarios$husage, xlab="Idade dos Maridos", 
     ylab = "Frequency")

# Histograma para 5 quebras com a mesma variavel
hist(salarios$husage, breaks = 5, 
     xlab = "Idades dos Maridos",ylab = "Frequency")

################################################################
#                           Boxplot                            #
################################################################

# Vamos continuar utilizando a base de dados "salarios"

# Instalando o pacote que gera o boxplot
# install.packages("car")

#Carregando o pacote que gera o boxplot
library (car)

# Gerando o boxplot para a variavel "age" que eh a idade das
# esposas
Boxplot( ~ age, data=salarios, id=list(method="y"), 
         ylab="Idade das esposas")

# Gerando o boxplot para a variavel "husage" que eh a 
# idade dos maridos
Boxplot( ~ husage, data=salarios, id=list(method="y"), 
         ylab="Idade dos maridos")
# Aqui vemos varios possiveis outliers na amostra, idades dos 
# maridos muito elevadas

###############################################################
#             Tabela de Distribuicao de frequencia            #
###############################################################

# Instalando pacote que gera a distribuicao de frequencia 
# install.packages("fdth")

# Carregando pacote que calcula a distribuicao de frequencia
library(fdth)

# Calculando a distribuicao de frequencia e guardando no objeto
# "table"
table <- fdt(salarios$husearns)

# Mostrando a distribuicao de frequencia
print (table)

################################################################