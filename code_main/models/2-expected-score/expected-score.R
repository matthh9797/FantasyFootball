# Home and Away Team must be specified as a numeric value for the TeamList which is a factor variable
exp_score <- function(HomeTeam, AwayTeam, HomeGoal, AwayGoal, HomeConcede, AwayConcede, TeamList = NA) {
  ## This is a function that takes 6 vector arguements of the same length which are a list of 
  ## home and away teams and the goals scored/conceded by each. Then calculates and expected
  ## goal for each team against each opponent.
  # Allow for names to be entered as a character vector
  if (class(HomeTeam) == "character") {
    TeamList <- as.factor(TeamList)
    lbls <- labels(TeamList)
    names(lbls) <- levels(TeamList)
    HomeTeam = as.numeric(lbls[[HomeTeam]])
    AwayTeam = as.numeric(lbls[[AwayTeam]])
  }
  # The overall goals scored by every team home and away 
  sum_hg <- sum(HomeGoal, na.rm = TRUE); sum_ag <- sum(AwayGoal, na.rm = TRUE)
  # make sure the team list is a factor variable
  TeamList <- as.factor(TeamList)
  # expected goal of home team is equal to the overall home goals of the home team multiplied by the
  # proportion of the overall away goals conceded (overall home goals scored) by the away team 
  # [Note: discount the proportion of away goals conceded by the home team]
  exp.hg <- HomeGoal[[HomeTeam]] * (AwayConcede[[AwayTeam]] / (sum_hg - AwayConcede[[HomeTeam]]))
  # expected goal of the away team is equal to the overall goals scored away goals scored by the away
  # team multiplied by the proportion of overall home goals conceded by the home team
  # [Note: discount the proportion of home goals conceded by the away team]
  exp.ag <- AwayGoal[[AwayTeam]] * (HomeConcede[[HomeTeam]] / (sum_ag - HomeConcede[[AwayTeam]]))
  return(c(exp.hg, exp.ag))
}