# clear workspace
rm(list = ls())

#set working directory
setwd("C:/Users/andrew.pike/Documents/R/cdec")
curdir = paste(getwd())

# install some packages we will use (lubridate for datetimes, rvest for web scraping, and RCurl for accessing websites)
install.packages("lubridate")
install.packages("rvest")
install.packages("RCurl")

# load some libraries
library(readxl)
library(lubridate)
library(rvest)
library(RCurl)

# source functions
source("getcdec.r")
source("querycdec.r")

# Look for a station:
# Just type in code of station... little waring if no station with that ID exists.
querycdec('BSF')

# Download data from that station:
# variable are in the following order: Station ID, Sensor #, Duration, StartDate, EndDate, SaveFile (y/n), Min, Max for quick filter.
TempData = getcdec('BSF','25', 'H', "2015-6-22-23","2015-9-23")
TempData = getcdec('WLK','20', 'E', "2007-10-01-00","2009-10-02-00")

