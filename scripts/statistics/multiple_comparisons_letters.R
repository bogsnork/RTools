library(multcompView)

Sepal.Length.fm <- aov(Sepal.Length~Species, data=iris)
Sepal.Length.Letters <- data.frame("Letters"=multcompLetters(extract_p(TukeyHSD(Sepal.Length.fm)$"Species"))$"Letters")

Sepal.Width.fm <- aov(Sepal.Width~Species, data=iris)
Sepal.Width.Letters <- data.frame("Letters"=multcompLetters(extract_p(TukeyHSD(Sepal.Width.fm)$"Species"))$"Letters")

Petal.Length.fm <- aov(Petal.Length~Species, data=iris)
Petal.Length.Letters <- data.frame("Letters"=multcompLetters(extract_p(TukeyHSD(Petal.Length.fm)$"Species"))$"Letters")

Petal.Width.fm <- aov(Petal.Width~Species, data=iris)
Petal.Width.Letters <- data.frame("Letters"=multcompLetters(extract_p(TukeyHSD(Petal.Width.fm)$"Species"))$"Letters")

Letters <- cbind(Sepal.Length.Letters, Sepal.Width.Letters, Petal.Length.Letters, Petal.Width.Letters)

Letters

dif3 <- c(FALSE, FALSE, TRUE)
names(dif3) <- c("a-b", "a-c", "b-c")
multcompTs(dif3)
multcompLetters(dif3)

library(MASS)
multcompBoxplot(Postwt~Treat, data=anorexia)
boxplot(Postwt~Treat, data=anorexia)

multcompTs()
