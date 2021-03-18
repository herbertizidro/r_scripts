library('readxl')
library('tidyverse')
library('plotly')


# VISUALIZAÇÃO
# TEMPO MÉDIO DE VEICULAÇÃO POR SEMANA DOS ANOS 2019 E 2020

grafico_2019_atualizado = read_excel("./saidas/CABEQ-SEMANA-2019.xlsx")
grafico_2020_atualizado = read_excel("./saidas/CABEQ-SEMANA-2020.xlsx")

wohoo_cabeq = cbind(grafico_2019_atualizado[, c(1,2,5,6)], grafico_2020_atualizado[, c(6)])
names(wohoo_cabeq)[3] = "MEDIA_SEMANAL_MINIMA"
names(wohoo_cabeq)[4] = "MEDIA_SEMANAL_VEICULADA_2019"
names(wohoo_cabeq)[5] = "MEDIA_SEMANAL_VEICULADA_2020"
wohoo_cabeq = wohoo_cabeq[, c(2,3,4,5)]


g1 = ggplot(wohoo_cabeq) +
  geom_line(aes(x = SEMANA, y = MEDIA_SEMANAL_VEICULADA_2019, colour="MÉDIA SEMANAL 2019")) +
  #geom_line(aes(x = SEMANA, y = MEDIA_HN_CRT), color='orange') +
  geom_line(aes(x = SEMANA, y = MEDIA_SEMANAL_MINIMA, colour="MÉDIA SEMANAL MÍNIMA")) +
  geom_line(aes(x = SEMANA, y = MEDIA_SEMANAL_VEICULADA_2020, colour="MÉDIA SEMANAL 2020")) + 
  scale_color_discrete(name = "variáveis", labels = c("X", "Y", "Z")) +
  scale_y_time(labels = function(l) strftime(l, '%H:%M:%S')) +
  labs(x = "Semanas", y = "Tempo") +
  #scale_x_date(date_labels = '%d/%m', breaks = "months") +
  ggtitle("Tempo médio de veiculação por semana - WOHOO 2019 e 2020") +
  theme_minimal()

g1 = ggplotly(g1)