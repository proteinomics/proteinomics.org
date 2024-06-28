# This file looks at global dietary protein compositions

library(tidyverse)
library(here)
library(plotly)

# If running for the first time,
# create a dataframe that combines historical and new food balance sheets:
# source("data_raw/faostat_fbs.R")
# Load combined food balance sheet data
fbs <- read_rds(paste0(here(),"/data_raw/faostat/fbs_combined_new.rds"))

# Create lists of item, element, and area codes

# 674 Protein supply quantity (g/capita/day)
# 684 Fat supply quantity (g/capita/day)
# 664 Food supply (kcal/capita/day)
# 511 Total population
element_codes <- c(674)

# 2941 Animal products
# 2903 Vegetal products
# 2901 Grand total
# S2501 Population
item_codes <- c(2903, 2941, 2901)

# 5707 European Union (27)
# 5000 World
# 5205 Latin America and the Caribbean (x)
# 5501 Australia and New Zealand
# 5203 Northern America
# 5204 Central America
# 5207 South America
# 5400 Europe
# 336 North and Central America (x)
# all_continent_groups <- continent_groups$Country.Group.Code
area_codes <- c(5000)

# Create continental North America by combining Northern America
# and Central America groupings

world <- fbs %>%
  filter(element_code %in% element_codes) %>%
  filter(item_code %in% item_codes) %>%
  filter(area_code %in% area_codes) 

world_plot <- world %>%
  plot_ly(
    x = ~year,
    y = ~value,
    color = ~item,
    type = 'scatter',
    mode = 'lines+markers'
  ) %>%
  layout(
    title = "World",
    xaxis = list(title = ""),
    yaxis = list(title = "g/capita/day"),
    showlegend = TRUE,
    legend = list(orientation = "h", x=0.5, xanchor='center',y=-0.2)
  ) %>%
  config(displayModeBar=F)



