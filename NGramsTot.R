rm(list = ls())
gc()
# memory.limit(size = 6000)

mergeDFs <- function (df1, df2){
  df1 <- df1[order(df1$Terms), ]
  df2 <- df2[order(df2$Terms), ]
  
  df1$Freq[df1$Terms %in% df2$Terms] <- df1$Freq[df1$Terms %in% df2$Terms] + df2$Freq[df2$Terms %in% df1$Term]
  df3 <- rbind(df1, df2[!(df2$Terms %in% df1$Terms), ])
  return(df3)
}
load("NGrams_10_percent_blogs_4.Rdata")
df1 <- freq_term[freq_term$Freq > 1, ]
rm(freq_term)
load("NGrams_10_percent_news_4.Rdata")
df2 <- freq_term[freq_term$Freq > 1, ]
rm(freq_term)
df21 <- mergeDFs(df1, df2)
rm(df1, df2)
load("NGrams_10_percent_twitter_4.Rdata")
df3 <- freq_term[freq_term$Freq > 1, ]
rm(freq_term)
df_ult <- mergeDFs(df21, df3)
rm(df21, df3)
df_ult <- df_ult[order(df_ult$Freq, decreasing = T), ]
rownames(df_ult) <- NULL
save(df_ult, file = "NGrams_10_percent_total_4.RData")
# rm(df_ult)