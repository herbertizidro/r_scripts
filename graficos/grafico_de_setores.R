if("pacman" %in% rownames(installed.packages()) == FALSE) {install.packages("pacman")}
pacman::p_load(dplyr, openxlsx, ggplot2, reshape2, plotly)


#lê os dados
refugiados_dataset = read.xlsx("1990-a-2019-solicitacoes-de-reconhecimento-da-condicao-de-refugiado.xlsx",
                               sheet = 1, startRow = 1, colNames = TRUE)

#muda o nome da coluna "MêsAno" para "Ano"
names(refugiados_dataset)[3] = "Ano"

#colunas "Nacionalidade", "Ano" e "Quantidade" apenas
#altera os valores da coluna "Ano", ex: de "05/2015" para "2015" 
refugiados_dataset = cbind(nacionalidade = refugiados_dataset$Nacionalidade, 
                           ano = substr(refugiados_dataset$Ano, start = 4, stop = 7), 
                           total = refugiados_dataset$Quantidade)

#
refugiados_dataset = data.frame(refugiados_dataset)
refugiados_dataset$total = type.convert(refugiados_dataset$total)

#agrupa onde nacionalidade e ano são iguais e soma os totais
refugiados_dataset = refugiados_dataset %>% group_by(nacionalidade, ano) %>% summarise(total = sum(total))

#ordem decrescente
refugiados_dataset = refugiados_dataset %>% arrange(desc(total))

#top 10 países
paises = unique(refugiados_dataset$nacionalidade)
paises = paises[2:11] #só pra venezuela não aparecer pois possui um valor muito alto e atrapalha a visualização
#dos outros países. pra voltar a aparecer basta mudar para [1:10]
refugiados_dataset = filter(refugiados_dataset, nacionalidade %in% paises)

#reorganiza a tabela para que os anos passem a ser colunas
refugiados_dataset = reshape2::dcast(refugiados_dataset, nacionalidade ~ ano)

#somente colunas entre 2010 e 2019
decada = select(refugiados_dataset, "2010":"2019")

#isolando coluna "nacionalidade"
nacionalidade = refugiados_dataset$nacionalidade

#soma dos valores das colunas
total = rowSums(decada[, 1:10], na.rm = TRUE)

#junção da coluna "nacionalidade" com as colunas "decada" e a coluna "total"
refugiados_dataset = cbind(nacionalidade, decada, total)

#ordem decrescente
refugiados_dataset = refugiados_dataset %>% arrange(desc(total))

frequencia_relativa = 100 * prop.table(refugiados_dataset$total)
refugiados_dataset = cbind(refugiados_dataset, frequencia_relativa = round(frequencia_relativa, digits = 1))
names(refugiados_dataset)[13] = "freq(%)"
View(refugiados_dataset)

#gráfico de setores com plotly
grafico_setores = plot_ly(refugiados_dataset, labels = ~nacionalidade, values = refugiados_dataset$total, type = 'pie') %>%
  layout(title = 'Total Solicitações de Refúgio(2010-2019)',
  xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
  yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))

grafico_setores