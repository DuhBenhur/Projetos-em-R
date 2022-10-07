#Teste t pareado comparando o resultado do connect rate de campanhas de marketing
# Antes e depois de ação de retardo do disparo do banner de aceite dos cookies

#Connect rate por campanha antes do teste
antes <- c(86.07, 92.88, 83.47, 72.66, 101.81, 2.6, 84.77, 108.42, 93.31, 2.48, 0.71)

#Connect rate por campanha após o teste
depois <- c(77.08,83.95,71.25,53.29,80.74,1.63,69.08,88.41,60.50,1.23,0.74)


#Gerando o dataframe
dados <- data.frame(grupo = rep(c("antes","depois"), each = 11),
                    connectrate = c(antes,depois))

#teste de normalidade nos residuos

teste_normalidade <-
  with(dados, connectrate[grupo == "depois"] - connectrate[grupo == "antes"])

shapiro.test(teste_normalidade)
#h0 p-value >= 0.05 distribuição = normal
#h1 p-value < 0.05 distribuição != normal

#No resultado desse teste, não rejeitamos a hipotese nula, pois o p-value = 0.5136

#Com a distribuição aderente a normalidade, podemos realizar o teste t pareado

teste_t2 <- t.test(connectrate ~ grupo, data = dados, paired = T)

teste_t2

Paired t-test

#data:  connectrate by grupo
#t = 4.1769, df = 10, p-value = 0.001897
#alternative hypothesis: true difference in means is not equal to 0
#95 percent confidence interval:
#  5.992293 19.694979
#sample estimates:
#  mean of the differences 
#12.84364 


#Visualização das diferenças no gráfico de boxplot
library(ggpubr)

ggboxplot(dados, x = "grupo",
          y = "connectrate",
          color = "grupo",
          palette = c("#00AFBB", "#E7B800"),
          order = c("antes","depois"),
          ylab = "Connect Rate",
          xlab = "grupo")

library("PairedData")
library("psych")

dados_pareados <- paired(antes,depois)
plot(dados_pareados, type = "profile") + theme_bw()

summary(dados)
describeBy(dados, dados$grupo)
