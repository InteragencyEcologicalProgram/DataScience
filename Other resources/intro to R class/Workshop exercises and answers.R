
#####################################################
############################ Exercise 1:
# ####################################################
# Note don't forget to set your working directory your path will differ from mine below

setwd("C:/Users/peterjam/Desktop")

# Create an object named "this" and assign it a value of 4

this <- 4

# 
# Next, create a new object "that" by multiplying "this" by 8 and subtracting 7
# 

that <- this*8 - 7

## if you prefer to use parenthesis

that <- (this*8) - 7


# Divide this by that and assign the value to "easy"
# 

easy<- this/that

# Save the all of the contents of your working directory to: "tada.Rdata"
# 

save.image("tada.RData")

# Remove all of the objects in your working directory
# 

rm(list=ls())

# Load (read in)  "tada.Rdata"
# 
load("tada.RData")

# Print out easy

easy


###############################################
############## Exercise 2:
###############################################
#   Create a on object named "by.grp"  with the value 75 divided by 30
# 
by.grp <- 75/30

# Use the object to create an vector named "victor" containing 30 elements with values from 1 to 75 by equal increments.  (don't forget "seq" function)
# 
victor<- seq(1,75,by.grp)

# Create a 10 by 3 matrix called "trix" using "victor". Note the first 10 elements of "victor" should be the values in the first column of "trix"
# 
trix<- matrix(victor,ncol = 3,byrow = FALSE)
  
# Replace the value of the first row, second column of "trix" with missing value
# 
trix[1,2] <- NA

# Replace the value in the 5th row, 2nd column with the current value times 8.
# 
trix[5,2]<- trix[5,2]*8

# Create a  dataframe named "my.dater" using "trix" and name the columns "A", "B", "C"
# 
my.dater<- as.data.frame(trix)
colnames(my.dater) = c("A", "B", "C")

# Print out the dataframe
my.dater

#######################################################
###################### Exercise 3:
#######################################################
# Note don't forget to set your working directory your path will differ from mine below

setwd("C:/Users/peterjam/Desktop")

#   Read the following three files into R: weather.csv (comma delimited), people.prn (single space delimited), and biota.txt (tab delimited). 
# 
weath <-read.csv("weather.csv")
peop<- read.table("people.prn", sep = " ", header = TRUE)
biota<- read.table("biota.txt", sep = "\t", header = TRUE)

# Using the weather file, create a new variable titled "ppt.in" by calculating precipitation in inches using the variable "total.ppt.mm" (precipitation in mm). (1 inch = 25.4 mm)
# 

weath$ppt.in <- weath$total.ppt.mm/25.4

# Using people, create a new variable titled "wt.kg" using the weight of each person in stone in the dataframe, variable "weight.stone" (1 stone = 6.35 kg). 
# 
peop$wt.kg <- peop$weight.stone*6.35

# Using the biota dataframe, create a new variable in the dataframe (call it what you want) by dividing the mass (Mass.kg) of each species, but its corresponding height (height.m).
# 
biota$condition<- biota$Mass.kg/biota$Height.m

# Write each dataframe to a comma separated file
# 

write.csv(weath,"new weather.csv")
write.csv(peop,"new people.csv")
write.csv(biota,"new biota.csv")

# Write each file to a tab delimited file

write.table(weath,"new weather.txt", sep = "\t")
write.table(peop,"new people.txt",sep = "\t")
write.table(biota,"new biota.txt",sep = "\t")

####################################################################
##################### Exercise 4:
####################################################################   
# Create a data frame with 5 rows and 3 columns all containing the value 1.
# 
new<-as.data.frame(matrix(rep(1,15),ncol = 3))

# Name the columns "XX", "YY", "ZZ"
# 
colnames(new)<- c("XX","YY","ZZ")

# Add a column to the dataframe containing the values 1 to 5. 
# 
new<- cbind(new,c(1:5))

# Name the new column "site"
# 
colnames(new)[4] <- "site"

# Create a dataframe containing  5 rows and 2 columns. The first column should have values from 1 to 5 and the second column should have letters from a to e. 
# 
second<-as.data.frame(cbind(c(1:5),c("a","b","c","d","e")))

# Name the columns of this data frame: "site" and "letter"
# 
colnames(second) <- c("site","letter")

# Merge the two dataframes
# 
almost<- merge(new,second)

# Write the combined dataframe to a csv file.

write.csv(almost,"I did it.csv")

###################################################################
########################### Exercise 5:
################################################################   

# don't forget the working directory
setwd("C:/Users/peterjam/Desktop")

#   Read in "habitat.csv" and "critter catch.csv" 
#
hab <-read.csv("habitat.csv")
critter <-read.csv("critter catch.csv")

# Combine the two datasets into a single dataset. (Hint... think merge, also note that "Date" is the only common column in the two data frames)
# 
combo<-merge(hab,critter)

