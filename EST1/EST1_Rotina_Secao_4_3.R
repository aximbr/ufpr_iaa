#################################################################
#    UNIDADE 4: Testes de hipoteses parametricos e intervalos   # 
#                             de confianca                      #
#                      Secao 4.3: Paired test                   #
#################################################################

#################################################################
#      Teste de duas amostras emparelhadas - paired Z test      #
#################################################################

# Instalando os pacotes necessarios para o teste
# install.packages("BSDA")
# install.packages("onewaytests")
# install.packages("sjPlot")
# install.packages("tigerstats")
# install.packages("misty")

# Carregando os pacotes
library("BSDA")
library("onewaytests")
library("sjPlot")
library("tigerstats")
library("misty")

# Para nao mostrar resultados em notacao cientifica
options(scipen=999)

# Carregando a base de dados "bigpaired_weight.RData". Trata-se
# de uma amostra emparelhada com dois grupos, antes e depois de
# um tratamento de alimentacao para camundongos. Os camundongos
# foram pesados antes e depois do tratamento, vamos ver a base 
# de dados
load("bigpaired_weight.RData")
View(bigpaired_weight)

# Vamos fazer checagens preliminares para verificar as exigencias 
# do teste: Amostras independentes, normalidade e homogeneidade
# das variancias entre os grupos

# Premissa 1: A amostra se refere a dados emparelhados, e eh uma
#             grande amostra?
# Sim, pois os camundongos foram pesados antes e depois do
# tratamento. A amostra possui dados emparelhados de 100
# camundongos.

# Premissa 2: Os dados de cada grupo da amostra seguem uma
#             distribuicao normal?
# Vamos usar o teste de normalidade Shapiro-Wilk com o seguinte
# teste de hipoteses:

# H0: os dados sao normalmente distribuidos
# Ha: os dados nao sao normalmente distribuidos

# Primeiro calculamos a diferenca entre os pares e guardamos no
# objeto "d"
d1 <- with(bigpaired_weight, 
          weight[group == "before"] - 
            weight[group == "after"])
d1

# Executando o teste Shapiro-Wilk para normalidade
shapiro.test(d1)             # => p-value = 0.5098

# Pelos resultados dos testes, os dois valores de p sao maiores
# do que o nivel de significancia 0.05, o que implica que a
# distribuicao dos dados nao eh significativamente diferente da
# distribuicao normal. 
# Em outras palavras, podemos assumir que os dois grupos possuem
# distribuicao normal.

# Observe que se os dados nao forem normalmente distribuidos, eh
# recomendavel usar outro teste de duas amostras nao parametrico.

# Premissa 3. As duas populacoes/amostras/grupos possuem
#             homogeneidade das variancias?
# O teste de hipoteses eh o seguinte:

# H0: As variancias sao estatisticamente iguais(homogeneas) 
# HA: As variancias nao sao estatisticamente iguais(homogeneas)

# Usaremos o teste F para testar a homogeneidade nas variancias. 
res.ftest <- var.test(weight ~ group, 
                      data = bigpaired_weight)
res.ftest

# Obtendo o valor tabelado da distribuicao F
qf(0.95, 99, 99)
# temos F=1,39
# para a outra cauda temos:
1/1.39
# F = 0,72

# Vamos construir o grafico:
dist_f(f = 1.39, deg.f1 = 99, deg.f2 = 99)
dist_f(f = 0.72, deg.f1 = 99, deg.f2 = 99)

# O teste de F tem valores criticos entre 0.72 e  1.39 (regiao 
# de nao rejeicao), os valores acima de 1,39 e abaixo de 0.72 
# estao na regiao de rejeicao de H0 (area azul do grafico). O
# valor da estatistica F calculada eh 1.0811, esse valor se
# encontra na regiao de nao rejeicao de H0. Entao, nao rejeitamos 
# a hipotese de que as variancias sao estatisticamente iguais.

# Feitas essas checagens preliminares, como os grupos sao
# emparelhados, normalmente distribuidos e possuem variancia
# homogenea, agora podemos fazer o teste de Z para duas amostras/
# grupos e responder a seguinte pergunta:

# Existe alguma diferenca significativa entre o peso dos 
# camundongos antes e depois do tratamento?

# Para responder executamos o seguinte teste de hipoteses:

# H0: A diferenca verdadeira entre os pesos dos camundongos antes
#     e depois do tratamento eh igual a zero,ou seja, as medias
#     sao estatisticamente iguais
# HA: A diferenca verdadeira entre os pesos dos camundongos antes
#     e depois do tratamento nao eh igual a zero, ou seja, as
#     medias nao sao estatisticamente iguais

