# Load the NEI & SCC data frames.
library(ggplot2)
library(gridExtra)
library(grid)
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Gather the subset of the NEI data which corresponds to vehicles
vehicles <- grepl("vehicle", SCC$SCC.Level.Two, ignore.case=TRUE)
vehiclesSCC <- SCC[vehicles,]$SCC
vehiclesNEI <- NEI[NEI$SCC %in% vehiclesSCC,]

# Subset the vehicles NEI data by each city's fip and add city name.
vehiclesBaltimoreNEI <- vehiclesNEI[vehiclesNEI$fips=="24510",]
vehiclesBaltimoreNEI$city <- "Baltimore City"
AggBaltimoreNEI<-aggregate(Emissions ~ year + city, vehiclesBaltimoreNEI,sum)
AggBaltimoreNEI$change<-(AggBaltimoreNEI$Emissions/AggBaltimoreNEI$Emissions[1]-1)*100

vehiclesLANEI <- vehiclesNEI[vehiclesNEI$fips=="06037",]
vehiclesLANEI$city <- "Los Angeles County"
AggLANEI<-aggregate(Emissions ~ year + city, vehiclesLANEI,sum)
AggLANEI$change<-(AggLANEI$Emissions/AggLANEI$Emissions[1]-1)*100
# Combine the two subsets with city name into one data frame
bothNEI <- rbind(AggBaltimoreNEI,AggLANEI)

png("plot6.png",width=861,height=522,units="px",bg="transparent")



ggp1 <- ggplot(bothNEI, aes(x=factor(year), y=Emissions, fill=city)) +
        geom_bar(stat="identity") +
        theme_bw() +
        theme(legend.position = "top")+
        labs(x="Year", y=expression("Total PM"[2.5]*" Emission(Tons)"))
ggp2 <- ggplot(bothNEI, aes(x=year, y=change, color=city)) +
        geom_line(stat="identity",size=2) +
        theme_bw() +
        theme(legend.position = "top")+
        labs(x="Year", y=expression("Total PM"[2.5]*" Change Percentage")) + 
        scale_x_continuous(breaks=c(1999,2002,2005,2008))


grid.arrange(ggp1, ggp2, ncol = 2, top="PM2.5 Motor Vehicle Source Emissions in Baltimore and Los Angles from 1999-2008")

dev.off()