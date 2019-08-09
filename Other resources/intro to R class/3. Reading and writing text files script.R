
# set working directory
setwd("G:/Jims class stuff/RRRR")
## read in tab delimited file
pet.data<-read.table("pets.txt", header = TRUE, sep = "\t")
### print the contents to the console
pet.data


## read in comma delimited file
pet.data2<-read.table("pets.csv", header = TRUE, sep = ",")
### print the contents to the console
pet.data2

### read in comma sepereated habitat file
habitat<-read.csv("habitat data.csv")
habitat

## print out first 6 lines
head(habitat)

habitat<-read.csv("habitat data.csv")
## print out first 6 lines
head(habitat)
## print out column names
names(habitat) 

weight<- pet.data$wt
leng <- pet.data$length

pet.data$leng.wt <- pet.data$wt / pet.data$length

weight<- pet.data$wt
leng <- pet.data$length
pet.data$leng.wt <- weight / leng

## Write a tab delimited file to working directory
write.table(pet.data, "Look and me.txt", sep = "\t")

## Write a comma delimited file to working directory
write.table(pet.data, "Look and me.csv", sep = ",")
## Write a comma delimited file to working directory
write.csv(pet.data, "Look and me too.csv")
