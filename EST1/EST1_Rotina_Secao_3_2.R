#################################################################
#            UNIDADE 3: Distribuicoes de probabilidade          #
#               Secao 3.2: Distribuicoes continuas              #
#################################################################


#################################################################
#             Distribuicao Normal Padronizada (Z)               #
#################################################################

# Instalando o pacote necessario
# install.packages("tigerstats")

# Carregando o pacote
library(tigerstats)

# Como no R os valores da tabela Z sao para uma cauda, para se
# obter o nivel de significancia de 95% deve-se colocar na funcao
# o valor de 2,5% para a cauda da direita e 97,5 para a cauda da
# esquerda 

# Para obter os valores da tabela Z, com 2,5% na cauda da 
# esquerda e direita:
qnorm(0.025)
qnorm(0.975)

# Para obter um grafico da distribuicao Z para a area de 95%:
pnormGC(c(-1.96,1.96),region="between",mean=0,
        sd=1,graph=TRUE)

# Para as areas de 2,5% (que somadas representam 5%):
pnormGC(c(-1.96,1.96),region="outside",mean=0,
        sd=1,graph=TRUE)

# Nos testes de hipoteses essas areas das caudas sao utilizadas
# para testar a hipotese H0, representam a area de rejeicao de H0


#################################################################
#                 Distribuicao "t" de Student                   #
#################################################################

# Por exemplo, para 95% de confianca e 25 graus de liberdade
# t = 2.06, para a tabela t tambem deve-se colocar 2,5% porque
# os valores sao para uma cauda

# Para obter os valores da tabela t, para 2,5% na da cauda 
# esquerda e direita, para 25 graus de liberdade:
qt(0.025, 25)
qt(0.975, 25)

# Construindo um grafico para destacar os 95% da distribuicao
ptGC(c(-2.06,2.06),region="between",df=25, graph = TRUE)

# Feito de outra forma, para destacar os 5% da distribuicao
ptGC(c(-2.06,2.06),region="outside",df=25, graph = TRUE)


#################################################################
#                    Distribuicao Chi-Square                    #
#################################################################

# Por exemplo, com 5 graus de liberdade e 5% de probabilidade
# (1.145476) na cauda inferior e 95% (11.0705) na cauda superior

# Obtendo os valores criticos (da tabela)
qchisq(0.05,5)
qchisq(0.95,5)

# Construindo o grafico para destacar os 5% do lado superior
# da distribuicao
pchisqGC(c(11.0705),region="above",df=5, graph = TRUE)

# Outra forma de grafico para destacar os 5% do lado inferior
# da distribuicao
pchisqGC(c(1.145476),region="below",df=5, graph = TRUE)


################################################################
#               Distribuicao "F" de Fisher e Snedecor          #
################################################################

# Por exemplo, com 20 graus de liberdade no numerador e 19 graus
# de liberdade no denominador temos:
qf(0.95, 20, 19)

# Uma forma de fazer o grafico:

# Instalando o pacote necessario
# install.packages("sjPlot")

# Carregando o pacote
library(sjPlot)

# Plotando o grafico
dist_f(f = 0, deg.f1 = 20, deg.f2 = 19)


#################################################################
#                      Distribuicao logistica                   #
#################################################################

# Obtendo o valor tabelado para 5% de significancia
qlogis(0.95)

# Para plotar o grafico eh necessario:
# Criar um vetor x de valores, aqui exemplificamos uma sequencia 
# de numeros de -20 a 20, a cada 0,10 
x <- seq(-20, 20, by = 0.1) 
# Se deseja ver os valores:
x

# Chamando a funcao plogis() sobre os valores: 
y <- plogis(x) 
y
# A funcao de probabilidade logistica (plogis) transforma os
# valores em probabilidade no intervalo entre 0 a 1 

# Plotando o grafico: 
plot(y)

################################################################