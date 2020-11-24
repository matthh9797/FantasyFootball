filterGoalDF <- function(goalDF, Team, From, To) {
  ## filterGoalDF is a function that takes the goalDF object as an arguement 
  ## and filters the object for a specific team between specific dates.
  # Filter the team
  df <- df %>% filter(Team == Team) %>% filter(Date < To) %>% filter(Date > From)
  return(result)
}