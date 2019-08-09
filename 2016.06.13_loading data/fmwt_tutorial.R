# OK stacy, Here's your script to plot various statistics from IEP data.
#Well, for the fall-midwater trawl, anyway. I haven't gotten further than that yet.

#First of all, where did you save that other file I gave you? You want to make that folder
# your working directory. To check and see what your current working directory is, use:
getwd()

#Ether more the "iepdataconnetion.R" file to that folder, or use "setwd" to change your working directory
setwd("whereever you saved that file")

#Now, we are going to run that script. It will download the data, put it in the right format,
#and set up some functions we are going to use.This will take several minutes.
source(file.path(getwd(),"iepdataconnetion.R"))

#There are a couple functions we are going to be running to graph various things you might want to grph
#The first is "Graphst" wich will graph the shannon=weiner index over time for a given station.

#For example, to grph the SW index from station 604:
Graphst(604)

#If we want to graph the CPUE for a particular species at a particular station over time,
#Use the function "Graphspp"

Graphspp(604, "Delta.Smelt")

#Note that it is important to spell the names of the fish right, and use a period inbetween
#two-word names. IF you want a reference, use this:
levels(fmwt2$species)

#To graph the index of abundance across the entire estuary for a given speices, use the "Index" function

Index("Splittail")

#And finally, for the estuary-wide shannon index over time (weighted by area), run the following:

swi = ggplot(fmwt3.1ya, aes(x=Year, y= sw)) + geom_line()
swi +  labs(y="Shannon-Weiner Index", x="Year") + ggtitle("FMWT diversity over time")

# The downword trend in overall diversity is rather disturbing, and I don't think I"ve seen it before.
