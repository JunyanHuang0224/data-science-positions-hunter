# This script scrapes the data science positions in websites: 
# LinkedIn, Indeed, Monster, Glassdoor and Zip Recruiter

# Use proxy
library(httr)
library(rvest)
library(base)

setwd("D:/STUDY/Github/COPD-Prediction-In-R/data-science-positions-hunter")

source("scripts/functions.R")

# Loop to use the proxies in the list.
# If the proxy fails to work, use the next proxy
# When the last proxy fails, use the get_proxies function to get new list of proxies

generalURL <- "https://www.indeed.com/jobs?as_and=data+scientist&as_phr=&as_any=&as_not=&as_ttl=&as_cmp=&jt=all&st=&as_src=&salary=&radius=25&l=Gaithersburg%2C+MD&fromage=15&limit=50&sort=date&psf=advsrch&from=advancedsearch"

# Read the general page
generalpage <- readHtml(generalURL)

# Get the chunks of jobs 
job_chunks <- generalpage %>% html_nodes("[class = 'jobsearch-SerpJobCard unifiedRow row result']")

# Parse the details of each job chunk
job_df <- data.frame(Title = character(),
                     Company = character(),
                     Rating = double(),
                     Location = character(),
                     Salary = character(),
                     Easy_Apply = character(),
                     Summary = character(),
                     Date = character(),
                     URL = character(),
                     stringsAsFactors = FALSE)
for (i in seq_along(job_chunks)){
  job_df[i, 1] <- parseAttribute(job_chunks[i], "title")
  job_df[i, 2] <- parseAttribute(job_chunks[i], "company")
  job_df[i, 3] <- parseAttribute(job_chunks[i], "ratingsContent")
  job_df[i, 4] <- parseAttribute(job_chunks[i], "location accessible-contrast-color-location")
  job_df[i, 5] <- parseAttribute(job_chunks[i], "salarySnippet holisticSalary")
  job_df[i, 6] <- parseAttribute(job_chunks[i], "iaLabel ")
  job_df[i, 7] <- parseAttribute(job_chunks[i], "summary")
  job_df[i, 8] <- parseAttribute(job_chunks[i], "date ")
  job_df[i, 9] <- job_chunks[i] %>% html_node("[class = 'title']") %>% html_node("a") %>% html_attr("href")
}









