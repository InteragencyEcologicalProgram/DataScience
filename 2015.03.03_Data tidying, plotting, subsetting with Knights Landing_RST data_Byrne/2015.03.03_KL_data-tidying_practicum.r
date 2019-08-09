#Practicum on Data TIDYING & importing, using Knights Landing RST data
#3.5.15 FisheRies R User Group Meeting
#Barb Byrne, NMFS

#Original Knights Landing (KL) data is in shared file "2015.03.03_KLRSTorigexcel.xls"
#To tidy the data for use in R, I
#--deleted all but primary worksheet
#--replaced all header rows with "tidy" column headings
#--added new "EFF" (efficiency) column
#--DIDN'T, BUT MIGHT IN FUTURE: add a column for night/day/24-hour sampling
#--DIDN'T, BUT MIGHT IN FUTURE: capture the size info included in the 
#       comments to the AdCHINOOK cell entries
#--removed all highlighting (don't think necessary, but did anyway)
#--Deleted all "comments (e.g. in cell T122; NOT the comments column 
#       (not sure if necessary, but did anyway)
#--saved as .csv
#--saved column headers in a cheatsheet (R_datasets_column_headers.txt) so I 
#       have easy reference when coding
#tidier KL data is in shared file "2015.03.03_KLRSTcsv.csv"

#Check out Jeff Leek's "The Elements of Data Analytic Style" for good info on data practices

#Import tidy KL data, changing code as needed to reflect your filepath
read.csv("C:/Users/BAB/Documents/R/FisheRies/2015.03.05/2015.03.03_KLRSTcsv.csv", header=TRUE)
#check file by looking at top six rows using "head" command
#oops, I forgot to assign a name to the data 
KLdata=read.csv("C:/Users/BAB/Documents/R/FisheRies/2015.03.05/2015.03.03_KLRSTcsv.csv", header=TRUE)
#NOW I'll check file with "head" command
head(KLdata)

#In RStudio, just go to the environment tab and click on "Import dataset" to import
#a dataset (will be assigned to an R object with the name of the imported file).  The code will magically appear in the R console windwo, so you can grab
#to include in an R script.  Also, the filepath tells you about your working directory"
getwd() #returns working directory
setwd("C:/Users/BAB/Documents/R/FisheRies") #use "setwd()" to set working directory

#Can use "~" to indicate filepath of working directory,the below should work
#once working directory is "C:/Users/BAB/Documents/R/FisheRies"
KLdata=read.csv("~/2015.03.05/2015.03.03_KLRSTcsv.csv", header=TRUE) 
#But it doesn't, get error saying file doesn't exist.  I'll check my files
dir("C:/Users/BAB/Documents/R/FisheRies/2015.03.05") #file seems to be there
#Error says: "cannot open file 'C:/Users/BAB/Documents/2015.03.05/2015.03.03_KLRSTcsv.csv': 
#No such file or directory; appears that R thinks my working directory is "C:/Users/BAB/Documents"??
#HELP!!!!! Any trouble-shooting tips from the group?
#I'll just use the full filepath on Line 27


#Now I'll further check things out using the "str" (for "structure") command
str(KLdata)
#looking good -- the 143 observations checks out against original file 
#     (144 rows including 1 header row)
#...and the data associated with each variable are the "right" sort of data, 
#    so nothing got mixed up
#Hmmm...some columns (e.g. StartD, StartT) are assumed by R to be factors, 
#    when really are continuous.  Dates and times need some more work
#Hmmmm...columns with no decimal places are interpreted as integer vectors 
#    rather than numeric vectors; might want to change that but won't worry for now
#Hmmm..."Comments" column is interpreted as factor column; might want to change 
#    to character vector

#if for some reason you want to check the end of your data use the "tail" command
tail(KLdata)

#did my data import as a data.frame?  Let me check the class...
class(KLdata)
#yup, I'm set

#If you're using RStudio, go to the "Environment Tab" in the top right panel and 
#you can see see the class, dimensions, etc of your dataset, and even view in a 
#data window

#let's plot WaterT by date
plot(WaterT~StopD)

