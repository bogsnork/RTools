#function to add totals to a flextable


  # example: 
  #   data <- iris %>% head() %>% mutate(rando = rep("randoms", 6)) %>% select(rando, everything())

flex_totals <- function(data) {
  
  nmrc <- sapply(data, is.numeric) #get positions of numeric cols
  data.ord <- cbind(data[!nmrc], data[nmrc]) #put numeric cols at the end
  data.ord$Totals <- rowSums(data.ord[sapply(data.ord, is.numeric)]) #add Totals
  nmrc <- sapply(data.ord, is.numeric) #get new numeric positions
  
  flextb <- flextable::flextable(data.ord)
  
  flextb <- flextable::add_footer_row(x = flextb, 
    values = c("Totals",as.character(colSums(data.ord[nmrc]))), #calc totals and add
    colwidths = c(sum(!nmrc), #number of cols to merge for the totals cell 
                  rep(1, length.out = sum(nmrc))) #numeric cols
    )
  flextb <- bold(x = flextb, j = ncol(data.ord))
  flextb <- bold(x = flextb, part = "footer")  #bolds the totals
  flextb <- align(x = flextb, align = "right", part = "footer")
  flextb
}


