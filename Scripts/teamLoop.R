## This function takes a list of teams and a function
## and loop the teams over the function

teamLoop <- function(teams, func) {
  for (team in teams) {
    func(team)
  }
}