#REally really messy count data: Too many options.

#load some packages

library(tidyverse)
library(pscl)
library(MASS)
library(visreg)

#The data set: Catch of Delta Smelt in the Fall Midwater Trawl from Montezuma Slough

#FMWT data is avaialable here: ftp://ftp.wildlife.ca.gov/TownetFallMidwaterTrawl/FMWT%20Data/
#I downloaded the data set and subset just the data on Delta Smelt. 

#load the file:
FMWT_DS = read.csv("FMWT_DeltaSmelt.csv")[,-1]

#switch Station to a factor and Date to a date
FMWT_DS$Station = as.factor(FMWT_DS$Station)
FMWT_DS$Date = as.Date(FMWT_DS$Date)

#subset just the stations in Montezuma Slough prior to 2011 

FMWT_DS2 = filter(FMWT_DS, (Station == "608" | Station == "605" | Station == "606") & Year <= 2011)

#if I wanted to investigate factors, such as salinity and temperature, that affect
#smelt catch, I might try a linear model. However, linear models have assumptions of normality and
#homogeneity of variance. 

#Just see what a linear model looks like
dslm = lm(catch~ Station + Secchi + TopEC, data = FMWT_DS2) 
summary(dslm)
#woohoo! Lots of siginificant pvalues! But we are violating all sorts of assumptions

#check out the diagnostic plots
#if you need a review of what these plots mean: https://data.library.virginia.edu/diagnostic-plots/
plot(dslm)

#look at the histogram
ggplot(FMWT_DS2, aes(x=catch)) + geom_histogram()

#look at a Shapiro-wilk normality test
shapiro.test(FMWT_DS2$catch)
#Definitely not normal!

#traditional statistics would now have you try a log-transformation on the data
#except we need to at "1" to each value because of all the zeros.

FMWT_DS2$logcatch = log(FMWT_DS2$catch +1)

shapiro.test(FMWT_DS2$logcatch)
#but we are still not normal.

#Furthermore, a lot of stastitions say you shouldn't transform count data.
#instead we can use generalized linear models with different error distributions.
#https://www.r-bloggers.com/do-not-log-transform-count-data-bitches/
#https://besjournals.onlinelibrary.wiley.com/doi/10.1111/j.2041-210X.2010.00021.x

#But which distribution should we use? Poisson is the usual first choice for count data.

#Poisson distributions

dsglm = glm(catch~ Station + Secchi + TopEC, family = poisson, data = FMWT_DS2) 
summary(dsglm)
#Wow! super significant. but how are we on those diagnostic plots?
plot(dsglm)
#Not good. We might have overdispersion. Poisson models are genrally good at describing the mean,
#but they usually underestimate the variance. 
#To check for that, we look at the difference
#between a posson and a quazipoisson distribution

#Quasipoisson
#A quassipoisson model uses the mean regression function and variance from the Poisson regression,
#but leaves the dispersion parameter unrestricted. (in a Poisson model dispersion = 1)
# Do not write in your report or paper that you used a quasi-Poisson distribution. Just say that
#you did a Poisson GLM, detected overdispersion, and corrected the standard errors
#using a quasi-GLM model where the variance is given by φ × μ, where μ is the
#mean and φ the dispersion parameter. Zuur et al. 2009


dsglm2 = glm(catch~ Station + Secchi + TopEC, family = quasipoisson, data = FMWT_DS2) 
summary(dsglm2)$dispersion # dispersion coefficient

#test for differences between the two model specifications
pchisq(summary(dsglm2)$dispersion * dsglm$df.residual, dsglm$df.residual, lower = F)
#it's very overdisperssed

#Negative binomial distributions account for overdisperssion, but variance is a quadratic
#function of the mean rather than a linear function of the mean (as in quazipoisson).
#There is lots of discussion as to which is better (e.g. Ver Hoef and Bveng 2007)

dsnb2 = glm.nb(catch~ Station + Secchi + TopEC,  data = FMWT_DS2) 
summary(dsnb2)
plot(dsnb2)
#but even this doesn't look great. The problem is, we have too many zeros, which isn't dealt with well
#in either quazipoisson or negative binomial models. 

#To deal with excess zeros, we can use a zero-inflated model, or a zero-augmented model (hurdle model)
#to figure out which to use, we need to understand the potential sources of zeros (modefied from Zuur et al 2009):
#1. Structural zeros. Delta smelt are not caught because the habitat is not suitable (too hot, to clear, too salty).
#2. Design error. Delta smelt are not caught because the midwater trawl doesn't sample the top part of hte water
#well and smelt hang out near the surface.
#3. Observer error. Delta smelt were caught, but Rosie thought they were Wakasagi.
#4. Smelt error. The habitat was suitable but the smelt weren't using it.

#Structural zeros and "smelt error" are considered "true zeros", 
#whereas design error and observer error are "false zeros"

#Zero-augmented models (two-part models or hurdle models) do not differentiate between types of zeros.
#zero-inflated models (mixture models) do differentiate so you can model zeros caused by the habitat
#being bad seperately from the zeros caused by observer or design error.

#the overdisperssion in our Poisson model may have just been caused by the extra zeros,
#so a zero inflated Poisson might work
dszip = zeroinfl(catch~ Station + TopEC + Secchi, dist = "poisson", data = FMWT_DS2)
summary(dszip)
#that was a wierd error. Yuck.

#If there was also overdisspersion in the counts, then a zero inflated negative binomial will
#work better.
dsznb = zeroinfl(catch~ Station + TopEC + Secchi, dist = "negbin", data = FMWT_DS2)
summary(dsznb)

#Dang. More errors.
#I get a warning "In sqrt(diag(object$vcov)) : NaNs produced" 
#this is usually because some of the covariates need to be standardized.
#the function "scale" will subtract the mean from the column and divide by its standard
#deviation to put all the variables on the same scale.
FMWT_DS2$TopEC2 = scale(FMWT_DS2$TopEC)
FMWT_DS2$Secchi2 = scale(FMWT_DS2$Secchi)

#try it again with the scaled covariates
dszip = zeroinfl(catch~ Station + TopEC2 + Secchi2, dist = "poisson", data = FMWT_DS2)
summary(dszip)

#If there was also overdisspersion in the counts, then a zero inflated negative binomial will
#work better.
dsznb = zeroinfl(catch~ Station + TopEC2 + Secchi2, dist = "negbin", data = FMWT_DS2)
summary(dsznb)

#much better!

#compare the zeroinflated models with a likelihood ratio test to see if we've delt with the overdispersion
library(lmtest)
lrtest(dszip, dsznb)
#it's telling me I'm still overdisperssed, I should use the negative binomial version

#look at the covariates again
summary(dsznb)

#look at the partial residual plots (also known as conditional plots)
visreg(dsznb)

#Model validation is based on plotting Pearson residuals against the fitted values
#and the Pearson residuals against each explanitory variable. You should not see any pattern (Zuur et al. 2009)

tests = data.frame(DSresid = residuals(dsznb, type = "pearson"), 
                   DSfit = dsznb$fitted.values,
                   sec = dsznb$model["Secchi2"],
                   EC = dsznb$model["TopEC2"])


ggplot(data = tests, aes(x=DSresid, y = DSfit)) + geom_point()
ggplot(data = tests, aes(x=DSresid, y = Secchi2)) + geom_point()
ggplot(data = tests, aes(x=DSresid, y = TopEC2)) + geom_point()
#looks OK!

#you can now use AIC model selection, or whatever method you prefer, to decide which covariates are most important.
