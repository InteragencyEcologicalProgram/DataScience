# lets make 3 vectors
lengths<- runif(100,30,500)
wghts<-  0.0002*lengths^3
relative_weight<- wghts/300

# lets make 2 data.frames
data1<- data.frame(year=rep(2009:2012,25), len=lengths, wghts=wghts, rel_weight=relative_weight)

data2<- data.frame(year=sample(2009:2012, 50, replace=TRUE), len=runif(50,100,800))
data2$wghts<- 0.0002*data2$len^3.01
data2$rel_weight<- data2$wghts/500
# what are the field names we can select?
names(data1)
# select the field length
data1$len # returns the data in the length field
data1$wghts # returns the date from the weight field

# lets make a matrix of random numbers
x<- matrix(runif(120,0,1),nrow=10, ncol=12,byrow=TRUE)

mylist<- list(lengths=lengths, weights=wghts, 
	relative_weight=relative_weight,
	data1=data1, data2=data2, matrix1=x) # now we have a list!
##### END DATA GENERATION


##### DATAFRAMES AND LISTS

mylist$length # the vector from above
cbind(mylist$lengths,lengths)# they are the same!

mylist$weights # the vector from above
cbind(mylist$weights,wghts)# they are the same!

mylist$data1$year # the vector from above
data1$year
cbind(mylist$data1$year,data1$year)# they are the same!

mylist$data2$len
data2$len
cbind(mylist$data2$len, data2$len)# they are the same!


##### BRACKETS

# SELECT THE 3RD FIELD (LENGTH) FROM THE DATA
data2[ , 3] # THIS RETURNS THE SAME AS dat$len
names(data2) # note that length is the 3rd field
data2$len
data2[ , 4]
data2$rel_weight

data2[ ,c(2,3)] # SELECT LENGTH AND WEIGHT FIELDS
data2[ ,c(2,3,4)] # SELECT LENGTH, WEIGHT, AND RELATIVE WEIGHT
data2[ ,c(2:4)] # this is the same as the above line of code 
data2[ ,c(1,3:4)] # pretty flexible
data2[c(1,4,7,19),c(1,3,4)]

data2[c(1:30),3] # returns the same as dat[ ,3]
data2[ , 3] # same as above

data2[c(1:10),c(3,4)]

dat[c(1,4,7,19),c(1,3,4)]

sum(data2[c(1,3,5,7,9,11),3])
 
 
###### LISTS

mylist$data1$log_transformed_len<- log(mylist$data1$len)
mylist$l_weight<- log(mylist$data1$wght) # for weight
mylist$data1$l_weight
names(mylist)
names(mylist$data1)

mylist$data1$l_weight<- log(mylist$data1$wght) # for weight
names(mylist$data1)

# adding some more to the list
mylist$mean_l_weight<- mean(mylist$data1$l_weight)
mylist$mean_l_weight

mylist[[1]]# get the first object
mylist[[5]]# get the 5th object

mylist[[5]][1,]
mylist[[5]][,2]


##### VECTORS

victor<- data1$len
victor # the vector

victor[3]

victor>300 # selects all the values greater than 300
victor[victor>300]
victor[rep(c(TRUE,FALSE),50)]

mean(victor[victor>300])# not the same as
mean(victor)
new_victor<- victor[victor>300]
mean(new_victor)

##### Some useful tricks application of operators

dat<- mylist$data2
# LETS ADD A FEW VALUES
dat[rep(c(TRUE,FALSE),25),2]<- -99
dat[sort(rep(c(TRUE,FALSE),25)),3]<- -99

dat[dat==-99]<-NA

is.na(dat$len)
 
dat[is.na(data$len),]

