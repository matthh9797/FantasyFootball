overall_goals <- function(HomeTeam, AwayTeam, Season, FTHG, FTAG) {
  ## A function that takes a dataframe of results as an input and returns a dataframe containg the goals scored and 
  ## conceded by a team overall, home and away. The results will be grouped by season and team
  library(dplyr)
  df1 <- data.frame(Season = as.factor(Season), HomeTeam = as.factor(HomeTeam), AwayTeam = as.factor(AwayTeam),
                    FTHG = as.numeric(FTHG), FTAG = as.numeric(FTAG))
  # Split into home and away data frames summarising goals scored by team and season
  home <- df1 %>% group_by(Season, HomeTeam) %>% summarise(home_goal=sum(FTHG, na.rm = TRUE), home_concede=sum(FTAG, na.rm = TRUE))
  away <- df1 %>% group_by(Season, AwayTeam) %>% summarise(away_goal=sum(FTAG, na.rm = TRUE), away_concede=sum(FTHG, na.rm = TRUE))
  # calculating the overall goals scored and conceded
  overall_goal <- home$home_goal + away$away_goal
  overall_concede <- home$home_concede + away$away_concede
  names(home)[2] <- "Team"; names(away)[2] <- "Team"
  # create a dataframe that sums all goals
  df2 <- data.frame(home, away_goal = away$away_goal, away_concede = away$away_concede,
                          overall_goal = overall_goal, overall_concede = overall_concede)
  # rearrange the columns of the dataframes
  df2 <- df2[ , c(1,2,7,3,5,8,4,6)]
  return(df2)
}