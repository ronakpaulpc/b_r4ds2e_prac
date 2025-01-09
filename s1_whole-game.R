# Code from book R for Data Science (2nd Edition) by Hadley Wickham and co.
# Here we have script files for each book section.
# Then, in each script file we have code sections for each chapter.
# This script contains code from the "Whole Game" section of the book.
# Here we get rapid overview of the main tools of data science: 
# importing, tidying, transforming, and visualizing data
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
#         "tidyverse",        # universe of pkgs for data manipulation
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


# # Trials for ways to load multiple packages in a single cmd
# # Loading using lapply
# reqpkgs <- c(
#     "nycflights13",
#     "tidyverse"
# )
# invisible(
#     lapply(reqpkgs, library, character.only = T)
# )
# # NOTE: This does not show which pkg gives the loading message
# 
# 
# # Loading using easypackages
# libraries(
#     "nycflights13",
#     "tidyverse"
# )
# # NOTE: This shows the loading messages of the pkgs by pkg name
# 
# 
# # Loading using pacman
# library(pacman)
# p_load(
#     nycflights13,               # commands from the tidy universe
#     tidyverse                   # contains "flights" dataset
# )
# # NOTE: This does not give any loading messages


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
    "repurrrsive",
    "tidymodels",
    "writexl"
)
# p_loaded()                          # checking the loaded packages
# unloadNamespace("writexl")          # Unloading a pkg




#_====
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# C1 - Data visualization -------------------------------------------------
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Here we get brief intro of data visualization with ggplot2
# Visualization is a mapping from variables in data to aesthetic properties
# Aesthetic properties - position, colour, size, and shape
# We do a deeper dive into creating visualizations with ggplot2-
# -in Chapter 10 through Chapter 12.


# 1.1 Prerequisites -------------------------------------------------------
# Packages required for this chapter
library(pacman)
p_load(
    tidyverse,                      # commands from the tidy universe
    palmerpenguins,                 # contains the "penguins" dataset
    ggthemes                        # has colour-blind safe colour palette
)


# 1.2 First steps ---------------------------------------------------------
# Let's see.

# 1.2.1 Exploring the penguins dataset ====
penguins                # View dataframe on console
glimpse(penguins)       # Alter dataframe view with few obs
View(penguins)          # Dataframe view

# 1.2.2 Ultimate goal ====
# Here we create our first ggplot step-by-step
# Graph with only data
ggplot(data = penguins)

# Next graph with axes aesthetics
ggplot(
    data = penguins,
    mapping = aes(x = flipper_length_mm, y = body_mass_g)
)

# Graph with geom aesthetic
ggplot(
    data = penguins,
    mapping = aes(x = flipper_length_mm, y = body_mass_g)
) +
    geom_point()

# 1.2.4 Adding aesthetics and layers ====
# Graph with point colour by species
ggplot(
    data = penguins,
    mapping = aes(x = flipper_length_mm, y = body_mass_g, colour = species)
) +
    geom_point()

# Graph with smooth linear curve
ggplot(
    data = penguins,
    mapping = aes(x = flipper_length_mm, y = body_mass_g, colour = species)
) +
    geom_point() +
    geom_smooth(method = "lm")

# Graph with single smooth curve
ggplot(
    data = penguins,
    mapping = aes(x = flipper_length_mm, y = body_mass_g)
) +
    geom_point(
        mapping = aes(colour = species)
    ) +
    geom_smooth(method = "lm")

# Graph with colour and shape by species
ggplot(
    data = penguins,
    mapping = aes(x = flipper_length_mm, y = body_mass_g)
) +
    geom_point(
        mapping = aes(colour = species, shape = species)
    ) +
    geom_smooth(method = "lm")

# Refined graph
ggplot(
    data = penguins,
    mapping = aes(x = flipper_length_mm, y = body_mass_g)
) +
    geom_point(
        mapping = aes(colour = species, shape = species)
    ) +
    geom_smooth(method = "lm") +
    labs(
        title = "Body mass and flipper length",
        subtitle = "Dimensions for Adelie, Chinstrap and Gentoo Penguins",
        x = "Flipper length (mm)",
        y = "Body mass (g)",
        colour = "Species",
        shape = "Species"
    ) +
    scale_colour_colorblind()


