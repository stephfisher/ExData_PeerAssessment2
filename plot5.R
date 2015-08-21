### Exploratory Data Analysis
### Course Project 2 - Plot 5
### Q5: How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

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

### Merge NEI & SCC
mergedData <- merge(NEI, SCC, by = "SCC")

### Filter Data for Balitmore City and "motor vechicle sources"
### I wasn't sure to filter based on SCC$EI.Sector or NEI$Type, so I opted for type = ON-ROAD to be more inclusive
baltimoreData <- subset(mergedData, fips == "24510" & type == "ON-ROAD")

### Aggregate data - Sum Baltimore City motor vechicle emissions by year
aggData <- aggregate(Emissions~year, baltimoreData, sum)

### Initiate call to ggplot and specify the data frame
g <- ggplot(aggData, aes(factor(year), Emissions))

### Take information from g object and create plot
g <- g + geom_bar(stat = "identity") +
	xlab("Year") +
	ylab(expression("Emissions PM"[2.5])) +
	ggtitle(expression("Baltimore City Motor Vechicle Sources Emissions by Year 1999-2008"))

### Print g
print(g)

### Copy plot to png file (480x480 pixels) -- don't forget to close the PNG device!
dev.copy (png, file = "./data/plot5.png", height = 480, width = 480) 
dev.off() 