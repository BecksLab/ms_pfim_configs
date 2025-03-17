##Load packages
library(grDevices)
library(here)
library(tidyverse)
library(vegan)

# set path to code sub dir
setwd(here())

# import network summary data
topology_sites <- read.csv("data/output/networks/topology.csv") %>%
  na.omit()

# PCA

topology_scaled <- scale(topology_sites[7:20])

ord <- metaMDS(topology_sites[7:20])
fit <- envfit(ord, topology_sites[1:6], perm = 9999)

df_pca <-
  cbind(topology_sites[1:6], as.data.frame(ord[["points"]]))

# Find the convex hull of the points being plotted
hull <- df_pca %>%
  group_by(node) %>%
  slice(chull(MDS1, MDS2))

ggplot() +
  geom_polygon(data = hull,
               aes(x = MDS1,
                   y = MDS2,
                   fill = node,
                   group = node),
                alpha = 0.20) +
  geom_point(data = df_pca,
             aes(x = MDS1,
                 y = MDS2,
                 shape = downsample,
                 colour = location),
             alpha = 0.4) +
  geom_segment(aes(x = 0, y = 0, 
                   xend = fit[["vectors"]][["arrows"]][1], 
                   yend = fit[["vectors"]][["arrows"]][2]),
               colour = "black",
               arrow = arrow(length = unit(0.03, "npc"))) +
  geom_text(aes(label = "time", 
                x = fit[["vectors"]][["arrows"]][1], 
                y = fit[["vectors"]][["arrows"]][2]), 
            nudge_x = 0.15,
            colour = "black") +
  theme_classic()

ggsave("images/pca.png",
       width = 4500,
       height = 3500,
       units = "px",
       dpi = 600)
