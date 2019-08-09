## Script created by M. Henderson for an introduction to R workshop in Stockton, CA - 9/28-9/29/2016

##########################     Quick R introduction   ########################################

#Let's start with a brief overview of some simple math we can perform with R
#To send each of the following commands from the script (what we are writing in) to the R console that actually
# does the analysis (down below) either click the 'Run' button at the top of the script (if you are using Rstudio), 
# write click and choose 'Run line or selection', or hit Ctrl-Enter (my favorite). You can also select multiple lines
# of code and run them all at once using the same commands.

# It is also crucially important that you comment all of your code so that you know what you did. In R the '#' is the
# comment symbol. In Rstudio, any comments will be color coded 'green' so you can tell them apart from the rest of 
# the script. I want you to write as many comments as possible throughout this workshop so that when you look over
# your code you will know what you did and how you did it. This doesn't only go for a workshop, it will be a valuable
# skill to have for the rest of your programming life!!!

2+2 #addition
3-2 #subtraction
3*5 #multiplication
3/5 #division
2^2 #exponent

#how do we save the result? We make an object!

result <- 2+2

#to look at this result, we simply have to print it out!
result

# R is an object oriented language. Meaning that it performs operations on objects and then will return
# the results from those operations as an object. So objects can include individual numbers (scalars), multiple
# number representing something (vectors), and larger collections of numbers and characters (data frames and lists).
# Other objects in R include functions, plots, and the results of statistical operations. But I'm getting ahead of
# myself, let's take one thing at a time.

# Note that we assigned the result of 2+2 to an object called 'results' using the operator '<-'
# We also could have used the equals sign (=)

result = 2+2

# It is important to note that object names in R are case sensitive, so the object 'result' is not the same as the 
# object 'Result'. Let's try that to make sure

result
Result #what happens when you enter this line of code?

# As I said before, we can used the objects in other operations. So if I want to multiply one result versus another:

result1 <- 4+4
result * result1

# I want to note here that these objects names are not the best programming practice. As you are writing your code,
# try to imagine if you will be able to make sense of things when you look at it again in a year. A year from now, will 
# you remember what result and result1 represented? Probably not. 

# It's better to give your objects relatively short names that are meaningful to you. Ideally, these names will
# also be relatively intuitive, so that other people looking at your code will be able to figure out what you did.
# Sometimes this is difficult to achieve, so just do the best you can.

# The objects we created are in the working directory. To see the contents of the working directory look up to the
# Environment tab in the upper right of the screen (if you are using Rstudio), or type:
ls()

# if we want to get rid of one of these objects we can use one of the following commands
remove(result)
# or in shorthand
rm(result1)



#############################     Data types       ################################

my.scalar <- 10 # a scalar
my.vector <- c(1, 2, 3, 4, 5) # a vector

# to create the vector we used the concatentate function 'c()'. If it helps you can also think of this c() as
# referring to collect or combine

# R is great at performing operations on an entire vector: 
small.vector <- my.vector/10
#look at the results
small.vector

#often we need to refer to individual elements within vectors. To do this, we use the square brackets
my.vector[4]
#what would it be if we did the same thing for small.vector
small.vector[4]

# Now that we know how to extract these elements, we can do things with them. Like assign them to a new object
fourth <- small.vector[4]

# We can also refer to multiple items in a vector using a colon
small.vector[3:5]

# the colon means that we are creating a sequence
new.vect <- c(10:20) 
new.vect
# Wow, that was a lot easier than typing them in individually!

#There are lots of other operators for creating vectors. Here are a few:

#create a vector with a sequence of values from 1.25 to 8.75 by increments of 0.25
wow <- seq(1.25, 8.75, by=0.25)

#create a vector with a sequence of 13 evenly spaced values between 9 and 14
double.wow <- seq(9, 14, length=13)

#create a vector of 13 elements with the same value 41
double.dog.wow <- rep(41,13)

#create a vector consisting of two sequences of 1, 2, 3, 4
triple.dog.wow <- rep(1:4, 2)

####### help!!!!
#here it's important to say that nobody can remember all of these commands or what order everything is entered in
# to find the syntax for the command do a search in the help tab in the window in the lower right of the Rstudio pane.
# you can also type
?seq

