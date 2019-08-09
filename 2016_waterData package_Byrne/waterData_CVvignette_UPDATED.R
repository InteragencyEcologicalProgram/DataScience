#Based on waterData package, by Karen Ryberg and Aldo Vecchia of USGS

#This example was inspired by the vignette in Appendix 1 of:
#Ryberg, K.R. and Vecchia, A.V., 2012, waterData -- An R package for retrieval analysis and anomaly calculation of
#daily hydrologic time series data, version 1.0: U.S. Geological Survey Open-File Report 2012-1168, 8p.

#First, let's install waterData
install.packages("waterData")  
#this command should also trigger the installation of other packages needed by waterData, e.g. latticeExtra and XML
#install just means the package is available to the system; need to load into the workspace
library(waterData) #I get an R version warning message which I'm going to ignore

#some USGS gages I like
#Sacramento Basin
#USGS 11370500 SACRAMENTO R A KESWICK CA
#USGS 11372000 CLEAR C NR IGO CA
#USGS 11376550 BATTLE C BL COLEMAN FISH HATCHERY NR COTTONWOOD CA
#USGS 11377100 SACRAMENTO R AB BEND BRIDGE NR RED BLUFF CA
#USGS 11381500 MILL C NR LOS MOLINOS CA
#USGS 11383500 DEER C NR VINA CA
#USGS 11390500 SACRAMENTO R BL WILKINS SLOUGH NR GRIMES CA
#USGS 11425500 SACRAMENTO R A VERONA CA
#USGS 11447650 SACRAMENTO R A FREEPORT CA

#Delta
#USGS 11447890 SACRAMENTO R AB DELTA CROSS CHANNEL CA
#USGS 11336600 DELTA CROSS CHANNEL NR WALNUT GROVE
#USGS 11447903 GEORGIANA SLOUGH NR SACRAMENTO R
#USGS 11447905 SACRAMENTO R BL GEORGIANA SLOUGH CA
#USGS 11455420 SACRAMENTO R A RIO VISTA CA
#USGS 11313405 OLD R A BACON ISLAND CA (1 of 2 gages for OMR)
#USGS 11312676 MIDDLE R AT MIDDLE RIVER CA (2 of 2 gages for OMR)
#USGS 11304810 SAN JOAQUIN R BL GARWOOD BRIDGE A STOCKTON CA
#USGS 11313460 SAN JOAQUIN R A PRISONERS PT NR TERMINOUS CA
#USGS 11337190 SAN JOAQUIN R A JERSEY POINT CA

#SJ Basin
#USGS 11302000 STANISLAUS R BL GOODWIN DAM NR KNIGHTS FERRY CA
#USGS 11299995 TULLOCH RES NR KNIGHTS FERRY CA
#USGS 11303000 STANISLAUS R A RIPON CA
#USGS 11303500 SAN JOAQUIN R NR VERNALIS CA

#DATA IMPOT LIMITATIONS -- the waterData package can only (as far as I can tell) pull in "daily data"
#Sample URL for seeing what daily values are available -- can just replace gage number at end of URL with any gage number of interest
#http://waterdata.usgs.gov/nwis/dv?referred_module=sw&site_no=11302000

#Sample URL for seeing ALL data available, can click into the "Daily Data" (NOT "Daily Statistics") info from this URL:
# http://waterdata.usgs.gov/nwis/inventory/?site_no=11302000&agency_cd=USGS

#CLEAN waterData import starts at Line 213.
#CLEAN function begins at Line 238

#Let's try out the "importDVs" function on USGS 11302000 (Stan R. near Knights Ferry)
#but first let's check out the parameters available
#all parameter codes (not necessarily available at all gages) can be searched at:
#http://nwis.waterdata.usgs.gov/usa/nwis/pmcodes
#Are OOODLES of parameters; simpler I think to just see what is avail at the gage of interest
#http://nwis.waterdata.usgs.gov/ca/nwis/uv/?cb_00010=on&format=gif_default&site_no=11302000
#Just water temp avail under "current/historical" instantaneous data -- code for that is 00010
#daily flow and temp data also available under "daily data" 
#****THIS waterData package ONLY WORKS ON DAILY DATA -- note the "uv" in the above URL which is instantaneous data *********
#depending on how you search, you may have different parameters available
#all avail data: http://waterdata.usgs.gov/nwis/inventory/?site_no=11302000&agency_cd=USGS
#daily temp max, min, med back to 1966!!!  And discharge back to 1957. yee-hah!

