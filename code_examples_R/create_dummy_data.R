# title: dummy data generator
# author: Lisette de Schipper
# date: "30-04-2024"
# description: Create Dummy data

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

nrows = 200000000

df <- data.frame(ID = seq(1, nrows, by=1))

df["column1"] <- sample(LETTERS[1:5],nrows, TRUE)

df["column2"] <- runif(nrows, min=5, max=15)

df["column3"] <- sample(c(TRUE,FALSE), nrows, TRUE)

df["column4"] <- sample(c("potato","tomato", "banana", "shoe"), nrows, TRUE)

haven::write_sav(df, r"(..\dummy_data\simpledummyset.sav)")