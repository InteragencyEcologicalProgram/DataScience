

## First lets create a vector of dates here we'll use 
## the Sys.Date command to get a vector of 10 dates starting 10 days 
## from today
begin<- Sys.Date()-10
end<- Sys.Date()
#here the vector
date.vect<- c(begin:end)
## what does it look like
date.vect

# change it to a format that is more understandabe
class(date.vect) = "Date"

## what does it look like? Thats better
date.vect


#A commonly encountered change to number format is when try to change
# dates in a vector or dataframe using ifelse. To illustrate, lets change the 
# date in the 'date.vect' from 3 days ago to todays date.

# old date we want to change
old.date = Sys.Date()-3
new.date = Sys.Date()

# this means if a value in date.vect (the date vector) equals the date from
# 3 days ago (old.date), change it to the new.date otherwise leave it the same
date.vect<-ifelse(date.vect == old.date,new.date,date.vect)
  
## what does it look like
date.vect

# change it to a format that is more understandabe
class(date.vect) = "Date"

## what does it look like? Thats better notice the 8th date equals the last date
date.vect

  
  



