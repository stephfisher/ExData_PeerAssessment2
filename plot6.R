### Exploratory Data Analysis
### Course Project 2 - Plot 6
### Q6: Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, California (fips == "06037"). Which city has seen greater changes over time in motor vehicle emissions?

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

### Filter data for Balitmore City of Los Angeles County and "motor vechicle sources"
### I wasn't sure to filter based on SCC$EI.Sector or NEI$Type, so I opted for type = ON-ROAD to be more inclusive
motorData <- subset(mergedData, (fips == "24510" | fips =="06037") & type == "ON-ROAD")

### Aggregate data - Sum Baltimore City motor vechicle emissions by year
aggData <- aggregate(Emissions~year + fips, motorData, sum)

### Assign fips city names
colnames(aggData)[2] <- "City"
aggData$City[aggData$City == "24510"] <- "Baltimore City"
aggData$City[aggData$City == "06037"] <- "Los Angeles"

### Calculate the linear regression and coefficents (mean change)
subsetBaltimore <- subset(aggData, City == "Baltimore City")
subsetLosAngeles <- subset(aggData, City == "Los Angeles")
lmBaltimore <- lm(Emissions~year, subsetBaltimore)
lmLosAngeles <- lm(Emissions~year, subsetLosAngeles)
slopeBaltimore <- round(lmBaltimore$coefficients["year"], digits = 2)
slopeLosAngeles <-round(lmLosAngeles$coefficients["year"], digits = 2)
slopeText <- data.frame(
	year = c(2004, 2004), 
	Emissions = c(750, 3750),
	City = c("Baltimore City", "Los Angeles"),
	slope = c(paste("slope = ", slopeBaltimore, sep = ""),
		  paste("slope = ", slopeLosAngeles, sep = "")))

### Initiate call to ggplot and specify the data frame
g <- ggplot(aggData, aes(year, Emissions))

### Take information from g object and create plot
g <- g + facet_grid(.~City) +
	scale_x_continuous(breaks=c(1999,2002,2005,2008)) +
	geom_bar(stat = "identity") +
	geom_smooth(method = "lm", size = 2, se = FALSE) +
	xlab("Year") +
	ylab(expression("Emissions PM"[2.5])) +
	ggtitle(expression("City Emissions by Year and Type 1999-2008"))	

### Add slope coefficients to plot
g <- g + geom_text(data = slopeText, aes(label = slope), color = "steel blue")

### Print g
print(g)

### Copy plot to png file (480x480 pixels) -- don't forget to close the PNG device!
dev.copy (png, file = "./data/plot6.png", height = 480, width = 480) 
dev.off() 