# 1.3 ggplot2 calls -------------------------------------------------------
# Alternative graphs
ggplot(
    data = penguins,
    mapping = aes(x = flipper_length_mm, y = body_mass_g)
) +
    geom_point()

ggplot(penguins, aes(x = flipper_length_mm, y = body_mass_g)) +
    geom_point()

penguins |> 
    ggplot(aes(x = flipper_length_mm, y = body_mass_g)) +
    geom_point()


# 1.4 Visualizing distributions -------------------------------------------
# Let's see

# 1.4.1 A categorical variable ====
# Bar graph
ggplot(
    data = penguins,
    mapping = aes(x = species)
) +
    geom_bar()

# With ordered bars
ggplot(
    data = penguins,
    mapping = aes(x = fct_infreq(species))
) +
    geom_bar()

# 1.4.2 A numerical variable ====
# Histogram
ggplot(
    data = penguins,
    mapping = aes(x = body_mass_g)
) +
    geom_histogram(binwidth = 200)

# Histogram of different bin widths
ggplot(data = penguins, aes(x = body_mass_g)) +
    geom_histogram(binwidth = 20)
ggplot(data = penguins, aes(x = body_mass_g)) +
    geom_histogram(binwidth = 2000)

# Density plot
ggplot(
    data = penguins, 
    mapping = aes(x = body_mass_g)
) +
    geom_density()


# 1.5 Visualizing relationships -------------------------------------------
# Here we create graph of at least two variables

# 1.5.1 A numerical and a categorical variable ====
# Box plot
ggplot(data = penguins, mapping = aes(x = species, y = body_mass_g)) +
    geom_boxplot()

# Alternatively, density plots
ggplot(
    data = penguins, 
    mapping = aes(x = body_mass_g, colour = species)
) + 
    geom_density(linewidth = 0.75)

ggplot(
    data = penguins,
    mapping = aes(x = body_mass_g, colour = species, fill = species)
) +
    geom_density(alpha = 0.5)

# 1.5.2 Two categorical variables ====
# Stacked bar graph
ggplot(
    data = penguins,
    mapping = aes(x = island, fill = species)
) +
    geom_bar()

# With percentage bars
ggplot(
    data = penguins,
    mapping = aes(x = island, fill = species)
) +
    geom_bar(position = "fill")

# 1.5.3 Two numerical variables ====
# Scatter plot
ggplot(
    data = penguins,
    mapping = aes(x = flipper_length_mm, y = body_mass_g)
) +
    geom_point()

# 1.5.4 Three or more variables ====
# Complex scatter plot
ggplot(
    data = penguins,
    mapping = aes(x = flipper_length_mm, y = body_mass_g)
) +
    geom_point(
        aes(colour = species, shape = island),
        size = 3,
        alpha = 3/4
    )

# Scatter plot with sub-plots
ggplot(
    data = penguins,
    aes(x = flipper_length_mm, y = body_mass_g)
) +
    geom_point(
        aes(colour = species, shape = species)
    ) +
    facet_wrap(~ island)


# 1.6 Saving your plots ---------------------------------------------------
# We use ggsave()
ggplot(
    data = penguins,
    mapping = aes(x = flipper_length_mm, y = body_mass_g)
) +
    geom_point(
        mapping = aes(colour = species, shape = species)
    ) +
    geom_smooth(method = "lm") +
    labs(
        title = "Body mass and flipper length",
        subtitle = "Dimensions for Adelie, Chinstrap and Gentoo Penguins",
        x = "Flipper length (mm)",
        y = "Body mass (g)",
        colour = "Species",
        shape = "Species"
    ) +
    scale_colour_colorblind()
ggsave(filename = "penguin-plot.png")


# 1.7 Common problems -----------------------------------------------------
# NO CODE.


# 1.8 Summary -------------------------------------------------------------
# NO CODE.




#_====
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# C2 - Workflow: Basics ---------------------------------------------------
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Here we get a foundation in running R code 
# Also, we get to know some of the most helpful RStudio features

# 2.1 Coding basics -------------------------------------------------------
# Basic math calculations in R
1 / 200 * 30
(59 + 73 + 2) / 3
sin(pi / 2)

