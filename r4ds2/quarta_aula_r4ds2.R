#Dúvidas e comentários do inicio da aula

str <- "Uma frase   maluca  
com enter         tabs e pontos,  finais."

stringr::str_view_all(str, "\\b")
stringr::str_view_all(str, "\\B")
stringr::str_view_all(str, "\\w")
stringr::str_view_all(str, "\\W")


str <- "siaiidfsiwsigiiiiiiiiiiiiiiiiiiiii"

stringr::str_extract(str, "i{1,3}")

stringr::str_extract(str, "i{3,}")

#Motivação

# É dificil encontrar um tipo de dados mais delicidado do que
# datas (e horas): diferentemente de textos e erros de encoding,
# erros de locale podem passar despercebidos e estragar uma análise
# inteira.

# Operações com tempo são complicadas, pois envolvem precisão e
# diversos fatores que variam de um lugar para o outro
# (fuso horário, horário de verão, anos bissextos, formato da data, etc.).

# Além das variações normais de como cada país escreve sua datas, cada computador
# tem seu jeito de interpretá-las e cada programa tem seu jeito de salvá-las

# Entender como é a representação de tempo dentro de linguagens de programação
# é muito valioso porque isso é umn problema relevante independentemente
# da ferramenta sendo utilizada.

library(lubridate)

now()

as.numeric(now())


#O formato padrão é denominado "Era UNIX" e conta o número de segundos
#desde o ano novo de 1970 em Londres (01/01/1970 00:00:00 UTC)

#O pacote {lubridate} vai nos possibilitar trabalhar com datas e data-horas do 
#ISO-8601 (ano-mês-dia hora:minuto:segundo)

#Para converter uma data-hora do formato brasileiro para o padrão universal,
#pensamos na ordem das unidades em inglês, day, month, year, hour, minute, 
#second

dmy_hms("15/04/2021 02:25:00")

#Também é possível trabalhar só com datas usando a mesma lógica das unidades

dmy("15/04/2021")

#O lubridade entende datas por extenso

dmy("15 de abril de 2021", locale = "pt_BR.UTF-8") #No win: Portuguese_Brazil.1252
mdy("April 15th 2021", locale = "en_US.UTF-8") #No Win: English (mês-dia-ano)

#Às vezes o Excel salva datas como o número de dias desde 01/01/1970, mas nem isso
#pode vencer o lubridate

as_date(18732)

#Lidando com Fusos

#É mais raro precisar lidar com fusos horários porque normalmente trabalhamos 
#com data-horas de um mesmo fuso, mas o {lubridate} permite lidar com isso também

dmy_hms("15/04/2021 02:25:30", tz = "Europe/London" )

#"2021-04-15 02:25:30 BST" BST = British Summer Time

#Nem o horário de verão consegue atrapalhar um cálculo preciso:
#com a gunção dst() é possível saber se em um dado dia aquele lugar estava
#no horário de verão.

dst(dmy_hms("15/04/2021 02:25:30", tz = "Europe/London"))

dst(dmy_hms("13/10/1989 18:40:00", tz = "America/Sao_Paulo")) #Era horário de verão?

#Operações entre datas

#Com os operadores matemáticos normais, também somos capazes de calcular
#distâncias entre datas e horas

dif <- dmy("13/10/2021") - dmy("12/10/2021")
dif

#Podemos transformar um objeto de diferença temporal em qualquer unidade que
#queiramos usando as funções no plural

as.period(dif) / minutes(1)
as.numeric(as.period(dif))/3600

#Para diferenças entre data-horas pode ser importante usar os fusos

#Outros exemplos

dmy_hms("15/04/2021 02:25:30") # Data-hora

dmy_hm("15/04/2021 02:25") #Sem segundo #Verificar

dmy_h("15/04/2021 02") #Sem minuto

as_datetime(1618453530) #Numérico

mdy_hms("4/15/21 2:25:30 PM") #Americano

dmy_hms("15/04/2021 02:25:30", tz = "Europe/London") #Com fuso

now() - dmy_hms("15/04/2021 02:25:30") #Diferença

now() - dmy_hms("15/04/2021 02:25:30", tz = "Europe/London") #Com fuso


minute("2021-04-15 02:25:30") #Minuto

year("2021-04-15") #Ano

wday("2021-04-15") #dia da semana
#Existe um argumento para mudar o primeiro dia da semana
#pesquisar

month("2021-04-15", label = TRUE, abbr = FALSE) # Mês (sem abrev.)


today() # hoje

today() + months(5) #meses

now() + seconds(5) #segundos

now() + days(5) #dias


as.period(today() - dmy("01/01/2021")) / days(1) #Dia - dia


t1 <- dmy_hms("15/04/2021 02:25:00", tz = "America/Sao_Paulo")
t2 <- dmy_hms("15/04/2021 02:25:00")

t1 - t2


t1 <- dmy_hms("15/04/2021 02:25:00", tz = "America/Sao_Paulo")
t2 <- dmy_hms("15/04/2021 02:25:00", tz = "Europe/London")

t1 - t2
t2 - t1

head(OlsonNames())


#Como não existe o dia 31/02/2021 (fevereiro tem menos dias),
# o {lubridate} simplesmente considera a operação inválida e não
#nos avisa!

x <- ymd("2021-01-31")
x + months(1) 

# No {clock}, 31/01/2021 + 1 mês é um erro que deve ser corrigido

library(clock)

add_months(x, 1) #Erro argumento inválido

#especficando umaestratégia de correção para o argumento invalido
#Nesse caso, overflow irá somar 1 mês e o que sobrar será somado
#em dias no outro mês
add_months(x,1,invalid = "overflow")

#FORCATS