# Fazendo o teste:
z.test(x=d1, y=NULL, mu=0, sigma.x=sd(d1), 
       sigma.y=NULL,alternative = "two.sided",
       conf.level = 0.95)

# No resultado:
# a) "Z" eh o valor estatistico do teste (Z = -109.62);  
# b) "p-value" eh o nivel de significancia do teste Z 
#    (valor de p = 0.00000000000000022); 
# c) O intervalo de confianca da diferenca entre as medias a 95%
#    de confianca se situa entre -206.9199 e -199.6509;
# d) "sample estimates" eh o valor da media de cada grupo da 
#    amostra (media da diferenca entre antes e depois eh igual
#    a 203,2854.

# Obtendo os valores tabelados da estatistica Z
qnorm(0.975)
qnorm(0.025)

# Vamos construir o grafico da distrib. Z
pnormGC(c(-1.96,1.96),region="outside",mean=0,
        sd=1,graph=TRUE)

# Os valores tabelados/criticos da distribuicao Z sao -1.96 e 
# 1.96 (regiao de nao rejeicao de H0), com 95% de confianca ou
# 5% de significancia. Os valores acima de 1.96 e abaixo de 
# -1.96 sao as regioes de rejeicao de H0 (areas azuis do 
# grafico). 
# Como o valor Z calculado eh -109.62 (menor que -1.96) ele se
# encontra na regiao de rejeicao de H0. Sendo assim, rejeitamos
# a hipotese (H0) de que as medias sejam estatisticamente iguais,
# ou seja, o peso medio dos camundongos antes do tratamento eh 
# estatisticamente diferente do peso medio dos camundongos apos
# o tratamento.

# Outra forma de interpretar:
# O valor de p do teste eh 0.00000000000000022, que eh menor que
# o nivel de significancia 0,05 (5% de significância ou 95% de
# confianca). Esse p-value se situa na area de rejeicao de H0,
# logo rejeita-se H0.
# Conclui-se que peso medio dos camundongos antes do tratamento
# eh estatisticamente diferente do peso medio apos o tratamento.
# Portanto, como as medias sao estatisticamente diferentes e em
# termos absolutos/nominais o peso medio dos camundongos apos o
# tratamento eh maior que o peso medio antes do tratamento. 
# Entao os camundongos efetivamente engordaram.

# Vamos confirmar o resultado com o teste de Welch
test.welch(weight ~ group, data = bigpaired_weight)
# O teste de Welch confirmou o que o teste de Z apresentou

# Entao, como a media apos o tratamento eh 450,3031 e antes do
# tratamento eh 247,0177 , se dividirmos um pelo outro temos:
450.3031/247.0177
# O peso medio dos camundongos efetivamente aumentou em 82,3%
# apos o tratamento


###############################################################
#     Teste de duas amostras emparelhadas - paired t test     #
###############################################################

# jah carregamos os pacotes no inicio desta rotina

# Carregando a base de dados "paired_weight.RData". Trata-se de
# uma amostra emparelhada com dois grupos, antes e depois de um
# tratamento de alimentacao de camundongos. Os camundongos 
# foram pesados antes e depois do tratamento, vamos ver a base
# de dados

# Essa nao eh a mesma base de dados do "teste Z" (acima), esta
# eh uma pequena amostra de um outro experimento
load ("paired_weight.Rdata")

# Queremos saber se existe alguma diferenca significativa nos
# pesos dos ratos apos o tratamento

# Estatisticas descritivas
group_by(paired_weight, group) %>%
  summarise(
    count = n(),
    mean = mean(weight, na.rm = TRUE),
    sd = sd(weight, na.rm = TRUE)
  )

# Checagem preliminar para verificar as exigencias do teste t 
# pareado

# Premissa 1: As duas amostras estao emparelhadas?
# Sim, uma vez que os dados foram coletados pesando os mesmos 
# ratos (emparelhamento).

# Premissa 2: Esta eh uma amostra grande e normalmente
#             distribuida?
# Nao, n<30. Como o tamanho da amostra nao eh grande o suficiente
# (menos de 30), usamos o teste de t para dados pareados, mas
# antes precisamos verificar se as diferencas dos pares seguem
# uma distribuicao normal. Usamos o teste de normalidade 
# Shapiro-Wilk, com as seguintes hipoteses

# H0: os dados sao normalmente distribuidos
# Ha: os dados nao sao normalmente distribuidos

