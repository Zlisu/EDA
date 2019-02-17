# Created by Kunpeng Yang
# Last updated 2/17/2019

# Data transformation ####
library(tidyverse)
cars <- mtcars
View(cars)

# Filter ####
filter(cars, cyl == 4, gear == 5) # select cars with 4 cylnders and 5 gears
filter(cars, mpg > 30) # select cars whose mpg is above 30
filter(cars, mpg < 20 | hp > 150) # logical operator: select cars whose mpg < 20 or hp > 150

# Arrange rows ####
arrange(cars, gear, hp, mpg) # rearrange the order of rows
arrange(cars, desc(hp)) # rearrange rows by hp in desc order 

# Select columns ####
select(cars, mpg, hp, gear) # select fields
select(cars, mpg:gear) # select fields from mpg to gear

# Add new variables ####
mutate(cars, 
       power = hp/wt, # add column which is horse power per ton
       efficiency = drat/mpg)

mutate(cars, 
       km_per_Litter = mpg/1.6/3.79) # add a new column which converts mpg to km per litter


# Grouped summaries ####
summarise(cars, efficiency = mean(mpg, na.rm = TRUE)) # calculate average mpg

by_size <- group_by(cars, cyl, carb) # build groups by car size depending on cyl and carb
summarise(by_size, efficiency = mean(mpg, na.rm = TRUE)) # calculate average mpg for each groups

# calculate average mpg of cars grouped by cyl
miles <- cars %>%
  group_by(cyl) %>%
  summarise(
    effi = mean(mpg)
  )

# draw plot
ggplot(data = miles, mapping = aes(x = effi)) +
  geom_freqpoly(binwith = 10)
