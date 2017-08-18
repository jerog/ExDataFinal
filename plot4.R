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

coalCodes <- SCC %>% filter(grepl("Coal", Short.Name))

yearlySums <- 
  NEI %>%
  filter(SCC %in% coalCodes$SCC) %>%
  select(year, Emissions) %>%
  group_by(year) %>%
  summarise(coalEmissions = sum(Emissions))

plot(
  yearlySums$year, 
  yearlySums$coalEmissions / 1000, 
  type = "l", 
  col=2, 
  axes = FALSE, # we'll insert these later with a more readable scale
  main = "Total PM2.5 Emissions from Coal Combustion, USA, 1999-2008",
  xlab = "Year", 
  ylab = "Total Emission (tons x 1000)"
)

axis(side = 1, at = yearlySums$year)
axis(side = 2, at = seq(350, 600, by = 50))