#Practicum on Data TIDYING & importing, using Stan data
#June R practicum
#Barb Byrne, NMFS

#NOTE -- Because I worked through this dataset using the script I put together for the
#Knights Landing practicum, there might be some residual KL references that I didn't
#update. 

#Original Standata is in file "StanData.xls"
#To tidy the data for use in R, I
#--deleted all but primary worksheet
#--replaced all header rows with "tidy" column headings
#--Deleted all metadata "comments 
#--saved as .csv
#--saved column headers in a cheatsheet (StanData_headers.txt) so I 
#       have easy reference when coding
#tidier Stan data is in shared file "StanDataCleanCSV.csv"

#Check out Jeff Leek's "The Elements of Data Analytic Style" for good info on data practices

#Import tidy Stan data, changing code as needed to reflect your filepath
read.csv("C:/Users/BAB/Documents/R/FisheRies/Stan data example/StanDataCleanCSV.csv", header=TRUE)
help(read.csv)
?read.csv
#check file by looking at top six rows using "head" command
#oops, I forgot to assign a name to the data 
Standata<-read.csv("C:/Users/BAB/Documents/R/FisheRies/Stan data example/StanDataCleanCSV.csv", header=TRUE)
#NOW I'll check file with "head" command
head(Standata)

#In RStudio, just go to the environment tab and click on "Import dataset" to import
#a dataset (will be assigned to an R object with the name of the imported file).  The code will magically appear in the R console windwo, so you can grab
#to include in an R script.  Also, the filepath tells you about your working directory"
getwd() #returns working directory
setwd("C:/Users/BAB/Documents/R/FisheRies") #use "setwd()" to set working directory

#Can use "~" to indicate filepath of working directory,the below should work
#once working directory is "C:/Users/BAB/Documents/R/FisheRies"
Standata=read.csv("~/Stan data example/StanDataCleanCSV.csv", header=TRUE) 
#Getting error saying cannot open connection; no such file or directory.  I'll check my files
dir("C:/Users/BAB/Documents/R/FisheRies/Stan data example") #file seems to be there
#Error says: "Error in file(file, "rt") : cannot open the connection
#In addition: Warning message:
#  In file(file, "rt") :
# cannot open file 'C:/Users/BAB/Documents/Stan data example/StanDataCleanCSV.csv': No such file or directory"
#HELP!!!!! Any trouble-shooting tips from the group?
#This happened to me for the KL dataset, too -- not sure what's up with my working directory or 
#"relative" path file approach... I'll just use the full filepath on Line 22


#Now I'll further check things out using the "str" (for "structure") command
str(Standata)
#looking good -- the 14 observations checks out against original file 
#     (15 rows including 1 header row)
#...and the data associated with each variable are the "right" sort of data, 
#    so nothing got mixed up
#Hmmm... Date column might need some more work


#also good to check the end of your data (that's where you sometimes see that "empty rows" might get 
#imported if there's some stray content in your original file)
tail(Standata)

#did my data import as a data.frame?  Let me check the class...
class(Standata)
#yup, I'm set

#If you're using RStudio, go to the "Environment Tab" in the top right panel and 
#you can see see the class, dimensions, etc of your dataset, and even view in a 
#data window

#let's plot OBB7DADM by Date
plot(OBB7DADM~Date)

#Need to use the right syntax
plot(Standata$OBB7DADM~Standata$Date)
#sigh. This is why dates can be problematic.  Because "Date" is a factor, it plots data in
#"alphanumeric" order, so it plots data in weird 6/1, 6/11, 6/12, 6/13, 6/14, 6/2, 6/3 etc. order.
#Also, it doesn't plot as points for some reason, but as horiz. bars
#I'm gonna bite the bullet and transform into some sort of Julian day


#okay, time to import adjusted dataset & check it out
head(StandataJ)
tail(StandataJ)
str(StandataJ)

#let's plot OBB7DADM by Date again -- don't forget to refer to correct data object
plot(StandataJ$OBB7DADM~StandataJ$Date)
#...and don't forget to refer to adjusted julian day column
plot(StandataJ$OBB7DADM~StandataJ$Day)
#better, but what happened to first few days of data??? 42156=6/1/2015
#let's look at the column info
StandataJ$OBB7DADM
#oh, right -- we don't have the 7DADM for the first 6 days of June because it takes 7
#days to accumulate! So, all is well.