# Creating new objects
x <- 3 * 4
primes <- c(2, 3, 5, 7, 11, 13)
primes * 2
primes - 1


# 2.2 Comments ------------------------------------------------------------
# Create a vector of primes
primes <- c(2, 3, 5, 7, 11, 13)
# Multiply primes by 2
primes * 2

# NOTE: Use comments to explain the "why" of your code, not the "how" or "what"


# 2.3 What's in a name? ---------------------------------------------------
# Inspecting an object by typing it's name
x
this_is_a_really_long_name <- 2.5
this_is_a_really_long_name
r_rocks <- 2^3


# 2.4 Calling functions ---------------------------------------------------
seq(from = 1, to = 10)  
x <- "hello world"


# 2.5 Exercises -----------------------------------------------------------
# DO IN SEPARATE SCRIPT FILE.


# 2.6 Summary -------------------------------------------------------------
# NO CODE.




#_====
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# C3 - Data transformation ------------------------------------------------
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Here we get an overview of all the key tools for transforming a dataframe.
# We’ll start with fns that operate on rows and then columns of a dataframe.
# Then we'll talk more about the pipe operator.
# Then we'll introduce the ability to work with groups.
# Then we will see a case study that showcases these functions in action.


# 3.1 Prerequisites -------------------------------------------------------
# Packages required for this chapter
# Loading using lapply
reqpkgs <- c(
    "nycflights13",
    "tidyverse"
)
invisible(
    lapply(reqpkgs, library, character.only = T)
)
# NOTE: This does not show which pkg gives the loading message


# Loading using easypackages
libraries(
    "nycflights13",
    "tidyverse"
)
# NOTE: This shows the loading messages of the pkgs by pkg name


# Loading using pacman
library(pacman)
p_load(
    nycflights13,               # commands from the tidy universe
    tidyverse                   # contains "flights" dataset
)


# 3.2 Rows ----------------------------------------------------------------
# Here we see commands that work on dataframe rows
# distinct() cmd may also work on columns

# 3.2.1 filter() ====
# Find all flights that departed more than 120 minutes late
flights |> 
    filter(dep_delay > 120)
# Flights that departed on January 1
flights |> 
    filter(month == 1 & day == 1)
# Flights that departed in January or February
flights |> 
    filter(month == 1 | month == 2)
# A shorter way to select flights that departed in January or February
flights |> 
    filter(month %in% c(1, 2))
# Creating dataframe of flights that departed on January 1
jan1 <- flights |> 
    filter(month == 1 & day == 1)

# 3.2.3 arrange() ====
# Sort dataframe by the departure time, which is spread over four columns
flights |> 
    arrange(year, month, day, dep_time)
# Order flights from most to least delayed
flights |> 
    arrange(
        desc(dep_delay)
    )

# 3.2.4 distinct() ====
# Remove duplicate rows from dataframe, if any
flights |> 
    distinct()

# Find all unique origin and destination pairs
flights |> 
    distinct(origin, dest)
# Alternatively, keep other columns when filtering for unique rows
flights |> 
    distinct(origin, dest, keep.all = T)

# Find the the number of occurrences of each unique origin-dest pair
flights |> 
    count(origin, dest, sort = T)


# 3.3 Columns --------------------------------------------------------------
# Here we see commands that work on dataframe columns
# These commands do not affect the rows
# mutate() creates new columns that are derived from the existing columns
# select() changes which columns are present 
# rename() changes the names of the columns, and 
# relocate() changes the positions of the columns.

# 3.3.1 mutate() ====
# We calculate two variables
# First we compute "gain", how much time a delayed flight made up in the air
# Then, the "speed" in miles per hour
flights |> 
    mutate(
        gain = dep_delay - arr_delay,
        speed = distance / (air_time / 60)
    )
# We use ".before" argument to add the new variables to the left hand side
flights |> 
    mutate(
        gain = dep_delay - arr_delay,
        speed = distance / (air_time / 60),
        .before = 1
    )
# Adding the new variables after "day" column
flights |> 
    mutate(
        gain = dep_delay - arr_delay,
        speed = distance / (air_time / 60),
        .after = day
    )

# Keep the columns that were involved or created in the mutate() step
flights |> 
    mutate(
        gain = dep_delay - arr_delay,
        hours = air_time / 60,
        gain_per_hour = gain / hours,
        speed = distance / hours,
        .keep = "used"
    )

