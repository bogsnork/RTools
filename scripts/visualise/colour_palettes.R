#colour pallettes

#GUI to choose a colour pallette----
library(colorspace)
choose_palette(n = 10,gui = "shiny")
#not sure how to export the results other than save as a file. 

#ggplot ----
library(ggplot2)
p <- ggplot(iris, aes(y = Sepal.Width, x = Sepal.Length )) +
  geom_point(aes(colour = Species)) 
p

p + scale_colour_brewer(type = "qual", palette = "Reds")

#change range of hues (hue = colour!)  values between 0 and 360
p + scale_colour_hue(h = c(310, 360))

#adjust luminosity and chroma
  # l - 0 to 100
  # c - (intensity of colour), maximum value varies
  #     depending on combination of hue and luminance
p + scale_colour_hue(l = 40, c = 150)

