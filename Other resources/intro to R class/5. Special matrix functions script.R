
### First create a 4 row by 5 column matrix
MTX <- matrix(c(1,1,1,1,1,2,2,2,2,2,3,3,3,3,3,4,4,4,4,4), ncol = 5, byrow = T)

# Print it out
MTX

## Transpose the matrix
# notice rows are columns and columns are rows
t(MTX)

# create a scalar
A <- 0.5

# multiply the matrix by a scalar
MTX*A

# myltiply matrix by another scalar
MTX*10

## create a vector
V = c(10,1,0.1,0.01)

## multiply the matrix by a vector
## WARNING THIS IS NOT MATRIX MULTIPLICATION
MTX*V

# To illustrate matrix multiplication we first create an identity
# matrix. This is a matrix with 1's along a diagonal from the top
# left to bottom right

IDENT = matrix(c(1,0,0,0,1,0,0,0,1), ncol= 3)
IDENT

# Identity matrices are super useful in quantitative applications so
# you've probably used them and didn't know, Ok, next we create
# a vector that has the number of elements equal to the number of
# columns in the matrix

V.new = c(1,2,3)

# matrix multiplication is specified using %*%
# so we have

IDENT %*% V.new

## it should have returned a column vector 1,2,3
# what happens if we just use the regular multiplication operator, *

IDENT * V.new

## check with a little R code
c = matrix(c(2,3,4,5,6,7), ncol = 2)
z = c(10,15)
c %*% z


## check with a little R code
c * z

# per capita fecundity juvenile
Fj = 1.1
# per capita fecundity adult
Fa = 2.1

#survival age 0
S0 = 0.25
#survival juvenile
Sj = 0.35
#survival adult
Sa = 0.75

trans.mtrx = matrix(c(0,Fj,Fa,S0,0,0,0,Sj,Sa), ncol = 3, byrow = T)
#print it out
trans.mtrx

#Number of animals in each age class
N0 = 100
Nj = 50
Na = 200

Nt = c(N0,Nj,Na)

## whats the population estimate for next year?
trans.mtrx %*% Nt

#eigen analysis of population transition matrix
eigen(trans.mtrx)$values[1]

## stable age distribution
eigen(trans.mtrx)$vectors[,1]/sum(eigen(trans.mtrx)$vectors[,1])

# we'll use the identity matrix
IDENT
# grab the diagonal elements
diag(IDENT)