#do I want all data or some statistic, e.g. daily mean?  Because I want min, max, and mean temp, as
#well as 7DADM, I'm just gonna grab it all and do the statistics in R, rather than grab three diff
#sets of data.  
#statistics codes are available at:
#http://nwis.waterdata.usgs.gov/nwis/help/?read_file=stat&format=table
#or not.... This was the URL given in Appendix 1, but doesn't seem to work.  
#On 6/23/15, the right URL was: http://help.waterdata.usgs.gov/stat_code
#TOP rows excerpted below; also a bunch of percentile and frequency analysis stats available -- see URL for full list
#REMEMBER -- CHECK GAGE FOR WHAT IS AVAILABLE

#Statistic Type Code   Statistic Type Name 	Statistic Type Description
#00001 	MAXIMUM 	MAXIMUM VALUES
#00002 	MINIMUM 	MINIMUM VALUES
#00003 	MEAN 	MEAN VALUES
#00004 	AM 	VALUES TAKEN BETWEEN 0001 AND 1200
#00005 	PM 	VALUES TAKEN BETWEEN 1201 AND 2400
#00006 	SUM 	SUMMATION VALUES
#00007 	MODE 	MODAL VALUES
#00008 	MEDIAN 	MEDIAN VALUES
#00009 	STD 	STANDARD DEVIATION VALUES
#00010 	VARIANCE 	VARIANCE VALUES
#00011 	INSTANTANEOUS 	RANDOM INSTANTANEOUS VALUES
#00012 	EQUIVALENT MEAN 	EQUIVALENT MEAN VALUES
#00013 	SKEWNESS 	SKEWNESS VALUES
#00021 	TIDAL HIGH-HIGH 	TIDAL HIGH-HIGH VALUES
#00022 	TIDAL LOW-HIGH 	TIDAL LOW-HIGH VALUES
#00023 	TIDAL HIGH-LOW 	TIDAL HIGH-LOW VALUES
#00024 	TIDAL LOW-LOW 	TIDAL LOW-LOW VALUES

#okay, let's try it!

t11302000=importDVs("11302000", code="00010") #first argument is for station, code for data (e.g. flow vs. temp)
#default startdate (sdate argument) is 1851-01-01; default enddate (edate argument is current system date)
#got an error message related to xmlName, maybe I need to load the associated packages
library(XML)
library(latticeExtra)
#ignoring all those red warning messages related to the R version
#let's try again; same code as before
t11302000=importDVs("11302000", code="00010") 
#nope.
#will try using exact code from their vignette
q05054000=importDVs("05054000", code="00060", stat="00003", sdate="2000-01-01", edate="2010-12-31")
#that worked.  earlier issue must be (gasp!) user error?!?!
head(q05054000)
tail(q05054000)

#IF YOU DON'T WANT TO SEE MY TROUBLE-SHOOTING on importing temp data, JUMP TO LINE 132 -- got a helpful troubleshoot from the
#package-developer, Karen Ryberg, herself!!!

#Maybe I need a stat code; don't really want mean, but will ask for it.
t11302000=importDVs("11302000", code="00010", stat="00003")
#nope, same error message.  Will put in start and end dates for a single year; maybe the default
#dates are messing up the system because the data don't go back to 1851.
t11302000=importDVs("11302000", code="00010", sdate="2014-01-01", edate="2014-12-31")
#nope, same UseMethod error again.
help(UseMethod) #uh, don't understand this help file
#I noticed that station 11302000 wasn't on the USGS Current Conditions list:
# http://waterdata.usgs.gov/ca/nwis/current?type=flow&group_key=NONE
#... maybe data from this gage is less "grabbable" than from other gages?

