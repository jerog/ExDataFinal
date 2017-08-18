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

yearlySums <- with(NEI, tapply(Emissions, year, sum))
years <- as.numeric(dimnames(yearlySums)[[1]])

plot(
  years, 
  yearlySums / 1000, 
  type = "l", 
  col=2, 
  axes = FALSE, # we'll insert these later with a more readable scale
  main = "Total PM2.5 Emissions, USA, 1999-2008",
  xlab = "Year", 
  ylab = "Total Emission (tons x 1000)",
  ylim = c(3000, 8000))

axis(side = 1, at = years)
axis(side = 2, at = seq(3000, 8000, by = 1000))