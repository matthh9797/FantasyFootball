summaryGoalDF <- function(goalDF, From, To) {
  library(dplyr)
  # Sumarise the expected goals for each team between the given dates
  exp.gls <- goalDF %>% filter(From < Date < To) %>% group_by(Team) %>% summarise(Total = sum(expectedGoal))
  # Do the same with the scaled goals
  scl.gls <- goalDF %>% filter(From < Date < To) %>% group_by(Team) %>% summarise(Total = sum(scaledGoal))
  return(list(exp.gls, scl.gls))
}