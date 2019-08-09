
dat <- read.csv("https://sites.google.com/site/rforfishandwildlifegrads/home/week-7/dat.csv?attredirects=0&d=1")
# setwd('.../your directory here/...')
# dat <- read.csv("dat.csv")

head(dat)
str(dat)
summary(dat)
names(dat)
dim(dat)
nrow(dat)
ncol(dat)
plot(weight ~ length, dat)
plot(dat$length,dat$weight)
plot(weight ~ length, dat, pch = 19)  # filled circles!
plot(weight ~ length, dat, pch = 15)  # filled squares
plot(weight ~ length, dat, pch = 17)  # filled triangles


plot(weight ~ length, dat, pch = 19, xlab = "Length (mm)", ylab = "Weight (g)")
plot(weight ~ length, dat, pch = 19, xlab = "Length (mm)", ylab = "Weight (g)", 
    xlim = c(0, 400), ylim = c(0, 400))

plot(weight ~ length, dat, xlab = "Length (mm)", ylab = "Weight (g)", xlim = c(200, 
    800), ylim = c(0, 800), type = "n")

plot(weight ~ length, dat, xlab = "Length (mm)", ylab = "weight (g)", xlim = c(200, 
    800), ylim = c(0, 800), type = "n")
points(weight ~ length, dat, subset = year == 2009, pch = 19)
points(weight ~ length, dat, subset = year == 2010, pch = 1)
points(weight ~ length, dat, subset = year == 2011, pch = 10)
points(weight ~ length, dat, subset = year == 2012, pch = 15)

plot(weight ~ length, dat, xlab = "Length (mm)", ylab = "weight (g)", xlim = c(200, 
    800), ylim = c(0, 800), type = "n")
points(weight ~ length, dat, subset = year == 2009, pch = 19, col = "red")  # add data for 2009
points(weight ~ length, dat, subset = year == 2010, pch = 1, col = "black")  # add data for 2010
points(weight ~ length, dat, subset = year == 2011, pch = 10, col = "blue")  # add data for 2011
points(weight ~ length, dat, subset = year == 2012, pch = 15, col = "green")  # add data for 2012


plot(weight ~ length, dat, xlab = "Length (mm)", ylab = "weight (g)", xlim = c(200, 
    800), ylim = c(0, 800), type = "n")
points(weight ~ length, dat, subset = year == 2009, pch = 19, col = "red")  # add data for 2009
points(weight ~ length, dat, subset = year == 2010, pch = 1, col = "black")  # add data for 2010
points(weight ~ length, dat, subset = year == 2011, pch = 10, col = "blue")  # add data for 2011
points(weight ~ length, dat, subset = year == 2012, pch = 15, col = "green")  # add data for 2012
## Adding a default legend
legend("top", legend = c("2009", "2010", "2011", "2012"), pch = c(19, 1, 10, 
    15), col = c("red", "black", "blue", "green"))
	
plot(weight ~ length, dat, xlab = "Length (mm)", ylab = "Weight (g)", xlim = c(200, 
    800), ylim = c(0, 800), type = "n")
points(weight ~ length, dat, subset = year == 2009, pch = 19, col = "red")  # add data for 2009
points(weight ~ length, dat, subset = year == 2010, pch = 1, col = "black")  # add data for 2010
points(weight ~ length, dat, subset = year == 2011, pch = 10, col = "blue")  # add data for 2011
points(weight ~ length, dat, subset = year == 2012, pch = 15, col = "green")  # add data for 2012
## Adding a default legend
legend("topleft", legend = c("2009", "2010", "2011", "2012"), pch = c(19, 1, 
    10, 15), col = c("red", "black", "blue", "green"))
	
plot(weight ~ length, dat, xlab = "Length (mm)", ylab = "Weight (g)", xlim = c(200, 
    800), ylim = c(0, 800), type = "n", las = 1)
points(weight ~ length, dat, subset = year == 2009, pch = 19, col = "red")  # add data for 2009
points(weight ~ length, dat, subset = year == 2010, pch = 1, col = "black")  # add data for 2010
points(weight ~ length, dat, subset = year == 2011, pch = 10, col = "blue")  # add data for 2011
points(weight ~ length, dat, subset = year == 2012, pch = 15, col = "green")  # add data for 2012
## Adding a default legend
legend("topleft", legend = c("2009", "2010", "2011", "2012"), pch = c(19, 1, 
    10, 15), col = c("red", "black", "blue", "green"), bty = "n")
	
### Line Plots ###########################
lindat <- aggregate(weight ~ year, dat, mean)
lindat$length <- aggregate(length ~ year, dat, mean)$length
lindat$n <- aggregate(weight ~ year, dat, length)$weight
lindat$var <- aggregate(weight ~ year, dat, var)$weight
lindat$lci <- lindat$weight - 1.96 * sqrt(lindat$var)/sqrt(lindat$n)
lindat$uci <- lindat$weight + 1.96 * sqrt(lindat$var)/sqrt(lindat$n)