# this help window will show you the syntax (what commands should be typed to accurately execute the command), describe
# the different arguments and the details regarding how things are done, and provide examples of how to use the 
# command correctly

#######
# lets move on to matrices - values contained in multiple rows and columns

# start with what we know
vect <- c(1:12)

#lets try to make a matrix out of this vector that has 3 columns and 4 rows
my.matrix <- matrix(vect) 

#did that work? Why not? Can we figure out what else we need to add?
?matrix

# Ahhh...we need to add some more commands
my.matrix <- matrix(vect, nrow=4)
my.matrix

# we also could have specified the number of colums
my.matrix <- matrix(vect, ncol=3)
my.matrix

# what if we wanted number increasing across columns instead of down rows?
my.matrix <- matrix(vect, ncol=3, byrow = TRUE)
my.matrix

# Notice the numbers in brackets specifying the rows (before comma) and columns (after comma)
# Just as with vectors, we can also refer to items within matrices:
my.matrix[2,3]

#In the square brackets for a matrix it will alway be [row, column]
# values in the 2nd and 3rd row of the first colum
my.matrix[2:3, 1]

#values in the 1st and 3rd row of the second column
my.matrix[c(1,3), 2]

# all the rows in the 2nd column - nothing needed to represent rows because we want all of them
my.matrix[,2]

#all of the columns in the 3 row
my.matrix[3,]

# Also, you can change values within an object by using the square brackets
my.matrix[2,2] <- 999

# What value would have been changed? Take a second to answer that before running the next line of code.
my.matrix

#### A brief introduction to working with characters and strings  ###

# So far we have only been working with numeric values in our objects, but R can also work with letters or words. 
# These are referred to in R as 'characters' or 'strings'

# We place characters inside quotes to distinguish them from numbers
species <- 'dog'
species

# we can also create a vector of strings
species.vect <- c('dog', 'cat', 'hamster')
species.vect

# Ways to create sequences of letters
alphabet <- letters[1:10]
alphabet

# how would you create a sequence of upper case letters (hint: use the help menu to look up 'letters')

# Let's make a matrix with letters
alpha.mat <- matrix(alphabet, ncol=2, byrow = TRUE)

#just like with a number matrix we can subset this matrix. How would we find the value in the 2 row of the first column?
##  go on, try to figure it out. I'll wait.

#what happens if we mix numbers and letters in the same matrix
mixed.matrix <- matrix(c(seq(1:5), letters[1:5]), ncol=2)
mixed.matrix

# Notice that the numbers are all now in quotes, meaning that R is treating these numbers as characters. This is because
# R will not allow vectors or matrices to have different types of values (e.g., numbers and characters). So if there
# are both numbers and letters in the same vector or matrix, R automatically reduces one type to the other. This
# is called coercion.

# Just to emphasize that point: A vector or a matrix cannot contain mixtures of numeric and character variables!!!!!

# Let's see what happens when we try to do operations on the numbers that R coerced to be characters
first <- mixed.matrix[1,1]
second <- mixed.matrix[2,1]

first+second

#there are a few functions to determine if an object is a number, character, or anything else
# (these are known as modes in R) 
typeof(first)
class(first)
is.character(first)
#there are all sorts of 'is.' statements
is.numeric(first)
is.integer(first)
is.vector(first)
is.matrix(first)
#etc...

# In Rstudio you can also see these values in the workspace window to the upper right

# So if R automatically changes something, can we change it back? Yep!
first.num <- as.numeric(first)
first.num
is.numeric(first.num)

# I'm curious, what happens if we try that on the matrix
curious <- as.numeric(mixed.matrix)

#you should have gotten this message
# Warning message: NAs introduced by coercion 

curious
#as you can see, all the letters were replaced by NAs. R doesn't know how to change a letter back into a number, so
# it replaces them with an NA

#Let's check the attributes of the matrix
class(curious)
typeof(curious)
is.matrix(curious)
### what????
is.vector(curious)
#when we converted it back to a number R made it into a vector. How can we make it back into a matrix?
curious.mat <- matrix(curious, ncol=2)

#now, what if we want to find out where there are NAs in the matrix
is.na(curious.mat)

#what if we wanted to replace those NAs with another value - say -999
# Well, we will have to use our handy matrix indices
# with the is.na command, we identified the locations in the matrix that had NAs
# so what happens if we just look at those values
curious.mat[is.na(curious.mat)]

