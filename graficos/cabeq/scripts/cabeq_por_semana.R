library('readxl')
library('writexl')
library('lubridate')
library('tidyverse')


# SERÁ REFATORADO

wohoo = read_excel("wohoo.xlsx")
grafico_2019 = read_excel("./saidas/CABEQ-DIA-2019.xlsx")
grafico_2020 = read_excel("./saidas/CABEQ-DIA-2020.xlsx")


SEMANA = data.frame(DATA = grafico_2019$DATA, SEMANA = format(grafico_2019$DATA, format = "%W"))

grafico_2019 = cbind(SEMANA$DATA, grafico_2019$DIA, SEMANA$SEMANA, grafico_2019[, c(3:12)])
names(grafico_2019)[1] = "DATA"
names(grafico_2019)[2] = "DIA"
names(grafico_2019)[3] = "SEMANA"


SEMANA = c()
MEDIA_HN = c()
MEDIA_HN_CRT = c()
MEDIA_MINIMO_HN = c()
MEDIA_EFETIVO_HN = c()
ANO = c()

# semanas ordenadas sem valores repetidos
semanas_2019 = unique(sort(grafico_2019$SEMANA, decreasing = FALSE))

# para usar na "total_valido_semana_cabeq"
wohoo2019 = wohoo %>% filter(ANO_VEICULACAO == 2019)
wohoo2019_semanas = data.frame(DATA = wohoo2019$DATA_VEICULACAO, SEMANA = format(wohoo2019$DATA_VEICULACAO, format = "%W"), CRT = wohoo2019$CRT, CLASSIFICACAO = wohoo2019$CLASSIF_NUMERICA_OBRA_DECL, DURACAO_TOTAL_HN = wohoo2019$DURACAO_TOTAL_HN)

for(s in 1:length(semanas_2019)){
  
  SEMANA = c(SEMANA, semanas_2019[s])
  
  aux = grafico_2019 %>% filter(SEMANA == semanas_2019[s])
  
  # total no horário nobre e média no horário nobre por semana
  total_semana_hn = sum(aux$DURACAO_TOTAL_HN)
  duracao_media_semanal_hn = total_semana_hn / nrow(aux)
  MEDIA_HN = c(MEDIA_HN, duracao_media_semanal_hn)
  
  # total no horário nobre e média no horário nobre sem o crt 18004000010007
  total_semana_hn_CRT_df = subset(wohoo2019_semanas, CRT != "18004000010007")
  total_semana_hn_CRT = sum(total_semana_hn_CRT_df$DURACAO_TOTAL_HN)
  duracao_media_semanal_hn_CRT = total_semana_hn_CRT / length(unique(total_semana_hn_CRT_df$DATA))
  MEDIA_HN_CRT = c(MEDIA_HN_CRT, duracao_media_semanal_hn_CRT)
  
  # mínimo de veiculação no horário nobre por semana
  tempo_minimo_semana_hn = total_semana_hn / 2
  tempo_minimo_media_semanal_hn = tempo_minimo_semana_hn / nrow(aux)
  MEDIA_MINIMO_HN = c(MEDIA_MINIMO_HN, tempo_minimo_media_semanal_hn)
  
  # média das obras que contam para a cota semanal
  obras_class_cabeq = wohoo2019_semanas %>% filter(CLASSIFICACAO == "01")
  obras_class_cabeq = obras_class_cabeq %>% filter(SEMANA == semanas_2019[s])
  total_valido_semana_cabeq = sum(obras_class_cabeq$DURACAO_TOTAL_HN)
  media_cabeq_semana = total_valido_semana_cabeq / length(unique(obras_class_cabeq$DATA))
  
  MEDIA_EFETIVO_HN = c(MEDIA_EFETIVO_HN, media_cabeq_semana)
  
  ANO = c(ANO, "2019")
  
}

grafico_2019_atualizado = cbind(ANO, SEMANA, MEDIA_HN, MEDIA_HN_CRT, MEDIA_MINIMO_HN, MEDIA_EFETIVO_HN)

#limpar memória
rm(list = subset(ls(), !(ls() %in% c("wohoo", "grafico_2019", "grafico_2020", "grafico_2019_atualizado", "wohoo2019_semanas"))))

# 2019 ---------------------------------------------------------------------------------------

# 2020 ---------------------------------------------------------------------------------------

# o código abaixo retorna uma coluna com um índice por semana, de acordo com as datas
SEMANA = data.frame(DATA = grafico_2020$DATA, SEMANA = format(grafico_2020$DATA, format = "%W"))

grafico_2020 = cbind(SEMANA$DATA, grafico_2020$DIA, SEMANA$SEMANA, grafico_2020[, c(3:12)])
names(grafico_2020)[1] = "DATA"
names(grafico_2020)[2] = "DIA"
names(grafico_2020)[3] = "SEMANA"


SEMANA = c()
MEDIA_HN = c()
MEDIA_HN_CRT = c()
MEDIA_MINIMO_HN = c()
MEDIA_EFETIVO_HN = c()
ANO = c()

