
# package -----------------------------------------------------------------
library(tidyverse)


# data --------------------------------------------------------------------
data(iris)


# figure ------------------------------------------------------------------
g = ggplot(data = iris, aes(x = Species, y = Sepal.Length, fill = Species))
b = stat_boxplot()
labs = labs(x="", y="Sepal.Length")
g+b+labs+theme_bw()