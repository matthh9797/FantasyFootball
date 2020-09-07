predict <- function(HomeTeam, AwayTeam, predictGoalMatrix) {
  # total goals scored home and away by every team in the Premier League
  totalHomeGoal <- sum(predictGoalMatrix[, "HomeGoals"])
  totalAwayGoal <- sum(predictGoalMatrix[, "AwayGoals"])
  teams <- rownames(predictGoalMatrix)
  # Home Goals by home team split into the proportion of away goals conceded by the away team
  HomeGoal <- predictGoalMatrix[[HomeTeam, "HomeGoals"]] * 
    predictGoalMatrix[[AwayTeam, "AwayConcede"]] / (totalHomeGoal - predictGoalMatrix[[HomeTeam, "AwayConcede"]])
  # Away Goals by away team split into the proportion of home goals conceded by the home team
  AwayGoal <- predictGoalMatrix[[AwayTeam, "AwayGoals"]] *
    predictGoalMatrix[[HomeTeam, "HomeConcede"]] / (totalAwayGoal - predictGoalMatrix[[AwayTeam, "HomeConcede"]])
  return(c(HomeGoal, AwayGoal))
}