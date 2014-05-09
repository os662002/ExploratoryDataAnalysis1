Course Project 1
========================================================

**Introduction**
================
This assignment uses data from the UC Irvine Machine Learning Repository, a popular repository for machine learning datasets. In particular, we will be using the "Individual household electric power consumption Data Set" which I have made available on the course web site:

- Dataset: Electric power consumption [20Mb]

- Description: Measurements of electric power consumption in one household with a one-minute sampling rate over a period of almost 4 years. Different electrical quantities and some sub-metering values are available.

The following descriptions of the 9 variables in the dataset are taken from the UCI web site:

- Date: Date in format dd/mm/yyyy
- Time: time in format hh:mm:ss
- Global_active_power: household global minute-averaged active power (in kilowatt)
- Global_reactive_power: household global minute-averaged reactive power (in kilowatt)
- Voltage: minute-averaged voltage (in volt)
- Global_intensity: household global minute-averaged current intensity (in ampere)
- Sub_metering_1: energy sub-metering No. 1 (in watt-hour of active energy). It corresponds to the kitchen, containing mainly a dishwasher, an oven and a microwave (hot plates are not electric but gas powered).
- Sub_metering_2: energy sub-metering No. 2 (in watt-hour of active energy). It corresponds to the laundry room, containing a washing-machine, a tumble-drier, a refrigerator and a light.
- Sub_metering_3: energy sub-metering No. 3 (in watt-hour of active energy). It corresponds to an electric water-heater and an air-conditioner.

**1. Downloading and extracting data**
======================================
First : set the working directory and create Data and Figure directory if needed.
Set language to english for axes labelling consistency.


```r
setwd("E:/Olivier/Exploratory Data Analysis/Projects/Project1")

if (!file.exists("./data")) {
    dir.create("./Data")
}
if (!file.exists("./Figures")) {
    dir.create("./Figures")
}

Sys.setlocale(locale = "English")
```

```
## [1] "LC_COLLATE=English_United States.1252;LC_CTYPE=English_United States.1252;LC_MONETARY=English_United States.1252;LC_NUMERIC=C;LC_TIME=English_United States.1252"
```


#1.1 Download

Date_download correspond the the download date


```r
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
setInternet2(use = TRUE)
# download.file(fileUrl,destfile='./Data/Electric_power_consumption.zip')

unzip("./Data/Electric_power_consumption.zip", exdir = "./Data")

date_download = date()
date_download
```

```
## [1] "Fri May 09 21:30:11 2014"
```

#1.2 extracting the data

Only the data for the first and 2d of february 2007 is loaded using the read.csv.sql command from the sqldf package.
Date and Time string characters are converted to date/time class : new column Datetime is created. 


```r
library(sqldf)
```

```
## Warning: package 'sqldf' was built under R version 3.0.3
```

```
## Loading required package: gsubfn
```

```
## Warning: package 'gsubfn' was built under R version 3.0.3
```

```
## Loading required package: proto
## Loading required namespace: tcltk
## Loading required package: RSQLite
## Loading required package: DBI
## Loading required package: RSQLite.extfuns
```

```r
epc <- read.csv.sql("./Data/household_power_consumption.txt", sql = "select * from file where Date = '1/2/2007' or Date = '2/2/2007' ", 
    sep = ";", header = TRUE)
```

```
## Warning: closing unused connection 5
## (./Data/household_power_consumption.txt)
```

```
## Loading required package: tcltk
```

```r
epc$Date <- as.Date(epc$Date, "%d/%m/%Y")
```

```
## Warning: closing unused connection 6
## (./Data/household_power_consumption.txt)
```

```r
epc$Datetime <- strptime(paste(as.character(epc$Date), epc$Time), "%Y-%m-%d %H:%M:%S")

names(epc)
```

```
##  [1] "Date"                  "Time"                 
##  [3] "Global_active_power"   "Global_reactive_power"
##  [5] "Voltage"               "Global_intensity"     
##  [7] "Sub_metering_1"        "Sub_metering_2"       
##  [9] "Sub_metering_3"        "Datetime"
```


Other method that could have been used : 

```r
header = read.csv("./Data/household_power_consumption.txt", sep = ";", nrow = 1, 
    header = TRUE)
lines <- grep("^[1-2]/2/2007", readLines("./Data/household_power_consumption.txt"))
epc2 = read.csv("./Data/household_power_consumption.txt", sep = ";", header = FALSE, 
    skip = lines[1] - 1, nrows = length(lines), na.strings = "?")
names(epc2) = names(header)
```


2. Plotting Global active power histogram
======================================

#png(file = "Figures/plot1.png")
# Create plot and send to a file (no plot appears on screen)

```r
with(epc, hist(Global_active_power, xlab = "Global active power (kilowatts)", 
    main = "Global active power", col = "red"))
```

![plot of chunk unnamed-chunk-5](figure/unnamed-chunk-5.png) 

```r
# dev.off()
```


3. Plotting Global active power time serie
======================================


```r
# png(file = 'Figures/plot2.png') Create plot and send to a file
with(epc, plot(Datetime, Global_active_power, xlab = "", ylab = "Global active power (kilowatts)", 
    col = "black", type = "l"))
```

![plot of chunk unnamed-chunk-6](figure/unnamed-chunk-6.png) 

```r
# dev.off()
```


4. Plotting energy sub metering time series
======================================


```r
# png(file = 'Figures/plot3.png') Create plot and send to a file (no plot
# appears on screen)
with(epc, plot(Datetime, Sub_metering_1, xlab = "", ylab = "", col = "black", 
    type = "l"))
with(epc, points(Datetime, Sub_metering_2, xlab = "", ylab = "", col = "red", 
    type = "l"))
with(epc, points(Datetime, Sub_metering_3, xlab = "", ylab = "", col = "blue", 
    type = "l"))
title(ylab = "Energy sub metering")
legend("topright", lty = 1, col = c("black", "blue", "red"), legend = c("Sub_metering_1", 
    "Sub_metering_1", "Sub_metering_3"))
```

![plot of chunk unnamed-chunk-7](figure/unnamed-chunk-7.png) 

```r
# dev.off()
```

5. Multiple plots
=================


```r
# png(file = 'Figures/plot4.png') Multiple plots
par(mfrow = c(2, 2))
# Plot 1 : time serie ofGlobal active power
with(epc, plot(Datetime, Global_active_power, xlab = "", ylab = "Global active power (kilowatts)", 
    col = "black", type = "l"))
# Plot 2 : time serie of Voltage
with(epc, plot(Datetime, Voltage, col = "black", type = "l"))
# Plot 3 : time serie of Energy sub metering
with(epc, plot(Datetime, Sub_metering_1, xlab = "", ylab = "", col = "black", 
    type = "l"))
with(epc, points(Datetime, Sub_metering_2, xlab = "", ylab = "", col = "red", 
    type = "l"))
with(epc, points(Datetime, Sub_metering_3, xlab = "", ylab = "", col = "blue", 
    type = "l"))
title(ylab = "Energy sub metering")
legend("topright", lty = 1, col = c("black", "blue", "red"), legend = c("Sub_metering_1", 
    "Sub_metering_1", "Sub_metering_3"), bty = "n")
# Plot 4
with(epc, plot(Datetime, Global_reactive_power, col = "black", type = "l"))
```

![plot of chunk unnamed-chunk-8](figure/unnamed-chunk-8.png) 

```r

# dev.off()
```


