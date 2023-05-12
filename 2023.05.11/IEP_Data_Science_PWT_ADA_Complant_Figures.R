# R Coding Colors for ADA Compliance
# Training Module
# Author: Daniel Ellis (daniel.ellis@wildlife.ca.gov)

# Load packages
library(viridis)
library(ggplot2)
library(dplyr)
# library(viridisLite)

# Scatterplots
# Make up some data
# x = year
# y = catch great whites in SF bay
year = data.frame(rep(c(2020:2039), each = 12))
month = data.frame(rep(c(1:12), length.out = 240))

# Save as df
df = cbind(year, month)
df$catch = NA

# Column names
names(df)[1]<-"year"
names(df)[2]<-"month"
names(df)[3]<-"catch"

# Make a copy 
df_goliath = df

# generate data with a trend
for (i in 1:nrow(df)){
  df$catch[i]= round((df$year[i]-2000)*(rpois(n =1, lambda = 0.75)), digits = 0)
}
df$species = "White Shark"

for (i in 1:nrow(df_goliath)){
  if(i <= 8){
  df_goliath$catch[i]= abs(rnorm(n=1, mean=1.2)*round(((df_goliath$year[i]-1960)*(rpois(n =1, lambda = 0.5))), digits = 0))
  }
  if(i >8 && 1 <= 14){
    df_goliath$catch[i]= abs(rnorm(n=1, mean=1.2)*round(((df_goliath$year[i]-1975)*(rpois(n =1, lambda = 0.5))), digits = 0))
  }
  if(i > 15){
    df_goliath$catch[i]= abs(rnorm(n=1, mean=1.2)*round(((df_goliath$year[i]-1992)*(2)*(rpois(n =1, lambda = 0.5))), digits = 0))
  }
  if(df_goliath$catch[i] > 50){
    df_goliath$catch[i] = 5
  }
}
df_goliath$species = "Goliath Grouper"

# Merge them
df = rbind(df, df_goliath)
df$catch = round(df$catch, digits = 0)
df$catch_log = log(df$catch +1)

# Make table for averages by year
df_mo_avg = df %>%  group_by(year, species) %>%  summarise(avg = mean(catch)) # How many by each region
df_mo_avg$avg = round(df_mo_avg$avg, digits = 0)

# START OF SCATTERPLOTS
##################################
# Cut down to one only
temp = filter(df_mo_avg, species == "White Shark")


# plot with trend line
plot2 = ggplot(temp, aes(x=year, y=avg)) + geom_point()+geom_smooth(method=lm , color="black", se=FALSE)+ theme_bw()
plot2

# Add CI for trend line
plot3 = ggplot(temp, aes(x=year, y=avg)) + geom_point()+geom_smooth(method=lm , color="black", fill="#69b3a2", se=TRUE)+ theme_bw()
plot3

# ADA- better
plot3 = ggplot(temp, aes(x=year, y=avg)) + geom_point(size= 4)+geom_smooth(method=lm , color="black", fill="#D3D3D3", se=TRUE, size = 2)+ theme_bw()+theme(axis.text.x=element_text(size=15))+theme(axis.text.y=element_text(size=15))+theme(axis.text=element_text(size=12),axis.title=element_text(size=14,face="bold"))
plot3

# But what if you have 2 datasets to plot
plot4 = ggplot(df_mo_avg, aes(x=year, y=avg)) + geom_point(size= 4)+geom_smooth(method=lm , color="black", fill="#D3D3D3", se=TRUE, size = 2)+ theme_bw()+theme(axis.text.x=element_text(size=15))+theme(axis.text.y=element_text(size=15))+theme(axis.text=element_text(size=12),axis.title=element_text(size=14,face="bold"))+ geom_point(data= df_mo_avg_copy,size= 5, color= "lightblue")+geom_smooth(data= df_mo_avg_copy,method=lm , color="black", fill="#D3D3D3", se=TRUE, size = 2)
plot4

# but better for ADA
plot5 <- ggplot(df_trends, aes(year, avg)) + 
                  geom_point(color='black', shape=21, size=4, aes(fill=factor(species))) +  
                  scale_fill_manual(values=c('red', 'white'))+
                  theme_bw()+theme(axis.text.x=element_text(size=15)) +
                  theme(axis.text.y=element_text(size=15)) +
                  theme(axis.text=element_text(size=12),axis.title=element_text(size=14,face="bold")) +
                  geom_smooth(data= df_mo_avg_copy,method=lm , color="black", fill="#D3D3D3", se=TRUE, size = 2) +              geom_smooth(data= df_mo_avg,method=lm , color="black", fill="red", se=TRUE, size = 2)
