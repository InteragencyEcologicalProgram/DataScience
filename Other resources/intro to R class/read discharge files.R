## R script for reading average daily discharge data for USGS stations

## These are the station numbers
stn.no = c(14171000, 14174000, 14306500, 14190500)

#lets check the first
stn.no[1]

## create place to put all of the discharge data
tada<-NULL

for(i in 1:length(stn.no)){
  # create object first that contains the query up to the station number
  first<- "http://waterdata.usgs.gov/or/nwis/dv?cb_00060=on&format=rdb&site_no="
#print it out
first

#create object that contains the end of the query after the station number
#note that date range is hard wider here
end = "&referred_module=sw&period=&begin_date=2000-01-01&end_date=2014-07-28"
#print it out
end

## now we use paste to combine first and the station number, "sep" tells the
## function that the separator between first and the station number is nothing
almost <- paste(first,stn.no[i],sep = "")
#print it out
almost

# and combine 'almost' with the end
location<- paste(almost,end, sep = "")
#print it out
location


# use the location we created above to download data and write to
# text file temp.txt this will be in the working directory
download.file(location,"temp.txt")

# read in the tab delimited flow file skip all the garbage at the top
# first 27 rows because its header junk
txt<-read.table("temp.txt",header=F,sep="\t", skip= 27)
#look at it
head(txt)
# select the first 4 columns
txt<-txt[,1:4]
## name the columns
colnames(txt)<- c("Agency","Gage.no","Date","Q.cfs")
#Combine with the other gages
tada<-rbind(tada,txt)
}


## Now lets allow the dates to vary from gage to gage

## These are the station numbers, beginning and ending dates
## note that all of these will be characters
stn.info = c(14171000, "1999-12-31", "2007-09-21",
             14174000, "2000-01-01", "2012-12-31",
             14306500, "1993-01-01", "1999-12-31", 
             14190500, "2003-02-10", "2013-12-31")
## make a matrix
stn.info<- matrix(stn.info, ncol = 3, byrow = T)

#lets check the first row
stn.info[1,]

## create place to put all of the discharge data
tada<-NULL

for(i in 1:nrow(stn.info)){
  
  # create object first that contains the query up to the station number
  first<- "http://waterdata.usgs.gov/or/nwis/dv?cb_00060=on&format=rdb&site_no="
  #print it out
  first
  
  #create object that containsbeginning date of the query after the station number
  #note that beginning date is pasted here
  begin = paste("&referred_module=sw&period=&begin_date=",stn.info[i,2], sep = "")
  
  ## here we're pasting the the end date for the discharge data
  end = paste("&end_date=",stn.info[i,3], sep = "")
  #print it out
  end
  
  ## now we use paste to combine first and the station number, "sep" tells the
  ## function that the separator between first and the station number is nothing
  first <- paste(first,stn.info[i,1],sep = "")
  #print it out
  first
  ## now add beginning date
  first<- paste(first,begin, sep = "")
  
  # and combine with the end date
  location<- paste(first,end, sep = "")
  #print it out
  location
  
  # usae the location we created above to download data and write to
  # text file temp.txt this will be in the working directory
  download.file(location,"temp.txt")
  
  # read in the tab delimited flow file skip all the garbage at the top
  # first 27 rows because its header junk
  txt<-read.table("temp.txt",header=F,sep="\t", skip= 27)
  #look at it
  head(txt)
  # select the first 4 columns
  txt<-txt[,1:4]
  ## name the columns
  colnames(txt)<- c("Agency","Gage.no","Date","Q.cfs")
  #Combine with the other gages
  tada<-rbind(tada,txt)
}

summary(tada)