#do you see what happened? That just returned the values for which the is.na command was TRUE
# It's the same as:
curious.mat[,2]

#So to replace them, we just reassign those values
curious.mat[is.na(curious.mat)] <- -999
curious.mat

####################  Data Frames  ########################
# Data Frames are similar to spreadsheets, so they will be a little more intuitive to people experienced in excel.
# Unlike vectors or matrices, data frames can contain values of different data types. BUT, each column within 
# a data frame can only contain one type of data. In other words, each column in a data frame can be considered
# a vector, and so the values within those columns must be of the same data type. 

# It's easier to illustrate by example, so let's do that.
#convert the curious.mat into a data.frame
curious.dat <- as.data.frame(curious.mat)
curious.dat

# did we do what we think?
class(curious.dat)
is.matrix(curious.dat)

#the column names are V1 and V2. The V stands for variable. These aren't very informative, so let's give them more
# useful names
colnames(curious.dat) <- c('site', 'data')
curious.dat

# We have a new way to refer to columns in data frames that we couldn't use with vectors or matrices
curious.dat$site

# But, we can also still use the square brackets
curious.dat[,1]

###################       lists        ###############################

# Lists are basically ways of combining information that are related, but may not belong in the same
# vector or data frame. For example, in R the output from many statistical analyses are returned as
# lists. In the case of a linear model this list may include the fit of the model (r-squared), the 
# coefficient estimates (intercept and slope), and many other goodies. Because you can combine these
# different data types that may even have different lengths (e.g., the r-squared is a single value but
# there are at least 2 coefficients in a linear model), lists are extremely flexible. They can also contain 
# objects that are numeric, character, or any other data type. However, just like they can't be in the same
# column of a data frame, they can't be in the same component (more on this later) of a list.

#First lets create some objects to put into our list

#create a numeric vector with a sequence of values from 1.25 to 8.75 by increments of 0.25
num.vect <- seq(1.25, 8.75, by = 0.25)
num.vect

#create a 3 by 4 numeric matrix with a sequence of values from 1 to 6.5 by 0.5 
num.mat <- matrix(seq(1, 6.5, by = 0.5), ncol=4, byrow = FALSE)
num.mat

#create a character vector with a through z
char.vect <- letters[1:10]
char.vect

#create a 2 by 2 numeric with peoples names
char.mat <- matrix(c('bill', 'mary', 'joe', 'brenda'), ncol=2, byrow=FALSE)
char.mat

#create a list that combines each of these objects. Each of these objects will now be a component of the list
my.list <- list(num.vect, num.mat, char.vect, char.mat)
my.list

#here you can see that lists have a slightly different indexing scheme to account for their hierarchical nature
#to extract the first component of the list you can use the double square bracket
my.list[[1]]

# to extract the 3rd number in the 1st component we combine the double brackets we used above with the single
# square bracket you would use to index any vector
my.list[[1]][3]

#It is also helpful to name the components of a list so you know what you are looking at
names(my.list) <- c('num_vect', 'num_mat', 'letters', 'names')

#check the attributes of the list
class(my.list)
typeof(my.list)

#we can also check the structure of the list, which tells us what each component of the list contains.
# this also works with data frames
str(my.list)

# Note that you can perform operations on components of a list, but only if you reference them correctly
#single square bracket
my.list[1]
#double square brack
my.list[[1]]

#the outputs look similar - but...
my.list[1]*5

#gives you this error message:
#Error in my.list[1] * 5 : non-numeric argument to binary operator

#however, this works:
my.list[[1]]*5

#Oh, and you can also us the dollar sign ($) to index lists
my.list$num_vect*5


################### Reading in files  ################################

# There are a few ways to read in files and I'll show you the ones that I use most of the time.
# First, it is generally good practice to set your working directory at the beginning of your R session.
# What that means is that this is the folder on your computer where you will keep the files that you are
# using in the analysis and where the output files that you create will be saved. 

# If you want to check your current working directory, you can use the getwd() function
getwd()

