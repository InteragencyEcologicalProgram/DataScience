#Secondary Axis Practicum
#Emily Mazur, NOAA NMFS Intern

#NOTE: Condensed working code is located at line 128

#Using hourly provisional CDEC RPN water temperature and DO data,
#imported into excel and saved as a CSV file

#Import data into RStudio:
Data <- read.csv("~/R/HourlyStanDataCleanCSV.csv", header = TRUE)
#remember to include the quotation marks and ".csv"!!!

#looking at data in script, the first row was imported as blank (because the cells were merged), so going to remove that:
Data <- Data[-(1),]
#looking at data again, the first blank row has been removed

#going to look to see if headers are attached to data - start with basic plot
plot(Wtemp)
#returns "object is not found" so going to attach headers to the data (It is important to detach at the end!):
attach(Data)

#now trying my basic plot again:
plot(Wtemp) #gives me a bar graph, not what I expected (it binned occurrence of temperatures)
#going to add "DO" and "Wtemp" as values in my environment like in the original basic plot:
WaterTemp<-Data$Wtemp
DO<-Data$DO

#going to try plotting again:
plot(Wtemp, type = "l", col = "blue")
#returns bar chart, with blue color and warnings
#going to try plotting against Date_time

Time<-Data$Date_Time
plot(Time, WaterTemp)
#plotting the time, R sorted the data alphanumerically, going to try to set the date

#first, remove the "time value"
remove(Time)
#next, format date:
Data$Date_Time <- as.Date(Data$Date_Time, "%m/%d/%y")
#try plotting again:
plot(Data$Date_Time, WaterTemp, xaxt = "n", type = "l")
#returns weird line plot, also have to format the time

#Looking back at my data, it has the year as 2020 - Julian Day must be off; also removed the hour--
#Above line happened when as.date was set - not sure how it changed
#need to go back and fix data in Excel - there is a space between the date and hour - I think this is what is throwing off the program





#STARTING OVER WITH AVERAGED STAN DATA FROM PREVIOUS PRACTICUM:
#import Stan Data
StanData <- read.csv("~/R/StanDataClean21Csv.csv", header = TRUE)
#clean up data - since I only have the first week of DO averages, going to take out every row but the first week in June
StanData <- StanData[-(15:35),]
#now only have first week of June, will go back and fix the date now since there's no conflict with time/hours
StanData$Date <- as.Date(StanData$Date, "%m/%d/%y")

#now will try plotting!
plot(StanData$Date, StanData$RPNTmean, type = "l")
#comes out with a nice line plot, but the y axis has a narrow range
#going to make the max, min, mean, and DO as values, then set the range
RiponMax <- StanData$RPNTmax
RiponMin <- StanData$RPNTmin
RiponMean <- StanData$RPNTmean
DO <- StanData$RPNDOmean
g_range <- range(50, RiponMax, RiponMin, RiponMean)
#don't have to include the na.rm=TRUE like before because there are no NA values

#going to remake plot, trying to add own labels 
plot(StanData$Date, RiponMean, type = "l", col = "Purple", xlab = NULL, ylab = NULL, ylim=g_range, lwd = 2)
#got a purple line but didn't repress the axis labels
#going to try to change labels by adding them directly into plotting code
plot(StanData$Date, RiponMean, type = "l", col = "Purple", xlab = "Date", ylab = "Temperature (Degrees F)", ylim=g_range, lwd = 2)

#got my labels to what I wanted, now going to add lines for max and min (and 7DADM for O. mykiss)
lines(RiponMax, type ="l", col ="green", lwd = 2)
lines(RiponMin, type = "l", col = "blue", lwd = 2)
lines(StanData$X7DADM65, type = "l", col = "red", lwd = 2)
#well code went through with no error/warning, yet the lines are not showing up on my plot
#even changing the code back to "StanData$RPNTmax" will not show a line
#might be that the lines are too close together so going to try to change the lower limit

g_range <- range(50, RiponMax, RiponMin, RiponMean)
plot(StanData$Date, RiponMean, type = "l", col = "Purple", xlab = "Date", ylab = "Temperature (Degrees F)", ylim=g_range, lwd = 2)
lines(RiponMax, type ="l", col ="green", lwd = 2)
#even changing the range does not make a line appear

#Figured it out! have to include the "StanData$Date" so R knows the x-coordinates, will finish with other lines
lines(StanData$Date, RiponMax, type ="l", col ="green", lwd = 2)
lines(StanData$Date, RiponMin, type = "l", col = "blue", lwd = 2)
lines(StanData$Date, StanData$X7DADM65, type = "l", col = "red", lwd = 2)
#okay all lines are added now. Going to add a title then try to find out how to add a secondary axis
title(main = "Daily Water Temperatures and Dissolved Oxygen at Ripon for June 2015")

