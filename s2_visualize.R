# Code from book R for Data Science (2nd Edition) by Hadley Wickham and co.
# Here we have script files for each book section.
# Then, in each script file we have code sections for each chapter.
# This script contains code from the "Visualize" section of the book.
# Here we will learn about visualizing data in further depth. 
# So let's roll!


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# C0 - Installing and loading ---------------------------------------------
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Working directory check
getwd()
# "C:/Users/Ronak/Documents/ALL Research/Rsoftware/b_r4ds/r4ds2e_prac"

# First we install the required packages
# install.packages(
#     c(
#         "tidyverse",        # universe of pkgs essential for data manipulation
#         "arrow",
#         "babynames",
#         "curl",
#         "duckdb",
#         "devtools",
#         "gapminder",
#         "ggrepel",
#         "ggridges",
#         "ggthemes",         # graph themes for ggplot2
#         "hexbin",
#         "janitor",          # cmds for data cleaning
#         "Lahman",
#         "leaflet",
#         "maps",
#         "nycflights13",     # flights datasets
#         "openxlsx",
#         "palmerpenguins",   # penguins datasets
#         "repurrrsive",
#         "styler",           # to modify existing R code to a specific style
#         "tidymodels",
#         "writexl"
#     )
# )

# Extra packages in this book section
# install.packages(
#     c(
#         "slider"            # for complex rolling aggregates
#     )
# )

# Loading the required packages
library(easypackages)
libraries(
    "tidyverse",                      # Universe of data mgmt pkgs
    "arrow",
    "babynames",
    "curl",
    "duckdb",
    "gapminder",
    "ggrepel",
    "ggridges",                       # Ridgeline plots based on ggplot2
    "ggthemes",                       # Useful themes based on ggplot2
    "hexbin",
    "janitor",                        # Cmds for data cleaning
    "Lahman",
    "leaflet",
    "maps",
    "nycflights13",
    "openxlsx",                       # For imp/exp and handling excel sheets
    "palmerpenguins",
    "pacman",
    "patchwork",                      # Combining plots
    "repurrrsive",
    "tidymodels",
    "writexl"
)
# p_loaded()                          # checking the loaded packages
# unloadNamespace("writexl")          # Unloading a pkg




#_====
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# C9 - Layers -------------------------------------------------------------
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# In here we will expand our foundational knowledge about ggplot2 from C1.
# We will learn more about the layered grammar of graphics.
# We will not cover every single fn and option for each of these layers, but 
# - we will walk through the most important and commonly used functionality
# - provided by ggplot2, and learn about packages that extend ggplot2.


# 9.1 Prerequisites -------------------------------------------------------
library(tidyverse)


# 9.2 Aesthetic mappings --------------------------------------------------
# Checking the mpg dataframe from ggplot2 pkg.
mpg
glimpse(mpg)
help(mpg)
# Let’s start by visualizing the relationship between displ and hwy for 
# - various classes of cars. We can do this with a scatterplot where the 
# - numerical vars are mapped to the x and y aesthetics and the cat var
# - is mapped to an aesthetic like color or shape.
# Left plot.
ggplot(data = mpg, aes(x = displ, y = hwy, colour = class)) +
    geom_point(size = 3)
# Right plot.
ggplot(data = mpg, aes(x = displ, y = hwy, shape = class)) +
    geom_point(size = 3)
# NOTE: When class is mapped to shape, we get two warnings.
# Since ggplot2 will only use 6 shapes at a time, by default, additional 
# - groups will go unplotted when we use the shape aesthetic. The 2nd warning
# - is related, there are 62 SUVs in the dataset and they’re not plotted.

# Similarly, we can map class to size or alpha aesthetics as well, which 
# - control the size and the transparency of the points, respectively.
# Left plot.
ggplot(data = mpg, aes(x = displ, y = hwy, size = class)) +
    geom_point()
# Right plot.
ggplot(data = mpg, aes(x = displ, y = hwy, alpha = class)) +
    geom_point(size = 3)
# NOTE: Both of these produce warnings as well.
# Mapping an unordered discrete (cat) var (class) to an 
# - ordered aesthetic (size or alpha) is generally not a good idea because
# - it implies a ranking that does not in fact exist.

# You can also set the visual properties of your geom manually as an argument
# - of your geom fn (outside of aes()) instead of relying on a var mapping
# - to determine the appearance.
ggplot(data = mpg, aes(x = displ, y = hwy)) +
    geom_point(colour = "blue", size = 3)


# 9.3 Geometric objects ---------------------------------------------------
# To change the geom in your plot, change the geom fn we add to ggplot().
# Plot with point geom.
ggplot(data = mpg, aes(x = displ, y = hwy)) +
    geom_point()
# Plot with smooth geom to fit a smooth line to the data.
ggplot(data = mpg, aes(x = displ, y = hwy)) +
    geom_smooth()
# Every geom fn in ggplot2 takes a mapping arg, either defined locally in the
# - geom layer or globally in the ggplot() layer. However, not every aesthetic
# - works with every geom. You could set a point's shape, but you couldn’t
# - set the “shape” of a line. If you try, ggplot2 will silently ignore that
# - aesthetic mapping.
ggplot(data = mpg, aes(x = displ, y = hwy, shape = drv)) +
    geom_smooth()