# 3.3.2 select() ====
# Select columns by name
flights |> 
    select(year, month, day)
# Select all columns between year and day (inclusive)
flights |> 
    select(year:day)
# Select all columns except those from year to day (inclusive)
flights |> 
    select(!year:day)
# Select all columns that are characters
flights |> 
    select(
        where(is.character)
    )

# Rename variables while select() them by using =
# NOTE: new name appears on left of =, and the old variable appears on right
flights |> 
    select(tail_num = tailnum)

# 3.3.3 rename() ====
# Use this when we want to keep the existing variables and rename a few
flights |> 
    rename(tail_num = tailnum)

# 3.3.4 relocate() ====
# We use this to move variables around
flights |> 
    relocate(time_hour, air_time)
# We can specify where to put the vars using the ".before" and ".after" args.
flights |> 
    relocate(year:dep_time, .after = time_hour) |> 
    glimpse()
flights |> 
    relocate(starts_with("arr"), .before = dep_time) |> 
    glimpse()


# 3.4 The pipe ------------------------------------------------------------
# Here we see the real power of pipe when we start combining multiple verbs.
# CASE: Find the fastest flights to Houston’s IAH airport.
flights |> 
    filter(dest == "IAH") |> 
    mutate(speed = distance / air_time * 60) |> 
    select(year:day, dep_time, carrier, flight, speed) |> 
    arrange(desc(speed))
# Using pipe it’s easy to skim because the verbs come each line's start:
# > start with the flights data,
# > then filter,
# > then mutate,
# > then select,
# > then arrange.

# Without the pipe things would get complicated.
# We would have to nest each function call inside the previous call.
arrange(
    select(
        mutate(
            filter(
                flights, 
                dest == "IAH"
            ),
            speed = distance / air_time * 60
        ),
        year:day, dep_time, carrier, flight, speed
    ),
    desc(speed)
)
# Or, we could use a bunch of intermediate objects.
flights1 <- filter(flights, dest == "IAH")
flights2 <- mutate(flights1, speed = distance / air_time * 60)
flights3 <- select(flights2, year:day, dep_time, carrier, flight, speed)
arrange(flights3, desc(speed))
# NOTE: While both forms have their time and place, the pipe generally 
# - produces data analysis code that is easier to write and read.


# 3.5 Groups --------------------------------------------------------------
# Till now we have seen dplyr fns that work with rows and cols. dplyr gets 
# - even more powerful when you add in the ability to work with groups.
# Here, we’ll focus on the most important functions:
# > group_by(),
# > summarize(), and
# > the slice family of functions.

# 3.5.1 group_by() ====
# We use group_by() to divide dataset into meaningful groups for analysis.
flights |> 
    group_by(month)
# group_by() does not change the data but if you look closely you will notice
# - in the output that it is “grouped by” month. This means subsequent 
# - operations will now work “by month”.

# 3.5.2 summarize() ====
# The most important grouped operation is a summary, which, when used to
# - calculate a single summary statistic, reduces the data frame to have
# - a single row for each group.
# CASE: Compute the average departure delay for each month.
flights |> 
    group_by(month) |> 
    summarize(
        avg_delay = mean(dep_delay)
    )
# Uhoh, all of our results are NAs, as some of the observed flights had
# - missing data in the delay column. We will tell the mean fn to ignore 
# - the missing values.
flights |> 
    group_by(month) |> 
    summarize(
        avg_delay = mean(dep_delay, na.rm = T)
    )
# We can create any number of summaries in a single call to summarize(). One 
# - very useful summary is n(), which returns the num of rows in each group.
flights |> 
    group_by(month) |> 
    summarize(
        avg_delay = mean(dep_delay, na.rm = T),
        n = n()
    )
# NOTE: Means and counts can get you a surprisingly long way in data science!

# 3.5.3 The slice_ functions ====
# There are 5 handy fns that allow extracting specific rows within each group:
# > df |> slice_head(n = 1) takes the first row from each group.
# > df |> slice_tail(n = 1) takes the last row in each group.
# > df |> slice_min(x, n = 1) takes the row with the smallest value of col x.
# > df |> slice_max(x, n = 1) takes the row with the largest value of col x.
# > df |> slice_sample(n = 1) takes one random row.
# We can vary n to select more than one row, or instead of n 
# - we can use prop = 0.1 to select (e.g.) 10% of the rows in each group.

