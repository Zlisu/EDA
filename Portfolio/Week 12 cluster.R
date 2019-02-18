# Created by Kunpeng Yang
# Last updated 1/17 2019

# load packages
library(tidyverse)
library(cluster)
library(factoextra)

df <- mtcars
df <- na.omit(df) # remove missing value
df <- scale(df) # scaling to avoid influence of unit
head(df)

# Distance ####
distance <- get_dist(df) # calculate distance matrix by Euclidean
fviz_dist(distance, gradient = list(low = "#00AFBB", mid = "white", high = "#FC4E07")) # plot distance

# K-means ####
k4 <- kmeans(df, centers = 4, nstart = 25) # group the data into 4 clusters
fviz_cluster(k4, data = df) # plot the clusters

# multiple plots of different clusters
k2 <- kmeans(df, centers = 2, nstart = 25) # set clusters to 2
k3 <- kmeans(df, centers = 3, nstart = 25) # set clusters to 3
k4 <- kmeans(df, centers = 4, nstart = 25) # set clusters to 4
k5 <- kmeans(df, centers = 5, nstart = 25) # set clusters to 5

p1 <- fviz_cluster(k2, geom = "point", data = df) + ggtitle("k = 2")
p2 <- fviz_cluster(k3, geom = "point", data = df) + ggtitle("k = 3")
p3 <- fviz_cluster(k4, geom = "point", data = df) + ggtitle("k = 4")
p4 <- fviz_cluster(k5, geom = "point", data = df) + ggtitle("k = 5")

library(gridExtra)
grid.arrange(p1, p2, p3, p4, nrow=2)

# Find optimal clusters ####
set.seed(123)

fviz_nbclust(df, kmeans, method = "wss")

# Average Silhousette Method ####
fviz_nbclust(df, kmeans, method = "silhouette")

# Gap Statistic Method ####
gap_stat <- clusGap(df, FUN = kmeans, nstart = 25,
                    K.max = 10, B = 50)
fviz_gap_stat(gap_stat)

# Extracting Results ####
# Analysis above found the optimal number of clusters is 9 or 10
# I will perform final analysis with 9 clusters
set.seed(111)
final <- kmeans(df, 9, nstart = 25)
print(final) # print out the result
fviz_cluster(final, data = df) # plot the clusters
