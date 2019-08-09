####################  Day 2  ###############################
#####           If Statements        #######################
 
# When performing an analysis or writing a program, we often need to look at the data and do 
# one action if a condition is met, and another action is the condition is not met. For example,
# if we wanted to classify a fish as a large or small based on its size we would need to compare
# the size of an individual fish to the cutoff size that we specify. We can do this using an 'if'
# statement. 

# In order to make these comparisons, the first thing we will need are some comparison operators.
# Fortunately, you're already familiar with most of these from math classes, but some are unique
# to R, so let's review the more common operators:

# x < y ; x is less than y
# x <= y ; x is less than or equal to y
# x > y ; x is greater than y
# x >= y ; x is greater than or equal to y
# x == y ; x is equal to y - Note that these are comparison operators, so they are not setting x equal to y,
#                               but asking if x is equal to y. To set x equal to y we would use a
#                               single equal sign or the assignment operator (<-)
# x != y ; x is not equal to y
# x | y ; x or y
# x & y ; x and y

# Now let's learn by doing!

# The general form of an if statement is:
# if (conditional statement) action

# this translates to if the result of some comparison (conditional statement) is true, then do some action.

# create abundance object and assign value of 10
abundance <- 10

#determine if abundance is greater than zero
abundance > 0 

#Now, what if we want to do something if that condition is TRUE

#make comparison
if(abundance > 0) present <- 1

#check to make sure it did what we thought it did
present

#Let's see what happens if abundance is equal to zero
# First we remove the object we just made so we know that we are starting from scratch
rm(present)

#set abundace to zero
abundance = 0

#make comparison
if(abundance > 0) present = 1

#check
present

### hmmm...I guess we need to specify something ELSE
if(abundance > 0) present = 1 else present = 0
present

# This translates to: if abundance is greater than zero, set the object present equal to 1, but if 
#                       abundance is less than or equal to zero set the object present to 0

#Now, what if we wanted to do multiple things under different conditions? We use the squiggly brackets.
if(abundance >0) {
  present = 1
  occupied = TRUE
} else {
  present = 0
  occupied = FALSE
}

#print results
c(present, occupied)

#### Another example
library(lubridate)
new.date <- mdy('5/13/2011')

#assign a season based on date 
# need to make a condition based how two conditions
# need to use an operator - check operator table
if(month(new.date) > 3 & month(new.date) < 7){
  season = 'spring'
} else {
  season = 'other'
}

#Now what if we wanted to assign it to winter if it is between
#November and April
#change date
new.date <- mdy('2/11/2103')

if(month(new.date) > 11 & month(new.date) < 3){
  season = 'winter'
} else {
  season = 'other'
}

season

## hmmm...that didn't work - why not? Hint: is it possible to be both greater than 11 and less than 3?
if(month(new.date) > 11 | month(new.date) < 3) {
  season = 'winter'
} else {
  season = 'other'
}

season

#Now lets work with multiple values
## Since this is a new day, let's set our working directory
setwd('C:\\Users\\mjh797\\Google Drive\\course development\\R workshop')

### read in the dates.csv
date.df <- read.csv('dates.csv')

#make the first column into a vector of dates
dateVec <- mdy(dates[,1])

#identify days greater than or equal to 15
day(dateVec) >= 15

#make a new variable based on condition
if(day(dateVec) >= 15) month.part = 'end' else month.part = 'early'

# These 'if statements' are really powerful, but we can only make one comparison at a time. 
# To make more comparison we could use a for loop.

#######          For loops!!!!            #######
# basic syntax
# for(i in start:end){
#   do something (end-start) times
# }

Y=10
for(i in 1:10){
  #add 2 to Y
  Y = Y+2
  Y
}

#need a print statement
for(i in 1:10){
  #add 2 to Y
  Y = Y+2
  print(Y)
}

#why is the last value different than what we saw before? 
# We never reset the original value

#what if we want to save things to a vector Z
Z <- rep(NA, 10) #intialize vector
Y=10
for(i in 1:length(Z)){
  #add 2 to Y
  Y = Y+2
  #save values
  Z[i]=Y
}

