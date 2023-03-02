# Carrega as bibliotecas necessárias
library(rvest)
library(tidyverse)

# Define a URL da página a ser lida
page <- "https://fundamentus.com.br/fii_resultado.php"

# Lê o conteúdo HTML da página e converte a tabela encontrada em um objeto data frame
fii <- read_html(page) %>% 
  html_table()

# Seleciona apenas a primeira tabela encontrada (que contém as informações de interesse)
# e seleciona apenas algumas colunas específicas
fii <- fii[[1]] %>% 
  select(
    Papel, Segmento, Cotação, 'Dividend Yield', 'P/VP',
    'Valor de Mercado', Liquidez, 'Vacância Média'
  ) %>% 
  
  # Faz a limpeza dos dados das colunas Cotação a Vacância Média
  # Substitui o caractere "." e "%" por vazio, transforma "," em "." e converte o tipo para numérico
  mutate(
    across(Cotação:'Vacância Média', gsub, pattern = "\\.|%", replacement = ""),
    across(Cotação:'Vacância Média', gsub, pattern = ",", replacement = "."),
    across(Cotação:'Vacância Média', as.numeric),
  )