# However, you could set the linetype of a line. geom_smooth() will draw a 
# - different line, with a different linetype, for each unique value of the
# - variable that you map to linetype.
ggplot(data = mpg, aes(x = displ, y = hwy, linetype = drv)) +
    geom_smooth()
# We make the plot clearer by overlaying the lines on top of the raw data and
# - then colouring everything according to drv.
ggplot(data = mpg, aes(x = displ, y = hwy, colour = drv)) +
    geom_point(size = 3) +
    geom_smooth(aes(linetype = drv))
# NOTE: This plot contains two geom in the same graph.

# Many geoms, like geom_smooth(), use a single geometric object to display 
# - multiple rows of data. For these geoms, you can set the group aesthetic
# - to a categorical variable to draw multiple objects. In practice, ggplot2
# - will automatically group the data for these geoms whenever you map an 
# - aesthetic to a discrete variable (as in the linetype example). It is 
# - convenient to rely on this feature because the group aesthetic by itself 
# - does not add a legend or distinguishing features to the geoms.
# Simple plot
ggplot(data = mpg, aes(x = displ, y = hwy)) +
    geom_smooth()
# Plot with group argument
ggplot(data = mpg, aes(x = displ, y = hwy)) +
    geom_smooth(aes(group = drv))
# Plot grouped by colour
ggplot(data = mpg, aes(x = displ, y = hwy)) +
    geom_smooth(aes(colour = drv), show.legend = FALSE)

# If you place mappings in a geom fn, ggplot2 will treat them as local 
# - mappings for the layer. It will use these mappings to extend or overwrite
# - the global mappings for that layer only. This makes it possible to display
# - different aesthetics in different layers.
ggplot(data = mpg, aes(x = displ, y = hwy)) +
    geom_point(aes(colour = class), size = 3) +
    geom_smooth()

# We can use the same idea to specify different data for each layer. 
# Plot where red points and open circles are used to highlight 2-seater cars.
# The local data argument in geom_point() overrides the global data argument
# in ggplot() for that layer only.
ggplot(data = mpg, aes(x = displ, y = hwy)) +
    geom_point() +
    geom_point(
        data = mpg |> filter(class == "2seater"),
        colour = "red"
    ) +
    geom_point(
        data = mpg |> filter(class == "2seater"),
        shape = "circle open",
        size = 3,
        colour = "red"
    )

# Geoms are the fundamental building blocks of ggplot2. You can completely
# - transform the look of your plot by changing its geom, and different geoms
# - can reveal different features of your data.
# CASE: Using histogram and density plot to reveal that the distribution of 
#       highway mileage is bimodal and right skewed.
# Histogram
ggplot(data = mpg, aes(x = hwy)) +
    geom_histogram(binwidth = 2)
# Density plot
ggplot(data = mpg, aes(x = hwy)) +
    geom_density(linewidth = 1.5)
# Using boxplot to reveal two potential outliers.
ggplot(data = mpg, aes(x = hwy)) +
    geom_boxplot()

# Although, ggplot2 provides more than 40 geoms, these do not cover all
# - possible plots one could make. If you need a different geom, we recommend
# - looking into extension packages first to see if someone else has already
# - implemented it.
# CASE: Making ridgeline plots using ggridges package.
# library(ggridges)
ggplot(data = mpg, aes(x = hwy, y = drv, fill = drv, colour = drv)) +
    geom_density_ridges(alpha = 0.5, show.legend = F)


# 9.4 Facets --------------------------------------------------------------
# In Ch 1 you learned about faceting with facet_wrap(), which splits a plot
# - into subplots that show one subset of the data based on a cat var.
ggplot(data = mpg, aes(x = displ, y = hwy)) +
    geom_point() +
    facet_wrap(~ cyl)
# To facet plot with combo of two vars use facet_grid & formula: rows ~ cols.
ggplot(data = mpg, aes(x = displ, y = hwy)) +
    geom_point() +
    facet_grid(drv ~ cyl)
# Setting the scales arg in a faceting fn to "free_x" will allow for 
# - different scales of x-axis across cols, "free_y" will allow for 
# - different scales on y-axis across rows, and "free" will allow both.
ggplot(data = mpg, aes(x = displ, y = hwy)) +
    geom_point() +
    facet_grid(drv ~ cyl, scales = "free")


# 9.5 Statistical transformations -----------------------------------------
# Checking the diamonds dataset
help(diamonds)
# In the following chart we see the total number of diamonds in the 
# - diamonds dataset, grouped by cut.
ggplot(data = diamonds, aes(x = cut)) +
    geom_bar()
# The chart shows that more diamonds are available with high quality cuts 
# - than with low quality cuts.

# The algorithm used to calculate new values for a graph is called a stat
# - short for statistical transformation. Every geom has a default stat and
# - every stat has a default geom. This means that you can typically use 
# - geoms without worrying about the underlying statistical transformation. 

# However, there are 3 reasons where we might need to use a stat explicitly:
# CASE 1: You might want to override the default stat. In the code below, we
#       change the stat of geom_bar() from count (the default) to 
#       identity. This lets us map the height of the bars to the raw values
#       of a y variable.
diamonds |> 
    count(cut) |> 
    ggplot(aes(x = cut, y = n)) +
    geom_bar(stat = "identity")
