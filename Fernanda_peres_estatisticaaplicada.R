
# Teste-t para duas amostras independentes ---------------------------------------------------



#Verificar se há efeito da posição que o aluno ocupa na sala
#(se "Frente" ou "Fundo") sobre as suas notas de Biologia, Física e História.
#Descreva os resultadso de forma apropriada.


#Carregando os pacotes
pacotes <- c("dplyr","RVAideMemoire","car")

if(sum(as.numeric(!pacotes %in% installed.packages())) != 0){
  instalador <- pacotes[!pacotes %in% installed.packages()]
  for (i in 1:length(instalador)){
    install.packages(instalador, dependencies = T)
    break()
  }
  sapply(pacotes, require, character = T)
}else{
  sapply(pacotes, require, character = T)
}

#Carregando a base de dados
dados <- read.csv('Banco de Dados 3.csv', sep = ';' , dec = ',')
View(dados)
glimpse(dados)

dados$Genero <- as.factor(dados$Genero)
dados$Escola <- as.factor(dados$Escola)
dados$Posicao_Sala <- as.factor(dados$Posicao_Sala)

#Verificação da normalidade dos dados
#Shapiro por grupo (pacote RVAideMemoire)

# O teste de Shapiro-wilk tem como h0 que a distribuição dos dados é normal

#H0: distribuição dos dados = normal p > 0,05
#H1: distribuição dos dados != normal p <= 0,05

byf.shapiro(Nota_Biol ~ Posicao_Sala, dados)

byf.shapiro(Nota_Fis ~ Posicao_Sala, dados)

byf.shapiro(Nota_Hist ~ Posicao_Sala, dados)

# Os dados são aderentes a normalidade


#Verificação da homogeneidade de variâncias - Teste de Levene

#H0: as variâncias dos grupos são homogêneas p > 0.05

#H1: as variâncias dos grupos não são homogêneas p <= 0.05

#Teste baseado na mediana

leveneTest(Nota_Biol ~ Posicao_Sala, dados)
leveneTest(Nota_Fis ~ Posicao_Sala, dados)
leveneTest(Nota_Hist ~ Posicao_Sala, dados)

#Teste baseado na média

leveneTest(Nota_Biol ~ Posicao_Sala, dados, center = mean) #variancia dos grupos para nota de Biologia, são homogeneas
leveneTest(Nota_Fis ~ Posicao_Sala, dados, center = mean) #variancia dos grupos para nota de Fisica, não são homogeneas
leveneTest(Nota_Hist ~ Posicao_Sala, dados, center = mean) #variancia dos grupos para nota de Historia, não são homogeneas

#Two Sample t-test

#H0: média do grupo A = média do grupo B p > 0.05
#H1: média do grupo A = média do grupo B p > 0.05

t.test(Nota_Biol ~ Posicao_Sala, dados, var.equal = TRUE) #Teste t para variancias homogeneas
t.test(Nota_Fis ~ Posicao_Sala, dados, var.equal = FALSE) #Teste t para variancias não homogeneas
t.test(Nota_Hist ~ Posicao_Sala, dados, var.equal = FALSE)#Teste t para variancias não homogeneas

#O teste-t para duas amostras independentes, mostrou que há efeito da posição na sala sobre a nota de física
#(t(17,68) = 4,44, p < 0,001).
#O grupo que sente na frente da sala apresentou, em média, notas de física superiores às do grupo que senta
#nos fundos da sala

#Existem diferenças na média dos grupos

#Visualização da distribuição dos dados

par(mfrow = c(1,3)) #Estabeleci que quero que os dados saiam na mesma linha
boxplot(Nota_Biol ~ Posicao_Sala, data = dados, ylab = "Notas de Biologia", xlab = "Posicão na Sala")
boxplot(Nota_Fis ~ Posicao_Sala, data = dados, ylab = "Notas de Física", xlab = "Posicão na Sala")
boxplot(Nota_Hist ~ Posicao_Sala, data = dados, ylab = "Notas de História", xlab = "Posicão na Sala")

referencias <- c(
  "REFERÊNCIAS BIBLIOGRÁFICAS:

Artigo (em português) comparando os testes de normalidade (e concluindo que o Shapiro-Wilk é superior aos demais, mesmo em amostras menores), e sugerindo avaliar a normalidade da variável dependente por grupo:
Leotti, V. B., Coster, R., & Riboldi, J. (2012). Normalidade de variáveis: métodos de verificação e comparação de alguns testes não-paramétricos por simulação. Revista HCPA. Porto Alegre. Vol. 32, no. 2 (2012), p. 227-234.",
  "Artigo (em inglês) comparando os testes de normalidade, e concluindo que o Shapiro-Wilk é o que tem maior poder:
Razali, N. M., & Wah, Y. B. (2011). Power comparisons of Shapiro-Wilk, Kolmogorov-Smirnov, Lilliefors and Anderson-Darling tests. Journal of statistical modeling and analytics, 2(1), 21-33.",
  "Artigo (em português) discutindo as alternativas a situações em que os dados não apresentam distribuição normal:
Paes, A. T. (2009). O que fazer quando a distribuição não é normal. Einstein–Educação continuada em Saúde, 7, 1.",
  "Artigo (em inglês) discutindo que os testes paramétricos são razoavelmente robustos a violações da normalidade quando o n é grande:
Lumley, T., Diehr, P., Emerson, S., & Chen, L. (2002). The importance of the normality assumption in large public health data sets. Annual review of public health, 23(1), 151-169.
"
)
length(referencias)