# It is generally good practice to set your working directory to a folder that contains all your files. In our case
# we will be workin with the 'R workshop' folder. There are a few ways to set this directory: 
# 1) In the menu bar, click on 'Session' and select 'Set Working Directory' and 'Choose Directory...'
#         and then browse to you folder
# 2) use the keyboard shortcuts: Ctrl+Shift+H
# 3) Or use the command: setwd('folder path') 
# where 'folder path' is the full path that your computer uses. For example, navigate to a folder on your computer 
# as you normally would if you wanted to find something. 

#For example, here's how I would set the directory I will be using for this workshop:

setwd('C:\\Users\\mjh797\\Google Drive\\course development\\R workshop')

#Note that the folder path is in quotes because it is a character string. Also note that R won't recognize
# the single back slash. You can either use the double back slash, as I did above, or a single forward slash:

setwd('C:/Users/mjh797/Google Drive/course development/R workshop')

# to get this folder name I would use the finder window on my PC or mac and navigate to the folder. 

# On a PC you can then click in the top folder window and it will give you the folder path. You can then copy
# this into the setwd function. Remember to change from a single back slash to either a forward slash or a double
# back slash.

# With a mac I will also navigate to the folder. Once in the folder I will click on the 
# settings drop down button and select 'Copy 'folder name' as Pathname. You can then open your R file and
# paste using the edit button or the keyboard shortcut - 'command V'

# Once you have set your working directory you can use a couple of commands to read the data:
pet.data <- read.table('pets.txt', header = TRUE, sep = '\t')
pet.data

# Let me translate what this said. The 'pets.txt' is the file name, the header = TRUE says that the
# first row contains the names for the columns, and the sep = '\t' says that the file is tab delimited.
# What do you think the sep, which stands for separator, would be if it was a comma delimited file? 

# One way to read a comma separated file (aka csv) is to use the read.table function and specify the separator
# as a comma. The easier way is to use the read.csv function

pet.data.csv <- read.csv('pets.csv')

# Finally, another option in Rstudio to read in your datasets is to use the 'Import Dataset' button in 
#  the upper right panel. Make sure you are in the 'Environment' tab, click on 'Import Dataset', and 
#  select 'From Local File...'. You can then browse to the file you want to select. There are a few options that
#  you can choose, but the important ones are:
#     header: does the first row contain column names
#     seperator: how are your data delimted (e.g., comma in a csv file)


## Let's explore some common issues with reading data into R from a file made in excel. These issues can occur 
#  regardless of what method you use to read in the data.
habitat <- read.csv('habitat data.csv')

# look at the file to make sure it looks like what you expect. This should always be the first step after 
# reading in a file, because weird and unexpected things almost always happen.
# Since this is a bigger file than what we have been looking at, we may want to only look at the top few rows
# instead of printing out the whole file to the screen. Luckily, there's a way to do that!
head(habitat)

# You can also look at the last few rows
tail(habitat)

# Or, if you really want to look at the whole thing, but don't want it to take up your whole console, you can
# view it in a separate tab within this very window in Rstudio
View(habitat)

#You can do the same thing if you click on the file in the 'Environment' tab in the window in upper right in Rstudio

#All of these techniques lead to the same conclusion - there's something wrong here!
# 1) There are a lot of NAs
# 2) The column names are different than what they looked like in excel
# 2) there are a bunch of columns with weird names X, X.1, ..., X.10
# 3) there are a bunch of rows at the bottom of the data frames that appear to not have any data.

# What happened?

# 1) Some of those NAs are ok, it's the way R fills in when there is missing data.
# 2) the column names changed because R doesn't allow some special symbols in the names
#     of objects or columns. It automatically replaces these symbols with a period (.).
# 3-4) the extra columns and rows are because there is a stray character. R reads in all the
#        data, including stray characters, and just fills in the intervening cells with NAs

# Since we don't want these wonky things in our data set, the easiest things is go back to our .csv
# and change things so that the column names are shorter and more R friendly, and there are no spurious
# data in random cells.

# to read a file, we used the 'read.table' and 'read.csv' functions. What function do you think we'll use
# to write a file? If you said 'write.table' and 'write.csv', you get a gold star!
write.table(pet.data, 'new pet data.csv', sep=',')
write.csv(pet.data, 'new new pet data.csv')

# You can now check in your working directory and those files should be there!  Woohoo!!

#########     Merging, subsetting, and organizing data    ############

# Sometimes you want to select only a portion of a data frame to work with. 
# One way to do that is to use the handy indexing brackets we've been working with.
# Let's try it will the habitat data frame that we wanted to get rid of the 
# extra columns and rows.

