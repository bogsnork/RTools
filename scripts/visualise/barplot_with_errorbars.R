#from: 
#https://www.r-graph-gallery.com/4-barplot-with-error-bar/

library(tidyverse)

# Data
data <- iris %>% dplyr::select(Species, Sepal.Length) 
head(data)

# Calculates mean, sd, se and IC
my_sum <- data %>%
  group_by(Species) %>%
  summarise(
    n=n(),
    mean=mean(Sepal.Length),
    sd=sd(Sepal.Length)
    ) %>%
  mutate( se=sd/sqrt(n))  %>%
  mutate( ic=se * qt((1-0.05)/2 + .5, n-1))

my_sum

# Standard deviation
ggplot(my_sum) +
  geom_bar( aes(x=Species, y=mean), stat="identity", 
            fill="forestgreen", alpha=0.5) +
  geom_errorbar( aes(x=Species, ymin=mean-sd, ymax=mean+sd), 
                 width=0.4, colour="orange", alpha=0.9, size=1.5) +
  ggtitle("using standard deviation")

# Standard Error
ggplot(my_sum) +
  geom_bar( aes(x=Species, y=mean), stat="identity", 
            fill="forestgreen", alpha=0.5) +
  geom_errorbar( aes(x=Species, ymin=mean-se, ymax=mean+se), 
                 width=0.4, colour="orange", alpha=0.9, size=1.5) +
  ggtitle("using standard error")

# Confidence Interval
ggplot(my_sum) +
  geom_bar( aes(x=Species, y=mean), stat="identity", 
            fill="forestgreen", alpha=0.5) +
  geom_errorbar( aes(x=Species, ymin=mean-ic, ymax=mean+ic), 
                 width=0.4, colour="orange", alpha=0.9, size=1.5) +
  ggtitle("using confidence interval")
