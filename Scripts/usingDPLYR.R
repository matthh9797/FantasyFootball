## Script to read in data from datahub on English Premier League results
library("jsonlite")
json_file <- 'https://datahub.io/sports-data/english-premier-league/datapackage.json'
json_data <- fromJSON(paste(readLines(json_file), collapse=""))
# get list of all resources:
print(json_data$resources$name)
# # choose data you want
# path_to_file <- json_data$resources$path[23]
# data <- read.csv(url(path_to_file))
# load dplyr
library(dplyr)
# season 2018/2019
path_to_file <- json_data$resources$path[23]
data <- read.csv(url(path_to_file))
season201819 <- select(data, 2:10)
teams1819 <- sort(unique(data$HomeTeam))
# season 2017/2018
path_to_file <- json_data$resources$path[24]
data <- read.csv(url(path_to_file))
season1718 <- select(data, 2:10)
teams1718 <- unique(data$HomeTeam)
# season 2016/2017
path_to_file <- json_data$resources$path[25]
data <- read.csv(url(path_to_file))
season1617 <- select(data, 2:10)
teams1617 <- unique(data$HomeTeam)

# home and away dataframes 2018/2019
homedata1819 <- group_by(season201819, HomeTeam) %>% summarise(GoalScored=sum(FTHG), GoalAgainst=sum(FTAG))
awaydata1819 <- group_by(season201819, AwayTeam) %>% summarise(GoalScored=sum(FTAG), GoalAgainst=sum(FTHG))
homedata1819 <- mutate(homedata1819, GoalperGame = GoalScored / 19, ConcedeperGame = GoalAgainst / 19)
awaydata1819 <- mutate(awaydata1819, GoalperGame = GoalScored / 19, ConcedeperGame = GoalAgainst / 19)
totalGoal1819 <- c(HomeGoals = sum(homedata1819$GoalScored), AwayGoals = sum(homedata1819$GoalAgainst))

# home and away dataframes 2017/2018
homedata1718 <- group_by(season1718, HomeTeam) %>% summarise(GoalScored=sum(FTHG), GoalAgainst=sum(FTAG))
awaydata1718 <- group_by(season1718, AwayTeam) %>% summarise(GoalScored=sum(FTAG), GoalAgainst=sum(FTHG))
homedata1718 <- mutate(homedata1718, GoalperGame = GoalScored / 19, ConcedeperGame = GoalAgainst / 19)
awaydata1718 <- mutate(awaydata1718, GoalperGame = GoalScored / 19, ConcedeperGame = GoalAgainst / 19)
totalGoal1718 <- c(HomeGoals = sum(homedata1718$GoalScored), AwayGoals = sum(homedata1718$GoalAgainst))

# home and away dataframes 2016/2017
homedata1617 <- group_by(season1617, HomeTeam) %>% summarise(GoalScored=sum(FTHG), GoalAgainst=sum(FTAG))
awaydata1617 <- group_by(season1617, AwayTeam) %>% summarise(GoalScored=sum(FTAG), GoalAgainst=sum(FTHG))
homedata1617 <- mutate(homedata1617, GoalperGame = GoalScored / 19, ConcedeperGame = GoalAgainst / 19)
awaydata1617 <- mutate(awaydata1617, GoalperGame = GoalScored / 19, ConcedeperGame = GoalAgainst / 19)
totalGoal1617 <- c(HomeGoals = sum(homedata1617$GoalScored), AwayGoals = sum(homedata1617$GoalAgainst))

# use functions predict and actualResults to look at the effectiveness of the model
source("Scripts/predict.R")
source("Scripts/actualResults.R")
# inspect liverpool
predict("Liverpool")
actualResults("Liverpool")
# inspect Wolves
predict("Wolves")
actualResults("Wolves")