#Will try my previous code for 11390500 (Sac R below Wilkins Slough), which also has temp data, 
#and *is* listed on the list for CA Current Conditions gages
t11390500=importDVs("11390500", code="00010", sdate="2014-01-01", edate="2014-12-31")
#same error message
#will try with flow data
q11390500=importDVs("11390500", code="00060", sdate="2014-01-01", edate="2014-12-31")
#THAT WORKED!!!
head(q11390500)
#What about gage height, another parameter at Wilkins Slough
h11390500=importDVs("11390500", code="00065", sdate="2014-01-01", edate="2014-12-31")
#Nope. 

#can I get flow data from the Stan R above KF gage?
q11302000=importDVs("11302000", code="00060", sdate="2014-01-01", edate="2014-12-31")
#yup!
head(q11302000)
#must be something with temp.  ???
#e-mailed Ryberg & Vecchia after stackoverflow and googling didn't turn up anything on trouble-shooting
#the waterData package.  Ryberg suggested I look again at the data available at my gage: 
#http://waterdata.usgs.gov/nwis/dv/?site_no=11302000
#The data seems to just be available as max, min, and median
#and I took a look at the R documentation in Appendix 2 and the importDVs function
#sets the default "stat" argument to 00003, which is the mean.  WHICH DOESN'T EXIST AT THIS GAGE!
#The mean DOES exist for the flow data, which is why the default stat argument worked for flow data
#I found the list of stat codes on the USGS website (see excerpt at line 73)
#max=00001, min=00002, & median=00008
tMax11302000=importDVs("11302000", code="00010", stat="00001",sdate="2014-01-01", edate="2014-12-31")
head(tMax11302000)
tMin11302000=importDVs("11302000", code="00010", stat="00002",sdate="2014-01-01", edate="2014-12-31")
head(tMin11302000)
tMed11302000=importDVs("11302000", code="00010", stat="00008",sdate="2014-01-01", edate="2014-12-31")
head(tMed11302000)
#Happiness. :-)
#will it work on Wilkins Slough gage if I ask for existing temp parameter?
#Check for avail data: http://waterdata.usgs.gov/nwis/dv/?site_no=11390500
#Same as other gage; max, min, median for temp data
tMax11390500=importDVs("11390500", code="00010", stat="00001",sdate="2014-01-01", edate="2014-12-31")
head(tMax11390500)
#works!!!

#Okay, now I'm gonna get down to business.
#Gonna clear my workspace and start clean
#used "clear workspace" option under Session menu in R Studio.  
#Not sure how to clear workspace using a single commands (but figured it out a few lines down)
#Do know that can remove objects one by one, e.g.
#add some objects to the global environment of my workspace (since cleared using menu option)
tMax11302000=importDVs("11302000", code="00010", stat="00001",sdate="2014-01-01", edate="2014-12-31")
tMin11302000=importDVs("11302000", code="00010", stat="00002",sdate="2014-01-01", edate="2014-12-31")
ls() #show what's in the global environment
#remove one by one
rm(tMax11302000)
ls() #now just the tMin object left
rm(tMin11302000)
ls()#now nothing left

#alternatively, can remove all at once (now I *do* know how to clear workspace with a single command!)
#add some objects to the workspace again
tMax11302000=importDVs("11302000", code="00010", stat="00001",sdate="2014-01-01", edate="2014-12-31")
tMin11302000=importDVs("11302000", code="00010", stat="00002",sdate="2014-01-01", edate="2014-12-31")
ls()
rm(list=ls()) #remove all at once.  Setting the "list" argument for the rm command to equal ls() 
#means that the rm command will be applied to all elements of that list, which should have all objects in the workspace.
ls() #check that workspace is clear
#Note that  the ls() commands are optional; I included here just to track my object formation and removal.