## Let's do a quick ecology example
#set initial population size
N=100
growth.rate <- 1.05

#first lets figure out what we want to do
N.time2 <- N*growth.rate

#lets create a time series vector to hold our answers
time.series <- rep(NA, 10)
time.series[1] <- N

for (year in 2:length(time.series)){
  #grow the population
  N = N*growth.rate
  time.series[year] <- N
}

## back to the date example
#initialize our new variable
month.part <- rep(NA, length(dateVec))

for(i in 1:length(dateVec)){
  if(day(dateVec)[i] >=15) 
    month.part[i] = 'end'
  else
    month.part[i] = 'start'
}

#check and see if it's correct
month.part

#breaking the for loop - what happens if we need to stop
N=10
growth.rate=0.85

time.series <- rep(NA, 100)
time.series[1] <- N

for(i in 1:length(time.series)){
  N = N*growth.rate
  time.series[i] <- N
  
  #break loop if population goes extinct
  if(N<1) break
}

time.series

#debugging - can set the value of i and just run the code line by line

#vectorization - after all that, there is an easier way
ifelse(day(dateVec)>=15, yes = 'end', no = 'start') 

#Also the apply functions that we went over yesterday are another method of vectorization
#They make your code run faster - but sometimes a loop is much more intuitive. 
# When I was just starting out, I just did what made sense and then tried to improve
# the efficiency of my code afterwards.

#########################   Functions!!!    #################
#To create a function - we declare it using the 'function' function
#A function can take one or more arguments

#create a vector
testVec <- seq(1:5)

#how would we calculate the mean (without the mean function)
sum(testVec)/length(testVec)

#now lets write a more general function that can work with any input
my.mean <- function(variable){
  sum(variable)/length(variable)
}

my.mean(testVec)

#let's create a function with more than 1 input
#create a function for dividing 2 numbers and squaring the result
my.add.square <- function(a,b){
  (a/b)^2
}

my.add.square(5,2)

#reverse the numbers
my.add.square(2,5)

#variables within a function are local variables - not saved to the working directory

#let's create a function to calculate means and standard deviations for multiple columns
#import the hw_dat.csv

#intialize a summary table
summary.table <- data.frame(var.mean = rep(NA,2), var.sd = rep(NA,2), var.min = rep(NA,2), var.max = rep(NA,2))

make.sum.table <- function(dat, first.col){
  #save column names

  table.row = 1
  for (i in first.col:length(dat)){
    summary.table[table.row,1] <- mean(dat[,i])
    summary.table[table.row,2] <- sd(dat[,i])
    summary.table[table.row,3] <- min(dat[,i])
    summary.table[table.row,4] <- max(dat[,i])
    table.row <- table.row +1
  }
  
  row.names(summary.table) <- names(dat)[first.col:length(hw_dat)]
  return(summary.table)
}

make.sum.table(hw_dat, 2)

# setting default values
make.sum.table <- function(dat, first.col=2){
  #save column names
  
  table.row = 1
  for (i in first.col:length(dat)){
    summary.table[table.row,1] <- mean(dat[,i])
    summary.table[table.row,2] <- sd(dat[,i])
    summary.table[table.row,3] <- min(dat[,i])
    summary.table[table.row,4] <- max(dat[,i])
    table.row <- table.row +1
  }
  
  row.names(summary.table) <- names(dat)[first.col:length(hw_dat)]
  return(summary.table)
}

#lets try this with another dataset!
stream.habitat <- read.csv("stream.habitat.csv")

##### debugging
make.sum.table(dat = stream.habitat, first.col = 4)

# Error in `row.names<-.data.frame`(`*tmp*`, value = c("Length", "Habitat" : 
# invalid 'row.names' length

## hmmm...lets see if we if we can figure this out
dat <- stream.habitat
first.col = 4

make.sum.table <- function(dat, first.col=2){
  #save column names
  
  table.row = 1
  for (i in first.col:length(dat)){
    summary.table[table.row,1] <- mean(dat[,i])
    summary.table[table.row,2] <- sd(dat[,i])
    summary.table[table.row,3] <- min(dat[,i])
    summary.table[table.row,4] <- max(dat[,i])
    table.row <- table.row +1
  }
  
  row.names(summary.table) <- names(dat)[first.col:length(dat)]
  return(summary.table)
}

