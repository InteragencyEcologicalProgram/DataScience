# For loops redux
for(i in 1:3){
    cat("outer loop ", i, "\n")
    for (j in 1:5) {
        cat("inner loop ", j, "\n")
    }
}
# Here is another example.
mns <- c()
for (i in 10:30) {
    sims <- c()
    for (j in 1:100) {
        x <- sum(rnorm(i, 80, 10))
        sims <- c(sims, x)
    }
    mns <- c(mns, mean(sims))
}
mns
# Functions
sims <- function(i) {
    x <- c()
    for (j in 1:100) {
        x <- sum(rnorm(i, 80, 10))
        sims <- c(sims, x)
    }
    return(x)
}

mns <- c()
for (i in 10:30) {
    mns <- c(mns, mean(sims(i)))
}
mns

# Some basic simulation
n <- 10
depth <- runif(n, 0.22, 2.2)
velocity <- runif(n, 0.03, 68)
B0 <- 0.237  # THESE VALUES FROM A BIT OF PILOT DATA
B1 <- -0.0063  # THESE VALUES FROM A BIT OF PILOT DATA
B2 <- 0.125856  # THESE VALUES FROM A BIT OF PILOT DATA
sim_density <- B0 + B1 * depth + B2 * velocity + rnorm(n, mean = 0, sd = 1)

# Another way to add error 
pred <- B0 + B1 * depth + B2 * velocity + rnorm(n, mean = 0, sd = 1)
sim_density <- rnorm(n, mean = pred, sd = 1)
Lets look at what we created!
par(mfrow = c(2, 1), mar = c(4, 3, 0, 0), oma = c(1, 2, 1, 1))
plot(depth, sim_density, ylab = "", las = 1, xlab = "Depth (m)")
plot(velocity, sim_density, ylab = "", las = 1, xlab = "Velocity (m/s)")
mylab <- expression(paste("Density (lamprey meter "^-2, ")", sep = ""))
mtext(side = 2, mylab, outer = TRUE)


sim_dat <- data.frame(depth = depth, velocity = velocity, density = sim_density)
fit <- lm(density ~ depth + velocity, sim_dat)
summary(fit)
We can extract the standard errors and calculate the coefficient of variation as you learned in week 8.
stderrs <- sqrt(diag(vcov(fit)))
ests <- coef(fit)
abs(stderrs/ests) * 100

# Lets see what happens if we up n to 100
n <- 100
depth <- runif(n, 0.22, 2.2)
velocity <- runif(n, 0.03, 68)
sim_density <- B0 + B1 * depth + B2 * velocity + rnorm(n, mean = 0, sd = 1)
sim_dat <- data.frame(depth = depth, velocity = velocity, density = sim_density)
fit <- lm(density ~ depth + velocity, sim_dat)
summary(fit)
stderrs <- sqrt(diag(vcov(fit)))
ests <- coef(fit)
abs(stderrs/ests) * 100

# Lets see what happens if we up n to 200
n <- 200
depth <- runif(n, 0.22, 2.2)
velocity <- runif(n, 0.03, 68)
sim_density <- B0 + B1 * depth + B2 * velocity + rnorm(n, mean = 0, sd = 1)
sim_dat <- data.frame(depth = depth, velocity = velocity, density = sim_density)
fit <- lm(density ~ depth + velocity, sim_dat)
summary(fit)
stderrs <- sqrt(diag(vcov(fit))) 
ests <- coef(fit) abs(stderrs/ests) * 100

# a function that can be used in a bigger simulation.
sim <- function(n = 20) {
    depth <- runif(n, 0.22, 2.2)
    velocity <- runif(n, 0.03, 68)
    B0 <- 0.237
    B1 <- -0.0063
    B2 <- 0.125856
    sim_density <- B0 + B1 * depth + B2 * velocity + rnorm(n, mean = 0, sd = 1)
    fit <- lm(sim_density ~ depth + velocity)
    betas <- coef(fit)
    return(betas)
}
sim(n = 30)

# using a function in a simulation
sampleSize <- seq(10, 100, by = 10)
output <- data.frame()
for (i in 1:length(sampleSize)) {
    for (j in 1:100) {
        betas <- sim(n = sampleSize[i])
        output_app <- data.frame(n = sampleSize[i], B0 = betas[1], B1 = betas[2], 
            B2 = betas[3])
        output <- rbind(output, output_app)
    }
}
head(output)

