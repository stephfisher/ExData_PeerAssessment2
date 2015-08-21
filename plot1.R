### Explorartory Data Analysis
### Course Project 2 - Plot 1
### Q1: Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? Using the base plotting system, make a plot showing the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.

### Download file "Data for Peer Assessment" and unzip
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(fileUrl,destfile = "./data/exdata_2Fdata_2FNEI_data.zip",method = "curl")
unzip(zipfile = "./data/exdata_2Fdata_2FNEI_data.zip",exdir = "./data")

### Read data
### This first line will likely take a few seconds. Be patient!
NEI <- readRDS("./data/summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds")

### Aggregate data - Sum emissions by year
aggData <- aggregate(Emissions~year, NEI, sum)

### Plot aggregated emissions by year
### Will use bar plot
with (aggData,
	barplot(height = Emissions, 
	names.arg = year,
	xlab = "Year", 
	ylab = expression("Emissions PM"[2.5]),
	main = expression("Total US Emissions by Year 1999-2008")))

### Copy plot to png file (480x480 pixels) -- don't forget to close the PNG device!
dev.copy (png, file = "./data/plot1.png", height = 480, width = 480) 
dev.off() 