plot(weight ~ year, lindat, type = "l", las = 1, xlab = "Year", ylab = "Mean weight (g)")


plot(weight ~ year, lindat, type = "b", las = 1, xlab = "Year", ylab = "Mean weight (g)")


# fix the x-axis (xaxt='n')
plot(weight ~ year, lindat, type = "b", las = 1, xlab = "Year", ylab = "Mean weight (g)", 
    xaxt = "n")
axis(side = 1, at = c(2009, 2010, 2011, 2012), labels = c("2009", "2010", "2011", 
    "2012"))
	
	
plot(weight ~ year, lindat, type = "b", las = 1, xlab = "Year", ylab = "Mean weight (g)", 
    xaxt = "n", ylim = c(0, 200), pch = 19)
axis(side = 1, at = c(2009, 2010, 2011, 2012), labels = c("2009", "2010", "2011", 
    "2012"))
segments(x0 = lindat$year, y0 = lindat$lci, x1 = lindat$year, y1 = lindat$uci)


# whiskers
plot(weight ~ year, lindat, type = "b", las = 1, xlab = "Year", ylab = "Mean weight (g)", 
    xaxt = "n", ylim = c(0, 200), pch = 19)
axis(side = 1, at = c(2009, 2010, 2011, 2012), labels = c("2009", "2010", "2011", 
    "2012"))
arrows(x0 = lindat$year, y0 = lindat$lci, x1 = lindat$year, y1 = lindat$uci, 
    angle = 90, length = 0.1, code = 3)
	
	
#### Boxplot #####
boxplot(length ~ stage, dat, xlab = "Stage", ylab = "Length (mm)")


boxplot(length ~ stage, dat, xlab = "Stage", ylab = "Length (mm)", subset = year == 
    2009, at = c(1:2) - 0.25, boxwex = 0.1)
boxplot(length ~ stage, dat, xlab = "Stage", ylab = "Length (mm)", subset = year == 
    2010, add = TRUE, at = c(1:2) - 0.125, boxwex = 0.1)
boxplot(length ~ stage, dat, xlab = "Stage", ylab = "Length (mm)", subset = year == 
    2011, add = TRUE, at = c(1:2) + 0.125, boxwex = 0.1)
boxplot(length ~ stage, dat, xlab = "Stage", ylab = "Length (mm)", subset = year == 
    2012, add = TRUE, at = c(1:2) + 0.25, boxwex = 0.1)
	
	
	boxplot(length ~ stage, dat, xlab = "Stage", ylab = "Length (mm)", subset = year == 
    2009, at = c(1:2) - 0.15, boxwex = 0.08, xaxt = "n", col = "red")
boxplot(length ~ stage, dat, xlab = "Stage", ylab = "Length (mm)", subset = year == 
    2010, add = TRUE, at = c(1:2) - 0.05, boxwex = 0.08, xaxt = "n", col = "yellow")
boxplot(length ~ stage, dat, xlab = "Stage", ylab = "Length (mm)", subset = year == 
    2011, add = TRUE, at = c(1:2) + 0.05, boxwex = 0.08, xaxt = "n", col = "green")
boxplot(length ~ stage, dat, xlab = "Stage", ylab = "Length (mm)", subset = year == 
    2012, add = TRUE, at = c(1:2) + 0.15, boxwex = 0.08, xaxt = "n", col = "grey")
axis(side = 1, at = c(1, 2), labels = c("Adults", "Juveniles"))
legend("topright", legend = c(2009:2012), fill = c("red", "yellow", "green", 
    "grey"))
	
	
##### Histograms #####
hist(dat$length)


hist(dat$length, xlab = "Length (mm)", ylab = "Number of fish", las = 1)
box()


hist(dat$length, xlab = "Length (mm)", ylab = "Number of fish", las = 1, main = "")
box()


hist(dat$length, xlab = "Length (mm)", ylab = "Number of fish", las = 1, main = NULL)
box()


hist(dat$length, xlab = "Length (mm)", ylab = "Density", las = 1, main = "", 
    freq = FALSE, col = "grey")
box()


par(oma = c(1, 2, 1, 1))  # add an outer margin to plot in
hist(dat$length, xlab = "Length (mm)", ylab = "", las = 1, main = "", freq = FALSE, 
    col = "grey")
box()
mtext(side = 2, "Density", outer = TRUE, line = 0)

##### Barplots #####
barplot(lindat$weight)


barplot(lindat$weight, names = lindat$year, las = 1, yaxt = "n", ylim = c(0, 
    250), ylab = "Mean weight (g)", width = 0.9, space = 0.1)
axis(side = 2, at = seq(0, 250, 50), labels = TRUE, las = 1)
box()


