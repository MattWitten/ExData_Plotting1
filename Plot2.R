#setwd("coursera/class4")
library(lubridate)
library(sqldf)

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
png("Plot2.png", width=480,height=480, units='px')

#I have no idea what this does
par(mfcol=c(1,1), oma=c(1,1,0,0), mar=c(3,3,3,3))

plot(power$Global_active_power, type= "l", ylab = "Global Active Power (kilowatts)", xlab = "", axes = FALSE)
axis(2)
title(ylab="Global Active Power (kilowatts)",col.lab="black")
axis(1, at = c(1, 1500, 2880), labels = c("Thurs","Fri","Sat"))


#dev.off()