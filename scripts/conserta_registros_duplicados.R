library('readxl')
library('writexl')
library('tidyverse')
library('gtools')


# a base do ibge estava com os códigos de municípios trocados só no ano de 2009
# os outros anos estavam corretos para cada município
# ao todo foram 186 municípios afetados por esse erro
# esse script resolve mais de 90% dos casos
# como o que sobrou foi pouco, decidi terminar manualmente

# então ele não está finalizado, mas já ajuda muito.
# os registros que o script não tratou, no geral são municípios cujo o nome
# se repete em mais de um estado, por exemplo: Caraúbas - PB e Caraúbas - RN
# não necessariamente o ano de 2009 está incorreto nesses casos


ibge = read_excel("População IBGE - UF - Municípios (2009 a 2020) - corrigido.xlsx")
ibge = as.data.frame(ibge)
names(ibge)[4] = "COD.MUNIC"

mun_repetidos = read_excel("duplicados.xlsx")
mun_repetidos = as.data.frame(mun_repetidos$NM_MUNICIPIO)
mun_repetidos = unique(mun_repetidos$`mun_repetidos$NM_MUNICIPIO`)

aux = c()
  
for (i in 1:length(mun_repetidos)) {
  
  # coleta o código que se repete entre 2011 e 2020
  consulta = ibge %>% filter(`NOME DO MUNICÍPIO` == mun_repetidos[i], as.numeric(ANO) %in% 2011:2020)
  codigo = unique(consulta$COD.MUNIC)
  # se for mais de um código, então temos mais de um município com o mesmo nome, ex: Caraúbas - PB e Caraúbas - RN
  if(length(codigo) == 1){
    # filtra pelo município, modifica todos os registros da coluna COD.MUNIC para o código correto
    #sendo assim, o ano de 2009 passa a ter o mesmo código dos outros anos
    ibge = ibge %>% mutate(COD.MUNIC = ifelse(`NOME DO MUNICÍPIO` == mun_repetidos[i], codigo, COD.MUNIC))
  }else{
    #parte ainda por fazer - por enquanto só informa os poucos municípios que restaram para consertar
    cat(mun_repetidos[i], "\n")
  }

  consulta = NULL
  codigo = NULL

}


write_excel(ibge, "População IBGE - UF - Municípios (2009 a 2020).xlsx")
