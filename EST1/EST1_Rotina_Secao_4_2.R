#################################################################
#    UNIDADE 4: Testes de hipoteses parametricos e intervalos   # 
#                             de confianca                      #
#         Secao 4.2: Unpaired test or two-sample test           #
#################################################################

#################################################################
#    Teste de duas amostras independentes - Unpaired Z test     #
#################################################################

# Instalando os pacotes necessarios:
# install.packages("BSDA")
# install.packages("onewaytests")
# install.packages("sjPlot")
# install.packages("tigerstats")
# install.packages("misty")

# Carregando os pacotes:
library("BSDA")
library("onewaytests")
library("sjPlot")
library("tigerstats")
library("misty")

# Carregando a base de dados "qi_unpaired", trata-se uma amostra
# com dois grupos, garotos e garotas, e que contem o "QI" de cada
# individuo, vamos ver a base de dados
load("EST1/qi_unpaired.RData")
View(qi_unpaired)

# Vamos fazer checagens preliminares para verificar as exigencias
# do teste: Amostras independentes, normalidade e homogeneidade 
# das variancias entre grupos

# Premissa 1: As duas amostras sao independentes?
# Sim, pois os grupos de garotos e garotas nao estao relacionados.
# Nao se trata de uma amostra ou grupos emparelhados.

# Premissa 2: Os dados de cada amostra/grupo possuem distribuicao
#             normal?
# Vamos usar o teste de normalidade Shapiro-Wilk com o seguinte
# teste de hipoteses:

# - H0: os dados sao normalmente distribuidos 
# - Ha: os dados nao sao normalmente distribuidos

# Primeiro vamos fazer o teste de normalidade Shapiro-Wilk para o
# "QI" dos garotos
with(qi_unpaired, shapiro.test(qi[group == "boy"]))     
# p-value > 0.05 (ou seja, 0.3253), logo o grupo possui
# distribuicao normal

# Agora vamos fazer o teste de normalidade Shapiro-Wilk para o 
# "QI" das garotas
with(qi_unpaired, shapiro.test(qi[group == "girl"]))     
# p-value>0.05 (ou seja, 0.2594), logo o grupo possui 
# distribuicao normal

# Pelos resultados dos testes, os dois valores de p-value sao
# maiores do que o nivel de significancia 0.05, o que implica
# que a distribuicao dos dados nao eh significativamente
# diferente da distribuicao normal. 
# Em outras palavras, podemos assumir que os dois grupos possuem
# distribuicao normal.

# Premissa 3. As duas populacoes/amostras/grupos possuem
#             homogeneidade das variancias?
# O teste de hipoteses eh:

# H0: As variancias sao estatisticamente iguais(homogeneas)
# HA: As variancias nao sao estatisticamente iguais(homogeneas)

# Usaremos o teste F para testar a homogeneidade nas variancias. 
res.ftest <- var.test(qi ~ group, data = qi_unpaired)
res.ftest

# Obtendo o valor tabelado da distribuicao F
qf(0.95, 119, 119)
# temos F=1,35
# para a outra cauda temos:
1/1.35
# F = 0,74

# Vamos construir o grafico:
dist_f(f = 1.35, deg.f1 = 119, deg.f2 = 119)
dist_f(f = 0.74, deg.f1 = 119, deg.f2 = 119)

# O teste de F tem valor critico entre 0.74 e 1.35 (regiao de
# nao rejeicao de H0), os valores acima de 1,35 e abaixo de 
# 0.74 estao na regiao de rejeicao de H0 (area azul do grafico).
# O valor da estatistica F calculada eh 0.99956. Como esse valor
# se encontra na regiao de nao rejeicao de H0, entao nao 
# rejeitamos a hipotese de que as variancias sao 
# estatisticamente iguais.

# Observe que se os individuos nao forem independentes trata-se 
# de uma amostra emparelhada e devemos utilizar o teste para esse
# tipo de amostra. Se os dados nao forem normalmente distribuidos,
# e as variancias nao forem homogeneas eh recomendavel usar o
# teste de duas amostras independentes nao parametrico.

# Feitas essas checagens preliminares, como os grupos sao
# independentes, normalmente distribuidos e de possuem variancia
# homogenea, agora podemos fazer o teste Z para duas amostras/
# grupos e responder o seguinte:

# Pergunta: Existe alguma diferenca significativa entre o "qi"
#           das garotas e dos garotos?