# CASE 2: You might want to override the default mapping from transformed vars 
#       to aesthetics. We display bar chart of proportions, rather than counts.
ggplot(data = diamonds, aes(x = cut, y = after_stat(prop), group = 1)) +
    geom_bar()
# See ?geom_bar section on "computed vars" for explanation on after_stat().
# CASE 3: You want to draw greater attention to the statistical transformation
#       in your code. We use stat_summary(), which summarizes the y values for
#       each unique x value, to show the summary we are computing.
ggplot(data = diamonds) +
    stat_summary(
        aes(x = cut, y = depth),
        fun.min = min,
        fun.max = max,
        fun = median
    )
# ggplot2 provides more than 20 stats for you to use. Each stat is a fn, so
# - you can get help in the usual way, e.g., ?stat_bin.


# 9.6 Position adjustments ------------------------------------------------
# There’s one more piece of magic associated with bar charts.
# We can colour bar charts using colour aesthetic.
ggplot(data = mpg, aes(x = drv, colour = drv)) +
    geom_bar(linewidth = 3)
# We can also use the fill aesthetic.
ggplot(data = mpg, aes(x = drv, fill = drv)) +
    geom_bar()
# When we map the fill aesthetic to another var (like class) the bars 
# - get stacked. Each stack represents a combination of drv and class.
ggplot(data = mpg, aes(x = drv, fill = class)) +
    geom_bar()
# NOTE: The stacking is performed automatically using the position adjustment
#       specified by the position argument.

# If you don’t want a stacked bar chart, you can use one of three other 
# - options: "identity", "dodge" or "fill".
# 1. position = "identity" will place each object exactly where it falls in 
# - the context of the graph. This is not very useful for bars, because it 
# - overlaps them. To see that overlapping we either need to make the bars 
# - slightly transparent.
ggplot(data = mpg, aes(x = drv, fill = class)) +
    geom_bar(position = "identity", alpha = 1/5)
ggplot(data = mpg, aes(x = drv, colour = class)) +
    geom_bar(position = "identity", linewidth = 2, fill = NA)
# NOTE: The identity position adjustment is more useful for 2d geoms, like
# - points, where it is the default.
# 2. position = "fill" works like stacking, but makes each set of stacked bars
# - the same height. This makes it easier to compare propns across groups.
ggplot(data = mpg, aes(x = drv, fill = class)) +
    geom_bar(position = "fill")
# 3. position = "dodge" places overlapping objects directly beside one
# - another. This makes it easier to compare individual values.
ggplot(data = mpg, aes(x = drv, fill = class)) +
    geom_bar(position = "dodge")

# There's another adjustment type that's important for scatter plots.
ggplot(data = mpg, aes(x = displ, y = hwy)) +
    geom_point()
# NOTE: The plot displays only 126 points, even though there are 234 obsn
# - in the dataset. This problem is known as overplotting.
# The underlying values of hwy and displ are rounded so the points appear on
# - a grid and many points overlap each other.
# SOL: We can set position = "jitter" to avoid this gridding. This adds a
# - small amount of random noise to each point and the points are spread out. 
ggplot(data = mpg, aes(x = displ, y = hwy)) +
    geom_point(position = "jitter")
# Adding randomness seems like a strange way to improve the plot. However 
# - this is such a useful operation, ggplot2 comes with a shorthand for
# - geom_point(position = "jitter"): geom_jitter().


# 9.7 Coordinate systems --------------------------------------------------
# Coordinate systems are probably the most complicated part of ggplot2. The
# - default coordinate system is the Cartesian coordinate system where x and y
# - positions act independently to determine the location of each point. There
# - are two other coordinate systems that are occasionally helpful.
# coord_quickmap() sets the aspect ratio correctly for geographic maps.
nz <- map_data("nz")
ggplot(data = nz, aes(x = long, y = lat, group = group)) +
    geom_polygon(fill = "white", colour = "black")
ggplot(data = nz, aes(x = long, y = lat, group = group)) +
    geom_polygon(fill = "white", colour = "black") +
    coord_quickmap()
# coord_polar() uses polar coordinates. Polar coordinates reveal an 
# - interesting connection between a bar chart and a Coxcomb chart.
bar <- ggplot(data = diamonds) +
    geom_bar(
        mapping = aes(x = clarity, fill = clarity),
        show.legend = F,
        width = 1
    ) +
    theme(aspect.ratio = 1)
bar
bar + coord_flip()
bar + coord_polar()


# 9.8 The layered grammar of graphics -------------------------------------
# NO CODE.


# 9.9 Summary -------------------------------------------------------------
# NO CODE.




#_====
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# C10 - Exploratory data analysis -----------------------------------------
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# This chapter will show you how to use visualization and transformation to
# - explore your data in a systematic way. This task is call Exploratory Data
# - Analysis, or EDA. 
# EDA is an iterative cycle where you:
# 1. Generate questions about your data.
# 2. Search for answers by visualizing, transforming, and modelling your data.
# 3. Use what you learn to refine the questions and generate new questions.
# In this chapter we’ll combine what you’ve learned about dplyr and ggplot2 to
# - interactively ask questions, answer them with data, and ask new questions.


# 10.1 Prerequisites ------------------------------------------------------
library(tidyverse)


# 10.2 Questions ----------------------------------------------------------
# NO CODE.


