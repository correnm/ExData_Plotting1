# Load the library
library(ggplot2) 

## make a path and file string
dir<-getwd()

## make a path and file string
dir<-getwd()
NEIfile<- paste(dir, "summarySCC_PM25.rds",sep="/")
SCCfile<- paste(dir, "Source_Classification_Code.rds",sep="/")

## Read in the data files
NEI <- readRDS(NEIfile)
SCC <- readRDS(SCCfile)

## Only the records related to Baltimore City
baltimore<-subset(NEI, fips=='24510')

## Only the records related to Los Angeles County
losAngeles<-subset(NEI, fips=='06037')

## Find just the records related to motor vehicles
vehicle <- grep('*[vV]ehicle*', SCC$EI.Sector)
vehicleSectors <- SCC[vehicle,]
motorVehicle <-vehicleSectors[,1]
## Merge the two data sources based on the SCC code
motorVehicleEmissionsB <- subset(baltimore, baltimore$SCC %in% motorVehicle)
motorVehicleEmissionsL <- subset(losAngeles, losAngeles$SCC %in% motorVehicle)

# Put both cities in the same data frame 
allData <- rbind(motorVehicleEmissionsB, motorVehicleEmissionsL)

# Get the total of emissions by type in each year
plotData <- aggregate(allData["Emissions"], by=allData[c("fips","year")], FUN=sum)

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
png("plot6.png", height=480, width=480)

# Line graph of emissions by year
output<- ggplot(data=plotData, aes(x=year, y=Emissions, group=fips,  
                                   color=fips)) + geom_line() + geom_point()

# changing the tick intervals on the x-axis
# set the title
output + scale_x_continuous(breaks=xbreaks, labels=xbreaks) +  ggtitle("Comparison of Motor Vehicle Emissions")  
# close the device
dev.off()