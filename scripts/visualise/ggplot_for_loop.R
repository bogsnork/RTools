#for loop for ggplot

#create separate plots for 
library(tidyverse)

head(iris)

#create vector of variable (column) names
variables <- c("Sepal.Length", "Sepal.Width",  "Petal.Length", "Petal.Width")

#loops over each variable: 
for (i in variables ){
  
  #create a ggplot graph, remembering to change 'aes' to 'aes_string' 
  #and quoting variables except i
  graph <- ggplot(iris, aes_string(x = "Species", y = i))+
    geom_boxplot() + 
    labs(title = paste("Iris characters by species:", i))
  
  #tell it to plot that graph
  plot(graph)
  
  # #uncomment to save to file:
  # ggsave(graph, filename = paste("my_data_prefix_",
  #                                str_replace(i, "\\.", "_"),
  #                                ".png",sep=""))

}

#that's it'
