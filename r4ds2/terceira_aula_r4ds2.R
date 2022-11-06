# Omitir valores NA em vetores

v <- c(1,2,3,NA,4)
v |>
  na.omit(v) |> 
  as.numeric()

#Com pacote purrr

c(1,2,3,NA,4) |>
  purrr::discard(is.na) #Talvez esse não seja o método que o R prefere para vetores


