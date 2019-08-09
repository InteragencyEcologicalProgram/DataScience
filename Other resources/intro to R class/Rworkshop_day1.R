## We are reading in the data
setwd('C:\\Users\\rkhartman\\Desktop\\Rworkshop')



X <- 2
Y <- 8
sqrt(X)

temp1 <- 20
temp2 <- 30
temp3 <- 
  
#myVect <- c(temp1, temp2, )

mySeq <- seq(10, 15)

myMat <- matrix(c(mySeq, myEven), ncol=2)

pet.data <- read.table('pets.txt', header = FALSE, sep = "\t")

habitat <- read.csv("C:/Users/rkhartman/Desktop/bdrug/intro to R class/Habitat data.csv", header=TRUE, stringsAsFactors=FALSE)
habitat <- habitat[-(30:35),-(13:23)]
#trial <- habitat[-(30:dim(habitat)[1]),-(13:dim(habitat)[2])]

rm(trial)

names(habitat)  <- c('site', 'waterTemp', 'airTemp', 'Ph', 'depthFt',
                     'waterTempRnd', 'DO', 'Cond', 'poolLengthFt', 
                     'poolWidthFt', 'maxH20', 'avgH20')

mean(habitat$waterTemp, na.rm=TRUE)
summary(habitat)

hab.subset <- subset(habitat,subset = waterTemp > 16)

habSubSort <- hab.subset[order(hab.subset$waterTemp),]
trial <- hab.subset[order(waterTemp),]

#read in habitat data
habitat <- read.csv("C:/Users/rkhartman/Desktop/bdrug/intro to R class/habitat.csv", stringsAsFactors=FALSE)

#read in critter data
critter <- read.csv("C:/Users/rkhartman/Desktop/bdrug/intro to R class/critter catch.csv", stringsAsFactors=FALSE)

#merge the datasets
mergeData <- merge(habitat, critter, by='Date')

Jul22 <- subset(mergeData, subset = Date == '7/22/2013')

myPi <- pi
myLetters <- letters[1:10]

myList <- list(myPi, myLetters)

write.csv()


#################     Working with strings   ###################

PI <- paste('The life of', pi)
PI <- paste('The life of', pi, collapse='')

IloveR = paste('I', 'love', 'R', sep='-')
paste(1:3, c('!', '?', '+'), sep='', collapse='')
paste(1:3, c('!', '?', '+'), sep='')

mixedCase <- 'All ChaRacters in Upper Case'
upperCase <- toupper(mixedCase)
lowerCase <- tolower(mixedCase)

#abbreviations
some_colors = colors()[1:4]
colors1 <- abbreviate(some_colors)
colors2 <- abbreviate(some_colors, minlength = 5)
colors3 <- abbreviate(some_colors, minlength = 3, method = 'both.sides')

#substrings
PI
substr(PI, 4,8)

#compare vectors
set3 <- c('some', 'random', 'few', 'words')
set4 <- c('some', 'many', 'none', 'few')

intersect(set3, set4)
setdiff(set3, set4)

#pattern matchings
tempText <- c('one word', 'a sentence', 'you and me', 'three two one')
pattern <- 'one'

grep(pattern, tempText)

replace <- '1'

gsub(pattern, replace, tempText)

############## Now lets play with Dates  ####################
dates <- read.csv("C:/Users/rkhartman/Desktop/bdrug/intro to R class/dates.csv", stringsAsFactors=FALSE)

class(dates[,1])

dates[,1] <- as.Date(dates[,1], format='%m/%d/%Y')
trial <- as.Date(dates[,5], format='%d-%b-%Y')

numDate <- 41407

####  lubridate!!!!!!   ####
library(lubridate)

ymd('20110604')
ymd(dates[,1])
dmy(dates[,2])

#determine julian day
yday(dates[,2])

## 
arrive <- ymd_hms('2011-06-04 12:00:00', tz='Pacific/Auckland')
leave <- ymd_hms('2011-08-10 14:00:00', tz='Pacific/Auckland')

second(arrive)
wday(arrive, label=TRUE)

interval(arrive, leave)
difftime(arrive, leave)


#################### Data Summaries  #######

strHab <- read.csv("C:/Users/rkhartman/Desktop/bdrug/intro to R class/stream.habitat.csv", stringsAsFactors=FALSE)
str(strHab)

strHab$fStream <- as.factor(strHab$Stream)

summary(strHab)
sd(strHab$Velocity)

names(strHab)

strHab[strHab$fStream=='Ball Crk','Length']
meanLengthBallCrk <- mean(strHab[strHab$fStream=='Ball Crk','Length'])

#calculate the mean stream length for each stream
trial <- tapply(strHab$Length, strHab$fStream, FUN=mean)
trial <- tapply(strHab$Length, strHab$fStream, FUN=length)

#look at sapply and lapply functions
#create a vector of variables I want to summarize
vars <- c('Length', 'Width', 'Depth', 'Velocity', 'Cobble', 'Gravel')

#determine which vars are in which columns
which(names(strHab) %in% vars)
match(names(strHab), vars)

meanVars <- sapply(strHab[,vars], FUN=mean, na.rm=T)

meanVars <- sapply(strHab[,which(names(strHab) %in% vars)], FUN=mean, na.rm=T)
meanVars <- lapply(strHab[,which(names(strHab) %in% vars)], FUN=mean, na.rm=T)

#### make some plots
plot(Width~Length, data=strHab)
plot(strHab$Length, strHab$Width, xlab='Stream Length', ylab='Stream Width')
plot(strHab$Length, strHab$Width, xlab='Stream Length', ylab='Stream Width',
     xlim=c(10,15))


linReg <- lm(Width~Length, data=strHab)
summary(linReg)

abline(linReg, col='red', lty=5)

#make a histogram of 
hist(strHab$Depth)

?boxplot
boxplot(Velocity~fStream, data=strHab, ylab = 'Stream Velocity')
