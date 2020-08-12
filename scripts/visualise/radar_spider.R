#radar plots / spider web plots

#several options

#ggplot2----
library(tidyverse)

#first calculate the points, e.g. the mean of each group
graphdata <- iris %>% gather(key = index, value = value, Sepal.Length:Petal.Width) %>% 
  group_by(Species, index) %>% 
  summarise(mean = mean(value))
head(graphdata)  

## spider / radar
ggplot(data = graphdata, aes(x = index, y = mean, colour = Species)) + 
  geom_point() +
  geom_polygon(aes(group = Species, fill = Species), alpha = 0.2) +
  coord_polar() +
#  ylim(0,)
  NULL

  #may need to set ylim to ensure 0 is visible.  Best if values between 0:1,  Can also facet


#ggiraphExtra::ggradar ----
library(tidyverse)
library(ggiraphExtra)

graphdata <- iris

ggRadar(data = graphdata, 
        aes(colour = Species, fill = Species), interactive = F, rescale = F) 

  #can also be made interactive and rescale and other options.  Don't need to prepare data too much

##ggradar::ggradar ----
library(ggradar)
library(scales)
mtcars_radar <- mtcars %>% 
  as_tibble(rownames = "group") %>% 
  mutate_at(vars(-group), rescale) %>% 
  tail(4) %>% 
  select(1:10)
mtcars_radar
ggradar(mtcars_radar)
  #nicer display but very fiddly to prepare data
