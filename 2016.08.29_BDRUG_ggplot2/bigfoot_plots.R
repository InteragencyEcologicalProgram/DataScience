#Plotting data on bigfoot sightings using ggplot2
# Presentation to the Bay-Delta R users Group
# August 29th, 2016
# Rosemary Hartman (Rosemary.Hartman@wildlife.ca.gov)

# Load the ggplot2 package
library(ggplot2)

#Import the data. This is the same csv Vanessa used for her intro to plotting presentation
bf.hab <- read.csv("bigfoot_habitat.csv")

# Basic Scatterplot
p1 = ggplot(bf.hab, aes(y=reports, x=pop2015))

p1 + geom_point() 

#Put population on a log scale
p1 + geom_point() +scale_x_log10()

# plot each state seperately
p1+geom_point() + facet_grid(.~state) + scale_x_log10()

# add trend lines
p1 + geom_point(aes(color = state)) +  
  geom_smooth(aes(color = state), method=lm) + scale_x_log10() +
  # Also make more informative lables
  labs(title = "Bigfoot Sightings 2015", y = "number of reports", x= "population")

## That's starting to get too long, let's clean it up

p1.1 = p1 + geom_point(aes(color = state)) + scale_x_log10() +
  geom_smooth(aes(color = state), method=lm) +
  labs(title = "Bigfoot Sightings 2015", y = "number of reports", x= "log population")

# Now we can add on to this graph quickly and easily
# change the theme
p1.1 + theme_bw()

# build your own theme

mytheme = theme(panel.background = element_rect(fill = "white"), # specify graph background color
                plot.background = element_rect(fill = 21), # figure background color
                panel.grid.major = element_line(size = 0.5, color = "grey"), # gridlines
                axis.line = element_line(size = 0.7, color = "black"), # axis lines
                legend.position = "top", text = element_text(size = 14)) # move the legend

# Now put it on your graph
p1.1 + mytheme 

# More pre-built themes using the ggthemes package
library(ggthemes)

# wall-street journal theme
p1.1 + theme_wsj()


# modify the scales:
p1.1 + scale_y_continuous(breaks = c(0,20, 40, 60), labels = c("none", "some", "many", "lots"))

# add annotation

p1.1 + annotate("text", x= 20, y = 10000, label = "I love R", color = "red", size = 10)

# Add another line:
p1.1 + geom_abline(intercept = -30, slope = 10, lty = 2)

# You can use geom_abline to add the results form a linear model (instead of geom_smooth)
lm1 = lm(bf.hab$reports ~ bf.hab$pop2015)
lm1$coefficients

p1.1 + geom_abline(intercept = lm1$coefficients[1], slope = lm1$coefficients[2])


# But what other types of plots can I make?

# boxplot

p2 = ggplot(bf.hab, aes(x=state, y= reports))

p2 + geom_boxplot()

# and change how it looks again...
p2 + geom_boxplot() + theme_wsj()

# violin plot
p2 + geom_violin()


# bar chart

# the automatic way to do a bar chart gives you counts
# so you have to specify a different statistic
p2 + geom_bar(stat = "identity") # this gives you total number of sitings

# you can use stat_summary to give you an average
p2 + stat_summary(fun.y = mean, geom="bar")

# and everyone likes error bars

# formula for standard errors:
stderr <- function(x) {
  sqrt(var(x[!is.na(x)]) / length(x[!is.na(x)]))
}
my.stderr <- function(x) {
  meany <- mean(x)
  ymin  <- mean(x) - stderr(x)
  ymax  <- mean(x) + stderr(x)
  # assemble the named output
  out <- c(y = meany, ymin = ymin, ymax = ymax)
  return(out)
}
  
p2 + stat_summary(fun.y = mean, geom="bar") + stat_summary(fun.data = "my.stderr", geom = "errorbar", width = 0.5)
         
# Stacked bar chart
p4 = ggplot(bf.hab, aes(x= state, y= reports, fill = county))

p4 + geom_bar(stat="identity") + scale_fill_discrete(guide = FALSE)

#The colors stack automatically, you can change them with "position"

# make them side by side:
p4 + geom_bar(stat="identity", position = "dodge") + scale_fill_discrete(guide = FALSE)

# percentage out of 100%
p4 + geom_bar(stat="identity", position = "fill") + scale_fill_discrete(guide = FALSE)





# Pie charts are similar to stacked bar charts, you just turn them into a circle!
p3 = ggplot(bf.hab, aes(x= 1, y= reports, fill = state))

p3 + stat_summary(fun.y = mean, geom="bar")

p3.1 = p3 + stat_summary(fun.y = mean, geom="bar", position = "fill")+ 
  coord_polar(theta = "y") 
p3.1

# You do have to fix the axes so they say what you want
p3.2 =p3.1 + scale_x_discrete(labels = NULL, name = NULL) +
  # and maybe add some annotation
  annotate('text', x=c(1,1,1), y = c(.12, .32, .75), label = c("I love California", "Oregon is cool too", "Too close to \n Canada")) +
  mytheme
p3.2
# Now we want to export this for our most prestegious publication

pdf(file = "bigfoot.pdf", width= 8, height = 8)
p3.2 #print our plot
dev.off() #stop making pdfs

# A different journal might want a png 

png(filename = "bigfoot.png", width = 400, height = 400, units = "px")
p3.2
dev.off()