# CASE: Find flights that are most delayed upon arrival at each destination.
flights |> 
    group_by(dest) |> 
    slice_max(arr_delay, n = 1) |> 
    relocate(dest)
# NOTE: There are 105 destinations but we get 108 rows here.
unique(flights$dest) |> length()
# This happens as slice_min() and slice_max() keep tied values, so they 
# - give us all rows with the highest value. If you want exactly 
# - one row per group you can set with_ties = FALSE.

# 3.5.4 Grouping by multiple variables ====
# We can create groups using more than one variable. 
# CASE: Make a group for each date.
daily <- flights |> 
    group_by(year, month, day)
daily
# When you summarize a tibble grouped by more than one var, each summary 
# - peels off the last group. To make it obvious what’s happening, dplyr 
# - displays a message that tells you how you can change this behavior.
daily_flights <- daily |> 
    summarize(n = n())
# We can request to keep this grouping and suppress the message.
daily_flights <- daily |> 
    summarize(
        n = n(),
        .groups = "drop_last"
    )
daily_flights
# Alternatively, change the default behaviour by setting a different value.
# Using "drop" to drop all grouping.
daily_flights <- daily |> 
    summarize(
        n = n(),
        .groups = "drop"
    )
daily_flights
# Using "keep" to preserve the same groups.
daily_flights <- daily |> 
    summarize(
        n = n(),
        .groups = "keep"
    )
daily_flights

# 3.5.5 Ungrouping ====
# You might also want to remove grouping from a dataframe without 
# - using summarize(). You can do this with ungroup().
daily |> ungroup()
# Now let’s see what happens when you summarize an ungrouped dataframe.
daily |> 
    ungroup() |> 
    summarize(
        avg_delay = mean(dep_delay, na.rm = T),
        flights = n()
    )
# We get a single row back because dplyr treats all the rows in an 
# - ungrouped dataframe as belonging to one group.

# 3.5.6 .by ====
# dplyr 1.1.0 includes a new, experimental, syntax for per-operation grouping,
# - the .by argument. group_by() and ungroup() aren’t going away, but you can
# - now also use the .by argument to group within a single operation.
flights |> 
    summarize(
        delay = mean(dep_delay, na.rm = T),
        n = n(),
        .by = month
    )
# group by multiple variables.
flights |> 
    summarize(
        delay = mean(dep_delay, na.rm = T),
        n = n(),
        .by = c(origin, dest)
    )
# .by works with all verbs and has the advantage that you do not need to use
# - the .groups argument to suppress the grouping message or ungroup() 
# - when you’re done.


# Case study: aggregates and sample size ----------------------------------
# TBC ####











#_====
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# C4 - Workflow: code style -----------------------------------------------
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Here we learn about writing clean and readable codes
# We can use the "styler" pkg to quickly restyle existing code

# Packages required for this chapter
libraries(
    "nycflights13",
    "tidyverse"
)


# 4.1 Names ----------------------------------------------------------------
# NOTE: use only lowercase letters, numbers, and "_"
# As a general rule of thumb, it’s better to prefer long, descriptive names 
# that are easy to understand rather than concise names that are fast to type. 
# Short names save relatively little time when writing code 
# (especially since autocomplete will help you finish typing them), 
# but it can be time-consuming when you come back to old code 
# and are forced to puzzle out a cryptic abbreviation.

# Strive for:
short_flights <- flights |> filter(air_time < 60)
# Avoid:
SHORTFLIGHTS <- flights |> filter(air_time < 60)


# 4.2 Spaces ---------------------------------------------------------------
# Put spaces on either side of mathematical operators and around 
# the assignment operator 
# Strive for
z <- (a + b)^2 / d
# Avoid
z<-( a + b ) ^ 2/d

# Don’t put spaces inside or outside parentheses for regular function calls
# Strive for
mean(x, na.rm = TRUE)
# Avoid
mean (x ,na.rm=TRUE)


# 4.3 Pipes ----------------------------------------------------------------
# |> should always have a space before it and be the last thing on a line
# Strive for 
flights |>  
    filter(!is.na(arr_delay), !is.na(tailnum)) |> 
    count(dest)
