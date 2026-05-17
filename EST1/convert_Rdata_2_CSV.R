#
rdata_to_csv_single <- function(rdata_file, csv_file) {
  obj_name <- load(rdata_file)     # nome do objeto carregado
  obj <- get(obj_name)             # recupera o objeto da memória
  write.csv(obj, csv_file, row.names = FALSE)
}

#### Entre com os nomes dos arquivos
# rdata_to_csv_single("dados.RData", "dados.csv")
getwd()
setwd("EST1")
rdata_to_csv_single("data_rats.Rdata", "data_rats.csv")
