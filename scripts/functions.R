# This script stores all the functions
library(dplyr)
library(tidyr)
library(rvest)

# Function that gets proxies from proxy site
# Return a vector of 20 proxies
getProxies_ <- function(){
  url <- "https://www.us-proxy.org/"
  page <- read_html(url)
  proxy_df <- page %>% html_node("table") %>%
    html_table()
  proxy_df <- proxy_df[1:20,]
  proxy_df$Https <- ifelse(proxy_df$Https == "no", "http://", "https://")
  proxy_df <- proxy_df %>% select(Https, `IP Address`, Port)
  proxy_df$Port <- paste0(":", proxy_df$Port)
  proxy_df <- unite(proxy_df, proxy, c(Https, `IP Address`, Port), sep = "")
  return(as.character(proxy_df[,1]))
}


# Function that dynamically to use proxy to read html
readHtml <- function(targerURL){
  proxies <- getProxies_()
  proxy_index <- 1
  while (proxy_index <= length(proxies) + 1){
    if (proxy_index == length(proxies) + 1){
      print("Used up all proxies. Get a new set of proxies.")
      proxies <- getProxies_()
      proxy_index <- 1
    }else{
      set_config(use_proxy(proxies[proxy_index]))
      webpage <- try(read_html(targerURL), silent = TRUE)
      if (class(webpage)[1] != "try-error"){
        print(paste0("Successfully read html with proxy number ", 
                   proxy_index, ": ", proxies[proxy_index]))
        return(webpage)
      } else{
        print(paste0("Failure! Tried proxy number ", proxy_index, ": ", proxies[proxy_index]))
        print("Try the next proxy.")
        proxy_index <- proxy_index + 1
      }
    }
  }
}

parseAttribute <- function(chunk, class){
  value <- try(chunk %>% html_node(paste0('[class = ', "'", class, "'", ']')) %>% html_text(trim = TRUE))
  if (class(value)[1] != "try-error"){
    return(value)
  } else{
    return(NA)
  }
}
  
  
  
  
  
  
