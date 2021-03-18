library('readxl')
library('writexl')
library('lubridate')
library('tidyverse')



wohoo = read_excel("wohoo.xlsx")



# colunas do dataframe que será gerado
DIA = c()
MES = c()
ANO = c()
DURACAO_TOTAL_HN = c()
DURACAO_TOTAL_HN_SEM_CRT = c()
VEICULACAO_MINIMA = c()
VEICULACAO_EFETIVA = c()

# valores para o for
dias = unique(wohoo$DIA_VEICULACAO)
meses = unique(wohoo$MES_VEICULACAO)
anos = unique(wohoo$ANO_VEICULACAO)

# PARA CADA ANO, PARA CADA MES, PARA CADA DIA
# criação dos dataframes que serão utilizados na plotagem dos gráficos
for(i in 1:length(anos)){
  for(j in 1:length(meses)){
    for(l in 1:length(dias)){
      
      aux = wohoo %>% filter(DIA_VEICULACAO == dias[l], MES_VEICULACAO == meses[j], ANO_VEICULACAO == anos[i])
      # total no horário nobra
      total_dia_hn = sum(aux$DURACAO_TOTAL_HN)
      # total no horário nobre sem o crt 18004000010007
      total_dia_hn_CRT = subset(aux, CRT != "18004000010007")
      total_dia_hn_CRT = sum(aux$DURACAO_TOTAL_HN)
      # mínimo de veiculação no horário nobre por dia
      tempo_minimo_hn = total_dia_hn / 2
      # obras que contam pra cumprir a cota diária
      total_valido_cabeq = aux %>% filter(CLASSIF_NUMERICA_OBRA_DECL == "01")
      total_valido_cabeq = sum(total_valido_cabeq$DURACAO_TOTAL_HN)
      
      # inserindo os valores nos arrays
      DIA = c(DIA, dias[l])
      MES = c(MES, meses[j])
      ANO = c(ANO, anos[i])
      DURACAO_TOTAL_HN = c(DURACAO_TOTAL_HN, total_dia_hn)
      DURACAO_TOTAL_HN_SEM_CRT = c(DURACAO_TOTAL_HN_SEM_CRT, total_dia_hn_CRT)
      VEICULACAO_MINIMA = c(VEICULACAO_MINIMA, tempo_minimo_hn)
      VEICULACAO_EFETIVA = c(VEICULACAO_EFETIVA, total_valido_cabeq)
      
    }
  }
}

# join
grafico_df = cbind(DIA, MES, ANO, DURACAO_TOTAL_HN, DURACAO_TOTAL_HN_SEM_CRT, VEICULACAO_MINIMA, VEICULACAO_EFETIVA)
grafico_df = as.data.frame(grafico_df)
# conserta um bug
grafico_df = subset(grafico_df, DURACAO_TOTAL_HN != 0)


# formata as datas
DATA = c()
for(h in 1:nrow(grafico_df)){
  data = paste0(grafico_df$DIA[h], "-", grafico_df$MES[h], "-", grafico_df$ANO[h])
  DATA = c(DATA, data)
}

grafico_df = cbind(DATA, grafico_df)

grafico_df$DATA = parse_date_time(grafico_df$DATA, orders="dmy")
grafico_df$DATA = as.Date(grafico_df$DATA)



# converter segundos em h:m:s
DURACAO_TOTAL_HN_HMS = seconds_to_period(grafico_df$DURACAO_TOTAL_HN)
DURACAO_TOTAL_HN_SEM_CRT_HMS = seconds_to_period(grafico_df$DURACAO_TOTAL_HN_SEM_CRT)
VEICULACAO_EFETIVA_HMS = seconds_to_period(grafico_df$VEICULACAO_EFETIVA)
VEICULACAO_MINIMA_HMS = seconds_to_period(grafico_df$VEICULACAO_MINIMA)
# join
grafico_df = cbind(grafico_df, DURACAO_TOTAL_HN_HMS, DURACAO_TOTAL_HN_SEM_CRT_HMS, VEICULACAO_EFETIVA_HMS, VEICULACAO_MINIMA_HMS)

# DATAFRAMES QUE SERÃO UTILIZADOS
# até aqui tudo devia ser exibido por dia nos gráficos, ou seja, as veiculações e durações
# porém, para facilitar a visualização, daqui em diante(no próximo script) será incluído um intervalo
# de tempo um pouco maior: será por semana.
grafico_2019 = grafico_df %>% filter(ANO == 2019)
grafico_2020 = grafico_df %>% filter(ANO == 2020)


write_xlsx(grafico_2019, "./saidas/CABEQ-DIA-2019.xlsx")
write_xlsx(grafico_2020, "./saidas/CABEQ-DIA-2020.xlsx")

# o código para plotar os gráficos estaria aqui
# mas como o intervalo de tempo será modificado
# ainda não é o momento de plotar uma visualização

#limpar memória
rm(list = subset(ls(), !(ls() %in% c("wohoo", "grafico_2019", "grafico_2020"))))