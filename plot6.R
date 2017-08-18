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
library(lattice)

# "Motor vehicles" determined to be the set of sectors that begin with "Mobile" and don't contain "Non-Road".
# Trains, planes, and ships (not to mention automobiles) are counted.

motorCodes <- SCC %>% filter(grepl("^Mobile", EI.Sector) & !grepl("Non-Road", EI.Sector))

# yearly sums for Baltimore City where the SCC matches the motor vehicle codes we just determined
yearlySums <- 
  NEI %>%
  filter(SCC %in% motorCodes$SCC & fips %in% c('24510','06037')) %>%
  mutate(municipality = ifelse(fips == '24510', 'Baltimore City', 'Los Angeles County')) %>%
  select(municipality, year, Emissions) %>%
  group_by(municipality, year) %>%
  summarise(motorEmissions = sum(Emissions))

print(
  xyplot(
    motorEmissions ~ year|municipality, 
    type="l",
    data = yearlySums, 
    xlab = "Year", 
    ylab = "Emissions (tons)", 
    main = "PM2.5 Emissions, Motor Vehicles, 1999-2008")
  )