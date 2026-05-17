##################
# Trabalho STA1
#
# G13
##################
# Setar diretorio de trabalho
setwd("D:\\jleitao\\Documents\\Curso UFPR\\IAA-004 - EST1\\trabalho")

# Instalando pacotes
# install.packages("dplyr")
# install.packages("ggpubr")
library(tidyr)
library(ggpubr)
library(ggplot2)
library(fdth)


# Carregar base de dados
load("salarios.RData")


# Configurando para nao aparecer notacao cientifica nos
# resultados
options(scipen = 999)

# 1 Gráficos e tabelas

# 1.a Elaborar os gráficos box-plot e histograma das variáveis “age” 
# (idade da esposa) e “husage” (idade do marido) e comparar os resultados

# Ajustar para os dados ficarem em um coluna
salarios_long <- pivot_longer(
  salarios,
  cols = c(age, husage),
  names_to = "variavel",
  values_to = "idade"
)
# Gerar o boxplot usando a funcao ggboxplot
ggboxplot(
  salarios_long,
  x = "variavel",
  y = "idade",
  color = "variavel",
  palette = c("pink", "lightblue"),
  ylab = "Idade",
  xlab = "",
  title = "Boxplot das idades"
)

# Gerar o histograma
par(mfrow = c(1, 2))

hist(salarios$age,
     main = "Histograma da idade das esposas",
     xlab = "Idade",
     col = "pink",
     border = "black")

hist(salarios$husage,
     main = "Histograma da idade do marido",
     xlab = "Idade",
     col = "lightblue",
     border = "black")

# 1.b Elaborar a tabela de frequencias das variáveis “age” (idade da esposa) 
# e “husage” (idade do marido) e comparar os resultados
table_age <- fdt(salarios$age)
table_husage <- fdt(salarios$husage)

print(table_age)
print(table_husage)

# 2 Medidas de posição e dispersão

# 2.a Calcular a média, mediana e moda das variáveis “age” (idade da esposa) 
# e “husage” (idade do marido) e comparar os resultados

# Media
mean_esp <- mean(salarios$age)
mean_mar <- mean(salarios$husage)

print(paste0( "A media da idade das esposas eh ", round(mean_esp),2))
print(paste0( "A media da idade dos maridos eh ", round(mean_mar),2))
print(paste0("A media de idade dos maridos eh ",
             round(((mean_mar/mean_esp)-1)*100, 2),
             "% ",
             "Superior a das esposas")) 
# Mediana
med_esp <- median(salarios$age)
med_mar <- median(salarios$husage)

print(paste0( "A mediana da idade das esposas eh ", med_esp))
print(paste0( "A mediana da idade dos maridos eh ", med_mar))
print(paste0("A mediaana de idade dos maridos eh ",
             round(((med_mar/med_esp)-1)*100, 2),
             "% ",
             "Superior a das esposas")) 
# Moda
# Para a idade dos maridos 
tab_mar <- table(salarios$husage)
mod_mar <- as.numeric(names(tab_mar)[tab_mar == max(tab_mar)])

# Para a idade das esposas
tab_esp <- table(salarios$age)
mod_esp <- as.numeric(names(tab_esp)[tab_esp == max(tab_esp)])

print(paste0( "A moda da idade das esposas eh ", mod_esp))
print(paste0( "A moda da idade dos maridos eh ", mod_mar))

print(paste0("A moda de idade dos maridos eh ",
             round(((mod_mar/mod_esp-1)*100), 2),
             "% ",
             "Superior a das esposas"))

# 2.b Calcular a variância, desvio padrão e coeficiente de variação das
# variáveis “age” (idade da esposa) e “husage” (idade do marido) e comparar
# os resultados

# Variancia
var_esp <- var(salarios$age)
var_mar <- var(salarios$husage)

print(paste0( "A variancia da idade das esposas eh ", round(var_esp,2)))
print(paste0( "A variancia da idade dos maridos eh ", round(var_mar,2)))
print(paste0("A variancia de idade dos maridos eh ",
             round(((var_mar/var_esp)-1)*100, 2),
             "% ",
             "Superior a das esposas"))

# desvio padrao
sd_esp <- sd(salarios$age)
sd_mar <- sd(salarios$husage)

print(paste0( "O desvio padrao da idade das esposas eh ", round(sd_esp,2)))
print(paste0( "O desvio padrao da idade dos maridos eh ", round(sd_mar,2)))
print(paste0("O desvio padrao da idade dos maridos eh ",
             round(((sd_mar/sd_esp)-1)*100, 2),
             "% ",
             "Superior a das esposas"))

# Coeficiente de variacao
cv_esp <- sd_esp/mean_esp
cv_mar <- sd_mar/mean_mar

print(paste0( "O coeficiente de variacao da idade das esposas eh ", round(cv_esp,2)))
print(paste0( "O coeficiente de variacao da idade dos maridos eh ", round(cv_mar,2)))
print(paste0("O coeficiente de variacao da idade dos maridos eh ",
             round(((cv_mar/cv_esp)-1)*100, 2),
             "% ",
             "Superior a das esposas"))

# 3 Testes paramétricos ou não paramétricos
# 
# 3.a Testar se as médias (se você escolher o teste paramétrico) ou as medianas 
# (se você escolher o teste não paramétrico) das variáveis “age” (idade da 
# esposa) e “husage” (idade do marido) são iguais, construir os intervalos 
# de confiança e comparar os resultados. 

# A decisão de usar um tipo de teste ou outro depende da natureza das amostras  
# Se forem normalmente distribuidas é melhor o teste paramétrico  
# Primeiro verificamos se as amostras seguem uma distribuição normal

# o teste de shapiro do R limita a 5000 amostras e o nosso dataset possui
length(salarios$age)
# 5634, então usamos 5000 amostras

x1 <- sample(salarios$age, 5000)

results <- shapiro.test(x1)
print(results)

# como p-value foi menor que 0.05 essa amostra não é normalmente distribuida

x2 <- sample(salarios$husage, 5000)
results <- shapiro.test(x2)
print(results)

# Mostrando através de q-q plots
par(mfrow = c(1,2))

qqnorm(salarios$age,
       main = "QQ-plot Esposas")
qqline(salarios$age, col = "red")

qqnorm(salarios$husage,
       main = "QQ-plot Maridos")
qqline(salarios$husage, col = "red")

# o p-value das duas amostras indica que ambas não possuem distribuição normal
# a alternativa é usar testes não parametricos como o teste U de Mann-Whitney
# e verificar as medianas
# jah sabemos que 
print(paste0( "A mediana da idade das esposas eh ", med_esp))
print(paste0( "A mediana da idade dos maridos eh ", med_mar))

# Hipoteses do teste:

# H0: a idade mediana dos maridos é igual estatisticamente a idade mediana das
#     esposas;
# Ha: a idade mediana dos maridos não é igual estatisticamente a idade mediana das
#     esposas;

# O teste eh sempre feito com relacao a disposicao no vetor de
# dados, do ultimo para o primeiro - No vetor: Man contra Woman

res <- wilcox.test(x=x2, y=x1,
                   exact = FALSE, conf.int=TRUE)
print(res)

# O p-value foi menor 0.05 então rejeitamos a hipotese nula que as medianas das
# idades dos maridos é igual a mediana da idade das esposas.

# Intervalo de confiança [2, 3] não inclui o zero
# Portanto existe diferença significativa entre as medianas
