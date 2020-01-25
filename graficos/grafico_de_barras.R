if("pacman" %in% rownames(installed.packages()) == FALSE) {install.packages("pacman")}
pacman::p_load(dplyr, openxlsx, ggplot2)


#lê os dados
refugiados_dataset = read.xlsx("1990-a-2019-solicitacoes-de-reconhecimento-da-condicao-de-refugiado.xlsx",
      sheet = 1, startRow = 1, colNames = TRUE)

#colnames(refugiados_dataset)
#
#[1] "Tipo.de.Alertas.e.Restrições" 
#[2] "Nacionalidade"                
#[3] "MêsAno"                      
#[4] "UF"                           
#[5] "Quantidade"


#seleciona tudo que não for "APÁTRIDA", "NACIONALIDADE INDEFINIDA" e "VENEZUELA"
refugiados_dataset = refugiados_dataset %>% 
  filter(!(Nacionalidade == "APÁTRIDA" | Nacionalidade == "NACIONALIDADE INDEFINIDA"))


#com while: calcula o total de solicitacoes de cada pais
aux = 1
TOTAL = c()
NACIONALIDADE = unique(refugiados_dataset$Nacionalidade)

while(aux <= length(NACIONALIDADE)){
  if(is.na(NACIONALIDADE[aux]) == FALSE){ #verifica se tem algum NA
    total_pais = refugiados_dataset[refugiados_dataset$Nacionalidade == NACIONALIDADE[aux], ]
    total_pais = sum(total_pais$Quantidade)
    TOTAL = c(TOTAL, total_pais)
    aux = aux + 1
  }
}


#junção de "paises" e "TOTAL"
solicitacoes_por_pais = tibble(NACIONALIDADE, TOTAL)


#ordena a tabela por meio da coluna TOTAL(decrescente)
solicitacoes_por_pais = solicitacoes_por_pais %>% arrange(desc(TOTAL))


top10 = solicitacoes_por_pais[1:10,]


#gráfico de barras
ggplot(top10) +
        geom_bar(
        aes(x = NACIONALIDADE, y = TOTAL),
        stat = "identity", 
        color = "red",  #contorno
        fill = "pink"    #preenchimento
        ) + theme_minimal() + #tema
        ggtitle("TOP 10 - Países que mais solicitaram refúgio ao Brasil(1990-2019)")
        