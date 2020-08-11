# Main Script for Fantasy Football Project

# Import libraries
library(hash)

# Import 2018/2019 result data dircetly from datahub.com
results_1819 <- read.csv("https://datahub.io/sports-data/english-premier-league/r/season-1819.csv", stringsAsFactors = FALSE)

# team names for 2019/2020 season as saved on local csv's in Data Folder
teams_1920 <- c("Arsenal", "AstonVilla", "Bournemouth", "Brighton", "Burnley", "Chelsea", "CrystalPalace", "Everton", "Leicester", "Liverpool",
               "ManCity", "ManUtd", "Newcastle", "Norwich", "SheffieldUtd", "Southampton", "Tottenham", "Watford", "WestHam", "Wolves")
## MAY BE A GOOD IDEA TO USE FACTOR FOR TEAM NAMES TO SORT CATEGORICAL DATA INSTEAD OF HASH

# team names for 2018/2019 season as in season-1819 csv
teams_1819 <- sort(unique(results_1819$HomeTeam))
## COULD USE DUMP FUNCTION TO STORE THIS OBJECT IN A FILE

# dictionaries to hash values of team names
values <- 1:20
dict_1920 <- hash(teams_1920, values)
dict_1819 <- hash(teams_1819, values)

# create a list of team fixture Data Frames for 2019/2020 season
fixtures_1920 <- lapply(paste0("Data/fixtures/", teams_1920, "_fixtures.csv"), read.csv)
# renaming fixture1920 elements
names(fixtures_1920) <- paste0(teams_1920, "_fixtures")

# create descriptive statistics data frame for the 2018/2019 season
Stat_1819 <- data.frame(Team=teams_1819, HG=0, AG = 0, HC = 0, AC = 0, stringsAsFactors = FALSE)

source("Scripts/goals.R")
source("Scripts/teamLoop.R")
source("Scripts/goalConcede.R")
# set values of Overall Home and Away goals and coneded column elements 
## COULD HAVE USED lapply()
teamLoop(teams_1819, goals)
# There is a bug in this code, incorrect values
## COULD HAVE USED lapply()
## COULD USE mapply() to apply to seperate team lists.
teamLoop(teams_1819, goalConcede)
# assing colSums to data frame
Totals_1819 = colSums(Stat_1819)
rbind(Stat_1819, Totals_1819)
# create global numerical object that is the overall goals in the 2018/2019 season
ovGoal_1819 <- sum(Stat_1819$HG) + sum(Stat_1819$AG)

# visualise the descriptive statistics
barplot(c(Stat_1819$HG[[1]], Stat_1819$AG[[1]]))

# create predict home goal matrix, predict away goal matrix, predict home concede matrix and predict 
# away concede matrix
## WHEN CREATING THIS MATRIX CREATE ONE OVERALL MATRIX WITH 4 SUBSETTED MATRICES USING THE MATRIX 
## SUBSETTING LECTURE
source("Scripts/predictHomeGoal.R")


