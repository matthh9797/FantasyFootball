extractSeason <- function(season, json_data. = json_data) {
  path_to_file <- json_data.$resources$path[season]
  data <- read.csv(url(path_to_file))
  library(dplyr)
  select(data, 2:10)
}
