

# R version 3.0.1
# Rstudio version 0.97.551

setwd("C:/Users/Jim/Desktop") #set working directory

fish<- read.csv("https://sites.google.com/site/rforfishandwildlifegrads/home/week-8/Fish%20data.csv?attredirects=0&d=1")

head(fish)
summary(fish)

fish$density.no.m2 <- with(fish,No.caught/Sample.area.m2)

lm(density.no.m2~ Depth.m + Velocity.ms,data = fish)

mod.out = lm(density.no.m2~ Depth.m + Velocity.ms,data = fish)

summary(mod.out)

summary(mod.out = lm(density.no.m2~ Depth.m + Velocity.ms,data = fish))

summary(mod.out <- lm(density.no.m2~ Depth.m + Velocity.ms,data = fish))

class(mod.out)

str(mod.out)

mod.out$coefficients

mod.out$coef

coef(mod.out)

sqrt(diag(vcov(mod.out)))


confint(mod.out,level = 0.90)

parms<-as.data.frame(cbind(mod.out$coef,sqrt(diag(vcov(mod.out)))))
colnames(parms)<- c("Estimate","Std.Error")
parms$Lower = parms$Estimate - 1.64*parms$Std.Error
parms$Upper = parms$Estimate + 1.64*parms$Std.Error
parms

mod.out$residuals

mod.out$resid


mod.out$fitted.values
mod.out$fitted

plot(mod.out$resid~mod.out$fitted)

plot(mod.out$resid~fish$Depth.m)

plot(mod.out$resid~fish$Velocity.ms)


summary(mod.out <- lm(density.no.m2~ Depth.m+ I(Depth.m^2) + Velocity.ms,data = fish))

plot(mod.out$resid~mod.out$fitted)

plot(mod.out$resid~fish$Depth.m)

qqnorm(mod.out$resid)


summary(mod.out <- lm(density.no.m2~ Depth.m*Velocity.ms,data = fish))

summary(mod.out <- lm(density.no.m2~ Depth.m + Velocity.ms + Depth.m:Velocity.ms,data = fish))

summary(mod.out <- lm(density.no.m2~ Depth.m+ I(Depth.m^2) + Velocity.ms + Season,data = fish))

fish$Fall = ifelse(fish$Season == "fall",1,0)

summary(mod.out <- lm(density.no.m2~ Depth.m + I(Depth.m^2) + Velocity.ms + Fall,data = fish))


## now we try a different function glm that fits generalized linear models
summary(new.out <- glm(density.no.m2~ Depth.m + I(Depth.m^2) + Velocity.ms + Fall,data = fish))

## lets see what's in the output list
str(new.out)

## we now have AIC in the output from glm
## because we have a small sample size we need to use small sample AIC: AICc
## first save AIC
aic = new.out$aic
## AICc requires number of observations in data we use length to get it
n = length(new.out$fitted)
## we also need the number of parameters in the model
## this is terned the rank we add 1 for the residual error
K = new.out$rank + 1

## here's how we calculate AICc
AIC.c <- aic + (2*K*(K+1))/(n-K-1)

## lets put these in a vector
mod.sel = c(n,K,AIC.c)

#for grins lets fit another model without fall in it
new2.out <- glm(density.no.m2~ Depth.m + I(Depth.m^2) + Velocity.ms,data = fish)

## lets calculate AICc for this model too
aic = new2.out$aic
n = length(new2.out$fitted)
K = new2.out$rank + 1

AIC.c2 <- aic + (2*K*(K+1))/(n-K-1)

## combine the AICc statiatics for both models
rbind(mod.sel,c(n,K,AIC.c2))


## glm function fits other types of glms, i.e., linear models with other types of distributions
## regular linear regression assumes a normal distribution another name for it is gaussian
## heres how we would specify the type of distriibution, gaussian is the default
summary(glm(density.no.m2~ Depth.m + I(Depth.m^2) + Velocity.ms,data = fish, family = gaussian))


## if we look back at the data we see that the original
## response was fish catch, which is an integer
names(fish)

## we can model count (integer) data using a poisson statistical distribution
## we specify this in glm using family = poisson
summary(pois.reg<-glm(No.caught ~ Depth.m + I(Depth.m^2) + Velocity.ms + Sample.area.m2,data = fish, family = poisson))

## what's in the output, nothing new
str(pois.reg)

## we can also examine the residuals just like normal linear regression
## here we use a normal quantile quantile plot. if we meet model assumptions
## it should liik closr to a straight line
qqnorm(pois.reg$resid)

## we can find out what other types of models glm fits using help()
help(glm)


trout<-read.csv("https://sites.google.com/site/rforfishandwildlifegrads/home/week-8/Westslope.csv?attredirects=0&d=1")

head(trout)

summary(logist.reg<-glm(PRESENCE ~ SOIL_PROD + GRADIENT + WIDTH,data = trout, family = binomial))

str(logist.reg)

plot(logist.reg$resid~trout$WSHD)
boxplot(logist.reg$resid~trout$WSHD)



require(lme4)


summary(H.logit <-glmer(PRESENCE ~ SOIL_PROD + GRADIENT + WIDTH + (1|WSHD),data = trout, family = binomial))

str(H.logit)


fitted(H.logit)
resid(H.logit)

boxplot(resid(H.logit)~trout$WSHD)

qqnorm(resid(H.logit))

fixef(H.logit)
sqrt(diag(vcov(H.logit)))

parms<-cbind(fixef(H.logit),sqrt(diag(vcov(H.logit))))
colnames(parms)<- c("Estimate","Std. Error")
parms

