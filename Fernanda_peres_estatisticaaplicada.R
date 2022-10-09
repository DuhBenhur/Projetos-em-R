
#Exercicios baseados na playlist Curso de Estatística Aplicada no R
#Autor: Fernanda Peres
#link: https://www.youtube.com/playlist?list=PLOw62cBQ5j9VE9X4cCCfFMjW_hhEAJUhU

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




# Teste-T Pareado ---------------------------------------------------------

pacotes <- c("dplyr","psych")

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


dados2 <- read.csv('Banco de Dados 4.csv', sep = ';' , dec = ',') %>% 
  rename(Convulsoes_PT = Convulsões_PT, Convulsoes_S1 = Convulsões_S1,
         Convulsoes_S6= Convulsões_S6, Genero = Gênero, ID_Medico = ID_Médico)

View(dados2)
glimpse(dados2)


#Verificação da normalidade

dados2$DiferencaPTS1 <- dados2$Convulsoes_PT - dados2$Convulsoes_S1

#Como estamos usando um teste-t pareado o pressuposto não é que a duas variaveis tenham distribuição normal
#Mas sim que a diferença entre as variaveis tenham distribuição normal.

shapiro.test(dados2$DiferencaPTS1)

#Verificação da normalidade dos dados
#Shapiro por grupo (pacote RVAideMemoire)

# O teste de Shapiro-wilk tem como h0 que a distribuição dos dados é normal

#H0: distribuição dos dados = normal p > 0,05
#H1: distribuição dos dados != normal p <= 0,05

#A distribuição dos dados não são normal

#3 opções caso a distribuição não seja normal

# 1 - Seguir com o teste-t pareado pois muitas referências sugerem que o teste-t pareado é robusto a violações da normalidade
#(Opção 1 não é recomendada)

# 2 - Transformar os dados, trabalhar com logaritmo dos dados forçando a normalidade

# 3 - Utilizar um teste não parametrico onde o pressuposto da normalidade não é necessário.



#Realização do teste t pareado

t.test(dados2$Convulsoes_PT, dados2$Convulsoes_S1, paired = TRUE)


#O teste-t pareado mostrou que a média de convulsões na primeira semana é diferente
#da média de convulsões pré-tratamento (t(274) = 3,68; p < 0,001). A média de convulsões da 
#primeira semana foi inferiro à média da semana pré-tratamento.

#Visualização da distribuição dos dados

par(mfrow=c(1,2))
boxplot(dados2$Convulsoes_PT, ylab = "Quantidade de Convulsões", xlab = "Pré-Tratamento")
boxplot(dados2$Convulsoes_S1, ylab = "Quantidade de Convulsões", xlab = "1ª semana de Tratamento")

#A escala não fica ok com mfrow

#Analise descritivaa dos dados

summary(dados2$Convulsoes_PT)
summary(dados2$Convulsoes_S1)


describe(dados2$Convulsoes_PT)
describe(dados2$Convulsoes_S1)



# ANOVA de uma via --------------------------------------------------------

# A ANOVA de uma via é um teste estatístico que permite a comparação das médias de mais de 2 grupos

# O teste-t para amostras independentes, permite a comparação das médias para 2 grupos independentes.
# A ANOVA de uma via é como se fosse uma extensão do teste-t para amostras independentes, permitindo a 
# comparação de mais de 2 grupos independentes.

#Passos do estudo. 

# Verificar a normalidade por grupo (teste de Shapiro-Wilk);
# Verificar a homogeneidade de variâncias (teste de Levene);
# Verificar a presença de outliers (boxplot e função);
# Fazer a ANOVA de 1 via;
# Fazer diferentes tipos de post-hoc (Duncan, Bonferroni, Tukey HSD);
# Pedir a estatística descritivaa dos dados

pacotes <- c("dplyr","psych","car","RVAideMemoire","rstatix","DescTools")

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


dados <- read.csv2('Banco de Dados 5.csv')
glimpse(dados)

# Verificação da normalidade dos dados
#Shapiro por grupo (pacote RVAdeMemoire)
#Alternativas: Fazer um teste não paramétrico ou fazer a transformação dos dados.

byf.shapiro(BC ~ Grupo, dados)
#placebo não passou no teste de normalidade