#I'm going to do something potentially dangerous and "attach" my dataset so that I can drop the 
#"StandataJ$" element of my variable names. 
attach(StandataJ, pos=2)
ls(pos=2)

#StandataJ now shows up in my "Environment Tab" in RStudio, and I can check out my variable names, 
#classes, etc. there.
# could use "par(mfrow=c(2,2))" if want to set up 2x2 plot array
#and, now I can explore my data faster
plot(OBB7DADM~JDay)
#Same plot, but notice that axis titles changed from, e.g., StanDataJ$OBB7DADM to OBB7DADM
#great, now I want to add temps at RPN to the plot
plot(RPN7DADM~JDay) 
#that just made a new plot for RPN temp
#Will remake OBB plot, then add Ripon temps using the "points" command
plot(OBB7DADM~JDay)
points(RPN7DADM,pch=2) 
#hmmm, not seeing the RPN data.  Let's check it
RPN7DADM
#maybe it's off the scale, but I thought the "points" command would automatically adjust the 
#axis scales.  Let's check...
help(points)
#not sure, in examples, I notice that the Plot command has an "axes" argument, maybe that is
#the problem
help(plot) #which refers me to "par"
help(par)
#I re-read the Points help and see that the points should refer to the x & y coords, so isn't 
#the same syntax as the plot arguments.  Try again

plot(OBB7DADM~JDay)
points(JDay, RPN7DADM,pch=2) #pch sets plotting character
#Nope that's not it -- syntax IS same (can use either the "x,y" or "y~x" syntax)
#Nope, still nothing.  Going to force my axes in the OBB plot and then try again
#Found help by googling "setting axis in R"
plot(OBB7DADM~JDay)
axis(2, at = seq(55, 90, by = 5), las=2) 
#axis 2 = y axis; "las" is an argument for axis label style with 2 being perpendicular to axis
#that added a new label at 70 but didn't extend axis.  Think need to suppress axis entirely in
#original plot command, then add in specified axis.
plot(OBB7DADM~JDay, yaxt=n)
#error; can't find 'n'
plot(OBB7DADM~JDay, yaxt="n")
#ta-da!
axis(2, at = seq(55, 90, by = 5), las=2) 
#Well, get the 70 label, but overall y axis not extended 55-90. :-(  What I found was how to
#set the axis LABELS, not the axis DIMENSIONS

#will try a different way
plot(OBB7DADM~JDay, ylim=c(55,90))
#AT LAST!!!!!
points(JDay, RPN7DADM,pch=2) #note that this x & y coordinate syntax is equivalent to the "y~x" syntax
#AT LAST!!!! BEAUTIFUL!
#now more...
points(OwlC7DADM~JDay, pch=3)

abline(65,0) #sets ref line; first two arguments are y-intercept and slope
#will redraw line in color.  
#Check out https://www.nceas.ucsb.edu/~frazier/RSpatialGuides/colorPaletteCheatsheet.pdf
#will refresh plot so don't have black line underlying new red line
plot(OBB7DADM~JDay, ylim=c(55,90), xlab="Julian Day 2015", ylab="Water Temperature (7DADM, degrees F)")
points(RPN7DADM~JDay,pch=2)
lines(RPN7DADM~JDay,lty=1)
lines(RPNTmax~JDay, lty=2)
lines(RPNTmin~JDay, lty=2)
abline(65,0, col="red")
lines(OwlC7DADM~JDay, pch=3, col="blue")
#love it!
legend(42156,80) #legend FAIL

#found a legend example which suggests an alternate way to build my plot all within the plot command
plot(c(42156,42170),c(55,90),type="n", #sets x and y axes scales
     , #sets x and y axis labels
     points(OwlC7DADM~JDay), points(OBB7DADM~JDay, pch=2), points(RPN7DADM~JDay,pch=3)), #plot data
     legend(42158,75, #sets position of legend
            c("Upstream of Knights Ferry", "Orange Blossom Bridge", "Ripon"), #puts text in legent
            lty=c(1,1,1), #sets line type for legend
            ))

#OKAY...the above totally didn't work. Leaving in this code in case I feel like toying with
#it in the future

