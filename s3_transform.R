# Code from book R for Data Science (2nd Edition) by Hadley Wickham and co.
# Here we have script files for each book section.
# Then, in each script file we have code sections for each chapter.
# This script contains code from the "Transform" section of the book.
# Here we deep dive into the variable types seen in a dataframe. 
# We will learn the tools to work with them.
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
easypackages::libraries(
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
# C12 - Logical vectors ---------------------------------------------------
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Here you’ll learn tools for working with logical vectors.
# First, we see the common way of creating logical vectors: numeric comparisons.
# Then we learn to use Boolean algebra to combine different logical vectors,
# - as well as some useful summaries. 
# We’ll finish off with if_else() and case_when().
# They are useful fns for making conditional changes using logical vectors.


# 12.1 Prerequisites ------------------------------------------------------
# Packages required
library(tidyverse)
library(nycflights13)

# Making up some dummy data for fun
# Vectors
x <- c(1, 2, 3, 5, 7, 11, 13)
x * 2
# Dataframe
df <- tibble(x)
df |> 
    mutate(y = x * 2)


# 12.2 Comparisons --------------------------------------------------------
# Creating transient logical vars with filter() which are 
# - computed, used and deleted.

# CASE: Finding all daytime departures that arrive roughly on time
flights |> 
    filter(dep_time > 600 & dep_time < 2000 & abs(arr_delay) < 20)
# Creating the underlying logical variables from filter() with mutate()
flights |> 
    mutate(
        daytime = dep_time > 600 & dep_time < 2000,
        approx_ontime = abs(arr_delay < 20),
        .keep = "used"
    )
# Altly, the initial filter cmd is written
flights |> 
    mutate(
        daytime = dep_time > 600 & dep_time < 2000,
        approx_ontime = abs(arr_delay < 20),
        .keep = "used"
    ) |> 
    filter(daytime & approx_ontime)


# 12.2.1 Floating point comparison ====
x <- c(1 / 49 * 49, sqrt(2) ^ 2)
print(x)    
# [1] 1 2

# Testing for equality
x == c(1, 2)
# [1] FALSE FALSE
# This is surprising

# This happens because x has decimal places and are not integers
print(x, digits = 16)

# SOL: To check == which ignores small diffs dplyr::near() can be used
near(x, c(1, 2))


# 12.2.2 Missing values ====
# Missing values shown using NA's denote something unknown.
# Thus any operation with NA will be an unknown, i.e., NA.
NA > 5
10 == NA
NA == NA

age_mary <- NA
age_john <- NA
age_mary == age_john

# Flight with missing departure time
flights |> 
    filter(dep_time == NA)


# 12.2.3 is.na() ====
# To do operations with NA we use is.na()
is.na(c(TRUE, NA, FALSE))
is.na(c(1, NA, 3))
is.na(c("a", NA, "b"))
# We can use is.na() to find Flights with missing departure time
flights |> 
    filter(is.na(dep_time))

# Using is.na() to sort missing values in arrange()
# arrange() usually puts missing values at the end
flights |> 
    filter(month == 1, day == 1) |> 
    arrange(dep_time)
# Now we put missing values at the top
flights |> 
    filter(month == 1, day == 1) |> 
    arrange(desc(is.na(dep_time)), dep_time)


# 12.3 Boolean algebra ----------------------------------------------------
# Let's see.

# 12.3.1 Missing values ====
df <- tibble(x = c(TRUE, FALSE, NA))
df |> 
    mutate(
        and = x & NA,
        or = x | NA
    )

# 12.3.2 Order of operations ====
# Note that the order of operations in R code doesn’t work like English 
# CASE: Finding flights that departed in November or December
# Writing as per sentence meaning but is wrong
flights |> 
    filter(month == 11 | 12)
# Writing in correct way
flights |> 
    filter(month == 11 | month == 12)

# Checking what happens behind the wrong code
flights |> 
    mutate(
        nov = month == 11,
        final = nov | 12,
        .keep = "used"
    )

# 12.3.3 %in% ====
# x %in% y returns a logical vector the same length as x 
# - that is TRUE whenever a value in x is anywhere in y.
1:12 %in% c(1, 5, 11)

# Altly, to find all flights in Nov and Dec
flights |> 
    filter(
        month %in% c(11, 12)
    )

# NOTE: %in% obeys different rules for NA to ==, as NA %in% NA is TRUE.
c(1, 2, NA) == NA
c(1, 2, NA) %in% NA

# Finding flights with dep_time at 8 AM or missing
flights |> 
    filter(dep_time %in% c(NA, 0800))


# 12.4 Summaries ----------------------------------------------------------
# Here we learn useful techniques for summarizing logical vectors.

# 12.4.1 Logical summaries ====
# There are two main logical summaries: any() and all(). 
# any(x) is the equivalent of |; it’ll return TRUE if there are any TRUE in x. 
# all(x) is equivalent of &, it’ll return TRUE if all values of x are TRUE.

# CASE: Find out if every flight was delayed on departure by at most an hour or 
# - if any flights were delayed on arrival by five hours or more. 
flights |> 
    group_by(year, month, day) |> 
    summarize(
        all_delayed = all(dep_delay < 60, na.rm = T),
        any_long_delay = any(arr_delay >= 300, na.rm = T),
        .groups = "drop"
    )

# 12.4.2 Numeric summaries of logical vectors ====
# When logical vector are used in numeric context, TRUE becomes 1 and FALSE 0.

# CASE: The propn of flights that were delayed on departure by at most an hour 
# - and the num of flights that were delayed on arrival by five hours or more.
flights |> 
    group_by(year, month, day) |> 
    summarize(
        proportion_delayed = mean(dep_delay <= 60, na.rm = T),
        count_long_delay = sum(arr_delay >= 300, na.rm = T),
        .groups = "drop"
    )

# 12.4.3 Logical subsetting ====
# CASE: The average delay just for flights that were actually delayed
flights |> 
    filter(arr_delay > 0) |> 
    group_by(year, month, day) |> 
    summarize(
        behind = mean(arr_delay, na.rm = T),
        n = n(),
        .groups = "drop"
    )

# CASE: The avg delay for flights that were delayed and also arrived early.
flights |> 
    group_by(year, month, day) |> 
    summarize(
        behind = mean(arr_delay[arr_delay > 0], na.rm = T),
        ahead = mean(arr_delay[arr_delay < 0], na.rm = T),
        n = n(),
        .groups = "drop"
    )


# 12.5 Conditional transformations ----------------------------------------
# One of the most powerful features of logical vectors are their use 
# - for conditional transformations, i.e. 
# - doing one thing for condition x, and something different for condition y.
# There are two important tools for this: if_else() and case_when().

# 12.5.1 if_else() ====
# Labelling a numeric vector as either “+ve” (positive) or “-ve” (negative)
x <- c(-3:3, NA)
if_else(condition = x > 0, true = "+ve", false = "-ve")
# Customizing missing value output
if_else(
    condition = x > 0,
    true = "+ve",
    false = "-ve",
    missing = "???"
)

# Create a minimal implementation of abs() fn
if_else(
    condition = x < 0,
    true = -x,
    false = x
)

# Create a simple version of coalesce() fn
x1 <- c(NA, 1, 2, NA)
y1 <- c(3, NA, 4, 6)
if_else(
    condition = is.na(x1),
    true = y1,
    false = x1
)

# In the labelling example zero is neither positive nor negative.
# We correct this using nested if_else() 
if_else(
    x == 0,
    true = "0",
    false = if_else(
        x < 0,
        true = "-ve",
        false = "+ve"
    ),
    missing = "???"
)

# 12.5.2 case_when() ====
# It performs different computations for different conditions.
# dplyr’s case_when() is inspired by SQL’s CASE statement.

# Recreate our previous nested if_else()
x <- c(-3:3, NA)
case_when(
    x == 0      ~ "0",
    x < 0       ~ "-ve",
    x > 0       ~ "+ve",
    is.na(x)    ~ "???"
)

# If none of the conditions match, the output gets an NA.
case_when(
    x < 0   ~ "-ve",
    x > 0   ~ "+ve"
)

# Using ".default" arg to create a “default”/catch all value
case_when(
    x < 0   ~ "-ve",
    x > 0   ~ "+ve",
    .default = "???"
)

# NOTE: If multiple conditions match, only the first will be used
case_when(
    x > 0   ~ "+ve",
    x > 2   ~ "big"
)

# Using case_when() to provide some human readable labels for the arrival delay
flights |> 
    mutate(
        status = case_when(
            is.na(arr_delay)        ~ "cancelled",
            arr_delay < -30         ~ "very early",
            arr_delay < -15         ~ "early",
            abs(arr_delay) <= 15    ~ "on time",
            arr_delay < 60          ~ "late",
            arr_delay < Inf         ~ "very late"
        ),
        .keep = "used"
    )

# 12.5.3 Compatible types ====
# NOTE: both if_else() and case_when() require compatible types in the output. 
# If they’re not compatible, you’ll see errors like this:
if_else(
    condition = TRUE,
    true = "a", false = 1 
)
case_when(
    x < -1  ~ TRUE,
    x > 0   ~ now()
)

# Overall, relatively few types are compatible. 
# Here are the most important cases that are compatible:
# Numeric and logical vectors are compatible.
# Strings and factors are compatible, because 
# - a factor is a string with a restricted set of values.
# Dates and date-times, are compatible because 
# - date is a special case of date-time.
# NA, which is technically a logical vector, is compatible with everything 
# - because every vector has some way of representing a missing value.


# 12.6 Summary ------------------------------------------------------------
# NO CODE.


#_====
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# C13 - Numbers -----------------------------------------------------------
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# We have used already numeric vector multiple times in this book.
# Here we systematically learn about them so that we can
# - tackle any future problem involving numeric vectors.

# We’ll start by giving you tools to make numbers if you have strings 
# - and then going into a little more detail of count(). 
# Then we’ll dive into various numeric transformations that pair with mutate(), 
# - including more general transformations that are applied to other 
# - vector types, but are often used with numeric vectors. 
# We’ll finish off by covering the summary functions that pair with summarize()
# - and show you how they can also be used with mutate().


# 13.1 Prerequisites ------------------------------------------------------
library(tidyverse)
library(nycflights13)


# 13.2 Making numbers -----------------------------------------------------
# Normally, you’ll get numbers already recorded in R’s numeric types: 
# integer or double. 
# In some cases, however, you’ll encounter them as strings.
# "readr" provides two useful functions for parsing strings into numbers:
# parse_double() and parse_number(). 

# Use parse_double() when there are numbers written as strings.
x <- c("1.2", "5.6", "1e3")
parse_double(x)

# Use parse_number() when the string has non-numeric text we want to ignore. 
x <- c("$1,234", "USD 3,513", "59%")
parse_number(x)


# 13.3 Counts -------------------------------------------------------------
# dplyr strives to make counting as easy as possible with count().
flights |> count(dest)
# To see the most common values, add sort = TRUE
flights |> count(dest, sort = TRUE)
# To see all the values, you can use |> View() or |> print(n = Inf).
flights |> count(dest, sort = TRUE) |> View()
flights |> count(dest, sort = TRUE) |> print(n = Inf)

# Altly, doing “by hand” with group_by(), summarize() and n(). 
# This also allows you to compute other summaries at the same time.
flights |> 
    group_by(dest) |> 
    summarize(
        n = n(),
        delay = mean(arr_delay, na.rm = TRUE)
    )
# NOTE: n() is a special summary function that doesn’t take any arguments and
# - instead accesses information about the “current” group. 
# This means that it only works inside dplyr verbs.

# There are other variants of the n() and count() fns.
# n_distinct(x) counts the num of distinct (unique) values of one/more vars. 
# Example, we see which destinations are served by the most carriers.
flights |> 
    group_by(dest) |> 
    summarize(
        carriers = n_distinct(carrier)
    ) |> 
    arrange(desc(carriers))
# sum() gives weighted count.
# Example, “count” the number of miles each plane flew.
flights |> 
    group_by(tailnum) |> 
    summarize(
        miles = sum(distance)
    ) |> 
    arrange(desc(miles))
# Altly, weighted count using count() fn
flights |> 
    count(tailnum, wt = distance)
# We can count missing values by combining sum() and is.na(). 
# In the flights dataset this represents flights that are cancelled.
flights |> 
    group_by(dest) |> 
    summarize(
        n_cancelled = sum(is.na(dep_time))
    )


# 13.4 Numeric transformations --------------------------------------------
# Transformation functions work well with mutate() 
# - because their output is the same length as the input. 
# The vast majority of transformation functions are already built into base R. 
# In this section will show the most useful ones. 
# Example, while R provides all the trigonometric functions
# - we don’t list them here because they’re rarely needed for data science.

# 13.4.1 Arithmetic and recycling rules ====
# R handles mismatched lengths by recycling, or repeating, the short vector.
# Simple example
x <- c(1, 2, 10, 20)
x / 5
# is shorthand for
x / c(5, 5, 5, 5)

# R will recycle any shorter length vector. 
# It usually (but not always) gives you a warning if the 
# - longer vector isn’t a multiple of the shorter.
x * c(1, 2)
x * C(1, 2, 3)

# These recycling rules also apply to logical comparisons (==, <, <=, >, >=, !=) 
# - and can lead to a surprising result if you accidentally 
# - use == instead of %in% and the data frame has an unfortunate number of rows.
# Example, if you use this code to find all flights in January and February
# Because of the recycling rules it actually finds
# - flights in odd numbered rows that departed in January and 
# - flights in even numbered rows that departed in February.
flights |> 
    filter(
        month == c(1, 2)
    )

# 13.4.2 Minimum and maximum ====
# The arithmetic functions also work with pairs of vars. 
# Two fns are pmin() and pmax(), which when given two or more vars
# - will return the smallest or largest value in each row.
df <- tribble(
    ~x, ~y,
    1,  3,
    5,  2,
    7,  NA
)
print(df)
df |> 
    mutate(
        min = pmin(x, y, na.rm = T),
        max = pmax(x, y, na.rm = T)
    )

# NOTE: These are different from min() and max() which take 
# - multiple observations and return a single value.
df |> 
    mutate(
        min = min(x, y, na.rm = T),
        max = max(x, y, na.rm = T)
    )

# 13.4.3 Modular arithmetic ====
# Modular arithmetic is the math done before invention of decimal places
# - i.e., division that yields a whole number and a remainder.
# In R, %/% does integer division and %% computes the remainder.
x <- 1:10
x %/% 3
x %% 3

# CASE: Unpack the sched_dep_time variable into hour and minute.
flights |> 
    mutate(
        hour = sched_dep_time %/% 100,
        minute = sched_dep_time %% 100,
        .keep = "used"
    )

# CASE: Checking how the propn of cancelled flights varies over the day.
flights |> 
    group_by(
        hour = sched_dep_time %/% 100
    ) |> 
    summarize(
        prop_cancelled = mean(is.na(dep_time)),
        n = n()
    ) |> 
    filter(hour > 1) |> 
    ggplot(aes(x = hour, y = prop_cancelled)) +
    geom_line(color = "grey50") +
    geom_point(aes(size = n))

# 13.4.4 Logarithms ====
# Logarithms are useful transformation for data ranging across 
# - multiple orders of magnitude and converting exponential to linear growth. 
# In R, you have a choice of three logarithms 
# - log() (the natural log, base e), log2() (base 2), and log10() (base 10).
# NO CODE

# 13.4.5 Rounding ====
# Use round(x) to round a number to the nearest integer.
round(123.456)
# Controlling the precision of the rounding with the "digits" argument.
round(123.456, digits = 2)
round(123.456, digits = 1)
round(123.456, digits = -1)     # round to nearest 10
round(123.456, digits = -2)     # roudn to nearest 100

# NOTE: round() uses banker's rounding
# If a number is half way bw two integers, it gets rounded to the even integer.
round(c(0.5, 1.5, 2.5))
 
# Also, there is floor() which always rounds down 
# - and ceiling() which always rounds up.
x <- 123.456
floor(x)
ceiling(x)
# NOTE: These two functions don’t have a digits argument.
# Round down to nearest two digits
floor(x * 100) / 100
# Round up to nearest two digits
ceiling(x * 100) / 100

# Using the same technique in round() 
# Round to nearest multiple of 4
round(x / 4) * 4
# Round to nearest 0.25
round(x / 0.25) * 0.25

# 13.4.6 Cutting numbers into ranges ====
# Use cut() to break up (aka bin) a numeric vector into discrete buckets.
x <- c(1, 2, 5, 10, 15, 20)
cut(x, breaks = c(0, 5, 10, 15, 20))
# Breaks can also be unevenly spaced.
cut(x, breaks = c(0, 5, 10, 100))

# Supplying your own labels. 
# NOTE: There should be one less labels than breaks.
cut(
    x,
    breaks = c(0, 5, 10, 15, 20),
    labels = c("s", "m", "l", "xl")
)

# Any values outside of the range of the breaks becomes NA.
y <- c(NA, -10, 5, 10, 30)
cut(y, breaks = c(0, 5, 10, 15, 20))

# 13.4.7 Cumulative and rolling aggregates ====
# Base R provides cumsum(), cumprod(), cummin(), cummax() for 
# - running, or cumulative, sums, products, mins and maxes. 
# dplyr provides cummean() for cumulative means.
x <- 1:10
cumsum(x)
# NOTE: For more complex rolling or sliding aggregates, try the "slider" pkg.


# 13.5 General transformations --------------------------------------------
# Let's start.

# 13.5.1 Ranks ====
# Use min_rank() where smallest values get lowest rank.
# also it handles ties.
x <- c(1, 2, 2, 3, 4, NA)
min_rank(x)

# check - are ranks output as vars
y <- min_rank(x)
print(y)
# yes, they do.

# Give largest values the lowest ranks
min_rank(desc(x))

# Looking at the other variants: 
# row_number(), dense_rank(), percent_rank(), and cume_dist(). 
# See the documentation for details.
df <- tibble(x = x)
df |> 
    mutate(
        row_number = row_number(x),
        dense_rank = dense_rank(x),
        percent_rank = percent_rank(x),
        cume_dist = cume_dist(x)
    )

# Dividing data into similarly sized groups
df <- tibble(id = 1:10)
df |> 
    mutate(
        row0 = row_number() - 1,
        three_groups = row0 %% 3,
        three_in_each_group = row0 %/% 3
    )

# 13.5.2 Offsets ====
# lead() and lag() allow you to refer the values just before or 
# - just after the “current” value. 
# They return a vector of the same length as the input, padded 
# - with NAs at the start or end.
x <- c(2, 5, 11, 11, 19, 35)
lag(x)
lead(x)
# The difference between the current and previous value.
x - lag(x)
# Telling when the current value changes.
df <- tibble(
    x,
    lag = lag(x),
    change = x == lag(x)
)
print(df)

# 13.5.3 Consecutive identifiers ====
# In a website data we want to break up events into sessions.
# Where we begin a new session after gap of minutes since the last activity.
# Data of times when someone visited a website.
events <- tibble(
    time = c(0, 1, 2, 3, 5, 10, 12, 15, 17, 19, 20, 27, 28, 30)
)
# Computing the time between each event, and see if there's actually a big gap.
events <- events |> 
    mutate(
        diff = time - lag(time, default = first(time)),
        has_gap = diff > 5
    )
print(events)
# Including a group variable using cumsum()
events |> 
    mutate(
        group = cumsum(has_gap)
    )

# Another approach for creating grouping variables is consecutive_id()
# - which starts a new group every time one of its arguments changes.
df <- tibble(
    x = c("a", "a", "a", "b", "c", "c", "d", "e", "a", "a", "b", "b"),
    y = c(1, 2, 3, 2, 4, 1, 3, 9, 4, 8, 10, 199)
)
# Keeping the first row from each repeated x.
df |> 
    group_by(
        id = consecutive_id(x)
    ) |> 
    slice_head(n = 1)


# 13.6 Numeric summaries --------------------------------------------------
# Let's start this section.

# 13.6.1 Center ====
# Comparing the mean vs median departure delay (in mins) for each destination.
flights_mod <- flights |> 
    group_by(year, month, day) |> 
    summarize(
        mean = mean(dep_delay, na.rm = T),
        median = median(dep_delay, na.rm = T),
        n = n(),
        .groups = "drop"
    )
        
flights_mod |> 
    ggplot(aes(x = mean, y = median)) +
    geom_abline(
        slope = 1,
        intercept = 0,
        color = "white",
        linewidth = 2
    ) +
    geom_point()

# 13.6.2 Minimum, maximum and quantiles ====
# In flights data look at the 95% quantile of delays rather than the maximum
flights |> 
    group_by(year, month, day) |> 
    summarize(
        max = max(dep_delay, na.rm = T),
        q95 = quantile(dep_delay, probs = 0.95, na.rm = T),
        .groups = "drop"
    )

# 13.6.3 Spread ====
# In flights data, check the spread of distance between origin and destination 
flights |> 
    group_by(origin, dest) |> 
    summarize(
        distance_iqr = IQR(distance),
        n = n(),
        .groups = "drop"
    ) |> 
    filter(distance_iqr > 0)

# 13.6.4 Distributions ====
# NOTE: The summary statistics described above are a way of reducing the 
# - distribution down to a single number.
# This means that they’re fundamentally reductive, and if you pick the wrong
# - summary, you can easily miss important differences between groups. 
# That’s why it’s always a good idea to visualize the distribution before 
# - committing to your summary statistics.

# We check that distributions for subgroups resemble the whole. 
# In the following plot 365 frequency polygons of dep_delay, one for each day.
flights |> 
    filter(dep_delay < 120) |> 
    ggplot(aes(
        x = dep_delay, 
        group = interaction(day, month)
    )) +
    geom_freqpoly(binwidth = 5, alpha = 1/5)
# The distributions seem to follow a common pattern, suggesting 
#  - it’s fine to use the same summary for each day.

# 13.6.5 Positions ====
# Find the first, fifth and last departure for each day.
flights |> 
    group_by(year, month, day) |> 
    summarize(
        first_dep = first(dep_time, na_rm = T),
        fifth_dep = nth(dep_time, n = 5, na_rm = T),
        last = last(dep_time, na_rm = T)
    )

# Extracting values at positions is complementary to filtering on ranks. 
# Filtering gives you all variables, with each observation in a separate row.
flights |> 
    group_by(year, month, day) |> 
    mutate(
        r = min_rank(sched_dep_time)
    ) |> 
    filter(r %in% c(1, max(r))) |> View()

# 13.6.6 With mutate() ====
# NO CODE.


# 13.7 Summary ------------------------------------------------------------
# NO CODE.




#_====
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# C14 - Strings -----------------------------------------------------------
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# So far, we have used strings without learning much about the details.
# Now it’s time to dive into them, learn what makes strings tick, 
# - and master some of the powerful string manipulation tools.


# 14.1 Prerequisites ------------------------------------------------------
library(tidyverse)
library(babynames)


# 14.2 Creating a string --------------------------------------------------
# Firstly, we can create a string using both single (') or double quotes ("). 
# There’s no behaviour difference between the two, but for consistency 
# - tidyverse style guide recommends using ", unless the string has multiple".
string1 <- "This is a string"
string2 <- 'If I want to include "quote" inside a string I use single quotes'
# NOTE: If you forget to close a quote, you’ll see +, the continuation prompt.
# If you can’t figure out which quote to close, press Esc to cancel the prompt.

# 14.2.1 Escapes ====
# To include a literal single, double quote or backslash in a string
# - you can use \ to “escape” it.
double_quote <- "\""
single_quote <- '\''
backslash <- "\\"
x <- c(single_quote, double_quote, backslash)
print(x)
# To see the raw contents of the string, use str_view().
str_view(x)

# 14.2.2 Raw strings ====
# Creating a string with multiple quotes or backslashes gets confusing quickly.
# See example, where we define the "double_quote" and "single_quote" vars.
tricky <- "double_quote <- \"\\\"\" # or '\"'
single_quote <- '\\'' # or \"'\""
print(tricky)
str_view(tricky)

# This is sometimes called leaning toothpick syndrome.
# To eliminate the escaping, you can instead use a raw string.
tricky <- r"(double_quote <- "\"" # or '"' 
single_quote <- '\'' # or "'" )"
print(tricky)
str_view(tricky)

# A raw string usually starts with r"( and finishes with )". 
# But if your string contains )" you can instead use r"[]" or r"{}".
# If that’s still not enough, you can insert any number of dashes to make the
# - opening and closing pairs unique, e.g., r"--()--", r"---()---", etc.
# Raw strings are flexible enough to handle any text.

# 14.2.3 Other special characters ====
# There are a handful of other special characters that may come in handy.
# The most common are \n, a new line, and \t, tab. 
# Sometimes we see strings containing Unicode escapes that start with \u or \U. 
# This is a way of writing non-English characters that work on all systems.
x <- c("one\ntwo", "one\ttwo", "\u00b5", "\U0001f604")
print(x)
str_view(x)
# You can see the complete list of other special characters in ?Quotes



# 14.3 Creating many strings from data ------------------------------------
# After the basics, now we’ll see the details of creating strings 
# - from other strings.

# 14.3.1 str_c() ====
# str_c() takes multiple vectors as arguments and returns a character vector.
str_c("x", "y")
str_c("x", "y", "z")
str_c("Hello ", c("John", "Susan"))

# str_c() is very similar to the base paste0(), but it obeys tidyverse rules.
# See example.
df <- tibble(name = c("Flora", "David", "Terra", NA))
print(df)
df |> mutate(
    greeting = str_c("Hi ", name, "!")
)

# To display missing values in another way, use coalesce() to replace them.
# Depending on use, you might use it either inside or outside of str_c()
df |> 
    mutate(
        greeting1 = str_c("Hi ", coalesce(name, "you"), "!"),
        greeting2 = coalesce(str_c("Hi ", name, "!"), "Hi!")
    )

# 14.3.2 str_glue() ====
# See in action
df |> mutate(
    greeting = str_glue("Hi {name}!")
)

# NOTE: To include a regular { or } in your string you need to escape it.
# Glue uses a different escaping technique: you double the special characters.
df |> 
    mutate(
        greeting = str_glue("{{Hi {name}!}}")
    )

# 14.3.3 str_flatten() ====
# It works with summarize() where output is not the same length as their inputs.
# It takes a char vector and combines each vector element into a single string.
str_flatten(c("x", "y", "z"))
str_flatten(c("x", "y", "z"), ", ")
str_flatten(
    c("x", "y", "z"), 
    collapse = ", ", 
    last = ", and "
)

# Using str_flatten() in a dataframe. It works well with summarize.
df <- tribble(
    ~name,          ~fruit,
    "Carmen",       "banana",
    "Carmen",       "apple",
    "Marvin",       "nectarine",
    "Terrence",     "cantaloupe",
    "Terrence",     "papaya",
    "Terrence",     "mandarin"
)
print(df)
df |> 
    group_by(name) |> 
    summarize(
        fruits = str_flatten(fruit, ", ")
    )


# 14.4 Extracting data from strings ---------------------------------------
# It’s very common for multiple vars to be crammed into a single string.
# Here, you’ll learn how to use four tidyr functions to extract them.

# 14.4.1 Separating into rows ====
# Using separate_longer_delim() to split based on a delimiter.
df1 <- tibble(x = c("a,b,c", "d,e", "f"))
df1
df1 |> 
    separate_longer_delim(x, delim = ",")

# # Using separate_longer_position() to split based on value position
df2 <- tibble(x = c("1211", "131", "21"))
df2
df2 |> 
    separate_longer_position(x, width = 1)

# 14.4.2 Separating into columns ====
# CASE: dataset x is made up of a code, edition number, and year, sep by "."
# We use separate_wider_delim() for separating the string into cols.
df3 <- tibble(x = c("a10.1.2022", "b10.2.2011", "e15.1.2015"))
df3
df3 |> 
    separate_wider_delim(
        x,
        delim = ".",
        names = c("code", "edition", "year")
    )

# If a specific var is not useful we use NA in varname to omit it.
df3 |> 
    separate_wider_delim(
        x,
        delim = ".",
        names = c("code", NA, "year")
    )

# In separate_wider_position() we specify the width of each column.
df4 <- tibble(x = c("202215TX", "202122LA", "202325CA"))
df4
df4 |> 
    separate_wider_position(
        x,
        widths = c(year = 4, age = 2, state = 2)
    )

# 14.4.3 Diagnosing widening problems ====
# CASE: What happens if some cols have too few cases.
df <- tibble(x = c("1-1-1", "1-1-2", "1-3", "1-3-2", "1"))
df
df |> 
    separate_wider_delim(
        x,
        delim = "-",
        names = c("x", "y", "z")
    )
# Based on error suggestion we try debugging the problem.
debug <- df |> 
    separate_wider_delim(
        x,
        delim = "-",
        names = c("x", "y", "z"),
        too_few = "debug"
    )
print(debug)
# Quickly seeing the inputs that failed.
debug |> 
    filter(x_ok == FALSE)
# SOL: Allotting NA to missing info after actual values.
df |> 
    separate_wider_delim(
    x,
    delim = "-",
    names = c("x", "y", "z"),
    too_few = "align_start"
)
# SOL: Allotting NA to missing info before actual values.
df |> 
    separate_wider_delim(
        x,
        delim = "-",
        names = c("x", "y", "z"),
        too_few = "align_end"
    )


# CASE: What happens if some cols have too many cases.
df <- tibble(x = c("1-1-1", "1-1-2", "1-3-5-6", "1-3-2", "1-3-5-7-9"))
df
df |> 
    separate_wider_delim(
        x,
        delim = "-",
        names = c("x", "y", "z")
    )
# Based on error suggestion we try debugging the problem.
debug <- df |> 
    separate_wider_delim(
        x,
        delim = "-",
        names = c("x", "y", "z"),
        too_many = "debug"
    )
print(debug)
# SOL: "drop" the additional values.
df |> 
    separate_wider_delim(
        x,
        delim = "-",
        names = c("x", "y", "z"),
        too_many = "drop"
    )
# SOL: "merge" the additional values.
df |> 
    separate_wider_delim(
        x,
        delim = "-",
        names = c("x", "y", "z"),
        too_many = "merge"
    )


# 14.5 Letters ------------------------------------------------------------
# Here we see fns that work with the individual letters within a string. 
# You’ll learn how to find the length of a string, extract substrings, 
# - and handle long strings in plots and tables.

# 14.5.1 Length ====
# str_length() tells you the number of letters in the string.
str_length(c("a", "R for data science", NA))

# CASE: Use with count() to find the distribution of lengths of US babynames.
head(babynames)
glimpse(babynames)
babynames |> 
    count(
        length = str_length(name),
        wt = n
    )

# CASE: Use filter() to look at the longest names, which has 15 letters.
babynames |> 
    filter(str_length(name) == 15) |> 
    count(
        name,
        wt = n,
        sort = TRUE
    )

# 14.5.2 Subsetting ====
# You can extract parts of a string using str_sub(string, start, end)
# - where start and end are the pos where the substring should start and end.
# The start and end arguments are inclusive, so 
# - the length of the returned string will be end - start + 1.
x <- c("Apple", "Banana", "Pear")
str_sub(x, 1, 3)

# You can use negative values to count back from the end of the string:
# -1 is the last character, -2 is the second to last character.
str_sub(x, -3, -1)

# NOTE: str_sub() won’t fail if the string is too short.
str_sub("a", 1, 5)

# CASE: Use str_sub() with mutate() to find the first and last letter of each name.
babynames |> 
    mutate(
        first = str_sub(name, 1, 1),
        last = str_sub(name, -1, -1)
    )


# 14.6 Non-English text ---------------------------------------------------
# So far, we’ve focused on English language text.
# This is particularly easy to work with for two reasons:
# - the English alphabet is relatively simple, there are just 26 letters.
# - the computing infrastructure we use today was designed by English speakers.

# Here we show you some of the biggest challenges you might encounter: 
# encoding, letter variations, and locale-dependent functions.

# 14.6.1 Encoding ====
# Checking the underlying representation of a string using charToRaw().
charToRaw("Hadley")
# Each six hexadecimal nums represents one letter: 48 is H, 61 is a, and so on.
# This mapping from hexadecimal number to character is called the encoding.
# In this case the encoding is called ASCII.

# Today, UTF-8 encoding is used almost everywhere, but not always. 
# Examples of unusual encodings.
x1 <- "text\nEl Ni\xf1o was particularly bad this year"
read_csv(x1)$text
x2 <- "text\n\x82\xb1\x82\xf1\x82\xc9\x82\xbf\x82\xcd"
read_csv(x2)$text
# To read these correctly, you specify the encoding via the locale argument.
read_csv(x1, locale = locale(encoding = "Latin1"))$text
read_csv(x2, locale = locale(encoding = "Shift-JIS"))$text
# NOTE: The above code does not work and gives error.

# 14.6.2 Letter variations ====
# Working in languages with accents poses a significant challenge when 
# - determining the pos of letters, as same chars may have different lengths.
# See below two ways of representing ü that look identical.
u <- c("\u00fc", "u\u0308")
str_view(u)
# But both strings differ in length, and their first characters are different.
str_length(u)
str_sub(u, 1, 1)
# Also they compare differently.
u[[1]] == u[[2]]
str_equal(u[[1]], u[[2]])

# 14.6.3 Locale-dependent functions ====
# There are few stringr functions whose behaviour depends on your locale. 
# A locale is similar to a language but includes an optional region specifier
# - to handle regional variations within a language.

# See which locales are supported in stringr
stringi::stri_locale_list()

# Base R string fns automatically use the locale set by your OS.
# This means that base R string fns do what you expect for your language, but
# - your code might work differently if you share it with someone who lives in
# - a different country. 
# To avoid this problem, stringr defaults to English rules by using the
# - “en” locale and requires you to specify the locale argument to override it.
# Fortunately, there are two sets of fns where the locale really matters:
# - changing case and sorting.

# CASE: Turkish has two i’s: with and without a dot. Since they’re two 
# - distinct letters, they’re capitalized differently.
str_to_upper(c("i", "ı"))
str_to_upper(c("i", "ı"), locale = "tr")
# CASE:  In Czech, “ch” is a compound letter that appears after h alphabet.
str_sort(c("a", "c", "ch", "h", "z"))
str_sort(c("a", "c", "ch", "h", "z"), locale = "cs")
# This also comes up when sorting strings with dplyr::arrange(), which is why
# - it also has a locale argument.


# 14.7 Summary ------------------------------------------------------------
# NO CODE.




#_====
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# C15 - Regular expressions -----------------------------------------------
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Here we learn functions that use regular expressions, a concise and 
# - powerful language for describing patterns within strings.


# 15.1 Prerequisites ------------------------------------------------------
library(tidyverse)
library(babynames)

# In here, we will use a mix of very simple inline examples so we can get the
# - basic idea, the babynames data, and 3 character vectors from stringr:
# 1. fruit: contains the names of 80 fruits.
# 2. words: contains 980 common English words.
# 3. sentences: contains 720 short sentences.
glimpse(babynames)
glimpse(fruit)
glimpse(words)
glimpse(sentences)


# 15.2 Pattern basics -----------------------------------------------------
# Here, we see how regex patterns work.
# The simplest patterns has letters and numbers that match those characters 
# exactly.
str_view(fruit, pattern = "berry")
# Letters and numbers match exactly and are called literal characters. Most 
# punctuation characters, like ., +, *, [, ], and ? have special meanings
# and are called metacharacters. 

# CASE: "." will match any character, so "a." will match any string that
# - contains an “a” followed by another character.
str_view(
    c("a", "ab", "ae", "bd", "ea", "eab"), 
    pattern = "a."
)

# CASE: We could find fruits that contain “a”, followed by 3 letters, 
# then an “e”.
str_view(fruit, pattern = "a...e")

# Quantifiers control how many times a pattern can match:
# 1. ? makes a pattern optional (i.e. it matches 0 or 1 times)
# 2. + lets a pattern repeat (i.e. it matches at least once)
# 3. * lets a pattern be optional or repeat (i.e. it matches any num of times)
# CASE: ab? matches an "a", optionally followed by a "b".
str_view(c("a", "ab", "abb"), "ab?")
# CASE: ab+ matches an "a", followed by at least one "b".
str_view(c("a", "ab", "abb"), "ab+")
# CASE: ab* matches an "a", followed by any number of "b"s.
str_view(c("a", "ab", "abb"), "ab*")

# Character classes are defined by [] and let you match a set of characters.
# Like, [abcd] matches “a”, “b”, “c”, or “d”. You can also invert the match 
# by starting with ^: [^abcd] matches anything except “a”, “b”, “c”, or “d”.
# CASE: Find the words containing an “x” surrounded by vowels.
str_view(words, "[aeiou]x[aeiou]")
# CASE: Find the words containing an “y” surrounded by consonants.
str_view(words, "[^aeiou]y[^aeiou]")

# You can use alternation, |, to pick between one or more alternative 
# patterns.
# CASE: Fruits containing “apple”, “melon”, or “nut”.
str_view(fruit, "apple|melon|nut")
# CASE: Fruits containing a repeated vowel.
str_view(fruit, "aa|ee|ii|oo|uu")
# Regular expressions are very compact and use a lot of punctuation characters,
# so they can seem overwhelming and hard to read at first. Don’t worry
# you’ll get better with practice, and simple patterns will soon become
# second nature.


# 15.3 Key functions ------------------------------------------------------
# Now that you’ve got the basics of regular expressions under your belt, let’s
# use them with some stringr and tidyr functions.


# 15.3.1 Detect matches ====
# str_detect() returns a logical vector that is TRUE if the pattern matches 
# an element of the character vector and FALSE otherwise
str_detect(c("a", "b", "c"), "[aeiou]")

# Since str_detect() returns a logical vector of the same length as the 
# initial vector, it pairs well with filter(). 
# For example, this code finds all the most popular names containing a 
# lower-case “x”:
babynames |> 
    filter(str_detect(name, "x")) |> 
    count(name, wt = n, sort = T)

# CASE: Compute and visualize the proportion of baby names that contain “x”
# broken down by year.
babynames |> 
    group_by(year) |> 
    summarize(prop_x = mean(str_detect(name, "x"))) |> 
    ggplot(aes(x = year, y = prop_x)) +
    geom_line()
# There are two functions that are closely related to str_detect(): 
# str_subset() and str_which(). 
# str_subset() returns a character vector containing only the strings that 
# match. str_which() returns an integer vector giving the positions of the 
# strings that match.


# 15.3.2 Count matches ====
# str_count() tells you how many matches there are in each string.
x <- c("apple", "banana", "pear")
str_count(x, "p")
# Note that each match starts at the end of the previous match, that is 
# regex matches never overlap. 
str_count("abababa", "aba")
str_view("abababa", "aba")

# It’s natural to use str_count() with mutate(). The following example uses 
# str_count() with character classes to count the number of vowels and 
# consonants in each name.
babynames |> 
    count(name) |> 
    mutate(
        vowels = str_count(name, "[aeiou]"),
        consonants = str_count(name, "[^aeiou]")
    )
# If you look closely, you’ll notice that there’s something off with our 
# calculations: “Aaban” contains three “a”s, but our summary reports only 
# two vowels. That’s because regular expressions are case sensitive. 
# There are three ways we could fix this in the book

# In this case, since we’re applying two functions to the name, I think 
# it’s easier to transform it first:
babynames |> 
    count(name) |> 
    mutate(
        name = str_to_lower(name),
        vowels = str_count(name, "[aeiou]"),
        consonants = str_count(name, "[^aeiou]")
    )


# 15.3.3 Replace values ====
# We can also modify strings with str_replace() and str_replace_all(). 
# str_replace() replaces the first match.
x <- c("apple", "pear", "banana")
str_replace(x, "[aeiou]", "-")
# str_replace_all() replaces all matches.
str_replace_all(x, "[aeiou]", "-")

# str_remove() and str_remove_all() are handy shortcuts for 
# str_replace(x, pattern, ""):
x <- c("apple", "pear", "banana")
str_remove(x, "[aeiou]")
str_remove_all(x, "[aeiou]")
# These functions are naturally paired with mutate() when doing data
# cleaning and you will often apply them repeatedly to peel off layers of 
# inconsistent formatting.


# 15.3.4 Extract variables ====
# Next we use regular expressions to extract data out of one column into 
# one or more new columns: separate_wider_regex(). It’s a peer of the 
# separate_wider_position() and separate_wider_delim() functions that you 
# learned.

# Let’s create a simple dataset to show how it works. Here we have some data 
# derived from babynames where we have the name, gender, and age of a bunch 
# of people in a rather weird format.
df <- tribble(
    ~str,
    "<Sheryl>-F_34",
    "<Kisha>-F_45", 
    "<Brandon>-N_33",
    "<Sharon>-F_38", 
    "<Penny>-F_58",
    "<Justin>-M_41", 
    "<Patricia>-F_84", 
)
df
# To extract this data we just need to construct a sequence of regular 
# expressions that match each piece. If we want the contents of that piece 
# to appear in the output, we give it a name.
df |> 
    separate_wider_regex(
        str,
        patterns = c(
            "<",
            name = "[A-Za-z]+",
            ">-",
            gender = ".",
            "_",
            age = "[0-9]+"
        )
    )


# 15.4 Pattern details ----------------------------------------------------
# Now that you understand the basics of the pattern language and how to use 
# it with some stringr and tidyr functions, it’s time to dig into more of 
# the details.


# 15.4.1 Escaping ====
# To create the regular expression \., we need to use \\.
dot <- "\\."
dot
# But the expression itself only contains one \
str_view(dot)
# And this tells R to look for an explicit "."
str_view(c("abc", "a.c", "bef"), "a\\.c")

# If \ is used as an escape character in regular expressions, how do you 
# match a literal \? 
# Well, you need to escape it, creating the regular expression \\. To create 
# that regular expression, you need to use a string, which also needs to 
# escape \. That means to match a literal \ you need to write "\\\\" — you 
# need four backslashes to match one.
x <- "a\\b"
x
str_view(x)
str_view(x, "\\\\")
# Altly, you might find it easier to use the raw strings, that lets you 
# avoid one layer of escaping.
str_view(x, r"{\\}")

# If you’re trying to match a literal ., $, |, *, +, ?, {, }, (, ), there’s 
# an alternative to using a backslash escape: you can use a character 
# class: [.], [$], [|], … all match the literal values.
str_view(c("abc", "a.c", "a*c", "a c"), "a[.]c")
str_view(c("abc", "a.c", "a*c", "a c"), ".[*]c")


# 15.4.2 Anchors ====
# By default, regular expressions will match any part of a string. If you 
# want to match at the start or end you need to anchor the regular expression 
# using ^ to match the start or $ to match the end.
# Fruit names that start with "a".
str_view(fruit, "^a")
# Fruit names that end with "a".
str_view(fruit, "a$")

# To force a regular expression to match only the full string, anchor it 
# with both ^ and $.
str_view(fruit, "apple")
str_view(fruit, "^apple$")

# You can also match the boundary between words (i.e. the start or end of 
# a word) with \b. This can be particularly useful when using RStudio’s 
# find and replace tool. 
# For example, if to find all uses of sum(), you can search for \bsum\b to 
# avoid matching summarize, summary, rowsum and so on.
x <- c("summary(x)", "summarize(df)", "rowsum(x)", "sum(x)")
x
str_view(x, "sum")
str_view(x, "\\bsum\\b")

# When used alone, anchors will produce a zero-width match
str_view("abc", c("$", "^", "\\b"))
# This helps you understand what happens when you replace a standalone anchor.
str_replace_all("abc", c("$", "^", "\b"), "--")


# 15.4.3 Character classes ====



# TBC ####




#_====
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# C16 - Factors -----------------------------------------------------------
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Factors are used for categorical variables. 
# Categorical variables have a fixed and known set of possible values. 
# They are also useful for displaying char vectors in a non-alphabetical order.


# 16.1 Prerequisites ------------------------------------------------------
# Packages required for this chapter.
library(tidyverse)


# 16.2 Factor basics ------------------------------------------------------
x1 <- c("Dec", "Apr", "Jan", "Mar")
# Using a string to record this var has two problems:
# There are 12 possible months and repeated entry might result in typos.
x2 <- c("Dec", "Apr", "Jam", "Mar")
# It doesn’t sort in a useful way, i.e., by alphabets.
sort(x1)

# You can fix both of these problems with a factor. 
# To create factor we start by creating the factor levels.
month_levels <- c("Jan", "Feb", "Mar", "Apr", "May", "Jun", 
                  "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")
# Now we create the factor.
y1 <- factor(x1, levels = month_levels)
print(y1)
sort(y1)
# Any values not in the level will be silently converted to NA.
y2 <- factor(x2, levels = month_levels)
print(y2)
# This seems risky.
# So we will use forcats::fct(), which will give warning
y2 <- fct(x2, levels = month_levels)

# If we don't give levels, it is taken from the data in alphabetical order.
factor(x1)
# NOTE: Sorting alphabetically is risky as each computer sorts strings differently.
# SOL: We use forcats::fct() which orders by first appearance.
fct(x1)
# Accessing the set of valid levels directly.
levels(y2)

# We can also create a factor when reading the data with readr.
csv <- "
month, value
Jan,12
Feb,56
Mar,12"
df <- read_csv(
    file = csv, 
    col_types = cols(month = col_factor(month_levels))
)
# ERROR
df$month


# 16.3 General Social Survey ----------------------------------------------
# For the rest of this chapter, we’re going to use gss_cat dataset.
# It’s a sample of data from the General Social Survey.
# GSS is a US survey conducted by the NORC at the University of Chicago.
?gss_cat
print(gss_cat)
glimpse(gss_cat)

# When factors are stored in a tibble, you can’t see their levels so easily. 
# One way to view them is with count().
gss_cat |> 
    count(race)


# 16.4 Modifying factor order ---------------------------------------------
# It’s useful to be able to change factor level order, like in a graph.
# CASE: explore the avg hours spent watching TV per day across religions.
relig_summary <- gss_cat |> 
    group_by(relig) |> 
    summarize(
        tvhours = mean(tvhours, na.rm = T),
        n = n()
    )
# Graph with unordered factors.
ggplot(
    data = relig_summary,
    aes(x = tvhours, y = relig)
) +
    geom_point()
# It is hard to read this plot because there’s no overall pattern. 
# We can improve it by reordering the factor levels.
# Graph with factors ordered by tvhours
ggplot(
    data = relig_summary, 
    aes(x = tvhours, y = fct_reorder(relig, tvhours))
) +
    geom_point()

# As we do complicated transformations, we recommend moving them out of aes() 
# - and into a separate mutate() step. 
# Altly, rewriting the above plot.
relig_summary |> 
    mutate(
        relig = fct_reorder(relig, tvhours)
    ) |> 
    ggplot(
        aes(x = tvhours, y = relig)
    ) +
    geom_point()

# CASE: Plot of how average age varies across reported income level.
# Data prep
rincome_summary <- gss_cat |> 
    group_by(rincome) |> 
    summarize(
        age = mean(age, na.rm = T),
        n = n()
    )
print(rincome_summary)
# Graph
ggplot(
    data = rincome_summary,
    aes(x = age, y = fct_reorder(rincome, age))
) +
    geom_point()
# Arbitrarily reordering the levels isn’t always a good idea.
# Here, rincome already has a order that we shouldn’t mess with.
# Reserve fct_reorder() for factors whose levels are arbitrarily ordered.

# Modified plot with “Not applicable” with the other special levels.
ggplot(
    data = rincome_summary,
    aes(x = age, y = fct_relevel(rincome, "Not applicable"))
) +
    geom_point()

# Using fct_reorder2()
# Data prep
by_age <- gss_cat |> 
    filter(!is.na(age)) |> 
    count(age, marital) |> 
    group_by(age) |> 
    mutate(
        prop = n / sum(n)
    )
print(by_age)
# Graph without reordering
ggplot(
    data = by_age,
    aes(x = age, y = prop, colour = marital)
) +
    geom_line(linewidth = 1.5) +
    scale_colour_brewer(palette = "Set1")
# Graph with reordering
ggplot(
    data = by_age,
    aes(
        x = age, 
        y = prop, 
        colour = fct_reorder2(marital, age, prop)
    )
) +
    geom_line(linewidth = 1.5) +
    scale_color_brewer(palette = "Set1") +
    labs(colour = "marital")

# Reordering bar plots
# Data prep
gss_cat |> 
    mutate(
        # fct_infreq orders by by num of obs with each level (largest first)
        # fct_rev reverses order of factor levels
        marital = marital |> fct_infreq() |> fct_rev()
    ) |> 
    ggplot(aes(x = marital)) +
    geom_bar()


# 16.5 Modifying factor levels --------------------------------------------
# More powerful than changing the orders of levels is changing level values.
# This allows you to clarify labels for publication, 
# - and collapse levels for high-level displays.
# Generally, we use fct_recode() which recodes/changes, the level values.
gss_cat |> count(partyid)
# Here, The levels are terse and inconsistent. 
# We tweak them to be longer and use a parallel construction.
gss_cat |> 
    mutate(
        partyid = fct_recode(
            partyid,
            "Republican, strong"    = "Strong republican",
            "Republican, weak"      = "Not str republican",
            "Independent, near rep" = "Ind,near rep",
            "Independent, near dem" = "Ind,near dem",
            "Democrat, weak"        = "Not str democrat",
            "Democrat, strong"      = "Strong democrat"
        )
    ) |> 
    count(partyid)
# NOTE: the new values go on the left and the old values go on the right.
# fct_recode() will leave the levels that aren’t explicitly mentioned as is.
# It will warn you if you accidentally refer to a level that doesn’t exist.

# To combine groups, we assign multiple old levels to the same new level.
gss_cat |> 
    mutate(
        partyid = fct_recode(
            partyid,
            "Republican, strong"    = "Strong republican",
            "Republican, weak"      = "Not str republican",
            "Independent, near rep" = "Ind,near rep",
            "Independent, near dem" = "Ind,near dem",
            "Democrat, weak"        = "Not str democrat",
            "Democrat, strong"      = "Strong democrat",
            "Other"                 = "No answer",
            "Other"                 = "Don't know",
            "Other"                 = "Other party"
        )
    ) |> 
    count(partyid)
# NOTE: If we group together cats that are truly different then
# - we will end up with misleading results.

# When we need to collapse many levels, fct_collapse() is useful.
gss_cat |> 
    mutate(
        partyid = fct_collapse(
            partyid,
            "other" = c("No answer", "Don't know", "Other party"),
            "republican" = c("Strong republican", "Not str republican"),
            "independent" = c("Ind,near rep", "Independent", "Ind,near dem"),
            "democrat" = c("Not str democrat", "Strong democrat")
        )
    ) |> 
    count(partyid)

# Sometimes we lump together small groups to make a plot or table simpler.
# That’s the job of the fct_lump_*() family of functions. 
# fct_lump_lowfreq() simply lumps the smallest group into “Other”
# - keeping "Other" as the smallest cat.
gss_cat |> count(relig)
# religion has many small cats that could be grouped.
gss_cat |> 
    mutate(
        relig = fct_lump_lowfreq(relig)
    ) |> 
    count(relig)
# Here the cats are lumped into 2 groups, which is not helpful.
# We’d like to see some more details, that is more cats.
# we can use the fct_lump_n() to specify that we want exactly 10 groups.
gss_cat |> 
    mutate(
        relig = fct_lump_n(relig, n = 10)
    ) |> 
    count(relig, sort = T)


# 16.6 Ordered factors ----------------------------------------------------
# Ordered factors, created with ordered(), has a strict ordering and 
# - equal distance between levels: the first level is “less than” the 
# - second level by the same amount that the second level is “less than” the
# - third level, and so on.
# We can recognize them when printing as they use < sign bwn the factor levels.
ordered(c("a", "b", "c"))
# SEE BOOK FOR MORE DETAILS.
# see vignette("contrasts", package = "faux") by Lisa DeBruine.


# 16.7 Summary ------------------------------------------------------------
# NO CODE.



#_====
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# C17 - Dates and times ---------------------------------------------------
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Here we learn how to work with dates and times in R.
# Dates and times are hard as they have to reconcile two physical phenomena,
# - the rotation of the Earth and its orbit around the Sun, 
# - with multiple geopolitical phenomena like months, time zones, and DST. 
# This chapter won’t teach you every last detail about dates and times,
# - but it will teach practical skills for handling common data analysis challenges.


# 17.1 Prerequisites ------------------------------------------------------
# Packages required for this chapter.
library(tidyverse)
library(nycflights13)


# 17.2 Creating date/times ------------------------------------------------
# There are three types of date/time data that refer to an instant in time:
# - date: Tibbles print this as <date>.
# - time: It is time within a day. Tibbles print this as <time>.
# - date-time: It is a date plus a time that uniquely identifies an instant
# -- in time (typically to the nearest second). Tibbles print this as <dttm>.
# -- Base R calls these POSIXct, but that doesn’t exactly trip off the tongue.

# Getting the current date.
today()
# Getting the current date-time.
now()
# Next we learn the four likely ways to create a date/time.

# 17.2.1 During import ====
# If your CSV contains an ISO8601 date or date-time, 
# you don’t need to do anything, readr will automatically recognize it.
csv <- "
date,datetime
2022-01-02,2022-01-02 05:12
"
read_csv(csv)

# Checking the options to import a very ambiguous date.
# The data
csv <- "
date
01/02/15
"
# import format 1
read_csv(
    file = csv, 
    col_types = cols(date = col_date("%m/%d/%y"))
)
# import format 2
read_csv(
    file = csv,
    col_types = cols(date = col_date("%d/%m/%y"))
)
# import format 3
read_csv(
    file = csv,
    col_types = cols(date = col_date("%y/%m/%d"))
)

# Check the list of built-in languages.
date_names_langs()

# 17.2.2 From strings ====
# Altly, we use lubridate’s helpers which attempt to automatically determine 
# - the format once you specify the order of the component. 
# To use them, identify the order in which year, month, and day appear in your
# - dates, then arrange “y”, “m”, and “d” in the same order. 
# That also gives you the lubridate fn name that will parse your date.
ymd("2017-01-31")
mdy("January 31st, 2017")
dmy("31st Jan, 2017")
# NOTE: ymd() and friends create dates.

# For creating date-time, add an underscore and one or more 
# - of “h”, “m”, and “s” to the name of the parsing fn.
ymd_hms("2017-01-31 20:11:59")
mdy_hm("01/31/2017 08:01")

# We can also force create a date-time from a date by supplying a timezone.
ymd("2017-01-31", tz = "UTC")

# 17.2.3 From individual components ====
# Sometimes we have each date-time component spread across multiple columns.
# Then we can aggregate each component to prepare our date-time var.
glimpse(flights)
flights |> 
    select(year, month, day, hour, minute)
# We use make_date() for dates, or make_datetime() for date-times.
flights |> 
    select(year, month, day, hour, minute) |> 
    mutate(
        departure = make_datetime(year, month, day, hour, minute)
    )

# Let’s do the same thing for each of the four time columns in flights. 
# The times are represented in a slightly odd format, so we use 
# - modulus arithmetic to pull out the hour and minute components.
# First, we create fn that extracts the hour and min components.
make_datetime_100 <- function(year, month, day, time) {
    make_datetime(year, month, day, time %/% 100, time %% 100)
}
# Then, we create the time vars in dataset.
flights_dt <- flights |> 
    filter(!is.na(dep_time), !is.na(arr_time)) |> 
    mutate(
        dep_time = make_datetime_100(year, month, day, dep_time),
        arr_time = make_datetime_100(year, month, day, arr_time),
        sched_dep_time = make_datetime_100(year, month, day, sched_dep_time),
        sched_arr_time = make_datetime_100(year, month, day, sched_arr_time)
    ) |> 
    select(origin, dest, ends_with("delay"), ends_with("time"))
# Now we explore the new dataset.
glimpse(flights_dt)

# CASE: visualize the departure times distributions across each day of 2013.
flights_dt |> 
    ggplot(aes(x = dep_time)) +
    # 86400 seconds = 1 day
    geom_freqpoly(binwidth = 86400)

# CASE: visualize the departure times distributions in a single day.
flights_dt |> 
    # selecting the day of 1st Jan, 2013
    filter(dep_time < ymd(20130102)) |> 
    ggplot(aes(x = dep_time)) +
    # 3600 seconds = 1 hr
    geom_freqpoly(binwidth = 3600)

# 17.2.4 From other types ====
# We can switch btwn a date-time and a date using as_datetime() and as_date().
today()
as_datetime(today())
now()
as_date(now())
as_datetime(60 * 60 * 10)
as_date(365 * 10 + 2)


# 17.3 Date-time components -----------------------------------------------
# After learning how to get date-time data into R, let’s learn 
# - what to do with them.

# 17.3.1 Getting components ====
# We can pull out each date component using accessor fns.
datetime <- ymd_hms("2026-07-08 12:34:56")
year(datetime)
month(datetime)
mday(datetime)

yday(datetime)
wday(datetime)

# For month() and wday() you can set label = TRUE to return the 
# abbreviated name of the month or day of the week.
# Set abbr = FALSE to return the full name.
month(datetime, label = T)
month(datetime, label = T, abbr = F)
wday(datetime, label = T)
wday(datetime, label = T, abbr = F)

# Creating the flights_dt dataset.
# First, we create fn that extracts the hour and min components.
# make_datetime_100 <- function(year, month, day, time) {
#     make_datetime(year, month, day, time %/% 100, time %% 100)
# }
# # Then, we create the time vars in dataset.
# flights_dt <- flights |> 
#     filter(!is.na(dep_time), !is.na(arr_time)) |> 
#     mutate(
#         dep_time = make_datetime_100(year, month, day, dep_time),
#         arr_time = make_datetime_100(year, month, day, arr_time),
#         sched_dep_time = make_datetime_100(year, month, day, sched_dep_time),
#         sched_arr_time = make_datetime_100(year, month, day, sched_arr_time)
#     ) #|> 
# select(origin, dest, ends_with("delay"), ends_with("time"))


# CASE: Check flight departures during the week and weekend.
flights_dt |> 
    mutate(wday = wday(dep_time, label = T)) |> 
    ggplot(aes(x = wday)) +
    geom_bar()

# CASE: Look at the average departure delay by minute within the hour.
# data prep
flights_gph <- flights_dt |> 
    mutate(minute = minute(dep_time)) |> 
    group_by(minute) |> 
    summarize(
        avg_delay = mean(dep_delay, na.rm = T),
        n = n()
    )
View(flights_gph)
# graph
flights_gph |> 
    ggplot(aes(x = minute, y = avg_delay)) +
    geom_line()

# CASE: Look at the scheduled departure time similarly.
# data
sched_dep <- flights_dt |> 
    mutate(minute = minute(sched_dep_time)) |> 
    group_by(minute) |> 
    summarize(
        avg_delay = mean(arr_delay, na.rm = T),
        n = n()
    )
# graph
sched_dep |> 
    ggplot(aes(x = minute, y = avg_delay)) +
    geom_line()


# 17.3.2 Rounding ====
flights_dt |> 
    count(week = floor_date(dep_time, unit = "week")) |> 
    ggplot(aes(x = week, y = n)) +
    geom_line() +
    geom_point()


# 17.4 Time spans ---------------------------------------------------------




# TBC ####



#_====
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# C18 - Missing values ----------------------------------------------------
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# We have already learned the basics of missing value in earlier chapters.
# Here, we will learn about missing values in more depth.


# 18.1 Prerequisites ------------------------------------------------------
# Packages required for this chapter.
library(tidyverse)


# 18.2 Explicit missing values --------------------------------------------
# Here, we explore a few handy tools for creating or eliminating 
# - missing explicit values, i.e. cells where you see an NA.

# 18.2.1 Last observation carried forward ====
# A common use for missing values is as a data entry convenience. When data 
# - is entered by hand, missing values sometimes indicate that the value in 
# - the previous row has been repeated (or carried forward).
treatment <- tribble(
    ~person,                ~treatment, ~response,
    "Derrick Whitmore",     1,          7,
    NA,                     2,          10,
    NA,                     3,          NA,
    "Katherine Burke",      1,          4
)
treatment
# Filling the missing values with last observed value.
treatment |> fill(everything())
# This process is called “last observation carried forward”, or locf in short.

# 18.2.2 Fixed values ====
# Sometimes missing values represent some fixed and known value, like 0.
# We can replace them.
x <- c(1, 4, 5, 7, NA)
x
coalesce(x, 0)
# Sometimes a concrete value actually represents a missing value like 99, -999.
x <- c(1, 4, 5, 7, -99)
x
na_if(x, -99)

# 18.2.3 NaN ====
# It is a special type of missing value that means "not a number".
x <- c(NA, NaN)
x
x * 10
x == 1
is.na(x)
is.nan(x)
# NaN results from a mathematical operation that has an indeterminate result.
0/0
0 * Inf
Inf - Inf
sqrt(-1)


# 18.3 Implicit missing values --------------------------------------------
# Here we learn about implicitly missing values, where an entire row of data
# - is simply absent from the data.
# Example - dataset with implicit missing values
stocks <- tibble(
    year    = c(2020, 2020, 2020, 2020, 2021, 2021, 2021),
    qtr     = c(1,    2,    3,    4,    2,    3,    4),
    price   = c(1.88, 0.59, 0.35, NA, 0.92, 0.17, 2.66)
)
stocks
# This dataset has two missing observations:
# - The price in the 2020, 4th quarter is explicitly missing.
# - The price in 2021, 1st quarter is implicitly missing, because 
# -- it simply does not appear in the dataset.

# Sometimes, we want to make implicit missing values explicit to have 
# - something physical to work with. Sometimes, we may want to remove explicit
# - missing values. The following sections discuss some tools for moving btw
# - implicit and explicit missingness.

# 18.3.1 Pivoting ====
# Pivoting can make implicit missings explicit and vice versa.
# Example - Pivot year col in stocks dataset.
stocks |> 
    pivot_wider(
        names_from = qtr,
        values_from = price
    )

# 18.3.2 Complete ====
# tidyr::complete() generates explicit missing values by using a set of vars
# - that define the combination of rows that should exist.
# Example - Generating all combination of year and qtr in stocks dataset.
stocks |> 
    complete(year, qtr)
# Sometimes the individual vars used in complete() are themselves incomplete 
# - and we can instead provide our own data.
# Example - Running year from 2019 to 2021 in stocks dataset.
stocks |> 
    complete(year = 2019:2021, qtr)

# If the var range is correct, but all values are not present, we could use
# - full_seq(x, 1) to generate values from min(x) to max(x) spaced out by 1.

# 18.3.3 Joins ====
# We can often only know that values are missing from one dataset when we
# - compare it to another using joins.
# Example - We can use two anti_join()s to reveal that we’re missing 
# - information for four airports and 722 planes mentioned in flights.
flights |> 
    distinct(faa = dest) |> 
    anti_join(airports)
flights |> 
    distinct(tailnum) |> 
    anti_join(planes)


# 18.4 Factors and empty groups -------------------------------------------
# A final type of missingness is the empty group, a group that doesn’t contain
# - any obsns, which can arise when working with factors.
health <- tibble(
    name    = c("Ikaia", "Oletta", "Leriah", "Dashay", "Tresaun"),
    smoker  = factor(c("no", "no", "no", "no", "no"), levels = c("yes", "no")),
    age     = c(34, 88, 75, 47, 56)
)
health
health |> count(smoker)
# This dataset only contains non-smokers, but we know that smokers exist.
# The group of non-smokers is empty. We can view them using count().
health |> count(smoker, .drop = FALSE)

# Similar problem comes up and can be avoided in ggplot graphs.
# Smoker group dropped.
ggplot(data = health, aes(x = smoker)) +
    geom_bar()
# Smoker group shown.
ggplot(data = health, aes(x = smoker)) +
    geom_bar() +
    scale_x_discrete(drop = FALSE)

# The same problem comes up more generally with dplyr::group_by(). And again 
# - you can use .drop = FALSE to preserve all factor levels.
health |> 
    group_by(smoker, .drop = FALSE) |> 
    summarize(
        n = n(),
        mean_age    = mean(age),
        min_age     = min(age),
        max_age     = max(age),
        sd_age      = sd(age)
    )
# A vector containing two missing values
x1 <- c(NA, NA)
length(x1)
# A vector containing nothing
x2 <- numeric()
length(x2)
# Altly, we use complete() after group_by() to make implicit missing explicit.
health |> 
    group_by(smoker) |> 
    summarize(
        n = n(),
        mean_age = mean(age),
        min_age = min(age),
        max_age = max(age),
        sd_age = sd(age)
    ) |> 
    complete(smoker)
# The main drawback of this approach is that you get an NA for the count, even
# - though you know that it should be zero.


# 18.5 Summary ------------------------------------------------------------
# NO CODE.




#_====
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# C19 - Joins -------------------------------------------------------------
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Here, we learn about joining dataframes together. 
# This chapter will introduce you to two important types of joins:
# > Mutating joins, which add new variables to one dataframe from matching
#   observations in another.
# > Filtering joins, which filter observations from one dataframe based on 
#   whether or not they match an observation in another.


# 19.1 Prerequisites ------------------------------------------------------
# Packages required for this chapter.
library(tidyverse)
library(nycflights13)
# NOTE: Here we will explore the five related datasets from nycflights13 using 
# - the join functions from dplyr.


# 19.2 Keys ---------------------------------------------------------------
# To understand joins, you need to first understand how two tables can be 
# - connected through a pair of keys, within each table.

# 19.2.1 Primary and foreign keys ====
# Every join involves a pair of keys: a primary key and a foreign key.
# A primary key is a var or set of vars that uniquely identifies each obs. 
# When more than one var is needed, the key is called a compound key.

# Identifying the primary keys in datasets
glimpse(airlines)       # Here carrier carrier (code) is the primary key.
glimpse(airports)       # Here faa (airport code) is the primary key.
glimpse(planes)         # Here tail number (tailnum) is the primary key.
glimpse(weather)
# Here, you can identify each observation by the combination of location and
# - time, making origin and time_hour the compound primary key.

# A foreign key is a var (or set of vars) that corresponds to a primary key
# - in another table.
# For example:
# > flights$tailnum corresponds to the primary key planes$tailnum.
# > flights$carrier corresponds to the primary key airlines$carrier.
# > flights$origin corresponds to the primary key airports$faa.
# > flights$dest corresponds to the primary key airports$faa.
# > flights$origin-flights$time_hour is a compound foreign key that corresponds
#   to the compound primary key weather$origin-weather$time_hour.

# 19.2.2 Checking primary keys ====
# It’s good practice to verify if the primary key in each dataset indeed
# - uniquely identify each observation. 

# One way to do that is to count() the primary keys and look for entries
# - where n is greater than one.
# CASE: Checking primary key in planes dataset.
planes |> 
    count(tailnum) |> 
    filter(n > 1)
# There are no obs with count > 1.
# CASE: Checking primary key in weather dataset.
weather |> 
    count(time_hour, origin) |> 
    filter(n > 1)
# There are no obs with count > 1.

# We should also check for missing values in your primary keys because if a
# - value is missing then it can’t identify an observation!
# CASE: Checking missing values in primary key of planes dataset.
planes |> 
    filter(is.na(tailnum))
# CASE: Checking missing values in primary key of weather dataset.
weather |> 
    filter(is.na(time_hour) | is.na(origin))

# 19.2.3 Surrogate keys ====
# So far we haven’t talked about the primary key for flights. After a little
# - thinking and experimentation, we determined that there are 3 variables
# - that together uniquely identify each flight.
flights |> 
    count(time_hour, carrier, flight) |> 
    filter(n > 1)
# There are no obs with count > 1.
# For flights, the combination of time_hour, carrier, and flight seems 
# - reasonable because it would be really confusing for an airline and its
# - customers if there were multiple flights with the same flight number in 
# - the air at the same time.

# Could there be other primary keys. For example, are altitude and latitude
# - a good primary key for airports?
airports |> 
    count(alt, lat) |> 
    filter(n > 1)
# There are duplicates with similar altitude and latitude.
# Identifying an airport by its altitude and latitude is clearly a bad idea
# - and in general it’s not possible to know from the data alone 
# - whether or not a combination of variables makes a good a primary key.

# That said, we might be better off introducing a simple numeric surrogate key
# - using the row number.
flights2 <- flights |> 
    mutate(id = row_number(), .before = 1)
glimpse(flights2)
# Surrogate keys can be particularly useful when communicating to other 
# - humans: it’s much easier to tell someone to take a look at flight 2001 
# - than to say look at UA430 which departed 9am 2013-01-03.


# 19.3 Basic joins --------------------------------------------------------
# Now that you understand how dataframes are connected via keys, we can start
# - using joins to better understand the flights dataset. 
# dplyr provides 6 join functions: 
# > left_join() 
# > inner_join() 
# > right_join() 
# > full_join() 
# > semi_join(), and 
# > anti_join() 
# They all have the same interface: they take a pair of dataframes (x and y) 
# - and return a dataframe. The order of the rows and columns in the output is
# - primarily determined by x.

# 19.3.1 Mutating joins ====
# A mutating join allows you to combine vars from two dataframes: 
# > it first matches observations by their keys, 
# > then copies across vars from one dataframe to the other. 
# Like mutate(), the join functions add vars to the right, so if your dataset
# - has many variables, you won’t see the new ones.
# Creating a narrower dataset with just six variables.
flights2 <- flights |> 
    select(year, time_hour, origin, dest, tailnum, carrier)
glimpse(flights2)
# There are 4 types of mutating join where left_join() is commonly used. 
# - The primary use of left_join() is to add in additional metadata.
# CASE: Use left_join() to add the full airline name to the flights2 data.
flights2 |> 
    left_join(airlines) |> 
    glimpse()
# CASE: Find out the temperature and wind speed when each plane departed.
flights2 |> 
    left_join(weather |> select(origin, time_hour, temp, wind_speed)) |> 
    glimpse()
# CASE: Find size of plane that was flying.
flights2 |> 
    left_join(planes |> select(tailnum, type, engines, seats)) |> 
    glimpse()

# When left_join() fails to find a match for a row in x, it fills in the 
# - new vars with missing values as shown in case of plane no N3ALAA.
flights2 |> 
    filter(tailnum == "N3ALAA") |> 
    left_join(planes |> select(tailnum, type, engines, seats))

# 19.3.2 Specifying join keys ====
# By default, left_join() will use all vars that are common in both dataframes
# - as the join key, the so called natural join. This is a useful heuristic
# - but it does not always work.
# CASE: Join flights2 with the complete planes dataset.
flights2 |> 
    left_join(planes) |> 
    view()
# We get a lot of missing matches because our join is trying to use tailnum
# - and year as a compound key. Both flights and planes have a year column but
# - they mean different things. flights$year is the year the flight occurred
# - and planes$year is the year the plane was built.

# CASE: Joins flights2 with planes dataset by tailnum as key.
# Key can be specified with join_by().
flights2 |> 
    left_join(planes, join_by(tailnum))
# NOTE: The year variables are disambiguated in the output with a 
# - suffix - year.x and year.y), which tells you whether the var came from
# - the x or y argument. You can override the default suffixes with the
# - suffix argument.

# NOTE: join_by(tailnum) is short for join_by(tailnum == tailnum).
# It is important to know as the x and y df may have differently named keys.
# CASE: Join the flight2 and airports table in 2 ways - by dest or origin.
flights2 |> 
    left_join(
        airports, join_by(dest == faa)
    )
flights2 |> 
    left_join(
        airports, join_by(origin == faa)
    )
# We will learn about inner_join(), right_join(), and full_join() below.

# 19.3.3 Filtering joins ====
# A filtering join is used to filter the rows. There are two types:
# > semi-joins, and
# > anti-joins.
# Semi-joins keep all rows in x that have a match in y.
# CASE: Use a semi-join to show just the origin airports.
airports |> 
    semi_join(flights2, join_by(faa == origin))
# CASE: Use a semi-join to show just the destination airports.
airports |> 
    semi_join(flights2, join_by(faa == dest))

# Anti-joins are the opposite: they return all rows in x that don’t have a 
# - match in y. They’re useful for finding missing values that are implicit
# - in the data. Implicitly missing values don’t show up as NAs but instead
# - only exist as an absence.
# CASE: Find rows that are missing from airports by looking for flights that
#       don’t have a matching destination airport.
flights2 |> 
    anti_join(airports, join_by(dest == faa)) |> 
    distinct(dest)
# CASE: Find which tailnum's are missing from planes.
flights2 |> 
    anti_join(planes, join_by(tailnum)) |> 
    distinct(tailnum)


# 19.4 How do joins work? -------------------------------------------------
# Here we further learn about joins by focusing on how each row in x matches
# - rows in y. We’ll begin by introducing a visual representation of joins
# - using the simple tibbles defined below. Although, we’ll see examples with
# - a single key called key and a single value column (val_x and val_y), but
# - the ideas all generalize to multiple keys and multiple values.
x <- tribble(
    ~key,   ~val_x,
    1,      "x1",
    2,      "x2",
    3,      "x3"
)
y <- tribble(
    ~key,   ~val_y,
    1,      "y1",
    2,      "y2",
    4,      "y3"
)

# Inner join
inner_join(x, y, join_by(key))
# Left join
left_join(x, y, join_by(key))
# Right join
right_join(x, y, join_by(key))
# Full join
full_join(x, y, join_by(key))
# The joins shown here are the so-called equi joins, where rows match
# - if the keys are equal.

# 19.4.1 Row matching ====
# So far we have seen what happens if a row in x matches O or 1 row in y. Now
# - we will see What happens if it matches more than 1 row.
# There are three possible outcomes for a row in x:
# > If it doesn’t match anything, it’s dropped.
# > If it matches 1 row in y, it’s preserved.
# > If it matches more than 1 row in y, it’s duplicated once for each match.

# Join two tables where multiple rows have same key in each.
df1 <- tibble(key = c(1, 2, 2), val_x = c("x1", "x2", "x3"))
df2 <- tibble(key = c(1, 2, 2), val_y = c("y1", "y2", "y3"))
inner_join(df1, df2, join_by(key))
# While the 1st row in df1 only matches 1 row in df2, the 2nd and 3rd rows 
# - both match 2 rows. This is sometimes called a many-to-many join, and will
# - cause dplyr to emit a warning
# If you want this output then you can use relationship = "many-to-many" arg.

# 19.4.2 Filtering joins ====
# The semi-join keeps rows in x that have one or more matches in y.
semi_join(x, y, join_by(key))
# The anti-join keeps rows in x that match zero rows in y.
anti_join(x, y, join_by(key))

# In both cases, only the existence of a match is important; it doesn’t matter
# - how many times it matches. This means that filtering joins never duplicate
# - rows like mutating joins do.
semi_join(df1, df2, join_by(key))
anti_join(df1, df2, join_by(key))


# 19.5 Non-equi joins -----------------------------------------------------
# So far we have only seen equi joins, where the rows match if the x key 
# - equals the y key. Now we are going to relax that restriction and discuss
# - other ways of determining if a pair of rows match.

# NOTE: In equi joins both x and y keys are equal and only one key is kept.
# But, we can request dplyr to keep both keys with keep = TRUE.
x |> 
    inner_join(y, join_by(key == key), keep = TRUE)
# When we move away from equi joins we will always show the keys, because 
# - the key values will often be different. For example, instead of matching
# - only when the x$key and y$key are equal, we could match whenever the
# - x$key is greater than or equal to the y$key.

# dplyr identifies four particularly useful types of non-equi join:
# > Cross joins match every pair of rows.
# > Inequality joins use <, <=, >, and >= instead of ==.
# > Rolling joins, are like inequality joins, but find only the closest match.
# > Overlap joins, are like inequality joins, but work with ranges.

# 19.5.1 Cross joins ====
# A cross join matches everything, generating the Cartesian product of rows.
# This means the output will have nrow(x) * nrow(y) rows.
cross_join(x, x)
# Cross joins are useful when generating permutations. Cross joins use a
# - different join function because there is no distinction between 
# - inner/left/right/full when you are matching every row.
# CASE: Generate every possible pair of names.
df <- tibble(name = c("John", "Simon", "Tracy", "Max"))
df |> cross_join(df)

# 19.5.2 Inequality joins ====
# Inequality joins use <, <=, >=, or > to restrict the set of possible matches.
# Inequality joins are extremely general, so general that it’s hard to 
# - come up with meaningful specific use cases. One small useful technique is
# - to use them to restrict the cross join so that instead of generating 
# - all permutations, we generate all combinations
df <- tibble(id = 1:4, name = c("John", "Simon", "Tracy", "Max"))
df |> inner_join(df, join_by(id < id))

# 19.5.3 Rolling joins ====
# Rolling joins are a special type of inequality join where instead of 
# - getting every row that satisfies the inequality, you get just the 
# - closest row. You can turn any inequality join into a rolling join by 
# - adding closest(). For example join_by(closest(x <= y)) matches the 
# - smallest y that’s greater than or equal to x, and join_by(closest(x > y)) 
# - matches the biggest y that’s less than x.
left_join(x, y, join_by(closest(key <= key)))
left_join(x, y, join_by(closest(key > key)))

# CASE: Planning the party of office employees.
# Table of office party dates 
parties <- tibble(
    q = 1:4,
    party = ymd("2022-01-10", "2022-04-04", "2022-07-11", "2022-10-03")
)
# Table of employees birthdays
set.seed(123)
employees <- tibble(
    name = sample(babynames::babynames$name, 100),
    birthday = ymd("2022-01-01") + (sample(1:365, 100, replace = TRUE) - 1)
)
employees
# Now, for each employee we want to find the first party date that comes 
# - after (or on) their birthday. We can express that with a rolling join.
left_join(
    employees, 
    parties, 
    join_by(closest(birthday >= party))
)
# There is one problem with this approach: the folks with birthdays before
# January 10 do not get a party.
anti_join(
    employees,
    parties,
    join_by(closest(birthday >= party))
)
# To solve this this we will need to perform overlap joins.

# 19.5.4 Overlap joins ====
# Overlap joins provide 3 helpers that use inequality joins to make it 
# easier to work with intervals:
# > between(x, y_lower, y_upper) is short for x >= y_lower, x <= y_upper.
# > within(x_lower, x_upper, y_lower, y_upper) is short for 
#   x_lower >= y_lower, x_upper <= y_upper.
# > overlaps(x_lower, x_upper, y_lower, y_upper) is short for 
#   x_lower <= y_upper, x_upper >= y_lower.

# CASE: Solve the birthday assignment problem where there’s no party for
#       the birthdays Jan 1-9.
parties <- tibble(
    q = 1:4,
    party = ymd(c("2022-01-10", "2022-04-04", "2022-07-11", "2022-10-03")),
    start = ymd(c("2022-01-01", "2022-04-04", "2022-07-11", "2022-10-03")),
    end = ymd(c("2022-04-03", "2022-07-11", "2022-10-02", "2022-12-31"))
)
parties
# Checking if the party periods overlap.
parties |> 
    inner_join(
        parties,
        join_by(overlaps(start, end, start, end), q < q)
    )
# Oops, there is an overlap, so let’s fix that problem and continue.
parties <- tibble(
    q = 1:4,
    party = ymd(c("2022-01-10", "2022-04-04", "2022-07-11", "2022-10-03")),
    start = ymd(c("2022-01-01", "2022-04-04", "2022-07-11", "2022-10-03")),
    end = ymd(c("2022-04-03", "2022-07-10", "2022-10-02", "2022-12-31"))
)
# Now we can match each employee to their party. This is a good place to 
# - use unmatched = "error" because we want to quickly find out if 
# - any employees didn’t get assigned a party.
employees |> 
    inner_join(
        parties, 
        join_by(between(birthday, start, end)),
        unmatched = "error"
    )


# 19.6 Summary ------------------------------------------------------------
# NO CODE.





