#lit review demo
#Rosemary Hartman, DWR, 2026-11-12
#Based on code from Matt Young, USGS
library(httr)
library(jsonlite)
library(dplyr)
library(purrr)
library(roadoi)
library(R.utils)
library(tidyverse)


#function to get articles from Cross REf with a given journal

my_email <- "rosemary.hartman@water.ca.gov"  # polite-pool identification -- replace with your email
ua <- user_agent(paste0("refs-fetcher/1.0 (mailto:", my_email, ")"))

from_date <- "2003-01-01"
until_date <- "2025-12-31"

## ---- Strategy 1: everything Crossref has for the SFEWS journal ----

fetch_journal_works <- function(query_title, from_date, until_date, rows = 1000) {
  resp <- GET(
    "https://api.crossref.org/works",
    ua,
    query = list(
      "query.container-title" = query_title,
      "filter" = paste0("from-pub-date:", from_date, ",until-pub-date:", until_date),
      "rows"   = rows,
      "select" = "DOI,title,author,abstract,issued,container-title,short-container-title"
    )
  )
  stop_for_status(resp)
  fromJSON(content(resp, as = "text", encoding = "UTF-8"), flatten = TRUE)$message$items
}

sfews_items <- fetch_journal_works("San Francisco Estuary and Watershed Science", from_date, until_date, rows = 1000)



#use OA DOI to get URLs for any pdfs
result_urls = oadoi_fetch(sfews_items$DOI, "Rosemary.Hartman@water.ca.gov", .flatten = TRUE)

#organize results so I just have one URL for each article with a URL
result_urls2 = result_urls %>%
  filter(!is.na(url_for_pdf)) %>%
  arrange(is_best) %>%
  group_by(doi) %>%
  slice_head() %>%
  ungroup()

#download the files
for(i in 1:nrow(result_urls2)){
  downloadFile(result_urls2$url_for_pdf[i],
               path  = getwd())
}


#now search everything in that folder for the words "ecosystem health"
#path to the folder with all the files
pdfdirectory = paste(getwd(), "/litpdf", sep ="")

#list of all the pdfs in the folder
files = list.files(pdfdirectory, recursive =T, pattern = "*.pdf")

#path to all the files
pdf_files = paste(pdfdirectory, "/", files, sep = "")

#empty vector to store failed files
failed_files <- character()

#apply to all the files
results <- lapply(pdf_files, function(f) {
  
  #trycatch stops errors from olding things up
  tryCatch({ 
    result = R.utils::withTimeout( #timeout allows it to move on if it hangs up
      keyword_search(
        f,
        path = TRUE,
        keyword = c("healthy ecosystem","ecosystem health", "healthy Delta ecosystem", 
                    "watershed health", "healthy estuary"),
        ignore_case = TRUE,
        token_results = FALSE
      ),
      timeout = 30,
      onTimeout = "error"
    )
    print(f)
    result = mutate(result, file = f,
                    Title = pdf_info(f)$keys$Title)
    return(result)
    
  }, error = function(e) {
    
    message("Skipping: ", basename(f))
    failed_files = c(failed_files, f)
    return(NULL)
    
  })
})

resultsdf = bind_rows(results) %>%
  mutate(file = str_remove(file, endnote_directory)) %>%
  select(keyword, file, Title) %>%
  distinct()

write.csv(resultsdf, file = "resultsdf_sfews.csv", row.names = F)


