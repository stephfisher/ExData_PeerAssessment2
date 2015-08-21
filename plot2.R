###Exploratory Data Analysis
### Course Project 2 - Plot 2
### Q2: Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008? Use the base plotting system to make a plot answering this question.

### Download file "Data for Peer Assessment" and unzip
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(fileUrl,destfile = "./data/exdata_2Fdata_2FNEI_data.zip",method = "curl")
unzip(zipfile = "./data/exdata_2Fdata_2FNEI_data.zip",exdir = "./data")

### Read data
### This first line will likely take a few seconds. Be patient!
NEI <- readRDS("./data/summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds")

### Filter NEI Data for Balitmore City (fips == "24510")
baltimoreData <- subset(NEI, fips == "24510")

### Aggregate data - Sum emissions by year 
baltimoreAggData <- aggregate(Emissions ~ year, baltimoreData, sum)

### Plot aggregated emissions by year
### Will use bar plot
with (baltimoreAggData,
	barplot(height = Emissions, 
	names.arg = year,
	xlab = "Year", 
	ylab = expression("Emissions PM"[2.5]),
	main = expression("Baltimore City Emissions by Year 1999-2008")))

### Copy plot to png file (480x480 pixels) -- don't forget to close the PNG device!
dev.copy (png, file = "./data/plot2.png", height = 480, width = 480) 
dev.off() 