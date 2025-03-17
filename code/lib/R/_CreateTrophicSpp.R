library(here)
library(tidyverse)

# set path to code sub dir
setwd(here())

# get all species files
file_list <-  list.files(path = "data/raw",
  pattern = "species.csv",
  full.names = TRUE)

#### Maximal traits ####

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
    write.csv(., str_replace(str_replace(file_list[i], "species", "trophic"), "raw", "clean/maximal"),
              row.names = FALSE)
}

#### Minimum traits ####

# loop through all files
for (i in 1:length(file_list)) {
  read.csv(file_list[i]) %>%
    bind_rows %>%
    select(c(feeding, motility, tiering, size, time_pre_during_post)) %>%
    mutate(feeding = case_when(feeding == "grazer_herbivore" ~ "herbivore",
                               str_detect(feeding, "^.*deposit.*$") ~ "herbivore",
                               str_detect(feeding, "^.*suspension.*$") ~ "herbivore",
                               TRUE ~ feeding),
           motility = case_when(motility == "nonmotile_attached" ~ "attached",
                                motility == "nonmotile_byssate" ~ "attached",
                                TRUE ~ motility),
           tiering = case_when(tiering == "shallow_infaunal" ~ "infaunal",
                               tiering == "deep_infaunal" ~ "infaunal",
                               str_detect(tiering, "^.*epifaunal.*$") ~ "epifaunal",
                               TRUE ~ tiering),
           size = case_when(str_detect(size, "^.*large.*$") ~ "large",
                            str_detect(size, "^.*medium.*$") ~ "medium",
                            str_detect(size, "^.*small.*$") ~ "small",
                            str_detect(size, "^.*tiny.*$") ~ "tiny",
                            TRUE ~ size)) %>%
    group_by(feeding, motility, tiering, size) %>%
    distinct() %>%
    ungroup() %>%
    mutate(species = paste0("sp_", row_number())) %>%
    select(species, feeding, motility, tiering, size, time_pre_during_post) %>%
    write.csv(., str_replace(str_replace(file_list[i], "species", "trophic"), "raw", "clean/minimum"),
              row.names = FALSE)
}
