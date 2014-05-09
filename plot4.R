setwd("E:/Olivier/Exploratory Data Analysis/Projects/Project1")

if(!file.exists("./data")){dir.create("./Data")}
if(!file.exists("./Figures")){dir.create("./Figures")}

#1. Downloading and extracting data
#-----------------------------------
#1.1 Download
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileUrl,destfile="./Data/Electric_power_consumption.zip")

unzip("./Data/Electric_power_consumption.zip",
      exdir="./Data")

date_download=date()
date_download

#1.2 extracting the data
library(sqldf)
epc<-read.csv.sql("./Data/household_power_consumption.txt",sql="select * from file where Date = '1/2/2007' or Date = '2/2/2007' ",sep=";",header=TRUE,na.strings = "?")
epc$Date<-as.Date(epc$Date,"%d/%m/%Y")
epc$Datetime<-strptime(paste(as.character(epc$Date),epc$Time),"%Y-%m-%d %H:%M:%S")

names(epc)
# Multiple plots
Sys.setlocale(locale="English")
png(file = "Figures/plot4.png")
# Multiple plots
par(mfrow = c(2, 2))
# Plot 1 : time serie ofGlobal active power
with(epc,plot(Datetime,Global_active_power,xlab="",ylab="Global active power (kilowatts)",col="black",type="l"))
# Plot 2 : time serie of Voltage
with(epc,plot(Datetime,Voltage,col="black",type="l"))
# Plot 3 : time serie of Energy sub metering
with(epc,plot(Datetime,Sub_metering_1,xlab="",ylab="",col="black",type="l"))
with(epc,points(Datetime,Sub_metering_2,xlab="",ylab="",col="red",type="l"))
with(epc,points(Datetime,Sub_metering_3,xlab="",ylab="",col="blue",type="l"))
title(ylab="Energy sub metering")
legend("topright", lty = 1, col = c("black","blue", "red"), legend = c("Sub_metering_1","Sub_metering_1", "Sub_metering_3"),bty="n")
# Plot 4
with(epc,plot(Datetime,Global_reactive_power,col="black",type="l"))

dev.off()
