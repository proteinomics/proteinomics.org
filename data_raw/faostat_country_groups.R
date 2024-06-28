
# This file creates mappings of FAO country groups for ease of reference

# Load libraries
library(tidyverse)

## Load FAO country groups from csv
## download manually from https://www.fao.org/faostat/en/#definitions
fao_groups <- read_csv("data_raw/faostat/FAOSTAT_data_6-28-2024.csv") %>%
  data.frame()

# Make mappings

## special groups
special_groups <- fao_groups %>%
  filter(Country.Group.Code != 5000) %>%
  filter(Country.Group.Code > 5700) 
## continent groups
continent_groups <- fao_groups %>%
  filter(Country.Group.Code != 5000) %>%
  filter(Country.Group.Code < 5700) %>%
  filter((Country.Group.Code/100)%%1==0)
## region groups
region_groups <- fao_groups %>%
  filter(Country.Group.Code != 5000) %>%
  filter(Country.Group.Code < 5700) %>%
  filter((Country.Group.Code/100)%%1>0)

## continent to region group mapping
africa <- region_groups %>%
  filter(Country.Group.Code > 5100, Country.Group.Code < 5200)
americas <- region_groups %>%
  filter(Country.Group.Code > 5200, Country.Group.Code < 5300)
asia <- region_groups %>%
  filter(Country.Group.Code > 5300, Country.Group.Code < 5400)
europe <- region_groups %>%
  filter(Country.Group.Code > 5400, Country.Group.Code < 5500)
oceania <- region_groups %>%
  filter(Country.Group.Code > 5500, Country.Group.Code < 5600)

## special group mapping
eu27 <- special_groups %>%
  filter(Country.Group.Code == 5707)
lldc <- special_groups %>%
  filter(Country.Group.Code == 5802)
ldc <- special_groups %>%
  filter(Country.Group.Code == 5801)
lifdc <- special_groups %>%
  filter(Country.Group.Code == 5815)
nfidc <- special_groups %>%
  filter(Country.Group.Code == 5817)
sids <- special_groups %>%
  filter(Country.Group.Code == 5803)

# Make single data frame with new columns for each grouping
## add continents
fao_groups_all <- fao_groups %>%
  left_join(rename(select(continent_groups, Country.Code, Country.Group, Country.Group.Code), continent=Country.Group, continent.code=Country.Group.Code), by='Country.Code')
## add regions
fao_groups_all <- fao_groups_all %>%
  left_join(rename(select(region_groups, Country.Code, Country.Group, Country.Group.Code), region=Country.Group, region.code=Country.Group.Code), by='Country.Code')
## add special groups
### note: special groups are not mutually exclusive
fao_groups_all <- fao_groups_all %>%
  select(-Country.Group, -Country.Group.Code) %>%
  distinct(Country, .keep_all = T) %>%
  left_join(rename(select(eu27,Country.Code,Country.Group,Country.Group.Code),eu27=Country.Group, eu27.code=Country.Group.Code), by='Country.Code') %>%
  left_join(rename(select(lldc,Country.Code,Country.Group,Country.Group.Code),lldc=Country.Group, lldc.code=Country.Group.Code), by='Country.Code') %>%
  left_join(rename(select(ldc,Country.Code,Country.Group,Country.Group.Code),ldc=Country.Group, ldc.code=Country.Group.Code), by='Country.Code') %>%
  left_join(rename(select(lifdc,Country.Code,Country.Group,Country.Group.Code),lifdc=Country.Group, lifdc.code=Country.Group.Code), by='Country.Code') %>%
  left_join(rename(select(nfidc,Country.Code,Country.Group,Country.Group.Code),nfidc=Country.Group, nfidc.code=Country.Group.Code), by='Country.Code') %>%
  left_join(rename(select(sids,Country.Code,Country.Group,Country.Group.Code),sids=Country.Group, sids.code=Country.Group.Code), by='Country.Code')

# Make dataframe of only aggregates
fao_aggregates <- continent_groups %>%
  bind_rows(region_groups) %>%
  bind_rows(special_groups) %>%
  select(Country.Group.Code, Country.Group) %>%
  distinct()

## save as rds
write_rds(fao_groups_all, 'data_raw/faostat/fao_groups.rds')
write_rds(fao_aggregates, 'data_raw/faostat/fao_aggregates.rds')
