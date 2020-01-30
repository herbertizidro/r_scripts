library(gtools)
library(tidyverse)

df1 <- read.csv2(file = "janeiro-2018.csv")
df2 <- read.csv2(file = "fevereiro-2018.csv")
df3 = smartbind(df1, df2) #junta verticalmente duas ou mais tabelas
write.csv(df3, file = "jan-fev-2018.csv")
