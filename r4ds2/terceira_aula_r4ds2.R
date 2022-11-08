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

#Exemplos de extract e remove

str_extract("Esse texto é importante! O meu número é 1234","(1234)")
str_remove("Esse texto é impotante! O meu número é 1234","(1234)")

#Resultados em funções diferentes

str_detect("Esse texto é impotante! O meu número é 1234","ando")#Retorna FALSE sem encontrar o padrão
str_extract("Esse texto é importante! O meu número é 1234","ando")#Retorna NA sem encontrar o padrão
str_remove("Esse texto é impotante! O meu número é 1234","ando")#Retorna o texto sem encontrar o padrão


# Exemplos com str_subset

str_subset(c("banana", "TANGERINA", "maçã", "lima"), "NA") #Maiúscula

str_subset(c("banana", "TANGERINA", "maçã", "lima"), "^ma")#Início
str_subset(c("banana", "TANGERINA", "maçã", "lima"),"ma$")# Final
str_subset(c("banana", "TANGERINA", "maçã", "lima"),".m")# Qualquer (algo antes do m)


str_extract(c("oii","oiii!","oiii!!!","oioioi!"),"i+!") # 1 ou mais
str_extract(c("oii","oiii!","oiii!!!","oioioi!"),"i+!?") # 0 ou 1
str_extract(c("oii","oiii!","oiii!!!","oioioi!"),"i+!*") # o ou mais
str_extract(c("oii","oiii!","oiii!!!","oioioi!"),"i{1,2}") # Entre m e n

str_extract(c("oii","oiii!","oiii!!!","oioioi!"), "[i!]+")# i(s) ou exclamações [] é ou
str_subset(c("banana", "TANGERINA", "maçã", "lima"),"[a-z]")# Conjuntos (minusculas)
str_extract(c("oii","oiii!","oiii!!!","oioioi!"), "(oi)+") #Tudo
str_extract(c("oii","oiii!","ola!!!","oioioi!"), "(i+|!+)") # Ou


#Escapando

str_replace("Bom dia.", "\\.","!") #Escapando
str_replace("Bom. Dia.", "\\.", "!") # Primeira ocorrência
str_replace_all("Bom. Dia.","\\.","!") #_all trata todas ocorrências
str_remove_all("Bom \"dia\"","\\\"") #Escapando o escape


#Dica geral para extrair vários acentos

stringi::stri_trans_general("Váríôs àçêntõs", "Latin-ASCII")#Remover acentos

str_extract_all("Número: (11) 91234-1234", "[0-9]+") #Números


str_extract("Número: (11) 91234-1234", "[A-Za-z]+") #Pega só o N pq o ú tem acento, é reconhecido como um 
#simbolo diferente

str_extract("Número: (11) 91234-1234", "[:alpha:]+") #Nesse caso pega a palavra com acento

#Colinha do stringr

#https://raw.githubusercontent.com/rstudio/cheatsheets/master/strings.pdf



#Tenho uma lista de emails
library(tidyverse)
texto = c("meu e-mail é fulano@bol.com.br, meu telefone é: (11) 96563-3243 e meu cep é 07642-126",
          "Bom dia!! \n E-mail: ciclana@gmail.com \n Contato: 5322-1234 \n CEP: 05544-147",
          "o telefone é +78(32) 6783-5234, cep: 35687-999, email: contato_56@bla.br. VALEU",
          "Meu.nome@hotmail.com, 943421516, 54869-147")

emails <- tibble(texto)

regex_cep <- "[0-9]{5}-[0-9]{3}"

str_detect("07642-126",regex_cep)

str_extract("07642-126", regex_cep)

regex_email <- "[a-zA-Z0-9_\\.]{1,100}@[a-z]{1,20}(.com)?(.br)?"

str_extract(texto, regex_email)

regex_telefone <- "(\\+[0-9]{2})?(\\([0-9]{2}\\) )?[0-9]{4,5}-?[0-9]{4,5}"



str_extract(texto, regex_telefone)


# duvida: se os textos viessem com "cep" antes, teria um jeito mais facil?

ceps <- c("kajsduibqefbef  iuuhuwhuheuhs cep 05798-927 obg,  hauhauhsuhuhe huahauha cep 00000-111")

ceps |> str_extract("cep .+")|>
  str_remove("cep ")|>
  str_extract("[0-9-]+")


emails |>
  mutate(
    telefone = str_extract(texto, regex_telefone),
    email = str_extract(texto, regex_email),
    cep = str_extract(texto, regex_cep)
  )|> View()

#Cep pegou o telefone para o caso em que o CEP tem o mesmo formato, e agora?

regex_cep <- "[0-9]{5}-[0-9]{3}([^0-9]|$)" # o circunflexo dentro do colchete é a negação daquele colchete
#Qualquer coisa que não seja de 0-9

emails |>
  mutate(
    telefone = str_extract(texto, regex_telefone),
    email = str_extract(texto, regex_email),
    cep = str_extract(texto, regex_cep)
  )|> View()
