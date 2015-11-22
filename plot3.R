library(ggplot2)

# Load the NEI & SCC data frames.
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Subset NEI data by Baltimore's fip.
baltimoreNEI <- NEI[NEI$fips=="24510",]

# Aggregate using sum the Baltimore emissions data by year
aggTotalsBaltimore <- aggregate(Emissions ~ year + type, baltimoreNEI,sum)

png("plot3.png",width=480,height=480,units="px",bg="transparent")



ggp <- ggplot(aggTotalsBaltimore,aes(year,Emissions,color=type)) +
        geom_line(stat = "identity",size = 2) +
        theme_bw() + 
        labs(x="year", y=expression("Total PM"[2.5]*" Emission (Tons)")) + 
        labs(title=expression("PM"[2.5]*" Emissions, Baltimore City 1999-2008 by Source Type"))+
        scale_x_continuous(breaks=c(1999,2002,2005,2008))
print(ggp)

dev.off()