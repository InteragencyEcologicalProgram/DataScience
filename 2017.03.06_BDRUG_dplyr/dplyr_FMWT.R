# Data manipulation with dplyr and tidyr
# Presentation for the Bay-Delta R users Group by Travis Hinkelman
# March 6, 2017
# Note: this presentation piggybacks on Rosemary Hartman's code from August 8, 2016

# First load the required packages
library(tidyverse)      # set of packages designed to work well together; includes dplyr, tidyr, ggplot2, readr
library(lubridate)      # package for working with dates
library(microbenchmark) # benchmark performance of different formulations of code (just for fun)

# First, let's recreate some of the data cleaning that Rosemary performed in the previous script
# But let's do it the dplyr way in one step with chained operations

df = read_csv("FMWT.csv") %>%                                                 # read_csv is similar to read.csv, but stringsAsFactors = FALSE as default and resulting object is a tibble (similar to data.frame)
  gather(key = Species, value = Catch, `Aequorea spp.`:`Yellowfin Goby`) %>%  # change from wide to long format (similar to 'melt' in reshape2)
  filter(Species == "Delta Smelt") %>%                                        # select only rows for Delta Smelt
  mutate(Catch = as.numeric(Catch),                                           # 'Catch' is read in a as a character; need to change to numeric
         Date = mdy(Date),                                                    # convert 'Date' column from character to date
         Date = if_else(year(Date) > Year, Date - years(100), Date))          # 'if_else' is dplyr alternative to 'ifelse'; 'ifelse' doesn't play well with dates                                           

# Select columns ----------------------------------------------------------

# Alternative methods for selecting columns
# in most of the examples, the code just prints the output to the console; it is not overwriting the original data frame
new.df = select(df, Date, Station, Catch)     # select columns
# in following lines, and most examples in this script, the code just prints the output to the console rather than saving with a new name (as done in the previous line)
select_(df, "Date", "Station", "Catch")       # select columns with quoted names
select(df, Date, StartTime = `Start Time`)    # select columns while renaming one column
select(df, Year:Index, Species:Catch)         # select columns with ':'
select(df, -Index:-Turbidity)                 # drop columns
select(df, -`Tow Volume`, -Weather, -Tide)    # drop columns

# select single column
microbenchmark(select(df, Date),              # dplyr
               select_(df, "Date"),           # dplyr (slow)
               subset(df, select = Date),     # base (slow)
               df[,"Date"],                   # base (slow)
               df[["Date"]],                  # base (very fast)
               times = 500)

# select multiple columns
microbenchmark(select(df, Year:Station),                                     # dplyr
               select(df, Year, Date, Survey, Station),                      # dplyr
               select_(df, "Year", "Date", "Survey", "Station"),             # dplyr (very slow)
               subset(df, select = c("Year", "Date", "Survey", "Station")),  # base (very slow)
               subset(df, select = c(Year, Date, Survey, Station)),          # base (slow)
               df[,c("Year", "Date", "Survey", "Station")],                  # base
               times = 500)

# drop multiple columns
microbenchmark(select(df, -Year:-Station),                            # dplyr           
               select(df, -Year, -Date, -Survey, -Station),           # dplyr
               select(df, -c(Year, Date, Survey, Station)),           # dplyr
               subset(df, select = -c(Year, Date, Survey, Station)),  # base (very, very slow)
               times = 500)

# Rename columns ----------------------------------------------------------

rename(df, StartTime = `Start Time`, DepthFT = Depth)                 

# Select rows ----------------------------------------------------------

filter(df, Year %in% seq(1970, 2010, 10) & Catch > quantile(Catch, probs = 0.75))

microbenchmark(filter(df, Year %in% seq(1970, 2010, 10) & Catch > quantile(Catch, probs = 0.75)),     # dplyr
               subset(df, Year %in% seq(1970, 2010, 10) & Catch > quantile(Catch, probs = 0.75)),     # base
               df[df$Year %in% seq(1970, 2010, 10) & df$Catch > quantile(df$Catch, probs = 0.75), ],  # base
               times = 500)

microbenchmark(filter(df, Year > 1990 & Catch > 0),     # dplyr
               subset(df, Year > 1990 & Catch > 0),     # base
               df[df$Year > 1990 & df$Catch > 0, ],     # base
               times = 500)

# Sort data frame ----------------------------------------------------------

arrange(df, -Catch, Year, Station) %>% View()                             # 'View' displays the output in a tab (in RStudio) b/c many of columns won't be printed in console