# 10.3 Variation ----------------------------------------------------------
# Variation is the tendency of the values of a var to change from measurement
# - to measurement. Every var has its own pattern of variation, which can 
# - reveal interesting information about how that it varies btwn measurements
# - on the same observation as well as across observations. The best way to
# - understand that pattern is to visualize the distn of the var’s values.
# CASE: Visualizing the distn of 54k diamond's weight from diamonds dataset.
ggplot(data = diamonds, aes(x = carat)) +
    geom_histogram(binwidth = 0.5)


# 10.3.1 Typical values ====
# CASE: Distribution of carat for smaller diamonds.
smaller <- diamonds |> filter(carat < 3)
ggplot(data = smaller, aes(x = carat)) +
    geom_histogram(binwidth = 0.01)


# 10.3.2 Unusual values ====
# CASE: Distribution of y var in the dataset to see outliers.
diamonds |> ggplot(aes(x = y)) +
    geom_histogram(binwidth = 0.5)
# To easily see the unusual values we zoom to the small values of y-axis.
diamonds |> ggplot(aes(x = y)) +
    geom_histogram(binwidth = 0.5) +
    coord_cartesian(ylim = c(0, 50))
# Now we see that there are three unusual values: 0, ~30, and ~60. 
# We pluck them out with dplyr
unusual <- diamonds |> 
    filter(y < 3 | y > 20) |> 
    select(price, x, y, z) |> 
    arrange(y)
unusual


# 10.4 Unusual values -----------------------------------------------------
# If you’ve encountered unusual values in your dataset, and simply want to
# - move on to the rest of your analysis, you have two options.
# Option 1: We can drop the entire row with strange values.
diamonds2 <- diamonds |>
    filter(between(y, 3, 20))
# This option is not recommended as one invalid value does not imply that all
# - the other values for that observation are also invalid. Also, if you have
# - low quality data then we might end up dropping our entire dataset.
# Option 2: We replace the unusual values with missing values.
diamonds2 <- diamonds |> 
    mutate(
        y = case_when(
            y < 3 | y > 20 ~ NA,
            .default = y
        )
    )
summary(diamonds2$y)
# Since, it’s not obvious where to plot missing values ggplot2 doesn’t include
# - them in the plot, but it does warn that they’ve been removed.
ggplot(data = diamonds2, aes(x = x, y = y)) +
    geom_point()
# We can supress the warning by setting na.rm = T.
ggplot(data = diamonds2, aes(x = x, y = y)) +
    geom_point(na.rm = T)

# Sometimes we want to understand what makes obsns with missing values 
# - different to obsns with recorded values.
# CASE: Compare scheduled departure time of cancelled & non-cancelled flights.
flights |> 
    mutate(
        cancelled = is.na(dep_time),
        sched_hour = sched_dep_time %/% 100,
        sched_min = sched_dep_time %% 100,
        sched_dep_time = sched_hour + (sched_min / 60)
    ) |> 
    ggplot(aes(x = sched_dep_time)) +
    geom_freqpoly(aes(colour = cancelled), binwidth = 1/4)


# 10.5 Covariation --------------------------------------------------------
# Covariation is the tendency for the values of 2 or more vars to vary 
# - together in a related way. If variation describes the behavior within
# - a var, covariation describes the behavior between vars. The best way to
# - spot covariation is to visualize the relationship between 2 or more vars.


# 10.5.1 A categorical and a numerical variable ====
# CASE: Explore how the price of a diamond varies with its quality (cut).
ggplot(data = diamonds, aes(x = price)) +
    geom_freqpoly(
        aes(colour = cut),
        binwidth = 500,
        linewidth = 1
    )
# NOTE: ggplot2 uses an ordered colour scale for cut because it’s defined
# - as an ordered factor var in the data.

# By default the geom_freqpoly() shows the count or absolute distribution
# - which is not that useful for comparison. To make the comparison easier
# - we will display the density, which is the count standardized so that
# - the area under each frequency polygon is one.
ggplot(data = diamonds, aes(x = price, y = after_stat(density))) +
    geom_freqpoly(
        aes(colour = cut),
        binwidth = 500,
        linewidth = 1
    )

# We use box plots as a simpler alternative.
ggplot(data = diamonds, aes(x = cut, y = price)) +
    geom_boxplot()

# NOTE: There are vars which may be categorical but not ordered. So we might
# - want to reorder them using fct_reorder() to make an informative display.
# CASE 1: Check how highway mileage varies across classes.
ggplot(data = mpg, aes(x = class, y = hwy)) +
    geom_boxplot()
# CASE 2: Doing the same after reordering class.
ggplot(data = mpg, aes(x = fct_reorder(class, hwy, median), y = hwy)) +
    geom_boxplot()
# CASE 3: Doing the same with horizontal box plots. We do that by exchanging
# - the x and y aesthetic mappings.
ggplot(data = mpg, aes(x = hwy, y = fct_reorder(class, hwy, median))) +
    geom_boxplot()


# 10.5.2 Two categorical variables ====
# To visualize the covariation between categorical vars, you’ll need to count
# the num of obsns for each combination of levels of these categorical vars.
ggplot(data = diamonds, aes(x = cut, y = color)) +
    geom_count()
# The size of each circle in the plot displays how many obsns occurred at 
# - each combination of values.