# Para responder executamos o seguinte teste de hipoteses:
# H0: A diferenca verdadeira entre as medias dos "qi"s dos   
#     grupos (garotos e garotas) eh igual a zero, ou seja,
#     as medias sao estatisticamente iguais
# HA: A diferenca verdadeira entre as medias dos "qi"s dos  
#     grupos (garotos e garotas) nao eh igual a zero, ou seja,
#     as medias sao estatisticamente diferentes

# Fazendo o teste!

# Vamos ver os desvios padroes dos grupos e as suas medias
with(qi_unpaired, sd(qi[group == "boy"]))
with(qi_unpaired, sd(qi[group == "girl"]))
with(qi_unpaired, mean(qi[group == "boy"]))
with(qi_unpaired, mean(qi[group == "girl"]))

# Vamos guardar os valores dos grupos em separado nos objetos
# "x" e "y":
x <- with(qi_unpaired, (qi[group == "boy"])) 
y <- with(qi_unpaired, (qi[group == "girl"]))

# Agora vamos fazer o teste de Z para amostras ou grupos 
# independentes 
z.test(x=x, y=y, mu=0, sigma.x=15.17, 
       sigma.y=15.18,alternative = "two.sided")

# No resultado:
# a) "Z" eh o valor estatistico do teste (Z = -2.348);  
# b) "p-value" eh o nivel de significancia do teste Z 
#    (valor de p = 0.01887); 
# c) O intervalo de confianca da diferenca entre as medias a 95%
#    de confianca se situa entre -8.4397344 e -0.7602656;
# d) "sample estimates" eh o valor da media de cada grupo da
#    amostra (media dos garotos = 105.575, e a media das garotas 
#    = 110.175).

# Obtendo os valores tabelados da estatistica Z
qnorm(0.975)
qnorm(0.025)

# Vamos construir o grafico da distribuicao Z
pnormGC(c(-1.96,1.96),region="outside",mean=0,
        sd=1,graph=TRUE)

# Os valores tabelados/criticos da distribuicao Z sao -1.96 e 
# 1.96 (area de nao rejeicao de H0), com 95% de confianca ou
# 5% de significancia. Os valores acima de 1.96 e abaixo de
# -1.96 sao as regioes de rejeicao de H0 (areas azuis do 
# grafico). Como o valor Z calculado eh -2.348, eh menor que
# -1.96, portanto ele se encontra na regiao de rejeicao de H0.
# Sendo assim, rejeitamos a hipotese (H0) de que as medias sejam
# estatisticamente iguais, ou seja, o "qi" medio dos garotos eh
# estatisticamente diferente do "qi" medio das garotas.

# Outra forma de interpretar:
# O valor de p do teste eh 0.01887, que eh menor que o nivel de
# significancia 0,05 (5% de signific�ncia ou 95% de confianca). 
# Esse p-value se situa na area de rejeicao de H0, logo 
# rejeita-se H0. Conclui-se que o "qi" medio dos garotos eh
# estatisticamente diferente do "qi" medio das garotas.
# Portanto, como as medias sao estatisticamente diferentes e em
# termos absolutos/nominais o "qi" medio das garotas eh maior que
# a media dos garotos, entao as garotas possuem efetivamente "qi"
# superior.

# Vamos confirmar o resultado com o teste de Welch
test.welch(qi ~ group, data = qi_unpaired)
# O teste de Welch confirmou o que o teste de Z apresentou

# Ent�o, a media do "qi" das garotas eh 110,175 e dos garotos eh
# 105,575
# Se dividirmos um pelo outro temos:
110.175/105.575
# O "qi" das garotas eh 4,36% superior ao "qi" dos garotos


################################################################
#    Teste de duas amostras independentes - Unpaired t test    #
################################################################

# Vamos utilizar a base de dados "mw_weight.RData"
# Carregando a base de dados
load ("EST1/mw_weight.RData")

# Trata-se de uma amostra com dois grupos, homens e mulheres e
# que contem o peso de cada individuo, vamos ver a base de 
# dados
View(mw_weight)

# Vamos fazer checagens preliminares para verificar as exigencias
# anteriores para a aplicacao do teste de comparacao das medias:
# Amostras independentes, normalidade e homogeneidade das 
# variancias 

# Premissa 1: Os dois grupos sao independentes?
# Sim, pois os grupos de homens e mulheres nao estao relacionados.
# Nao se trata de uma amostra ou grupos emparelhados.

# Premissa 2: Os dados de cada grupo segue uma distribuicao
#             normal?
# Vamos usar o teste de normalidade Shapiro-Wilk com as seguintes
# hipoteses

# - H0: os dados sao normalmente distribuidos 
# - Ha: os dados nao sao normalmente distribuidos