barplot(lindat$weight, names = lindat$year, las = 1, yaxt = "n", ylim = c(0, 
    250), ylab = "Mean weight (g)", width = 0.9, space = 0.1)
axis(side = 2, at = seq(0, 250, 50), labels = TRUE, las = 1)
box()
# dynamite plot
arrows(x0 = c(0.475, 1.475, 2.475, 3.475), y0 = lindat$weight, x1 = c(0.475, 
    1.475, 2.475, 3.475), y1 = lindat$uci, angle = 90)
	
	
plot(weight ~ length, lindat, type = "h", lwd = 5, lend = 2, las = 1, ylab = "Mean weight (g)", 
    xlab = "Mean Length (mm)")
	
	
addpoints <- function(plotyear, plotsymbol, plotcol) {
    ## make a function to plot points for a given year
    points(weight ~ length, dat, subset = year == plotyear, pch = plotsymbol, 
        col = plotcol)
}
plot(weight ~ length, dat, type = "n", xlab = "Length (mm)", ylab = "Weight (g)")
addpoints(plotyear = 2009, plotsymbol = 1, plotcol = "red")
addpoints(plotyear = 2010, plotsymbol = 2, plotcol = "blue")
addpoints(plotyear = 2011, plotsymbol = 2, plotcol = "black")
addpoints(plotyear = 2012, plotsymbol = 2, plotcol = "black")

##### Multipanel plots ##### 
par(mfrow = c(2, 2), mar = c(4, 4, 0, 0.2))
plot(weight ~ length, dat, xlab = "Length (mm)", ylab = "Weight (g)", las = 1)
plot(length ~ weight, dat, ylab = "Length (mm)", xlab = "Weight (g)", las = 1)
boxplot(weight ~ year, dat, xlab = "Year", ylab = "Weight (g)", las = 1)
boxplot(weight ~ stage, dat, xlab = "Year", ylab = "Weight (g)", las = 1)


par(mfrow = c(4, 1), mar = c(4, 4, 0, 0.2))
plot(weight ~ length, dat, xlab = "Length (mm)", ylab = "Weight (g)", las = 1)
plot(length ~ weight, dat, ylab = "Length (mm)", xlab = "Weight (g)", las = 1)
boxplot(weight ~ year, dat, xlab = "Year", ylab = "Weight (g)", las = 1)
boxplot(weight ~ stage, dat, xlab = "Stage", ylab = "Weight (g)", las = 1)







##### BONUS MATERIAL
## LAYOUT() FUNCTION Figure 8.2 A: a 2x2 panel (2 rows and 2 columns)
layout(matrix(c(1, 2, 3, 4), 2, 2, byrow = TRUE))  # same as
par(mfrow = c(2, 2))
layout.show(4)  ## show the layout that has been set up for the 4 plots

plot(weight ~ length, dat, xlab = "Length (mm)", ylab = "Weight (g)", las = 1)

plot(length ~ weight, dat, ylab = "Length (mm)", xlab = "Weight (g)", las = 1)
boxplot(weight ~ year, dat, xlab = "Year", ylab = "Weight (g)", las = 1)
boxplot(weight ~ stage, dat, xlab = "Year", ylab = "Weight (g)", las = 1)
## a 4x1 panel (4 rows and 1 column)
layout(matrix(c(1, 2, 3, 4), 4, 1, byrow = TRUE))
layout.show(4)  ## show the layout that has been set up
par(mar = c(4, 4, 0, 0.2))

plot(weight ~ length, dat, xlab = "Length (mm)", ylab = "Weight (g)", las = 1)

plot(length ~ weight, dat, ylab = "Length (mm)", xlab = "Weight (g)", las = 1)
boxplot(weight ~ year, dat, xlab = "Year", ylab = "Weight (g)", las = 1)
boxplot(weight ~ stage, dat, xlab = "Stage", ylab = "Weight (g)", las = 1)
##  a different layout for 2 plots

layout(matrix(c(1, 1, 0, 2), 2, 2, byrow = TRUE))
layout.show(2)  ## show the layout that has been set up
plot(weight ~ length, dat, xlab = "Length (mm)", ylab = "Weight (g)", las = 1)

boxplot(weight ~ year, dat, xlab = "Year", ylab = "Weight (g)", las = 1)
##  Clean up he white space by adjusting the margins

layout(matrix(c(1, 1, 0, 2), 2, 2, byrow = TRUE))
layout.show(2)  ## show the layout that has been set up
par(mar = c(4, 4, 0.2, 0.2))

plot(weight ~ length, dat, xlab = "Length (mm)", ylab = "Weight (g)", las = 1)
par(mar = c(4, 4, 0.5, 0.2))
boxplot(weight ~ year, dat, xlab = "Year", ylab = "Weight (g)", las = 1)