#MOTIVAÇAO
# 
# No R, um dos tipos de dados mais importantes é o fator
# Mas qual é a razão por trás da existência dos fatores?
# Não seria melhor tudo ser string como em outras linguagens?
#   
# A resposta simples é: não. Fatores são a forma do R lidar com variáveis
# categóricas (ordenadas ou não) e eles podem facilitar muito a vida, tanto
# na modelagem quanto na vissualização dos dados. Hoje em dia é menos comum
# ter variáveis  categóricas em uma base do que variávveis textuais, 
# mas isso não quer dizer que fatores não sejam uma ferramenta incrível.
# 
# Para nos ajudar a trablhar com fatores, temo o pacote {forcats}
# (for cateforrical variables). As suas pricipais funções
# servem para alterar a ordem e modificar os níves de um fator


#Introdução

#Por padrão, quando criamos um fator manualmente, a função
# as_factor() recebe strings que denotam as categorias.
# As ategorias são guardadas na ordem em que aparecem
# (o que é diferente do {base})

library(forcats)

x <- as_factor(c("baixo", "medio", "baixo", "alto", NA))
x
#Formalmente, um fator não passa de um 
#vetor numérico com níveis (levels):
#os nomes de cada categoria

typeof(x)


#Vantagens
# 
# 
# Como já aludido, os fatores sã úteis na modelagem estatística:no ANOVA, por exemplo, é útil
# e adequado interpretar um vertor de textos como um vetor de textos como um vetor de
# números inteiros
# 
# Fatores também ocupam significativamente menos espaços em memória do que string
# (quando seu uso for apropriado) já que são armazenados como inteiros,
# mas podem ser trabalhados como strings

x[x != "medio"]
# 
# 
# Mais interessante ainda é trabalhar com fatores ordenados, que
# facilitam a criação de gráficos porque permiem ordenar
# variáveis não - alfabeticamente

#Comparações com textos ordenados, por exemplos os meses do ano
#reconhecidos de forma ordenada de Janeiro a Dezembro em 12 fatores
lubridate::month(Sys.Date(), label = TRUE, abbr = FALSE)

#Remover níveis sem representante
fct_drop(x[x != "medio"])

# Re-rotular os níveis com uma função
fct_relabel(x, stringr::str_to_upper)

#Concatenar fatores

fct_c(x, as_factor(c("altíssimo", "perigoso")))

#Re-nívelar fator (trazer níveis para frente) uso raro

(x2 <- fct_relevel(x, "alto", "medio"))

#Transformar a ordem dos elementos no ordemanento do fator

fct_inorder(x2, ordered = TRUE)

#Transformar a ordem dos níveis no ordenamento do fator

as.ordered(x2)

# Transformar NA em um fator explícito

fct_explicit_na(x, na_level = "(vazio)")

#juntar fatores com poucas ocorrências
fct_lump_min(x, min = 2, other_level = "outros")

#Inverter a ordem dos níveis

fct_rev(x)

#Usar um vetor para reordenar (útil no mutate())

fct_reorder(x, c(2,1,3,10,0), .fun = max)

#Alterar manualmente os níveis
lvls_revalue(x, c("P", "M","G"))

#Alterar manualmente a ordem dos níveis
lvls_reorder(x, c(3,2,1))

starwars |> 
  group_by(sex) |> 
  summarise(n = n()) |> 
  ggplot(aes(sex, n))+
  geom_col()
  theme_minimal()
  
#Um simples gráfico de barras já é ótimo
#para demonstrar o poder do {forcats}
  
#Note que, ao lado, as barras estão ordenadas
#Pela ordem alfabética do sexo
  
#Caso de uso
  
starwars |> 
  mutate(
    sex = as_factor(sex)
  ) |> 
  group_by(sex) |> 
  summarise(n = n()) |> 
  ggplot(aes(sex, n))+
  geom_col()+
  theme_classic()

#Transformano a coluna em fator, agora as
#barras ficam ordenadas pela precedência na coluna


starwars |> 
  mutate(
    sex = as_factor(sex),
    sex = fct_relabel(sex,stringr::str_to_title))|>  
  group_by(sex) |> 
  summarise(n = n()) |> 
  ggplot(aes(sex, n))+
  geom_col()+
  theme_classic()

#transformando com relabel o nome das colunas



starwars |> 
  mutate(
    sex = as_factor(sex),
    sex = fct_relabel(sex,stringr::str_to_title),
    sex = fct_explicit_na(sex, "?")
  ) |> 
  group_by(sex) |> 
  summarise(n = n()) |> 
  ggplot(aes(sex, n))+
  geom_col()+
  theme_classic()
#Fazer com que o NA se torne um fator
#também é simples com fct_explicit_na()


starwars |> 
  mutate(
    sex = as_factor(sex),
    sex = fct_relabel(sex,stringr::str_to_title),
    sex = fct_explicit_na(sex, "?"),
    sex = fct_lump_n(sex, 2)
  ) |> 
  group_by(sex) |> 
  summarise(n = n()) |> 
  ggplot(aes(sex, n))+
  geom_col()+
  theme_classic()

#Se não quisermos todos os níveis, podemos
#agupar os menos frequentes com a familia de funções
#fcl_lump_***()


starwars |> 
  mutate(
    sex = as_factor(sex),
    sex = fct_relabel(sex,stringr::str_to_title),
    sex = fct_explicit_na(sex, "?"),
    sex = fct_lump_n(sex, 2)
  ) |> 
  group_by(sex) |> 
  summarise(n = n()) |> 
  mutate(sex = fct_reorder(sex, n)) |> 
  ggplot(aes(sex, n))+
  geom_col()+
  theme_classic()

#Para ordenar as barras de acordo com outra
#variável, podemos simplesmente usar
# fct_reorder() (trocando o argumento .fun quando necessario)
