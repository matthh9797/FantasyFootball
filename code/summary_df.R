summary_df <- function(season, year) {
  ## A far from perfect function that takes a season tbl object, specific to this project with the results of a given season
  ## and returns a data.tbl with a summary of the goals scored home and away in the premier league that season
  ## season: a data.tbl of results, year: a character string with the season
  library(dplyr)
  home <- group_by(season, HomeTeam) %>% summarise(GoalScored=sum(FTHG), GoalAgainst=sum(FTAG))
  away <- group_by(season, AwayTeam) %>% summarise(GoalScored=sum(FTAG), GoalAgainst=sum(FTHG))
  home <- mutate(home, Season = year, HomeorAway = "home", GoalperGame = GoalScored / 19, ConcedeperGame = GoalAgainst / 19)
  away <- mutate(away, Season = year, HomeorAway = "away", GoalperGame = GoalScored / 19, ConcedeperGame = GoalAgainst / 19)
  names(home)[1] <- "Team"; names(away)[1] <- "Team"; summary <- rbind(home, away)
  summary <- mutate(summary, Season = as.factor(Season), HomeorAway = as.factor(HomeorAway))
  return(summary)
}


