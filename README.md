Exploratory Data Analysis - Project 2

# Introduction

Fine particulate matter (PM2.5) is an ambient air pollutant for which there is strong evidence that it is harmful to human health. In the United States, the Environmental Protection Agency (EPA) is tasked with setting national ambient air quality standards for fine PM and for tracking the emissions of this pollutant into the atmosphere. Approximatly every 3 years, the EPA releases its database on emissions of PM2.5. This database is known as the National Emissions Inventory (NEI). You can read more information about the NEI at the EPA National [Emissions Inventory web site](http://www.epa.gov/ttn/chief/eiinformation.html).

For each year and for each type of PM source, the NEI records how many tons of PM2.5 were emitted from that source over the course of the entire year. The data that you will use for this assignment are for 1999, 2002, 2005, and 2008.

# Data

The data for this assignment are available from the course web site as a single zip file:

* [Data for Peer Assessment [29Mb]](https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip)

The zip file contains two files:

PM2.5 Emissions Data (`summarySCC_PM25.rds`): This file contains a data frame with all of the PM2.5 emissions data for 1999, 2002, 2005, and 2008. For each year, the table contains number of tons of PM2.5 emitted from a specific type of source for the entire year. Here are the first few rows.
````
##     fips      SCC Pollutant Emissions  type year
## 4  09001 10100401  PM25-PRI    15.714 POINT 1999
## 8  09001 10100404  PM25-PRI   234.178 POINT 1999
## 12 09001 10100501  PM25-PRI     0.128 POINT 1999
## 16 09001 10200401  PM25-PRI     2.036 POINT 1999
## 20 09001 10200504  PM25-PRI     0.388 POINT 1999
## 24 09001 10200602  PM25-PRI     1.490 POINT 1999
````

* `fips`: A five-digit number (represented as a string) indicating the U.S. county
* `SCC`: The name of the source as indicated by a digit string (see source code classification table)
* `Pollutant`: A string indicating the pollutant
* `Emissions`: Amount of PM2.5 emitted, in tons
* `type`: The type of source (point, non-point, on-road, or non-road)
* `year`: The year of emissions recorded

Source Classification Code Table (`Source_Classification_Code.rds`): This table provides a mapping from the SCC digit strings int he Emissions table to the actual name of the PM2.5 source. The sources are categorized in a few different ways from more general to more specific and you may choose to explore whatever categories you think are most useful. For example, source “10100101” is known as “Ext Comb /Electric Gen /Anthracite Coal /Pulverized Coal”.

# Assignment

The overall goal of this assignment is to explore the National Emissions Inventory database and see what it say about fine particulate matter pollution in the United states over the 10-year period 1999–2008. You may use any R package you want to support your analysis.

## Preparing the Data Set 

```{r setup,echo=FALSE}
if(!file.exists("./data")){
        dir.create("./data")
}
fileUrl = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
destfile="./data/exdata_data_NEI_data.zip"
download.file(fileUrl, destfile, method ="auto")
unzip(destfile, overwrite = T, exdir = "./data")
```

Now load the .rds files using the `readRDS()` function: 

```{r data, cache=TRUE}
NEI = readRDS("summarySCC_PM25.rds")
SCC = readRDS("Source_Classification_Code.rds")
```

## Questions

You must address the following questions and tasks in your exploratory analysis. For each question/task you will need to make a single plot. Unless specified, you can use any plotting system in R to make your plot.

### Question 1

Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 

```{r aggregate,cache=TRUE}
library(plyr)
aggregate = with(NEI, aggregate(Emissions, by = list(year), sum))
```

Using the base plotting system to plot the total PM2.5 Emission from all sources: 

```{r plot1}
plot(aggregate, 
    type = 'b', col = 'red', 
    xlab = 'Year', ylab = 'Total PM2.5 emissions', 
    main = 'Total PM2.5 emissions in the US (1999-2008)', 
    xaxt="n")
axis(1, at = seq(1999, 2008, by = 3), las = 1)
```

![alt tag](https://github.com/lvncnt/ExDataAnalysisII/blob/master/plot1.png)

* Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 

The total emissions from PM2.5 have decreased in the United States from 1999 to 2008. 

### Question 2

Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008? 

```{r baltimore,cache=TRUE}
NEI_BC = NEI[NEI$fips == '24510',]
aggregate_BC = with(NEI_BC, aggregate(Emissions, by = list(year), sum))
```

Using the base plotting system to make a plot of this data,

```{r plot2}
plot(aggregate_BC, 
    type = 'b', col = 'red', 
    xlab = 'Year', ylab = 'Total PM2.5 emissions', 
    main = 'Total PM2.5 emissions in Baltimore (1999-2008)', 
    xaxt="n")
axis(1, at = seq(1999, 2008, by = 3), las = 1)
```

![alt tag](https://github.com/lvncnt/ExDataAnalysisII/blob/master/plot2.png)

*Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008? 

        Overall the total emissions from PM2.5 have decreased in the Baltimore City, Maryland from 1999 to 2008, though there was an increase of PM2.5 between the year 2002 and 2005. 

### Question 3

Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? 

```{r plot3}
library(ggplot2)

NEI_BC = NEI[NEI$fips == '24510',]
NEI_BC_type = ddply(NEI_BC, .(type, year), summarize, Emissions = sum(Emissions))

gg1 = ggplot(data = NEI_BC_type, 
    aes(x = year, y = Emissions, color = type, group = type)) + 
    geom_point() + 
    geom_line() 
gg2 = gg1 + 
    labs(x="Year", y="Total PM2.5 Emissions", title="Total Emissions by Pollutant Type")
gg2 + theme(legend.title = element_text(colour="chocolate", size=12, face="bold")) + 
    scale_color_discrete(name="Pollutant\nType")

dev.copy(png, file = 'plot3.png', width = 480, height = 480)
dev.off()
```
![alt tag](https://github.com/lvncnt/ExDataAnalysisII/blob/master/plot3.png)

**Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? Which have seen increases in emissions from 1999–2008?**

The `non-road`, `nonpoint`, `on-road` source types have seen decreased emissions overall from 1999-2008 for Baltimore City. The `point` source was seen an increase overall from 1999-2008. 

### Question 4

Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?

```{r combustion,cache=TRUE}
SCC_coal = SCC[grepl("coal", SCC$Short.Name, ignore.case = T),]$SCC
SCC_coal = as.character(SCC_coal)
NEI$SCC = as.character(NEI$SCC)
NEI_coal = NEI[NEI$SCC %in% SCC_coal, ]
aggregate_coal = with(NEI_coal, aggregate(Emissions, by = list(year), sum))

```
Now plot the data `aggregate_coal`

```{r plot4}
plot(aggregate_coal, 
    type = 'b', col = 'red', 
    xlab = 'Year', ylab = 'Total PM2.5 emissions', 
    main = 'Coal combustion Emissions', 
    xaxt="n")
axis(1, at = seq(1999, 2008, by = 3), las = 1)

dev.copy(png, file = 'plot4.png', width = 480, height = 480)
dev.off()
```

![alt tag](https://github.com/lvncnt/ExDataAnalysisII/blob/master/plot4.png)

**Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?**

The overall trend was decreasing from 1999 to 2008, although there was a slight increase between 2002 and 2005.

### Question 5

How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City? 

```{r motorVehicles,cache=TRUE}
SCC_motor = SCC[grepl("vehicles", SCC$EI.Sector, ignore.case = T),]$SCC
SCC_motor = as.character(SCC_motor)
NEI$SCC = as.character(NEI$SCC)
NEI_motor_BC = NEI[(NEI$SCC %in% SCC_motor) & (NEI$fips == "24510"), ]
aggregate_motor = with(NEI_motor_BC, aggregate(Emissions, by = list(year), sum))
```

Next making a plot of `aggregate_motor`,

```{r plot5}
plot(aggregate_motor, 
    type = 'b', col = 'red', 
    xlab = 'Year', ylab = 'Total PM2.5 emissions',
    main = 'Emissions from motor vehicle sources', 
    xaxt="n")
axis(1, at = seq(1999, 2008, by = 3), las = 1)

dev.copy(png, file = 'plot5.png', width = 480, height = 480)
dev.off()
```

![alt tag](https://github.com/lvncnt/ExDataAnalysisII/blob/master/plot5.png) 

**How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?**

Emissions from motor vehicle sources in Baltimore City steeply decreased from 1999 to 2005 and then undergone slight decrease between 2002 - 2005 and a further decrease from 2005 - 2008.

### Question 6

Comparing emissions from motor vehicle sources in Baltimore City (fips == "24510") with emissions from motor vehicle sources in Los Angeles County, California (fips == "06037"),

```{r mvBaltimoreLA,cache=TRUE}
SCC_motor = SCC[grepl("vehicle", SCC$EI.Sector, ignore.case = T),]$SCC
SCC_motor = as.character(SCC_motor)
NEI$SCC = as.character(NEI$SCC)
NEI_motor_BC = NEI[(NEI$SCC %in% SCC_motor) & (NEI$fips == "24510"), ]
aggregate_motor_BC = with(NEI_motor_BC, aggregate(Emissions, by = list(year), sum))
aggregate_motor_BC$city = "Baltimore City"
aggregate_motor_BC$relEmissions = aggregate_motor_BC$x/aggregate_motor_BC$x[1]

NEI_motor_AC = NEI[(NEI$SCC %in% SCC_motor) & (NEI$fips == "06037"), ]
aggregate_motor_AC = with(NEI_motor_AC, aggregate(Emissions, by = list(year), sum))
aggregate_motor_AC$city = "Los Angeles"
aggregate_motor_AC$relEmissions = aggregate_motor_AC$x/aggregate_motor_AC$x[1]

aggregate_motor = rbind(aggregate_motor_BC, aggregate_motor_AC)
names(aggregate_motor) = c("year", "Emissions", "city", "relEmissions")
```

Now plot the `aggregate_motor` using the ggplot2 system,

```{r plot6}
library(ggplot2)
 

gg1 = ggplot(data = aggregate_motor, aes(x = year, y = relEmissions, color = city, group = city)) + 
    geom_point() + geom_line() 
gg2 = gg1 + labs(x="Year", y="Fold Emission changes (to 1999)", 
    title="Emission Changes Relative to 1999 in BC & LA")
gg2 + theme(legend.title = element_text(colour="chocolate", size=12, face="bold")) + 
    scale_color_discrete(name="City")

dev.copy(png, file = 'plot6.png', width = 480, height = 480)
dev.off()
```
![alt tag](https://github.com/lvncnt/ExDataAnalysisII/blob/master/plot6.png)

**Which city has seen greater changes over time in motor vehicle emissions?**

Emissions from motor vehicle sources in Baltimore City continuously decreased from 1999 to 2008 by 75 percent whereas emissions from motor vehicle sources since 1999 in Los Angeles County undergone slight changes relative to 1999. So Baltimore City has seen greater changes over time in motor vehicle emissions. 
