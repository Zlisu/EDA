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
