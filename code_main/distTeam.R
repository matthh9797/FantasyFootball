distTeam <- function(TEAM, season = allSeason) {
  ## table of team goals
  t1 <- table(subset(season, HomeTeam == TEAM)$FTHG)
  t2 <- table(subset(season, AwayTeam == TEAM)$FTAG)
  allGoal <- rbind(subset(season, HomeTeam == TEAM)$FTHG,
                   subset(season, AwayTeam == TEAM)$FTHG)
  t3 <- table(allGoal)
  # plot the data
  par(mfrow = c(1, 3), mar = c(4, 4, 2, 1), oma = c(0,0,2,0))
  hist(subset(season, HomeTeam == TEAM)$FTHG, col = "blue", xlab = "Home Goals", main = "Home Goals from 2009 to 2020")
  hist(subset(season, AwayTeam == TEAM)$FTAG, col = "blue", xlab = "Away Goals", main = "Away Goals from 2009 to 2020")
  hist(allGoal, col = "green", xlab = "Total Goals", main = "Total Goals from 2009 to 2020")
  mtext("Distribution of Goals Scored in the Premier League", outer = TRUE)
  # return the table lists
  return(list(t1, t2, t3))
}