#Why do we have all of those NAs???
summary(dat)

# Oh right, there are NAs in the dataset. We will need to specify that we want to exclude those
# from the calculations. I'll leave that up to you to do using those skillz you learned yesterday.

#######################          Basic statistical analysis        ##############################
# Functions from Zuur

#First load some functions that Alain Zuur provides at his website: http://www.highstat.com/
source('/Users/mjhenderson/Google Drive/DataDepot/libraries/HighstatLibV4.R')
install.packages('lattice')
library(lattice)

#open the fish_data.csv 

dotchart(fish_data$Length)

MyVar<-c('Length', 'Width', 'Depth', 'Velocity', 'Cobble', 'Gravel')
Mypairs(stream.habitat[, MyVar])

# if you couldn't load the functions from the Zuur website a simple alternative that will
# give you the pair plots but not the correlation coefficients is just
plot(stream.habitat[, MyVar])

## transform variable to look at fish density
fish$density.m2 <- with(fish, No.caught/Sample.area.m2)

#model density as a function of depth and velocity
lm(density.m2 ~ Depth.m + Velocity.ms, data=fish)

#create an object to save the model output
mdl.results <- lm(density.m2 ~ Depth.m + Velocity.ms, data=fish)

#summarize the output to look at the results
summary(mdl.results)

#look at what other type of output we get from the model
names(mdl.results)

#format of the contents
str(mdl.results)

#extract the model coefficients
mdl.results$coefficients

#there is also some shorthand
coef(mdl.results)

#look at confidence intervals
confint(mdl.results, level=0.95)

#standard errors #### No need to confuse people ###
sqrt(diag(vcov(mdl.results)))

#residuals
mdl.results$residuals

#predicted values of observations
mdl.results$fitted.values

#look at some diagnostic plots
#plot residual vs. predicted values
plot(mdl.results$resid~mdl.results$fitted)

#plot residuals vs. velocity
plot(mod.out$resid~fish$Velocity.ms)

#plot residuals vs depth
plot(mod.out$resid~fish$Depth.m)

##hmmm...there appears to be a trend - we should probaly include a quadratic
fish$Depth.m.sq <- fish$Depth.m^2 
#and use the new variable in the regression model 
mdl.results <- lm(density.no.m2~ Depth.m + Depth.m.sq + Velocity.ms, data = fish)

#or we can use the I()
summary(mdl.results <- lm(density.no.m2~ Depth.m+ I(Depth.m^2) + Velocity.ms, data = fish))

#the I() function tells R that an operation needs to be performed inside the parenthesis
#before the model is fit

plot(mdl.results$resid~mdl.results$fitted) 
plot(mdl.results$resid~fish$Depth.m)
# normal probability plot of residuals, should resemble a straight line if model fit is OK 
qqnorm(mdl.results$resid)

plot(mdl.results)

#interactions
# the asterisk indicates main effects and interactions between 2 or more variables 
summary(mdl.results <- lm(density.no.m2~ Depth.m*Velocity.ms, data = fish)) 

# a colon means include the interaction between 2 or more variables 
summary(mdl.results <- lm(density.no.m2~ Velocity.ms + Depth.m:Velocity.ms, data = fish))

# create binary indicator variable 
fish$Fall = ifelse(fish$Season == "fall",1,0)

#see if this parameter helps
summary(mdl.results <- lm(density.no.m2~ Depth.m + I(Depth.m^2) + Velocity.ms + Fall, data = fish))

## fit the same model using GLM
summary(new.out <- glm(density.no.m2~ Depth.m + I(Depth.m^2) + Velocity.ms + Fall,data = fish))

#for grins lets fit another model without fall in it 
new2.out <- glm(density.no.m2~ Depth.m + I(Depth.m^2) + Velocity.ms,data = fish)

#compare AIC between the two models
AIC(new.out, new2.out)

###############################   GGplot     ######################################