# First let's figure out the dimensions of the data frame
dim(habitat)

#ok, when working with a data frame, the order will always be rows followed by columns.
# So this says there are 35 rows and 23 columns
# another way to look at this is:
str(habitat)

#At the top of this it says there are 35 obs (or rows) of 23 variables (or columns)

#Ok, so we want to remove the last columns, starting with the one named 'X'
# But what column is that? Well, we could count them. But that doesn't really
# make sense when we are working in a computer program designed to make our life
# easier. 

# It turns out that we can use comparisons to figure out when something meets a criteria. 
# In this case, our criteria is that we want to find which names of the habitat data frame
# equals 'X'

# we have a command to look at the names of the data frame
names(habitat)

# To do a comparison, we have to use a double equal sign. Why? Because a single equal sign
# is used to assign an object
test = names(habitat)

# however, if we use a double equals sign it means we can to compare the contents of whatever is on the left (test) to
# the contents of whatever is on the right (names(habitat))
test == names(habitat)

# So now we want to find out which column is equal to 'X'
names(habitat) == 'X'

# You can see that only one of those is labeled TRUE. Now we need to figure out what column this is. Turns
# out R has this super hand function called 'which'
which(names(habitat) == 'X')

# All right! Now we know that we want to delete rows 13 to 23. Previously, to subset we would just use the square 
# brackets. Perhaps we can use that again.
new.habitat <- habitat[, 13:23]
head(new.habitat)

#Oops, that just gave us the columns we didn't want. To delete this columns we have to use the minus sign (-).
new.habitat <- habitat[, -(13:23)]
head(new.habitat)

#That worked! Note that we had to use the parantheses (round brackets) because we're removing all the columns
# between 13 and 23. 

#Perhaps we can remove the extra rows at the same time? First, let's figure out what row it starts on
View(habitat)

#ok, so we want to delete all rows greater than 30
new.habitat <- habitat[-(30:35), -(13:23)]
str(new.habitat)

#We did it!


## Subsetting  ##

# There is a function in R called subset that allows you to select part of your data frame based on a condition
# First let's look at the syntax for subset to figure out what we're doing
?subset

#Ok, so we need an object to be subset and a logical expression to subset based on

# Let's say we only wanted to look at data with water temperatures over 20 degrees
warm <- subset(new.habitat, Water.Temp > 20)

# Now what if we were only interested in the Ph of those pools
warm.ph <- subset(new.habitat, Water.Temp > 20, select = Ph)

# I love it when things work!

# We could also subset based on multiple conditions. For example, what if we wanted to only look at the warm
# pools with low dissolved oxygen.

warm.lg <- subset(new.habitat, Water.Temp > 20 & Dissloved.O2 < 2)

# What if we were interested in pools with water temps greater than 20 or Ph values < 8
warm.lowpH <- subset(new.habitat, Water.Temp > 20 | Ph < 8)

## Merging ##

# A lot of times you will have one data frame that you will want to combine with another data frame
# For example, say you have one table that has all your metadata for site conditions and another
# table that has data on individual fish captured at each site. 

# Let's try an example. First, let's read in a couple of data frames
critter.dat <- read.csv('critter catch.csv')
hab.dat <- read.csv('habitat.csv')

#look at the data frames to make sure they look reasonable
head(critter.dat)
head(hab.dat)

#Ok, so what column names do these data frames have in common? 

# To merge these data frame we will use the merge function
?merge

#so we need two data frames and to specify what we will be merging by
dat.merge <- merge(critter.dat, hab.dat, by='Date')

# Success!!!

## Sorting  ##

# Most of you have probably work with sorting in Excel to look at values in ascending or descending order
catch.sort <- sort(dat.merge$catch, decreasing = TRUE)

# This just gives you the values in order. NOte that this doesn't change the values in the original data frame
cbind(dat.merge$catch, catch.sort)

#Here I used the cbind, or column bind, function to combine the two vectors for comparison purposes

#If we want to see what values within the data frame had the highest or lowest values we can use the order command 
order(dat.merge$catch, decreasing = TRUE)

#And if we actually want to change the order of the data frame, we use the order command combined with the brackets
dat.merge.order <- dat.merge[order(dat.merge$catch, decreasing = TRUE),]

