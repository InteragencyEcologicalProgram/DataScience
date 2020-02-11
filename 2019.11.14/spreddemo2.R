#A demonstration of data manipulation
#Rosemary Hartman, 11 November, 2019

#This demonstrates how to switch data from "long" to "wide". 
#I origionally put this together for a coworker who was trying to convert 
#her dataset from one in "long" format to one in "wide" format
#where the columns were season-by-year.

#I suggested the best way to do this was using functions in dplyr and tidyr

#first load the "tidyverse" set of R packages
library(tidyverse)

#now upload the data

demo = read.csv("2019.11.14/spreaddemodata.csv")


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
demo = select(demo, -Year)

#If you're feeling fancy, you can also use the "mutate" function to do this all at once
demo = mutate(demo, yearseason = paste(Year, as.numeric(Season), sep = "_"), Year = NULL, Season = NULL)

demo = unite(demo, col = "test", Biovolume, Species, sep = "_")

View(demo)

#Now flip it so "yearseason" are the column names, biovolume is the value, and "Species" are
#the row names. I did this using the pivot_wider function, which is the latest and greatest
#way to do this. (it replaces "spread", which replaced "cast")

demo2 = pivot_wider(data = demo, names_from = yearseason, values_from = Biovolume)
View(demo2)

#We have a missing value in one of our rows, since there was no species-year combination
#in the origional data set. TO replace it we use the  "values_fill" term in the pivot_wider function

demo2 = pivot_wider(data = demo, names_from = yearseason, 
                    values_from = Biovolume, values_fill = list(Biovolume = 0))
View(demo2)


#if you want to go back to "long" format, use "pivot_longer"
?pivot_longer
demo3 = pivot_longer(demo2, names_to = "yearseason", values_to = "Biovolume", -Species)
View(demo3)

#notice that we now have an extra observation because we added the "0" back in
nrow(demo3)
nrow(demo)

#You can convert "yearseason" back to "year and "season" using the "seperate" function

demo3 = separate(demo3, col = yearseason, into = c("Year", "Season"), sep = " ")

#turn "season" into a named factor again
demo3 = mutate(demo3, Season = factor(Season, levels = c(1,2,3,4), 
                      labels = c("winter", "spring", "summer", "fall")))

View(demo3)

#Just for fun, let's put it into columns by species

demo4 = pivot_wider(demo, names_from = Species, values_from = Biovolume)

#The sky's the limit!

#We can pivot multiple variables at once

#Add an example variable
demo = mutate(demo, abundance = rnorm(nrow(demo)))

#now transpose it
demo5 = pivot_wider(data = demo, names_from = Species, values_from = c(Biovolume, abundance))
View(demo5)


#or if you want to drop one of them

demo6 = pivot_wider(data = demo, id_cols = yearseason, 
                    names_from = Species, values_from = Biovolume)
View(demo6)



demo6 = pivot_wider(data = demo,
                    names_from = Species, values_from = Biovolume)
View(demo6)