plot5
    
# but ACTUALLY better for ADA
plot5 <- ggplot(df_trends, aes(year, avg)) + 
  geom_point(color='black', shape=21, size=4, aes(fill=factor(species))) +  
  scale_fill_manual(values=c('red', 'white'))+
  theme_bw()+theme(axis.text.x=element_text(size=15)) +
  theme(axis.text.y=element_text(size=15)) +
  theme(axis.text=element_text(size=12),axis.title=element_text(size=14,face="bold")) +
  geom_smooth(data= df_mo_avg_copy,method=lm , color="black", fill="red", se=TRUE, size = 2) +              geom_smooth(data= df_mo_avg,method=lm , color="black", fill="yellow", se=TRUE, size = 2)
plot5
##################################
# END OF SCATTERPLOTS

# START OF BARPLOTS / HISTOGRAMS
##################################
# Start with single species
plot =  ggplot( df_mo_avg, aes(x=factor(year),y=avg, fill=species)) + 
  geom_bar(position = "dodge", stat = "identity")+
  xlab("Year") + ylab("Average Catch") 
plot

  
# Better colors
plot1 =  ggplot( df_mo_avg, aes(x=factor(year),y=avg, fill=species)) + 
  geom_bar(position = "dodge", stat = "identity", colour= "black")+theme_bw()+
  xlab("Year") + ylab("Average Catch") +scale_fill_manual(values=c("blue","lightyellow"))+theme_bw()
plot1

# Or pattern fill
# remotes::install_github("coolbutuseless/ggpattern")
# install.packages("magick")
library(ggpattern)
library(magick)
plot2 <- ggplot(df_mo_avg, x=factor(year), y = avg,aes(factor(year), avg,fill=species))+theme_bw()+
 geom_bar_pattern(position="dodge",stat = "identity",pattern_color = "black", pattern_fill = "white", aes(pattern=species))+scale_pattern_manual(values = c("White Shark" = "stripe","Goliath Grouper"="crosshatch"))
plot2 

# but maybe thats just bad patterns
plot3 <- ggplot(df_mo_avg, x=factor(year), y = avg,aes(factor(year), avg,fill=species))+
  geom_col_pattern(position = "dodge",aes(pattern_type = species, pattern_fill = species), pattern = 'magick', pattern_key_scale_factor = 0.7,  fill = "white",colour  = 'black') + scale_pattern_type_discrete(choices = c('vertical2', 'fishscales')) +theme_bw()
plot3 

##################################
# END OF BARPLOTS / HISTOGRAMS


# START OF RELATIVE ABUNDANCE / PIE CHARTS
##################################
# Relative abund version of plot3
plot3 <- ggplot(df_mo_avg, x=factor(year), y = avg,aes(factor(year), avg,fill=species))+
  geom_col_pattern(position = "fill",aes(pattern_type = species, pattern_fill = species), pattern = 'magick', pattern_key_scale_factor = 0.7,  fill = "white",colour  = 'grey') + scale_pattern_type_discrete(choices = c('vertical2', 'fishscales')) +theme_bw()
plot3 

# But what if they are small?
test = filter(df_mo_avg, species=="Goliath Grouper")
test$avg = test$avg*100
test$species = "Mississippi Silverside"
test1 = rbind(test, df_mo_avg)

test = filter(df_mo_avg, species=="Goliath Grouper")
test$avg = test$avg*200
test$species = "Mysids"
test = rbind(test1, test)

plot4 <- ggplot(test, x=factor(year), y = avg,aes(factor(year), avg,fill=species))+
  geom_col_pattern(width= 0.5,position = "fill",aes(pattern_type = species, pattern_fill = species), pattern = 'magick', pattern_key_scale_factor = 0.7,  fill = "white",,  colour  = 'grey') + scale_pattern_type_discrete(choices = c('vertical2', "bricks","stripes",'fishscales')) +theme_bw()
plot4

# More color doesnt help
plot5 <- ggplot(test, x=factor(year), y = avg,aes(factor(year), avg,fill=species))+
  geom_col_pattern(position = "fill",aes(pattern_type = species, pattern_fill = species), pattern = 'magick', pattern_key_scale_factor = 0.7,  colour  = 'black') + scale_pattern_type_discrete(choices = c('gray0', "bricks","gray60",'fishscales')) +theme_bw()
plot5