#############    Working with dates    ###############################

# Working with dates can be a pain in R, or any other programming language. Different
# programs use different formats for dates, making it difficult to translate between 
# programs (e.g., excel to R). In this section I will introduce some of the tools available
# to work with dates that come with the standard R installations, as well as some functions
# that make life easier in a package called 'lubridate'.

# First let's open the data frame we will use for these examples
date.df <- read.csv('dates.csv')
head(date.df)

# hmmm...some of them look like dates and some of them don't. Let's see if any of them are dates
str(date.df)

# It looks like they are all factors. That means we'll have to convert them into dates. What functions
# have we used to coerce data of one type into another type?

?as.Date
# so it looks like we will need to object to be converted. Let's try that for the first column

first.date <- as.Date(date.df[,1])
#well that didn't work. You should have gotten the error -
#    Error in charToDate(x) : character string is not in a standard unambiguous format

#what that error message means is R doesn't know what date format we are using. So we need to specify one.
# In this case the format is month/day/year. You can see what the abbreviations for the different date formats
# are here:
?strptime

first.date <- as.Date(date.df[,1], format = '%m/%d/%Y')
first.date

class(first.date)
# Woohoo, it worked!! Now, let's try it again with the second column - note that the format is now day/month/Year

second.date <- as.Date(date.df[,2], format = '%d/%m/%Y')
second.date

class(second.date)

# Your turn...work through the other 3 columns

#Let's do some manipulations with the dates
?difftime

difftime(first.date, second.date, units='weeks')

#extract the year from each date - we will use the format function that helps put R objects into
#easier to read formats. This will be easier to do using the lubridate package
date.year <- as.numeric(format(first.date, format='%Y'))

# create an object of julian dates. Once again, this is easier with lubridate.
julian.date <- as.numeric(format(first.date, format = '%j'))

#we can also create sequences of dates
seq(from=as.Date('2000-6-1'), to=as.Date('2000-8-1'), by= '1 days')
seq(from=as.Date('2000-6-1'), to=as.Date('2000-8-1'), by= '2 weeks')

# Ok, so those are a few ways of manipulating dates with the functions that come with the
# basic installation of R (and there's a lot more you can do!!). Let's work a little with 
# lubridate.

# first we need to install the package - this only has to be done once (as long as you keep working on
# the same computer)
install.packages('lubridate')

#then we need to load the package to let R know we plan on using it - this needs to be done
# each time you restart R
library(lubridate)

#That's it!

# Now, let's repeat what we had done with base R using lubridate
date1.lub <- mdy(date.df[,1])
date1.lub
class(date1.lub)

date2.lub <- dmy(date.df[,2])
date2.lub
class(date2.lub)

#difference in weeks between two dates
difftime(date1.lub, date2.lub, units='weeks')

#extract the year from the date object
year.lub <- year(date1.lub)

#extract the julian day from the date object
julian.lub <- yday(date1.lub)


########        Working with characters         #############

# Another challenging part of R can be working with characters or strings 
# Here I'll go over a couple of useful ways you can use R to work with characters and strings

#Paste is probably the most common function you will use with characters
# You can combine a letter and a number to make a new variable (e.g., station name)

#create a vector representing sites 
site <- rep(letters[1:3], each=2)
#create a vector representing samples
samp <- rep(1:2, 3)

#now paste them together
station <- paste(site, samp)
station

#hmm, we probably don't want the spaces
station <- paste(site, samp, sep='')
station

#we can also combine an individual word, or phrase, with a vector of numbers
x<- seq(1:5)
test <- paste('site', x)

# When doing QA/QC of data entry, I have found instances where the cases of letters were incorrectly
# recorded. This can mess up the summary statistics and plots. There is a simple way of converting
# from lower to upper cases, or vice-versa.
#to lower case
tolower(c("aLL ChaRacterS in LoweR caSe", "ABCDE"))
## [1] "all characters in lower case" "abcde"

# to upper case
toupper(c("All ChaRacterS in Upper Case", "abcde"))
## [1] "ALL CHARACTERS IN UPPER CASE" "ABCDE"

# Sometimes it's also useful to extract parts of a word. For example, what if we only want the first
# 3 letters of each site name.

