
#ORIENTATION:
# 1. console window
# 2. code window
# 3. environment window
# 4. plot/help/packages window

#This is a comment.  R ignores anything after a #

#R is a calculator!
3+2

#The assignment operator
x <- 3
x

#Functions
sum(1, 2, 3)
c(1,2,3)
mean(c(1,2,3))
x<-mean(c(1,2,3))

rm(x)  #clean up our environment

#### IMPORT DATA ####
#Our dataset = bigfoot reports and some habitat variables

bigfoot <- read.csv("C:/Users/vtobias/Desktop/R Graphing/bigfoot_habitat.csv", header=TRUE,
                    stringsAsFactors = FALSE)

####  SAVE CODE ####
#point out save button

##### INSPECT DATASET ####

#what are the variables called?
names(bigfoot)     

#gives summary stats for each variable in the dataset
summary(bigfoot)   

#gives the "structure" of a dataset.  Good for finding out what kind of varibles you have
str(bigfoot)       
#notice some characters and some integers

#look at one variable
bigfoot$county     #the $ is how you tell R to look for "county" inside of "bigfoot".  Important if there is more than one dataset
head(bigfoot$county)  #just look at the first few rows

#look at all the variables in a spreadsheet-like device
View(bigfoot)


#### PLAY WITH THE DATA ####

#How many bigfoot reports are there?
sum(bigfoot$reports)

#What is the average number of bigfoot reports by county?
#remember that these are county-level reports
mean(bigfoot$reports)

#How many reports per capita?
  #we can make a new object to store the answer
rpts.cap <- bigfoot$reports/bigfoot$pop2010
  #or we can make a variable within our dataset
bigfoot$rpts.cap <- bigfoot$reports/bigfoot$pop2010
  #we don't want to get confused so lets delete that vector
rm(rpts.cap)      #note that this is the vector by itself, not the variable in the bigfoot dataset
  #Let's look at the dataset to see that our new variable is there!
View(bigfoot)

#What is the average number of reports per capita?
  #do math inside of a function!
mean(bigfoot$reports/bigfoot$pop2010)
mean(bigfoot$rpts.cap)


#### BOXPLOTS ####

#basic boxplot
boxplot(bigfoot$reports)

#boxplots by state
boxplot(bigfoot$reports ~ bigfoot$state)  #y ~ group

#TRY THIS: make a boxplot of evergreen forest area by state


#### SCATTER PLOTS ####
#splom(bigfoot[,c(3:6, 12:15)])


plot(bigfoot$e.forest, bigfoot$reports)
plot(bigfoot$e.forest, bigfoot$reports,
     xlab="Evergreen Forest Area", ylab="Reports")
plot(bigfoot$e.forest, bigfoot$reports,
     xlab="Evergreen Forest Area", ylab="Reports",
     bty="l")

#Complicated version with different colors and a legend
#SUBSETTING DATA
plot(bigfoot$e.forest[bigfoot$state=="Washington"], bigfoot$reports[bigfoot$state=="Washington"],
     xlab="Evergreen Forest Area", ylab="Reports",
     pch=16, col="blue")
points(bigfoot$e.forest[bigfoot$state=="California"], bigfoot$reports[bigfoot$state=="California"],
       pch=15, col="red")
#TRY THIS: how would you add oregon with green triangles?
points(bigfoot$e.forest[bigfoot$state=="Oregon"], bigfoot$reports[bigfoot$state=="Oregon"],
       pch=17, col="green")
legend("topright", c("Washington", "California", "Oregon"), 
       pch=c(16, 15, 17), col=c("blue", "red", "green"))

#### BARPLOTS ####
tapply(bigfoot$reports, bigfoot$state, FUN=sum)
barplot(tapply(bigfoot$reports, bigfoot$state, FUN=sum))
barplot(tapply(bigfoot$reports, bigfoot$state, FUN=sum), col=c("red", "green", "blue"))


### LINE PLOTS ####


#sort by county name
bigfoot <- bigfoot[order(bigfoot$county),]
plot(bigfoot$reports, type="l")

plot(bigfoot$reports, type="l", xaxt="n",
     xlab="County", ylab="Reports")
axis(side=1, at=1:length(bigfoot$county), labels=bigfoot$county)

plot(bigfoot$reports, type="l", xaxt="n",
     xlab="County", ylab="Reports")
axis(side=1, at=1:length(bigfoot$county), labels=bigfoot$county, las=2)

plot(bigfoot$reports, type="l", xaxt="n",
     xlab="County", ylab="Reports")
axis(side=1, at=1:length(bigfoot$county), labels=bigfoot$county, las=2,
     cex.axis=0.5)


#SHOW POWERPOINT SLIDE WITH SUGGESTIONS

#suggest possible graphs to make to answer these questions

#IS THE NUMBER OF REPORTS JUST A FUNCTION OF COUNTY SIZE?
  # Try a scatter plot of county size (all.pixels) and number of reports (reports)

#WHY IS THE TOTAL NUMBER OF REPORTS SO HIGH IN WASHINGTON?
  #COMPARE THE AMOUNT OF BIGFOOT HABITAT BY STATE. (WHAT QUALIFIES AS HABITAT IS UP TO YOU!)
  #  Try a boxplot of habitat variables or a barplot.

#HOW DOES HUMAN POPULATION GROWTH IN A COUNTY RELATE TO BIGFOOT REPORTS?
  #Use the population variables
  # - example: pop2015-pop2014 = how much the population grew in 2014
  # Try some scatterplots of population growth and the number of reports.

#DOES THE NUMBER OF REPORTS PER CAPITA RELATE TO AGRICULTURE? WHAT ABOUT FOREST AREA?



library(knitr)
stitch("C:/Users/vtobias/Desktop/R Graphing/bigfoot_code.R")
