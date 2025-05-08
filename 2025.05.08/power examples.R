#MORE POWER

#data manipulation
library(tidyverse)

#easy power tests
library(pwr)
library(effectsize)

#linear mixed models
library(lme4)
library(lmerTest)

#more complicated models
library(glmmTMB)

#simlation-based power analysis
library(simr)

############################### 
#first, a basic power analysis for a t-test

#what effect size do you want?
cohen.ES(test = "t", size = "medium")

#ok, let's calculate an effect size from real data
View(iris)

irissub = filter(iris, Species %in% unique(iris$Species)[c(1:2)])

cohens_d(x = filter(irissub, Species == "versicolor")$Sepal.Length, 
         y = filter(irissub, Species == "setosa")$Sepal.Length)

cohens_d(Petal.Length ~ Species, data = irissub)

#Now how many samples would we need to see a difference in sepal length?

pwr.t.test(d = 2.1, sig.level = 0.05, power = 0.8)


#what if we have 8 samples per group, how much power do we have?

pwr.t.test(n=8, d = 2.1, sig.level = 0.05)

#if we want 80% power, what's the smallest effect size we can see?


pwr.t.test(n=8, d = 2.1, sig.level = 0.05)

#########################################################

#so much for the easy part.

#I want to see how many samples we need to detect an inter-annual
# trend in abundance of Pseudodiaptomu (zooplankton)
# in the Delta. 
#Also salinity

#https://github.com/InteragencyEcologicalProgram/zooper
#this is the dataset with all of the IEP zooplankton data
library(zooper)

#Let's look at one taxa, pseudodiaptomus forbesi
pseudo = Zoopsynther(Data_type = "Community", Sources = c("EMP", "FMWT", "STN", "20mm"), Years = c(2010:2011)) %>%
  filter(Taxname == "Pseudodiaptomus forbesi", Lifestage == "Adult", !is.na(SalSurf)) %>%
  mutate(logCPUE = log(CPUE +1), Month = month(Date))

#Mixed model with random effects of month and station
myrNB = lmer(logCPUE ~ Year + SalSurf + (1|Station),  
             data = pseudo)

summary(myrNB)


#change the effect of year
fixef(myrNB)["Year"] =  .1

#test the power for the year effect
test = powerSim(myrNB, nsim=100, test = fixed("Year", method = "t"))
test

#what if we wanted a larger effect size?
fixef(myrNB)["Year"] =  .5
powerSim(myrNB, nsim=100, test = fixed("Year", method = "t"))
#MORE POWER

#now test salinity
fixef(myrNB)["SalSurf"] =  .1
powerSim(myrNB, nsim=100, test = fixed("SalSurf", method = "t"))



#extend the data along station to artificially increase the sample size
modex = extend(myrNB, along = "Station", n = 200)
p = powerCurve(modex,  along = "Station",  breaks = c(10,20,50,100,200), nsim = 100)
#p2 = powerCurve(modex,  along = "Station",  breaks = c(5, 10,15, 20,30,40,50,70,100,150, 200), nsim = 1000)
#save(p2, file = "data/p2.RData")

print(p)
ggplot(summary(p), aes(x = nlevels, y = mean)) + geom_line()

ggplot(summary(p2), aes(x = nlevels, y = mean)) + geom_line()

###############################################
#but what if I don't have data to start with?
#Well, let's start by assuming we want to detect a 25% change
#in CPUE between years, and we assume variance correlation is 0.4

samples = factor(1:20)
station = factor(c("A1","B1","A2","B2","A3","B3"))
Year = c("2010", "2011")
Month = c(1:12)

#dataframe of covariates
covariates = data.frame(ID = samples) %>%
  cross_join(data.frame(Station = station)) %>%
  cross_join(data.frame(Year = Year)) %>%
  cross_join(data.frame(Month = Month))

covariates = mutate(covariates, 
                    SalSurf = rgamma(nrow(covariates), shape =5, scale =1 )+Month/2)

#make a model 
TestModel = makeGlmer(y ~ SalSurf + Year + (1|Month) + (1|Station), 
                      family = "poisson", fixef = c(.2,.1, .1),
                      VarCorr = list(.4, .4), data = covariates)
summary(TestModel)

