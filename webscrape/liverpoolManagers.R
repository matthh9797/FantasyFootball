## WEBSCRAPPING LIVERPOOL MANAGER LIST
library(rvest)
temp <- url %>% html %>% html_nodes("table")
temp
livManagers <- html_table(temp[3], fill = TRUE)
# html table is list of 1 containg the table
livManagers <- livManagers[[1]]
# first column was repeat of names
livManagers <- livManagers[2:23,]
library(dplyr)
livManagers <- as.tbl(livManagers)
livManagers <- livManagers %>% mutate(From = as.POSIXlt.Date(From),
                                      To = as.POSIXlt.Date(To))