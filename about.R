# Load the necessary libraries
library(tidyverse)
library(plotly)

# Read the Google Trends data from CSV
pw <- read_csv("gtrends.csv")

# Convert Month to Date format
pw$Month <- as.Date(paste0(pw$Month, "-01"))

# Create the ggplot2 plot
p_chart <- ggplot(pw, aes(x = Month, y = protein)) +
  geom_line(color = 'red') +
  labs(
    title = '"Protein" Search Popularity',
    x = '',
    y = ''
  ) +
  ylim(0, 100) +
  theme_minimal()

#p_chart <- ggplotly(p_chart)

# Convert the ggplot2 plot to an interactive plotly plot
#p_chart <- ggplotly(p_chart_gg) %>%
 # layout(showlegend = FALSE)

# Display the plot
p_chart