# Avoid
flights|>filter(!is.na(arr_delay), !is.na(tailnum))|>count(dest)

# Be wary of writing very long pipes, say longer than 10-15 lines. 
# Break them into smaller sub-tasks, giving each task an informative name.


# 4.4 ggplot2 --------------------------------------------------------------
# The same basic rules that apply to the pipe also apply to ggplot2
# just treat + the same way as |>


# 4.5 Sectioning comments --------------------------------------------------
# As your scripts get longer, use sectioning comments 
# to break up your file into manageable pieces



#_====
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# C5 - Data tidying -------------------------------------------------------
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Here we learn a consistent way to organize data in R using a system
# - called tidy data.
# Getting your data into tidy format requires some work up front.
# Once you have tidy data and the tidy tools provided by packages
# - you will spend more time on the data questions you care about.


# 5.1 Prerequisites --------------------------------------------------------
# In this chapter we only require the tidyr pkg which is part of tidyverse pkg
library(tidyverse)


# 5.2 Tidy data ------------------------------------------------------------
# Here we learn the definition of tidy data.
# Then we see the definition applied to a simple toy dataset.

# Seeing the same data organized in three different ways
print(table1)
print(table2)
print(table3)
# Among all datasets table1 will be much easier to work with because it’s tidy.

# Examples of working with table1 using tidyverse cmds
# Compute rate per 10,000
table1 |> 
    mutate(rate = cases / population * 10000)
# Compute total cases per year
table1 |> 
    group_by(year) |> 
    summarize(total_cases = sum(cases))
# Visualize country-wise case changes over time
ggplot(data = table1, aes(x = year, y = cases)) +
    geom_line(
        aes(group = country), 
        colour = "grey50"
    ) +
    geom_point(
        aes(colour = country, shape = country)
    ) +
    scale_x_continuous(breaks = c(1999, 2000))


# 5.3 Lengthening the data -------------------------------------------------
# We learn to pivot the data into a tidy form, with vars in the cols 
# - and obs in the rows.
# tidyr provides two fns for pivoting data: pivot_longer() and pivot_wider().

# 5.3.1 Data in column names ====
print(billboard)
View(billboard)
# Here, the col names are one var (week) the cell values are another (rank).
# The data is in wide format and we pivot this data from wide to long.
billboard |> 
    pivot_longer(
        cols = starts_with("wk"),
        names_to = "week",
        values_to = "rank"
    )

# The long dataframe has NA's that don’t really represent unknown observations
# They were forced to exist by the structure of the dataset
# Example, there are many songs that have been in the top 100 for < 76 weeks
billboard |> 
    pivot_longer(
        cols = starts_with("wk"),
        names_to = "week",
        values_to = "rank",
        values_drop_na = TRUE
    )

# Creating the final tidy dataset
# Add, we convert week values from strings to number
billboard_longer <- billboard |> 
    pivot_longer(
        cols = starts_with("wk"),
        names_to = "week",
        values_to = "rank",
        values_drop_na = TRUE
    ) |> 
    mutate(
        week = parse_number(week)
    )
View(billboard_longer)

# Now we visualize how song ranks vary over time
billboard_longer |> 
    ggplot(aes(x = week, y = rank, group = track)) +
    geom_line(
        alpha = 0.25
    ) +
    scale_y_reverse()

# 5.3.2 How does pivoting work? ====
# We see how pivoting works using a simple dataframe
# Creating the dataframe
df <- tribble(
    ~id, ~bp1, ~bp2,
    "A", 100, 120,
    "B", 140, 115,
    "C", 120, 125
)
print(df)

# Pivoting df to longer
df_l <- df |> 
    pivot_longer(
        cols = c(bp1, bp2),
        names_to = "measurement",
        values_to = "value"
    )
print(df_l)

# 5.3.3 Many variables in column names ====
glimpse(who2)
View(who2)
who2 |> 
    pivot_longer(
        cols = !(country:year),
        names_to = c("diagnosis", "gender", "age"),
        names_sep = "_",
        values_to = "count"
    )