#from looking online seems a little difficult to add a secondary axis
#here is some sample code I found (the author placed his second axis on the left, but can also move to the right using 4)
par(new=T) #allows new time series to be plotted over old one
plot(StanData$Date, DO, axes=False, ylim=c(4,max(DO)), xlab="", ylab="", type="l",lty=2, main="",lwd=2)
axis(4, ylim=c(4,max(DO)))
mtext(4,text="Dissolved Oxygen (mg/L)")
#gave me a primitive secondary axis - the margin was not big enough to put the axis and label

#starting with new plot I was able to get the secondary axis, however labeling was messed up.
#Starting from beginning:
plot(StanData$Date, RiponMean, type = "l", col = "Purple", xlab = "Date", ylab = "Temperature (Degrees F)", ylim=g_range, lwd = 2)
lines(StanData$Date, RiponMax, type ="l", col ="green", lwd = 2)
lines(StanData$Date, RiponMin, type = "l", col = "blue", lwd = 2)
lines(StanData$Date, StanData$X7DADM65, type = "l", col = "red", lwd = 2)
title(main = "Daily Water Temperatures and Dissolved Oxygen at Ripon for June 2015")
par(new=T) #allows new time series to be plotted over old one
plot(StanData$Date, DO, axes=False, ylim=c(4,max(DO)), xlab="", ylab="", type="l",lty=2, main="",lwd=2)
axis(4, ylim=c(4,max(DO)))
mtext(4, line = 3, text="Dissolved Oxygen (mg/L)")
# gave me what I want but the secondary axis label is still overlapping the axis - to move it: added the "line = 3"

#now to finish off with a legend (I'm going to try to locate with with "locator(1)" which will allow me to use my cursor:
legend(locator(1), c("Max", "Mean", "Min", "7DADM for O. mykiss Juvenile Rearing", "Dissolved Oxygen"), cex=0.8, col=c("Green", "Purple", "Blue", "Red", "Black"), lty=1:2, lwd = 2)
#it allows me to click but I can click anywhere outside the plot area
#going to just put the legend on the bottom of the graph:
legend("bottom", c("Max", "Mean", "Min", "7DADM for O. mykiss Juvenile Rearing", "Dissolved Oxygen"), cex=0.8, col=c("Green", "Purple", "Blue", "Red", "Black"), lty=1:2, lwd = 2)
#this gives the legend at the bottom, but I see that the line type is alternating between 1 and 2
legend("bottom", c("Max", "Mean", "Min", "7DADM for O. mykiss Juvenile Rearing", "Dissolved Oxygen"), cex=0.8, col=c("Green", "Purple", "Blue", "Red", "Black"), lty=c(1,1,1,1,2), lwd = 2)


#Condensed Code from start:
StanData <- read.csv("~/R/StanDataClean21Csv.csv", header = TRUE) #imported data
StanData <- StanData[-(15:35),] #deleted empty rows
StanData$Date <- as.Date(StanData$Date, "%m/%d/%y") #set date format so it wouldn't graph alphanumerically
RiponMax <- StanData$RPNTmax #put my values in the Environment
RiponMin <- StanData$RPNTmin
RiponMean <- StanData$RPNTmean
DO <- StanData$RPNDOmean
g_range <- range(50, RiponMax, RiponMin, RiponMean) #set my range
par(mar=c(5, 5, 5, 6) + 0.1)
plot(StanData$Date, RiponMean, type = "l", col = "Purple", xlab = "Date", ylab = "Temperature (Degrees F)", ylim=g_range, lwd = 2)
lines(StanData$Date, RiponMax, type ="l", col ="green", lwd = 2)
lines(StanData$Date, RiponMin, type = "l", col = "blue", lwd = 2)
lines(StanData$Date, StanData$X7DADM65, type = "l", col = "red", lwd = 2)
title(main = "Daily Water Temperatures and Dissolved Oxygen at Ripon for June 2015")
par(new=T) #additional time series
plot(StanData$Date, DO, axes=FALSE, ylim=c(4,max(DO)), xlab="", ylab="", type="l",lty=2, main="",lwd=2)
axis(4, ylim=c(4,max(DO)))
mtext(4, line = 3, text="Dissolved Oxygen (mg/L)")
legend("bottom", c("Max", "Mean", "Min", "7DADM for O. mykiss Juvenile Rearing", "Dissolved Oxygen"), cex=0.8, col=c("Green", "Purple", "Blue", "Red", "Black"), lty=c(1,1,1,1,2), lwd = 2)

#running it over the margin aspect was messed up so didn't get to see the secondary axis title. Will go back up above and include margin set
#I run it multiple times with the same code and get different axis placement every time
#Seems that when running the code for the first time with no plot, the axis is messed up, but running it again once there is already a plot present makes it normal
#Moving the margin to before the original plot makes it right on the first try!