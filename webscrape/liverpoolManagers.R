## WEBSCRAPPING LIVERPOOL MANAGER LIST
library(rvest)
# url of the wikipedia manager table
url <- "https://en.wikipedia.org/wiki/List_of_Liverpool_F.C._managers#:~:text=Liverpool%20F.C.%20managers%20%20%20%20Name%20,%20%20288%20%2016%20more%20rows%20"
# create a connection with the url
webpage <- read_html(url)
# read html from the class wikitable
tbs <- html_nodes(webpage, ".wikitable")
# The manager table is the second table of this class
tb <- html_table(tbs[2], header = TRUE, fill = TRUE)
tb <- tb[[1]]
# tidy the names
nm1 <- names(tb)
nm2 <- as.character(tb[1,])
lg <- nm1 == nm2
nm1[!lg] <- paste(nm1[!lg], nm2[!lg], sep = ".")
tb <- tb[2:dim(tb)[1],]
names(tb) <- nm1
# subset out the date columns and convert to date type
from <- tb$From
to <- tb$To
man_tb <- data.frame(Team = "Liverpool", Manager = tb$Name, From = from, TO = to)