#sigh.  Bad syntax.
plot(KLdata$WaterT~KLdata$StopD)
#sigh. This is why dates can be problematic.  
#I'm gonna bite the bullet and transform into some sort of Julian day
#What is the difference between Julian Day and Julian Date????? Which am I doing???

#okay, time to import adjusted dataset & check it out
KLdataJ=read.csv("C:/Users/BAB/Documents/R/FisheRies/2015.03.05/2015.03.03_KLRSTcsv_julian.csv", header=TRUE)
head(KLdataJ)
tail(KLdataJ)
str(KLdataJ)

#let's plot WaterT by data again -- don't forget to refer to correct data object
plot(KLdataJ$WaterT~KLdataJ$StopD)
#...and don't forget to refer to adjusted julian day column
plot(KLdataJ$WaterT~KLdataJ$StopDjWY)
#not going to bother pretty-ing up the plot

#I'm going to do something potentially dangerous and "attach" my dataset so that I can drop the 
#"KLdataJ$" element of my variable names. 
attach(KLdataJ, pos=2)
ls(pos=2)

#KLdataJ now shows up in my "Environment Tab" in RStudio, and I can check out my variable names, 
#classes, etc. there.
#and, now I can explore my data faster
plot(WaterT~StopDjWY)

#let's check if the CPUE is the "catch/hours fished" that I think it is
MyCPUE=WR/HrsFished
CPUEdiff=MyCPUE-WRcpue
CPUEdiff
#ugh.  rounding issues. Is a way to check whether or not is "basically zero". I can't find it in my notes.
#This is close
zerocheck=CPUEdiff<0.0001
zerocheck
which(zerocheck==FALSE)
#try same thing with less restrictive "zero-like number"
zerocheck=CPUEdiff<0.001
zerocheck
which(zerocheck==FALSE)
#Let's check out the 60th observation
CPUEdiff[60]

#Close enough for me -- let's compare some CPUE data
plot(WRcpue~StopDjWY) #great, now I want to add SR to the plot
points(SRcpue~StopDjWY) #oops, same plotting character
#I can't remember how to change plotting character
help(points)
plot(WRcpue~StopDjWY) #to refresh plot with just WR data
points(SRcpue~StopDjWY, pch=2) #better

#Okay, let's adjust by the cone ops, e.g. using the EFF column
#First, let's just check how unadjusted CPUE looks at different EFFs
plot(WRcpue~EFF) #looks similar, but can't tell how many points at low WRcpue values
plot(WRcpue~EFF, jitter=TRUE)#dang, that didn't work
plot(WRcpue~EFF, jitter==TRUE) #that didn't work either (logical tests use double ==, but think
#that when setting a parameter, might just be a single =, even though using "logical" term)
help(plot) #that didn't help
help(jitter)#oh, I get it -- I have to jitter my data, then plot it
plot(jitter(WRcpue)~EFF) #...but that doesn't seem to do it.Maybe my WRcpue isn't numeric
class(WRcpue) #nope, it is numeric and should work. Oh, duh, I mean to jitter EFF, not WRcpue
plot(WRcpue~jitter(EFF)) #better, though hardly pretty...
plot(WRcpue~jitter(EFF, factor=0.1)) #not sure this is better, but you get the idea that you 
#can either let the jitter be set by default, or by setting degree of jitter explicitly

#Let's adjust the cpue
adjWRcpue=WRcpue*EFF #adjusts CPUE by cone ops
plot(adjWRcpue~WRcpue)
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
ls()
ls(pos=1)  #same as before, R assumes global environment first
ls(pos=2) #objects in the KLdataJ data.frame
plot(EFF~StopDjWY) #this works
EFF=2 #now I create a variable that may "mask" my column header in KLdataJ
ls() #now I see my new variable 
ls(pos=1) #and I still see my new variable
ls(pos=2) #and I see something with the same name, but in this position it's a vector
plot(EFF~StopDjWY) #I get an error, because (I think) the so-called "lexical scoping"
#in R looks first in the Global Environment and only then at other positions; if it
#finds a variable, it will try to use it.  BEWARE!  ...but it's so handy sometimes...
rm(EFF, pos=1)  #"rm" is for "remove"
ls(pos=1) #now the conflicting EFF object is gone
plot(EFF~StopDjWY) #now it works
detach(pos=2)
ls(pos=2) #cleared out


