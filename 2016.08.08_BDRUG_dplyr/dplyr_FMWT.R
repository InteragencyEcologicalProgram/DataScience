#Data manipulation with dplyr and reshape
# Presentation for the Bay-Delta R users Group by Rosemary Hartman
# August 8, 2016

# First load the required packages
library(dplyr)
library(reshape2)

#Import the data. This is the Fall Midwater Trawl flatfile available:
# ftp://ftp.dfg.ca.gov/TownetFallMidwaterTrawl/FMWT%20Data/
FMWT <- read.csv("~/Desktop/brdug/FMWT.csv")

# If we want to look at the whole file in a new window:
View(FMWT)

# Check to see if we have all the data types imported correctly:
str(FMWT)
# you can also use "glimpse" from dyplr do to the same thing:
glimpse(FMWT)

#Another function to look at just the first few lines:
head(FMWT)

# The dates didn't come in correnctly, let's fix that:
FMWT$Date = as.Date(FMWT$Date, "%m/%d/%y")

# The data is currently a matrix with one row for each tow and a column
# for each species. However, most R analyses (including graphing, ANOVAs, regressions)
# will need one observatio per row. We can use the "melt" function in the reshape package

FMWT2 = melt(FMWT, id.vars = 1:18, variable.name = "species", value.name = "catch")
glimpse(FMWT2)

# Now each species has its own line, but the whole data set is currently in order 
# of species. What if we want to reorganize it in order of trawl sequence?

FMWT2 = FMWT2[order(FMWT2$Date, FMWT2$Station),]
glimpse(FMWT2)

#Nice! But really, we only care about Delta Smelt. Let's subset just the Delta
# smelt catch:

smelt = filter(FMWT2, species == "Delta.Smelt")
View(smelt)

# But that gives us a line for every single trawl, including the ones with
# no catch. Let's get rid of the zeros.

smelt.nozero = filter(smelt, catch >0)
head(smelt.nozero)

# This is equivelent to subset(smelt, catch>0), in base R. "filter", from dplyr
# lets you more easily set multiple conditions. For example:

filter(smelt, Year == 2000 & Survey >= 4 & Station == 706)

# Which 10 trawls had the highest catch?

top_n(smelt, 10)

# Great! But I don't really care about the individual trawls.
# How can I summarize the data for each year? Or automatically compute 
# the annual index!
# To do this, we will need to group the data by year, and calculate a mean

smelt.yr = summarize(group_by(smelt.nozero, Year), catch.total = sum(catch))
plot(smelt.yr$Year, smelt.yr$catch)

# The "summarize" function from dplyr is one of my favorites. You can do almost unlimited
#summary statistics.

smelt.yr = summarize(group_by(smelt, Year), catch.total = sum(catch), meancatch = mean(catch), sdcatch = sd(catch), n = length(catch))
head(smelt.yr)

# OK, so I really want to compute the annual index like Randy does instead
# of just getting the total catch for each year. The instructions are here:
# ftp://ftp.dfg.ca.gov/TownetFallMidwaterTrawl/FMWT%20Data/CPUE%20and%20Index%20Calculation%20Instructions.doc

# First we need to import the info on which station is in which area
# and what the weights are.
areas <- read.csv("~/Desktop/brdug/areas.csv")

# Now we want to attach the column with the area and the weight to the dataframe of trawls
# You can use the "left_join" function from dplyr. You can also use the base function "merge"
# for this particular join, but dplyr has options for more complicated joins.

smelt = left_join(smelt, areas, by = "Station")

# The index is only calculated with September, October, November, and December.
# So we want to subset the smelt data frame for those months.
# First pull out the months.
smelt$month = months(smelt$Date, abbreviate = T)
smelt.I = filter(smelt, month=="Sep"| month=="Oct" | month=="Nov" | month=="Dec")
# the | is the "or" indicator. More logical commands:
?base::Logic

# Calculate the mean monthly catch per trawl for each area.
smelt.I2 = summarise(group_by(smelt.I, Year, month, Area, weight), catch.ave = mean(catch))

# you can also write this
smelt.I2 = smelt.I %>% group_by(Year, month, Area, weight) %>% summarise (catch.ave = mean(catch))

# Now multiply by the weight. The "mutate" function will add a new variable.

smelt.I2 = mutate(smelt.I2, weighted.catch = weight*catch.ave)

# calculate the monthly index
index.month = smelt.I2 %>% group_by(Year, month) %>% summarize(month.I = sum(weighted.catch))

# and finally, calculate the yearly index by summing the 

indeces = index.month %>% group_by(Year) %>% summarize(Index = sum(month.I))

# There ae some issues with the index from 1969, 1974 and 1979, so
# ignore those for now, but the others should match the ones posted here:
# http://www.dfg.ca.gov/delta/data/fmwt/Indices/sld002.asp

# Let's take a quick look

plot(indeces$Year, indeces$Index, type = "h")

# Looks nice!

# Now, we said we usually want one observation per row, but what if we want to 
# switch this around and have one column for each of the monthly indecies, and one
# row for each year? We use the "dcast" function from the reshape2 package.
# This is the opposite of the "melt" function.

index.month2 = dcast(index.month, Year ~ month)

# We can also use "cast" as an alternate way to calculate the yearly indecies

index.yr = dcast(index.month, Year ~ ., sum)
