#A demonstration of data manipulation for Peggy
#Rosemary Hartman, 9 August, 2019

#This demonstrates how to switch data from "long" to "wide"

#first load the "tidyverse" set of R packages
library(tidyverse)

#now upload the data

demo = read.csv("spreaddemodata.csv")


#see what it looks like
str(demo)

#reorder the "season" factor
demo$Season = factor(demo$Season, levels = c("winter", "spring", "summer", "fall"))

#make a new variable that combines season and year
#we'll make "Season" into a number, winter = 1, spring =2, summer = 3, fall = 4
demo$yearseason = paste(demo$Year, as.numeric(demo$Season))

#remove the old "year" and "season" values
demo$Year = NULL
demo$Season = NULL

#now flip it so "yearseason" are the column names, biovolume is the value, and "Species" are
#the row names

demo2 = pivot_wider(data = demo, names_from = yearseason, values_from = Biovolume)

#if you want to go back to "long" format, use "pivot_longer"

demo3 = pivot_longer(demo2, names_to = "yearseason", values_to = "Biovolume", -Species)

#convert "yearseason" back to "year and "season"

demo3$Year = substr(demo3$yearseason, 1, 4)
demo3$Season = factor(substr(demo3$yearseason, 6,6), levels = c(1,2,3,4), 
                      labels = c("winter", "spring", "summer", "fall"))