byf.shapiro(Pressao ~ Grupo, dados)

#Verificação da homogeneidade de variancias

leveneTest(BC ~ Grupo, dados, center=mean)
leveneTest(Pressao ~ Grupo, dados, center=mean)

#Observação
#Por default, o teste realizado pelo pacote car tem como base a mediana(median)
# O teste baseado na mediana é mais robusto
# Mudamos para ser baseado na média (comparável ao SPSS)

#Verificação da presença de outliers (por grupo) - Pacotes dplyr e rstatix

#Para BC:
dados %>% 
  group_by(Grupo) %>% 
  identify_outliers(BC)

#pelo boxplot

boxplot(BC ~ Grupo, data = dados, ylab = "Frequência cardíaca(bps)", xlab = "Tratamento")

#Para Pressão:
dados %>% 
  group_by(Grupo) %>% 
  identify_outliers(Pressao)

#pelo boxplot

boxplot(Pressao ~ Grupo, data = dados, ylab = "Frequência cardíaca(bps)", xlab = "Tratamento")

#Realização da ANOVA

#Criação do modelo para BC
anova_BC <- aov(BC ~ Grupo, dados)
summary(anova_BC)

#H0: média do grupo A = média do grupo B = média do grupo C -> p > 0.05
#H1: há pelo menos uma diferença entre as médias dos grupos -> p <= 0.05


#Criação do modelo para Pressão
anova_Pressao <- aov(Pressao ~ Grupo, dados)
summary(anova_Pressao)


#O resultado da ANOVA indicou que existem diferenças entre as médias dos grupos, mas 
#não sabemos em qual grupo está a diferença.

#Análise post-hoc 
#Post-hocs permitidos: "hsd", "bonferroni", "lsd", "scheffe", "newmankeuls", "duncan"

#Observação

#Existe uma quantidade muito grande de testes de post-hocs no mundo
# O adequado vai depender da necessidade de pesquisa
# Em geral os testes de post-hoc podem ser divididos em testes mais liberais e mais conservadores

#Os testes mais liberais, corrigem menos, então é mais provavel que se encontre diferenças
# em testes mais liberais e menos provavel que se encontre diferenças em testes mais conservadores. 

#Os testes mais liberais cometem mais erros do tipo 1: Dizer que uma coisa é significante quando na verdade
#ela não é

#Isso depende muito do seu desenho experimental, dependendo da sua pergunta, vocè pode cometer erro do tipo
# 1 mas não pode cometer erro do tipo 2 e vice-versa

# O ideal é usar um post-hoc equilibrado, nem tão liberal e nem tão conservador

# vamos fazer 3

# Um liberal: duncan
# Um moderado: TukeyHSD (HSD = Diferença Significante Honesta )
# Um Conservador: Bonferroni

#Uso do Duncan
PostHocTest(anova_BC, method = "duncan", conf.level = 0.95)


#Uso do TukeyHSD
PostHocTest(anova_BC, method = "hsd", conf.level = 0.95)


#Uso do Bonferroni
PostHocTest(anova_BC, method = "bonf", conf.level = 0.95)

#É o mesmo que:

pairwise.t.test(dados$BC, dados$Grupo, p.adj = "bonferroni", paired = F)

#Exemplo de como resumir em uma tabela mais de um post-hoc

round(
  cbind(duncan = PostHocTest(anova_BC, method = "duncan")$Grupo[,"pval"],
        bonf = PostHocTest(anova_BC, method = "bonf")$Grupo[,"pval"],
        hsd = PostHocTest(anova_BC, method = "hsd")$Grupo[,"pval"]),6)


#para pressão

#Uso do TukeyHSD
PostHocTest(anova_Pressao, method = "hsd", conf.level = 0.95)


#Analise descritiva dos dados

describeBy(dados$BC, group = dados$Grupo)
describeBy(dados$Pressao, group = dados$Grupo)

#Descrevendo resultados da ANOVA para pressão

#A ANOVA de uma via mostrou que há efeito do tratamento sobre a média de pressão 
#arterial [F(2,28) = 5,521; P = 0,0095]. O post-hoc Tukey HSD mostrou que há
#diferenças entre o grupo placebo e o grupo anti-hipertensivo padrão, mas nao entre os demais
#grupos
summary(anova_Pressao)

