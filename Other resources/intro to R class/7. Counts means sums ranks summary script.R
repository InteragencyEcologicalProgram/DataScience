## set working directory
setwd("G:/")

# read in commas separated files
catch<-read.csv("Fish.catch.csv")
habitat<-read.csv("stream.habitat.csv")
water<-read.csv("Water.measures.csv")

#whats in these data frames
head(catch)
head(habitat)
head(water)


## what are the variables in the water data frame
names(water)

mean(water$Water_Temp)
median(water$Water_Temp)
sd(water$Water_Temp)
var(water$Water_Temp)
min(water$Water_Temp)
max(water$Water_Temp)
sum(water$Water_Temp)

## how many elements are in this object?
length(water$Water_Temp)

## complete summary of data in water
summary(water)

## what are median 50% and the lower and upper 95%
# quantiles of water temperatures
quantile(water$Water_Temp,probs=c(0.025,0.5,0.975))

# note that you can specify other quantiles by putting different
# he we specify the 20, 40, 60, and 80th percentiles
quantile(water$Water_Temp,probs=c(0.2,0.4,0.6,0.8))


## combine mean, standard deviation(sd), min and max of water temperature
water.temp<- c(mean(water$Water_Temp),sd(water$Water_Temp),min(water$Water_Temp),max(water$Water_Temp))

## combine mean, sd, min and max of conductivity
conduct <-c(mean(water$Conductivity),sd(water$Conductivity),min(water$Conductivity),max(water$Conductivity))

## combine mean, sd, min and max of dissolved oxygen
DO<-c(mean(water$DO),sd(water$DO),min(water$DO),max(water$DO))

## Create a table with the combined summary data using rbind function
sum.data <- rbind(water.temp,rbind(conduct,DO))

#print it out
sum.data

# what type of object is it?
class(sum.data)

## calculate mean Turbidity in column 6
mean(water[,6])


## save the names of the columns in a file, water.name
water.name = names(water)

## create place to put the summary data
sum.table = c()

## for loop for calculating and combining summary data by column
for(i in 3:6){
  ## calculate summary statistics for each column from 3 to 6
  ## use rbind to stack the values into a single matrix
  sum.table<- rbind(sum.table,c(mean(water[,i]),sd(water[,i]),min(water[,i]),max(water[,i])))
}

## combine variable names with corresponding summary statistics
sum.table <-cbind(as.data.frame(water.name[3:6]),sum.table)

## the columns need names, so let's do it
colnames(sum.table) = c("Characteristic","Mean","SD","Min","Max")


## create a function for calculating the mean
## first name it and identify arguments
my.mean <- function(variable){
  # users of the function provide "variable" and this is what is done with it
  sum(variable)/length(variable)
}

## use the new function
my.mean(water$Water_Temp)

## compare to built-in R mean function
mean(water$Water_Temp)


## create a function for dividing 2 numbers and squaring the result
my.add.square <- function(a,b){
  (a/b)^2
}
# use the function
my.add.square(5,2)

# use the function but reverse the numbers
my.add.square(2,5)

## Lets create a function that creates the summary table so we can use it later
## inputs are name of data frame (dat.frm), and column number of first variable to
## summarize note we will assume that we will summarize all variables from that
## column number to the end of the data frame.
mk.sum.table <- function(dat.frm,first){
  # save names in columns to local file
  namz = names(dat.frm)
  #create place to put summary data
  tablez = c()
  ## calculate summary statistics for each column from first to last
  ## last is calculated using length() function applied to column names
  for(i in first:length(namz)){
    ## use rbind to stack the values into a single matrix
    tablez<- rbind(tablez,c(mean(dat.frm[,i]),sd(dat.frm[,i]),min(dat.frm[,i]),max(dat.frm[,i])))
  }
  
  ## combine summary data with column names in namz
  ## note that your combining characters and numbers so we
  # must convert the names to a data frame before the cbind
  tablez <-cbind(as.data.frame(namz[first:length(namz)]),tablez)
  
  ## the columns need names
  colnames(tablez) = c("Characteristic","Mean","SD","Min","Max")
  
  ## this returns the data frame that was created otherwise nothing is output
  return(tablez)
}

## now let's invoke the function
mk.sum.table(water,3)

