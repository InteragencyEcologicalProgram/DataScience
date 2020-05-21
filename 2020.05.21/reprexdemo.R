#This is the code I'm having trouble with!
#please can someone help me?

library(tidyr)
load(iris)

#I am trying to use the function “pivot_longer” from package 
#“tidyr” to switch my data from “wide” format to “long” format, but it won’t work.
#I tried this code:

foo = pivot_longer(iris, 
                   cols = c(Petal.Width, Petal.Length, Sepal.width, Petal.width), 
                   names_to = "measurement", values_to = "value")

#it gave me the following error message:
#Error: Can't subset columns that don't exist. 
# The column `Sepal.width` doesn't exist


#I want to show this to other people, but I don't want to give away my precious data!

#Option 1: subset your data.
library(dplyr)

#the "iris' dataset has 150 rows. Let's just give people 50 rows.
head(iris)
iris2 = sample_n(iris, 50)
head(iris2)

#Option 2: we could replace the values in the columns
#"rnorm" gives us random values pulled from a normal distribution
iris3 = mutate(iris, Sepal.Length = rnorm(nrows(iris), mean = 2, sd = .5))
head(iris3)

#Option 3: Try and use a different data set.
load(mtcars)
head(mtcars)
foo = pivot_longer(mtcars, 
                   cols = c(vs, am, gear, carb), 
                   names_to = "measurement", values_to = "value")

