library(here)
library(tidyverse)

# set path to code sub dir
setwd(here())

# get all species files
file_list <-  list.files(path = "data/raw",
  pattern = "^.*data.*$",
  full.names = TRUE)

#### Maximal datasets ####

# loop through all files (baically move to different folder)
for (i in 1:length(file_list)) {
  read.csv(file_list[i]) %>%
    write.csv(., str_replace(file_list[i], "raw", "clean/maximal"),
              row.names = FALSE)
}

#### Minimum datasets ####

# loop through all files (baically move to different folder)
for (i in 1:length(file_list)) {
  read.csv(file_list[i]) %>%
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
    write.csv(., str_replace(file_list[i], "raw", "clean/minimum"),
              row.names = FALSE)
}
