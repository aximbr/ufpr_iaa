#################################################################
#    UNIDADE 4: Testes de hipoteses parametricos e intervalos   # 
#                             de confianca                      #
#               Secao 4.1: One Sample Test                      #
#################################################################

#################################################################
#   Teste de hipotese para comparar a media de uma variavel com # 
#  outro valor hipotetico e Intervalo de confianca para a media #
#                   usando a distribuicao (Z)                   #
#################################################################

# Este eh um teste e intervalo de confian�a para grandes amostras

# Instalando os pacotes necessarios para os testes
# install.packages("carData")
# install.packages("datasets")
# install.packages("BSDA")
# install.packages("nortest")
# install.packages("stats")
# install.packages("rcompanion")
# install.packages("dplyr")
# install.packages("tigerstats")
# install.packages("misty")

# Carregando os pacotes necessarios para os testes
library(carData)
library(datasets)
library(BSDA)
library(nortest)
library(stats)
library(rcompanion)
library(dplyr)
library(tigerstats)
library(misty)

# Configurando para nao aparecer notacao cientifica nos
# resultados
options(scipen = 999)

# Vamos utilizar a base de dados "qi_unpaired" que tem dados de
# "QI" de alunos
# Carregando a base de dados
load("EST1/qi_unpaired.RData")

# Vamos calcular a media e o desvio padrao da variavel "qi", 
# de toda amostra
mean(qi_unpaired$qi)

# Calculando as estatisticas descritivas por grupo, garotos e
# garotas:
group_by(qi_unpaired, group) %>%
  summarise(
    count = n(),
    mean = mean(qi, na.rm = TRUE),
    sd = sd(qi, na.rm = TRUE)
  )

# Calculando o desvio padrao de toda amostra:
sd(qi_unpaired$qi)

# Vamos gerar um histograma:
hist(qi_unpaired$qi)

# Vamos plotar a curva normal sobre o histograma:
plotNormalHistogram(qi_unpaired$qi, prob = FALSE, 
              main = "Normal Distribution overlay on Histogram", 
                     length = 1000 )

# Para uma amostra ou grupo nao eh necessario testar se a
# variancia eh constante isto porque basta que a amostra/
# populacao seja normalmente distribuida para que a variancia
# seja bem comportada.
# Se soubermos que a amostra provem de uma populacao normalmente
# distribuida nao eh necessario ou obrigatorio testar a 
# normalidade, mas eh prudente.

# Executanto teste de normalidade de Kolmogorov-Smirnov
lillie.test(qi_unpaired$qi)
# Regra de bolso: Como o p-value eh superior a 0.05, a variavel
# "qi" eh normalmente distribuida 

# Ressalta-se que se nao fosse identificada normalidade 
# deveriamos utilizar um teste equivalente nao parametrico,
# portanto, nao usariamos o teste "Z" nem "t"

# Executando o teste de z para uma amostra com o valor hipotetico
# de 110 que eh o "qi" medio das garotas 

# Hipoteses:
# H0: a media do "qi" geral eh estatisticamente igual a 110
# Ha: a media do "qi" geral nao eh estatisticamente igual a 110

z.test(qi_unpaired$qi, y=NULL, alternative="two.sided", 
       mu = 110, sigma.x = sd(qi_unpaired$qi), 
       sigma.y = NULL, conf.level = 0.95)

# Intervalo de confianca
# Isso quer dizer que o "qi" medio geral vai variar entre 105,94
# e 109,81, com uma media de 107,88, com 95% de confianca ou 5%
# de significancia

# Resultado do teste da media:
# Valor da Estatistica z = -2,1486
# Confrontamos esse valor com o valor tabelado da estatistica Z
# para 95% de confianca ou 5% de significancia (usamos isso para
# obter o valor tabelado, conforme comando abaixo)

# Obtendo os valores tabelados da estatistica Z:
qnorm(0.025) # os 2,5% da cauda inferior
qnorm(0.975) # os 2,5% da cauda superior

# Construindo a curva normal:
pnormGC(c(-1.96,1.96),region="outside",mean=0,
        sd=1,graph=TRUE)

# Como a estistica z calculada (-2.1486) eh menor que a 
# estatistica tabelada (-1.96), este valor se situa na regiao
# de rejei��o de H0, portanto rejeitamos a hipotese (H0) de que
# o valor verdadeiro da media da variavel "qi" eh 
# estatisticamente igual a 110 ("qi" medio das garotas).

# Ressalta-se que se o valor da estatistica z calculada (no
# resultado do teste) fosse maior que 1.96 (valor tabelado) o
# resultado seria o mesmo em termos de interpretacao do teste. 

