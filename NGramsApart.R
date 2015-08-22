rm(list = ls())
gc()
memory.limit(size = 6000)
options(java.parameters = "-Xmx6g")

# options(warn = -1)
# Sys.setenv(JAVA_HOME =' C:\\Program Files (x86)\\Java\\jre1.8.0_51')
Sys.setenv(TZ = "Europe/Moscow")

library(RWeka)
library(rJava)
library(tm)
library(stringi)
library(stringr)
library(lattice)
library(slam)

# setwd("C:/Coursera/Data Science/10 - Capstone Project/Initial Data/en_US")

NGramsGeneration <- function(text_sample, marker) {
  
  text_sample <- iconv(text_sample, "UTF-8", "ASCII", sub = "");
  
  text_sample <- Corpus(VectorSource(text_sample))
  
  badwords <- read.csv("badwords.csv", stringsAsFactors = F, sep = ";", quote = "")[, 1]
  
  text_sample <- tm_map(text_sample, content_transformer(tolower))
  text_sample <- tm_map(text_sample,content_transformer(removeNumbers))
  text_sample <- tm_map(text_sample,content_transformer(removeWords), badwords)
  rm(badwords)
  text_sample <- tm_map(text_sample,content_transformer(removePunctuation))
  text_sample <- tm_map(text_sample,content_transformer(stripWhitespace))
  
  nmax <- 4
  
  for (i in 1:nmax) {
    options(mc.cores = 1)
    tdm <- TermDocumentMatrix(text_sample, 
                              control = list(tokenize = function(x) 
                              NGramTokenizer(x, Weka_control(min = i, max = i)),
                              wordLengths = c(1, Inf)))
    gc()
    
    if (i == nmax) {
      rm(text_sample)
    }
    
    freq_term <- rowapply_simple_triplet_matrix(tdm, sum)
    rm(tdm)
    freq_term <- sort(freq_term, decreasing = T)
    row.names(freq_term) <- NULL
    
    freq_term <- data.frame(freq_term)
    freq_term$Terms <- rownames(freq_term)
    rownames(freq_term) <- NULL
    colnames(freq_term)[1] <- "Freq"
    freq_term <- freq_term[c("Terms", "Freq")]
    
    filename <- paste0("NGrams_10_percent_", as.character(marker), as.character(i), ".RData")
    save(freq_term, file = filename)
    
    rm(freq_term)
    gc()
    
  }
}

set.seed(1981)

blogs <- readLines("en_US.blogs.txt", encoding = "UTF-8", skipNul = TRUE)
blogs_sample <- blogs[sample(length(blogs), round(length(blogs)*0.1))]
rm(blogs)

NGramsGeneration(blogs_sample, "blogs_")

rm(blogs_sample)

news <- readLines("en_US.news.txt", encoding = "UTF-8", skipNul = TRUE)
news_sample <- news[sample(length(news), round(length(news)*0.1))]
rm(news)

NGramsGeneration(news_sample, "news_")

rm(news_sample)

twitter <- readLines("en_US.twitter.txt", encoding = "UTF-8", skipNul = TRUE)
twitter_sample <- twitter[sample(length(twitter), round(length(twitter)*0.1))]
rm(twitter)

NGramsGeneration(twitter_sample, "twitter_")

rm(twitter_sample)

gc()


