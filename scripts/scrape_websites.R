# This script scrapes the data science positions in websites: 
# LinkedIn, Indeed, Monster, Glassdoor and Zip Recruiter

# Use proxy
library(httr)
set_config(use_proxy("http://75.146.218.153:55768"))

library(rvest)
indeed_url <- "https://www.indeed.com/jobs?q=data+scientist&l=Gaithersburg%2C+MD&radius=50"
indeed_webpage <- read_html(indeed_url)
