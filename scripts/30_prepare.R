# Welcome to the Togaware Data Science Data Template ----
#
# Australian Weather Dataset.
# Data Wrangling.
#
# File: 30_prepare.R
#
# This template provides a starting point for the 
# data scientist exploring a new dataset. By no means
# is it the end point of the data science journey.
# 
# This R script is automatically extracted from a knitr
# file with a .Rnw extension. That file includes a broader 
# narrative and explanation of the journey through our data.
# Before our own journey into literate programming we can
# make use of these R scripts as our templates for data science.
# 
# The template is under regular revision and improvement
# and is provided as is. It is published as an appendix to the 
# book, Quick Start Data Science in R from CRC Press (pending).
#
# Copyright (c) 2014-2016 Togaware.com
# Authored by and feedback to Graham.Williams@togaware.com
# License: Creative Commons Attribution-ShareAlike CC BY-SA 
#
# Version: 20161113T113628

#### DATA WRANGLING --------------------------------

# Review the variables to optionally normalise their names.

names(ds)

# Normalise the variable names.

names(ds) %<>% normVarNames() %>% print()

# Review the dataset.

glimpse(ds)

# Review the first few observations.

head(ds) %>% print.data.frame()

# Review the last few observations.

tail(ds) %>% print.data.frame()

# Review a random sample of observations.

sample_n(ds, size=6) %>% print.data.frame()

# Traditional dataset summary to get started.

summary(ds)

## Data Wrangling weatherAUS ----------------

# Date data type conversion (if required).

class(ds$date)
ds$date %<>% as.character() %>% ymd() %>% as.Date()
class(ds$date)

# How many locations are represented in the dataset.

ds$location %>% 
  unique() %>%
  length()

# Review the distribution of observations across levels.

ds %>%
  select(starts_with("rain_")) %>%
  sapply(table)

# Note the  names of the rain variables.

ds %>% 
  select(starts_with("rain_")) %>% 
  names() %>%
  print() ->
vnames

# Confirm these are currently character variables.

ds[vnames] %>% sapply(class)

# Choose to convert these variables from character to factor.

ds[vnames] %<>% 
  lapply(factor) %>% 
  data.frame() %>% 
  tbl_df()

# Confirm they are now factors.

ds[vnames] %>% sapply(class)

# Verify the distribution has not changed.

ds %>%
  select(starts_with("rain_")) %>%
  sapply(table)

ds %>% 
  select(contains("_dir")) %>%
  names() %>%
  paste(collapse="|, \\verb|") %>%
  paste0("\\verb|", . , "|") %>%
  str_replace(", (\\\\\\verb[^,]+)$", ", and \\1") ->
wgvars

# Review the distribution of observations across levels.

ds %>%
  select(contains("_dir")) %>%
  sapply(table)

# Levels of wind direction are ordered compas directions.

compass <- c("N", "NNE", "NE", "ENE",
             "E", "ESE", "SE", "SSE",
             "S", "SSW", "SW", "WSW",
             "W", "WNW", "NW", "NNW")

# Note the names of the wind direction variables.

ds %>% 
  select(contains("_dir")) %>% 
  names() %>%
  print() ->
vnames

# Confirm these are currently character variables.

ds[vnames] %>% sapply(class)

# Convert these variables from character to factor.

ds[vnames] %<>% 
  lapply(factor, levels=compass, ordered=TRUE) %>% 
  data.frame() %>% 
  tbl_df()

# Confirm they are now factors.

ds[vnames] %>% sapply(class)

# Verify the distribution has not changed.

ds %>%
  select(contains("_dir")) %>%
  sapply(table)

# Note the character remaining variables to be dealt with.

cvars <- c("evaporation", "sunshine")

# Review the values.

head(ds[cvars])
tail(ds[cvars])
sample_n(ds[cvars], 6)

# Check the current class of the variables.

ds[cvars] %>% sapply(class)

# Convert to numeric.

ds[cvars] %<>% sapply(as.numeric)

# Confirm the conversion.

ds[cvars] %>% sapply(class)

## Identifiers and Targets ----------------

# Note the available variables.

vars <- names(ds) %>% print()

# Note the target variable.

target <- "rain_tomorrow"

# Place the target variable at the beginning of the vars.

vars <- c(target, vars) %>% unique() %>% print()

# Note the risk variable - measures the severity of the outcome.

risk <- "risk_mm"

# Note any identifiers.

id <- c("date", "location")

## Generic Data Wrangling ----------------

# Initialise ignored variables: identifiers and risk.

ignore <- union(id, if (exists("risk")) risk) %>% print()

# Heuristic for indentifiers to possibly ignore.

ds[vars] %>%
  sapply(function(x) x %>% unique() %>% length()) %>%
  equals(nrow(ds)) %>%
  which() %>%
  names() %>%
  print() ->
ids

# Add them if any to the variables to be ignored for modelling.

ignore <- union(ignore, ids) %>% print()

# Identify variables with only missing values.

ds[vars] %>%
  sapply(function(x) x %>% is.na %>% sum) %>%
  equals(nrow(ds)) %>%
  which() %>%
  names() %>%
  print() ->
missing

# Add them if any to the variables to be ignored for modelling.

ignore <- union(ignore, missing) %>% print()

# Identify a threshold above which proportion missing is fatal.

missing.threshold <- 0.7

# Identify variables that are mostly missing.