#Okay, NOW I'm getting down to business
#Okay before I plot, I want to calculate a 7 day average of daily max temp (7DADM)
#Found out one way to make a function that will calculate a moving average at: http://www.markhneedham.com/blog/2014/09/13/r-calculating-rolling-or-moving-averages/
tMax11302000=importDVs("11302000", code="00010", stat="00001",sdate="2014-01-01", edate="2014-12-31")
SevenDADM <- function(x,n=7){filter(x,rep(1/n,n), sides=1)} #don't follow all the filter args, but it works!
#I set the default value of n to 7, since I want to generate a 7-day average.  If you wanted some other averaging
#window, you can override the 7 using this same function by giving an alternate value, e.g. n=14.  
#watch out for that "sides" argument in the filter function within this function!!! 
#sides=2 centers the window;sides=1 means the value will only include past values (what I want).
#Note that I tried assigning to a function called "7DADM" and kept getting an error; changing the name to SevenDADM worked
#Guess R doesn't like objects starting with numbers???
SevenDADMout=SevenDADM(tMax11302000)
str(SevenDADMout) #hmmm, 365 rows, as expected, but have 4 columns
#Duh, that's because tMax11302000 has four columns.  The 7DADM of the gage number and qualifier code became 1; the
#temp data did what I wanted, and the data info was converted to julian dates and averaged!!!!!  7day average of daily date?!?

#to just get the 7DADM of temp, use
SevenDADMout=SevenDADM(tMax11302000[,2]) #This applies the SevenDADM function to the second, temp data column
View(SevenDADMout)#Not sure what this will do in R, but in Rstudio, this command in the R Console causes a worksheet-like 
#view of the data to pop up in set of tabs in the upper left panel (where the script file is as well)


#CLEAN CODE for USGS 11302000 (Stan R. above Knights Ferry)
library(waterData) #this is sufficient if have already installed the waterData package; if you haven't, use >install.packages("waterData" before picking up at this line)
tMax11302000=importDVs("11302000", code="00010", stat="00001",sdate="2014-01-01", edate="2014-12-31") #import daily max temp
head(tMax11302000)
tMin11302000=importDVs("11302000", code="00010", stat="00002",sdate="2014-01-01", edate="2014-12-31") #import daily min temp
head(tMin11302000)
tMed11302000=importDVs("11302000", code="00010", stat="00008",sdate="2014-01-01", edate="2014-12-31") #import daily median temp
head(tMed11302000)
qMean11302000=importDVs("11302000", code="00060", stat="00003",sdate="2014-01-01", edate="2014-12-31") #import daily mean flow
head(tMed11302000)
SevenDADM <- function(x,n=7){filter(x,rep(1/n,n), sides=1)} #create function to calculate 7 day averages
SevenDADMout=SevenDADM(tMax11302000[,2]) #apply function to max temp data
View(SevenDADMout) #Note that is a CAPITAL "V"!

#Ready to start plotting! 
#for emily: use >par(mfrow=c(1,4)) or maybe >par(mfrow=c(4,1)) or par(mfrow=c(2,2))  before any plot command; plots more than one plot

#CLEAN FUNCTION for temp/flow graph for any USGS gage with mean flow, and max/min/median temp data

##BUT FUNCTION IS STILL GLITCHY -- HAVING PROBLEMS WITH F vs C plots, and in turning off med temp data grab

