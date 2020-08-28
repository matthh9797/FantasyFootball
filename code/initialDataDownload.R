## Script to read in data from datahub on English Premier League results
library("jsonlite")
json_file <- 'https://datahub.io/sports-data/english-premier-league/datapackage.json'
json_data <- fromJSON(paste(readLines(json_file), collapse=""))
save(json_data, file = "data/datahub-premierleague-datapackage.json")
# get list of all resources:
print(json_data$resources$name)
# use function extract season to extract the 10 seasons from the json_data and 
# rbind into a single results data frame
source("code/extractSeason.R")
result_tbl <- rbind(
  extractSeason(season = 32, year = "0910"),
  extractSeason(season = 31, year = "1011"),
  extractSeason(season = 30, year = "1112"),
  extractSeason(season = 29, year = "1213"),
  extractSeason(season = 28, year = "1314"),  
  extractSeason(season = 27, year = "1415"),
  extractSeason(season = 26, year = "1516"),  
  extractSeason(season = 25, year = "1617"),
  extractSeason(season = 24, year = "1718"),
  extractSeason(season = 23, year = "1819")
  
)
result_tbl <- transform(result_tbl, Season = as.factor(Season))
# store result object
save(result_tbl, file = "data/result_tbl.R")
# create list of the teams in the Premier League by season
team_list <- list(
  "teams_0910" = sort(unique(extractSeason(season = 32, year = "0910")$HomeTeam)),
  "teams_1011" = sort(unique(extractSeason(season = 31, year = "1011")$HomeTeam)),
  "teams_1112" = sort(unique(extractSeason(season = 30, year = "1112")$HomeTeam)),
  "teams_1213" = sort(unique(extractSeason(season = 29, year = "1213")$HomeTeam)),  
  "teams_1314" = sort(unique(extractSeason(season = 28, year = "1314")$HomeTeam)),
  "teams_1415" = sort(unique(extractSeason(season = 27, year = "1415")$HomeTeam)),
  "teams_1516" = sort(unique(extractSeason(season = 26, year = "1516")$HomeTeam)),  
  "teams_1617" = sort(unique(extractSeason(season = 25, year = "1617")$HomeTeam)),
  "teams_1718" = sort(unique(extractSeason(season = 24, year = "1718")$HomeTeam)),
  "teams_1819" = sort(unique(extractSeason(season = 23, year = "1819")$HomeTeam))
)
save(team_list, file = "data/team_list.R")
## 3. Creating summary dataframes detailing the number of goals scored and conceded home and away
## grouped by teams
source("code/summary_df.R")
## Note: this variation will much up the predict function which will need adapted to this new format
goalSummary <- rbind(
  summary_df(season = filter(result_tbl, Season == "0910"), year = "0910"),
  summary_df(season = filter(result_tbl, Season == "1011"), year = "1011"),
  summary_df(season = filter(result_tbl, Season == "1112"), year = "1112"),
  summary_df(season = filter(result_tbl, Season == "1213"), year = "1213"),
  summary_df(season = filter(result_tbl, Season == "1314"), year = "1314"),
  summary_df(season = filter(result_tbl, Season == "1415"), year = "1415"),
  summary_df(season = filter(result_tbl, Season == "1516"), year = "1516"),
  summary_df(season = filter(result_tbl, Season == "1617"), year = "1617"),
  summary_df(season = filter(result_tbl, Season == "1718"), year = "1718"),
  summary_df(season = filter(result_tbl, Season == "1819"), year = "1819")
)
# store goalSummary Object
save(goalSummary, file = "data/goalSummary.R")

