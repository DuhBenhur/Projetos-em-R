library(dplyr)
library(tidyr)
#O Pacote tidyr possui funções que nos ajudam a deixar uma base bagunçada
#em uma base tidy. Ou então, nos ajudam a bagunçar um pouquinho
# a nossa base quando isso nos ajudar a produzir os resultados
#que queremos

#Vamos ver aqui algumas de suas principais funções:

#separate() e unite(): para separar variáveis concatenadas
#em uma única coluna ou uni-las.

#pivot_wider() e pivot_longer():para pivotar a base

imdb <- readRDS("material do curso/materiais/data/imdb.rds")
imdb

#A função separate separa duas ou mais variaveis que estão
#concatenadas em uma ou mais colunas
imdb %>% 
  select(generos)

##Usando a função separate

imdb %>% 
  separate(col = generos, into = c("genero1", "genero2","genero3"),
           sep = "\\|") %>% 
  select(starts_with("genero"))

#concatenar com unite()

imdb %>% 
  select(starts_with("ator"))

#Criar coluna chamada elenco

imdb %>%
  unite(col = "elenco", starts_with("ator"), sep = " - ") %>% 
  select(elenco)

#Pivotagem de tabelas
#pivot_longer()

#Abaixo, transformamos as colunas ator1, ator2, e ator3 em
#duas colunas: ator_atriz e protagonismo.

imdb_long<-imdb %>%
  pivot_longer( 
    cols = starts_with("ator"),
    names_to = "protagonismo",
    values_to = "ator_atriz") %>% 
  select(titulo, ator_atriz, protagonismo)

imdb_long %>% 
  pivot_wider(
    names_from = protagonismo,
    values_from = ator_atriz
  ) %>% 
  select(titulo, starts_with("ator"))


casas <- dados::casas

#A ideia da função across() é facilitar a aplicação de uma operação a diversas colunas
# da base.

casas %>% 
  group_by(geral_qualidade) %>% 
  summarise(
    lote_area_media = mean(lote_area, na.rm = TRUE),
    venda_valor_medio = mean(venda_valor, na.rm = TRUE)
  )

#Com a função across, a sintaxe é simplificada

casas %>% 
  group_by(geral_qualidade) %>% 
  summarise(across(
    .cols = c(lote_area, venda_valor), #Variáveis
    .fns = mean, na.rm = TRUE #Função
  ))
 
#O R não deixa criar uma coluna que começa com ponto
#Pode existir uma colunas chamada cols, mas para evitar conflito, o R 
# tem o argumento começando com "." sendo assim .cols


#Usando across(), podemos facilmente aplicar uma função em todas as colunas da nossa
#base. O argumento padrão de .cols é everything()

#Por questão de espaço, vamos pegar apenas 5 colunas

casas %>% 
  summarise(across(.fns = n_distinct)) %>% 
  select(1:5)


#Se quisermos selecionar as colunas a serem modificadasa partir de um teste lógico,
#utilizamos o ajudante where(). No exemplo abaixo, calculamos o múmero de valores
#distintos das colunas de categóricas.

#pegando apenas 5 colunas por questão de espaço
casas %>% 
  summarise(across(
    .cols = where(is.character), #variaveis
    .fns = n_distinct # função
  )) %>% 
  select(1:5)



