#link aulas
#https://curso-r.github.io/202210-r4ds-2/

#Purrr

#Lisras são como vetores, com a diferença de que elas não precisam ser 
#homogêneas (seus elementos podem ter qualquer tipo)


l <- list(
  um_numero = 123,
  um_vetor = c(TRUE, FALSE, TRUE),
  uma_string = "abc",
  uma_lista = list(1,2,3)
)

str(l)

#Acessar elementos na lista

l$um_numero

l$um_vetor

l$uma_string

l$uma_lista
l$uma_lista[[1]] #primeiro elemento da lista
l$uma_lista[[2]] # segundo elemento da lista
l$uma_lista[[3]] # terceiro elemento da lista


#Indexação

#Para acessar os elementos de uma lista precisamos tomar cuidado com a 
#diferença entre [] e [[]] (ou purrr::pluck()): o primeiro acesa uma posição,
#enquanto o segundo acessa um elemento

l[3]
l[[3]]

library(purrr)


pluck(l, 4, 2) #Indexação profunda



#Exemplos de aula (pacote purrr)

# Motivação: ler e empilhar as bases IMDB separadas por ano




library(tidyverse)




# abrindo só um arquivo
imdb_1956 <- read_rds("D:/R/Curo R - R para Ciencia de Dados II/Projetos-em-R/Projetos-em-R/data/imdb_por_ano/imdb_1956.rds")



# criando um vetor dos arquivos por ano da base do imdb
# com base R
arquivos <- list.files("data/imdb_por_ano", full.names = TRUE)

# O full names serve pra passar o caminho inteiro do arquivo
list.files("data/imdb_por_ano", full.names = FALSE)


# vai ler cada arquivo do vetor "arquivos"
imdb_por_ano <- map(arquivos, read_rds)



# com o _dfr podemos empilhar todas as bases
imdb_empilhado <- map_dfr(arquivos, read_rds)




# -------------------------------------------------------------------------


# Motivação: fazer gráficos de dispersão do orçamento vs receita
# para todos os anos da base




imdb <- read_rds("data/imdb.rds")




# deixar uma linha por ano com o nest

imdb_nest <- imdb |>
  group_by(ano) |>
  nest()

# criamos tibbles que tem todas as informações de cada ano




# voltando ao que era antes com o unnest:

imdb_nest |>
  unnest(cols = "data")




# funcao que faz grafico de dispersao do
# orcamento vs receita:

faz_grafico_dispersao <- function(tab){
  tab |>
    ggplot(aes(x = orcamento, y = receita)) +
    geom_point()
}




# experimentando a funcao
imdb |>
  faz_grafico_dispersao()


imdb |>
  ggplot(aes(x = orcamento, y = receita)) +
  geom_point()

# fazendo para cada ano:

imdb_graficos <- imdb |>
  filter(!is.na(ano)) |>
  group_by(ano) |>
  nest() |>
  mutate(
    grafico = map(data, faz_grafico_dispersao)
  )




imdb_graficos$grafico[[1]]




# especificando o ano
imdb_graficos |>
  filter(ano == 2007) |>
  pluck("grafico", 1)



# e se eu quiser salvar os graficos?


dir.create("graficos")


file_names <- stringr::str_c(imdb_graficos$ano, ".png")


o_que_map_devolve <-
  map2(file_names, imdb_graficos$grafico, ggsave, path = "graficos/")


# walk:

o_que_walk_devolve <- file_names[1:10] |>
  walk2(imdb_graficos$grafico[1:10], ggsave, path = "graficos/")





# -------------------------------------------------------------------------



faz_grafico_dispersao_titulo <- function(tab, titulo){
  tab |>
    ggplot(aes(x = orcamento, y = receita)) +
    geom_point() +
    labs(title = titulo)
}

imdb |>
  faz_grafico_dispersao_titulo("Orçamento vs Receita")


imdb_graficos_2 <- imdb |>
  filter(!is.na(ano)) |>
  group_by(ano) |>
  nest() |>
  mutate(
    titulo = str_c("Grafico do ano de ", ano),
    grafico = map2(data, titulo, faz_grafico_dispersao_titulo)
  )

# especificando o ano
imdb_graficos_2 |>
  filter(ano == 2003) |>
  pluck("grafico", 1)


# -------------------------------------------------------------------------

# tambem podemos rodar um modelo para
# cada grupo




# base que usaremos
?mtcars
mtcars |> View()



rodar_modelo <- function(tab){
  lm(mpg ~ ., data = tab)
}




rodar_modelo(mtcars)




# um modelo para cada grupo de numero de cilindros

tab_modelos <- mtcars |>
  group_by(cyl) |>
  nest() |>
  mutate(
    modelo = map(data, rodar_modelo)
  )


tab_modelos |>
  filter(cyl == 6) |>
  pluck("modelo", 1) |>
  summary()


tab_modelos$modelo[[3]]


tab_modelos$modelo[[3]] |> summary()




# outra forma (mais direta), sem criar uma função!!




# funcao que usamos:
rodar_modelo <- function(tab){
  lm(mpg ~ ., data = tab)
}




tab_modelos_2 <- mtcars |>
  group_by(cyl) |>
  nest() |>
  mutate(
    modelo = map(data, ~lm(mpg ~ ., data = .x))
  )

#O Curso parou aqui, o restante são exercicios que podemos fazer em casa

# -------------------------------------------------------------------------

## Essa parte não deu tempo de falar na aula, mas vou deixar
## os códigos com mais exemplos:

# -------------------------------------------------------------------------

# Motivação: iterar uma função não vetorizada




# função vetorizada:

is.na(NA)
is.na(c("a", "n", NA))




# função não vetorizada:

verifica_texto <- function(x){
  if (x != "") {
    "Texto a ser retornado"
  } else {
    NULL
  }
}




textos <- sample(c(letters, ""), 1000, replace = TRUE)




verifica_texto(textos)




map(textos, verifica_texto)





# -------------------------------------------------------------------------

# Motivação: criar coluna de pontos do time da casa
# ganhos a partir de um placar ({brasileirao})




remotes::install_github("williamorim/brasileirao")
brasileirao::matches




calcular_pontos <- function(placar){
  
  gols <- stringr::str_split(placar, "x", simplify = TRUE)
  
  if (gols[1] > gols[2]){
    return(3)
  } else if (gols[1] < gols[2]) {
    return(0)
  } else {
    return(1)
  }
}




calcular_pontos("1x1")
calcular_pontos("2x0")
calcular_pontos("1x6")




brasileirao::matches |>
  mutate(
    pontos = map_dbl(score, calcular_pontos)
  )




# Gols pro e gols contra
# (separar os numeros do placar em 2 colunas diferentes)




scores <- brasileirao::matches$score




as.numeric(stringr::str_split(scores[1], "x", simplify = TRUE))[1]




calcula_gols_casa <- function(placar) {
  as.numeric(stringr::str_split(placar, "x", simplify = TRUE))[1]
}




calcula_gols_casa(scores[1])
calcula_gols_casa(scores[2])
calcula_gols_casa(scores[3])




map_dbl(scores, calcula_gols_casa)




brasileirao::matches |>
  dplyr::mutate(
    pontos_casa = purrr::map_dbl(score, calcular_pontos),
    
    gols_casa = purrr::map_dbl(
      score,
      ~as.numeric(stringr::str_split(.x, "x", simplify = TRUE)[1])
    ),
    
    gols_visitante = purrr::map_dbl(
      score,
      ~as.numeric(stringr::str_split(.x, "x", simplify = TRUE)[2])
    )
  )
