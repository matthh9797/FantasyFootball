extractSeason <- function(season, year, json_data. = json_data) {
  ## extract the individual season data from JSON file taken from datahub
  path_to_file <- json_data.$resources$path[season]
  data <- read.csv(url(path_to_file), nrows = 380)
  library(dplyr)
  data <- as.tbl(data)
  data <- data %>% select(2:10) %>% mutate(Season = year)
}
