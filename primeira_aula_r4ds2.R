#Criando projetos
install.packages("usethis")

usethis::use_blank_slate() # Desativar Rstory e Rdata

userthis::create+project("~/pasta1/pasta2")#Criar projeto no diretório


#Pastas necessárias

#Fluxo de limpeza

data-raw/base.xlsx #Na pasta data-raw, ficam os arquivos brutos recebidos dos clientes
data-raw/leitura.R #Códifo para ler os dados brutos
data-raw/limpeza.R #Código para limpeza dos dados brutos
data-raw/arrumação.R #Código para arrumar os  dados brutos
data-raw/salva.R #Código para salvar os dados brutos

#Organização dos arquivos

saveRDS(base_perfeita, "data/base.rds") #Salvar os dados limpos em arquivo .rds
#Os arquivos .rds são mais leves para leitura no R. Todos os modelos, gráficos e análises serão feitas
#com base nesse arquivo .rds

R/modelo.R
 * readRDS("data/base.rds")

R/gráfico.R
  * readRDS("data/base.rds")

#Uma sugestão interessante para quando temos muitos arquivos de dados é dividi-los em pastas por extensão:
#colocar arquivos Excel na pasta data-raw/xlsx/, arquivos CSV na pasta data-raw/csv/ e assim por diante.

#Nesta pasta, também podemos guardar rascunhos da nossa análise.

#A pasta R, só pode ter scripts.R com funções.


#Com a função Source, podemos chamar as funções criadas no R

* source("R/01_itau_leitura.R")
* ler_base()
* ajustar_nomes()