dat_no_na<- dat[!(is.na(dat$len),] # super intuitive right? 
dat # not the same as dat_no_na
	
dat$len
na.omit(dat$len)
	
dat[na.omit(dat$length),]
	
complete.cases(dat) # returns a vector of true/falses
dat_complete<- dat[complete.cases(dat),] # select rows with no NA values
dat_complete # look at new data without NAs
dat # the data with NAs

##### SUBSETTING

dat2010<- subset(data1, year==2010)
dat_after_2010<- subset(data1, year>2010)
dat_all_but_2010<- subset(data1, year != 2010)
dat_even_years<- subset(data1, year %in% c( 2008, 2010, 2012))

dat_2010_length_100<- subset(data1, year==2010 & length > 100)
dat_2010_length_100 # FAIL! X#amp;*^, WHY?
names(data1)
dat_2010_length_100<- subset(data1, year==2010 & len > 100)

new_dat<- subset(data1, len > 400 | len < 50 )
new_dat<- subset(data1, year == 2010 & (len > 100 | len < 60))

######### MERGING

yeardata<- data.frame(year=c(2009:2012),type=c("wet","dry","extra dry", "bone dry"))
yeardata

names(data1)
names(yeardata)

mergedata<- merge(data1, yeardata, by="year")
mergedata # cool there is our merged datasets

mergedata<- subset(mergedata, year>2009)
mergedata # no 2009 data!

mergedata<- merge(data1, yeardata, by="year")
mergedata # uncool, there is no data for 2009
unique(mergedata$year)# lets make sure

mergedata<- merge(data1, yeardata, by="year",all.x=TRUE)
table(mergedata$year)
head(mergedata,30)# whew that is what we wanted!

# make some data to merge
data<- data.frame(year=sample(2009:2013, 8, replace=TRUE),
month=sample(7:9, 8, replace=TRUE),
weather=sample(letters[1:3],8,replace=TRUE))

# make some data to merge with that data
lots_o_data<- data.frame(year=sample(2009:2013, 80, replace=TRUE),
month=sample(7:9, 80, replace=TRUE),
length=runif(80, 100,600))
data
lots_o_data

lots_o_lots_o_data<- merge(data, lots_o_data, by=c("year","month"),all=TRUE)
lots_o_lots_o_data

########### APPENDING

all_vectors<- cbind(mylist$length, mylist$weight, mylist$relative_weight)

names(data1)
names(data2)
fulldata<-rbind(data1,data2)
dim(data1)
dim(data2)
dim(fulldata)

class(x) # make sure we can use a matrix
bigmatrix<- rbind(matrix1, matrix1)
dim(matrix1)
dim(bigmatrix)

# install.packages("plyr")
require(plyr)
data1_no_len<- data1[,-2]
names(data1_no_len)
names(data2) # names don't exactly match
fulldat<-rbind(data1_no_len,data2)# fail.... errror
fulldat<-rbind.fill(data1_no_len,data2)

########## SORTING

sort(data2$year, decreasing=TRUE)
sort(data2$year, decreasing=FALSE)

year_sorted<- sort(data2$year, decreasing=FALSE)
cbind(year_sorted, data2$year) # not the same!

order(data2$year, decreasing=TRUE)
order(data2$year, decreasing=FALSE)
order(data2$year,data2$len, decreasing=TRUE)

orderid<-order(data2$year,data2$len, decreasing=TRUE)

data2_sorted<- data2[orderid,]

data2_sorted<- data2[order(data2$year),]
data2_sorted

data2_sorted<- data2[order(data2$year, data2$len),]
data2_sorted


#### bonus material


which.min(data2$len) # returns the row index of the minimum value of len
which.max(data2$len) # returns the row index of the maximum value of len

data2[which.min(data2$len),]  # use the index to get that row of data
data2[which.max(data2$len),] # use the index to get that row of data

data_dup<- data2[c(1,1,1,2,2,2),]

weighted_data<- data.frame(spp=c("Critter 1","Critter 2","Critter 3"),counts=c(10,12,5))
weighted_data[ rep(c(1:3),weighted_data$counts),]