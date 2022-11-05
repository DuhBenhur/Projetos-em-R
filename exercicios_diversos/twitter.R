library("tidyverse")
library("httr")
library("rtweet")

auth_setup_default()

trends <- get_trends()

tuitar

post_tweet("teste rtweet #rstats")


janones <- get_timeline("AndreJanonesAdv", n = 200)


haddad <- search_tweets("Haddad", n = 1000)

#Top trends no Brasil

aux <- trends_available()
woeid_brazil <- aux$woeid[which(aux$name == "Brazil")]

#50 trending topics do Brasil

trends_brazil <- get_trends(woeid = woeid_brazil)


#filtrar os trending topics do brazil com hashtags

trends_brazil_com_hashtags <- trends_brazil |>
  filter(grepl("#", trend)) |>
  select(trend) |>
  pull()


#Criar objeto da classe character com as hashtags separadas por OR

trends_para_consulta <- paste0(trends_brazil_com_hashtags, collapse = " OR ")

tweets <- search_tweets(q = trends_para_consulta,
                        n = 1000, #maximo 18000
                        include_rts = FALSE,
                        lang = "pt")


#Seleção das variaveis

tweets <- tweets |>
  select(DATE_TIME = created_at,
         TEXT = text,
         TEXT_WIDTH = display_text_width,
         IS_QUOTE = is_quote_status)


#presença de hashtahs

presenca_hashtags <-
  sapply(
    (1:length(trends_brazil_com_hashtags)),
    FUN = function(x){
      grepl(trends_brazil_com_hashtags[x],tweets$TEXT)
    }
  )


colnames(presenca_hashtags) <- trends_brazil_com_hashtags
tweets <- cbind(tweets, presenca_hashtags)

#Salvar arquivo

filename <- paste0("TwitterData_",
                   strftime(Sys.time(), format = "%d%m%Y_%H"),
                   "H.Rdata")

save(tweets, file=filename)