# same issue for pie charts
df2 <- data.frame(
  group = factor(c("Cool", "But", "Use", "Less","test","woohoo"), levels = c("Cool", "But", "Use", "Less","test","woohoo")),
  value = c(1, 6, 30, 40,50,3)
)

ggplot(df2, aes(x="", y = value, pattern_angle = group))+
  geom_bar_pattern(
    aes(pattern_type = group, pattern_fill = group),
    pattern                  = 'magick',
    pattern_scale            = 2,
    width                    = 1,
    stat                     = "identity",
    fill                     = 'white',
    colour                   = 'black',
    pattern_aspect_ratio     = 1,
    pattern_density          = 0.3
  ) +
  coord_polar("y", start=0) +
  theme_void(20) +
  theme(legend.key.size = unit(2, 'cm')) +
  scale_pattern_type_discrete(choices = gridpattern::names_magick_stripe) +
  labs(
    title    = "ggpattern::geom_bar_pattern()",
    subtitle = "pattern='magick'") 

##################################
# END OF RELATIVE ABUNDANCE / PIE CHARTS



# START OF HEAT MAPS / GRADIENTS
##################################
# Make up some data
x =  data.frame(rep(c(1:60), length.out=2400))
y =  data.frame(rep(c(1:40), each=60))
df = data.frame(x,y)
df$z = NA

# Column names
names(df)[1]<-"time"
names(df)[2]<-"space"

# Assign values based upon x and y coordinates
for (i in 1:nrow(df)){
  print(i)
  
  if(df$time[i] <= 15 & df$space[i] <= 15){
    df$z[i] = round(1*abs(rnorm(n=1, mean=5)), digits = 0)
  }
  if(df$time[i] <= 15 & df$space[i]> 15 & df$space[i]<= 35 ){
    df$z[i] = round(2*abs(rnorm(n=1, mean=5)), digits = 0)
  }
  if(df$time[i] <= 15 & df$space[i]> 35 ){
    df$z[i] = round(3*abs(rnorm(n=1, mean=5)), digits = 0)
  }
  
  
  if(df$time[i] > 15 & df$time[i] <= 41 & df$space[i]<=15   ){
    df$z[i] = round(abs(rnorm(n=1, mean=5)), digits = 0)
  } 
  if(df$time[i] > 15 & df$time[i] <= 41 & df$space[i]> 15 & df$space[i]<= 35 ){
    df$z[i] = round(3*abs(rnorm(n=1, mean=5)), digits = 0)
  }
  if(df$time[i] > 15 & df$time[i] <= 41 & df$space[i]> 35  ){
    df$z[i] = round(abs(rnorm(n=1, mean=5)), digits = 0)
  }
  
  
  
  if(df$time[i] > 41 & df$space[i]<=15){
    df$z[i] = round(3*abs(rnorm(n=1, mean=5)), digits = 0)
  }
  if(df$time[i] > 41 & df$space[i]> 15 & df$space[i]<= 35 ){
    df$z[i] = round(2*abs(rnorm(n=1, mean=5)), digits = 0)
  }
  if(df$time[i] > 41 & df$space[i]> 35  ){
    df$z[i] = round(abs(rnorm(n=1, mean=5)), digits = 0)
  }
}


sort(unique(df$z), na.last=T)
sort(unique(df$time), na.last=T)
sort(unique(df$space), na.last=T)


# Column names
names(df)[3]<-"density"


###############################################
# AS ARRAY

# Convert back to vectors
z = df$density


# Make an array to hold the values
arr = array(data = z, dim= c(60,40))

# Check array dimensions
dim(arr)

# Visualize array
arr[3,]

# Plot it
image(z=arr, las=1,x=c(1:60), y=c(1:40), col=viridis(3))
image(z=arr, las=1,x=c(1:60), y=c(1:40), col=viridis(5))
image(z=arr, las=1,x=c(1:60), y=c(1:40), col=viridis(10))
image(z=arr, las=1,x=c(1:60), y=c(1:40), col=viridis(length(unique(df$density))))

image(z=arr, las=1,x=c(1:60), y=c(1:40), col=turbo(3))
image(z=arr, las=1,x=c(1:60), y=c(1:40), col=turbo(5))
image(z=arr, las=1,x=c(1:60), y=c(1:40), col=turbo(10))
image(z=arr, las=1,x=c(1:60), y=c(1:40), col=turbo(length(unique(df$density))))

turbo(n=5)
turbo(n=10)
turbo(n=15)
turbo(n=20)
turbo(n=25)

#################################################
