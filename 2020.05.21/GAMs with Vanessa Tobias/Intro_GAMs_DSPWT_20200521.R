####################################################
##           Introduction to GAMs                 ##
## for the Data Science PWT meeting 2020-May-21   ##                          ##
## Author: Vanessa Tobias <vanessa_tobias@fws.gov ##
## License: CC-0                                  ##
####################################################

# The purpose of this code is to give a brief overview
# of the mgcv::gam function and a few of the the things 
# you can use it for. 
# It's a very flexible package so there is
# a lot more that you can do. Hopefully this gives you
# some vocabulary that will help you look up more information. 
# Also look at the presentation that accompanies this code
# for more explanation and resources.

#### Load Libraries ####
library(lubridate)
library(mgcv)
library(tidyverse)

#### Load Data ####
# Dayflow data can be downloaded from
#     https://data.ca.gov/dataset/dayflow
# Here we're using data I had on hand. It has years 1978:2018.

wy <- read.csv("Dayflow_data.csv", 
               stringsAsFactors = FALSE, 
               header = TRUE)
# look at what's in the dataset:
str(wy)

#### Set up the data how we need it ####

# Create a factor for water year type
wy$WYearType.f <- factor(wy$WYearType, levels = c("C", "D", "BN", "AN", "W"))

# Format dates
wy$Date <- mdy(wy$Date)

# Create day of year "doy" (calendar year)
wy$doy <- yday(wy$Date)

# Create a day of water year variable "dowy"
# -- Water years run from Oct. 1 to Sept. 30
# -- Calendar year might be problematic because the ends of 
#    the years might not match up. Better to use water year, where
#    we can expect flow to be low at both ends.
yday(mdy("9/30/1955")) # end of the water year
#[1] 273
wy$dowy <- wy$doy - 273
wy$dowy[which(wy$dowy < 1)] <- wy$doy[which(wy$dowy < 1)] + 92
wy$DeltaOut[which(wy$DeltaOut < 0)] <- NA

# Create a month of water year variable "mowy"
wy$mowy <- wy$Month - 9
wy$mowy[which(wy$mowy < 1)] <- wy$mowy[which(wy$mowy < 1)] + 12

#### Look at Data ####
# Plot Delta Outflow (DeltaOut) by Day of Water Year (dowy)
plot(wy$dowy, wy$DeltaOut,
     pch = ".")

#### Fit a GLM for reference ####
glm1 <- glm(DeltaOut ~ dowy,
            data = wy)
summary(glm1)
# Intercept
# Slope
# Deviance

#### Fit a simple GAM ####
# This is a model of how mean Delta Outflow (DetlaOut) changes 
#   over the course of a water year. It's using day of water year
#   (dowy) as a predictor variable.
gam1 <- gam(DeltaOut ~ s(dowy), 
            data = wy)
# default basis is thin plate regression spline (bs = "tp")
# see ?smooth.terms for more info

# Just like a GLM, you can view a summary of the model
summary(gam1)
# Parametric Intercept
# Smooth term
# Deviance explained

# There is another summary that you need to look at as well:
gam.check(gam1)
# Diagnostic Plots
# Console: 
# - check for convergence
# - check that k isn't too low

# Make predictions & plot results
gam1.pred <- predict(gam1, 
                     newdata = data.frame(dowy = 1:365),
                     type = "response")
plot(1:365,
     gam1.pred,
     type = "l", 
     lwd = 2)

# Look at the ends of the line 
# We might want to make sure that Dec. 31 matches up with Jan. 1.

#### Change the basis to a circular spline ####
gam2 <- gam(DeltaOut ~ s(dowy, bs = "cc"), # circular spline
            data = wy)
summary(gam2)
gam.check(gam2)
gam2.pred <- predict(gam2, 
                     newdata = data.frame(dowy = 1:365),
                     type = "response")
plot(1:365,
     gam2.pred,
     type = "l", lwd = 2)

#### Different lines for different water years? ####
gam3 <- gam(DeltaOut ~ s(dowy, bs = "cc", by = WYearType.f), 
            data = wy)
summary(gam3)
gam.check(gam3)
gam3.pred <- predict(gam3, 
                     newdata = data.frame(dowy = 1:365,
                                          WYearType.f = rep("W", 365)),
                     type = "response",
                     se.fit = TRUE)
names(gam3.pred)
plot(1:365,
     gam3.pred$fit,
     type = "l", lwd = 2)

#### Plot  all WY Types ####
# Make predictions from the model
gam3.pred <- predict(gam3, 
                     newdata = data.frame(dowy = rep(1:365, 5),
                                          WYearType.f = levels(wy$WYearType.f)),
                     type = "response",
                     se.fit = TRUE)
# Rearrange into a data.frame & add explanatory variables
gam3.pred <- data.frame(dowy = rep(1:365, 5),
                        WYearType.f = levels(wy$WYearType.f),
                        fit = gam3.pred$fit,
                        se.fit = gam3.pred$se.fit)
# Set the levels for water year types in order
gam3.pred$WYearType.f <- factor(gam3.pred$WYearType.f, 
                                levels = c("C", "D", "BN", "AN", "W"))
# Plot lines for each water year type
gam3.pred %>%
  ggplot() +
  geom_line(aes(dowy, fit, 
                color = WYearType.f),
            size = 1.5) +
  labs(x = "Day of Water Year",
       y = "Delta Outflow (cfs)") +
  theme_classic()
# Obviously this needs to be refined!
# Outflow probably isn't really negative in wet years!
# Changes to consider: 
# - type of basis 
# - k-value (k might be too high here)
# - "family" for the model (Gaussian allows negatives)
# - "link" for the model

#### What about interactions? ####
plot(wy$mowy, wy$TotInflow, pch = ".")
plot(wy$Year, wy$TotInflow, pch = ".")
# use "te" for interactions when you don't 
# explicitly include main effects in the model
gam4 <- gam(TotInflow ~ te(mowy, Year),
            data = wy)
# --- OR ---
# use "ti" instead of "te"] when you have main effects in the model
gam4 <- gam(TotInflow ~ 
              s(mowy, bs = "cc") +
              s(Year, bs = "tp") +
              ti(mowy, Year),
            data = wy)
summary(gam4)
gam.check(gam4)
# probably want to increase k for Year