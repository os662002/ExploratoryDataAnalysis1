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
#1.3 plotting Global active power time serie
Sys.setlocale(locale="English")
png(file = "Figures/plot2.png")
## Create plot and send to a file (no plot appears on screen)
with(epc,plot(Datetime,Global_active_power,xlab="",ylab="Global active power (kilowatts)",col="black",type="l"))
dev.off()
