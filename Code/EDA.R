# Created by Kunpeng Yang
# Last updated 1/17 2019

# import data 
df <-read.csv("Data/bikeVendors.csv")

# View data
top_n(df, 10)

# add a new column which is the average market share among all stores of a certain bike
library(tidyverse)
df <- df %>%
  mutate(Avg = select(., Albuquerque.Cycles:Wichita.Speed) %>% rowSums(na.rm = TRUE)/30)

levels(df$category1)
levels(df$category2)
levels(df$frame)

# View data structure
str(df)




# Explore data -----------------------------------------------------------
## by price ------------------------
df1 <- df[order(df$price),] # sort data by price
barplot(df1$price, names.arg=df1$model, xlab = "Bike model", ylab = "Price",
        main = "Bike Price", col = "green", border = "white")

boxplot(df$price, main = "Bike Price")

boxplot(df$price~df$category1, ylab = "Average Price") # Mountain bike vs Road bike

## by market share -----------------


# select mountain bikes
mountain <- subset(x = df, subset = category1 == "Mountain")
# select road bikes
road <- subset(x = df, subset = category1 == "Road")
# plot mountain bike mkt shares
plot(mountain$Avg, type = "o", col = "red", xlab = "Bike model", ylab = "Average Market Share",
     main = "Average market share of bikes by categories")
# add line of road bike shares
lines(road$Avg, type = "o", col = "blue")

# box plot
boxplot(df$Avg ~ df$category1, ylab = "Average Market Share")



## clusters--------------------------------------------------
library(cluster)
library(factoextra)

# drop categorial data fields
drops <- c("model", "category1", "category2", "frame")
bike2 <- df
bike2 <- bike2[, !(names(bike2) %in% drops)]

# use bike models as row names
bike_model <- df$model
row.names(bike2) <- bike_model

bike2$price <- as.numeric(bike2$price)

bike2 <- na.omit(bike2) # remove missing value
bike2 <- scale(bike2) # scaling to avoid influence of unit

set.seed(123)

fviz_nbclust(bike2, kmeans, method = "wss")

# Average Silhousette Method 
fviz_nbclust(bike2, kmeans, method = "silhouette")

# Gap Statistic Method 
gap_stat <- clusGap(bike2, FUN = kmeans, nstart = 25,
                    K.max = 10, B = 50)
fviz_gap_stat(gap_stat)

# use 4 clusters
k4 <- kmeans(bike2, centers = 4, nstart = 25)
fviz_cluster(k4, data = bike2)


# Price ~ Category t-test ----------------------------------------------
# check dependent variable distribution
plot(density(df$price))

# check skewness
library(moments)
agostino.test(df$price)
# fix positive skew
agostino.test(log(df$price))

# build model
price_category <- t.test(log(price) ~ category1, data = df)
price_category

# Price ~ Frame t test ----------------------------------------------
# View average price of different types of bikes 
boxplot(df$price~df$frame, ylab = "Average Price")

# check distribution
plot(density(df$price))

# check skewness
library(moments)
agostino.test(df$price)
# fix positive skew
agostino.test(log(df$price))

# build model
price_category <- t.test(log(price) ~ frame, data = df)
price_category

# Which model has the highest market share -----------------------------------------

# Adding a colume of average market share
# row sum is divided by 30 because there are 30 stores in the dataset
library(tidyverse)
df <- df %>%
  mutate(Avg_percentage = select(., Albuquerque.Cycles:Wichita.Speed) %>% rowSums(na.rm = TRUE)*100/30)

# sort data by average market share
sorted_mkt <- df[order(df$Avg_percentage, decreasing = TRUE),] 

sorted_mkt[, c("model", "category1", "price", "Avg_percentage" )]

# Market share ~ price ####
# Distribution of dependent variable
plot(density(df$Avg_percentage))
agostino.test(df$Avg_percentage)

agostino.test(log(df$price))

# identify relationship between predictor and dependent variable
library(car)
scatterplot(df$price, df$Avg_percentage)

# linear regression model
mkt_model <- lm(df$Avg_percentage ~ df$price)
summary(mkt_model)

# check residuals
qqnorm(mkt_model$residuals)
qqline(mkt_model$residuals)
shapiro.test(mkt_model$residuals)
