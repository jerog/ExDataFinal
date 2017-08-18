## Download files if they doesn't exist in the working directory

if (!file.exists("summarySCC_PM25.rds")) {
  library(zip)
  download.file(
    "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip",
    "rawsource.zip",
    method = "curl"
  )
  unzip("rawsource.zip")
}

# Let's save time reading these big files. Assumes we do not alter the content in place.
if (!("NEI" %in% ls())) NEI <- readRDS("summarySCC_PM25.rds")
if (!("SCC" %in% ls())) SCC <- readRDS("Source_Classification_Code.rds")

library(dplyr)

# "Motor vehicles" determined to be the set of sectors that begin with "Mobile" and don't contain "Non-Road".
# Trains, planes, and ships (not to mention automobiles) are counted.

motorCodes <- SCC %>% filter(grepl("^Mobile", EI.Sector) & !grepl("Non-Road", EI.Sector))

# yearly sums for Baltimore City where the SCC matches the motor vehicle codes we just determined
yearlySums <- 
  NEI %>%
  filter(SCC %in% motorCodes$SCC & fips == "24510") %>%
  select(year, Emissions) %>%
  group_by(year) %>%
  summarise(motorEmissions = sum(Emissions))

plot(
  yearlySums$year, 
  yearlySums$motorEmissions, 
  type = "l", 
  col=2, 
  axes = FALSE, # we'll insert these later with a more readable scale
  main = "Total PM2.5 Emissions from Motor Vehicles, Baltimore City, 1999-2008",
  xlab = "Year", 
  ylab = "Total Emissions (tons)"
)

axis(side = 1, at = yearlySums$year)
axis(side = 2, at = seq(300, 800, by = 100))