## ggplot can be a little difficult to learn, but once you get it down it will make your life
##  a lot easier. Especially if you are making more complex figures.

# some of the advantages:
#   1) follows a consistent 'grammar of graphics' that was outlined in a book (Wilkinson, 2005)
#   2) it is very flexible
#   3) it is very easy to modify and polish plots
#   4) It is widely used, so there is a lot of help out there to do what you need to do

# The basics of the grammar of graphics:
#   - Traditionally, people viewed different types of plots independently
#   - This failed to acknowledge the common elements/similarities between different plots
#   - Wilkinson's book (Grammar of Graphics) describes the building blocks of graphics
#      that when combined can generate all the different plots you need. It's a more
#      cohesive way of thinking about plots.
#   - In case you missed it, the 'gg' in 'ggplot' stands for Grammar of graphics.

# So in ggplot, you build up your plot in layers. You first start by specifying all the
# things that are common in whatever plot you would want to build. You do this in the 
# ggplot statement
library(ggplot2)

#the first element specifies the common elements in the environment:
#  (dataframe, x and y axes, and the color) 
firstPlot <- ggplot(diamonds, aes(x=carat, y=price, color=cut)) + geom_point() 

#what if I want to change the shape of the points
secPlot <- ggplot(diamonds, aes(x=carat, y=price, color=cut, shape=color)) + geom_point() 

#add a smooth line to the fit of the data - the smooth part of the geom inherits the aesthetics specified in the 
#ggplot statement
secPlot + geom_smooth()

#what if I want an overall smooth instead of multiple smooth lines
ggplot(diamonds, aes(x=carat, y=price)) + geom_point(aes(color=cut)) + geom_smooth()

#add labels
labPlot <- ggplot(diamonds, aes(x=carat, y=price, color=cut)) + geom_point() + 
  labs(title="Scatterplot", x="Carat", y="Price")

#change theme
newPlot <- labPlot + theme_bw()

#facets
newPlot + facet_wrap(~cut, ncol=3)

### Nice those were some cool plots!  Now lets try it with a new dataset
#read in the dat.csv file
LWdat <- read.csv('dat.csv')

#look at the data
head(LWdat)

# Make a first plot of the data
LWplot <- ggplot(LWdat, aes(x=length, y=weight)) + geom_point()
LWplot

# There appears to be a couple of different curves. Let's see if we can figure out why
# Perhaps its because of fish stage
LWplot.stage <- LWplot + geom_point(aes(col=stage))
LWplot.stage

# Well, that didn't work. It's not surprising since, in this case, stage is determined
# by fish size. 

# Let's try year
LWplot.year <- LWplot + geom_point(aes(col=factor(year)))
LWplot.year

# Aha!! There does appear to be different length weight relationships depending on year!

#Let's fit a smoothed line to each year
LWplot.year.lin <- LWplot.year + geom_smooth()
LWplot.year.lin

#hmmm... that only fit a single smooth line. How can we change that?
LWplot.year.lin <- ggplot(LWdat, aes(x=length, y=weight, color=factor(year))) + geom_point() + geom_smooth()
LWplot.year.lin

# Nice!! Now what if we wanted those different year in different panels
LWplot.facet <- LWplot.year.lin + facet_grid(~year)
LWplot.facet

# Looks pretty good, but what if we wanted to change the axis labels.
LWplot.facet.scale <- LWplot.facet + scale_x_continuous(breaks=c(250, 500, 750))

# And I personally don't like the grey background grid, so I normally change the theme
LWplot.facet.theme <- LWplot.facet.scale + theme_bw() 
LWplot.facet.theme

# Obviously, nobody can remember all these different functions and the syntax
# for each of the statements. I often find myself googling how to do something,
# and there is almost always someone who has struggled with the same issue and posted
# a solution. I also often refer to a handy ggplot cheatsheet, which you can find here:
# https://www.rstudio.com/wp-content/uploads/2015/03/ggplot2-cheatsheet.pdf

# Woohoo!! Another great day playing with R! Hopefully this short workshop has 
# stimulated your interest enough to keep on playing with R and learing more about
# it's capabilities.
