# set the working directory and load necessary packages
library(pdftools)
library(tidyverse)
setwd("C:/Users/d5hn/Desktop/College/482")


# read in the PDF using pdftools
beckham_text <- pdf_text("VICT BECK INV.pdf") %>% readr::read_lines()
beckham_text
reform_Beckham <- beckham_text[1:111] %>%
  str_squish() %>% # removes excess white space
  str_replace_all(",", "") %>% # removes comma punctuation
  strsplit(split = " ") # splits each word in the line as it's own element

#identifying the cases in the chr variable that have information on shipped quantity and cost/unit
rows <- rep(0,111)
info_rows <- beckham_text
for (i in 1:length(beckham_text)) {
  if (str_extract_all(beckham_text[[i]],"REG") == "REG") {
    rows[i] = i
  }
}
rows <- rows[rows > 0]
rows
reform_Beckham <- reform_Beckham[rows]

#creating an empty list of lists to take in the information; moving towards the creation of a dataframe
final_Beckham <- replicate(length(reform_Beckham), list())
x <- 0
for (i in 1:length(reform_Beckham)) {
  for (j in 1:length(reform_Beckham[[i]])) {
    if (reform_Beckham[[i]][j] == "REG") {
      x <- x + 1
      final_Beckham[[x]][1] <- reform_Beckham[[i]][j + 1]
      final_Beckham[[x]][2] <- reform_Beckham[[i]][j + 2]
    }
  }
}

df_Beckham <- data.frame(units=length(final_Beckham), cost=length(final_Beckham[[1]]))

for (i in 1:length(final_Beckham)) {
  for (j in 1:length(final_Beckham[[i]])) {
    df_Beckham[i,j] <- final_Beckham[[i]][j]
  }
}



