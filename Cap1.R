#Vetor
x <- c(5,10,15,20,25,30,35,40)

#Saída do vetor x
x

#Leitura de objetos no ambiente
ls()

#Soma dos valores no vetor

sum(x)

#Variância é uma medida de quanto um conjunto de números difere de sua média.

var(x)

#Criando vetor com a função seq() - Sequence Generation

y <- seq(5,40,5)
y
#Se or argumentos forem nomeados, não importa a ordem

z <- seq(to=40, by=5, from=5)
z

#Help sobre funcões
?seq()

#Funções definidas pelo usuário

hypotenuse <- function(a,b){
  hyp <- sqrt(a^2+b^2)
  return(hyp)
}

#chamando a função e passando os argumentos
hypotenuse(3,4)


#Estruturas

#Vetor de caracteres

beatles <- c("john", "paul", "george", "ringo")
beatles

#Vetor Lógico
w <- c(T,F,T,T,F)

#Componente do Vetor

beatles[2]
beatles[1]
beatles[0] #Diferente do python, o primeiro componente de um vetor é 1


beatles[2:3]

#Componentes não consecutivos
beatles[c(2,4)]

#Vetor númérico elementos aumentam em 1

s <- 5:45
s

#Vetor de valores repetidos

v1 <- c(7,8,4,3)
repeated_v1 <- rep(v1,3)
repeated_v1
v1

#Usando um vetor como argumento para repetição

v2 <- c(1,3,5,8) # O número de componentes do vetor de repetição, precisa necessariamente,
#ser igual ao número de componentes do vetor repetido.

repeated_v1_v2 <- rep(v1,v2)
repeated_v1_v2

#Adicionando ao vetor append

ss <- c(1,2,3,5,8)
ss <- append(ss,13)
ss

#Adicionando no inicio do vetor prepend

ss < prepend(ss,0) # Não funcionou no R base, talvez (?rlang::lifecycle)
ss

#Quantidade de itens em um vetor

length(ss)
ss


#Matrizes

#Criando matriz partindo de um vetor

num_matriz <- seq(5,100,5)
num_matriz

#A função dim() pode transformar um vetor em uma matriz bidimensional

dim(num_matriz) <- c(2,10)

num_matriz

num_matriz_2 <- matrix(seq(5,100,5), nrow = 2)
num_matriz_2

num_matriz_2[1,6]

#Listas
# Em R, uma lista é uma coleção de objetos que não são necessariamente
#do mesmo tipo.

beatles
ages <- c(17,15,14,22)

#Combinando informações na lista list()

b_info <- list(names=beatles, age_joined = ages)

b_info

#Selecionando elemento dentro da lista

b_info$names
b_info$age_joined
b_info$names[3]

b_info$names[b_info$age_joined <= 14]


#Data Frame
names <- c("al","barbara","charles","donna","ellen","fred")
height <- c(72,64,73,65,66,71)
weight <- c(195,117,205,122,125,199)
gender <- c("M","F","M","F","F","M")

factor_gender <- factor(gender)
factor_gender

#A funcao data.frame() trabalha com vetroes para criar um dataframne
d <- data.frame(names,factor_gender,height,weight)
d

#Altura da terceira pessoa

d[3,3]

# Todas informações da quinta pessoa

d[5,]

#Altura média

mean(d$height)

#critérios

mean(d$heigth[d$factor_gender == "M"])


#Outras formas
#Acessar componente do dataframe sem $

with(d,mean(height[factor_gender == "F"]))

#É equivalente a
mean(d$height[d$factor_gender == "F"])

#Quantas linhas no dataframe

nrow(d)

#E quantas colunas

ncol(d)

#Adicionando colna com cbind()

aptitude <- c(35,20,32,22,18,15)

d.apt <- cbind(d,aptitude)
d.apt

# Loops for e instruções if

#Formado geral do loop for

#for counter in star:end{
#  statement 1
#  statement n
#}
#O counter controla as iterações

#O formato geral mais simples de uma instrucao if é

if(test){ declaracao para executar se o teste for verdadeiro}
else {declaracao para executar se o teste for falso}

xx <- c(2,3,4,5,6)
xx
yy <- NULL

# Testar para ou impar mod no R é %%

10%%3

5%%2

4%%2

# if xx[i] %% 2 == 0 entãoo xx[i] é par

#loop for e instrução if

for(i in 1:length(xx)){
  if(xx[i] %% 2 == 0){yy[i] <- "EVEN"}
  else{ yy[i]<- "ODD"}}
  


yy
###Final capitulo 1