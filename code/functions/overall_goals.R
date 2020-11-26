overall_goals <- function(results) {
  ## A function that takes a dataframe of results as an input and returns a dataframe containg the goals scored and 
  ## conceded by a team overall, home and away. The results will be grouped by season and team
  library(dplyr)
  # Split into home and away data frames summarising goals scored by team and season
  home <- results %>% group_by(Season, HomeTeam) %>% summarise(home_goal=sum(FTHG), home_concede=sum(FTAG))
  away <- results %>% group_by(Season, AwayTeam) %>% summarise(away_goal=sum(FTAG), away_concede=sum(FTHG))
  # calculating the overall goals scored and conceded
  overall_goal <- home$home_goal + away$away_goal
  overall_concede <- home$home_concede + away$away_concede
  names(home)[2] <- "Team"; names(away)[2] <- "Team"
  # create a dataframe that sums all goals
  dataframe <- data.frame(home, away_goal = away$away_goal, away_concede = away$away_concede,
                          overall_goal = overall_goal, overall_concede = overall_concede)
  return(dataframe)
}