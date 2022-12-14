library(dplyr)
library(tidyr)
library(dados)
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

#Combinando across() com outros operadores
#Podemos combinar testes lógicos com seleções de colunas. Calculamos as áreas médias,
#garantindo que pegamos apenas variáveis numéricas.

#Pegando apenas 4 colunas por questão de espaço.

casas %>% 
  summarise(across(
    .cols = where(is.numeric) & contains("_area"),
    .fns = mean, na.rm = TRUE
  )) %>% 
  select(1:4)

?dplyr::starts_with


#Fazer várias aplicações do across() também é possível:

casas %>% 
  group_by(fundacao_tipo) %>% 
  summarise(
    across(contains("area"), mean, na.rm = TRUE),
    across(where(is.character), ~ sum(is.na(.x))), #Conta o número de NA nas colunas do tipo caracter
    n_obs = n()
  ) %>% 
  select(1:2,19:20,n_obs)

# A última funcionalidade relevante do across() é a capacidade de receber uma lista
#de funções

casas %>% 
  group_by(rua_tipo) %>% 
  summarise(across(
    .cols = c(lote_area, venda_valor),
    .fns = list("média" = mean, "mediana" = median)
  ))

#O argumento .names define uma fórmula para a construção do nome das novas colunas:

casas %>% 
  group_by(rua_tipo) %>% 
  summarise(across(
    .cols = c(lote_area, venda_valor),
    .fns = list("media" = mean, "mediana" = median),
    .names = "{.fn}_de_{.col}" #{nome da função} _de_ {nome da coluna}
  ))


#across() outros verbos

#O across() pode ser utilizado em todos os verbos do dplyr (com exceção do select() e rename())
#já que ele não traz vantagens com relação ao que já podia ser feito) e isso unifica o modo que 
#trabalhamos essas operações no dplyr

#Vamos ver um exemplo para o mutate() e para o filter()


#O código abaixo transforma todas as variáveis que possuem area no nome,
#passando os valores de pés quadrados para metros quadrados

casas %>% 
  mutate(across(
    contains("area"),
    ~.x/10.764))

#O código a seguir filra apenas as casas que possuem varanda aberta, cerca e lareira

casas %>% 
  filter(across(
         c(varanda_aberta_area, cerca_qualidade, lareira_qualidade),
         ~!is.na(.x)
  ))

#Motivação: explorar algumas funções do tidyr para lidar com 
#NAs

#drop_na()

dados_starwars %>%  View()

dados_starwars %>% 
  drop_na() %>% 
  View()


#Motivação: substituir todos os NAs das variáveis por "Sem informação"

dados_starwars %>% 
  mutate(
    across(
      where(is.character),
      tidyr::replace_na,
      replace = "sem informação"
    )
  ) %>% View()

glimpse(dados_starwars)


#Deixando no formato longo e contando NAs por coluna

dados_starwars %>% 
  summarise(across(.fns = ~sum(is.na(.x)))) %>% 
  pivot_longer(everything(), names_to = "coluna",
               values_to = "num_na") %>% 
  arrange(desc(num_na)) %>% View()
  

#Motivação: Ver o número de categorias distintas
#Em cada variável categórica


dados_starwars %>% 
  summarise(across(
    where(is.character),
    n_distinct
  ))

#Pivotando e ordenando pelo número de categorias



dados_starwars %>%
  summarise(across(where(is.character),
                   n_distinct)) %>% 
  pivot_longer(everything(), names_to = "coluna", values_to = "num_cat") %>% 
  arrange(desc(num_cat)) %>% View()


#Remover nome (é a chave da base)

dados_starwars %>% 
  summarise(across(
    .cols = c(where(is.character), -nome),
    .fns = n_distinct
  )) %>% 
  pivot_longer(everything(), names_to = "coluna", values_to = "num_cat") %>% 
  arrange(desc(num_cat))


#Motivação: Descobrir o ator com maior lucro médio na base IMDB,
#considerando as 3 colunas de elenco
imdb <- readRDS("E:/R/Curo R - R para Ciencia de Dados II/Projetos-em-R/material do curso/materiais/data/imdb.rds")


glimpse(imdb)


imdb %>% 
  mutate(lucro = receita - orcamento) %>% 
  select(titulo,lucro, starts_with("ator")) %>% 
  pivot_longer(starts_with("ator"), names_to = "protagonismo", values_to = "ator") %>% 
  group_by(ator) %>% 
  summarise(lucro_medio = mean(lucro, na.rm = TRUE),
            n_filmes = n())%>%
  filter(n_filmes > 5) %>% 
  arrange(desc(lucro_medio))

#Motivação: Fazer uma tabela do lucro médio anual dos filmes
#de comédia, ação e romance (2000 a 2016)

imdb %>% 
  mutate(lucro = receita - orcamento) %>% 
  select(titulo,ano, generos, lucro) %>% 
  separate_rows(generos, sep = "\\|") %>% 
  filter(generos %in% c("Commedy", "Action", "Romance")) %>% 
  filter(between(ano, 2000, 2016)) %>% 
  group_by(ano, generos) %>% 
  summarise(media_lucro = mean(lucro, na.rm = TRUE)) %>% 
    arrange(desc(media_lucro))

names(imdb)
