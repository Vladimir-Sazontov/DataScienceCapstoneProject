WB <- function(input_text, n_show) {
  
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
  
  FT <- data.frame(as.character(NULL), numeric(0), numeric(0))
  
  P_wb <- function(FTemp, len, FTL) {
    if (!is.data.frame(FTemp)) {
      return(NULL)
    }
    else if (dim(FTemp)[1] == 0) {
      return(NULL)
    }
    else {
      FTempNew <- FTemp
      if (len > 1) {
        P <- as.vector(NULL)
        for (i in 1:dim(FTempNew)[1]) {
          j <- 1
          while (j <= len) {
            FTempNew$Terms[i] <- paste(word(FTemp$Terms[i], (len-j+1):len), collapse = " ")
            if (j == 1) {
              if (!(FTempNew$Terms[i] %in% FTL[[1]]$Terms)) {
                FTempNew$Freq[i] <- 0
              }
              else{
                FTempNew$Freq[i] <- FTL[[1]][FTL[[1]]$Terms %in% FTempNew$Terms[i], ]$Freq
              }
              P[i] <- FTempNew$Freq[i]/sum(FTempNew$Freq)
            }
            else {
              Context <- paste("^", paste(word(FTemp$Terms[i], (len-j+1):(len-1)), collapse = " "), sep = "")
              N <- length(grep(Context, FTL[[j]]$Terms))
              if (!(FTempNew$Terms[i] %in% FTL[[j]]$Terms)) {
                FTempNew$Freq[i] <- 0
              }
              else{
                FTempNew$Freq[i] <- FTL[[j]][FTL[[j]]$Terms %in% FTempNew$Terms[i], ]$Freq
              }
              P[i] <- (FTempNew$Freq[i] + N*P[i])/(sum(FTempNew$Freq) + N)
            }
            j <- j + 1
          }
        }
      }
    }
    return(P)
  }
  
  
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
      if (dim(FTemp)[1] != 0) {
        FTemp$P_wb <- P_wb(FTemp, len, FTL)
        FTemp <- FTemp[order(FTemp$P_wb, decreasing = T), ]
      }
      else{
        FTemp <- data.frame(as.character(NULL), numeric(0), numeric(0))
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