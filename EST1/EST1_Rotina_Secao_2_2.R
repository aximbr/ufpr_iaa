##################################################################
#                UNIDADE 2: Estatistica descritiva               #
#                 Secao 2.2: Medidas de dispersao                #
##################################################################

##################################################################
#                             Variancia                          #
##################################################################

# Vamos utilizar a base de dados "salarios.RData"

# Carregando a base de dados "salarios.RData", o R vai buscar o
# arquivo onde tiver setado como diretorio padrao
load("EST1/salarios.RData")

# Calculando a variancia dos rendimentos dos maridos
var(salarios$husearns)

# Calculando a variancia dos rendimentos das esposas
var(salarios$earns)

# A variancia do rendimento dos maridos eh US$165.639,1
# A variancia do rendimento das esposas eh US$69.340,83

# Se dividirmos a variancia dos rendimentos dos maridos pela
# das esposas:
((165639.1/69340.83)-1)*100

# Portanto, a variancia do rendimento dos maridos eh mais que o
# dobro (2X) a variancia dos rendimentos das esposas (138,88% a
# mais)

#################################################################
#                         Desvio Padrao                         #
#################################################################

# Calculando o desvio padrao dos rendimentos dos maridos:
sd(salarios$husearns)

# Calculando o desvio padr�o dos rendimentos das esposas:
sd(salarios$earns)

# O desvio padrao do rendimento dos maridos eh US$406,98 
# O desvio padrao do rendimento das esposas eh US$263,32

# Se dividirmos o desvio padrao dos rendimentos dos maridos pelo
# das esposas:
((406.9878/263.32650)-1)*100

# O desvio padrao dos rendimentos dos maridos eh mais que 50%
# superior ao das esposas (54,56% a mais)

#################################################################
#                    Coeficiente de Variacao                    #
#################################################################

# Calculando a media dos rendimentos dos maridos e guardando no
# objeto "meanM"
meanM <- mean(salarios$husearns)

# Calculando a media dos rendimentos das esposas e guardando no
# objeto "meanE"
meanE <- mean(salarios$earns)

# Calculando o desvio padrao dos rendimentos dos maridos e 
# guardando no objeto sdM
sdM <- sd(salarios$husearns)

# Calculando o desvio padrao dos rendimentos das esposas e
# guardando no objeto sdE
sdE <- sd(salarios$earns)

# Calculando o coeficiente de variacao dos rendimentos dos
# maridos:
cvM <- (sdM/meanM)*100
cvM
# O coeficiente de variacao do rendimento dos maridos eh 89,74%

# Calculando o coeficiente de variacao dos rendimentos das 
# esposas:
cvE <- (sdE/meanE)*100
cvE
# O coeficiente de variacao do rendimento das esposas eh 113,09%

# Isso quer dizer que o rendimento dos maridos e esposas variam
# muito na amostra. Ainda, pode-se concluir que os rendimentos
# das esposas variam mais que dos maridos.

# Regra de bolso:
# Quando o CV for:
# a) CV < 15% existe baixa dispersao: dados homogeneos
# b) 15% =< CV <= 30% existe media dispersao
# c) CV > 30% existe alta dispersao: dados heterogeneos


#################################################################
#                    Valores Minimo e Maximo                    #
#################################################################

# Vamos extrair um sumario estatistico das variaveis rendimento
# dos maridos e esposas
summary(salarios$husearns)
summary(salarios$earns)

# O rendimento maximo das esposas (US$2.884,50) e eh maior do
# que dos maridos (US$1.823,00).

# O valor minimo eh zero para ambos.


#################################################################
#                             Quartis                           #
#################################################################

# Calculando o 1o. quartil do rendimento das esposas
Q1 <- quantile(salarios$earns, probs = 0.25)
Q1

# Calculando o 2o. quartil do rendimento das esposas
Q2 <- quantile(salarios$earns, probs = 0.50)
Q2
# Perceba que o 2o. quartil eh igual a mediana, e sempre serah,
# para qualquer variavel e dataset.

# Calculando o 3o. quartil do rendimento das esposas
Q3 <- quantile(salarios$earns, probs = 0.75)
Q3

# Perceba que os valores dos quartis sao identicos aos obtidos
# no comando 
summary(salarios$earns)

# Agora os quartis para o rendimento dos maridos
Q1 <- quantile(salarios$husearns, probs = 0.25)
Q1

Q2 <- quantile(salarios$husearns, probs = 0.50)
Q2

Q3 <- quantile(salarios$husearns, probs = 0.75)
Q3

summary(salarios$husearns)

# Conclusao:
# Como o Q2, Q3 e max do rendimento dos maridos sao maiores que
# os das esposas, conclui-se que existe um maior "espalhamento/
# dispersao" do rendimento dos maridos. Isso corrobora o achado
# no coeficiente de variacao, no desvio padrao e variancia


#################################################################
#               Distancia interquartilica: Q3 - Q1              #
#################################################################

# Calculando a IQR para os rendimentos dos maridos
IQR(salarios$husearns)

# Calculando a IQR para os rendimentos das esposas
IQR(salarios$earns)

# Quanto maior for o valor da IQR, maior eh a dispersao na 
# variavel. A comparacao entre as distancias interquartilicas
# dos rendimentos das esposas e maridos confirma que a variacao/
# dispersao nos rendimentos das esposas eh menor 
# (maridos = US$675; esposas = US$380)

#################################################################
#                             Percentis                         #
#################################################################

# Nos quartis dividimos a amostra em quatro partes, nos percentis
# dividimos a amostra em 10 partes, por exemplo, o percentil 0.4
# significa que sao os primeiros 40% da amostra; divide as 
# primeiras 40% observacoes da amostra dos 60% superiores. 

quantile(salarios$husearns, c(0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7,
                              0.8, 0.9)) 
quantile(salarios$earns, c(0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7,
                           0.8, 0.9)) 

# Os valores maiores dos rendimentos dos maridos, conforme se
# caminha para a totalidade da amostra, quando comparado ao das
# esposas, mostra uma variacao maior entre os rendimentos dos
# maridos. Apesar disso, vimos que quando executamos o summary()
# verificamos que o rendimento das esposas tem valor maximo maior.

##################################################################