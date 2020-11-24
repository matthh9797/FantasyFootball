## This script is made to study the model Throughout the Season
source("code/summaryGoalDF.R")
## Study teams that the model suggests have the best fixtures 
## for scoring goals

## 1. Week 5 - Week 10
summaryGoalDF(goalDF, From = 5, To = 10)

# a. Fulham have the highest scaled rating 2.95
dplyr::filter(goalDF, Team == "Fulham", (Week >= 5) & (Week <= 10))
# The first 5 fixtures that FUlham have are all a positive
# scaled rating suggesting they have potential to score goals

# b. Man United have the second highest scaled Rating 2.28
dplyr::filter(goalDF, Team == "Man United", (Week >= 5) & (Week <= 10))
# Man United have especially high expected goal ratings against
# Chelsea@Home (2.96) in Week 6, West Brom@Home (2.59) in Week 9
# Arsenal@Home and West Brom@Home

# c. Crystal Palace are third with 1.80
dplyr::filter(goalDF, Team == "Crystal Palace", (Week >= 5) & (Week <= 10))
# Crystal Palace have consistently good fixtures witha a particurly large
# scaled score against Fulham@Away in week 6 and Burnley Away in week 9

# d. Newcastle are 4th with a 1.51 rating
dplyr::filter(goalDF, Team == "Newcastle", (Week >= 5) & (Week <= 10))

## 1. Week 5 - Week 12
summaryGoalDF(goalDF, From = 5, To = 12)





