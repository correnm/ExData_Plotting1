## make a path and file string
dir<-getwd()
NEIfile<- paste(dir, "summarySCC_PM25.rds",sep="/")
SCCfile<- paste(dir, "Source_Classification_Code.rds",sep="/")

## Read in the data files
NEI <- readRDS(NEIfile)
SCC <- readRDS(SCCfile)

## Aggregate and sum the emissions by year (Baltimore City Only)
baltimore<-subset(NEI, fips=='24510')

emissionsByYear<-aggregate(Emissions ~ year, data=baltimore, sum)

# save plot to png file
png("plot2.png", height=480, width=480)
# suppress scientific notation
options(scipen=5)

# plotting symbol and color
par(pch=16, col="blue")

# get the range for the x and y axis 
xrange <- range(emissionsByYear$year) 
yrange <- range(emissionsByYear$Emissions)

# Determine the upper and lower limit for the x and y-axis
xmin<-min(emissionsByYear$year)
xmax<-max(emissionsByYear$year)
ymin<-min(emissionsByYear$Emissions)
ymax<-max(emissionsByYear$Emissions)

# Determine the values for axis tick marks
xbreaks <- c(seq(xmin, xmax, by=3))
ybreaks <- pretty(ymin:ymax, n=4)  

# set up the plot parameters
plot(xrange, yrange,  type="n", xlab="Year", ylab="Total Emissions (All Sources)",
     xlim=c(xmin, xmax),  ylim=c(ymin, ymax),
     xaxt="n",  yaxt="n"     
     )
title(main="10-Year Summary for Baltimore City, MD")

## Generate a line chart showing points at the indicated year
lines(emissionsByYear$year, emissionsByYear$Emissions, type="p")
lines(emissionsByYear$year, emissionsByYear$Emissions)

## draw the x-axis with user-defined tick-marks
axis(side=1, at=xbreaks, labels=TRUE)
## draw the y-axis with user-defined tick-marks
axis(side=2, at=ybreaks, labels=TRUE,las="0")

# close the device
dev.off()