#### This file downloads faostat data using the FAOSTAT package
#### https://cran.r-project.org/web/packages/FAOSTAT/index.html

library(tidyverse)
library(FAOSTAT)

# Create folder
data_folder <- "data_raw/faostat" 
dir.create(data_folder) # create directory if it doesn't already exist

# Download data
#crop_production <- get_faostat_bulk(code = "QCL", data_folder = data_folder)
# Food Balances (2010-)
fbs <- get_faostat_bulk(code = "FBS", data_folder = data_folder)
# Food Balances historical (-2013)
fbsh <- get_faostat_bulk(code = "FBSH", data_folder = data_folder)

# Save data in rds format for faster loading later
#saveRDS(crop_production, "data_raw/crop_production_e_all_data.rds")
saveRDS(fbs, paste0(data_folder, "/fbs.rds"))
saveRDS(fbsh, paste0(data_folder, "/fbsh.rds"))

# Load data from saved file
#crop_production <- readRDS("data_raw/crop_production_e_all_data.rds")
#fbs <- readRDS(paste0(data_folder,"/fbs.rds"))
#fbsh <- readRDS(paste0(data_folder,"/fbsh.rds"))