#Emily -- the below is old code from some work using Knights Landing data -- need to update the 
#data references but might be some useful bits in there, e.g. shows how to subset
#data using logical operators.


lines(c(0,2,4)~c(0,2,4)) #thought that would plot a 1:1 line.  It plots a line, but not the one I want
help(lines) #help doc suggests "abline" command
help(abline) #useful
plot(adjWRcpue~WRcpue) #refresh plot
abline(0,1)#Lovely.  Realize now that am plotting cpues with EFFs of both 1 and 0.5
plot(adjWRcpue[EFF<1]~WRcpue[EFF<1]) #subsetting!  Use brackets. Logical operators often useful
abline(0,1)
points(adjWRcpue[EFF==1]~WRcpue[EFF==1], pch=3) #as I'd expect, when EFF=1, cpue and 
#adjusted cpue are the same

#Let's make some more plots to see how adjusted CPUE relates to various envtal factors
par(mfrow=c(3,1)) #sets up plotting window with 3 "rows" and 1 "column"
plot(adjWRcpue~WLK)
plot(adjWRcpue~WaterT)
plot(adjWRcpue~Turb)

#Let's find out turbidity around Halloween
HalloweenTurb=Turb[StopDjWY>25 & StopDjWY<40]
HalloweenTurb
plot(HalloweenTurb~StopDjWY) #error because I'm using my subsetted Turb with the full StopDjWY
plot(HalloweenTurb~StopDjWY[StopDjWY>25 & StopDjWY<40]) #This works, but the plot is skinny 
#because I'm stil in "3 x 1 plotting land".  Note that R "recycles" the plot spaces; this
#can cause overwriting if not careful...
par(mfrow=c(1,1)) #sets graphics window to be one plot
plot(HalloweenTurb~StopDjWY[StopDjWY>25 & StopDjWY<40]) #voila!
plot(HalloweenTurb~StopDjWY[StopDjWY>25 & StopDjWY<40], xlab="Day after 10/1/14", 
     ylab="Turbidity (NTU)", main="Turbidity at the Knights Landing RST during the Halloween
     high catch event")  #prettier version

#Let's add a "highlight window" -- CREDIT TO DAVE HARRIS FOR THIS CODE
# Define a translucent yellow color. Alpha controls opacity
translucent.yellow = rgb(red = 1, green = 1, blue = 0, alpha = .4)

# Add a translucent yellow rectangle between 800 and 1500 on the x axis
rect(xleft = 29, xright = 33, ytop = 42, ybottom = 0, col = translucent.yellow, border = NA) #ooooohhhh!
#notice that I don't have to be perfect on my "ytop" or "ybottom" guess; R limits the window 
#to within the graph box.
plot(HalloweenTurb~StopDjWY[StopDjWY>25 & StopDjWY<40], xlab="Day after 10/1/14", 
     ylab="Turbidity (NTU)", main="Turbidity at the Knights Landing RST during the Halloween
     high catch event")
rect(xleft = 29, xright = 33, ytop = 60, ybottom = -20, col = translucent.yellow, border = NA) #still good

#SESSION CLEANUP
#don't forget to remove variables and detach datasets, or you might be crying soon!get
#If using RStudio, can check to see that disappears from the Global Environment

#sidebar demonstrating how lexical scoping works in R
ls()
ls(pos=1)  #same as before, R assumes global environment first
ls(pos=2) #objects in the StandataJ data.frame
plot(EFF~StopDjWY) #this works
EFF=2 #now I create a variable that may "mask" my column header in StandataJ
ls() #now I see my new variable 
ls(pos=1) #and I still see my new variable
ls(pos=2) #and I see something with the same name, but in this position it's a vector
plot(EFF~StopDjWY) #I get an error, because (I think) the so-called "lexical scoping"
#in R looks first in the Global Environment and only then at other positions; if it
#finds a variable, it will try to use it.  BEWARE!  ...but it's so handy sometimes...
rm(EFF, pos=1)  #"rm" is for "remove"
ls(pos=1) #now the conflicting EFF object is gone
plot(EFF~StopDjWY) #now it works
#end sidebar

detach(pos=2)#this will clear out the datasets/variables I attached to position 2
ls(pos=2) #cleared out


