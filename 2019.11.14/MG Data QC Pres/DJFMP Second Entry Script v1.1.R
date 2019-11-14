# Target Dates ------------------------------------------------------------
date_start <- "2018-08-01"
date_end <- "2019-07-31"
target_database <- "DoubleEntry_FY2019.accdb"

# Settings ----------------------------------------------------------------
saved_table <- FALSE
code_4 <- TRUE 
site_na_convert <- TRUE
unique_output <- TRUE
show_names <- TRUE
first_entry_search <- FALSE
first_entry_name <- ""
second_entry_search <- FALSE
second_entry_name <- ""

# Server Information ------------------------------------------------------
sql_driver_str <- "SQL Server"
djfmp_user_id <- "djfmpreader"
djfmp_user_password <- "d1fmpR0ad3rPr0d"
first_entry_server_name <- "ifw9bct-sqlha1"

# Time --------------------------------------------------------------------
start_time=format(Sys.time(), "%Y-%m-%d_%H_%M")

# File Paths --------------------------------------------------------------
unique_path <- paste("./Output/",start_time,"DJFMP/", sep="")
if (unique_output==TRUE) {
        dir.create(unique_path)
}

# Library -----------------------------------------------------------------
if (!require('odbc')) install.packages('odbc'); library('odbc')
if (!require('dplyr')) install.packages('dplyr'); library('dplyr') 
if (!require('tidyr')) install.packages('tidyr'); library('tidyr') 
if (!require('compareDF')) install.packages('compareDF'); library('compareDF') 
if (!require('lubridate')) install.packages('lubridate'); library('lubridate') 
if (!require('devtools')) install.packages('devtools'); library('devtools') 
if (!require('here')) install.packages('here'); library('here') 

# Custom Functions --------------------------------------------------------
'%!in%' <- function(x,y)!('%in%'(x,y))

getstr = function(mystring, initial.character, final.character)
{         snippet = rep(0, length(mystring))
        for (i in 1:length(mystring))
        {
                initial.position = gregexpr(initial.character, mystring[i])[[1]][1] + 1
                final.position = gregexpr(final.character, mystring[i])[[1]][1] - 1
                snippet[i] = substr(mystring[i], initial.position, final.position)
        }
        return(snippet)
}

# Open Database Connections -----------------------------------------------
first_entry_con <- odbc::dbConnect(drv=odbc::odbc(), 
											 						         driver=sql_driver_str, 
																	         server=first_entry_server_name,
																	         uid=djfmp_user_id, 
																	         pwd=djfmp_user_password)

second_entry_db_string <- paste0("Driver={Microsoft Access Driver (*.mdb, *.accdb)};",
                                 "Dbq=", "M:\\IEP\\rdbms\\DJFMP\\DJFMP Database\\",
																 paste0("Current Access Applications\\",target_database))
second_entry_con <- DBI::dbConnect(drv=odbc::odbc(), 
																	         .connection_string=second_entry_db_string)

