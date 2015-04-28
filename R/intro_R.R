x <- 15
ls() # list objects in environment
x - 5
y <- 4
y <- x/2
y
# a vector of weights, use c to combine
weights <- c(50, 60, 65, 82)
weights
animals <- c("mouse", "rat,", "dog")
animals
?mean
# number of elements
length(weights)
length(animals)

# find class of an object
class(weights)
class(animals)

# structure
str(weights)
str(animals)

# add elements to vectors
weights <- c(weights, 90)
weights
weights <- c(30, weights)
weights

# combine objects x, y, and weights into a vector called z
z <- c(x, y, weights)
z
# find the mean of this set using function mean()
z_mean <- mean(z)
z_mean
z_max <- max(z)
z_max

# Working with DATA
getwd()  # get working directory
list.files()  # list files in working directory
setwd("~/Desktop")   # change directory
setwd("~/wsu")
gapminder <- read.csv("data/gapminder.csv")
head(gapminder)

class(gapminder)
str(gapminder)

# Based on output of str(gapminder)
# What is the class of the object gapminder? data.frame
# How many rows (obs.) and columns (variables) are in the object? 6
# How many countries are represended in this data? 142

# Subsetting your dataset

# Subsetting your vector, e.g., weights
weights[1]
weights[2:3]

gapminder[1, 1]  # first row, first column
gapminder[1, 3]  # first row, third column
gapminder[500, 5:6]  # 500th row, 5th & 6th column

gapminder$pop  # grab single column of dataframe, e.g, population
gapminder[, 5]   # equivalent to above line
gapminder[, "pop"]   # equivalent to above line

# return all rows of data for Finland
gapminder[gapminder$country == "Finland", ]

# find countries and years where population <= 100,000
gapminder[gapminder$pop <= 100000, c("country", "year")]
#which is same as
gapminder[gapminder$pop <= 100000, c(1, 3)]

# Challange:  which are not equivalent?
gapminder[50, 4]    # 1st number is row, 2nd is column
gapminder[50, "lifeExp"]
gapminder[4, 50]    # not equiv
gapminder$lifeExp[50]  # this pulls column "lifeExp"

# Challenge: Which countries have life expect > 80?
gapminder[gapminder$lifeExp > 80, c("country", "lifeExp")]
gapminder[gapminder$lifeExp > 80, "country"]

# INSTALL PACKAGES
install.packages("dplyr")
install.packages("ggplot2")
install.packages("colorspace")  # needed for ggplot2
install.packages("knitr")
install.packages("rmarkdown")
library("dplyr")    # load the library
library(help=dplyr)    # lists all the functions in dplyr
library("ggplot2")    # load ggplot2
library(help=ggplot2)   # lists all the functions in ggplot2

# WORKING WITH DPLYR
# select and filter
select(gapminder, country, year, pop)    # select get columns
filter(gapminder, country == "Finland")   # filter gets rows

# using pipes, %>%  (shortcut: cmd+shift+M ) -- you have to drag-select the full code block before hitting cmd+return
gapminder_sml <- gapminder %>%
  filter(pop <= 100000) %>%
  select(country, year)

# To output data...
write.csv(gapminder_sml, "data/gapminder_sml.csv")

# Challenge: use pipes to include rows where gdpPercap >= 35,000.  Retain country, year and gdpPercap
gapminder %>%  
  filter(gdpPercap >= 35000) %>%
  select(country, year, gdpPercap)

# Mutate to create new column in your dataset
gapminder %>%
  mutate(totalgdp = gdpPercap * pop) %>%
  head

# Split, Apply, Combine : group_by(), summarize()
# summarize() collapses multiple values into one
gapminder %>%
  mutate(totalgdp = gdpPercap * pop) %>%
  group_by(continent) %>%
  summarize(meangdp = mean(totalgdp))   # create new column

gapminder %>%
  mutate(totalgdp = gdpPercap * pop) %>%
  group_by(continent, year) %>%
  summarize(meangdp = mean(totalgdp))

meanmingdp <- gapminder %>%
  mutate(totalgdp = gdpPercap * pop) %>%
  group_by(continent, year) %>%
  summarize(meangdp = mean(totalgdp), mingdp = min(totalgdp))

# Challenge:  use group_by() and summarize() to find max life exp for each continent
gapminder %>%
  group_by(continent) %>%
  summarize(max(lifeExp))

# Challenge:  use group_by() and summarize() to find mean, min, max lifeExp for each year
gapminder %>%
  group_by(year) %>%
  summarize(max(lifeExp), min(lifeExp), mean = mean(lifeExp))
  
