library(ggplot2)
library(tidyverse)
library(plotly)
library(here)

# Load fao data
#crop_production <- readRDS("data_raw/crop_production_e_all_data.rds")
fbs <- read_rds(paste0(here(),"/data_raw/faostat/","fbs_combined_new.rds"))

protein <- fbs %>%
  filter(element_code == 674) %>%
  filter(item_code == 2941 | item_code == 2903 | item_code == 2901)

protein_wide <- protein %>%
  pivot_wider(id_cols = c(area, year), names_from = item, values_from = value) %>%
  filter(year == 1961)

total <- protein %>%
  filter(item_code==2901) %>%
  mutate(total = value)
vegetal <- protein %>%
  filter(item_code==2903) %>%
  mutate(vegetal = value)
animal <- protein %>%
  filter(item_code==2941) %>%
  mutate(animal = value)

test <- protein_wide %>%
  ggplot(aes(`Animal Products`, `Vegetal Products`, colour = area, size = `Grand Total`)) + 
  geom_point(show.legend = FALSE) + 
  theme_void() +
  theme(
    plot.title = element_text(hjust = 0.5),
    legend.position = "bottom",
    panel.grid.major = element_blank(),  # Remove major grid lines
    panel.grid.minor = element_blank(),  # Remove minor grid lines
    panel.border = element_blank(),      # Remove panel border
    axis.line = element_blank()          # Remove axis lines
  )


test
#ggplotly(test)

