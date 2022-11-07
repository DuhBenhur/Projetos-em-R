pacotes <- c("jsonlite","plotly","tidyverse","cluster","dendextend","factoextra","fpc",
             "gridExtra", "magrittr","esquisse","knitr","kableExtra","xml2","httr")


if(sum(as.numeric(!pacotes %in% installed.packages())) != 0){
  instalador <- pacotes[!pacotes %in% installed.packages()]
  for (i in 1:length(instalador)){
    install.packages(instalador, dependencies = T)
    break()
  }
  sapply(pacotes, require, character = T)
}else{
  sapply(pacotes, require, character = T)
}


#Coleção de links

u_links <- "https://www.seedbank.com/collections/feminized-seeds/"

r_links <- httr::GET(u_links)

html <- r_links |> 
  httr::content()
pagina <- html |> 
  xml2::xml_find_all("//a[@class='page-number']") |> 
  xml2::xml_text()


#Extração dos dados

u <- "https://www.seedbank.com/products/auto-super-lemon-haze-seeds/"

r <- httr::GET(u)

r |>
  httr::content()|>
  xml2::xml_find_all("//*[@class='pie_progress']") |>
  xml2::xml_attr("data-goal") |>
  as.numeric()

html <- r |> 
  httr::content()
titulo <- html |> 
  xml2::xml_find_all("//h1[@class='product-title product_title entry-title']") |> 
  xml2::xml_text()

valor <- html |> 
  xml2::xml_find_all("//*[@class='pie_progress']") |> 
  xml2::xml_attr("data-goal") |> 
  as.numeric()

nome <- html |> 
  xml2::xml_find_all("//*[@class='pie_progress__label']") |> 
  xml2::xml_text()

tibble::tibble(
  titulo = titulo,
  nome = nome, 
  valor = valor
) |> 
  dplyr::mutate(titulo = stringr::str_squish(titulo))|>
  pivot_wider(id_cols=titulo, names_from = nome, values_from = valor)