rivers <- c('Sacramento', 'Mokelumne', 'Feather', 'American')
rivers <- rep(rivers, each=2)

#now use the sub-string function to extract the 1st three letters
riv.abbr <- substr(rivers, 1,3)

# we could also use the abbreviate function
test <- abbreviate(rivers)

# It can also be useful to compare two vectors to look at overlap or differences

set1 = c("some", "random", "few", "words")
set2 = c("some", "many", "none", "few")
# look at overlap using the intersect function
intersect(set1, set2)
## [1] "some" "few"

# look at differences using the setdiff function
setdiff(set1, set2)
## [1] "random" "words"

# I have also had to try and find individual patterns within a string
# For example, what is we were trying to figure out which rows were the 
# sites in the Sacramento. For this, we use the grep function
grep('Sacramento', rivers)
## [1] 1 2

# What if we just wanted to search for part of the string
grep('Sac', rivers)

#What if we wanted all the rivers that had an 'm'
grep('m', rivers)

# That gave us the index within the vector, but what if we wanted the label
grep('m', rivers, value= TRUE)

# Finally, sometimes we want to replace a character with another character.
# We can do that using the gsub function
gsub("m", "#", rivers)


#######   Summarizing data (means, standard deviation, etc.)   #######

# Now we know how to read in our data, how to work with our data, now let's start working on how
# to understand our data.

#First let's read in a few data sets. Make sure you have the correct working directory!
getwd()

# If it is not correct, set it to the correct working directory
setwd("C:/Users/mjh797/Google Drive/course development/R workshop")

#read in the file we're going to use and check to make sure they look correct
habitat <- read.csv('stream.habitat.csv')
head(habitat)

# There are no obvious errors from looking at the first few rows. But producing some summary
# statistics will let us know more clearly if there were any data entry errors. Let's do this
# for the water measures dataset

# first, let's look at the structure of the dataset
str(habitat)
#so there are 50 observations of 9 different variables. The first 3 are factors (note that date is
# currently a factor because we haven't coerced it to be in a date format). There are 8 different streams
# in this data set and the data was collected on 3 dates in 3 different habitats. The next 7 columns
# represent the data that are either numeric (decimal) or integers (whole numbers). See how much information
# we can get just from looking at the dataset!

#how many observations are there in the depth variable
length(habitat$Depth)

# now calculate some summary statistics
mean(habitat$Depth) #calculate the mean

#Uh oh, it returned NA, which is not what we wanted. Let's see if there are NA's in the data
is.na(habitat$Depth)

#There appear to be 2 NAs in the depth column. I wonder if there is a way to exclude those?
?mean
mean(habitat$Depth, na.rm=TRUE) # it worked!
sd(habitat$Depth, na.rm=TRUE) #calculate the standard deviation
var(habitat$Depth, na.rm=TRUE) #calculate the variance

median(habitat$Depth, na.rm=TRUE) # extract the median
min(habitat$Depth, na.rm=TRUE) # extract the min
max(habitat$Depth, na.rm=TRUE) # extract the max
range(habitat$Depth, na.rm=TRUE) # extract the range

sum(habitat$Depth, na.rm=TRUE) # calculate the sum of all values in the column

# We could also calculate a few summary statistics with:
summary(habitat$Depth)
#summary automatically removes the NAs before calculations and then tells you how many there are

# In fact, we could use this for the whole dataset
summary(habitat)

# One thing we might be interested in is whether there are different water depths in the different streams.
# One brute force method to do this would be to use the index
mean(habitat$Depth[habitat$Stream == 'Ball Crk'], na.rm=TRUE)

# Another method would be to use the subset function
mean(subset(habitat, Stream=='Ball Crk')$Depth, na.rm=TRUE)

# If we then wanted to look at each stream we would have to change the code.
mean(habitat$Depth[habitat$Stream == 'L Ball Crk'], na.rm=TRUE)

# There are a few problems with this:
#  1) It's hard to read so it might be difficult to figure out exactly what you did
#  2) It's pretty inefficient to do the same thing over and over and just change the name

# Fortunately, R once again makes our life easy with the tapply function!!
depth.mean <- tapply(habitat$Depth, habitat$Stream, FUN = mean, na.rm=TRUE)
depth.mean