# Primeiro calculamos a diferenca entre os pares e guardamos no
# objeto "d"
d <- with(paired_weight, 
          weight[group == "before"] - 
            weight[group == "after"])
d

#  Agora aplicamos o teste de Shapiro-Wilk para (d)
shapiro.test(d)             # => p-value = 0.6141
# No resultado, o p-value eh maior do que o nivel de 
# significancia 0.05, o que implica que a distribuicao das
# diferencas (d) nao eh significativamente diferente da
# distribuicao normal.
# Em outras palavras, podemos assumir a normalidade dos dados.

# Premissa 3: As duas populacoes/amostras/grupos possuem
#             homogeneidade das variancias?
# O teste de hipoteses eh:

# H0: As variancias sao estatisticamente iguais(homogeneas) 
# HA: As variancias nao sao estatisticamente iguais(homogeneas)

# Usaremos o teste F para testar a homogeneidade nas variancias: 
res.ftest <- var.test(weight ~ group, 
                      data = paired_weight)
res.ftest

# Obtendo o valor tabelado da distribuicao F
qf(0.95, 9, 9)
# temos F=3,18
# para a outra cauda temos:
1/3.18
# F = 0,31

# Vamos construir o grafico:
dist_f(f = 3.18, deg.f1 = 9, deg.f2 = 9)
dist_f(f = 0.31, deg.f1 = 9, deg.f2 = 9)

# O teste de F, com valor critico entre 0.31 e 3.18 (area de nao
# rejeicao de H0), os valores acima de 3.18 e abaixo de 0.31 
# estao na regiao de rejeicao de H0 (area azul do grafico). O
# valor da estatistica F calculada no teste eh 2.5324. Como esse
# valor se encontra na regiao de nao rejeicao, entao nao 
# rejeitamos a hipotese de que as variancias sao estatisticamente
# iguais.

# Observe que se os individuos nao forem emparelhados, devemos
# utilizar um teste para amostras independentes. Se os dados
# nao forem normalmente distribuidos, e as variancias nao forem
# homogeneas eh recomendavel usar o teste de duas amostras 
# emparelhadas nao parametrico.

# Apos essas averiguacoes iniciais podemos executar o teste para
# a diferenca das medias emparelhadas com a seguinte pergunta:

# Existe alguma mudanca significativa no peso dos ratos apos o
# tratamento?

# H0: O peso dos ratos eh estatisticamente igual antes e depois
#     do tratamento
# HA: O peso dos ratos nao eh estatisticamente igual antes e 
#     depois do tratamento
res <- t.test(weight ~ group, data = paired_weight, 
              paired = TRUE)
res

# No resultado:
# a) "t" eh o valor estatistico do teste t (t = 20.883),
# b) df sao os graus de liberdade (df = 9),
# c) O p-value eh o nivel de significancia do teste t
#    (p-value = 0.0000000062).
# d) conf.int eh o intervalo de confianca das diferencas das
#    medias com 95%, que eh entre 173,42 e 215,56
# e) A estimativa da media amostral para as diferencas entre  
#    pares eh (media = 194,49).

# Vamos obter os valores de t tabelados
qt(0.025, 9)
qt(0.975, 9)

# Vamos construir o grafico
ptGC(c(-2.26,2.26),region="outside",df=9, graph = TRUE)

# Os valores tabelados/criticos de t sao -2,26 e 2,26, que eh o
# intervalo da regiao de nao rejeicao de H0, valores menores que
# -2,26 e maiores que 2,26 pertencem as regioes de rejeicao de H0.
# Como o t calculado eh 20,883 esse valor se encontra na regiao 
# de rejeicao de "H0" pois eh maior que 2,26. Logo, rejeitamos 
# "H0", e nao rejeitamos "Ha" de que os pesos dos ratos antes e
# depois do tratamento nao sao iguais.

# Outra forma de interpretar o resultado:
# O p-value do teste eh 0.0000000062, que eh menor que o nivel
# de significancia 0.05. Podemos entao rejeitar H0, logo nao 
# rejeitamos Ha, e concluimos que o peso medio dos camundongos
# antes do tratamento eh significativamente diferente do peso
# medio apos o tratamento.

# Vamos confirmar o resultado com o teste de Welch
test.welch(weight ~ group, data = paired_weight)
# O teste de Welch confirmou o que o teste de Z apresentou

# Como o peso medio dos ratos antes o tratamento eh 199 e depois
# do tratamento eh 394, podemos dividir os valores e encontrar:
394/199
# Os camundongos engordaram 97,99% apos o tratamento

#################################################################