# semanas ordenadas sem valores repetidos
semanas_2020 = unique(sort(grafico_2020$SEMANA, decreasing = FALSE))

# para usar na "total_valido_semana_cabeq"
wohoo2020 = wohoo %>% filter(ANO_VEICULACAO == 2020)
wohoo2020_semanas = data.frame(DATA = wohoo2020$DATA_VEICULACAO, SEMANA = format(wohoo2020$DATA_VEICULACAO, format = "%W"), CRT = wohoo2020$CRT, CLASSIFICACAO = wohoo2020$CLASSIF_NUMERICA_OBRA_DECL, DURACAO_TOTAL_HN = wohoo2020$DURACAO_TOTAL_HN)


for(s in 1:length(semanas_2020)){
  
  SEMANA = c(SEMANA, semanas_2020[s])
  
  aux = grafico_2020 %>% filter(SEMANA == semanas_2020[s])
  
  # total no horário nobre e média no horário nobre por semana
  total_semana_hn = sum(aux$DURACAO_TOTAL_HN)
  duracao_media_semanal_hn = total_semana_hn / nrow(aux)
  MEDIA_HN = c(MEDIA_HN, duracao_media_semanal_hn)
  
  # total no horário nobre e média no horário nobre sem o crt 18004000010007
  total_semana_hn_CRT_df = subset(wohoo2020_semanas, CRT != "18004000010007")
  total_semana_hn_CRT = sum(total_semana_hn_CRT_df$DURACAO_TOTAL_HN)
  duracao_media_semanal_hn_CRT = total_semana_hn_CRT / length(unique(total_semana_hn_CRT_df$DATA))
  MEDIA_HN_CRT = c(MEDIA_HN_CRT, duracao_media_semanal_hn_CRT)
  
  # mínimo de veiculação no horário nobre por semana
  tempo_minimo_semana_hn = total_semana_hn / 2
  tempo_minimo_media_semanal_hn = tempo_minimo_semana_hn / nrow(aux)
  MEDIA_MINIMO_HN = c(MEDIA_MINIMO_HN, tempo_minimo_media_semanal_hn)
  
  # média das obras que contam para a cota semanal
  obras_class_cabeq = wohoo2020_semanas %>% filter(CLASSIFICACAO == "01")
  obras_class_cabeq = obras_class_cabeq %>% filter(SEMANA == semanas_2020[s])
  total_valido_semana_cabeq = sum(obras_class_cabeq$DURACAO_TOTAL_HN)
  media_cabeq_semana = total_valido_semana_cabeq / length(unique(obras_class_cabeq$DATA))
  
  MEDIA_EFETIVO_HN = c(MEDIA_EFETIVO_HN, media_cabeq_semana)
  
  ANO = c(ANO, "2020")
  
}


grafico_2020_atualizado = cbind(ANO, SEMANA, MEDIA_HN, MEDIA_HN_CRT, MEDIA_MINIMO_HN, MEDIA_EFETIVO_HN)

grafico_2019_atualizado = as.data.frame(grafico_2019_atualizado)
grafico_2020_atualizado = as.data.frame(grafico_2020_atualizado)

grafico_2019_atualizado$SEMANA = as.numeric(grafico_2019_atualizado$SEMANA)
grafico_2019_atualizado$MEDIA_HN = as.numeric(grafico_2019_atualizado$MEDIA_HN)
grafico_2019_atualizado$MEDIA_HN_CRT = as.numeric(grafico_2019_atualizado$MEDIA_HN_CRT)
grafico_2019_atualizado$MEDIA_MINIMO_HN = as.numeric(grafico_2019_atualizado$MEDIA_MINIMO_HN)
grafico_2019_atualizado$MEDIA_EFETIVO_HN = as.numeric(grafico_2019_atualizado$MEDIA_EFETIVO_HN)

grafico_2020_atualizado$SEMANA = as.numeric(grafico_2020_atualizado$SEMANA)
grafico_2020_atualizado$MEDIA_HN = as.numeric(grafico_2020_atualizado$MEDIA_HN)
grafico_2020_atualizado$MEDIA_HN_CRT = as.numeric(grafico_2020_atualizado$MEDIA_HN_CRT)
grafico_2020_atualizado$MEDIA_MINIMO_HN = as.numeric(grafico_2020_atualizado$MEDIA_MINIMO_HN)
grafico_2020_atualizado$MEDIA_EFETIVO_HN = as.numeric(grafico_2020_atualizado$MEDIA_EFETIVO_HN)

write_xlsx(grafico_2019_atualizado, "./saidas/CABEQ-SEMANA-2019.xlsx")
write_xlsx(grafico_2020_atualizado, "./saidas/CABEQ-SEMANA-2020.xlsx")

#limpar memória
rm(list = subset(ls(), !(ls() %in% c("wohoo", "grafico_2019", "grafico_2020", "grafico_2019_atualizado", "grafico_2020_atualizado", "wohoo2019_semanas", "wohoo2020_semanas"))))