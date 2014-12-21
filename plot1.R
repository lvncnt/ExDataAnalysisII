"""
PM2.5 Emissions Data (summarySCC_PM25.rds): This file contains a data frame with all of the PM2.5 emissions data for 1999, 2002, 2005, and 2008. For each year, the table contains number of tons of PM2.5 emitted from a specific type of source for the entire year. 

Source Classification Code Table (Source_Classification_Code.rds): This table provides a mapping from the SCC digit strings in the Emissions table to the actual name of the PM2.5 source. 

""" 
## Download the Data Set 

if(!file.exists("./data")){
        dir.create("./data")
}
fileUrl = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
destfile="./data/exdata_data_NEI_data.zip"
download.file(fileUrl, destfile, method ="auto")
unzip(destfile, overwrite = T, exdir = "./data")

setwd(paste(getwd(), "data", sep = '/'))

## Read files using the readRDS() function

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Question 1 
#  Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? Using the base plotting system, make a plot showing the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.
library(plyr)

aggregate = with(NEI, aggregate(Emissions, by = list(year), sum))
plot(aggregate, type = 'b', col = 'red', xlab = 'Year', ylab = 'Total PM2.5 emissions', main = 'Total PM2.5 emissions in the US (1999-2008)', xaxt="n")
axis(1, at = seq(1999, 2008, by = 3), las = 1)

# the total emissions from PM2.5 have decreased in the United States from 1999 to 2008

dev.copy(png, file = 'plot1.png', width = 480, height = 480)
dev.off()
 
