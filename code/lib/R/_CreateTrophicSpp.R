library(here)
library(tidyverse)

# set path to code sub dir
setwd(here())

# get all species files
file_list <-  list.files(path = "data/clean",
  pattern = "species.csv",
  full.names = TRUE)

# loop through all files
for (i in 1:length(file_list)) {
  read.csv(file_list[i]) %>%
    bind_rows %>%
    select(c(feeding, motility, tiering, size, time_pre_during_post)) %>%
    group_by(feeding, motility, tiering, size) %>%
    distinct() %>%
    ungroup() %>%
    mutate(species = paste0("sp_", row_number())) %>%
    select(species, feeding, motility, tiering, size, time_pre_during_post) %>%
    write.csv(., str_replace(file_list[i], "species", "trophic"),
              row.names = FALSE)
}