powerSim(TestModel, nsim = 100)

#but real zooplankton data isn't quite poisson. It's prpbably
#zero-inflated negative binomial. 

#this, or other more exciting types of models will force you to run your own power
#analyses


#see also:
#https://avehtari.github.io/ROS-Examples/

#first set up what you think the group means and variance should be
MeanByMonth = data.frame(Month = c(1:12),
                         MonthMean = c(1,2,2,2,3,9,18, 15, 9, 4,3,1)) %>%
  mutate(VariancebyMonth = MonthMean/2)

#now set up the station effects, predicted year effects, salinity effects                         
StationEffects = data.frame(Station = station, 
                            stationEffect = rnorm(6,0, .4)) #let's say the site-to-site standard deviation is 0.4
SalinityEffect = -0.05
YearEffect = 0.2

simulated_data = covariates %>%
  left_join(MeanByMonth, by = "Month")%>%
left_join( StationEffects)%>%
  mutate(Zooplankton = rnbinom(1, mu = MonthMean, size = VariancebyMonth)+ #simulate data
           stationEffect+SalSurf*SalinityEffect+YearEffect*as.numeric(Year))
  

mod1 = glmmTMB(Zooplankton ~ SalSurf+Year + Month + (1|Station),
               family = "nbinom2",
              data = simulated_data)
summary(mod1)


#now we do that over, and over, and over again!
#set it up in a loop

results = data.frame()
nsims = 20

for(i in 1:nsims) {
  simulated_data = covariates %>%
    left_join(MeanByMonth, by = "Month")%>%
    left_join( StationEffects)%>%
    
    mutate(Zooplankton = rnbinom(1, mu = MonthMean, size = VariancebyMonth)+
             stationEffect+SalSurf*SalinityEffect+YearEffect*as.numeric(Year))
  
  mod1 = glmmTMB(Zooplankton ~ SalSurf+Year + Month + (1|Station),
                 family = "nbinom2",
                 data = simulated_data)
  smod = summary(mod1)
  
  resultsA = data.frame(Sim = i, salinityP =smod$coefficients$cond[2,4],
                        YearP = smod$coefficients$cond[3,4],
                        MonthP = smod$coefficients$cond[4,4])
  results = bind_rows(results, resultsA)
  
}

view(results)

#calculate power - the number of significant results over total simluations 
Powerresults = results %>%
  summarize(SalinityPower = length(salinityP[which(salinityP< 0.05)])/n(), 
            YearPower = length(YearP[which(YearP< 0.05)])/n(),
            MonthPower = length(MonthP[which(MonthP< 0.05)])/n(),)



#increased sample size
samples = factor(1:100)
covariates = data.frame(ID = samples) %>%
  cross_join(data.frame(Station = station)) %>%
  cross_join(data.frame(Year = Year)) %>%
  cross_join(data.frame(Month = Month))





#now we do that over, and over, and over again!
#set it up in a loop

results100 = data.frame()
nsims = 20

for(i in 1:nsims) {
covariates = mutate(covariates, 
                    SalSurf = rgamma(nrow(covariates), shape =5, scale =1 )+Month/2)  

simulated_data = covariates %>%
    left_join(MeanByMonth, by = "Month")%>%
    left_join( StationEffects)%>%
    
    mutate(Zooplankton = rnbinom(1, mu = MonthMean, size = VariancebyMonth)+
             stationEffect+SalSurf*SalinityEffect+YearEffect*as.numeric(Year))
  
  mod1 = glmmTMB(Zooplankton ~ SalSurf+Year + Month + (1|Station),
                 family = "nbinom2",
                 data = simulated_data)
  smod = summary(mod1)
  
  resultsA = data.frame(Sim = i, salinityP =smod$coefficients$cond[2,4],
                        YearP = smod$coefficients$cond[3,4],
                        MonthP = smod$coefficients$cond[4,4])
  results100 = bind_rows(results100, resultsA)
  
}

view(results100)
Powerresults2_100 = results100 %>%
  summarize(SalinityPower = length(salinityP[which(salinityP< 0.05)])/n(),
            YearPower = length(YearP[which(YearP< 0.05)])/n(),
            MonthPower = length(MonthP[which(MonthP< 0.05)])/n(),)
