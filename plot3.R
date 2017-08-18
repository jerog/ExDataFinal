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

## Let's save time reading these big files. Assumes we do not alter the content in place.

if (!("NEI" %in% ls())) NEI <- readRDS("summarySCC_PM25.rds")
if (!("SCC" %in% ls())) SCC <- readRDS("Source_Classification_Code.rds")

library(dplyr)

bmoreCityEmissionsByYearAndType <-
  NEI %>% 
  filter(fips == '24510') %>%
  select(year, type, Emissions) %>%
  group_by(year, type) %>%
  summarise(totalEmissions = sum(Emissions))


print(
  ggplot(bmoreCityEmissionsByYearAndType, aes(x = year, y = totalEmissions)) + 
    scale_x_continuous(name = "Year", breaks = seq(1999, 2008, by=3)) +
    labs(y = "Emissions (tons)", title = "PM2.5 Emissions by Source, Baltimore City, 1999-2008") +
    theme(panel.spacing = unit(1, "lines")) +
    facet_grid(. ~ type) + 
    geom_line()
)
