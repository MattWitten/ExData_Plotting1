#setwd("coursera/class4")
library(sqldf)
library(lubridate)

#Make a temp location to download file
temp <- tempfile()

#download zip file
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",temp)

#explore contents of zip file
#unzip(temp, list = TRUE)

power <- read.table(unzip(temp, "household_power_consumption.txt"), header = TRUE,sep = ";") 


#get rid of temp connection when done, per the internet
unlink(temp) 

#convert Date to a Date value --having troubles with this
#power$Date <- as.Date(power$Date)

#get just two days of data
power <- sqldf("select * from power where Date = '1/2/2007' or Date = '2/2/2007'")

#convert data to numbers
power$Global_active_power <- as.numeric(as.character(power$Global_active_power))
power$Date <- dmy(power$Date)
power$wday <- wday(power$Date, label = TRUE)

#make the graphic 480 x 480
#png("Plot1.png", width=480,height=480, units='px')

#I have no idea what this does
#par(mfcol=c(1,1), oma=c(0,0,0,0), mar=c(.2,.2,.2,.2), tcl=-0.1, mgp=c(0,0,0))

hist(power$Global_active_power, col = "red", main= "Global Active Power", xlab = "Global Active Power (kilowatts)")
#rug(power$Global_active_power)
#dev.off()