# You remember how to plot right?  
par(mfrow = c(3, 1), mar = c(3, 1, 0, 1), oma = c(1, 3, 1, 1))
boxplot(B0 ~ n, output)
abline(h = 0.237)
boxplot(B1 ~ n, output)
abline(h = -0.0063)
boxplot(B2 ~ n, output)
abline(h = 0.125856)
mtext(side = 2, "Estimate", outer = TRUE, line = 1.5)



# A Poisson example
#sample size
n <- 1000
#regression coefficients
beta0 <- 1
beta1 <- 0.2
beta2 <- -0.5
#generate covariate values
x <- runif(n=n, min=0, max=1.5)
x2<- runif(n=n, min=-3,max=3)
#compute mu's
mu <- exp(beta0 + beta1 * x + beta2*x2)
#generate Y-values
y <- rpois(n=n, lambda=mu)
#data set
data <- data.frame(y=y, x=x)
head(data)
glm(y~x + x2,data, family="poisson")

# An exponential population model
N0 <- 2
r <- 0.1
nyears <- 10
N <- rep(NA, nyears + 1)
N <- N0
for (i in 1:nyears) {
    N[i + 1] <- r * N[i] + N[i]
}
N

# plot the simulation output
plot(c(0:10), N, ylab = "Population size (plants/hectare)", xlab = "Year", las = 1, 
    type = "b")


# different ways to approach this problem in R,
N <- rep(NA, nyears + 1)
N[1] <- N0
for (i in 2:(nyears + 1)) {
    N[i] <- r * N[i - 1] + N[i - 1]
}
N

# the collection operator 
N <- N0
for (i in 1:nyears) {
    Nt1 <- r * N[i] + N[i]
    N <- c(N, Nt1)
}
N

# Logistic model
N0 <- 2
r <- 0.1
nyears <- 50
K <- 49
N <- rep(NA, nyears + 1)
N[1] <- N0
for (i in 1:nyears) {
    N[i + 1] <- r * N[i] * ((K - N[i])/K) + N[i]
}
N

# Breaking the for loop

N0 <- 2
r <- 0.1
nyears <- 50
K <- 49
N <- rep(NA, nyears + 1)
N[1] <- N0
for (i in 1:nyears) {
    N[i + 1] <- r * N[i] * ((K - N[i])/K) + N[i]
    if (N[i + 1] >= 30) 
        break
}
N

length(na.omit(N))


# Age/stage structured population model
# AN AGE OR STAGE MATRIX OF FECUNDITIES AND SURVIVALS
A<- matrix(c(0,2,3,4, 0.6,0,0,0, 0,0.3,0,0, 0,0,0.24,0),nrow=4, byrow=T)

# A MATRIX TO HOLD THE FORECASTS OF THE POP
population<- matrix(0, nrow=4, ncol=10)

# SEED THE POPULATION
population[,1]<- c(400, 200, 100, 40)

# FORECAST THE STRUCTURED POPULATION
for(i in 2:10){
    population[,i]<- A%*%population[,i-1]
    }

# CALCULATE THE TOTAL POPULATION AT EACH TIME STEP
totalPopulation<- apply(population, 2, sum)
plot(totalPopulation)

# plot the age structured population
plot(c(1:10),population[1,],ylim=c(0,8000),type='l')
points(c(1:10),population[2,],type='l')
points(c(1:10),population[3,],type='l')
points(c(1:10),population[4,],type='l')

# LAMBDA FOR MATRIX A
lambda<-as.numeric(eigen(A)$values[1])
w<-as.numeric(eigen(A)$vectors[,1])
w<-w/sum(w) # STABLE AGE DISTRIBUTION FOR MATRIX A
w
v<-as.numeric(eigen(t(A))$vectors[,1])
v<-v/v[1]; # REPRODUCTIVE VALUE FOR MATRIX A
v
s<-outer(v,w)/sum(v*w) # SENSITIVITY FOR MATRIX A
s
e<-(s*A)/lambda # ELASTICITIES FOR MATRIX A
e