microbenchmark(arrange(df, -Catch, Year, Station),                        # dplyr
               df[order(-df$Catch, df$Year, df$Station),],                # base
               df[order(-df[["Catch"]], df[["Year"]], df[["Station"]]),], # base
               times = 100)

# Create columns ----------------------------------------------------------

df %>% 
  mutate(Depth = as.numeric(Depth),
         DepthCat = if_else(Depth < median(Depth, na.rm = TRUE), "shallow", "deep")) %>% 
  arrange(-Catch) %>% 
  View()

# base R approach to creating columns
# df$Depth = as.numeric(df$Depth)
# df$DepthCat = if_else(df$Depth < median(df$Depth, na.rm = TRUE), "shallow", "deep")

# Group by ----------------------------------------------------------

# categorize depth based on median depth each year
df %>% 
  group_by(Year) %>% 
  mutate(Depth = as.numeric(Depth),
         DepthCat = if_else(Depth < median(Depth, na.rm = TRUE), "shallow", "deep")) %>% 
  arrange(-Year, -Catch) %>% 
  View()

# calculate the proportion of annual catch
df %>% 
  group_by(Year) %>% 
  mutate(PropCatch = Catch/sum(Catch, na.rm = TRUE)) %>% 
  arrange(-Year, -PropCatch) %>% 
  View()

# Summarise ----------------------------------------------------------

df %>% 
  group_by(Year) %>% 
  summarise(AnnualCatch = sum(Catch, na.rm = TRUE)) %>% 
  View()

# move straight for summarise to plotting without creating any intermediate object
df %>% 
  group_by(Year) %>% 
  summarise(AnnualCatch = sum(Catch, na.rm = TRUE)) %>% 
  ggplot(aes(x = Year, y = AnnualCatch)) +
  geom_line()

# define a custom function for use in mutate_all 
na_zero <- function (x) {
  x[is.na(x)] <- 0
  return(x)
}

df %>%
  filter(!is.na(Microcystis)) %>% 
  group_by(Year, Microcystis) %>% 
  summarise(Catch = sum(Catch, na.rm = TRUE)) %>% 
  spread(key = Microcystis, value = Catch) %>% 
  mutate_all(na_zero)

# Other things that came up ----------------------------------------------------------

# Function for calculating water year from calendar year and month
wy <- function(y, m){
  return(y + ifelse(m >= 10, 1, 0))
}
wy(y = 2016, m = 1:12)
wy(y = year("2016-10-01"), m = month("2016-10-01"))  # 'year' and 'month' are lubridate functions


# Add missing values to a timeseries
# pull out subset of FMWT data
df.ex = df %>% 
  filter(Year == 1967) %>% 
  select(Date, Catch) %>% 
  group_by(Date) %>% 
  summarise(Catch = sum(Catch, na.rm = TRUE)) %>% 
  arrange(Date)
  
# using padr package
library(padr)
df.pad = df.ex %>% 
  pad(start_val = ymd("1967-01-01"), end_val = ymd("1967-12-31")) %>% 
  fill_by_value(Catch, value = NA)

# approach using 'full_join' (similar to 'merge' in base R)
df.fj = df.ex %>%
  full_join(data.frame(Date = seq(from = ymd("1967-01-01"), to = ymd("1967-12-31"), by = 1)))

# using 'bind_rows' (similar to 'rbind' in base R)
# this only works if you want to fill your missing dates with zero catch
df.br = df.ex %>% 
  bind_rows(data.frame(Date = seq(from = ymd("1967-01-01"), to = ymd("1967-12-31"), by = 1), # create sequence of all dates in selected year
                       Catch = 0)) %>%          
  group_by(Date) %>% 
  summarise(Catch = sum(Catch, na.rm = TRUE))

# Repeat rows of a data frame based on a count column (useful for making histograms)
library(mefa)
# make up non-repeating data frame
non.rpt.ex = data_frame(Species = rep(c("A", "B"), 15),
                    ForkLength = round(runif(n = 30, min = 30, max = 100), 0),
                    Count = round(runif(n = 30, min = 1, max = 10), 0))
# use 'rep' from mefa to repeat rows based on 'Count' column
rpt.ex = rep(select(non.rpt.ex, Species, ForkLength), times = non.rpt.ex$Count)

# might be able to avoid repeating data frame depending on need
# weighted mean example
# first, unweighted example based on repeated data frame
rpt.ex %>% 
  group_by(Species) %>% 
  summarise(Mean = mean(ForkLength))
# next, weighted example based on non-repeated data frame
non.rpt.ex %>% 
  group_by(Species) %>% 
  summarise(Mean = weighted.mean(x = ForkLength, w = Count))