# Also, we could compute the counts with dplyr and then graph with geom_tile().
diamonds |> count(color, cut)
diamonds |> count(color, cut) |> 
    ggplot(aes(x = color, y = cut)) +
    geom_tile(aes(fill = n))


# 10.5.3 Two numerical variables ====
# Already we used scatter plot to visualize covariation btwn 2 numerical vars.
smaller <- diamonds |> filter(carat < 3)
ggplot(data = smaller, aes(x = carat, y = price)) +
    geom_point()
# The relationship is exponential.

# Scatterplots become less useful as the size of your dataset grows, because
# - points begin to overplot, and pile up into areas of uniform black.
# One way to fix the problem: using the alpha aesthetic to add transparency.
ggplot(data = smaller, aes(x = carat, y = price)) +
    geom_point(alpha = 1/50)

# NOTE: Using transparency can be challenging for very large datasets.
# Another solution is to use bin in two-dimensions.
# Sol 1: Using rectangular bins
ggplot(data = smaller, aes(x = carat, y = price)) +
    geom_bin2d()
# Sol 2: Using hexagonal bins
ggplot(data = smaller, aes(x = carat, y = price)) +
    geom_hex()
# Sol 3: We could bin carat and then for each group, display a boxplot.
ggplot(data = smaller, aes(x = carat, y = price)) +
    geom_boxplot(
        aes(group = cut_width(carat, 0.1))
    )
# cut_width(x, width), as used above, divides x into bins of width.


# 10.6 Patterns and models ------------------------------------------------
# If a systematic relationship exists between two variables it will appear as
# a pattern in the data. If you spot a pattern, ask yourself:
# >> Could this pattern be due to coincidence (i.e. random chance)?
# >> How can you describe the relationship implied by the pattern?
# >> How strong is the relationship implied by the pattern?
# >> What other variables might affect the relationship?
# >> Does the relationship change if you look at individual data subgroups?

library(tidymodels)
diamonds <- diamonds |> 
    mutate(
        log_price = log(price),
        log_carat = log(carat)
    )
diamonds_fit <- linear_reg() |> 
    fit(log_price ~ log_carat, data = diamonds)
diamonds_aug <- augment(diamonds_fit, new_data = diamonds) |> 
    mutate(.resid = exp(.resid))
ggplot(diamonds_aug, aes(x = carat, y = .resid)) +
    geom_point()
# Once you’ve removed the strong relationship between carat and price, you
# - can see what you expect in the relationship between cut and price: 
# - relative to their size, better quality diamonds are more expensive.
ggplot(data = diamonds_aug, aes(x = cut, y = .resid)) +
    geom_boxplot()


# 10.7 Summary ------------------------------------------------------------
# NO CODE.




#_====
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# C11 - Communication -----------------------------------------------------
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# In C10, you learned how to use plots as tools for exploration. Now that
# - you understand your data, you need to communicate your understanding to
# - others. To help others quickly build up a good mental model of the data
# - you will need to invest considerable effort in making your plots as 
# - self-explanatory as possible. In this chapter, you’ll learn some of the
# - tools that ggplot2 provides to do so.

# In C10, you learned how to use plots as tools for exploration. Now that
# you understand your data, you need to communicate your understanding to
# others. To help others quickly build up a good mental model of the data
# you will need to invest considerable effort in making your plots as 
# self-explanatory as possible. In this chapter, you’ll learn some of the
# tools that ggplot2 provides to do so.

# 11.1 Prerequisites ------------------------------------------------------
library(tidyverse)
library(scales)
library(ggrepel)
library(patchwork)


# 11.2 Labels -------------------------------------------------------------
# The easiest place to start when turning an exploratory graphic into an
# expository graphic is with good labels. You add labels with the labs() fn.
mpg |> ggplot(aes(x = displ, y = hwy)) +
    geom_point(
        aes(colour = class),
        size = 3
    ) +
    geom_smooth(se = F) +
    labs(
        x = "Engine displacement (L)",
        y = "Highway fuel economy (mpg)",
        colour = "Car type",
        title = "Fuel efficiency generally decreases with engine size",
        subtitle = "Two seater (sports cars) are an exception because of their light weight",
        caption = "Data from fueleconomy.gov"
    )

# It’s possible to use mathematical equations instead of text strings. 
# Just switch "" out for quote(). 
df <- tibble(
    x = 1:10,
    y = cumsum(x^2)
)
df |> ggplot(aes(x, y)) +
    geom_point(size = 3) +
    labs(
        x = quote(x[i]),
        y = quote(sum(x[i] ^ 2, i == 1, n))
    )
# Read about the available options in ?plotmath


# 11.3 Annotations --------------------------------------------------------
# Sometimes, it’s useful to label individual obsns or groups of obsns. The 
# first tool you have at your disposal is geom_text(). It is similar to
# geom_point(), but it has an additional aesthetic: label. This makes it
# possible to add textual labels to your plots.

# There are two possible sources of labels. 
# FIRST, you might have a tibble that provides labels.
# Create the data
label_info <- mpg |> 
    group_by(drv) |> 
    arrange(desc(displ)) |> 
    slice_head(n = 1) |> 
    mutate(
        drive_type = case_when(
            drv == "f" ~ "front-wheel drive",
            drv == "r" ~ "rear-wheel drive",
            drv == "4" ~ "4-wheel drive"
        )
    ) |> 
    select(displ, hwy, drv, drive_type)
