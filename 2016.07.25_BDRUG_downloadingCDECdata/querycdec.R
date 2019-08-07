querycdec = function(station_id)
{
  # This function will print out metadata for a CDEC station.
  # Just enter the station you are interested in as "BSF"
  
  # Load required library:
  library(rvest)
  
  # Make URL:
  url = paste("http://cdec.water.ca.gov/cgi-progs/staMeta?station_id=",station_id, sep = '')
  # Read URL:
  file = read_html(url)
  
  # Extract table data:
  tables = html_nodes(file, "table")
  
  if(length(tables) == 0)
  {
    print('No site information avialable, check for correct site code')
    stop()
  }
  table1 = data.frame(html_table(tables[1], fill = TRUE))
  table2 = data.frame(html_table(tables[2], fill = TRUE))

  # Name table columns:
  names(table2)[1]<-paste("Sensor")
  names(table2)[2]<-paste("Sensor ID number")
  names(table2)[3]<-paste("Shortest duration of measure")
  names(table2)[4]<-paste("Sensor abreviation")
  names(table2)[5]<-paste("Type of measurement")
  names(table2)[6]<-paste("Time available")
  
  # Center data for printing:
  name.width <- max(sapply(names(table2), nchar))
  names(table2) <- format(names(table2), width = name.width, justify = "centre")
  format(table2, width = name.width, justify = "centre")
  
  # Print data to screen... displays best with wide screen... 
  print('**********************************************************')
  print(paste('SITE METADATA'))
  print('**********************************************************')
  print(paste(table1[1,1],' is ',table1[1,2]))
  print(paste(table1[2,1],' is ',table1[2,2]))
  print(paste(table1[3,1],' is ',table1[3,2]))
  print(paste(table1[2,3],' is ',table1[2,4]))
  print(paste(table1[3,3],' is ',table1[3,4]))
  print(paste(table1[1,3],' is ',table1[1,4]))
  print(paste(table1[4,1],' is ',table1[4,2]))
  print(paste(table1[4,3],' is ',table1[4,4]))
  print('**********************************************************')
  print(paste('There following data are available at this site'))
  print('**********************************************************')
  print(table2)

  # clean up:
  rm('url', 'file', 'tables', 'table1', 'table2')
  
}