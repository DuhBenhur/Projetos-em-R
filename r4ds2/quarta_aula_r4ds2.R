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


