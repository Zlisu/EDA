# Created by Kunpeng Yang
# Last updated 2/17/2019

# Read csv files ####
library(tidyverse) # load tidyverse package
setwd("/Users/birdfish/Documents/Github/EDA") # set working directory
data <- read_csv("Data/gapminder.csv") # import csv file

# Parcing vectors ####
# number
parse_number("3,14", locale = locale(decimal_mark = ","))
parse_number("This function extract numbers from strings like this 95%")

# Factors
animals <- c("cat", "dog") # set levels
parse_factor(c("dog", "cat", "dog"), levels = animals) # identify levels
parse_factor(c("cat", "dog", "pig"), levels = animals) # unexpected factor

# Date and/or time
parse_datetime("20190101T1230") # date and time
parse_datetime("20190101") # date only
parse_date("2019-01-01") # Expects - or / as seperator
parse_date("2019/01/01")

parse_date("19/01/01", "%y/%m/%d") # specifis layout
parse_date("19/01/01", "%d/%m/%y")

# Time
library(hms)
parse_time("12:30")
parse_time("12:30 am")

# Writing to a file ####
write_csv(data, "Data/export_csv.csv") # write data to a csv file named export.csv
write_rds(data, "Data/export_rds.rds") # use rds wrappers

install.packages("feather")
library(feather)
write_feather(data, "Data/export_feather.feather")

# Read other file types ####
read.delim("Data/RExam.dat", header = TRUE) # read .dat file
