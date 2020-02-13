library(xlsx)
library(dplyr)

dados_cadastrais = read.xlsx("dados_cadastrais.xlsx", 1)
exibidores = read.xlsx("lista_exibidores.xls", 1)
names(dados_cadastrais)[3] = "REGISTRO" #porque exibidores tem "REGISTRO"
exibidores = exibidores[, 1:6]
dados_cadastrais = dados_cadastrais[,c(3, 17, 21)]
output = left_join(exibidores, dados_cadastrais, by="REGISTRO")
write.xlsx(output, "exibidores_com_email_e_uf.xlsx")
