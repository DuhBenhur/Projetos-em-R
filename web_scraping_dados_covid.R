library(tidyverse)
library(httr)

u_covid <- "https://covid.saude.gov.br/"

r <- httr::GET(u_covid,
               httr::write_disk("output/covid.html"))

u_rar <- "https://mobileapps.saude.gov.br/esus-vepi/files/unAFkcaNDeXajurGB7LChj8SgQYS2ptm/fdffc0f59ecafd03ea43d370fa35afa5_HIST_PAINEL_COVIDBR_11out2022.rar"

GET(u_rar, httr::write_disk("output/dados_covid.rar"))]


# automatizar a descoberta do link u_rar ----------------------------------



u_portal_geral <- "https://qd28tcd6b5.execute-api.sa-east-1.amazonaws.com/prod/PortalGeral"

r_portal_geral <- GET(u_portal_geral)
                     # httr::accept_json(),
                     # httr::user_agent("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/105.0.0.0 Safari/537.36"))



#Não deu certo

#próximos passos é imitar os headers da requisição

r_portal_geral <- GET(u_portal_geral,
                      httr::add_headers(
                        "X-Parse-Application-Id" = "unAFkcaNDeXajurGB7LChj8SgQYS2ptm")
)

link_rar <- content(r_portal_geral)$results[[1]]$arquivo$url

GET(link_rar, httr::write_disk("output/dados_covid.rar", overwrite = T))
# Automatizar a coleta da chave -------------------------------------------

js_com_chave <- "https://covid.saude.gov.br/main-es2015.js"

r_javascript <- httr::GET(js_com_chave)

chave <- r_javascript |>
  content("text", encoding = "UTF-8") |>
  stringr::str_extract("(?<=PARSE_APP_ID = ')[^']+")



r_portal_geral <- GET(u_portal_geral,
                      httr::add_headers(
                        "X-Parse-Application-Id" = chave)
)

link_rar <- content(r_portal_geral)$results[[1]]$arquivo$url

GET(link_rar, httr::write_disk("output/dados_covid.rar", overwrite = T))



# criar função ------------------------------------------------------------

baixar_dados_do_dia <- function(arquivo = "output/dados_convid.rar"){
  js_com_chave <- "https://covid.saude.gov.br/main-es2015.js"
  
  r_javascript <- httr::GET(js_com_chave)
  
  chave <- r_javascript |>
    content("text", encoding = "UTF-8") |>
    stringr::str_extract("(?<=PARSE_APP_ID = ')[^']+")
  
  
  
  r_portal_geral <- GET(u_portal_geral,
                        httr::add_headers(
                          "X-Parse-Application-Id" = chave)
  )
  
  link_rar <- content(r_portal_geral)$results[[1]]$arquivo$url
  
  GET(link_rar, httr::write_disk(arquivo, overwrite = T))
  
}


baixar_dados_do_dia()