# Import Sample Data ------------------------------------------------------
first_sample_date_query <- gsub("[\r\n]"," ", sprintf("
		SELECT *
		FROM Sample
		WHERE SampleDate BETWEEN '%s' AND '%s';
", date_start, date_end))

first_sample_date_table <- DBI::dbGetQuery(conn=first_entry_con, 
																		 statement=first_sample_date_query)

second_sample_query <- "SELECT * FROM Sample1;"

second_sample_table <- DBI::dbGetQuery(conn=second_entry_con, statement=second_sample_query)

# Wrangle Sample Data -----------------------------------------------------
first_sample_date_table<-first_sample_date_table[!grepl("EDSM", first_sample_date_table$MethodCode),]
second_sample_date_table<-second_sample_table[!grepl("EDSM", second_sample_table$MethodCode),]

second_sample_date_table <- second_sample_table %>%
        filter(SampleDate >= date_start & SampleDate <= date_end)

second_sample_date_table <- second_sample_table %>%
  filter(SampleDate >= date_start & SampleDate <= date_end)


second_sample_date_table$SampleTime <- substr(second_sample_date_table$SampleTime, 11, 20) 
second_sample_date_table$SampleDate <- as.character(second_sample_date_table$SampleDate)

first_sample_date_table<-first_sample_date_table[order(first_sample_date_table$SampleDate, first_sample_date_table$SampleTime),]
second_sample_date_table<-second_sample_date_table[order(second_sample_date_table$SampleDate, second_sample_date_table$SampleTime),]
levels(first_sample_date_table$ID) <- unique(first_sample_date_table$ID)
levels(second_sample_date_table$ID) <- unique(second_sample_date_table$ID)

# Adding ID's -------------------------------------------------------------
first_sample_date_table$ID <- paste(first_sample_date_table$StationCode,first_sample_date_table$SampleDate,first_sample_date_table$SampleTime)
first_sample_date_table$ID <- as.factor(first_sample_date_table$ID)
second_sample_date_table$ID <- paste(second_sample_date_table$StationCode,second_sample_date_table$SampleDate,second_sample_date_table$SampleTime)
second_sample_date_table$ID<-as.factor(second_sample_date_table$ID)

# Linking SampleID and ID -------------------------------------------------
first_IDs <- data.frame("StationCode"=first_sample_date_table$StationCode, "SampleDate"=first_sample_date_table$SampleDate, "SampleTime"=first_sample_date_table$SampleTime,"SampleID"=first_sample_date_table$SampleID, "first_entry"=first_sample_date_table$created_by)
second_IDs <- data.frame("StationCode"=second_sample_date_table$StationCode, "SampleDate"=second_sample_date_table$SampleDate, "SampleTime"=second_sample_date_table$SampleTime,"Sample1ID"=second_sample_date_table$Sample1ID, "second_entry"=second_sample_date_table$created_by)

first_IDs$SampleTime<-lubridate::hms(first_IDs$SampleTime)
second_IDs$SampleTime<-lubridate::hms(second_IDs$SampleTime)
first_IDs$SampleDate <- as.Date(first_IDs$SampleDate)
second_IDs$SampleDate <- as.Date(second_IDs$SampleDate)
first_IDs$SampleTime<-lubridate::hms(first_IDs$SampleTime)
second_IDs$SampleTime<-lubridate::hms(second_IDs$SampleTime)
first_IDs$ID<-paste(first_IDs$StationCode,first_IDs$SampleDate,first_IDs$SampleTime)
second_IDs$ID<-paste(second_IDs$StationCode,second_IDs$SampleDate,second_IDs$SampleTime)

# Trim Unused Columns -----------------------------------------------------
first_sample_date_table<-first_sample_date_table[, intersect(colnames(second_sample_date_table), colnames(first_sample_date_table))]
second_sample_date_table<-second_sample_date_table[, intersect(colnames(first_sample_date_table), colnames(second_sample_date_table))]
first_sample_date_table$created_by <- NULL
first_sample_date_table$created_on <- NULL
first_sample_date_table$isSite <- NULL
first_sample_date_table$Username <- NULL
second_sample_date_table$created_by <- NULL
second_sample_date_table$created_on <- NULL
second_sample_date_table$isSite <- NULL
second_sample_date_table$Username <- NULL

# Compile Personnel Information ------------------------------------------
entry1 <- data.frame("ID"=first_IDs$ID, "first_entry"=first_IDs$first_entry)
entry2 <- data.frame("ID"=second_IDs$ID, "second_entry"=second_IDs$second_entry)
master_entry <- merge(entry1, entry2, by=c("ID"))
master_entry$first_entry <- getstr(master_entry$first_entry, '_', '@')
master_entry$second_entry <- tolower(master_entry$second_entry)

# Handle Code 4's ---------------------------------------------------------
if (code_4==FALSE) {first_sample_date_table <- filter(first_sample_date_table, first_sample_date_table$GearConditionCode!=4)}

if (code_4==FALSE) {second_sample_date_table <- filter(second_sample_date_table, second_sample_date_table$GearConditionCode!=4)}

# Combine, Format, and Split ----------------------------------------------
first_sample_date_table$Entry <-1
second_sample_date_table$Entry <-2
combined_table <- rbind (first_sample_date_table, second_sample_date_table)
combined_table$SampleTime<-lubridate::hms(combined_table$SampleTime)
combined_table$SampleDate <- as.Date(combined_table$SampleDate)
combined_table$SampleDate<-lubridate::ymd(combined_table$SampleDate)
combined_table$ID <- paste(combined_table$StationCode,combined_table$SampleDate,combined_table$SampleTime)
first_sample_date_table<- filter(combined_table, Entry==1)
second_sample_date_table<- filter(combined_table, Entry==2)

# Identify Orphan Samples -------------------------------------------------
first_orphan <- setdiff(first_sample_date_table$ID,second_sample_date_table$ID)
second_orphan<- setdiff(second_sample_date_table$ID, first_sample_date_table$ID)
first_sample_date_table <- filter(first_sample_date_table, first_sample_date_table$ID %!in% first_orphan)
second_sample_date_table <- filter(second_sample_date_table, second_sample_date_table$ID %!in% second_orphan)

if (unique_output==FALSE){ 
        write.csv(first_orphan, "./output/first_orphan.csv")
}

if (unique_output==TRUE) {
        first_orphan_file <- paste(unique_path,start_time,"first_orphan.csv", sep="")
        write.csv(first_orphan, first_orphan_file)
}

if (unique_output==FALSE){ 
        write.csv(second_orphan, "./output/second_orphan.csv")
}

if (unique_output==TRUE) {
        second_orphan_file <- paste(unique_path,start_time,"second_orphan.csv", sep="")
        write.csv(second_orphan, second_orphan_file)
}


first_IDs <- filter(first_IDs, first_IDs$ID %!in% first_orphan)
second_IDs <- filter(second_IDs, second_IDs$ID %!in% second_orphan)

# Add Data Entry Tech -----------------------------------------------------
first_sample_date_table<- merge(first_sample_date_table, master_entry, by="ID")
second_sample_date_table<- merge(second_sample_date_table, master_entry, by="ID")

# Import Catch Data -------------------------------------------------------
if ((file.exists("./data/table1catch.csv")) & (file.info("./data/table1catch.csv")$mtime+100000<Sys.time()) | saved_table==FALSE) {
        unlink("./data/table1catch.csv")
  }
if (file.exists("./data/table1catch.csv")) {
        first_catch_table<-read.csv("./data/table1catch.csv")
} 
if (!file.exists("./data/table1catch.csv")) {
        first_catch_query <- "SELECT * FROM Catch;"
        first_catch_table <- DBI::dbGetQuery(conn=first_entry_con, statement=first_catch_query)
        write.csv(first_catch_table, "./data/table1catch.csv")
}

second_catch_query <- "SELECT * FROM Catch1;"
second_catch_table <- DBI::dbGetQuery(conn=second_entry_con, statement=second_catch_query)

# Wrangle Catch Data ------------------------------------------------------
first_catch_date_table <- filter(first_catch_table, first_catch_table$SampleID %in% first_IDs$SampleID)
second_catch_date_table <- filter(second_catch_table, second_catch_table$Sample1ID %in% second_IDs$Sample1ID)
colnames(second_IDs)[colnames(second_IDs) == 'Sample1ID'] <- 'SampleID'
colnames(second_catch_date_table)[colnames(second_catch_date_table) == 'Sample1ID'] <- 'SampleID'

first_catch_date_table$Entry<-1
second_catch_date_table$Entry<-2

first_catch_date_table<-first_catch_date_table[, intersect(colnames(second_catch_date_table), colnames(first_catch_date_table))]
second_catch_date_table<-second_catch_date_table[, intersect(colnames(first_catch_date_table), colnames(second_catch_date_table))]
first_catch_date_table<- left_join(first_catch_date_table, first_IDs, "SampleID")
second_catch_date_table<- left_join(second_catch_date_table, second_IDs, "SampleID")

first_catch_date_table <- first_catch_date_table[order(first_catch_date_table$ID),]
second_catch_date_table <- second_catch_date_table[order(second_catch_date_table$ID),]

first_catch_date_table$SampleID<-NULL
second_catch_date_table$SampleID<-NULL

first_catch_date_table$first_entry<- NULL
second_catch_date_table$second_entry<- NULL

first_catch_date_table <- merge (first_catch_date_table, master_entry, by="ID")
second_catch_date_table <- merge (second_catch_date_table, master_entry, by="ID")


# Import Site Detail ------------------------------------------------------
first_site_query <- "SELECT * FROM Site;"
first_site_table <- DBI::dbGetQuery(conn=first_entry_con, statement=first_site_query)

second_site_query <- "SELECT * FROM Site1;"
second_site_table <- DBI::dbGetQuery(conn=second_entry_con, statement=second_site_query)

# Wrangle Site Details ----------------------------------------------------
first_site_date_table <- filter(first_site_table, first_site_table$SampleID %in% first_IDs$SampleID)
colnames(second_site_table)[colnames(second_site_table) == 'Sample1ID'] <- 'SampleID'
second_site_date_table <- filter(second_site_table, second_site_table$SampleID %in% second_IDs$SampleID)
second_site_date_table$Depth <- second_site_date_table$Depth *1.000
first_site_date_table$Entry <- 1
second_site_date_table$Entry <- 2

first_site_date_table<-first_site_date_table[, intersect(colnames(second_site_date_table), colnames(first_site_date_table))]
second_site_date_table<-second_site_date_table[, intersect(colnames(first_site_date_table), colnames(second_site_date_table))]
first_site_date_table<- left_join(first_site_date_table, first_IDs, "SampleID")
second_site_date_table<- left_join(second_site_date_table, second_IDs, "SampleID")


first_site_date_table$first_entry<- NULL
second_site_date_table$second_entry<- NULL


first_site_date_table <- merge (first_site_date_table, master_entry, by="ID")
second_site_date_table <- merge (second_site_date_table, master_entry, by="ID")

if (site_na_convert==TRUE){
    first_site_date_table[is.na(first_site_date_table)] <- 0
second_site_date_table[is.na(second_site_date_table)] <- 0
        }

# Constrain to Entry Tech -------------------------------------------------
first_entry_name <- tolower(first_entry_name)
second_entry_name <- tolower(second_entry_name)

if (first_entry_search == TRUE & second_entry_search ==TRUE) {
        first_sample_date_table <- filter(first_sample_date_table, first_entry==first_entry_name & second_entry== second_entry_name)       
}

if (first_entry_search== TRUE & second_entry_search== FALSE) {
        first_sample_date_table <- filter(first_sample_date_table, first_entry==first_entry_name)       
}

if (first_entry_search== FALSE & second_entry_search == TRUE) {
        first_sample_date_table <- filter(first_sample_date_table, second_entry==second_entry_name)
}

if (first_entry_search == TRUE & second_entry_search ==TRUE) {
        second_sample_date_table <- filter(second_sample_date_table, first_entry==first_entry_name & second_entry== second_entry_name)       
}

if (first_entry_search== TRUE & second_entry_search== FALSE) {
        second_sample_date_table <- filter(second_sample_date_table, first_entry==first_entry_name)       
}

if (first_entry_search== FALSE & second_entry_search == TRUE) {
        second_sample_date_table <- filter(second_sample_date_table, second_entry==second_entry_name)
}

if (first_entry_search == TRUE & second_entry_search ==TRUE) {
        first_catch_date_table <- filter(first_catch_date_table, first_entry==first_entry_name & second_entry== second_entry_name)       
}

if (first_entry_search== TRUE & second_entry_search== FALSE) {
        first_catch_date_table <- filter(first_catch_date_table, first_entry==first_entry_name)       
}

if (first_entry_search== FALSE & second_entry_search == TRUE) {
        first_catch_date_table <- filter(first_catch_date_table, second_entry==second_entry_name)
}

if (first_entry_search == TRUE & second_entry_search ==TRUE) {
        second_catch_date_table <- filter(second_catch_date_table, first_entry==first_entry_name & second_entry== second_entry_name)       
}

if (first_entry_search== TRUE & second_entry_search== FALSE) {
        second_catch_date_table <- filter(second_catch_date_table, first_entry==first_entry_name)       
}

if (first_entry_search== FALSE & second_entry_search == TRUE) {
        second_catch_date_table <- filter(second_catch_date_table, second_entry==second_entry_name)
}

if (first_entry_search == TRUE & second_entry_search ==TRUE) {
        first_site_date_table <- filter(first_site_date_table, first_entry==first_entry_name & second_entry== second_entry_name)       
}

if (first_entry_search== TRUE & second_entry_search== FALSE) {
        first_site_date_table <- filter(first_site_date_table, first_entry==first_entry_name)       
}

if (first_entry_search== FALSE & second_entry_search == TRUE) {
        first_site_date_table <- filter(first_site_date_table, second_entry==second_entry_name)
}

if (first_entry_search == TRUE & second_entry_search ==TRUE) {
        second_site_date_table <- filter(second_site_date_table, first_entry==first_entry_name & second_entry== second_entry_name)       
}

if (first_entry_search== TRUE & second_entry_search== FALSE) {
        second_site_date_table <- filter(second_site_date_table, first_entry==first_entry_name)       
}

if (first_entry_search== FALSE & second_entry_search == TRUE) {
        second_site_date_table <- filter(second_site_date_table, second_entry==second_entry_name)
}

if (show_names==FALSE){
        first_catch_date_table$first_entry <- NULL
        first_catch_date_table$second_entry <- NULL
        second_catch_date_table$first_entry <- NULL
        second_catch_date_table$second_entry <- NULL
        second_site_date_table$first_entry <- NULL
        second_site_date_table$second_entry <- NULL
}

if (show_names==FALSE){
        first_sample_date_table$first_entry <- NULL
        first_sample_date_table$second_entry <- NULL
        second_sample_date_table$first_entry <- NULL
        second_sample_date_table$second_entry <- NULL
}

# Include SampleID --------------------------------------------------------
first_sampleID <- data.frame("ID"=first_IDs$ID, "first_sampleID"=first_IDs$SampleID)
second_sampleID <- data.frame("ID"=second_IDs$ID, "second_sampleID"=second_IDs$SampleID)
master_sampleID <- merge(first_sampleID, second_sampleID, by=c("ID"))


first_sample_date_table$SampleID <- NULL
first_sample_date_table<- merge(first_sample_date_table, master_sampleID, by=c("ID"))
second_sample_date_table<- merge(second_sample_date_table, master_sampleID, by=c("ID"))

first_catch_date_table<- merge(first_catch_date_table, master_sampleID, by=c("ID"))
second_catch_date_table<- merge(second_catch_date_table, master_sampleID, by=c("ID"))

first_site_date_table<- merge(first_site_date_table, master_sampleID, by=c("ID"))
second_site_date_table<- merge(second_site_date_table, master_sampleID, by=c("ID"))

first_site_date_table <- arrange(first_site_date_table, SampleID & Depth)
second_site_date_table <- arrange(second_site_date_table, SampleID & Depth)

# Sample Comparison -------------------------------------------------------
sample_output<-compare_df(first_sample_date_table, second_sample_date_table, c("ID"), limit_html = 100000, tolerance = 0, tolerance_type = "difference", exclude = c("Entry", "SampleDate", "SampleTime", "StationCode", "updated_by", "updated_on","UserName"), keep_unchanged_cols = TRUE, stop_on_error = FALSE)

if(unique_output == FALSE){
        cat(sample_output$html_output, file="./Output/sample_comparison_results.html")
}

if (unique_output == TRUE){
        sample_comparison_file <- paste(unique_path,start_time,"sample_comparison_results.html", sep="")
        cat(sample_output$html_output, file=sample_comparison_file)
}


# Catch Comparison --------------------------------------------------------
catch_output<-compare_df(first_catch_date_table, second_catch_date_table, group_col=c("ID"), limit_html = 100000, tolerance = 0, tolerance_type = "difference", exclude = c("Entry", "TagCode", "RaceByTag", "SampleDate", "SampleTime", "StationCode"), keep_unchanged_cols= TRUE, stop_on_error = FALSE)

if(unique_output==FALSE){
        cat(catch_output$html_output, file="./Output/catch_comparison_results.html")
}

if (unique_output==TRUE){
        catch_comparison_file <- paste(unique_path,start_time,"catch_comparison_results.html", sep="")
        cat(catch_output$html_output, file=catch_comparison_file)
}

# Site Detail Comparison --------------------------------------------------
site_output<-compare_df(first_site_date_table, second_site_date_table, group_col=c("ID"), limit_html = 100000, tolerance = 0, tolerance_type = "difference", exclude = c("Entry", "StationCode", "SampleID", "SampleDate", "SampleTime"), keep_unchanged_cols= TRUE, stop_on_error = FALSE)

if(unique_output==FALSE){
        cat(site_output$html_output, file="./Output/site_comparison_results.html")
}

if (unique_output==TRUE){
        site_comparison_file <- paste(unique_path,start_time,"site_comparison_results.html", sep="")
        cat(site_output$html_output, file=site_comparison_file)
}

# Comparing Catch Counts and Totals ---------------------------------------
first_catch_count<-first_catch_date_table %>%
  group_by(OrganismCode) %>%
  summarize(count=n())
second_catch_count<-second_catch_date_table %>% group_by(OrganismCode) %>% summarize(count=n())

first_catch_sum<-first_catch_date_table %>% group_by(OrganismCode) %>% summarize(sum(CatchCount))
second_catch_sum<-second_catch_date_table %>% group_by(OrganismCode) %>% summarize(sum(CatchCount))

first_catch_lengths<-first_catch_date_table %>% group_by(OrganismCode) %>% summarize(sum(ForkLength))
second_catch_lengths<-second_catch_date_table %>% group_by(OrganismCode) %>% summarize(sum(ForkLength))

catch_diff_summary <- data.frame("Species"=union(first_catch_count$OrganismCode, second_catch_count$OrganismCode), "First Count"=first_catch_count$count, "Second Count"=second_catch_count$count, "Count Difference"=first_catch_count$count-second_catch_count$count, "First Sum"=first_catch_sum$`sum(CatchCount)`, "Second Sum"=second_catch_sum$`sum(CatchCount)`, "Sum Difference"=first_catch_sum$`sum(CatchCount)`-second_catch_sum$`sum(CatchCount)`, "First Lengths"=first_catch_lengths$`sum(ForkLength)`, "Second Lengths"=second_catch_lengths$`sum(ForkLength)`, "Length Difference"=first_catch_lengths$`sum(ForkLength)`-second_catch_lengths$`sum(ForkLength)`)
if (unique_output==FALSE){ 
        write.csv(catch_diff_summary, "./output/catch_diff_summary.csv")
}

if (unique_output==TRUE) {
        catch_diff_file <- paste(unique_path,start_time,"catch_diff_summary.csv", sep="")
        write.csv(catch_diff_summary, catch_diff_file)
}

# Scorecard ---------------------------------------------------------------
if(show_names==TRUE){
        first_sample_scores <- sample_output$comparison_df %>% group_by(first_entry) %>%  summarize (count=n())
        colnames(first_sample_scores)[colnames(first_sample_scores)=="first_entry"] <- "name"
        second_sample_scores <- sample_output$comparison_df %>% group_by(second_entry) %>%  summarize (count=n())
        colnames(second_sample_scores)[colnames(second_sample_scores)=="second_entry"] <- "name"

        first_catch_scores <- catch_output$comparison_df %>% group_by(first_entry) %>%  summarize (count=n())
        colnames(first_catch_scores)[colnames(first_catch_scores)=="first_entry"] <- "name"
        second_catch_scores <- catch_output$comparison_df %>% group_by(second_entry) %>%  summarize (count=n())
        colnames(second_catch_scores)[colnames(second_catch_scores)=="second_entry"] <- "name"

        sample_scores <- left_join (first_sample_scores, second_sample_scores, by= "name", keep=TRUE)
        catch_scores <- left_join (first_catch_scores, second_catch_scores, by= "name", keep=TRUE)

        employee_list <- data.frame(name=unique(c(first_sample_scores$name, second_sample_scores$name, first_catch_scores$name, second_catch_scores$name)))

        combined_scores <- employee_list %>% left_join(first_sample_scores, by="name") %>% left_join(second_sample_scores, by="name") %>% left_join(first_catch_scores,by="name") %>% left_join(second_catch_scores,by="name")
        combined_scores[is.na(combined_scores)] <- 0
        combined_scores$total <- rowSums(combined_scores[2:5])
        colnames(combined_scores) <- c("name", "first_sample", "second sample", "first catch", "second catch", "total")

        if (unique_output==FALSE){ 
                write.csv(combined_scores, "./output/scores.csv")
}

        if (unique_output==TRUE) {
                score_file <- paste(unique_path,start_time,"scores.csv", sep="")
                write.csv(combined_scores, score_file)
}
}

# Disconnect from Databases --------------------------------------
DBI::dbDisconnect(conn=first_entry_con)
DBI::dbDisconnect(conn=second_entry_con)

# Session Information ----------------------------------------------------
writeLines(capture.output(session_info()), "./output/sessionInfo.txt")

###Run Complete############################################