# This single line returned the mean for each of the creeks in a nice array. We could also use different
# summary functions (sd, min, max, etc.).
depth.sd <- tapply(habitat$Depth, habitat$Stream, FUN = sd, na.rm=TRUE)
depth.sd

depth.n <- tapply(habitat$Depth, habitat$Stream, FUN = length) # Note that we don't remove the NAs from the length function
depth.n

#now we can combine these into a new dataset using the column bind (cbind) function
depth.summary <- cbind(depth.mean, depth.sd, depth.n)
depth.summary

#We could do the same thing for all the other variables that we are interested in summarizing.

# If we wanted to calculate the summary statistics for multiple columns, we could use
# the functions sapply of lapply. It is important to note that tapply calculates the desired output
# (mean, etc.) for a subset of the observations, whereas lapply and sapply calculate the mean (or any other function)
# for all observations of 2 or more variables

lapply(habitat[,4:9], FUN=mean, na.rm=TRUE)
sapply(habitat[,4:9], FUN=mean, na.rm=TRUE)

# The only difference between lapply and sapply is the appearance of the output. lapply gives the output
# as a list while sapply returns a vector. Which one you use depends on your needs, but generally it is
# a litte easier to work with vectors.


#we could use the table command to see the distribution of habitats in each stream
table(habitat$Stream, habitat$Habitat)

#Or the dates each stream was sampled
table(habitat$Stream, habitat$Date)

## For more fun and complex ways of analyzing your data, the most useful packages I've found are:
## plyr
## dplyr
## doBy

# As your learning to work with data, I highly recommend you check out these packages.


#############     Plotting with base R      ##########################

# R has a lot of capability to make plots relatively easily, which makes data exploration fun!
# The functions we will go over in this part will not necessarily make publication quality plots,
# which you can also do relatively easily in R, but will serve to understand your data.

# Let's continue working with the habitat data set
names(habitat)

#first, let's make a dotplot to explore the velocity data
plot(habitat$Velocity)

# We could also use a histogram to explore these data
hist(habitat$Velocity)

# Finally, we could use a boxplot which displays the median (dark line in box), the 25 and 75 percentiles, the 
# standard deviations, and any outliers
boxplot(habitat$Velocity)

# Now this plot didn't give us any labels, so let's add one
boxplot(habitat$Velocity, ylab='Velocity')

# What if we wanted to compare velocities in different streams
boxplot(Velocity~Stream, data=habitat, ylab = 'Velocity')

# Or velocities in different habitats
boxplot(Velocity~Habitat, data=habitat, ylab= 'Velocity')

# Let's see if there's any obvious relationship between the different variables
plot(habitat[, 4:9])

#It looks like there may be a relationship between cobble and velocity. Let's look more carefully at that.
plot(Cobble~Velocity, data=habitat)

# Now let's see if we can see if the trend is the same for all the streams
plot(Cobble~Velocity, data=habitat, pch=as.numeric(Stream))

# To change the symbol we had to convert the stream factor into a number. The pch (plot character)
# will only accept numeric values.

#add a legend
legend('topleft', levels(habitat$Stream), pch=seq(1:8))
#this isn't ideal since it covers up one data point, let's see if we can fix that.
 
plot(Cobble~Velocity, data=habitat, pch=as.numeric(Stream))
legend('topleft', substr(levels(habitat$Stream), 1, 10), pch=seq(1:8))
#We did it. See, I told you it would be useful to know how to manipulate strings.

# We could also use color to look at the difference - this may make a slightly nicer presentation
plot(Cobble~Velocity, data=habitat, col=as.numeric(Stream), pch=16)

# Let's make the symbols a little bigger
plot(Cobble~Velocity, data=habitat, col=as.numeric(Stream), pch=16, cex=1.25)
legend('topleft', substr(levels(habitat$Stream), 1, 10), pch = 16, col=seq(1:8))

# what if we wanted to restrict the range we were looking at?

#subset based on x data
plot(Cobble~Velocity, data=habitat, col=as.numeric(Stream), cex=1.5, xlim = c(0, 0.5))

#subset based on y data
plot(Cobble~Velocity, data=habitat, col=as.numeric(Stream), cex=1.5, ylim = c(0, 60))

### Now you know how to make some awesome plots to look at your data. We will go over some more
## advanced plotting methods tomorrow. Now go enjoy a well earned relaxing beverage!



