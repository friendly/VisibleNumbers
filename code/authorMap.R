setwd("C:/Documents/milestone/databases")
#source("C:/R/functions/html2latin1.R")

#author <- read.csv("author.csv", stringsAsFactors=FALSE, na.strings=c(NA, ""))

filename <- "author.csv"
authorfile <- readLines(file(filename))
timestamp <- file.info(filename)$mtime
authorfile <- html2latin1(authorfile)
author <- read.csv(textConnection(authorfile), stringsAsFactors=FALSE, na.strings=c(NA, ""))
#str(author)

# select lived of the form yyyy-yyyy -- don't need to do this
#OK <- grep("[[:digit:]]{4}-[[:digit:]]{4}", author$lived)
#autdata <- author[OK,c(3,4,6:14)]
autdata <- author[,c(3,4,6:14)]
str(author)

#autdata$name <- paste(autdata$lname, ", ", gsub("([[:alpha:]]*) .*", "\\1", autdata$givennames), sep="")
autdata$name <- paste(gsub("([[:alpha:]]*) .*", "\\1", autdata$givennames), toupper(autdata$lname), sep=" ")

## try googleVis

library(googleVis)

# remove NA from lat/long -- these will cause gvisMap() to fail
OK <- (!is.na(autdata$birthlat)) & (!is.na(autdata$birthlong))
autdata <- autdata[OK,]
autdata$latlong <- paste(autdata$birthlat, autdata$birthlong, sep=':')

# make the tool tip include a link to the milestones site
query <- paste("<a href='http://www.datavis.ca/milestones/index.php?query=", autdata$lname, "'>",
               autdata$name, "</a>", sep="")
autdata$tip <- paste(query, # autdata$name, 
		autdata$birthplace, 
		ifelse(is.na(autdata$birthdate), "", format(as.Date(autdata$birthdate), "%b %d %Y")), 
		sep="\n")

# 
authorMap <- gvisMap(autdata, 'latlong', 'tip',
             options=list(
             		showTip=TRUE, 
                enableScrollWheel=TRUE,
                useMapTypeControl=TRUE,
                mapType='normal',
			          width=1000,height=500), 
			   chartid="authors")

# customize ...
header <- authorMap$html$header
header <- sub("<title>authors</title>", "<title>Milestones authors map</title>", header)

# Add custom page title after the <body> tag that ends the header
num <- nrow(autdata)
myhead <- paste("<h1>Birth places of Milestones Authors</h1>
<p>
This interactive map shows the birthplace of authors in the milestones database for",
num, "authors for which this information is known.",
"(Using: ", filename, ", as of ", timestamp,
")</p>
")
authorMap$html$header <- paste(header, myhead, sep="\n")

plot(authorMap)

# save it to a file
print(authorMap, file="authorMap.html")


