# This file looks at global dietary protein compositions by continent.
# It includes some aggregate country groupings

# Create country group mappings for ease of reference
source("data_raw/faostat_country_groups.R")

# If running for the first time,
# create a dataframe that combines historical and new food balance sheets:
# source("food_balance_sheets.R")
# Load combined food balance sheet data
fbs <- read_rds("data_raw/faostat/fbs_combined_new.rds")

# --- #

# Global

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

protein <- fbs %>%
  filter(element_code %in% element_codes) %>%
  filter(item_code %in% item_codes) %>%
  filter(area_code %in% area_codes) 

# Plot
p <- ggplot(protein, aes(x = year, y = value, color = item)) + 
  geom_line() +
  facet_wrap(~ area, scales = "fixed") + # Create a separate plot for each country
  geom_point() + # Optional: adds points to the line plot
  #scale_color_manual(values = c("red", "blue", "green")) + # Optional: custom colors for lines
  labs(title = "Protein Supply Quantity",
       x = "Year", 
       y = "g/capita/day",
       color = "Protein Supply") +
  theme_gray()

# Print the plot
ggplotly(p)

# Split into separate dataframes
protein_list <- split(protein, protein$area) %>%
  # Convert to wide
  lapply(function(df){
    df %>%
      select(year, item, value) %>%
      spread(key = item, value = value)
  })

# Create a directory for the CSV files, if it doesn't already exist
dir.create("data_csv/continents", recursive = TRUE, showWarnings = FALSE)

# Save each dataframe as a CSV file
lapply(names(protein_list), function(area) {
  file_path <- paste0("data_csv/continents/", area, ".csv")
  write_csv(protein_list[[area]], file_path)
})