label_info
# Create the graph
ggplot(data = mpg, aes(x = displ, y = hwy, colour = drv)) +
    geom_point(alpha = 0.3, size = 3) +
    geom_smooth(se = F) +
    geom_text(
        data = label_info,
        aes(x = displ, y = hwy, label = drive_type),
        fontface = "bold", size = 5, hjust = "right", vjust = "bottom"
    ) +
    theme(legend.position = "none")
# The above plot is hard-to-read as the labels overlap with each other and
# the points.
ggplot(data = mpg, aes(x = displ, y = hwy, colour = drv)) +
    geom_point(alpha = 0.3, size = 3) +
    geom_smooth(se = F) +
    geom_label_repel(
        data = label_info,
        aes(x = displ, y = hwy, label = drive_type),
        fontface = "bold", size = 5, nudge_y = 2
    ) +
    theme(legend.position = "none")

# SECOND, we highlight certain points on a plot. We use a handy technique of
# adding a 2nd layer of large, hollow points to highlight the labelled points.
potential_outliers <- mpg |> 
    filter(
        hwy > 40 | (hwy > 20 & displ > 5)
    )
ggplot(data = mpg, aes(x = displ, y = hwy)) +
    geom_point() + 
    geom_text_repel(
        data = potential_outliers, aes(label = model)
    ) +
    geom_point(data = potential_outliers, colour = "red") +
    geom_point(
        data = potential_outliers,
        colour = "red", size = 3, shape = "circle open"
    )

# Another handy function for adding annotations to plots is annotate(). As a
# rule of thumb, geoms are generally useful for highlighting a subset of the
# data while annotate() is useful for adding one or few annotation elements
# to a plot.
# Create text to add to our plot.
trend_text <- "Larger engine sizes tend to have lower fuel economy." |> 
    str_wrap(width = 30)
trend_text
# Create the graph.
ggplot(data = mpg, aes(x = displ, y = hwy)) +
    geom_point() +
    annotate(
        geom = "label", label =  trend_text,
        x = 3.5, y = 38,
        hjust = "left", colour = "red"
    ) +
    annotate(
        geom = "segment",
        x = 3, xend = 5, y = 35, yend = 25,
        colour = "red",
        arrow = arrow(type = "closed")
    )


# 11.4 Scales -------------------------------------------------------------
# The third way you can make your plot better for communication is to adjust
# the scales. Scales control how the aesthetic mappings manifest visually.

# 11.4.1 Default scales ====
# Normally, ggplot2 automatically adds scales for you. When you type
ggplot(data = mpg, aes(x = displ, y = hwy)) +
    geom_point(aes(colour = class))
# ggplot2 automatically adds default scales behind the scenes
ggplot(data = mpg, aes(x = displ, y = hwy)) +
    geom_point(
        aes(colour = class)
    ) +
    scale_x_continuous() +
    scale_y_continuous() +
    scale_colour_discrete()


# 11.4.2 Axis ticks and legend keys ====
# Collectively axes and legends are called guides. Axes are used for x and y
# aesthetics; legends are used for everything else.
# There are two primary arguments that affect the appearance of the ticks on
# the axes and the keys on the legend: breaks and labels. Breaks controls the
# position of the ticks, or the values associated with the keys. Labels 
# controls the text label associated with each tick/key. The most common use
# of breaks is to override the default choice.
ggplot(data = mpg, aes(x = displ, y = hwy)) +
    geom_point(aes(colour = drv)) +
    scale_y_continuous(
        breaks = seq(15, 40, by = 5)
    )

# Labels can be used the same way as breaks. You can also set it to NULL to
# suppress the labels altogether. You can also use breaks and labels to 
# control the appearance of legends. For discrete scales for categorical vars
# labels can be a named list of the existing level names and the desired 
# labels for them.
ggplot(data = mpg, aes(x = displ, y = hwy, colour = drv)) +
    geom_point() +
    scale_x_continuous(labels = NULL) +
    scale_y_continuous(labels = NULL) +
    scale_colour_discrete(
        labels = c("4" = "4-wheel", "f" = "front", "r" = "rear")
    )

# The labels arg coupled with labelling fns from the scales package is also
# useful for formatting numbers as currency, percent, etc.
# CASE: Plot with dollar sign label and thousand separator commas.
ggplot(data = diamonds, aes(x = price, y = cut)) +
    geom_boxplot(alpha = 0.05) +
    scale_x_continuous(labels = label_dollar())
# CASE: Plot with dollar values divided by 1,000 and adding a suffix 
# “K” (for “thousands”) as well as adding custom breaks.
ggplot(data = diamonds, aes(x = price, y = cut)) +
    geom_boxplot(alpha = 0.05) +
    scale_x_continuous(
        labels = label_dollar(scale = 1/1000, suffix = "K"),
        breaks = seq(1000, 19000, by = 6000)
    )
# CASE: Adding percentage to labels.
ggplot(data = diamonds, aes(x = cut, fill = clarity)) +
    geom_bar(position = "fill") +
    scale_y_continuous(
        labels = label_percent(),
        name = "Percentage"
    )

