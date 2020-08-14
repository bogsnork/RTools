#pie charts
library(tidyverse)
library(ggpubr)


df <- data.frame(
  group = c("Male", "Female", "Child"),
  value = c(21, 25, 70))
labs <- paste0(df$group, " (", round(100*df$value/sum(df$value),2), "%)")

ggpie(df, x = "value", label = labs,
      lab.pos = "in", lab.font = c(4,"bold","black"), fill = "group", color = "white",
      palette = c("#00AFBB", "#E7B800", "#FC4E07"), 
      main = paste0("Humans, n=", sum(df$value)), legend = "right")


