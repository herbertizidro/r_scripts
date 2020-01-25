if("pacman" %in% rownames(installed.packages()) == FALSE) {install.packages("pacman")}
pacman::p_load(dplyr, openxlsx, ggplot2, reshape2, plotly)


#lê os dados
refugiados_dataset = read.xlsx("1990-a-2019-solicitacoes-de-reconhecimento-da-condicao-de-refugiado.xlsx",
                               sheet = 1, startRow = 1, colNames = TRUE)


#muda o nome da coluna "MêsAno" para "Ano"
names(refugiados_dataset)[3] = "Ano"


#colunas "Nacionalidade", "Ano" e "Quantidade" apenas
#altera os valores da coluna "Ano", ex: de "05/2015" para "2015" 
refugiados_dataset = cbind(Nacionalidade = refugiados_dataset$Nacionalidade, 
                           Ano = substr(refugiados_dataset$Ano, start = 4, stop = 7), 
                           Total = refugiados_dataset$Quantidade)

refugiados_dataset = data.frame(refugiados_dataset)
refugiados_dataset$Total = type.convert(refugiados_dataset$Total)


#agrupa onde ano e nacionalidade são iguais e soma os totais
refugiados_dataset = refugiados_dataset %>% group_by(Ano, Nacionalidade) %>% summarise(Total = sum(Total))


#TOP 10
#ordem decrescente
refugiados_dataset = refugiados_dataset %>% arrange(desc(Total))
top10 = unique(refugiados_dataset$Nacionalidade)
top10 = top10[2:11] #sem Venezuela


#filtra 2010 a 2019 e paises no TOP 10
decada = as.character(2010:2019)
refugiados_dataset = refugiados_dataset %>% 
  filter(Ano %in% decada & Nacionalidade %in% top10)


#gráfico de linhas
grafico_linhas = ggplot(refugiados_dataset, aes(x = Ano, y = Total, colour = Nacionalidade, group = 1)) +
  geom_line() +
  geom_point(size = 2) +
  theme_minimal() +
  ggtitle("Países que mais solicitaram refúgio ao Brasil 2010-2019") +
  scale_color_manual(values = c("#1E90FF", "#FF0000", "#000000", "#FF00FF", "#32CD32", "#8470FF", "#FFC125", "#0000FF", "#8B4513", "#006400")) +
  theme(legend.background = element_rect(fill = "#E0FFFF", size = 0.5, linetype = "blank"))


#converte pra versão interativa com plotly
grafico_linhas = ggplotly(grafico_linhas)
grafico_linhas