# Another use of breaks is when you have relatively few data points and want
# to highlight exactly where the observations occur. 
# CASE: Plot showing when each US president started and ended their term.
presidential |> 
    mutate(
        id = 33 + row_number()
    ) |> 
    ggplot(aes(x = start, y = id)) +
    geom_point() +
    geom_segment(
        aes(xend = end, yend = id)
    ) +
    scale_x_date(
        breaks = presidential$start,
        date_labels = "'%y",
        name = NULL
    )


# 11.4.3 Legend layout ====
# We most often use breaks and labels to tweak the axes.
base <- ggplot(data = mpg, aes(x = displ, y = hwy)) +
    geom_point(aes(colour = class))
base + theme(legend.position = "right")     # default
base + theme(legend.position = "left")
base + 
    theme(legend.position = "top") +
    guides(colour = guide_legend(nrow = 3))
base + 
    theme(legend.position = "bottom") +
    guides(colour = guide_legend(nrow = 3))

# To control the display of individual legends, use guides() along with
# guide_legend() or guide_colorbar().
ggplot(data = mpg, aes(x = displ, y = hwy)) +
    geom_point(aes(colour = class)) +
    geom_smooth(se = F) +
    theme(legend.position = "bottom") +
    guides(
        colour = guide_legend(nrow = 2, override.aes = list(size = 4))
    )
# NOTE: The name of the argument in guides() matches the name of the
# aesthetic just like in labs()


# 11.4.4 Replacing a scale ====
# Instead of just tweaking the details a little, you can instead replace 
# the scale altogether. It’s very useful to plot transformations of vars.
# CASE: Relationship btwn carat and price after log transformation.
ggplot(data = diamonds, aes(x = carat, y = price)) +
    geom_bin2d()
ggplot(data = diamonds, aes(x = log10(carat), y = log10(price))) +
    geom_bin2d()
# In this transformation the axes are now labelled with the transformed
# values which makes plot interpretation hard. Therefore, instead of doing
# the transformation in the aesthetic mapping, we can do it in the scale.
ggplot(data = diamonds, aes(x = carat, y = price)) +
    geom_bin2d() +
    scale_x_log10() +
    scale_y_log10()

# Now we learn to customize colour scale. We can change colour scale using 
# user-defined scales.
# CASE: Use Colorbrewer scales to make plot colour-blind friendly.
ggplot(data = mpg, aes(x = displ, y = hwy)) +
    geom_point(
        aes(colour = drv),
        size = 3
    )
ggplot(data = mpg, aes(x = displ, y = hwy)) +
    geom_point(
        aes(colour = drv),
        size = 3
    ) +
    scale_colour_brewer(palette = "Set1")
# If there are just a few colours, you can add a redundant shape mapping. 
# This will also help ensure your plot is interpretable in black and white.
ggplot(data = mpg, aes(x = displ, y = hwy)) +
    geom_point(
        aes(colour = drv, shape = drv),
        size = 3
    ) +
    scale_colour_brewer(palette = "Set1")
# When you have a predefined mapping between values and colours, use 
# scale_colour_manual(). 
# CASE: When we map presidential party to colour, we want to use the standard
# mapping of red for Republicans and blue for Democrats.
presidential |> 
    mutate(id = 33 + row_number()) |> 
    ggplot(aes(x = start, y = id, colour = party)) +
    geom_point(size = 2) +
    geom_segment(
        aes(xend = end, yend = id),
        linewidth = 1
    ) +
    scale_colour_manual(
        values = c("Republican" = "#E81B23", "Democratic" = "#00AEF3"),
    )

# For continuous colour, we can use built-in colour palettes or the Viridis
# colour scheme. Viridis gives carefully tailored continuous colour schemes
# that are perceptible to people with various forms of colour blindness as 
# well as perceptually uniform in both colour and black and white. These 
# scales are available as continuous (c), discrete (d), and binned (b) 
# palettes in ggplot2.
# Data
df <- tibble(
    x = rnorm(1000), y = rnorm(1000)
)
# Default continuous scale
ggplot(df, aes(x = x, y = y)) +
    geom_hex() +
    coord_fixed() +
    labs(
        title = "Default, continuous",
        x = NULL, y = NULL
    )
# Viridis continuous scale
ggplot(df, aes(x = x, y = y)) +
    geom_hex() +
    coord_fixed() +
    scale_fill_viridis_c() +
    labs(
        title = "Viridis, continuous",
        x = NULL, y = NULL
    )
# Viridis binned
ggplot(df, aes(x = x, y = y)) +
    geom_hex() +
    coord_fixed() +
    scale_fill_viridis_b() +
    labs(
        title = "Viridis, binned",
        x = NULL, y = NULL
    )


# 11.4.5 Zooming ====
# There are three ways to control the plot limits:
# 1. Adjusting what data are plotted.
# 2. Setting the limits in each scale.
# 3. Setting xlim and ylim in coord_cartesian().
# We see each of them in a series of plots below.

# CASE: Plot showing relationship between engine size and fuel efficiency
#       coloured by type of drive train.
ggplot(data = mpg, aes(x = displ, y = hwy)) +
    geom_point(aes(colour = drv)) +
    geom_smooth()
# CASE: Same plot on a subset of same data.
mpg |> 
    filter(displ >= 5 & displ <= 6 & hwy >= 10 & hwy <= 25) |> 
    ggplot(aes(x = displ, y = hwy)) +
    geom_point(aes(colour = drv)) +
    geom_smooth()
