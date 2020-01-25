
if("pacman" %in% rownames(installed.packages()) == FALSE) {install.packages("pacman")}
pacman::p_load(data.table, stringr, dplyr)


linhasRepetidas = function(){
  
  #escolhe o diretório do script como diretório de busca do arquivo csv
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
  #cria vetor com o nome de todos os arquivos csv da pasta atual
  files = file.info(list.files(getwd(), pattern = ".csv"))
  #carrega o arquivo mais recente
  nome_arquivo = rownames(files)[order(files$mtime)][nrow(files)]
  DF = fread(nome_arquivo, fill = TRUE)
  #acha as linhas diferentes e repetidas
  diferentes = distinct(DF)
  indice = duplicated(DF)
  repetidos = DF[indice,]
  
  #separa a string onde houver ponto e pega o conteúdo à esquerda
  #ex: x = "nome.csv" -> x = "nome", "csv"
  output = str_split(nome_arquivo, "\\.")[[1]][1]
  
  #encontrando repetidas gera um arquivo csv
  if(nrow(repetidos) > 0){
    fwrite(repetidos, file = paste0(output, " - repetido.csv"))
  }
  #encontrando diferentes gera um arquivo csv
  fwrite(diferentes, file = paste0(output, " - limpo.csv"), sep = ";")
  
}


#função que limpa um csv(tira linhas repetidas)
linhasRepetidas()