# Challenge: pick country, find pop for each year in data prior to 1982.  Return country, year, pop.
gapminder_finland <- gapminder %>%
  filter(country == "Finland", year < 1982) %>%
  select(country, year, pop)

##########################################################

# WORKING WITH GGPLOT2 -- for data visualizations

# load ggplot2 library
library(ggplot2)

# load gapminder data
gapminder <- read.csv("~/wsu/data/gapminder.csv")

# scatterplot of lifeExp vs gdpPercap
# aes = aesthetics; in this case, sets x and y axes
# geom = geometric objects, in this case
ggplot(gapminder, aes(x=gdpPercap, y=lifeExp)) + 
  geom_point()

p <- ggplot(gapminder, aes(x=gdpPercap, y=lifeExp))  # define graphical object p
p + geom_point()   # add the layer for geometric points

p3 <- p + geom_point() + scale_x_log10()
p3
# color points by continent
p3 + aes(color=continent)

#review
ggplot(gapminder, aes(x=gdpPercap, y=lifeExp)) + scale_x_log10() + geom_point()

# Challenge:  make scatterplot of lifeExp vs gdpPercap with only China data
ggplot((gapminder %>% filter(country == "China")), aes(x=gdpPercap, y=lifeExp)) + 
  geom_point(size = 5, alpha = 0.5, color = "red")
# or better
p_china <- gapminder %>%
  filter(country=="China") %>%
  ggplot(aes(x=gdpPercap, y=lifeExp)) +
  geom_point(size = 5, alpha = 0.5, color = "red")

# Challenge: try size, shape, color aesthetics, 
# both with categorical variables (e.g., continent) and numeric variables (e.g., pop)
ggplot(gapminder, aes(x=gdpPercap, y=lifeExp, color=continent, size=pop, shape=continent)) + 
  scale_x_log10() + geom_point()

# add multiple layers (each call to geom_* creates new layer)
ggplot((gapminder %>% filter(country == "China")), aes(x=gdpPercap, y=lifeExp)) + 
  geom_point(size = 5, alpha = 0.7, aes(color=year)) + geom_line(color = "violet")

# Challenge: make plot of lifeExp vs gdpPercap for China and India
# with lines in black but points colored by country.
ggplot((gapminder %>% filter(country == "China" | country == "India")), aes(x=gdpPercap, y=lifeExp)) + 
  geom_point(aes(color = country), size = 5) + geom_line(aes(group=country), color="black") 
# or
ggplot((gapminder %>% filter(country %in% c("China", "India"))), aes(x=gdpPercap, y=lifeExp)) + 
  geom_point(aes(color = country), size = 5) + geom_line(aes(group=country), color="black")

# make a histogram
gapminder %>%
  filter(year==2007) %>%
  ggplot(aes(x=lifeExp)) + geom_histogram(binwidth=2.5, fill="orchid", color="black")

# make a boxplot
gapminder %>%
  filter(year==2007) %>%
  ggplot(aes(y=lifeExp, x=continent)) + geom_boxplot(fill="aquamarine", width=0.8)

# make a point plot
gapminder %>%
  filter(year==2007) %>%
  ggplot(aes(y=lifeExp, x=continent)) + geom_boxplot() +
  geom_point(position=position_jitter(width=0.1, height=0), aes(color=continent)) 

# FACETING, splitting the data:  facet_grid(), facet_wrap()
# facet_grid() splits either vertically or horizontally depending on where you put the ~
# facet_wrap() simply wraps individual facets
ggplot(gapminder, aes(x=gdpPercap, y=lifeExp)) + geom_point() + scale_x_log10() + facet_grid(continent ~ .)
ggplot(gapminder, aes(x=gdpPercap, y=lifeExp)) + geom_point() + scale_x_log10() + facet_grid(~ continent)
ggplot(gapminder, aes(x=gdpPercap, y=lifeExp)) + geom_point() + scale_x_log10() + facet_grid(continent ~ year)

ggplot(gapminder, aes(x=gdpPercap, y=lifeExp, color=continent)) + geom_point() + scale_x_log10() + facet_wrap(~year)

# Challenge: select 5 countries, plot lifeExp vs gdpPercap across time (with geom_line), facet by country
plot <- gapminder %>%
  filter(country == "India" | country == "New Zealand" | country == "China" | country == "Iceland" | country == "Iran") %>%
  ggplot(aes(y=lifeExp, x=gdpPercap)) + geom_line(aes(color=country)) + facet_wrap(~ country)

# SAVE AS (png, pdf, etc)
ggsave("figures/plot.png", plot, height=7, width=10)

  