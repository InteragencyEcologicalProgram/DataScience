# Fun with Factors
# M. Johnston
# Office Hours
# Thu Jul 23 08:42:38 2020 ------------------------------


## FACTORS - What are they?
#-------------------------------------------------------#
## You can think of factors as an alternative way to store character data.  Factors  make sense to use when your data has a specific order or hierarchy.

# Create a factor vector:
grades = factor(c("freshman", "sophomore", "junior", "senior"))

grades          # the "levels" aren't in the desired order
levels(grades)  # examine this explicitly with levels() 

str(grades)           # calling str() on factors returns the number of levels
as.integer(grades)    # factors are literally stored as integers under the hood

# it's easiest to create the levels at the same time as you create the factors
grades = factor(grades, levels = c("freshman", "sophomore", "junior", "senior"))

#########################################################
# Factors when reading in data
#########################################################
## The main place that factors trip people up is in the conversion to and from character.  Here we have some data that has an "?" (accidentally) in one of the numeric columns (the "MaxDepth" column):
dl = read.csv("data/dive_log.csv", stringsAsFactors = TRUE, na.strings = "")

str(dl)  #  Note all the factor columns

dl$MaxDepth     # R stored this (and all the other character columns) as factors, since the stringsAsFactors argument of read.csv() was set to TRUE above.

as.numeric(dl$MaxDepth)  #  If we try to convert that factor column directly to numeric, we are given the integer factor levels instead of the values.  This can be very confusing, especially if you weren't aware that the "?" was present in your original data.  You may have just assumed that the MaxDepth column would be numeric.

as.numeric(as.character(dl$MaxDepth))   # In order to get the correct values back, we must first convert from factor to character, before we can then convert to numeric.  We get a warning message about NAs (it converted the factor "?" to the character "?" to NA).

#########################################################
# Factors as efficient storage
#########################################################
## Factors can be an efficient way of storing character data when there are many repeated values that you often want to access as a group.  For example:

groups = c("control", "treatment", "control", "treatment")

groups = factor(groups)

levels(groups)      # recognizes our two groups as levels in our data

## The levels() function can be used to change factor labels as well.  For example, suppose we want to change the "control" label to "placebo."  Since "control" is the first LEVEL of our factor vector, we change the first element of the levels(groups) vector using the bracket function:

levels(groups)[1] <- "placebo"      # this re-assigns the first element of the levels                                     # of our factor vector

groups                              # and it very efficiently relabeled all the
                                    # "control"s to "placebo" in our vector.


#########################################################
# On Your Own
#########################################################
## Using the following vector:
some.colors = c(rep(c("red", "yellow", "blue", "magenta", "green"), 2), "cyan")

# ... convert it a factor vector.  What are its levels?  


#  Change the "blue" label to "turqoise".




#-------------------------------------------------------#
# References: J.W. Braun & D. Murdoch, 2016. A First Course in Statistical Programming With R.  Cambridge University Press.
