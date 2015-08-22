NTP <- function(input_text, n_show) {
  
  Sys.setenv(TZ = "Europe/Moscow")
  
  library(tm)
  library(stringr)
  load("FTL.RData")
  
  input_text <- iconv(input_text, "UTF-8", "ASCII", sub="")
  input_text <- tolower(input_text)
  input_text <- gsub("he's", "he is", input_text)
  input_text <- gsub("it's", "it is", input_text)
  input_text <- gsub("'s", "", input_text)
  
  input_text <- gsub("i'm", "i am", input_text)
  input_text <- gsub("'ve", " have", input_text)
  input_text <- gsub("'re", " are", input_text)
  
  input_text <- gsub("can't|cannot", "can not", input_text)
  input_text <- gsub("won't", "will not", input_text)
  input_text <- gsub("'ll", " will", input_text)
  input_text <- gsub("'d", " would", input_text)
  
  input_text_corpus <- VCorpus(VectorSource(input_text))
  # input_text_corpus <- tm_map(input_text_corpus, content_transformer(tolower))
  input_text_corpus <- tm_map(input_text_corpus, removePunctuation)
  input_text_corpus <- tm_map(input_text_corpus, removeNumbers)
  input_text_corpus <- tm_map(input_text_corpus, stripWhitespace)
  
  input_text <- as.character(input_text_corpus[[1]])
  input_text <- gsub("(^[[:space:]]+|[[:space:]]+$)", "", input_text)
  
  input_text <- unlist(strsplit(input_text, split = " "))
  input_text_len <- length(input_text);
  if (input_text_len == 0) {
    return("")
  }
  
  FT <- data.frame(as.character(NULL), numeric(0))
  
  nmax <- 4
  
  for (i in (nmax-1):1) {
    if (input_text_len >= i) {
      input_text_cut <- paste(input_text[(input_text_len-(i-1)):input_text_len], collapse = " ")
      search_str <- paste("^", input_text_cut, " ", sep = "")
      len <- i + 1
      FTemp <- FTL[[len]][grep(search_str, FTL[[len]]$Terms), ]
      FTemp <- FTemp[order(FTemp$Freq, decreasing = T), ]
      if (dim(FTemp)[1] > n_show) {
        FTemp <- FTemp[1:n_show, ]
      }
      FT <- rbind(FT, FTemp)
    }
  }
 
  if ((length(FT[ , 1]) == 0) & input_text_len > 0)
  {
    FT <- rbind(FT, FTL[[1]][1:n_show, ])
  }
  
  row.names(FT) <- NULL
  
  #   FT <- FT[1:n_show, ]
  #   return(FT)
  
  FT$Terms <- word(FT$Terms, -1)
  FT <- FT[, 1]
  FT <- unique(FT)
  if (length(FT) >= n_show) {
    FT <- FT[1:n_show]    
  } else {
    FT <- FT
  }
  
  return(FT)
}