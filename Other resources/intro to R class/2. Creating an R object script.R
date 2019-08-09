
# using the = operator
Z= 10
# or using the assignment “<-“ operator
Z <- 10

# create vector
jims.vect <- c(1,2,3,4,5)
# print out vector
jims.vect

# divide all the values in the vector by 10
new.vect <- jims.vect/10
# print out vector
new.vect

# print out 4th element
new.vect[4]

## assign 4th element to another object, fourth
fourth = new.vect[4]

# print elements 3, 4, and 5 in new.vect
new.vect[3:5]

## create vector
biggy = c(10:20)
#print out vector
biggy

# create a vector with a sequence of values from 1.25 to 8.75 by increments of 0.25
wow <- seq(1.25, 8.75, by = 0.25)

# create a vector with a sequence of 13 evenly spaced values between 9 and 14
double.wow <- seq(9, 14, length = 13)

# create a vector of 13 elements with the same value 41
double.dog.wow <- rep(41,13)

# create a vector consisting of two sequences of 1,2,3,4
triple.dog.wow <- rep(1:4, 2)

# create a vector with a sequence of values from 1 to 10 by increments of 0.5
nuts <- seq(1,10, by = 0.5)

# select the odd numbered elements of nuts and put them into a vector wing.nuts
wing.nuts = nuts[c(1,3,4,5,7,9,11,13,15,17,19)]

# select the odd numbered elements of nuts using seq and put them into a vector wing.nuts
wing.nuts = nuts[seq(1,19,2)]

### create the vector the hard way
vect = c(1,2,3,4,5,6,7,8,9,10,11,12)

### create the vector the easy way
vect = c(1:12) 

### create the vector the easy way
vect = c(1:12)
## create the 4 by 3 matrix using the values in vect
jims.matrix = matrix(vect, nrow = 4)
## create the 4 by 3 matrix using the values in vect
jims.matrix = matrix(vect, ncol = 3)

## create the 4 by 3 matrix using the values in vect
jims.matrix = matrix(vect, ncol = 3, byrow = TRUE)
## print out the matrix
jims.matrix

### print out value in row 2, column 3 in jims.matrix
jims.matrix[2,3]

## print out the values in rows 2 and 3 in the first column
jims.matrix[2:3,1]

## print out the values in rows 1 and 3 in the second column
jims.matrix[c(1,3),2]

## print out all the rows for columns 1 and 3, notice blank for row
jims.matrix[,c(1,3)]
## print out all the columns for row 2, notice blank for column
jims.matrix[2,]

## change the value in row 2, column 1 to -99
jims.matrix[2,1] <- -99
## print out matrix
jims.matrix

## change the values in rows 1 and 4, column 3 to missing, remember NA is missing
jims.matrix[c(1,4),3] <- NA
## print out matrix
jims.matrix

## change the values in row 4, column 2 to the sum of values in row 3, columns 1 and 2
jims.matrix[4,2] <- jims.matrix[3,1] + jims.matrix[3,2]
## print out matrix
jims.matrix

## create species assign “dog”
species = ‘dog’
#print out
species

## create species.vect and assign pet names
species.vect = c("dog","cat","hamster")
#print out
species.vect

# create vector alphabet the hard way
alphabet <- c("a","b","c","d","e","f","g")
#print it out
alphabet

# create vector alphabet the easy way
alphabet <- letters[1:10]
#print it out
alphabet

## create pet.vect and assign pet names
pet.vect = c("dog","cat","hamster","goldfish","mouse","bird")
## create a matrix
pet.matrix = matrix(pet.vect, ncol = 3, byrow = TRUE)
## print it out
pet.matrix

## print out the values in row 1 column 1 and 3
pet.matrix[1,c(1,3)]

## print out all the rows for columns 1
pet.matrix[,1]

# the hard way
trial<- c("a","b","c","d",1,2,3,4,5,6,7,8)
#print it out
trial

#easier way
trial<- c(letters[1:4],1:8)
#print it out
trial

## create mixed up matrix
trial.n.error <-matrix(trial,ncol = 3, byrow = FALSE)
# print it out
trial.n.error

## add columns 2 and 3 on trial.n.error matrix
trial.n.error[,2] + trial.n.error[,3]


### what is this
typeof(trial.n.error)

##we can do the same for individual columns or rows
typeof(trial.n.error[,2])

## what class of object is trial.n.error
class(trial.n.error)


## is trial.n.error a numeric matrix
is.numeric(trial.n.error)

## is trial.n.error a character matrix
is.character(trial.n.error)

