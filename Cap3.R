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

#Projeto Rápido Sugerido 3.1

#Alterar a cor das legendas para refletir as cores reais

#obter todas cores do R
colors()

#função de pesquisa grep para buscar as cores que tenham o argumento no nome (nesse caso brown)
colors()[grep("brown",colors())]

novas_cores <- c("brown4","dodgerblue1","sandybrown","limegreen")

barplot(t(females), beside=T, ylim = c(0,70), xlab = "Hair Color",
        ylab = "Frequency of Eye Color", col=novas_cores, axis.lty = "solid")


#Projeto Rápido Sugerido 3.2

tipo_origem <- subset(carros,
                      select = c("Type", "Origin"))

cores_carros <- c("blue","grey70")

barplot(t(table(tipo_origem)), beside=T, ylim = c(0,15), xlab = "Type",
        ylab = "Frequency", col=cores_carros, axis.lty = "solid")
legend("topright", rownames(t(table(tipo_origem))), cex = 0.8, fill=cores_carros,
       title = "Origem")

#Graficos de pizza

pie(table(carros$Type), labels = carros$Type)


#Grafico de dispersão

#o parametro pch indica o tipo de ponto que será exibido no gráfico
plot(airquality$Wind, airquality$Temp, pch=16,
     xlab = "Wind Velocity (MPH)",
     ylab = "Temperature (Fahrenheit)",
     main = "Temperatire vs Wind Velocity")


#Temperatura dependente da velocidade do vento (nao tem diferença em relação ao gráfico da linha 160)
plot(airquality$Temp~airquality$Wind,pch=16,
     xlab = "Wind Velocity (MPH)",
     ylab = "Temperature (Fahrenheit)",
     main = "Temperature vs Wind Velocity")


#Relação entre temperatura e mês do ano

plot(airquality$Temp~airquality$Month, pch=16,
     xlab = "Month of the year",
     ylab = "Temperature (Fahrenheit)",
     main = "Temperature vs Month")

#Matriz de dispersão

#Criação do subconjunto

Ozone_Temp_Wind <- subset(airquality,
                          select = c(Ozone,Temp,Wind))

#Desenhando a matriz

pairs(Ozone_Temp_Wind)

#Boxplot

boxplot( Temp ~ Month, data = airquality, xaxt = "n")

# O terceiro arumento xaxt suprime os rótuos que pararecem do eixo x
# (5,6,7,8 e 9 ) que represantam os meses, ao invés disso, pode-se usar

axis(1, at=1:5, labels=c("Maio", "Junho","Julho", "Agosto", "Setembro"))
