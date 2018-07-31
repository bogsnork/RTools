#skim summary statistics with skimr

install.packages("skimr")
library(skimr)

?`skimr-package`

skim(chickwts)
skim(iris)

#select
skim(iris, Sepal.Length, Petal.Length)

#grouped
iris %>% dplyr::group_by(Species) %>% skim() 

#nice formating
skim(chickwts) %>% pander()
skim(chickwts) %>% kable()


#tidy version for computing on (long format)

a <-  skim(chickwts)
print.data.frame(a)
pander(a)
kable(a)

skim(mtcars) %>% dplyr::filter(stat=="hist")

#works with strings
skim(dplyr::starwars)

#specify your own stats
#skim_with()

funs <- list(iqr = IQR,
             quantile = purrr::partial(quantile, probs = .99))

skim_with(numeric = funs, append = FALSE)

skim(iris, Sepal.Length)

skim_with_defaults()  # Restores defaults



