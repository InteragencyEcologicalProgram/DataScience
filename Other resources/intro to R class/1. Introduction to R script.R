
fish.wt = 10
fish.length = 150
fish.condition = fish.length/fish.wt
fish.condition
ls()

# This program calculates the goofy Peterson condition factor
fish.wt = 10
fish.length = 150
## here's the formula..., pure genius
fish.condition = fish.length/fish.wt
fish.condition
ls()

# This program calculates the goofy Peterson condition factor
fish.wt = 10
fish.length = 150
## here's the formula..., pure genius
fish.condition = fish.length/fish.wt
#fish.condition
ls()


setwd("G:/Jims class stuff/RRRR") ## NOTICE USE OF FORWARD SLASH
# This program calculates the goofy Peterson and Colvin condition factor
fish.wt = 10
fish.length = 150
## here's the formula..., pure genius
fish.condition = fish.length/fish.wt
fish.condition
ls()


setwd("G:\\Jims class stuff\\RRRR") ## NOTICE USE OF DOUBLE BACKSLASH
# This program calculates the goofy Peterson and Colvin condition factor
fish.wt = 10
fish.length = 150
## here's the formula..., pure genius
fish.condition = fish.length/fish.wt
fish.condition
ls()


setwd("G:\\Jims class stuff\\RRRR")
# This program calculates the goofy Peterson and Colvin condition factor
fish.wt = 10
fish.length = 150
## here's the formula..., pure genius
fish.condition = fish.length/fish.wt
fish.condition
ls()
### Here's where we save everything
save.image(file = "firstRclass.Rdata")


### Here's where we save just 2 objects
save(file = "firstRclass.Rdata", list = c("fish.condition","fish.wt"))

load("firstRclass.Rdata")

# Load objects from existing file, full path edition
load("G:\\Jims class stuff\\RRRR\\firstRclass.Rdata")