# NOTE: Subsetting data has affected the x and y scales and the smooth curve.

# CASE: Plot with limits in scales itself.
ggplot(data = mpg, aes(x = displ, y = hwy)) +
    geom_point(aes(colour = drv)) +
    geom_smooth() +
    scale_x_continuous(limits = c(5, 6)) +
    scale_y_continuous(limits = c(10, 25))
# NOTE: This too affects the scales and the smooth curve.

# CASE: Setting limits using coord_cartesian().
ggplot(data = mpg, aes(x = displ, y = hwy)) +
    geom_point(aes(colour = drv)) +
    geom_smooth() +
    coord_cartesian(
        xlim = c(5, 6),
        ylim = c(10, 25)
    )

# Setting the limits on individual scales is generally more useful if you 
# want to expand the limits, e.g., to match scales across different plots.  
# CASE: We extract two classes of cars and plot them separately.
# Creating data subset
suv <- mpg |> filter(class == "suv")
compact <- mpg |> filter(class == "compact")
# Plot with suv subset
ggplot(data = suv, aes(x = displ, y = hwy, colour = drv)) +
    geom_point()
# Plot with compact subset
ggplot(data = compact, aes(x = displ, y = hwy, colour = drv)) +
    geom_point()
# NOTE: It’s difficult to compare the plots because all three scales 
# (the x-axis, the y-axis, and the colour aesthetic) have different ranges.

# SOL: To overcome this problem is to share scales across multiple plots
# training the scales with the limits of the full data.
x_scale <- scale_x_continuous(limits = range(mpg$displ))
y_scale <- scale_y_continuous(limits = range(mpg$hwy))
col_scale <- scale_colour_discrete(limits = unique(mpg$drv))
# Plot with suv subset
ggplot(data = suv, aes(x = displ, y = hwy, colour = drv)) +
    geom_point() +
    x_scale + y_scale + col_scale
# Plot with compact subset
ggplot(data = compact, aes(x = displ, y = hwy, colour = drv)) +
    geom_point() +
    x_scale + y_scale + col_scale


# 11.5 Themes -------------------------------------------------------------
# We can customize the non-data elements of our plot with a theme.
ggplot(data = mpg, aes(x = displ, y = hwy)) +
    geom_point(aes(colour = class)) +
    geom_smooth(se = F) +
    theme_bw()

# CASE: Customizing individual theme elements.
ggplot(data = mpg, aes(x = displ, y = hwy, colour = drv)) +
    geom_point() +
    labs(
        title = "Larger engine sizes tend to have lower fuel economy",
        caption = "Source: https://fueleconomy.gov."
    ) +
    theme(
        legend.position = c(0.6, 0.7),
        legend.direction = "horizontal",
        legend.box.background = element_rect(colour = "black"),
        plot.title = element_text(face = "bold"),
        plot.title.position = "plot",
        plot.caption.position = "plot",
        plot.caption = element_text(hjust = 0)
    )


# 11.6 Layout -------------------------------------------------------------
# The patchwork package allows you to combine separate plots into the same
# graphic. To place two plots next to each other, you can simply add them 
# to each other.
p1 <- ggplot(data = mpg, aes(x = displ, y = hwy)) +
    geom_point() +
    labs(title = "Plot 1")
p1
p2 <- ggplot(data = mpg, aes(x = drv, y = hwy)) +
    geom_boxplot() +
    labs(title = "Plot 2")
p2
p1 + p2
# NOTE: In the above code chunk we did not use a new fn from the patchwork 
# package. Instead, the package added a new functionality to the + operator.

# We can also create complex layouts with patchwork.
p3 <- ggplot(data = mpg, aes(x = cty, y = hwy)) +
    geom_point() +
    labs(title = "Plot 3")
p3
(p1 | p3) / p2

# Additionally, patchwork allows you to collect legends from multiple plots
# into one common legend, customize the placement of the legend as well as
# dimensions of the plots, and add a common title, subtitle, caption, etc.
# to your plots.
p1 <- ggplot(data = mpg, aes(x = drv, y = cty, colour = drv)) +
    geom_boxplot(show.legend = F) +
    labs(title = "Plot 1")
p2 <- ggplot(data = mpg, aes(x = drv, y = cty, colour = drv)) +
    geom_boxplot(show.legend = F) +
    labs(title = "Plot 2")
p3 <- ggplot(data = mpg, aes(x = cty, colour = drv, fill = drv)) +
    geom_density(alpha = 0.5) +
    labs(title = "Plot 3")
p4 <- ggplot(data = mpg, aes(x = hwy, colour = drv, fill = drv)) +
    geom_density(alpha = 0.5) +
    labs(title = "Plot 4")
p5 <- ggplot(data = mpg, aes(x = cty, y = hwy, colour = drv)) +
    geom_point(show.legend = F) +
    facet_wrap( ~ drv) +
    labs(title = "Plot 5")
# Combining the plots.
(guide_area() / (p1 + p2) / (p3 + p4) / p5) +
    plot_annotation(
        title = "City and highway mileage for cars with different drive trains",
        caption = "Source: https://fueleconomy.gov."
    ) +
    plot_layout(
        guides = "collect", heights = c(1, 3, 2, 4)
    ) & 
    theme(legend.position = "top")


# 11.7 Summary ------------------------------------------------------------
# NO CODE.





























