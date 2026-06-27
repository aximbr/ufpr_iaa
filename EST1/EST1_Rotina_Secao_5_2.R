##################################################################
#            Unidade 5. Testes nao Parametricos                  #
#                5.2 Mann-Whitney "U" test                       #
##################################################################

# Instalando pacotes
# install.packages("dplyr")
# install.packages("ggpubr")

# Carregando os pacotes
library("dplyr")
library("ggpubr")

# Preparando os dados em dois vetores numericos pesos de homens e
# mulheres
women_weight <- c(38.9, 61.2, 73.3, 21.8, 63.4, 64.6, 48.4,
                  48.8, 48.5)
men_weight <- c(67.8, 60, 63.4, 76, 89.4, 73.3, 67.3, 61.3,
                62.4) 

# Criando um data frame com o nome "weight"
weight <- data.frame( 
  group = rep(c("Woman", "Man"), each = 9),
  weight = c(women_weight,  men_weight)
)

# Queremos saber se o peso mediano das mulheres difere do peso
# mediano dos homens.

# Vamos primeiro calcular um sumario estatistico
group_by(weight, group) %>%
  summarise(
    count = n(),
    median = median(weight, na.rm = TRUE),
    IQR = IQR(weight, na.rm = TRUE)
  )

# Vamos visualizar os dados usando box-plots
# Plotaremos o "weight" por groupo
ggboxplot(weight, x = "group", y = "weight", 
          color = "group", palette=c("#00AFBB", "#E7B800"),
          ylab = "Weight", xlab = "Groups")

# Para evitar a notacao cientifica 
options(scipen = 999)

# Vamos fazer o teste se o peso mediano dos homens eh igual ao
# peso mediano das mulheres

# Hipoteses do teste:

# H0: O peso mediano dos homens eh igual estatisticamente ao peso
#     mediano das mulheres;
# Ha: O peso mediano dos homens nao eh estatisticamente igual ao
#     peso mediano das mulheres

# O teste eh sempre feito com relacao a disposicao no vetor de
# dados, do ultimo para o primeiro - No vetor: Man contra Woman
res <- wilcox.test(weight ~ group, data = weight,
                   exact = FALSE, conf.int=TRUE)
res

# O p-value do teste eh 0,02712, que eh menor que o nivel de
# significancia 0,05. Podemos concluir que o peso mediano dos
# homens eh estatisticamente diferente do peso mediano das
# mulheres (rejeitamos H0).
# O intervalo de confianca da diferenca entre as medianas esta 
# entre 1,20 e 28.20, com uma mediana de 14,60.

# Se quisermos testar se o peso mediano dos homens eh menor
# que o peso mediano das mulheres:

# Hipoteses do teste:

# H0: O peso mediano dos homens nao eh estatisticamente menor que
#     o peso mediano das mulheres;
# Ha: O peso mediano dos homens eh estatisticamente menor que o 
#     peso mediano das mulheres.

# Usamos a seguinte funcao:
wilcox.test(weight ~ group, data = weight, 
            exact = FALSE, alternative = "less", 
            conf.int=TRUE)

# Como p-value > 0.05, aceitamos H0, o peso mediano dos homens 
# nao eh menor que o peso mediano das mulheres
# O intervalo de confianca da diferenca entre as medianas eh um
# valor menor que 26,00, com uma mediana de 14,60

# Se quisermos testar se o peso mediano dos homens eh maior que
# o peso mediano das mulheres:

# Hipoteses do teste:

# H0: O peso mediano dos homens nao eh estatisticamente maior que
#     o peso mediano das mulheres;
# Ha: O peso mediano dos homens eh estatisticamente maior que o 
#     peso mediano das mulheres.

# Usamos a seguinte funcao:
wilcox.test(weight ~ group, data = weight,
            exact = FALSE, alternative = "greater", 
            conf.int=TRUE)

# Como p-value < 0.05, o peso mediano dos homens eh 
# estatisticamente maior que o peso mediano das mulheres 
# (rejeitamos H0).
# O intervalo de confianca para a diferenca entre as medianas eh 
# um valor maior que 3,19 com uma mediana de 14,60

#################################################################