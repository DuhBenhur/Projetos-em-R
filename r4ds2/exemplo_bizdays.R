base <- tibble::tribble(
  ~id, ~data,
  "A", "2022-02-13",
  "A", "2022-02-14",
  "A", "2022-02-15",
  "A", "2022-02-16",
  "A", "2022-02-17",
  "A", "2022-02-19",
  "B", "2022-02-04",
  "B", "2022-02-04",
  "B", "2022-02-05",
  "B", "2022-02-06",
  "B", "2022-02-07",)

bizdays::load_builtin_calendars() #carrega os calendários do bizdays

base |> 
  dplyr::mutate(
    data = lubridate::as_date(data),
    eh_bizday = bizdays::is.bizday(data, cal = "Brazil/ANBIMA") #retorna dias úteis
  ) |> 
  dplyr::filter(eh_bizday) |> #filtra os dias úteis
  dplyr::group_by(id) |> #agrupa por id de cliente
  dplyr::slice_max(data, with_ties = FALSE) |> #seleciona a maior data
  dplyr::ungroup()#desagrupa