# 5.3.4 Data and variable names in the column headers ====
glimpse(household)
print(household)
household |> 
    pivot_longer(
        cols = !family,
        names_to = c(".value", "child"),
        names_sep = "_",
        values_drop_na = TRUE
    )


# 5.4 Widening the data ----------------------------------------------------
# Here we use pivot_wider() which makes datasets wider 
# - by increasing columns and reducing rows 
glimpse(cms_patient_experience)
View(cms_patient_experience)
# Here each organization is spread across six rows 
# - with one row for each measurement taken in the survey organization

# We see the complete set of values for measure_cd and measure_title vars
cms_patient_experience |> 
    distinct(measure_cd, measure_title)

# Now we pivot to wide form
# Here id col is not given and we stil have multiple columns
cms_patient_experience |> 
    pivot_wider(
        names_from = measure_cd,
        values_from = prf_rate
    )
# Here id col is defined and we get single rows for each organization
cms_patient_experience |> 
    pivot_wider(
        id_cols = starts_with("org"),
        names_from = measure_cd,
        values_from = prf_rate
    )

# 5.4.1 How does pivot_wider() work? ====
# We see an example using a simple dataset
df <- tribble(
    ~id, ~measurement, ~value,
    "A",        "bp1",    100,
    "B",        "bp1",    140,
    "B",        "bp2",    115,
    "A",        "bp2",    120,
    "A",        "bp3",    105
)
print(df)
# From long to wide
df |>
    pivot_wider(
        id_cols = id,
        names_from = measurement,
        values_from = value
    )

# Long to wide process
# We check the unique col names
df |> 
    distinct(measurement) |> 
    pull()
# NOTE: By default, the rows in the output are determined by all the vars.
# - that aren’t going into the new names or values. 
# These are called the id_cols.
df |> 
    select(-c("measurement", "value")) |> 
    distinct()
# pivot_wider() then combines these results to generate an empty data frame
df |> 
    select(-c("measurement", "value")) |> 
    distinct() |> 
    mutate(x = NA, y = NA, z = NA)


# There may be multiple rows in the input that correspond to 
# - one cell in the output. 
# The example below has two rows that correspond to 
# - id “A” and measurement “bp1”.
df <- tribble(
    ~id, ~measurement, ~value,
    "A",        "bp1",    100,
    "A",        "bp1",    102,
    "A",        "bp2",    120,
    "B",        "bp1",    140,
    "B",        "bp2",    115
)
print(df)
# Attempting to pivot this col gives an output with list-columns (see ch23)
df |> 
    pivot_wider(
        id_cols = id,
        names_from = measurement,
        values_from = value
    )
# Code to id duplicates in data
df |> 
    group_by(id, measurement) |> 
    summarize(n = n(), .groups = "drop") |> 
    filter(n > 1)


# 5.5 Summary --------------------------------------------------------------
# See the following vignette to learn more about data pivoting
vignette("pivot", package = "tidyr")




#_====
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# C6 - Workflow: Scripts and Projects -------------------------------------
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# We learn about two essential tools for organizing code: scripts and projects.
# NO CODE




#_====
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# C7 - Data import --------------------------------------------------------
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# We learn the basics of reading data files into R

# 7.1 Prerequisites --------------------------------------------------------
# We learn to load flat files in R with the "readr" package.
# It is part of the core tidyverse.
library(tidyverse)


# 7.2 Reading data from a file ---------------------------------------------
# We read the students.csv file from website
students <- read_csv("https://pos.it/r4ds-students-csv")
glimpse(students)

# 7.2.1 Practical advice ====
# After reading data in, the first step usually involves transforming it in
# - some way to make it easier to work with in the rest of your analysis.
print(students)

# Reading custom missing values
students <- read_csv(
    file = "https://pos.it/r4ds-students-csv", 
    na = c("N/A", "")
)
print(students)

# Need to rename syntactic variable names (surrounded by ``)
students |> 
    rename(
        student_id = `Student ID`,
        full_name = `Full Name`
    )

# Altly, we can use clean_names() to transform all var names
students |> 
    clean_names()

# Transforming categorical vars to factor
students |> 
    clean_names() |> 
    mutate(
        meal_plan = factor(meal_plan)
    )

# Fixing age col by making it numeric
students <- students |> 
    clean_names() |> 
    mutate(
        meal_plan = factor(meal_plan),
        age = parse_number(
            ifelse(test = age == "five", "5", age)
        )
    )