## let's try to summarize the habitat file
## first, see what in it
head(habitat)

## try the new function with habitat
## first column to include is 4- Length
mk.sum.table(habitat,4)


mean(habitat[,4])


## here we can tell the function to remove the missing data
mean(habitat[,4], na.rm = TRUE)


## Modify the above function by adding na.rm to each function
mk.sum.table <- function(dat.frm,first){
  namz = names(dat.frm)
  tablez = c()
  for(i in first:length(namz)){
    ## calculate sumary statistics for each column
    ## use rbind to stack the values into a single matrix
    tablez<- rbind(tablez,c(mean(dat.frm[,i],na.rm = T),sd(dat.frm[,i],na.rm = T),min(dat.frm[,i],na.rm = T),max(dat.frm[,i],na.rm = T)))
  }
  
  ## combine summary data with column names in namz
  ## note that your combining characters and numbers so we
  # must convert the names to a data frame before the cbind
  tablez <-cbind(as.data.frame(namz[first:length(namz)]),tablez)
  
  ## the columns need names
  colnames(tablez) = c("Characteristic","Mean","SD","Min","Max")
  
  ## this returns the data frame that was created otherwise nothing is output
  return(tablez)
}

## try the new function with habitat
# first column to include is #4 Length
mk.sum.table(habitat,4)


summary(habitat)

#identify the missing length data
is.na(habitat$Length)

#calculate the mean length for use below
mean(habitat$Length,na.rm = T)

#Let's put these things together and replace missing data, is.na = TRUE, with the mean calculated above, otherwise (else) if not missing keep the non-missing value

#replace the missing data with the mean length
ifelse(is.na(habitat$Length),11.479,habitat$Length)

#We could get really fancy and put the mean function inside of the ifelse function.

## replace missing length data but put function inside ifelse function
ifelse(is.na(habitat$Length),mean(habitat$Length,na.rm = T),habitat$Length)

## first examine contents of habitat
head(habitat)

## use tapply to summarize by groups
by.hab.mean <- tapply(habitat$Length,habitat$Habitat, mean, na.rm = T)
#print it out
by.hab.mean

# what kind of object is it
class(by.hab.mean)

str(by.hab.mean)

by.hab.mean[1]

## coerce into a data frame
as.data.frame(by.hab.mean)

### a new function for summarizing data by groups
## values inside [c()] correspond to column numbers
aggregate(habitat[c(4,5)], by = habitat[c(3)],mean,na.rm = T)

## we can do by more than 1 group for example stream and habitat
aggregate(habitat[c(4,5)], by = habitat[c(1,3)],mean,na.rm = T)

## lets create an object with all of the means
hab.means <-aggregate(habitat[c(4:9)], by = habitat[c(1,3)],mean,na.rm = T)

## what kind of object did we create
class(hab.means)

head(catch)

## new function for summarizing data
spc.collect <-table(catch$Species)
spc.collect

## that type of object is this
class(spc.collect)
str(spc.collect)

spc.collect<- as.data.frame(spc.collect)
spc.collect
colnames(spc.collect) = c("Species","Total.catch")
spc.collect

## create an object that
tot.catch<-as.data.frame(table(catch$Stream,catch$Habitat,catch$Species))
## print it out
tot.catch

## lets create a similar object using aggregate and counting the number of
## elements using length
tot.catch.nozero<- aggregate(catch[c(5)], by = catch [c(1,3,4)],length)
#print it out
tot.catch.nozero


# create species using unique combinations of stream, date, habitat type, and species
species<-unique(catch[,1:4])
# print it out
species

# create a new object (column in species) and assign a 1 to species that were
# captured aka detected
species$detect = 1

## calculate richness but summing the total number of species detected in a sample
richness<- aggregate(species[c(5)], by = species[c(1:3)],sum)

# create new combined data frame
for.correl <- merge(richness,habitat, all = TRUE)
# print it out
for.correl

# replace NA with zero
for.correl$detect<- ifelse(is.na(for.correl$detect),0,for.correl$detect)
# print it out
for.correl

cor(for.correl$detect,for.correl$Length)

# summarize for.correl
summary(for.correl)

help(cor)


cor(for.correl$detect,for.correl$Length, use = "pairwise.complete.obs")

cor(for.correl[,4:10], use = "pairwise.complete.obs")





