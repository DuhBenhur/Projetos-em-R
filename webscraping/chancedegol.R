library("httr")
library("tidyverse")
library("xml2")


u_cdg <- "https://www.chancedegol.com.br/br21.htm"

r_cdg <- GET(u_cdg, write_disk("output/cdg.html"))

#Como descobrir o encoding de uma string?
string <- readr::read_file("output/cdg.html")
stringi::stri_enc_detect(string)

#Voltou NA provavelmente por conta do enconding



r_cdg |>
  content(encoding = "latin1")|>
  xml_find_all("//table")

#Outra forma de puxar a tabela com o pacote rvest
r_cdg |>
  content(encoding = "latin1")|>
  rvest::html_elements(css = "table")

r_cdg |>
  content(encoding = "latin1")|>
  rvest::html_elements(xpath = "//table")


#por trás o rvest chama o xml2. Podemos verificar isso fazendo o seguinte

#rvest:::html_element.default

#O que fazer com a table?

#Retorna uma lista
r_cdg |>
  content(encoding = "latin1")|>
  xml_find_all("//table") |>
  rvest::html_table()

#Retorna o dataframe
r_cdg |>
  content(encoding = "latin1")|>
  xml_find_first("//table") |>
  rvest::html_table()

#Colocando o nome das colunas com parametro header

r_cdg |>
  content(encoding = "latin1")|>
  xml_find_first("//table") |>
  rvest::html_table(header = TRUE)|>
  #a parte de scraping acaba aqui!!!
  # a partir de agora é tidyverse
  janitor::clean_names() |>
  mutate(across(c(vitoria_do_mandante:vitoria_do_visitante),
                parse_number))|>
  View()

#Salvando em um objeto

tabela <- 
  r_cdg |>
  content(encoding = "latin1")|>
  xml_find_first("//table") |>
  rvest::html_table(header = TRUE)|>
  #a parte de scraping acaba aqui!!!
  # a partir de agora é tidyverse
  janitor::clean_names() |>
  mutate(across(c(vitoria_do_mandante:vitoria_do_visitante),
                parse_number))

#Encontrando o resultado final pela cor vermelha no site

vermelho <- r_cdg |>
  content(encoding = "latin1") |>
  xml_find_all("//font[@color='#FF0000']")|>
  #retornar no formato texto
  xml_text()

#Resultado

tabela <- 
  r_cdg |>
  content(encoding = "latin1")|>
  xml_find_first("//table") |>
  rvest::html_table(header = TRUE)|>
  #a parte de scraping acaba aqui!!!
  # a partir de agora é tidyverse
  janitor::clean_names() |>
  mutate(across(c(vitoria_do_mandante:vitoria_do_visitante),
                parse_number)) |>
  mutate(resultado_jogo = parse_number(vermelho)) |>
  mutate(quem_ganhou = case_when(
    resultado_jogo == vitoria_do_mandante ~ "Mandante",
    resultado_jogo == vitoria_do_visitante ~ "Visitante",
    TRUE ~ "Empate"
  ))

#Outra forma de escrever para não escrever varios mutates

tabela <- 
  r_cdg |>
  content(encoding = "latin1")|>
  xml_find_first("//table") |>
  rvest::html_table(header = TRUE)|>
  #a parte de scraping acaba aqui!!!
  # a partir de agora é tidyverse
  janitor::clean_names() |>
  mutate(across(c(vitoria_do_mandante:vitoria_do_visitante),
                parse_number),
  resultado_jogo = parse_number(vermelho),
  quem_ganhou = case_when(
    resultado_jogo == vitoria_do_mandante ~ "Mandante",
    resultado_jogo == vitoria_do_visitante ~ "Visitannte",
    TRUE ~ "Empate"
  ),
  chute = case_when(
    vitoria_do_mandante > vitoria_do_visitante & vitoria_do_mandante > empate ~ "Mandante",
    vitoria_do_visitante > vitoria_do_mandante & vitoria_do_visitante > empate ~ "Visitante",
    TRUE ~ "Empate"
  ),acertou = chute == quem_ganhou)


tabela |>
  count(acertou) |>
  mutate(prop = n/sum(n))


#pegar outros anos

pegar_cdg <- function(ano){
  u_cdg <- glue::glue("https://www.chancedegol.com.br/br{ano-2000}.htm")
  r_cdg <- GET(u_cdg)
  
  vermelho <- r_cdg |>
    content(encoding = "latin1") |>
    xml_find_all("//font[@color='#FF0000']")|>
    #retornar no formato texto
    xml_text()
  
  tabela <- 
    r_cdg |>
    content(encoding = "latin1")|>
    xml_find_first("//table") |>
    rvest::html_table(header = TRUE)|>
    #a parte de scraping acaba aqui!!!
    # a partir de agora é tidyverse
    janitor::clean_names() |>
    mutate(across(c(vitoria_do_mandante:vitoria_do_visitante),
                  parse_number),
           resultado_jogo = parse_number(vermelho),
           quem_ganhou = case_when(
             resultado_jogo == vitoria_do_mandante ~ "Mandante",
             resultado_jogo == vitoria_do_visitante ~ "Visitannte",
             TRUE ~ "Empate"
           ),
           chute = case_when(
             vitoria_do_mandante > vitoria_do_visitante & vitoria_do_mandante > empate ~ "Mandante",
             vitoria_do_visitante > vitoria_do_mandante & vitoria_do_visitante > empate ~ "Visitante",
             TRUE ~ "Empate"
           ),acertou = chute == quem_ganhou)
  
  
  tabela |>
    count(acertou) |>
    mutate(prop = n/sum(n))
  
  
}

pegar_cdg(2022)


#varios anos

2010:2021 |>
  set_names() |>
  map_dfr(pegar_cdg, .id = "ano") |>
  filter(acertou) |>
  ggplot(aes(x = ano, y = prop)) +
  geom_col()
  
  
