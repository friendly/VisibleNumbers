#library(HistData)
data(Wheat, package="HistData")
data(Wheat.monarchs, package="HistData")
setwd("c:/Documents/milestone/images/playfair")

# -----------------------------------------
# plot the labor cost of a quarter of wheat
# -----------------------------------------
Wheat1 <- within(na.omit(Wheat), {Labor=Wheat/Wages})

pdf(file="wheat2.pdf", height=8, width=12)
op <- par(mar=c(4,4.1,1,1)+.01)   # tight bounding box

with(Wheat1, {
	plot(Year, Labor, type='b', pch=16, cex=1.5, lwd=1.5, 
	     ylab="Labor cost of a Quarter of Wheat (weeks)",
	     ylim=c(1,12.5),
	     cex.axis=1.2, cex.lab=1.5,
	     lab=c(12,5,7)
	     );
	lines(lowess(Year, Labor), col="red", lwd=3)
	})
	
# cartouche
text(1740, 10, "Chart", cex=2, font=2)
text(1740, 8.5, 
	paste("Shewing at One View", 
        "The Work Required to Purchase", 
        "One Quarter of Wheat",
        "from 1865 to 1821", 
        sep="\n"), cex=1.5, font=3)

with(Wheat.monarchs, {
	y <- ifelse( !commonwealth & (!seq_along(start) %% 2), 12.4, 12.6)
	segments(start, y, end, y, col=gray(.4), lwd=8, lend=1)
	segments(start, y, end, y, col=ifelse(commonwealth, "white", NA), lwd=4, lend=1)
	text((start+end)/2, y-0.2, name, cex=0.7)
	})
par(op)
dev.off()
