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

