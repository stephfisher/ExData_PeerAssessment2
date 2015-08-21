### Exploratory Data Analysis
### Course Project 2 - Plot 3
### Q3:Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? Which have seen increases in emissions from 1999–2008? Use the ggplot2 plotting system to make a plot answer this question.

### Download file "Data for Peer Assessment" and unzip
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(fileUrl,destfile = "./data/exdata_2Fdata_2FNEI_data.zip",method = "curl")
unzip(zipfile = "./data/exdata_2Fdata_2FNEI_data.zip",exdir = "./data")

### Install and load ggplot2 library
for (package in c("ggplot2")) {
    if (!require(package, character.only=T, quietly=T)) {
        install.packages(package)
        library(package, character.only=T)
    }
}

### Read data
### This first line will likely take a few seconds. Be patient!
NEI <- readRDS("./data/summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds")

### Filter NEI Data for Balitmore City (fips == "24510")
baltimoreData <- subset(NEI, fips == "24510")

### Aggregate data - Sum emissions by year and type
baltimoreAggData <- aggregate(Emissions ~ year + type, baltimoreData, sum)

### Initiate call to ggplot and specify the data frame
g <- ggplot(baltimoreAggData, aes(x=year, y= Emissions, color = type))

### Take information from g object and create plot
g <- g + scale_x_continuous(breaks=c(1999,2002,2005,2008)) +
	geom_line(size = 1) +
	geom_point(size = 3) + 
	xlab("Year") +
	ylab(expression("Emissions PM"[2.5])) +
	ggtitle(expression("Baltimore City Emissions by Year and Type 1999-2008"))

### Print g
print(g)

### Copy plot to png file (480x480 pixels) -- don't forget to close the PNG device!
dev.copy (png, file = "./data/plot3.png", height = 480, width = 480) 
dev.off() 