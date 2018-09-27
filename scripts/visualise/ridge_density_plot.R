#ridge density plot

library(tidyverse)
#like joy division 'unknown pleasures' cover
ggplot(iris, aes(y = Species, x = Sepal.Length )) +
  ggridges::geom_density_ridges(fill = "transparent", colour = "white")+
  theme(
    panel.background = element_rect(fill = "black", colour = "black"),
    panel.grid = element_blank(),
    plot.background = element_rect(fill = "black"),
    plot.margin = unit(x = c(1,1,1,1), units = "cm"))+
  NULL