model2_score_predict <- function(HomeTeam, AwayTeam, predictGoalMatrix) {
  ## ! Change this function to accept a Teams vector as factors
  ## and return an array of results
  
  # total goals scored home and away by every team in the Premier League
  totalHomeGoal <- sum(predictGoalMatrix$home_goal)
  totalAwayGoal <- sum(predictGoalMatrix$away_goal)
  teams <- predictGoalMatrix$Team
  # Home Goals by home team split into the proportion of away goals conceded by the away team
  HomeGoal <- predictGoalMatrix[[which(predictGoalMatrix$Team == HomeTeam), "home_goal"]] * 
    predictGoalMatrix[[which(predictGoalMatrix$Team == AwayTeam), "away_concede"]] / 
    (totalHomeGoal - predictGoalMatrix[[which(predictGoalMatrix$Team == HomeTeam), "away_concede"]])
  # Away Goals by away team split into the proportion of home goals conceded by the home team
  AwayGoal <- predictGoalMatrix[[which(predictGoalMatrix$Team == AwayTeam), "away_goal"]] *
    predictGoalMatrix[[which(predictGoalMatrix$Team == HomeTeam), "home_concede"]] / 
    (totalAwayGoal - predictGoalMatrix[[which(predictGoalMatrix$Team == AwayTeam), "home_concede"]])
  return(c(HomeGoal, AwayGoal))
}