# Mas, se a estatistica z calculada (no resultado do teste) se
# situasse entre -1.96 e 1.96 (valor tabelado), nao rejeitariamos
# H0.

# Se este fosse o caso, nao poderiamos rejeitar que a media da
# variavel "qi" seria estatisticamente igual a 110, com 95% de
# confianca ou 5% de significancia.


#################################################################
#  Teste de hipotese para comparar a media de uma variavel com  #
# outro valor hipotetico e Intervalo de confianca para a media  #
#                  usando a Distribuicao "t"                    #
#################################################################

# jah carregamos os pacotes necessarios no inicio da rotina

# Este eh um teste e intervalo de confian�a para pequenas
# amostras

# Instalando o pacote necessario ao teste
# install.packages("stats")

# Vamos utilizar a base de dados "mw_weight", uma amostra com 
# pesos de homens e mulheres 
# Carregando a base de dados
load("mw_weight.RData")

# Exemplo para a variavel "weight", peso das mulheres na base de
# dados "mw_weight"

# Primeiro, vamos ver estatisticas descritivas do dataset
group_by(mw_weight, group) %>%
  summarise(
    count = n(),
    mean = mean(weight, na.rm = TRUE),
    sd = sd(weight, na.rm = TRUE)
  )

# Agora vamos separar as mulheres em outro objeto:
pesow <- mw_weight %>% filter(group == "Woman")

# Vamos calcular algumas estatisticas descritivas das mulheres
mean(pesow$weight) # media
sd(pesow$weight) # desvio padrao  

# Vamos gerar um histograma
hist(pesow$weight)
# Vamos plotar a curva normal sobre o histograma
plotNormalHistogram(pesow$weight, prob = FALSE, 
                    main = "Normal Distribution overlay on Histogram", 
                    length = 1000 )

# Executanto teste de normalidade de Kolmogorov-smirnov:
lillie.test(pesow$weight) # p-value = 0.5107
# Como o p-value eh superior a 0.05, a variavel "weight" para as
# mulheres eh normalmente distribuida

# Vamos executar o teste de t para a media dos pesos das mulheres
# comparando com um valor hipotetico de 69 que eh o peso dos 
# homens

# Hipoteses:
# H0: A media do peso das mulheres eh estatisticamente igual a 69
# Ha: A media do peso das mulheres nao eh estatisticamente igual 
#     a 69

t.test(pesow$weight, y = NULL,
       alternative = c("two.sided"),
       mu = 69.00, paired = FALSE, var.equal = FALSE,
       conf.level = 0.95, data=pesow)

# Resultado do intervalo de confian�a:
# Isso quer dizer que a media dos pesos das mulheres vai variar
# entre 40.11 e 64.09, com uma media de 52.10, com 95% de 
# confianca ou 5% de significancia.

# Resultado para o teste da media:
# Valor da Estatistica: t = -3.2507, com 8 graus de liberdade

# Confrontamos esse valor com o valor tabelado da estatistica t
# para 95% de confianca ou 5% de significancia (usamos isso para
# obter os valores tabelados, conforme comandos abaixo)

# Obtendo os valores tabelados de "t" de student
qt(0.975, df=8) # cauda superior
qt(0.025, df=8) # cauda inferior

# Vamos construir o grafico
ptGC(c(-2.31,2.31),region="outside",df=8, graph = TRUE)

# Como a estistica t calculada (-3.2507) eh menor que a 
# estatistica tabelada (-2,31), portanto o valor de -3.2507 se
# encontra na regiao de rejeicao.
# Sendo assim, rejeitamos a hipotese (H0) de que o valor
# verdadeiro da media eh estatisticamente igual a 69,00 (peso 
# dos homens).

# Ressalta-se que caso o valor da estatistica t calculada (no
# resultado do teste) fosse maior que 2.31 o resultado seria o
# mesmo em termos de interpretacao do teste. 

# Mas, se a estatistica t calculada (no resultado do teste) se
# situasse entre -2.31 e 2.31 (valor tabelado) nao rejeitariamos
# H0. Neste caso, poderiamos considerar que a media da variavel
# seria estatisticamente igual a 69,00 com 95% de confianca ou
# 5% de significancia. 


#################################################################
#        Intervalo de confianca para o desvio padrao            #  
#################################################################

# Calculando o intervalo de confianca do desvio padrao para a
# variavel peso das mulheres - mesmo dataset do exercicio 
# anterior:
ci.sd(pesow$weight, method = "chisq")

# Resultado:
# Isso quer dizer que o desvio padrao da variavel "weight" varia
# entre 10,53 e 29,88, com media de 15,60, com 95% de confianca
# ou 5% de significancia em um teste bicaudal

#################################################################