ds[vars] %>%
  sapply(function(x) x %>% is.na() %>% sum()) %>%
  '>'(missing.threshold*nrow(ds)) %>%
  which() %>%
  names() %>%
  print() ->
mostly

# Add them if any to the variables to be ignored for modelling.

ignore <- union(ignore, mostly) %>% print()

# Identify a threshold above which we have too many levels.

levels.threshold <- 20

# Identify variables that have too many levels.

ds[vars] %>%
  sapply(is.factor) %>%
  which() %>%
  names() %>%
  sapply(function(x) ds %>% extract2(x) %>% levels() %>% length()) %>%
  '>='(levels.threshold) %>%
  which() %>%
  names() %>%
  print() ->
too.many

# Add them if any to the variables to be ignored for modelling.

ignore <- union(ignore, too.many) %>% print()

# Identify variables that have a single value.

ds[vars] %>%
  sapply(function(x) all(x == x[1L])) %>%
  which() %>%
  names() %>%
  print() ->
constants 

# Add them if any to the variables to be ignored for modelling.

ignore <- union(ignore, constants) %>% print()

# Note which variables are numeric.

vars %>%
  setdiff(ignore) %>%
  '['(ds, .) %>%
  sapply(is.numeric) %>% 
  which() %>%
  names() %>%
  print() ->
numc

# For the numeric variables generate a table of correlations

ds[numc] %>%
  cor(use="complete.obs") %>%
  ifelse(upper.tri(., diag=TRUE), NA, .) %>% 
  abs %>% 
  data.frame %>%
  tbl_df %>%
  set_colnames(numc) %>%
  mutate(var1=numc) %>% 
  gather(var2, cor, -var1) %>% 
  na.omit %>%
  arrange(-abs(cor)) %>%
  print() ->
mc

# Any variables could be removed because highly correlated?

correlated <- c("temp_3pm", "pressure_3pm", "temp_9am")

# Add them if any to the variables to be ignored for modelling.

ignore <- union(ignore, correlated) %>% print()

# Check the number of variables currently.

length(vars)

# Remove the variables to ignore.

vars <- setdiff(vars, ignore) %>% print()

# Confirm they are now ignored.

length(vars)

## Variable Selection ----------------

# Formula for modelling.

form <- formula(target %s+% " ~ .") %>% print()

# Use correlation search to identify key variables.
# Could be useful to decide which variables to retain.

cfs(form, ds[vars])

# Any variables to remove because not useful?

vars %<>% setdiff(NULL) %>% print()

# Use information gain to identify variable importance.

information.gain(form, ds[vars]) %>%
  rownames_to_column() %>%
  arrange(attr_importance)

# Any variables to remove because not useful?

vars %<>% setdiff(NULL) %>% print()

## Further Wrangling ----------------

# Check the dimensions to start with.

dim(ds) %>% echo()

# Identify observations with a missing target.

ds %>% 
  extract2(target) %>% 
  is.na() %T>%
  {sum(.) %>% echo()} ->
missing.target 

# Remove observations with a missing target.

ds %<>% filter(!missing.target)

# Confirm the filter delivered the expected dataset.

dim(ds) %>% echo()

## Optional: Missing Value Imputation ----------------

# Count the number of missing values.

ds[vars] %>%  is.na() %>% sum() %>% echo()

# Impute missing values.

ds[vars] %<>% na.roughfix()

# Confirm that no missing values remain.

ds[vars] %>%  is.na() %>% sum() %>% echo()

## Optional: Remove Observations With Missing Values ----------------

# Initialise the list of observations to be removed.

omit <- NULL

# Review the current dataset.

ds[vars] %>% nrow() %>% echo()
ds[vars] %>% is.na() %>% sum() %>% echo()

# Identify any observations with missing values.

ds[vars] %>%
  na.omit() %>%
  attr("na.action") %>%
  print() ->
mo

# Record the observations to omit.

omit <- union(omit, mo) %T>% {length(.) %>% print()}

# If there are observations to omit then remove them.

if (length(omit)) ds <- ds[-omit,]

# Confirm the observations have been removed.

ds[vars] %>% nrow() %>% echo()
ds[vars] %>% is.na() %>% sum() %>% echo()

## Normalise Factors ----------------

# Note which variables are categoric.

ds[vars] %>%
  sapply(is.factor) %>%
  which() %>%
  names() %>%
  print() ->
catc

# Check the levels.

ds[catc] %>% sapply(levels)

# Normalise the levels of all categoric variables.

for (v in catc) 
  levels(ds[[v]]) %<>% normVarNames()

# Review the levels.

ds[catc] %>% sapply(levels)

## Categoric Target ----------------

# Ensure the target is categoric.

class(ds[[target]])

ds[[target]] %<>% as.factor()

# Confirm the distribution.

ds[target] %>% table()

ds %>%
  ggplot(aes_string(x=target)) +
  geom_bar(width=0.2, fill="grey") +
  scale_y_continuous(labels=comma) +
  theme(text=element_text(size=14))

## Numeric Target - Alternative ----------------

# Ensure the target is numeric.

class(ds[[target]])

ds[[target]] %<>% as.numeric()

# Confirm the distribution.

ds[target] %>% summary()

ds %>%
  ggplot(aes_string(x=target)) +
  geom_histogram(fill="grey", col="black", binwidth=20) +
  theme(text=element_text(size=14))

