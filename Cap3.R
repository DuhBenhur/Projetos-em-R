#Gráficos

library(datasets)
head(airquality)

#hist é uma função gráfica do R base para gerar histogramas
hist(airquality$Temp)

#A função pode receber alguns argumentos para melhorar a vizualização de dados.

hist(airquality$Temp, xlab = "Temperature (Degrees Fahrenheit)",
     main = "Temperatures in New York City May 1 - September 30, 1973")

#Setando o número de barras

hist(airquality$Temp, xlab = "Temperature (Degrees Fahrenheit)",
     main = "Temperatures in New York City May 1 - Semptember 30, 1973",
     breaks = 9)

#Gráfico de densidade, ao invés da frequencia, é registrada
#a probabilidade de que uma temperatura selecionada dos dados esteja nesse intervalo.
#Adicionar o parametro probability

hist(airquality$Temp, xlab = "Temperature (Degrees Fahrenheit)",
     main = "Temperatures in New York City May 1 - Semptember 30, 1973",
     probability = TRUE)

#Adicionar linha ao gráfico de densidade
lines(density(airquality$Temp))

#Grafico de barras

#Variavel X categórica

library(MASS)
head(Cars93[1:13])

#Tabela de frêquencias

table(Cars93$Type)
table(Cars93$Manufacturer)

#Gráfico de barras

barplot(table(Cars93$Type))

#Adicionando argumentos ao barplot

barplot(table(Cars93$Type), ylim=c(0,25), xlab="Type", ylab="Frequency",
        axis.lty = "solid",
        space = .5)
#onde ylim altera o limite do eixo Y para 25, sendo assim a barra Midsize não vai além do
#limite

library(dplyr)

carros <- Cars93
carros_americanos <- filter(carros, Origin == "USA")

#Gráfico carros americanos

barplot(table(carros_americanos$Type), ylim=c(0,13), xlab = "Type",
        ylab = "Frequency", axis.lty = "solid",
        space = .3)
title(main = "Carros Americanos por Tipo", font.main = 28)

carros_non_americanos <- filter(carros, Origin == "non-USA")


barplot(table(carros_non_americanos$Type), ylim = c(0,18),
        xlab = "Type", ylab = "Frequency", axis.lty= "solid", space= .4)
title(main = "Carros Não Americanos por Tipo")

barplot(table(carros$Cylinders), ylim = c(0,60),
        xlab = "Cylinders", ylab = "Frequency", axis.lty= "solid", space= .4)
title(main = "Carros por quantidade de cilindros", font.main = 28)


#Quantidade de Airbags

barplot(table(carros$AirBags), ylim = c(0,55),
        xlab = "Airbags", ylab = "Frequency", axis.lty = "solid",
        space = .5)
title(main = "Carros Por Quantidade de Airbags", font.main = 28)


#Carros por tipo de tração

barplot(table(carros$DriveTrain), ylim = c(0,70),
        xlab = "Tipo de Tração",
        ylab = "Quantidade", axis.lty = "solid",
        space = .5)
title(main = "Carros Por Tipo de Tração", font.main = 25)

#Agrupando barras


cores <- HairEyeColor
cores

females <- cores[,,2]
females


nome.cores = c("black", "grey40", "grey80", "white")

barplot(t(females), beside=T, ylim = c(0,70), xlab = "Hair Color",
        ylab = "Frequency of Eye Color", col=nome.cores, axis.lty = "solid")
#beside permite que as barras sejam agrupadas lado a lado
#sem esse parametro, veriamos um gráfico de composição (colunas empilhadas)


#Inserindo a legenda

legend("topleft", rownames(t(females)), cex = 0.8, fill=nome.cores,
       title = "Eye Color")

#primeiro argumento referencia a posição da legenda
# segundo fornece os nomes
#terceiro especifica o tamanho do caracteres (80% do tamanho normal)
# o quarto fornece as cores para amostra de cores
# ultimo, titulo