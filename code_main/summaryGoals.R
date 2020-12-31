summaryGoals <- function(results) {
  ## A far from perfect function that takes a season tbl object, specific to this project with the results of a given season
  ## and returns a data.tbl with a summary of the goals scored home and away in the premier league that season
  ## season: a data.tbl of results, year: a character string with the season
  library(dplyr)
  # split results into teams then summarise the goals scored and conceded
  home <- results %>% group_by(Season, HomeTeam) %>% summarise(GoalScored=sum(FTHG), GoalAgainst=sum(FTAG))
  away <- results %>% group_by(Season, AwayTeam) %>% summarise(GoalScored=sum(FTAG), GoalAgainst=sum(FTHG))
  # Add rates
  home <- mutate(home, HomeorAway = "Home", GoalperGame = GoalScored / 19, ConcedeperGame = GoalAgainst / 19)
  away <- mutate(away, HomeorAway = "Away", GoalperGame = GoalScored / 19, ConcedeperGame = GoalAgainst / 19)
  # rename column names from HomeTeam and AwayTeam to just team with HomeorAway variable
  names(home)[2] <- "Team"; names(away)[2] <- "Team"; summary <- rbind(home, away)
  summary <- mutate(summary, HomeorAway = as.factor(HomeorAway))
  summary <- as.data.frame(summary)
  return(summary)
}


