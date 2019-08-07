# data
drift.dat<-read.csv("Drift_Jun2014.subset4NL.csv")
head(drift.dat)
str(drift.dat)

# subset by site (SHR = Sac R., STTD = Yolo)
drift.SHR<-subset(drift.dat, StationCodes=="SHR")
head(drift.SHR)
drift.STTD<-subset(drift.dat, StationCodes=="STTD")
head(drift.STTD)

# summarise data for plots by year and invert category 
library(plyr)
SHR <- ddply(drift.SHR, c("Year", "Category"), summarise, N = mean(N))
head(SHR)
SHR<-na.omit(SHR)

STTD <- ddply(drift.STTD, c("Year", "Category"), summarise, N =mean(N))
head(STTD)
STTD<-na.omit(STTD)

# bar plots
library(ggplot2)
SH<-ggplot(SHR, aes(x=Year, y=N, fill=Category)) + 
  geom_bar(stat="identity") +
  xlab("Time") +
  ylab("N") +
  theme_bw()

ST<-ggplot(STTD, aes(x=Year, y=N, fill=Category)) + 
  geom_bar(stat="identity") +
  xlab("Time") +
  ylab("N") +
  theme_bw()

#choose a color
library(RColorBrewer)
display.brewer.all()

# add color, scale, remove elements
STD<-ST +ylim(0,35)+scale_fill_brewer(palette="BuGn") + guides(fill=FALSE) 
SHRH<-SH +ylim(0,35) +scale_fill_brewer(palette="BuGn") +
  theme(axis.text.y=element_blank(), axis.ticks.y=element_blank(),
        axis.title.y=element_blank())

# final figure
library(gridExtra)
theme_set(theme_gray(base_size = 22))

tiff(filename="Drift_final.tif", units="in", bg="white", height=10, width =10, res=750, pointsize=18)
vp1 <- viewport(width = 0.43, height = 1, x=0.23)
vp2 <- viewport(width = 0.6, height = 1, x=0.73)
print(STD, vp = vp1)
print(SHRH, vp = vp2)

dev.off()