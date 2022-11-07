# Omitir valores NA em vetores

v <- c(1,2,3,NA,4)
v |>
  na.omit(v) |> 
  as.numeric()

#Com pacote purrr

c(1,2,3,NA,4) |>
  purrr::discard(is.na) #Talvez esse não seja o método que o R prefere para vetores


#Motivação

#Bases com colunas em texto já são extremamente comuns hoje em dia, então saber lidar 
#com etrings se torna essencial na caixa de ferramentas do cientista de daods

#Além de ajudar em análise de dados, tratar strings ajuda com programação
#porque grande parte das linguagens modernas funcionamda mesma maneira que o R
#nesse quesito.

#O conhecimento de expressões regulares vale para a vida, é impossível descrever
#com poucas palavras todas as coisas que são implementáveis via regex

#Normalmente os textos são bagunçados, independentemente do quão cuidadosa foi
#a coleta de dados, então precisamos arrumá-los; podemos fazer isso do jeito fácil
#({stringr} e regex) ou do jeito difícil ({base}e lágrimas ) hauhauhaua


#Strings não passam de sequências de caracteres ("cadeias" em português)

#No R podemos criar uma string com um par de aspas(simples ou duplas)

#O print() mostra a estrutura da string, enquanto cat()mostra o texto

print("etc! Está 10\u00BAC lá fora")

#Para colocar aspas dentro de uma string, podemos escapas o caractere

cat("Ele disse \"escapar\"")


#O pacote {stringr} é a forma mais simples de trabalhar com strings no R

library(stringr)

abc <- c("a", "b", "c")
str_c("prefixo-", abc,"-sufixo")


#Todas as funções relevantes começam com str_e funcionam bem juntas

abc |>
  str_c("-sufixo")|>
  str_length()


#Encontrando padrões
str_detect("Colando Strings", pattern = "ando")

#Extraindo trecho padrão

str_extract("Colando Strings", pattern = "ando")

#Substituindo padrões

str_replace("Colando Strings", pattern = "ando", replacement = "ei")


#Removendo padrões

str_remove("Colando Strings", pattern = "Strings") %>% 
  str_squish() #A função trimws(), não ajusta espaços no meio, apenas no começo e no final


#Regex

#Expressões regulares "são "programação pa strings", permitindo extrair padrões
#bastante complexos com comandos simples

#Elas giram em torno de padrões "normais" de texto, mas com alguns símbolos especiais
#com significados específicos

frutas <- c("banana", "TANGERINA", "maçã", "lima")

str_detect(frutas, pattern = "na")

#Exemplo . (qualquer caractere), ^ (início da string) e $(fim da string)

str_detect(frutas, pattern = "^ma")


#Podemos contar as ocorrências de um padrão: + (1 ou mais vezes), *(0 ou mais vezes),
#{m,n} (entre m e n vezes).? (0 ou 1 vez)


ois <- c("oi","oii","oiii!","oioioi!")

str_extract(ois, pattern = "i+")

#[] é um conjunto e () é um conjunto "inquebrável

str_extract(ois, pattern = "[i!]$")#i ou exclamação no final da string


str_extract(ois, pattern = "(oi)+")#o seguido de i 

# Se de fato precisarmos encontrar um dos caracteres reservados descritos 
#anteriormente, precisamos escapá-los da mesma forma como vimos antes

str_replace("Bom dia.", pattern = ".", replacement = "!")

str_replace("Bom dia.", pattern = "\\.", replacement = "!")

#Não esquecer que algumas funções do {stringr} possuem variações

str_replace_all("Bom. Dia.", pattern = "\\.", replacement = "!")
