#Data
fin.dat<-read.csv("diet.4IRI_example.csv")

##########################################################################

## assigning groups

# month and year
fish.dat$Date<-as.Date(fish.dat$Date)
fish.dat<-within(fish.dat, Year<-format(fish.dat$Date, "%Y"))
fish.dat<-within(fish.dat, Month<-format(fish.dat$Date, "%m"))
fish.dat$yr.mo<-with(fish.dat, paste(Year, Month, sep="."))

# add prey category
prey<-read.csv("PreyTaxa_JC.csv")
head(prey)
diet.prey<-merge(diet.dat, prey, by=c("Prey.taxa","LH"), all.x=T)
#
diet.prey[,21][is.na(diet.prey[,21])]<- "Nondescript"

## calculate fish weight from FL
wd<-read.csv("weights_2012_15.csv")
nlmodel<-nls(Weight.in.field.g.~beta*FL.mm.^alpha, start=list(beta=0.0001, alpha=3), data=wd)
sumnlmodel<-summary(nlmodel)
aa<-sumnlmodel$coefficients[1]
ab<-sumnlmodel$coefficients[2]
bv<-aa*FL^ab

## remove fish w/ empty stomachs
data<-subset(fish.dat, Prey.taxa!="Empty")

write.csv(fin.dat,"diet.4IRI.csv")
##########################################################################
## Data tests

# column summary, screen for errors
stat.desc(diet.count)

#examine for sufficiency (rate species, abundant species, variables with low variation)
# >5% of observations missing
testdata <- drop.var(diet.count, pct.missing=5)
#non-zero values in less than 5%
testdata <- drop.var(diet.count, min.po=5)
#fewer than 5 non-zero values
testdata <- drop.var(diet.count, min.fo=5)
#occurring in more than 95%
testdata <- drop.var(diet.count, max.po=95)
#too little variation
testdata <- drop.var(diet.count, min.cv=95)

# frequency of occurrence and abundance graphs
## produces 10 plots to show "samples" by "species"
foa.plots(diet.count)

## examine distribution
#  empirical cumulative distribution functions (deviations for the diagonal indicate non-uniformity)
ecdf.plots(diet.count)
#skewness
hist.plots(diet.count)
box.plots(diet.count)
# normal quantile-quantile plots (deviations for the diagonal indicate departure from a normal distribution)
qqnorm.plots(diet.count)
uv.plots(diet.count)

#ANOSIM
source("biostats.R")
library(vegan)
library(cluster)
library(pvclust)
library(pastecs)
# log or square root
tradata<-log10(diet.count+1)
#resemblance (distance matrix)
diet<-vegdist(tradata, "bray")
# anosim by gear
gear.anosim<-anosim(diet, grp[,2])
summary(gear.anosim)
plot.anosim(gear.anosim)

##########################################################################
#N0: total sample size for group of interest (ex. Site A (vs. B))
#occurrence: number of fish that invert occurred w/n group of interest
# number: total count of invert type w/n a group of interest
# weight: total weight of invert type w/n a group of interest
# %N0: number/ total # of all inverts in group of interest
# %G0: weight/ total weight of all inverts in group of interest
# %F0: occurrence/N0
# IRI: (%NO + %Go) *%FO
##########################################################################
library(plyr)
# metrics by invert type and group
dat.prey.moyr <- ddply(fin.dat, c("Category","yr.mo"), function(x){
  number <- sum(x$Count, na.rm=T)
  weight <- sum(x$Wt, na.rm=T)
  occurrance <-length(unique(x$fish.ID))
  dat <- data.frame(number, weight, occurrance)
})
head(dat.prey.moyr)

# metrics by group only
dat.moyr <- ddply(fin.dat, "yr.mo", function(x){
  t.number <- sum(x$Count, na.rm=T)
  t.weight <- sum(x$Wt, na.rm=T)
  N0 <- length(unique(x$fish.ID))
  dat <- data.frame(t.number, t.weight, N0)
})
head(dat.moyr)

dat<-merge(dat.prey.moyr, dat.moyr, by = "yr.mo", all = T)
head(dat)

# final parameters
dat <- transform(dat, p.N0=100*(number/t.number))
dat <- transform(dat, p.G0=100*(weight/t.weight))
dat <- transform(dat, p.F0=100*(occurrance/N0))
dat <- transform(dat, IRI=((p.N0+p.G0)*p.F0))
head(dat)


