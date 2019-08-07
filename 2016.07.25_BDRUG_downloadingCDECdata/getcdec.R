getcdec = function(station_id, sensor_num, dur_code, start_date, end_date)
{
  # function will load data from cdec website (http://cdec.water.ca.gov/)
  
  # Example:
  # station_id = 'BSF'; sensor_num = '25'; dur_code = 'H'; start_date ='2016-7-21';  end_date = '2016-7-25'; 
  # http://cdec.water.ca.gov/cgi-progs/queryCSV?station_id=BSF&sensor_num=25&dur_code=H&start_date=7-21-2016&end_date=7-25-2016
    
  # load libraries, RCurl (for accessing web data), and lubridate (for time handling)
    library(RCurl)
    library(lubridate)
  
  # convert sensor_num to a character if it is a number
  if (typeof(sensor_num)!="character")
    {sensor_num = as.character(sensor_num)}  
      
  # make url
  url = paste("http://cdec.water.ca.gov/cgi-progs/queryCSV?station_id=", station_id,"&sensor_num=",sensor_num,"&dur_code=",dur_code,"&start_date=",start_date,"&end_date=",end_date,sep = '')

  # connect to url and import
  file = read.csv(textConnection(getURL(url)), skip = 2, colClasses = c("character","character", "numeric"), header = F, na.strings = 'm')
  
  #time zone
  tzone = "America/Los_Angeles"
  
  # format date
  ymd_hms_str = paste(file[,1],file[,2],"00",sep='')
  time = ymd_hms(ymd_hms_str,tz = tzone)
  
  # format values
  data = file[,3]

  # get units... add more as needed
  unit = switch(sensor_num,
                '25' = 'deg F', # temperature
                '20' = 'cfs',   # flow
                '41' = 'cfs',   # mean daily flow
                '15' = 'af',    # storage
                '6'  = 'feet',  # water elevation
                '23' = 'cfs',   # outflow
                '48' = 'cfs',   # discharge power gen
                '71' = 'cfs',   # dischareg spillway
                '1'  = 'ft',    # stage
                '76' = 'cfs')   # reservoir inflow
  
  #newtime and new data
  # get duration for new time vector  
  dur = switch(dur_code,'E' = '15 min','H' = '1 hour', 'D' = '1 day', 'M = 1 month')  
  #make new time vector
  newtime = seq(time[1],tail(time,n=1),by=dur)
  #allocate new data vector
  newdata = matrix(nrow=length(newtime),ncol=1)
  #find overlapping points between time and newtime
  newdata[newtime %in% time] = data[time %in% newtime]
  
  #overwrite time and data
  time = newtime
  data = newdata
  
  #make data frame
  cdec_out = data.frame(station_id, sensor_num, time, data, unit, tzone)
  
  return(cdec_out)

}
