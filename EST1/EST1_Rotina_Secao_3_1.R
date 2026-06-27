#################################################################
#            UNIDADE 3: Distribuicoes de probabilidade          #
#               Secao 3.1: Distribuicoes discretas              #
#################################################################

#################################################################
#                   Distribuicao binomial                       #
#################################################################

# Exemplo do slide: x = 0; n = 10; p = 0.3; 
# Resultado = 2.82%

# Calculando a probabilidade
local({
  .Table<- data.frame(Probability=dbinom(0:10, 
                                        size=10, 
                                        prob = 0.3))
  rownames(.Table) <- 0:10
  print (.Table)   
})

# Se olharmos na tabela para o experimento "zero" o valor eh
# "0.0282475249" que eh a mesma coisa que "2,82%"

# Outra forma de fazer
pbinom(c(0), size=10, prob=0.3, lower.tail=TRUE)

# Para gerar um grafico das 11 primeiras probs:
success <- 0:10
plot(success, dbinom(success, size=10, 
                     prob=.3),type='h')


#################################################################
#                     Distribuicao poisson                      #
#################################################################

# Exemplo do slide:lambda = 5; x = 3; resultado 14.04%

# Calculando a probabilidade
local({
  .Table<- data.frame(Probability=dpois(0:5,lambda=5))
  rownames(.Table) <- 0:5
  print (.Table)   
})

# Se olharmos na tabela a linha "3" que se refere ao numero de
# chamadas recebidas (evento) encontramos "0.14037390" que eh
# a mesma coisa que "14,04%"

##### Calculando de outra forma
dpois(3, lambda = 5)

# Para gerar grafico das 6 primeiras probabilidades:
success <- 0:5
plot(success, dpois(success, lambda=5), type='h')


#################################################################
#                    Distribuicao geometrica                    #
#################################################################

########### Numero de fracassos ate primeiro sucesso ############

# Exemplo do slide: Y=k=2; p = 0.4; Resultado = 14,40%

# Calculando a probabilidade
local({
  .Table<- data.frame(Probability=dgeom(0:5,prob=0.4))
  rownames(.Table) <- 0:5
  print (.Table)   
})

# Se olharmos na tabela a linha numero "2" vamos encontrar
# "0.1440" que eh a mesma coisa que "14,40%"

#### Calculando de outra forma
dgeom(2, 0.4)

# Para gerar um grafico das 6 primeiras probs.
success <- 0:5
plot(success, dgeom(success, 0.4), type='h')

######## Numero de tentativas necessarias para se obter ######### 
#################### o primeiro sucesso #########################

# Para evitar resultados com notacao cientifica usamos:
options(scipen=999)

# Exemplo do slide: p = 0.10; Y = k = 34 ==> K-1=33 ; 
# Resultado 0.31%

# Calculando a probabilidade
local({
  .Table<-data.frame(Probability=dgeom(1:40,prob=0.1))
  rownames(.Table) <- 1:40
  print (.Table)   
})

# Na tabela gerada, se olharmos a linha de numero "33" 
# encontraremos o valor de "0.003090315" que eh a mesma coisa
# que "0,31%" 

### Calculando de outra forma
dgeom(33, 0.1)

# Para gerar um grafico com as probs. de 30 a 35:
success <- 30:35
plot(success, dgeom(success, 0.1), type='h')


#################################################################
#                  Distribuicao hipergeometrica                 #
#################################################################

# Exemplo do slide: 
# numero de sucessos na amostra = 2; 
# numero de sucessos na populacao = m = 3; 
# numero de fracassos na populacao = n = 3; 
# tamanho da amostra = k = 4; 
# Resultado = 60%

# Calculando a probabilidade
local({
  .Table<-data.frame(Probability=dhyper(0:3,
                                        m = 3, 
                                        n = 3, 
                                        k = 4))
  rownames(.Table) <- 0:3
  print (.Table)   
})

# Se olharmos na tabela a linha "2" teremos "0.6" que eh a mesma
# coisa que 60%

# Calculando de outra forma:
dhyper(2, m = 3, n = 3, k = 4)

# Para gerar um grafico com as 6 primeiras probs:
success <- 0:5
plot(success,dhyper(success, m=3, n=3, k=4),type='h')


#################################################################
#            Distribuicao Binomial Negativa ( Inversa)          #
#################################################################

# Exemplo do slide: 
# x = 10; k=numero sucessos= size=3; p = 0.02; Resposta = 0.025% 

local({
  .Table<-data.frame(Probability=dnbinom(0:10, size=3,
                                         prob=0.02))
  rownames(.Table) <- 0:10
  print (.Table)   
})

# No resultado devemos ler a observacao "7", pois 10-3=7 , dado
# que a distribuicao eh negativa (inversa), nesta linha 
# acharemos "0.00025002015" que eh a mesma coisa que 0,025%.

# Calculando de outra forma:
dnbinom(7, size = 3, prob=0.02)

# Para gerar um grafico das 11 primeiras probs:
success <- 0:10
plot(success, dnbinom(success, size = 3, 
                      prob=0.02), type='h')

#################################################################