
## don't forget to set YOUR working directory
setwd("G:/")

## read example data file into a data frame
dater<-read.csv("dates.csv")

## let's see what is in the data frame
head(dater)

## what are the type of objects in the data frame
class(dater$date.m.d.y)

#print out columns
dater$date.m.d.y


#create Date1 using values in dater$date.m.d.y
Date1 <- as.Date(dater$date.m.d.y, format="%m/%d/%Y")
# print it out
Date1

# first coerce dater$date.m.d.y to become character
# then coerce to become date
Date1 <- as.Date(as.character(dater$date.m.d.y), format="%m/%d/%Y")

#check on the type of object we created
class(Date1)


# first check the class of the object (this is good practice)
class(dater$date.d.m.y)

# create Date2 by coercing dater$date.d.m.y notice the format is day
# month year
Date2 <- as.Date(dater$date.d.m.y, format="%d/%m/%Y")
#print it out
Date2
# check the class again for grins
class(Date2)

##First let's try dater$date.y.m.d print it out and examine
dater$date.y.m.d

## looks like year (4 digit) month, day try coercing using the code below
as.Date(dater$date.y.m.d, format="%Y/%m/%d")

# create Date3 by coercing dater$date.y.m.d notice the use of dashes
Date3 <- as.Date(dater$date.y.m.d, format="%Y-%m-%d")

### print out next object. Notice the values are delimited using a period
dater$date.d.m.y.2

# create Date4 by coercing dater$date.y.m.d notice the use of periods
Date4 <- as.Date(dater$date.d.m.y.2, format="%d.%m.%Y")

### print out next object dater$date.m.d.y.2.
dater$date.d.m.y.2


# create Date5 by coercing dater$date.m.d.y.2 notice the use %b and dashes
Date5 <- as.Date(dater$date.m.d.y.2, format="%d-%b-%Y")


# difference in days between Date1 and Date2
Date1 - Date2


help(difftime)


difftime(Date1,Date2, units = 'weeks')


(Date1 - Date2)/7

# create year by stripping the year value in Date1 and make it numeric
year <-as.numeric(format(Date1, format = "%Y"))

# create month by stripping the month value in Date1 and make it numeric
month <-as.numeric(format(Date1, format = "%m"))

## create month.char by stripping the month value in Date1 and output
## in abbreviated character format
month.char <- format(Date1, format = "%b")

# create day by stripping the day value in Date1 and make it numeric
day <-as.numeric(format(Date1, format = "%d"))

## create Julian date from Date1 and coerce into numeric
Julian<-as.numeric(strftime(Date1, format = "%j"))


# create object my.date using year, month, and day created above
my.date<-ISOdate(year,month,day)
#print it out
my.date

## just extract the year  month and day from my.date
strptime(my.date, "%Y-%m-%d")

#output dates every 2 weeks
seq(as.Date('2000-6-1'),to=as.Date('2000-8-1'),by='2 weeks')

#output dates each day
seq(as.Date('2000-6-1'),to=as.Date('2000-8-1'),by='1 days')


####COMPARISON (LOGICAL) OPERATORS
# create abundance and assign value of 10

abundance = 10

# determine if abundance is greater than zero

abundance > 0

# make comparison
if(abundance > 0) present = 1

## print out
present

#remove present
rm(present)

#set abundance to zero
abundance = 0

# make comparison
if(abundance > 0) present = 1
## print out
present

# make comparison
if(abundance > 0) present = 1 else present = 0
## print out
present

# make comparison
if(abundance > 0){ present = 1
  occupied = 'yes'
} else{ present = 0
      occupied = 'no'
}

## combine and print out
c(present, occupied)


new.date = as.Date("5/13/2011", format = "%m/%d/%Y")

### make comparison and assign season
if(as.numeric(format(new.date, format = "%m"))> 4 & as.numeric(format(new.date, format = "%m")) < 7) { season = 'spring'
## if its not spring it is another season
} else{season = 'other'}


#print it out
season

new.date = as.Date("2/11/2013", format = "%m/%d/%Y")

# just modify the above code
if(as.numeric(format(new.date, format = "%m"))< 4 & as.numeric(format(new.date, format = "%m")) > 11) { season = 'winter'
} else{season = 'other'}

#print it out
season


if(as.numeric(format(new.date, format = "%m")) < 4 | as.numeric(format(new.date, format = "%m")) > 11) { season = 'winter'
## assign other to non-winter months
} else{season = 'other'}

#print out
season


# identify days greater than equal to 15 (TRUE)
as.numeric(format(Date1, format = "%d")) >= 15


# identify days greater than equal to 15 (TRUE)
if(as.numeric(format(Date1, format = "%d")) >= 15) month.part = 2 else month.part = 1

Date1[1]


# identify if first day  greater than equal to 15 (TRUE)
if(as.numeric(format(Date1[1], format = "%d")) >= 15) month.part = 2 else month.part = 1

###############################FOR LOOPS

#for(i in min:max) {
#                do something max minus min times
#                   }

Y = 10
for(i in 1:10) {
# add 2 to Y
Y = Y + 2
# print it out?
Y
}

#print it out last value
Y

Y = 10
for(i in 1:10) {
# add 2 to Y
Y = Y + 2
# print it out!!
print(Y)
}


Z=c()
Y = 10
for(i in 1:10) {
            # add 2 to Y
            Y = Y + 2
            # save values of Y each step
            Z = c(Z,Y)
            }
 # print it out
Z

#set initial population size
N = 100
# create a place to put the simulated time series data
# star with year = 0 and initial population size N
time.series=c(0,N)
## growth rate
lambda = 1.05
# Yearly time step loop for 10 years
for(year in 1:10) {
             # grow the population
             N = N*lambda
             # save values
             time.series = rbind(time.series,c(year,N))
             }
# print it out
time.series

## create plane to hold trend assessment
trend= c()
for(i in 2:11){
        ## population size is in column 2
        ## compare pop size to previous pop size and create trend object
        if(time.series[i,2] > time.series[i-1,2]) trend[i] = "increasing" else trend[i] = "decreasing"
         }
# print it out
trend


#how many elements in Date1
length(Date1)

# create the object month.part
month.part = c()

for(i in 1:length(Date1)){
        # identify if first day greater than equal to 15 (TRUE)
        if(as.numeric(format(Date1[i], format = "%d")) >= 15) month.part[i] = 2 else month.part[i] = 1
        }

# print it out
month.part

## initial population size
N = 10
## create place for population time series
popn = c(0,N)
## population growth rate
lambda = 0.85
# for loop with index year
for(year in 1:100){
               N = N*lambda
              # save population data
              popn = rbind(popn,c(year,N))
              # if population size is less than 1 break out of loop
              if (N < 1) break
              }
# print it out
popn

#############VECTOR OPERATORS

#ifelse(comparison, value if true, value if false)



ifelse(as.numeric(format(Date1, format = "%d")) >= 15, 2,1)