# Primeiro vamos fazer o teste de normalidade Shapiro-Wilk para
# os pesos masculinos
with(mw_weight, shapiro.test(weight[group == "Man"]))     
# p-value>0.05 (0.1066), logo o grupo possui distribuicao normal

# Agora vamos fazer o teste de normalidade Shapiro-Wilk para os
# pesos femininos
with(mw_weight, shapiro.test(weight[group == "Woman"]))     
# p-value>0.05 (0.6101), logo o grupo possui distribuicao normal

# Pelos resultados dos testes, os dois valores de p-value sao
# maiores do que o nivel de significancia 0.05, o que implica 
# que a distribuicao dos dados nao eh estatisticamente diferente
# da distribuicao normal. 
# Em outras palavras, podemos assumir que os grupos possui
# distribuicao normal.

# Premissa 3: As duas populacoes tem as variancias 
#             estatisticamente iguais?
# O teste de hipoteses eh o seguinte

# H0: As variancias sao estatisticamente iguais(homogeneas)
# HA: As variancias nao sao estatisticamente iguais(homogeneas)

# Usaremos o teste F para testar a homogeneidade das variancias. 
res.ftest <- var.test(weight ~ group, data = mw_weight)
res.ftest

# Vamos obter o valor tabelado de F
qf(0.95, 8, 8)
# temos F = 3.44 lado direito
# No outro lado da curva:
1/3.44
# temos F = 0,29 lado esquerdo

# Vamos construir o grafico:
dist_f(f = 3.44, deg.f1 = 8, deg.f2 = 8)
dist_f(f = 0.29, deg.f1 = 8, deg.f2 = 8)

# O valor calculado do teste eh 0,36134, e a area de nao 
# rejeicao de H0 (variancias iguais) esta entre 0,29 e 3,44. 
# Portanto, podemos considerar que as variancias sao 
# estatisticamente iguais.

# Entao depois das verificacoes preliminares temos que:
# As amostras/grupos sao independentes; as amostras ou grupos
# sao normalmente distribuidos; e as amostras ou grupos tem
# variancia homogenea.

# Observe que se os individuos nao forem independentes, devemos 
# utilizar um teste para dados pareados. Se os dados nao forem
# normalmente distribuidos, e as variancias nao forem homogeneas
# eh recomendavel usar o teste de duas amostras independentes
# nao parametrico.

# Feitas essas verificacoes preliminares tem-se a seguinte
# pergunta: Existe alguma diferenca significativa entre
# os pesos das mulheres e dos homens?

# Para responder executamos o seguinte teste de hipoteses
# H0: A verdadeira diferenca das medias entre os grupos homens
#     e mulheres eh igual a zero, ou seja, as medias sao 
#     estatisticamente iguais
# HA: A verdadeira diferenca das medias entre os grupos homens
#     e mulheres nao eh igual a zero, ou seja, as medias sao
#     estatisticamente diferentes

# Fazendo o teste:
res <- t.test(weight ~ group, data = mw_weight, 
              var.equal = TRUE)
# Verificando o resultado
res

# No resultado:
# a) "t" eh o valor estatistico do teste (t = 2.7842);  
# b) "p-value" eh o nivel de significancia do teste t (valor de
#    p = 0.01327); 
# c) O intervalo de confianca da diferenca entre as medias a 95%
#    de confianca se situa entre 4.029759 e 29.748019;
# d) "sample estimates" eh o valor da media de cada grupo da 
#    amostra (media dos homens = 68.99, e a media das mulheres
#    = 52.10).

# Obtendo os valores tabelados da estatistica t com 16 graus de
# liberdade
qt(0.975, 16)
qt(0.025, 16)

# Vamos construir o grafico:
ptGC(c(-2.12,2.12),region="outside",df=16, graph = TRUE)

# A estatistica t calculada eh 2,7842 e se encontra na regiao de
# rejeicao de H0, portanto, conclui-se que as medias sao 
# estatisticamente diferentes.

# Outra forma de interpretar:
# O valor de p do teste eh 0.01327, que eh menor que o nivel de
# significancia 0,05 (5% de signific�ncia ou 95% de confianca).
# Esse p-value se situa na area de rejeicao de H0, logo 
# rejeita-se H0. Conclui-se que o peso medio dos homens eh 
# estatisticamente diferente do peso medio das mulheres.

# Vamos confirmar o resultado com o teste de Welch
test.welch(weight ~ group, data = mw_weight)
# O teste de Welch confirmou o resultado

# Portanto, se dividirmos as medias temos:
68.99/52.10
# o peso medio dos homens eh 32,42% superior ao peso medio das
# mulheres

################################################################