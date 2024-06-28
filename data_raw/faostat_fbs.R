
# This combines historical and current food balance sheet data into single time series

fbs <- readRDS(paste0("data_raw/faostat/","fbs.rds"))
fbsh <- readRDS(paste0("data_raw/faostat/","fbsh.rds"))

`%notin%` <- Negate(`%in%`) # create "notin" operator

fbs_1 <- subset(fbs, year %notin% c(2010,2011,2012,2013))
fbsh_1 <- subset(fbsh, year %notin% c(2010,2011,2012,2013))

# Choose whether 2010-2013 overlap should favor old or new methodology:
fbs_combined_old <- merge(fbsh, fbs_1, all=T) # old methodology
fbs_combined_new <- merge(fbsh_1, fbs, all=T) # new methodology

# Save for faster loading later
saveRDS(fbs_combined_old, "data_raw/faostat/fbs_combined_old.rds")
saveRDS(fbs_combined_new, "data_raw/faostat/fbs_combined_new.rds")
