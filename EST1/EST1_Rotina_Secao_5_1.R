##################################################################
#            Unidade 5. Testes nao Parametricos                  #
#         5.1 One-Sample Wilcoxon Signed Rank Test               #
##################################################################

# Instalando os pacotes necessarios
# install.packages("ggpubr")

# Carregando os pacotes
library(ggpubr)

# Vamos usar um conjunto de dados como exemplo que contem o peso
# de 10 ratos. Queremos saber se o peso mediano dos camundongos
# difere de 25g?

# Configurando o diretorio de trabalho
setwd("D:/PyProj/ufpr_iaa/EST1")

# Carregando o dataset
load("data_rats.Rdata")

# Vamos calcular um sumario estatistico da amostra
summary(data_rats$weight)
# A mediana eh 19,05

# Vamos visualizar os dados usando box plots
ggboxplot(data_rats$weight, 
          ylab = "Weight (g)", xlab = FALSE,
          ggtheme = theme_minimal())
# Nao temos valores extremos, mas se tivessemos nao haveria 
# problema algum

# Vamos calcular o One-sample Wilcoxon Signed Rank Test e 
# queremos saber se o peso mediano dos ratos difere de 25g
# (teste bicaudal)

# As hipoteses do teste sao:

# H0: peso mediano dos ratos eh estatisticamente igual a 25g
# HA: peso mediano dos ratos nao eh estisticamente igual a 25g

res <- wilcox.test(data_rats$weight, mu = 25, conf.int=TRUE)
res 

# Resultado do teste:
# O p-value do teste eh 0,001953, que eh menor que o nivel de 
# significancia 0.05. Podemos rejeitar a hipotese nula e 
# concluir que o peso mediano dos ratos eh estatisticamente
# diferente de 25g com um p-value de p = 0,001953.
# O intervalo de confianca com 95% esta entre 18,10 e 20,15

# Se desejamos testar se o peso mediano dos ratos eh inferior 
# a 25g (que eh um teste unicaudal):
# As hipoteses do teste sao:

# H0: o peso mediano dos ratos eh maior igual que 25g
# HA: o peso mediano dos ratos nao eh maior igual que 25g

# Usamos a seguinte funcao:
wilcox.test(data_rats$weight, mu = 25, alternative = "less",
            conf.int=TRUE)

# Resultado do teste:
# O p-value do teste eh 0,0009766, que eh menor que o nivel de 
# significancia 0,05. Podemos rejeitar a hipotese nula e 
# concluir que o peso mediano dos ratos nao eh estatisticamente
# maior que 25g, ou seja, eh menor que 25g (nao rejeitamos Ha).
# O intervalo de confian�a eh de um valor menor que 20,05, com
# uma mediana de 19,15.

# Se desejamos testar se o peso mediano dos ratos eh superior que 
# 25g (que eh um teste unicaudal):

# As hipoteses do teste sao:

# H0: o peso mediano dos ratos eh menor igual que 25g
# HA: o peso mediano dos ratos nao eh menor igual que 25g

# Usamos a seguinte funcao:
wilcox.test(data_rats$weight, mu = 25, alternative = "greater",
            conf.int=TRUE)

# Resultado do teste:
# O p-value do teste eh 1,0 , que eh maior que o nivel de 
# significancia 0.05. Portanto, n�o podemos rejeitar H0. Assim, 
# concluimos que o peso mediano dos ratos eh estatisticamente
# menor que 25g.
# O intervalo de confian�a eh de um valor maior que 18,35, com
# uma mediana de 19,15.

#################################################################