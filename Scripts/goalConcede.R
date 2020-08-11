## This function calculates the overall home and away goals conceded of an inputed team
## and sets the values of the correct element in the Descriptive Statistics 2018/2019 
## data frame to the resulting number

goalConcede <- function(team) {
  # logical vectors that returns TRUE if the value of the element of the HomeTeam or AwayTeam 
  # columns in the results 2018/2019 data frame is equal to team and FALSE otherwise.
  i <- (results_1819$HomeTeam == team)
  j <- (results_1819$AwayTeam == team)
  # set values of Descriptive Statistics 2018/2019 OVHG and OVAG columns for team
  DescriptiveStat_1819$OVHC[dict_1819[[team]]] <<- sum(results_1819$FTAG[i])
  DescriptiveStat_1819$OVAC[dict_1819[[team]]] <<- sum(results_1819$FTHG[j])
}