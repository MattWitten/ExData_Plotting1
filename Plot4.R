#setwd("coursera/class4")
library(lubridate)
library(sqldf)
#library(ggplot2)

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
power$Sub_metering_1 <- as.numeric(as.character(power$Sub_metering_1))
power$Sub_metering_2 <- as.numeric(as.character(power$Sub_metering_2))
power$Sub_metering_3 <- as.numeric(as.character(power$Sub_metering_3))
power$Global_reactive_power <- as.numeric(as.character(power$Global_reactive_power))
power$Voltage <- as.numeric(as.character(power$Voltage))

power$Date <- dmy(power$Date)
power$wday <- wday(power$Date, label = TRUE)

#make the graphic 480 x 480
png("Plot4.png", width=480,height=480, units='px')

#I have no idea what this does
par(mfrow=c(2,2), oma=c(1,1,0,0), mar=c(3,3,3,3))

plot(power$Global_active_power, type= "l", ylab = "Global Active Power", xlab = "", axes = FALSE)
axis(2)
axis(1, at = c(1, 1500, 2880), labels = c("Thurs","Fri","Sat"))

plot(power$Voltage, type= "l", ylab = "Global Active Power", xlab = "", axes = FALSE)
axis(2)
axis(1, at = c(1, 1500, 2880), labels = c("Thurs","Fri","Sat"))


plot(power$Sub_metering_1, type= "l", ylab = "Global Active Power (kilowatts)", xlab = "", axes = FALSE)
axis(2, ylab = "Energy Sub metering")
axis(1, at = c(1, 1500, 2880), labels = c("Thurs","Fri","Sat"))
lines(power$Sub_metering_2, col = "red")
lines(power$Sub_metering_3, col = "blue")
legend(1000,38, # places a legend at the appropriate place 
       c("Sub_metering_1","Sub_metering_2", "Sub_metering_3"), # puts text in the legend 
       
       lty=c(1,1,1), # gives the legend appropriate symbols (lines)
       
       lwd=c(2.5,2.5, 2.5),col=c("black","blue","red")
       
       ,cex = .5) # gives the legend lines the correct color and width

plot(power$Global_reactive_power, type= "l", ylab = "Global Active Power", xlab = "", axes = FALSE)
axis(2)
axis(1, at = c(1, 1500, 2880), labels = c("Thurs","Fri","Sat"))
#dev.off()