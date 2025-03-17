#library
library(here)
library(tidyverse)

# set path to code sub dir
setwd(here())

df <- read.csv(here("data/clean/feeding_rules.csv")) %>%
  mutate_all(~str_replace_all(., "nonmotile", "non_motile")) %>%
  mutate_all(~str_replace_all(., "-", "_"))

traits_classes <- df %>%
  select(trait_type_resource) %>%
  distinct() %>%
  pull()

#### Maximal traits ####

# write rules .csv
write.csv(df, here("data/feeding_rules/feeding_rules_maximal.csv"),
          row.names = FALSE)

#### Minimal traits ####

df_min <- df %>%
  mutate(trait_resource = case_when(trait_resource == "shallow-infaunal" ~ "infaunal",
                                    trait_resource == "deep-infaunal" ~ "infaunal",
                                    str_detect(trait_resource, "^.*epifaunal.*$") ~ "epifaunal",
                                    trait_resource == "non-motile_attached" ~ "attached",
                                    trait_resource == "non-motile_byssate" ~ "attached",
                                    str_detect(trait_resource, "^.*deposit.*$") ~ "herbivore",
                                    str_detect(trait_resource, "^.*suspension.*$") ~ "herbivore",
                                    str_detect(trait_resource, "grazer_herbivore") ~ "herbivore",
                                    str_detect(trait_resource, "^.*large.*$") ~ "large",
                                    str_detect(trait_resource, "^.*medium.*$") ~ "medium",
                                    str_detect(trait_resource, "^.*small.*$") ~ "small",
                                    str_detect(trait_resource, "^.*tiny.*$") ~ "tiny",
                                    TRUE ~ as.character(trait_resource)),
         trait_consumer = case_when(trait_consumer == "shallow-infaunal" ~ "infaunal",
                                    trait_consumer == "deep-infaunal" ~ "infaunal",
                                    str_detect(trait_consumer, "^.*epifaunal.*$") ~ "epifaunal",
                                    trait_consumer == "non-motile_attached" ~ "attached",
                                    trait_consumer == "non-motile_byssate" ~ "attached",
                                    str_detect(trait_consumer, "^.*deposit.*$") ~ "herbivore",
                                    str_detect(trait_consumer, "^.*suspension.*$") ~ "herbivore",
                                    str_detect(trait_consumer, "grazer_herbivore") ~ "herbivore",
                                    str_detect(trait_consumer, "^.*large.*$") ~ "large",
                                    str_detect(trait_consumer, "^.*medium.*$") ~ "medium",
                                    str_detect(trait_consumer, "^.*small.*$") ~ "small",
                                    str_detect(trait_consumer, "^.*tiny.*$") ~ "tiny",
                                    TRUE ~ as.character(trait_consumer))) %>%
  distinct()

# write rules .csv
write.csv(df_min, here("data/feeding_rules/feeding_rules_minimum.csv"),
          row.names = FALSE)