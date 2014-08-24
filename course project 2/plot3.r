# Load the library
library(ggplot2) 

# make a path and file string
dir<-getwd()
NEIfile<- paste(dir, "summarySCC_PM25.rds",sep="/")
SCCfile<- paste(dir, "Source_Classification_Code.rds",sep="/")

# Read in the data files
NEI <- readRDS(NEIfile)
SCC <- readRDS(SCCfile)

# Data for Baltimore City Only
baltimore<-subset(NEI, fips=='24510')

# Get the total of emissions by type in each year
plotData <- aggregate(baltimore["Emissions"], by=baltimore[c("type","year")], FUN=sum)

# get the range for the x and y axis 
xrange <- range(plotData$year) 
yrange <- range(plotData$Emissions)

# Determine the upper and lower limit for the x and y-axis
xmin<-min(plotData$year)
xmax<-max(plotData$year)
ymin<-min(plotData$Emissions)
ymax<-max(plotData$Emissions)

# Determine the values for axis tick marks
xbreaks <- c(seq(xmin, xmax, by=3))
ybreaks <- pretty(ymin:ymax, n=4)  

# Save plot to png file
png("plot3.png", height=480, width=480)

# Line graph of emissions by year
output<- ggplot(data=plotData, aes(x=year, y=Emissions, group=type,  
            color=type)) + geom_line() + geom_point()

# changing the tick intervals on the x-axis
# set the title
output + scale_x_continuous(breaks=xbreaks, labels=xbreaks) +  ggtitle("10-Year Summary for Baltimore City, MD")  
# close the device
dev.off()


