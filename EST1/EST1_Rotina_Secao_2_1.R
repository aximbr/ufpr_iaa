##################################################################
#                UNIDADE 2: Estatistica descritiva               #
#                  Secao 2.1: Medidas de posicao                 #
##################################################################

##################################################################
#                                Media                           #
##################################################################

# Vamos utilizar a base de dados "salarios.RData"

# Carregando a base de dados "salarios.RData", o R vai buscar o
# arquivo onde estiver setado como diretorio padrao
load("salarios.RData")

# Calculando a media dos rendimentos dos maridos
mean(salarios$husearns)

# Calculando a media dos rendimentos das esposas
mean(salarios$earns)

# A media do rendimento dos maridos na amostra eh US$453,5406
# A media do rendimento das esposas na amostra eh US$232,833

# se dividirmos o rendimento medio dos maridos pelo das esposas
# temos
453.5406/232.833

# Portanto, o rendimento medio dos maridos eh quase o dobro do 
# rendimento medio das esposas (94,79% a mais)


##################################################################
#                              Mediana                           #
##################################################################

# Calculando a mediana dos rendimentos dos maridos
median(salarios$husearns)

# Calculando a mediana dos rendimentos das esposas
median(salarios$earns)

# A mediana do rendimento dos maridos eh de US$418,5
# A mediana do rendimento das esposas eh de US$185,0 

# Se dividirmos a mediana dos rendimentos dos maridos pelo das 
# esposas temos:
((418.5/185)-1)*100

# Em termos de mediana o rendimento dos maridos eh mais que o
# dobro do rendimento das esposas (126,22% a mais)


##################################################################
#                             Moda                               #
##################################################################

# Calculando as modas das idades dos maridos e esposas

# Para a idade dos maridos 
table(salarios$husage)
subset(table(salarios$husage), 
       table(salarios$husage) == 
         max(table(salarios$husage)))

# Para a idade das esposas
table(salarios$age)
subset(table(salarios$age), 
       table(salarios$age) == max(table(salarios$age)))

# A moda da idade dos maridos eh de 44 anos, com 201 pessoas 
# A moda da idade das esposa eh de 37 anos, com 217 pessoas

# Portanto, a moda da idade dos maridos eh maior que a das 
# esposas: 
44/37
# eh aproximadamente 18,92% maior.

#################################################################