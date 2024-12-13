###Code Lowrance GPX files to compare with Database

library(tidyverse)
install.packages("gpx")
library(gpx)
library(odbc)
library(here)
library(dplyr)
library(tidyr)
library(sf)
library(lubridate)
library(XML)
library(DBI)
install.packages('compareDF'); library('compareDF')
edsm_unique_output <- TRUE
#Format output
edsm_start_time=format(Sys.time(), "%Y-%m-%d_%H%M")

# File Paths --------------------------------------------------------------
if(edsm_unique_output==TRUE) {
  out_path <- paste("./data/",edsm_start_time,"EDSM/", sep="")
  dir.create(out_path)
} else {
  out_path <- "./"
}


## Retrieve data and store locally, if desired

## Kodiak:
kdtr_con <-
                            
# odbc::dbListTables(conn=kdtr_con)
date_start <- "2023-11-27"    
date_end <- "2024-06-06"    
kdtr_sample_station1 <- DBI::dbGetQuery(conn=kdtr_con,
                                        statement="SELECT Sample_Station.*, Sample.SampleDate 
              FROM Sample_Station LEFT JOIN Sample ON 
                     Sample_Station.SampleID = Sample.SampleID;")

EDSM_Effort_A_query <- gsub("[\r\n]"," ", sprintf("
SELECT Sample.SampleID, ref_region.RegionCode AS Region, 
ref_subregion.SubRegion AS SubRegion, ref_stratum_code.Stratum AS Stratum, 
Sample_Station.StationCode AS Station, 
Sample.SampleDate AS [Date], Sample.SampleTime AS [Time], 
Sample.WeatherCode AS Wthr, Sample_Station.TowMax AS tow_max, 
Sample_Station.Latitude AS target_latitude, Sample_Station.Longitude AS target_longitude, 
Sample_Station.LatitudeStart AS StartLat, Sample_Station.LongitudeStart AS StartLong, 
Sample_Station.LatitudeEnd AS StopLat, Sample_Station.LongitudeEnd AS StopLong, 
Sample.DO, Sample.SpecificConductance AS EC, Sample.WaterTemp AS Temp, 
Sample.Turbidity AS Turb, Sample.TurbidityFNU AS TurbFNU, Sample.YsiSerialNo AS [YSI#], Sample.HatchSerialNo AS [Turb#], 
Sample.GearCode AS [Gear#], Sample.GearConditionCode AS Cond, 
Sample.MeterSerialNo AS [Flow#], Sample.TowNumber AS Tow, Sample_Station.PairedStudies AS paired_studies, 
Sample_Station.BottomDepth AS start_depth, Sample.TowDuration AS Dur, Sample.SamplingDirection AS Dir, 
Sample.Secchi AS Scchi, Sample.FlowmeterStart AS StartMeter, Sample.FlowmeterEnd AS EndMeter, Sample.FlowmeterDifference AS TotalMeter, 
[FlowmeterDifference]*12.54*0.026873 AS RawVolume, 
Sample.FlowDebris AS Debris, Sample.Comments, 
Sample.Tide AS TideCode 
FROM (((Sample INNER JOIN Sample_Station ON Sample.SampleID = Sample_Station.SampleID) 
INNER JOIN ref_subregion ON Sample_Station.SubRegionID = ref_subregion.SubRegionID) 
INNER JOIN ref_stratum_code 
ON Sample_Station.Stratum = ref_stratum_code.Stratum) 
INNER JOIN ref_region ON Sample_Station.RegionID = ref_region.RegionID
WHERE Sample.MethodCode = 'edsm' AND Sample.SampleDate BETWEEN '%s' AND '%s' 
ORDER BY Sample.SampleDate, Sample.SampleTime;", date_start, date_end))

EDSM_Effort_A <- DBI::dbGetQuery(conn=kdtr_con, statement=EDSM_Effort_A_query)

DBI::dbDisconnect(conn=kdtr_con)

###format data to match Lowrance GPX naming for easier comparison
EDSM_Effort<- EDSM_Effort_A %>%
  select(Station,Date,Time,Tow,StartLat, StartLong,StopLat,StopLong) %>%
  mutate(Station = paste(Station, Tow, sep = "-"),
         StartLat = round(StartLat, 5),
         StartLong = round(StartLong, 5),
         StopLong = round(StopLong, 5),
         StopLat = round(StopLat, 5)
         )


EDSM_startcoords <- EDSM_Effort %>%
  select(Station,Date, StartLat,StartLong,) %>%
  mutate(Station=paste0(Station,"S"))

EDSM_stopcoords <- EDSM_Effort %>%
  select(Station,Date,StopLat,StopLong,) %>%
  mutate(Station=paste0(Station,"E"))




# # or:
# data1 <- dplyr::bind_rows(lapply(gpx_files, function(x) { read_gpx(x)$waypoints }))
# ########


########
gpx_files <- list.files("GPX23Jan_Jun", pattern = "\\.gpx$", full.names = TRUE)[1:60]
gpx_list <- list()
for(i in seq(gpx_files)) {
  gpx_list[[i]] <- read_gpx(gpx_files[i])$waypoints
}
gpx_df <- dplyr::bind_rows(gpx_list)
gpx_df<- gpx_df %>%mutate( DateTime=ymd_hms(Time),
                          Date= as.Date(DateTime),
                          Time=format(DateTime, "%H:%M:%S"))%>%
                  select(-Time)


gpx_df<- gpx_df %>%
  rename(Station=Name) %>%
  mutate(Latitude = round(Latitude, 5),
         Longitude = round(Longitude, 5),
         StartLat = ifelse(grepl("S$", Station, ignore.case = TRUE), Latitude, NA),
         StopLat = ifelse(grepl("E$", Station, ignore.case = TRUE), Latitude, NA),
         StartLong = ifelse(grepl("S$", Station, ignore.case = TRUE), Longitude, NA),
         StopLong = ifelse(grepl("E$", Station, ignore.case = TRUE), Longitude, NA),
         Latitude = round(Latitude, 5),
         Longitude = round(Longitude, 5))
        



write.csv(gpx_df, file.path("data","gpx_df.csv"),
          row.names=FALSE)


gpx_start<- gpx_df %>%
  filter(grepl("S$", Station)) %>%
  select(Station,Date,StartLat,StartLong)
  
gpx_stop<- gpx_df %>%
  filter(grepl("E$", Station)) %>%
  select(Station,Date,StopLat,StopLong)


##Compare function
#startCoord
edsm_StartCoord_output <- compareDF::compare_df(
  gpx_start,
  EDSM_startcoords,
  group_col = c("Station"),
  tolerance = 0,
  tolerance_type = "difference",
  keep_unchanged_cols = TRUE,
  stop_on_error = FALSE,
  change_markers = c("GPX", "SQL")
)

edsm_startcoord_comparison_file <- paste0(out_path, edsm_start_time,
                                     "edsm_gpx_startcoord_results.xlsx")
compareDF::create_output_table(edsm_StartCoord_output,
                               output_type = "xlsx",
                               file_name = edsm_startcoord_comparison_file,
                               limit = 1000,
                               color_scheme = c(addition = "#D81B60",
                                                removal = "#0088FF",
                                                unchanged_cell = "#999999",
                                                unchanged_row = "#293352"))


##STOP COORD
edsm_StopCoord_output <- compareDF::compare_df(
  gpx_stop,
  EDSM_stopcoords,
  group_col = c("Station"),
  tolerance = 0,
  tolerance_type = "difference",
  keep_unchanged_cols = TRUE,
  stop_on_error = FALSE,
  change_markers = c("GPX", "SQL")
)
edsm_stopcoord_comparison_file <- paste0(out_path, edsm_start_time,
                                          "edsm_gpx_stopcoord_results.xlsx")
compareDF::create_output_table(edsm_StartCoord_output,
                               output_type = "xlsx",
                               file_name = edsm_stopcoord_comparison_file,
                               limit = 1000,
                               color_scheme = c(addition = "#D81B60",
                                                removal = "#0088FF",
                                                unchanged_cell = "#999999",
                                                unchanged_row = "#293352"))

















