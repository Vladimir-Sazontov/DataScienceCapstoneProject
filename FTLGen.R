rm(list = ls())
gc()

FTL <- list(NULL)

nmax <- 4

for (i in 1:nmax) {
  
  filename <- paste0("NGrams_10_percent_total_", as.character(i), ".RData")
  load(file = filename)
  df_ult <- df_ult[df_ult$Freq > 2, ]
  FTL[[i]] <- df_ult
  rm(df_ult)
  
  save(FTL, file = "FTL.RData")
  
}
