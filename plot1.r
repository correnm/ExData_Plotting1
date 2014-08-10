plot1<- function(){
    ## load library
    library(sqldf)
    
    ## make a path and file string
    dir<-getwd()
    filename<- paste(dir, "household_power_consumption.txt",sep="/")
    
    ## Subset the data for the designated time period
    plotdata <- read.csv.sql(filename, sep=";", sql = 'select * from file 
                             where Date = "1/2/2007" or Date ="2/2/2007"
                             ')
    
    # save plot to png file
    png("plot1.png", height=480, width=480)
    # Create uneven breaks for the x and y-axis
    xbreaks <- c(seq(0,6, by=2))
    ybreaks <- c(seq(0, 1200, by=200))
    # create the histograp
    hist(plotdata$Global_active_power,
         main="Global Active Power",
         right=TRUE,
         col="red",
         xlab="Global Active Power (kilowatts)",
         xaxt="n",
         yaxt="n"
         )

    ## draw the x-axis with user-defined tick-marks
    axis(side=1, at=xbreaks, labels=TRUE)
    ## draw the y-axis with user-defined tick-marks
    axis(side=2, at=ybreaks, labels=TRUE)
    

    # close the device
    dev.off()
}