# create new object
fix<- trial.n.error[,2:3]

# what is this type of object
class(fix)

# is fix a matrix, notice another is function-- of course!
is.matrix(fix)

## what are the type of variables in fix
typeof(fix)

## what are the attributes of fix, yes another function
attributes(fix)

# coerce fix to become numeric
fixed <- as.numeric(fix)
#print it out
fixed

# what is this type of object-- numeric
class(fixed)

# is fixed a matrix, -- oh no!
is.matrix(fixed)

## what are the type of variables in fixed-- yes numeric!
is.numeric(fixed)

fixed <- as.numeric(fix)
#print it out
fixed <- matrix(fixed,ncol = 2, byrow = FALSE)
fixed

# what is this type of object-- matrix
class(fixed)

#add column 1 and 2 of fixed
fixed[,1] + fixed[,2]

#create a third column in fixed by adding column 1 and 2 of fixed
new.val <- fixed[,1] + fixed[,2]

#print it out
new.val


# create vector curious by coercing trial.n.error
curious<-as.numeric(trial.n.error)
## print it out
curious


## are there missing values in curious
is.na(curious)

#replace zero elements in curious with -666
curious[curious== 0] <- -666
#print it out
curious

## create numeric vector num.vect with values 1:15
num.vect = c(1:15)
## print it out
num.vect

# create character vector char.vect by coercing num.vect
char.vect= as.character(num.vect)
## print it out
char.vect


## print out matrix as a reminder
trial.n.error
#create my.dater data frame by coercing trial.n.error
my.dater<- as.data.frame(trial.n.error)
# print it out
my.dater

#what classs of object
class(my.dater)

# is my.dater a data frame-- yes!
is.data.frame(my.dater)

# is my.dater a matrix -- no!
is.matrix(my.dater)


#change column names in my.dater to pixie, dixie, and bud
colnames(my.dater) = c("pixie", "dixie", "bud")
#print it out
my.dater


#print out the second column dixie in my.data
my.dater$dixie

#we can also refer to individual columns in a data frame using brackets
#print out the second column dixie in my.data
my.dater[,2]


#try to add dixie and bud columns in my.dater
my.dater$dixie + my.dater$bud


# whatclass is dixie
class(my.dater$dixie)

#is dixie numeric- no!
is.numeric(my.dater$dixie)

#is dixie a factor- yes!
is.factor(my.dater$dixie)

# first print out bud
my.dater$bud

# try to coerce bud to a numeric value
as.numeric(my.dater$bud)

# print out bud
my.dater$bud

# now coerce as character then to coerce bud to a numeric value
as.numeric(as.character(my.dater$bud))


# now coerce as character then to coerce bud to a numeric value
my.dater$bud <- as.numeric(as.character(my.dater$bud))

# whats the class-- numeric!
class(my.dater$bud)

# is it numeric--yes!
is.numeric(my.dater$bud)

# now coerce as character then to coerce dixie to a numeric value
my.dater$dixie <- as.numeric(as.character(my.dater$dixie))

# whats the class--numeric!
class(my.dater$dixie)

# is it numeric--yes!
is.numeric(my.dater$dixie)

# create a numeric vector with a sequence of values from 1.25 to 8.75 by increments of 0.25 and print
num.vct <- seq(1.25, 8.75, by = 0.25)
num.vct

# create 3 by 4 numeric matrix with a sequence of values from 1 to 6.5 by 0.5 and print
num.mtrx <- matrix(seq(1, 6.5, by = 0.5), ncol = 4, byrow = FALSE)
num.mtrx

# create a character vector with a through z and print
char.vct <- letters[1:10]
char.vct

# create 2 by 2 numeric with peoples names and print
char.mtrx <- matrix(c("bill", "mary","joe","brenda"), ncol = 2, byrow = FALSE)
char.mtrx

## create a list that contains all of these objectives
big.list <- list(num.vct,char.mtrx,num.mtrx,char.vct)

## create a name for each object within the big.list and print
names(big.list) <- c("vect_numbrs", "names", "numb_matrx","letters")
big.list

## what class is this object
class(big.list)

# what type of object
typeof(big.list)

## new very important function for lists
str(big.list)


# to access the ‘names’ object in big.list
big.list$names

# to access the names object the 2nd one in big.list
big.list[2]

# what is the class of object created using $ in big.list
class(big.list$names)

# what is the class of object created using [] syntax in big.list
class(big.list[2])


#multiply the elements in the first object within the list by 5
big.list$vect_numbrs*5

#multiply the elements in the first object within the list by 5
big.list[1]*5