print(students)


# 7.2.2 Other arguments ====
# Reading text strings that are created and formatted like a CSV file
read_csv(
    "a, b, c
    1, 2, 3
    4, 5, 6"
)

# Dropping metadata lines while importing
read_csv(
    "The first line of metadata
    The second line of metadata
    x, y, z
    1, 2, 3
    4, 5, 6",
    skip = 2
)

# Dropping metadata lines starting with "#"
read_csv(
    "# A comment I want to skip
    x, y, z
    1, 2, 3
    4, 5, 6",
    comment = "#"
)

# Data without col names
read_csv(
    "1, 2, 3
    4, 5, 6",
    col_names = FALSE
)

# Data without col names and giving custom col names
read_csv(
    "1, 2, 3
    4, 5, 6",
    col_names = c("x", "y", "z")
)


# 7.3 Controlling column types ---------------------------------------------
# A CSV file doesn’t contain any information about the type of each var 
# i.e. whether it’s a logical, number, string, etc.
# read_csv() guesses the var type using heuristic.
# This section describes how this guessing heuristic works, 
# - how to resolve some common problems that cause it to fail, and,
# - how to supply the column types yourself.

# 7.3.1 Guessing types ====
# Seeing the behaviour of readr fns
read_csv(
    "logical,numeric,date,string
    TRUE,1,2021-01-15,abc
    false,4.5,2021-02-15,def
    T,Inf,2021-02-16,ghi"
)
# NOTE: This heuristic works well if we have a clean dataset, 
# but in real life, we will encounter a selection of weird, beautiful failures.

# 7.3.2 Missing values, column types and problems ====
# One common cause var type misspecification is
# - vars are recorded using something other than the NA that readr expects.
simple_csv <- "
x
10
.
20
30"

read_csv(file = simple_csv)
# Here, col x gets imported as a char, but it should be numeric

# SOL: specify the missing val in na argument
read_csv(file = simple_csv, na = ".")

# 7.3.3 Column types ====
# Overriding the default column
another_csv <- "
x,y,z
1,2,3"
# All cols read as char
read_csv(
    file = another_csv,
    col_types = cols(.default = col_character())
)

# Only specific cols read as char
read_csv(
    file = another_csv,
    col_types = cols_only(x = col_character())
)


# 7.4 Reading data from multiple files -------------------------------------
# Sometimes data is split across multiple files.
# For example, you might have sales data for multiple months, 
# - with each month’s data in a separate file.
# Using read_csv() we can read these data in at once and 
# - stack them on top of each other in a single data frame.

# Reading files from website
sales_files <- c(
    "https://pos.it/r4ds-01-sales",
    "https://pos.it/r4ds-02-sales",
    "https://pos.it/r4ds-03-sales"
)
mult_files <- read_csv(file = sales_files, id = "file")
View(mult_files)


# 7.5 Writing to a file ----------------------------------------------------
print(students)
write_csv(x = students, file = "students-2.csv")
read_csv(file = "students-2.csv")
# NOTE: The variable type info is lost when files are saved as CSV 
# - Its because you’re starting over with reading from a plain text file again.

# SOL 1: Save as rds file
write_rds(x = students, file = "students-2.rds")
read_rds(file = "students-2.rds")

# SOL 2: Save as parquet file
# The arrow package allows you to read and write parquet files.
# It is a fast binary file format that can be shared
# - across programming languages.
library(arrow)
write_parquet(x = students, "students-2.parquet")
read_parquet(file = "students-2.parquet")


# 7.6 Data entry -----------------------------------------------------------
# Sometimes you’ll need to assemble a tibble “by hand” 
# - and doing a little data entry in your R script. 
# There are two useful functions to help you do this.

# tibble() works by column input layout
tibble(
    x = c(1, 2, 5),
    y = c("h", "m", "g"),
    z = c(0.08, 0.83, 0.60)
)

# tribble() works by laying out data row by row
tribble(
    ~x, ~y, ~z,
    1, "h", 0.08,
    2, "m", 0.93,
    5, "g", 0.60
)


#_====
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# C8 - Workflow: Getting help ---------------------------------------------
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# NO CODE.







