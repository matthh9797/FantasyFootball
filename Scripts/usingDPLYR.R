## Script to read in data from datahub on English Premier League results
library("jsonlite")
json_file <- 'https://datahub.io/sports-data/english-premier-league/datapackage.json'
json_data <- fromJSON(paste(readLines(json_file), collapse=""))
# get list of all resources:
print(json_data$resources$name)
# choose data you want
path_to_file <- json_data$resources$path[23]
data <- read.csv(url(path_to_file))
# load dplyr
library(dplyr)
season201819 <- select(data, 2:10)

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

# liverpool data
liverpool201819 <- filter(season201819, HomeTeam == "Liverpool" | AwayTeam == "Liverpool")

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

## predicting goals scored against each team 
# Arsenal home goals scored 
arsenal1819 <- as.tbl(data.frame(Team = teams1819[2:20]))
arsenal1819 <- mutate(arsenal1819, HomeGoal = 42 * awaydata1819$GoalAgainst[2:20] / (596 - 35))
arsenal1819 <- mutate(arsenal1819, RoundedHomeGoal = round(HomeGoal, digits = 0))
filter(season201819, HomeTeam == "Arsenal") %>% arrange(AwayTeam)

# Man Utd Home Results
manutd1819 <- as.tbl(data.frame(Team = teams1819))
# note: homeGoalScoredManU = 33, awayConcededManU = 29, totalHomeGoals = 596
manutd1819 <- mutate(manutd1819, HomeGoal = 33 * awaydata1819$GoalAgainst / (596 - 29)) %>%
    mutate(RoundedHomeGoal = round(HomeGoal, digits = 0)) %>%
    # note: homeGoalConcededManU = 25, awayGoalScored = 32, totalAwayGoals = 476
    mutate(AwayGoal = awaydata1819$GoalScored * 25 / (476 - 32)) %>%
    mutate(RoundedAwayGoal = round(AwayGoal, digits = 0)) %>%
    filter(Team != "Man United")
## MAKE THIS AN ACTUAL RESULT COLUMN
filter(season201819, HomeTeam == "Man United") %>% arrange(AwayTeam)

# Liverpool All Results
liverpool1819 <- as.tbl(data.frame(Team = teams1819))
# calculating home results
liverpool1819 <- mutate(liverpool1819, HomeGoal = 55 * awaydata1819$GoalAgainst / (596 - 12)) %>%
    mutate(RHG = round(HomeGoal, digits = 0)) %>%
    mutate(HomeConcede = awaydata1819$GoalScored * 10 / (476 - 34)) %>%
    mutate(RHC = round(HomeConcede, digits = 0))
# calculating away results
# note: AwayGoalScoredLiverpool = 34, HomeConcedeLiverpool = 10, totalAwayGoal = 476
liverpool1819 <- mutate(liverpool1819, AwayGoal = 34 * homedata1819$GoalAgainst / (476 - 10)) %>%
    mutate(RAG = round(AwayGoal, digits = 0)) %>%
    # note: AwayConcedeLiverpool = 12, HomeGoalScoredLiverpool = 55, totalHomeGoal = 596
    mutate(AwayConcede = homedata1819$GoalScored * 12 / (596 - 55)) %>%
    mutate(RAC = round(AwayConcede, digits = 0)) %>%
    filter(Team != "Liverpool")

filter(season201819, HomeTeam == "Liverpool") %>% arrange(AwayTeam)
filter(season201819, AwayTeam == "Liverpool") %>% arrange(HomeTeam)



