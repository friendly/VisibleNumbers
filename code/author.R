setwd("C:/Documents/milestone/databases")
source("C:/R/functions/html2latin1.R")


# read from a common source on euclid
afile <- "http://euclid.psych.yorku.ca/datavis/Private/database/author.csv"
authorfile <- readLines(url(afile))
#authorfile <- readLines(file("author.csv"))
authorfile <- html2latin1(authorfile)
author <- read.csv(textConnection(authorfile), stringsAsFactors=FALSE, na.strings=c(NA, ""))
str(author)

# select lived of the form yyyy-yyyy
OK <- grep("[[:digit:]]{4}-[[:digit:]]{4}", author$lived)
author <- author[OK,c(3,4,6:14)]
#str(author)

# fix names with HTML entities
#grep("&", author$lname, value=TRUE)

# extract year of birth/death
author$byear <- as.numeric(gsub("([[:digit:]]{4})-[[:digit:]]{4}", "\\1", author$lived))
author$dyear <- as.numeric(gsub("[[:digit:]]{4}-([[:digit:]]{4})", "\\1", author$lived))
 
OK <- (!is.na(author$byear)) & (!is.na(author$dyear))
author <- author[OK,]

author$lifespan <- author$dyear - author$byear

author$name <- paste(author$lname, ", ", gsub("([[:alpha:]]*) .*", "\\1", author$givennames), sep="")

# extract & fix up country
country <- gsub(".*, ", "", author$birthplace)
#table(country)

country[grep("London", country)] <- "England"
#country[grep("Côte-", country)] <- "France"
#country[grep("Normandy", country)] <- "France"
#country[grep("Wuerzburg", country)] <- "Germany"
#country[grep("Württemberg", country)] <- "Germany"
#country[grep("Empire", country)] <- "Russia"

country[country %in% c("England", "Scotland")] <- "UK"
author$country <- country
table(country)

#keepc <- c("France", "Germany", "UK")

# subset to year >= 1500
author <- author[author$byear >= 1500,]
keep <- author[author$country %in% c("France",  "UK"),]

# timespan plot a la Priestley -- need to create an author category variable
# to make this useful
sorted <- keep[order(keep$country, keep$byear),]
sorted$country <- factor(sorted$country)

alt <- function(a,b) {ifelse(seq(length(a)) %% 2, a, b)}
num <- table(sorted$country)

pdf(file="timespan.pdf", width=9, height=9)
op <- par(mar=c(4,4,1,1)+.01)
plot(sorted$byear, 1:nrow(sorted), xlab="Year", ylab="", yaxt="n", xpd=NA, cex.lab=1.5,
	xlim=c(1500, 2000), cex=0.7, pch=16, col=rep(c("blue", "red"), num))
segments(sorted$byear, 1:nrow(sorted), sorted$dyear, 1:nrow(sorted), 
	col=rep(c("blue", "red"), num))

# print authors names, but alternating left/right
text(alt(sorted$byear, sorted$dyear), 
	1:nrow(sorted), sorted$name, cex=0.75, 
	pos=rep(c(2,4), length=nrow(sorted)))

# country
mtext(c("France", "England, Scotland"), side=2, at=c(num[1]/2, num[1]+num[2]/2), srt=90, cex=1.5)
# caption. NB: there must be a better way to align vertically
text(1610, 75, "Specimen of a\nChart of Biography", cex=2.5, font=4)
text(1610, 69, "of Milestones Authors", cex=1.5, font=4)
par(op)
dev.off()


# author lifespan
pdf(file="lifespan.pdf", width=10, height=4)
op <- par(mar=c(4,4,3,2)+.01)
plot(density(author$lifespan), xlab="Lifespan (years)", main="Milestone author lifespan", lwd=2, col="blue")
rug(jitter(author$lifespan))

extremes <- order(author$lifespan)[c(1:3,160:162)]
text(author$lifespan[extremes], 0.0005, author$name[extremes], srt=45, adj=c(0, .5))
abline(v=median(author$lifespan), lty="dashed", col="red")
stats <- summary(author$lifespan)
abline(v=stats[c(2,3,5)], lty=c(2,1,2), col="red")
par(op)
dev.off()