#note that built-in ylim in plot code good for Stan R above Knights Ferry, but Ripon and OBB data are too
#high to fit.  Leaving auto ylim (by removing ylim argument) may set ylim range so that abline ref line won't show.  
#Maybe could do something fancy to set ylim to a min of "1 degree below data min or ref line, whichever is lower" 
#to a max of "1 degree above data max or ref line, whichever is higher".  HAVE NOT DONE SO YET.
USGSTempFlowFig=function(gageid, Tmax=1, Tmin=1, Tmed=1, Qmean=1, TinF=1, start, end)
{
  #gageid should be input in quotation marks, e.g. "11302000" 
  #set Tmax, Tmin, Tmed and/or Qmean to =0 for any element not wanted on the figure
  #TinF=1 default is for figure in Fahrenheit; TinF=0 is for fig in Celsius
  ##start, and end should be input in quotation marks, in the form "yyyy-mm-dd"
  #sdate and edate arguments in the importDVs function in the waterData package have default argument values,
  #BUT since are set to "start" and "end", the user NEEDS to set the "start" and "end" arguments in the call to the 
  #USGSTempFlowFig function so that the embedded importDVs function has the necessary arguments.
  
  #I'm interested in summer temps on the Stan, and the criterion goes into effect June 1.
  #Because the criterion in effect during May is different, I don't want to generate a 7DADM for June 1-6, 
  #since will include days not subject to the June-Sept criterion.
  
  #BUT, since some might not like to have 6 days of NAs in the front of their 7DADM data,
  #could, in the future, add some sort of "frontfill" argument.  e.g.,if frontfill==1, adjust start or sdate to be 
  #6 days earlier so have a 7DADM on first day of period.  Probably requires some painful conversion to julian date 
  #and back into the "yyyy-mm-dd" format -- might be easier to have a datastart and graphstart date; 
  #the datastart can be set 6 days earlier, and plotted from the graphstart date.  
  #That second way is less elegant but easy. 
  
  library(waterData) #note that if you don't have this package installed, this function will kick out an error. 
  if(Tmax==1) #reminder that can set something equal to some value with a single equal sign, but... 
    #...asking if something is equal to some value takes two equal signs
    # How "if" works:  if the condition in the parentheses is true, R should do all the stuff in the following curly braces
  {tMaxData=importDVs(staid=gageid, code="00010", stat="00001",sdate=start, edate=end) #import data; a four-column data frame
   tMaxDataF=((9/5)*tMaxData[,2])+32} #Convert data from imported C data to F data; a single vector (since converted only the temp column)
  
  if(Tmin==1)
  {tMinData=importDVs(staid=gageid, code="00010", stat="00002",sdate=start, edate=end)
   tMinDataF=((9/5)*tMinData[,2])+32} #Convert data from imported C data to F data
  
  if(Tmed==1)
  {tMedData=importDVs(staid=gageid, code="00010", stat="00008",sdate=start, edate=end)
   tMedDataF=((9/5)*tMedData[,2])+32} #Convert data from imported C data to F data
  else {print("I think Tmed is not 1")} #added this in for some troubleshooting -- can ignore
  
  if(Qmean==1)
  {qMeanData=importDVs(staid=gageid, code="00010", stat="00001",sdate=start, edate=end)}
  
  SevenDADM <- function(x,n=7){filter(x,rep(1/n,n), sides=1)} #define function 
  SevenDADMout=SevenDADM(tMaxData[,2]) #apply function to max temp data
  SevenDADMoutF=((9/5)*SevenDADMout)+32 #Convert data from imported C data to F data -- could instead have just applied SevenDadm function to tMaxDataF
  
  #Fahrenheit plot
  if(TinF==1)
  {
    #used to have C to F conversions here, but would have needed to include 3 more if statements
    #in case max, min, or mean turned "off"; just moved conversion into if statements above.  Can 
    #set unlimited number of expressions within the curly braces after each if command
    
    plot(tMaxDataF~tMaxData$dates, ylab="Water Temperature (degrees F)", xlab="Date", ylim=c(50,72),cex=0.5,
         main=gageid) 
    #don't use $val in the y-axis data since converted data is a header-less vector 
    points(tMinDataF~tMaxData$dates, pch=3,cex=0.5) #didn't change xaxis data; date column should be same in all datasets
    lines(SevenDADMoutF~tMaxData$dates, lty=1, col="red", lwd=3)
    abline(65,0, lty=2,lwd=3)
  }
  else
  {
  #Celsius plot
    plot(tMaxData$val~tMaxData$dates, ylab="Water Temperature (degrees C)", xlab="Date", ylim=c(10,20),cex=0.5,
         main=gageid)
    points(tMinData$val~tMaxData$dates, pch=3,cex=0.5) #didn't change xaxis data; date column should be same in all datasets
    lines(SevenDADMout~tMaxData$dates, lty=1, col="red", lwd=3)
    abline(18.3,0, lty=2,lwd=3)
   }
}

#Test function
USGSTempFlowFig("11302000", start="2015-06-01", end="2015-08-03") #default TinF=1, Stan R above KF
#WORKS!
USGSTempFlowFig("11302000", TinF=0, start="2015-06-01", end="2015-08-03") #Stan R above KF
#works!
USGSTempFlowFig("11303500", TinF=1, start="2015-06-01", end="2015-08-03") #USGS 11303500 SAN JOAQUIN R NR VERNALIS CA
#Horrifyingly hot

