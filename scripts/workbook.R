wb = createWorkbook()

addWorksheet(wb,"sheet1")
addWorksheet(wb,"sheet2")

writeDataTable(wb, "sheet1", mtcars)
writeDataTable(wb, "sheet2", starwars)

arquivo = paste0("mtcars-starwars.xlsx")

saveWorkbook(wb, file = arquivo, overwrite = TRUE)
