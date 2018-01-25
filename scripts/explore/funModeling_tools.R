#exploratory data analysis with pkg funModeling
#https://livebook.datascienceheroes.com/appendix.html#funmodeling-quick-start

#Packages ----
#install.packages("funModeling")
library(funModeling)
library(dplyr)
#Exploratory data analysis ----

# df_status: Dataset health status 
df_status(heart_disease)

# plot_num: plot distributions of numeric variables
    #plots only numeric variables
plot_num(heart_disease, path_out = ".")

#profiling_num: Calculating several statistics for numerical variables
    #Retrieves several statistics for numerical variables.
profiling_num(heart_disease, print_results = TRUE, digits = 2)

# freq: Getting frequency distributions for categoric variables
    #plots only factor and character variables
freq(data = heart_disease, input = c('thal','chest_pain'), plot = TRUE, na.rm = FALSE, path_out = ".")


#Correlations ----

#correlation_table: Calculates R statistic
  #Retrieves R metric (or Pearson coefficient) for all numeric variables, skipping the categoric ones.

correlation_table(data = heart_disease, target = "has_heart_disease")