# Using a for loop and an if statement , create a new variable, "presence" in the combined data set that consists of 0 when the species is absent, 1 when the catch is greater than 0 but less than 10 and 2 when the catch is greater than or equal to  10.
# 
combo$presence = 0

for(i in 1:length(combo[,1])){
  if(combo$catch[i] > 0) combo$presence[i] = 1
  if(combo$catch[i] > 10) combo$presence[i] = 2
}

# Create another new variable "presence2" using the if-else function  and the same rules as  #2 above.
# 
combo$presence2 = 0
combo$presence2<-ifelse(combo$catch > 0,1,combo$presence2)
combo$presence2<-ifelse(combo$catch > 10,2,combo$presence2)

# Write resulting data frame to tab delimited file

write.table(combo,"combo.txt",sep = "\t")

########################################################
################################ Exercise 6:

# don't forget the working directory
setwd("C:/Users/peterjam/Desktop")

#   Read in "stream.habitat.csv" and "Water.measures.csv"
# 
hab <-read.csv("stream.habitat.csv")
water <-read.csv("Water.measures.csv")

# Combine the two data frames
# 
combo<-merge(hab,water)

# Calculate mean, sd, minimum, and maximum of Water_Temp, Conductivity, DO, Turbidity, Length, Width, Depth, Velocity, Cobble, and Gravel, grouped by habitat type (Habitat) 
# 
means<-aggregate(combo[c(4:13)], by = combo[c(3)], mean, na.rm = TRUE)
sds<-aggregate(combo[c(4:13)], by = combo[c(3)], sd, na.rm = TRUE)
mins<-aggregate(combo[c(4:13)], by = combo[c(3)], min, na.rm = TRUE)
maxs<-aggregate(combo[c(4:13)], by = combo[c(3)], max, na.rm = TRUE)


# Combine summary values in a single data frame.
# 
## first get names of habitats from output file
hab.names<- means[,1]

## lets transpose the summary data so each column is a habitat type
## t() means transpose, round() mean round to number digits

means<-round(t(means[,2:10]),1)
colnames(means) = paste("Mean_",hab.names, sep = "")

sds<-round(t(sds[,2:10]),2)
colnames(sds) = paste("SD_",hab.names, sep = "")

mins<-round(t(mins[,2:10]),1)
colnames(mins) = paste("Min_",hab.names, sep = "")

maxs<-round(t(maxs[,2:10]),1)
colnames(maxs) = paste("Max_",hab.names, sep = "")

sum.table <- as.data.frame(cbind(means,cbind(sds,cbind(mins,maxs))))


### get really fancy using paste

sum.table$Pool = paste(sum.table$Mean_Pool, paste(" (", paste(sum.table$SD_Pool,paste(") ",paste(sum.table$Min_Pool,sum.table$Max_Pool, sep = " - "),sep = ""),sep = ""),sep =""),sep="")
sum.table$Riffle = paste(sum.table$Mean_Riffle, paste(" (", paste(sum.table$SD_Riffle,paste(") ",paste(sum.table$Min_Riffle,sum.table$Max_Riffle, sep = " - "),sep = ""),sep = ""),sep =""),sep="")
sum.table$Run = paste(sum.table$Mean_Run, paste(" (", paste(sum.table$SD_Run,paste(") ",paste(sum.table$Min_Run,sum.table$Max_Run, sep = " - "),sep = ""),sep = ""),sep =""),sep="")


# Write data frame to csv file, just the last 3 columns

write.csv(sum.table[,13:15],"summary table.csv")

###############################################################
######################### Exercise 7:
###############################################################
# don't forget the working directory
setwd("C:/Users/peterjam/Desktop")

#   Read in "habitat.csv" and "critter catch.csv" 
# 
hab <-read.csv("habitat.csv")
critter <-read.csv("critter catch.csv")

# 
# Combine the two datasets into a single dataset. (Hint... think merge, also note that "Date" is the only common column in the two data frames)
# 
combo<-merge(hab,critter)

# Fit a linear regression model relating catch to temperature and cloud.cover  
# 

summary(out.put<-lm(catch ~ temperature + cloud.cover, data = combo))

## don't forget to see what is in out.put first
str(out.put)

# Examine residuals, plot residuals vs predicted values
#
plot(fitted(out.put)~resid(out.put), xlab = "Residuals", ylab = "Predicted")

# plot residuals vs temperature
# 
plot(combo$temperature~resid(out.put))

# Create a table with the parameter estimates, standard errors, and confidence limits
Estimate<- coef(out.put) 
Std.Error<- sqrt(diag(vcov(out.put)))

conf.lim<-confint(out.put, level = 0.95)

parmater.table<- cbind(Estimate,cbind(Std.Error,conf.lim))

