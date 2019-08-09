library(dssrip)
library(ggplot)

#Enter post-processed DSM2 dss file:
dss_file = "rem_naa_q5_roa0_out_ec_PostPro.dss"
#Enter dss file location:
dss_loc = "C:/Users/SM034500/Desktop/DSM2/R-Postprocessing/"

#Enter output location
Loc = "RSAN018"
#Enter output variable
Var = "EC-MEAN"
#Enter output time-step
DT = "1DAY"

#Enter year
year = '1986'


#Open dss file
dss = paste(dss_loc,dss_file,sep="")

dss_open = opendss(dss)

#Create dss path
Path = paste("/*/",Loc,"/",Var,"/*/",DT,"/*/", sep = "")

#Open dss path
Loc_Path = getPaths(dss_open,Path)
Loc_Path_ref = getFullTSC(dss_open,Loc_Path)

#Create data frame from dss data
MODEL_OUTPUT <- data.frame(date=index(Loc_Path_ref), coredata(Loc_Path_ref))

MODEL_OUTPUT[2] = MODEL_OUTPUT[2]/1000

#Create dataframe of reference values/dates for salinity
#YOU STILL NEED TO WORK ON THIS SECTION!
tab_val = c('sd1','ed1','v1','sd2','ed2','v2')
ind_val = c(4,5,6,7,8,9)
ref = data.frame(tab_val,ind_val)

ref[2,2]

sd1 = 4
ed1 = 5
sd2 = 7
ed2 = 8
v1 = 6
v2 = 9

#ec_file = opendss("C:\\Users\\SM034500\\Desktop\\DSM2\\R-Postprocessing\\rem_naa_q5_roa0_out_ec_PostPro.dss")
#MODEL_OUTPUT = getPaths(ec_file,"/*/RSAN018/EC-MIN/*/1DAY/*/")
#MODEL_OUTPUT_ref = getFullTSC(ec_file,MODEL_OUTPUT)
##MODEL_OUTPUT_ref[year]

#Read water year data
WY = read.csv('C:\\Users\\SM034500\\Desktop\\DSM2\\R-Postprocessing\\WY_Data.csv')
WYN = WY[which(WY$YEAR == year), 2]

#Read respective csv file for salinity reference data
#YOU NEED TO SET UP A METHOD TO FIND CORRECT SALINITY DATA FILE BASED ON OUTPUT LOCATION
SAL_DATA = read.csv('C:\\Users\\SM034500\\Desktop\\DSM2\\R-Postprocessing\\D1641_AG.csv')

# Processing Start date 1

#Determine start date of reference salinity
start_date1f <- SAL_DATA[which(SAL_DATA$Location == Loc & SAL_DATA$WYT.1 == WYN), sd1]
#Convert to string
start_date1s <- lapply(start_date1f, as.character)
#Add year
start_date1s <- paste(start_date1s,year,sep="-")
#Convert to date
start_date1 <- as.Date(start_date1s, format = '%d-%b-%Y')

#Processing End date 1

#Determine end date of reference salinity
end_date1f <- SAL_DATA[which(SAL_DATA$Location == Loc & SAL_DATA$WYT.1 == WYN), ed1]
#Convert to string
end_date1s <- lapply(end_date1f, as.character)
#Add year
end_date1s <- paste(end_date1s,year,sep="-")
#Convert to date
end_date1 <- as.Date(end_date1s, format = '%d-%b-%Y')

#Processing Start date 2

#Determine end date of reference salinity
start_date2f <- SAL_DATA[which(SAL_DATA$Location == Loc & SAL_DATA$WYT.1 == WYN), sd2]
#Convert to string
start_date2s <- lapply(start_date2f, as.character)
#Add year
start_date2s <- paste(start_date2s,year,sep="-")
#Convert to date
start_date2 <- as.Date(start_date2s, format = '%d-%b-%Y')

#Processing end date 2

#Determine end date of reference salinity
end_date2f <- SAL_DATA[which(SAL_DATA$Location == Loc & SAL_DATA$WYT.1 == WYN), ed2]
#Convert to string
end_date2s <- lapply(end_date2f, as.character)
#Add year
end_date2s <- paste(end_date2s,year,sep="-")
#Convert to date
end_date2 <- as.Date(end_date2s, format = '%d-%b-%Y')

#Determine regulatory standards for salinity given location and water year
v_1 <- SAL_DATA[which(SAL_DATA$Location == Loc & SAL_DATA$WYT.1 == WYN), v1]
v_2 <- SAL_DATA[which(SAL_DATA$Location == Loc & SAL_DATA$WYT.1 == WYN), v2]

#Plot EC during regulatory standard dates Apr through Aug at given location and water year
start1 = which(as.Date(MODEL_OUTPUT$date) == start_date1)
end1 = which(as.Date(MODEL_OUTPUT$date) == end_date1)
start2 = which(as.Date(MODEL_OUTPUT$date) == start_date2)
end2 = which(as.Date(MODEL_OUTPUT$date) == end_date2)
plot(MODEL_OUTPUT[start1:end2,1],MODEL_OUTPUT[start1:end2,2])

# Plot lines for regulatory standards
X1 = c(MODEL_OUTPUT[start1,1],MODEL_OUTPUT[end1,1])
Y1 = c(v_1,v_1)
X2 = c(MODEL_OUTPUT[start2,1],MODEL_OUTPUT[end2,1])
Y2 = c(v_2,v_2)
X12 = c(MODEL_OUTPUT[end1,1],MODEL_OUTPUT[start2,1])
Y12 = c(v_1,v_2)
#Plots line from start1 to end1
lines(X1,Y1)
#Plots line from start2 to end2
lines(X2,Y2)
#Plots line from end1 to start2
lines(X12,Y12)