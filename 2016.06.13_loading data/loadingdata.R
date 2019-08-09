# How to load your data! And a few helpful functions for working with it.
# Rosemary Hartman Rosemary.Hartman@wildlife.ca.gov
#
# THe most useful way of loading your data into R is to first put it
# in a .csv file. Working with it a little bit in excel first
# will help you get it into R. In particular, make sure all your
# column heading names are meaningful, but relatively short, because
# you will be working with them a lot.

# A few things to remember about R:
# R is case-sensative, so "FishLenght" is not the same as "fishlength".
# Spaces count, but periods do not, so "fish length" is two variables, but "fish.length" 
# is one variable.
# There are some stylistic things that most R users conform to, ignoring
# style won'e hurt you, but it will make it harder to communicate with others.
# Review the style guide here: https://google.github.io/styleguide/Rguide.xml

# So, start with your excel file of your data. Make sure all the 
# headers are one word, all lower case, with multi-word headers
# seperated by periods. You cannot start a variable name with a number,
# and do not include special characters in the headers.

# Now lets load it into R. You can use the "Import Dataset" button in 
# RStudio, or the "read.csv" funtions.

beachseines <- read.csv("~/Desktop/bdrug/beachseines.csv")
# R will automatically look for the file in the folder for the working directory.
# It will load it as a data frame object, with the headers as column labels.


# If you are not sure where it is looking, use this function:
getwd()

# If you want to change the working directory:
setwd("c:/Desktop/bdrug")  # note / instead of \ in windows 

# Now let's take a look at the data. You can click on the dataset listed
# in the "Environment" tab of Rstudio, or use the "view" fucntion.

View(beachseines)
# Notice that our missing vale was automatically replaced with "NA"

# If we want to look at part of the data frame at a time, there are a few different ways of doing that.
# The $ after the name of a data frame selects a certain column from the data frame

beachseines$species

# Alternately, we can use square brackets after the name to select certain rows or columns
beachseines[,4] #first column

beachseines[1,] # first row

beachseines[2,"species"] # you can use the row or column label instead of number if you put it in quotes


# Our dataset had a mix of different data types. R will detect some of them automatically,
# but it might not have gotten them all right. Let's check:

str(beachseines)

# Notice that it automatically turned our fish name character strings
# into a factor. However, it also put our date as a factor, and it
# put our site number as an integer. We want date to be a "date"
# and we want site to be a factor. Let's fix that

beachseines$date = as.Date(beachseines$date, "%m/%d/%y") # This tells it that we want it to be a date, 
# and it is currently in the format "month/day/year"
# For the codes for other date formats, check out
?strptime # You can also access the help file using help(strptime)

beachseines$site.num = as.factor(beachseines$site.num)
# this tells it that "site.num" isn't really a number, just the name of the site.

#Check our dataset again:
str(beachseines)

# Looks good! Now let's try a little basic math.
#What is the average length of Delta Smelt we caught?
mean(beachseines$fl[which(beachseines$species=="DELSME")])

# What is the average length of striped bass we caught?
mean(beachseines$fl[which(beachseines$species=="STRBAS")])
# Shoot! We have a missing value in there. We need to tell R
# what to do with it.
mean(beachseines$fl[which(beachseines$species=="STRBAS")], na.rm=T)

# It would be a lot easier and faster if we averaged all the species at once,
# instead of one at a time. To do that, we are going to load our first package.

install.packages("plyr") # install it if you haven't already
library(plyr) # load it into your current work session. Note:
# You have to load packages each time you start R. It won't remember them.

# I'll talk more about this package later if we have time, but
# it is one of the best for data manipulation.

(meanfl = ddply(beachseines, .(species), summarize, avefl = mean(fl, na.rm=T))) # putting brackets around the whole line prints it
# This function takes the dataframe "beachseines", groups it by species,
#summarizes it using mean, and makes a new data frame with the results.

View(meanfl)


