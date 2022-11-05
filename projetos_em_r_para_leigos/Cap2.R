#Aprendizados do livro - Cap 2
library(datasets)

library(MASS)

#Primeiras linhas do dataframe
head(airquality)

#Ultimas linhas do dataframe
tail(airquality)


#Média do campo Ozônio sem tratar dados ausentes
mean(airquality$Ozone)

#Média do campo Ozônio tratando dados ausentes

mean(airquality$Ozone, na.rm = TRUE)

#rm = remova

#Subconjuntos de dados

month.day.ozone <- subset(airquality,
                          select = c(Month, Day,Ozone))

#Subset é uma função do R base e serve para retornar
#seleções parcial de vetores, matrizes e data frames
#A função select nesse caso, é um parametro de subset e indica
#  o vetor de colunas que se quer trabalhar


#Selecionando linhas com subset

August.Ozone <- subset(airquality, Month == 8, 
                       select = c(Month, Day, Ozone))




#Estrutura básica de uma fórmula no R

#function(dependent_var ~ independent_var, data = data.frame)

analysis <- lm(Temp ~ Month, data = airquality)

#Embora o livro no aborde, essa é a construção básica de 
#uma regressão linear simples e exige alguns pressupostos 
#antes de sair rodando, tenha calma.

summary(analysis)

#O Resultado de summary é uma lista

s <- summary(analysis)

#Todos coeficientes
s$coefficients

#Estimativa  para o mês
s$coefficients[2,1]

#Temp = 58.211212 + (2.81*Month)

#A temperatura aumenta a uma taxa de 2.81 graus por mês

#Explorando o tidyverse

library("tidyverse")

#um dos pacotes components do tidyverse é o tidyr
#Uma de suas funções extremamente úteis é a chamada de drop_na()

aq.no.missing <- drop_na(airquality)

head(aq.no.missing)

#Função filter 
filter(aq.no.missing, Day == 1)

