proportionGoalMatrix <- function(predictGoalMatrix) {
  ## Function inputs predictGoalMatrix (2*40) with predicted goals scored
  ## and conceded home and away and returns (20*40) matrix with the normalised
  ## goals scored against each team home and away
  totalGoalScored <- sum(predictGoalMatrix$HomeGoals) + sum(predictGoalMatrix$AwayGoals)
  teams <- rownames(predictGoalMatrix)
  # for all teams preict scores 
  source("code/predict.R")
  data <- sapply(teams, function(HomeTeam) sapply(teams, function(AwayTeam) predict(HomeTeam, AwayTeam, predictGoalMatrix)))
  # proportionGoalMatrix shows goals scored against each team in the premier league
  # initialise matrix
  proportionGoalMatrix <- matrix(data = data, ncol = 40, nrow = 20)
  colNames <- c(sapply(teams, function(x) paste0(x, ".Home")), sapply(teams, function(x) paste0(x, ".Away")))
  colnames(proportionGoalMatrix) <- colNames
  rownames(proportionGoalMatrix) <- teams

  
  
  
  
}