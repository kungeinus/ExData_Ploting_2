# Load the NEI & SCC data frames.
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Aggregate by sum the total emissions by year
aggTotals <- aggregate(Emissions ~ year,data = NEI, sum)

png("plot1.png",width=480,height=480,units="px",bg="transparent")
par(mar=c(5.1,5.1,4.1,2.1))
barplot(
        (aggTotals$Emissions)/10^6,
        names.arg=aggTotals$year,
        xlab="Year",
        ylab=expression("PM2.5 Emissions"~(10^{6}~"Tons")),
        main="Total PM2.5 Emissions From All US Sources",
        col="red"
)

dev.off()