#Back to Stan, going back in time...
USGSTempFlowFig("11302000", start="1966-02-01", end="2015-08-03") #default TinF=1, Stan R above KF
#Cool!  Or, rather, NOT cool pre-1983...
USGSTempFlowFig("11302000", start="1966-02-01", end="1976-08-03") #default TinF=1, Stan R above KF
#error -- hmmm....
11302000data=importDVs(staid=11302000, code="00010", stat="00001",sdate="1966-02-01", edate="1976-08-03")
#ERROR--doesn't like object starting with a number
T11302000data=importDVs(staid=11302000, code="00010", stat="00001",sdate="1966-02-01", edate="1976-08-03")
#ERROR--need quotation marks around station
T11302000data=importDVs(staid="11302000", code="00010", stat="00001",sdate="1966-02-01", edate="1976-08-03")
#that works
head(T11302000data)
sum(is.na(T11302000data$val)) #how many values in the temp column are NAs?
which(is.na(T11302000data$val)) #in which rows are the NA temp values?
T11302000data$dates[T11302000data$val==is.na] #which dates are associated with NA temp values?
#doesn't work
T11302000data$dates[is.na(T11302000data$val)] #which dates are associated with NA temp values?
#sweet!!!

#try 70's data again, with end date with existing data...but 1976-08-03 does appear to be date with existing data
#what is temp on 8/3/1976?
T11302000data$val[T11302000data$dates=="1976-08-03"] #don't forget the double equal signs to test condition

USGSTempFlowFig("11302000", start="1966-02-01", end="1976-08-03") #default TinF=1, Stan R above KF
#still doesn't work -- I'm stumped.

#let's try for Clear Creek near Igo gage
USGSTempFlowFig("11372000", start="2015-06-01", end="2015-06-23")
#get same "UseMethod" error name I got before, which now makes me think the data I'm asking for doesn't exist,
#so I'll go check out what's available at that gage: http://waterdata.usgs.gov/nwis/dv/?site_no=11372000
#...and no Median temp data is available, so the function is hiccuping at that point.  
#luckily, I can turn off the Median query by setting Tmed=0
USGSTempFlowFig("11372000", Tmed=0, start="2015-06-01", end="2015-06-23")
#but that doesn't work. Still get UseMethod error
#let's see if the Tmed argument is being recognized; will run Tmed=0 on gage with median data, e.g. 11302000
USGSTempFlowFig("11302000", Tmed=0,  start="2011-06-01", end="2015-06-23")
#this works, probably because function is trying to get median data and can.  My Tmed (and probably Tmax and Tmin
#arguments seem not to be working, now that I'm testing them!)

#I'm doing some ad-hoc debugging to figure out WHERE in teh code my problem is
#Added in an "else" statement after my if(Tmed==1)expression
USGSTempFlowFig("11372000", Tmed=0, start="2015-06-01", end="2015-06-23")
#Would expect the above to print("I think Tmed is not 1"), but it doesn't, so it's failing before then.
USGSTempFlowFig("11302000", Tmed=0,  start="2015-06-01", end="2015-06-23")
#However, the above does print("I think Tmed is not 1"), which suggests that the fxn knows that Tmed=0,
#and shouldn't be trying to access median data, and so not kicking out the UseMethod error.  

#Checked data avail again:http://waterdata.usgs.gov/nwis/dv/?site_no=11372000
#AAHHHHHH -- Now I see that the temp max & min data only avail 3/25/1965 to 1/28/79
USGSTempFlowFig("11372000", Tmed=0, start="1970-01-01", end="1975-01-01")
#Yay -- it works!
#now let's test with Tmed=1, which shouldn't work (because this gage doesn't have med temp data available)
USGSTempFlowFig("11372000", Tmed=1, start="1970-01-01", end="1975-01-01")
#yup, as expected (and as should be the case) this doesn't work.  

#I <3 the waterData package!