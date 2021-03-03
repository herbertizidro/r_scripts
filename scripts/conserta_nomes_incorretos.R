library('readxl')
library('writexl')
library('tidyverse')
library('gtools')


ibge = read_excel("População IBGE - UF - Municípios (2009 a 2020) - corrigido.xlsx")
codigo_municipio = read_excel("dtb_2010.xls")
codigo_municipio = codigo_municipio[, c(1,7,8)]

ibge$`COD. MUNIC` = as.character(ibge$`COD. MUNIC`)
ibge$`COD. UF` = as.character(ibge$`COD. UF`)
codigo_municipio$Município = as.character(codigo_municipio$Município)

ibge =  as.data.frame(ibge)
codigo_municipio = as.data.frame(codigo_municipio)

# tira o código da UF e deixa somente os 5 dígitos do código do Município
for(i in 1:length(codigo_municipio$Município)){
  codigo_municipio$Município[i] = substr(codigo_municipio$Município[i], start = 3, stop = 7)
}

# Conserta os nomes dos municípios da tabela "ibge":
# A tabela do Instituto Brasileiro de GEOGRAFIA e Estatística - IBGE, tem vários municípios com nome errado.
# Nomes com e sem "H", "C", com hífen e sem hífen, com e sem acentuação. Ex:

# São Cristovão do Sul e São Cristóvão do Sul, Graccho Cardoso e Gracho Cardoso, Biritiba Mirim e Biritiba-Mirim,
# Florínea e Florínia, Mogi Mirim e Moji Mirim, São Luís do Paraitinga e São Luiz do Paraitinga, Fortaleza do Tabocão e
# Tabocão e etc.

# O bloco de código abaixo conserta esse erro usando a tabela dessa página https://www.ibge.gov.br/explica/codigos-dos-municipios.php
# como o padrão.

for (i in 1:length(unique(codigo_municipio$Município))) {
  
  ibge = ibge %>% mutate(`NOME DO MUNICÍPIO` = ifelse(`COD. MUNIC` == codigo_municipio$Município[i] & ibge$`COD. UF` == codigo_municipio$UF[i], codigo_municipio$Nome_Munic[i], `NOME DO MUNICÍPIO`))
  
}


write_xlsx(ibge, "População IBGE 2009-2010 - FINAL.xlsx")
