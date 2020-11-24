## a. Add the list of fixtures 
fixtures <- read.csv("data/fixtures/epl-2020-GMTStandardTime.csv")
fixtures <- transform(fixtures, Date = as.Date(Date, format = "%d/%m/%Y"))
## b. pre-process teams from 2020/2021 to match the format of the results data source
fixtures <- transform(fixtures, Home.Team = as.character(Home.Team), Away.Team = as.character(Away.Team))
fixtures$Home.Team[fixtures$Home.Team == "Man Utd"] <- "Man United"
fixtures$Home.Team[fixtures$Home.Team == "Sheffield Utd"] <- "Sheffield United"
fixtures$Home.Team[fixtures$Home.Team == "Spurs"] <- "Tottenham"
fixtures$Away.Team[fixtures$Away.Team == "Man Utd"] <- "Man United"
fixtures$Away.Team[fixtures$Away.Team == "Sheffield Utd"] <- "Sheffield United"
fixtures$Away.Team[fixtures$Away.Team == "Spurs"] <- "Tottenham"
fixtures <- transform(fixtures, Home.Team = as.factor(Home.Team), Away.Team = as.factor(Away.Team))

## Append to the fixture list 
fixtures <- transform(fixtures, POSTPONED = FALSE)
fixtures$POSTPONED <- ((fixtures$Result == "") & (fixtures$Date < Sys.Date()))
