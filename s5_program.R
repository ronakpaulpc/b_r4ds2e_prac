# Code from book R for Data Science (2nd Edition) by Hadley Wickham and co.
# Here we have script files for each book section.
# Then, in each script file we have code sections for each chapter.
# This script contains code from the "Program" section of the book.
# In this part of the book, you’ll improve your programming skills. 
# Programming is a cross-cutting skill needed for all data science work.

# Programming produces code, and code is a tool of communication. Obviously
# - code tells the computer what you want it to do. But it also communicates
# - meaning to other humans. Thinking about code as communication vehicle 
# - is important as every project you do is fundamentally collaborative. Even
# - if you’re not working with other people, you will definitely be working
# - with future-you! Writing clear code is important so that others like 
# - future-you, can understand why you tackled an analysis in the way 
# - you did. That means getting better at programming also involves getting
# - better at communicating. Over time, you want your code to become not just 
# - easier to write, but easier for others to read.

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
#         "patchwork",
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
    "arrow",
    "babynames",
    "curl",
    "duckdb",
    "gapminder",
    "ggrepel",
    "ggridges",                     # Ridgeline plots based on ggplot2
    "ggthemes",                     # Useful themes based on ggplot2
    "hexbin",
    "janitor",                      # Cmds for data cleaning
    "Lahman",
    "leaflet",
    "maps",
    "nycflights13",
    "openxlsx",                     # For imp/exp and handling excel sheets
    "palmerpenguins",
    "pacman",
    "patchwork",
    "repurrrsive",
    "tidymodels",
    "writexl",
    "tidyverse"                     # Universe of data mgmt pkgs
)
# p_loaded()                          # checking the loaded packages
# unloadNamespace("writexl")          # Unloading a pkg

# Updating R from Rstudio
# install.packages("installr")
# library(installr)
# updateR(TRUE)



#_====
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# C25 - Functions ---------------------------------------------------------
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# The best way to improve your data scientist influence is to write fns. In
# this chapter we will learn about three useful types of fn:
# 1. Vector fns take vectors as input and return a vector as output.
# 2. Dataframe fns take a dataframe as input and return a dataframe as output.
# 3. Plot fns that take a dataframe as input and return a plot as output.


# 25.1 Prerequisites ------------------------------------------------------
library(tidyverse)
library(nycflights13)


# 25.2 Vector functions ---------------------------------------------------
# These functions that take one or more vectors and return a vector result.
df <- tibble(
    a = rnorm(5),
    b = rnorm(5),
    c = rnorm(5),
    d = rnorm(5)
)
df
df |> mutate(
    a = (a - min(a, na.rm = T)) / (max(a, na.rm = T) - min(a, na.rm = T)),
    b = (b - min(a, na.rm = T)) / (max(b, na.rm = T) - min(b, na.rm = T)),
    c = (c - min(c, na.rm = T)) / (max(c, na.rm = T) - min(c, na.rm = T)),
    d = (d - min(d, na.rm = T)) / (max(d, na.rm = T) - min(d, na.rm = T))
)
# NOTE: The above code has a mistake.
# When copying-and-pasting Hadley forgot to change an a to b.


# 25.2.1 Writing a function ====
# To write a function you need to first analyse your repeated code to figure
# what parts are constant and what parts vary. Then our function is:
rescale01 <- function(x) {
    (x - min(x, na.rm = T)) / (max(x, na.rm = T) - min(x, na.rm = T))
}
# Test this function with simple vectors
rescale01(c(-10, 0, 10))
rescale01(c(1, 2, 3, NA, 5))
# Now we can rewrite our mutate call as:
df |> mutate(
    a = rescale01(a),
    b = rescale01(b),
    c = rescale01(c),
    d = rescale01(d)
)


# 25.2.2 Improving our function ====
# The rescale01() function does some unnecessary work — instead of computing
# min() twice and max() once we could instead compute both the minimum and
# maximum in one step with range().
rescale01 <- function(x) {
    rng <- range(x, na.rm = T)
    (x - rng[1]) / (rng[2] - rng[1])
}
# Testing the fn on infinite values.
x <- c(1:10, Inf)
rescale01(x)

# Asking the function to ignore infinite values
rescale01 <- function(x) {
    rng <- range(x, na.rm = T, finite = T)
    (x - rng[1]) / (rng[2] - rng[1])
}
rescale01(x)


# 25.2.3 Mutate functions ====
# Mutate fns work well inside of mutate() and filter() and they return an
# output of the same length as the input.
# Compute the Z-score, i.e., rescaling a vector to have a mean 0 and sd 1.
z_score <- function(x) {
    (x - mean(x, na.rm = T)) / sd(x, na.rm = T)
}
z_score(c(1:10))

# CASE: clamp() fn that ensures all vector values lie btwn a min or a max.
clamp <- function(x, min, max) {
    case_when(
        x < min ~ min,
        x > max ~ max,
        .default = x
    )
}
clamp(x = 1:10, min = 3, max = 7)

# Functions can also be used to perform string manipulation.
# CASE: Convert first character of string to upper case.
first_upper <- function(x) {
    str_sub(x, 1, 1) <- str_to_upper(str_sub(x, 1, 1))
    x
}
first_upper("hello")

# CASE: Strip percent signs, commas, and dollar signs from a string before
#       converting it into a number.
clean_number <- function(x) {
    is_pct <- str_detect(x, "%")
    num <- x |> 
        str_remove_all("%") |> 
        str_remove_all(",") |> 
        str_remove_all(fixed("$")) |> 
        as.numeric()
    if_else(is_pct, num / 100, num)
}

clean_number <- function(x) {
    is_pct <- str_detect(x, "%")
    num <- x |> 
        str_remove_all("%") |> 
        str_remove_all(",") |> 
        str_remove_all("$") |> 
        as.numeric()
    if_else(is_pct, num/100, num)
}

# Testing the function.
clean_number("$12,300")
clean_number("45%")
# CODE IS GIVING ERRORS

# Sometimes we need fns that are highly specialized for one data analysis step.
# CASE: Replace missing values as 997, 998, or 999 with NA.
fix_na <- function(x) {
    if_else(x %in% c(997, 998, 999), NA, x)
}
fix_na(c(995:1000))


# 25.2.4 Summary functions ====
# Summary functions return a single value for use in summarize().
commas <- function(x) {
    str_flatten(x, collapse = ", ", last = " and ")
}
commas(c("cat", "dog", "pigeon"))

# CASE: Computing the coefficient of variation, which divides the 
# standard deviation by the mean.
cv <- function(x) {
    sd(x, na.rm = T) / mean(x, na.rm = T)
}
# Function test
cv(runif(100, min = 0, max = 50))
cv(runif(100, min = 0, max = 500))

# CASE: Make a common pattern easier to remember by giving it a memorable name.
n_missing <- function(x) {
    sum(is.na(x))
}
# Function test
x <- c(1:3, NA, 5:7, NA, NA, 10)
n_missing(x)

# You can also write functions with multiple vector inputs.
# CASE: Computing the mean absolute percentage error to help you compare 
# model predictions with actual values.


# 25.3 Dataframe functions ------------------------------------------------
# Dataframe functions are like dplyr commands. They work like dplyr verbs:
# they take a dataframe as the first argument, some extra arguments that
# say what to do with it, and return a dataframe or a vector.

# 25.3.1 Indirection and tidy evaluation ====
# When you start writing functions that use dplyr verbs you rapidly hit the 
# problem of indirection.
# CASE: Learn the indirection problem with the grouped_mean() fn.
grouped_mean <- function(df, group_var, mean_var) {
    df |> 
        group_by(group_var) |> 
        summarize(mean(mean_var))
}
# When we try to use it we get an error.
diamonds |> grouped_mean(cut, carat)

# To make the problem a bit more clear, we can use a made up dataframe.
df <- tibble(
    mean_var = 1,
    group_var = "g",
    group = 1,
    x = 10,
    y = 100
)
df
df |> grouped_mean(group, x)
df |> grouped_mean(group, y)
# NOTE: grouped_mean fn is using the fn arguments as the varnames rather 
# than using the varnames inside the fn arguments. This is a problem of 
# indirection, and it arises because dplyr uses tidy evaluation to allow
# you to refer to the names of variables inside your dataframe without 
# any special treatment.

# SOL: Embracing in tidy evaluation. Embracing a var means to wrap it in
# braces so var becomes { var }. Embracing a variable tells dplyr to use
# the value stored inside the arg, not the arg as the literal var name.
grouped_mean <- function(df, group_var, mean_var) {
    df |> 
        group_by({{group_var}}) |> 
        summarize(mean({{mean_var}}))
}
df |> grouped_mean(group, x)
diamonds |> grouped_mean(cut, carat)


# 25.3.2 When to embrace? ====
# So the key challenge in writing data frame functions is figuring out which
# arguments need to be embraced. Fortunately, this is easy because you can
# look it up from the documentation.
# NO CODE.


# 25.3.3 Common use cases ====
# If you commonly perform the same set of summaries when doing initial 
# data exploration, you might consider wrapping them up in a helper fn.
summary6 <- function(data, var) {
    data |> summarize(
        min = min({{var}}, na.rm = T),
        max = max({{var}}, na.rm = T),
        mean = mean({{var}}, na.rm = T),
        median = median({{var}}, na.rm = T),
        n = n(),
        n_miss = sum(is.na({{var}})),
        .groups = "drop"
    )
}
diamonds |> summary6(carat)

# The good thing in this fn is, because it wraps summarize(), we can use it
# on grouped data.
diamonds |> 
    group_by(cut) |> 
    summary6(carat)

# Also, since the args to summarize are data-masking also means that the 
# var arg to summary6() is data-masking. That means you can also summarize
# computed variables.
diamonds |> group_by(cut) |> 
    summary6(log10(carat))

# Another popular summarize() helper function is a version of count() that
# also computes proportions.
count_prop <- function(df, var, sort = F) {
    df |> 
        count({{var}}, sort = sort) |> 
        mutate(
            prop = (n / sum(n)),
            pct = prop * 100
        )
}
diamonds |> count_prop(clarity)
# NOTE: We use a default value for sort so that if the user doesn’t 
# supply their own value it will default to FALSE.

# Find the sorted unique values of a variable for a subset of the data.
unique_where <- function(df, condition, var) {
    df |> 
        filter({{ condition }}) |> 
        distinct({{ var }}) |> 
        arrange({{ var }})
}
# Find all the destinations in December.
flights |> unique_where(month == 12, dest)
# NOTE: This fn allows the user to supply a condition, rather than supplying
# a variable and a value to do the filtering.

# If you’re working repeatedly with the same data, we can hard-code it.
# CASE: The following fn always works with the flights dataset and always
# selects time_hour, carrier, and flight as they are the compound primary key.
subset_flights <- function(rows, cols) {
    flights |> 
        filter({{ rows }}) |> 
        select(time_hour, carrier, flight, {{ cols }})
}


# 25.3.4 Data-masking vs tidy-selection ====
# Sometimes you want to select vars inside a function that uses data-masking.
# CASE: Write a count_missing() that counts the num of missing obsns in rows.
count_missing <- function(df, group_vars, x_var) {
    df |> 
        group_by({{group_vars}}) |> 
        summarize(
            n_miss = sum(is.na({{x_var}})),
            .groups = "drop"
        )
}
flights |> 
    count_missing(c(year, month, day), dep_time)
# WE GET ERROR. 
# It is because group_by() uses data-masking, not tidy-selection.

# SOL: We can use the pick(). It allows you to use tidy-selection inside
# data-masking functions.
count_missing <- function(df, group_vars, x_var) {
    df |> 
        group_by(pick({{ group_vars }})) |> 
        summarize(
            n_miss = sum(is.na({{ x_var }})),
            .groups = "drop"
        )
}
flights |> count_missing(c(year, month, day), dep_time)
# THIS IS FINE.

# Another convenient use of pick() is to make a 2d table of counts. 
# CASE: Count using all the vars in the rows and columns, then use 
#       pivot_wider() to rearrange the counts into a grid.
count_wide <- function(df, rows, cols) {
    df |> 
        count(pick({{ rows }}, {{ cols }})) |> 
        pivot_wider(
            names_from = {{ cols }},
            values_from = n,
            names_sort = T,
            values_fill = 0
        )
}
diamonds |> count_wide(c(clarity, color), cut)


# 25.4 Plot functions -----------------------------------------------------
# Plot fns return a plot instead of returning a dataframe. This is helpful in
# cases when we are making a lot of the same plots.
diamonds |> 
    ggplot(aes(x = carat)) +
    geom_histogram(binwidth = 0.1)
diamonds |> 
    ggplot(aes(x = carat)) +
    geom_histogram(binwidth = 0.05)

# We wrap the repeated code into a histogram fn.
histogram <- function(df, var, binwidth) {
    df |> 
        ggplot(aes(x = {{ var }})) +
        geom_histogram(binwidth = binwidth)
}
diamonds |> histogram(carat, 0.1)

# NOTE: histogram() returns a ggplot2 plot, meaning you can still add on 
# additional components if you want. Just remember to switch from |> to +
diamonds |> 
    histogram(carat, 0.1) +
    labs(
        x = "Size (in carats)",
        y = "Number of diamonds"
    )


# 25.4.1. More variables ====
# It’s straightforward to add more variables to the mix. 
# CASE: Function to eyeball whether or not a dataset is linear by
# overlaying a smooth line and a straight line.
linearity_check <- function(df, x, y) {
    df |> 
        ggplot(aes(x = {{ x }}, y = {{ y }})) +
        geom_point() +
        geom_smooth(
            formula = y ~ x, method = "loess", 
            colour = "red", se = F 
        ) +
        geom_smooth(
            formula = y ~ x, method = "lm",
            colour = "blue", se = F
        )
}
# Function check
starwars |> 
    filter(mass < 1000) |> 
    linearity_check(mass, height)
    
# Coloured scatter plots for large datasets avoiding over plotting.
hex_plot <- function(df, x, y, z, bins = 20, fun = "mean") {
    df |> 
        ggplot(aes(x = {{ x }}, y = {{ y }}, z = {{ z }})) +
        stat_summary_hex(
            # make border same colour as fill
            aes(colour = after_scale(fill)),
            bins = bins,
            fun = fun
        )
}
# Function check
diamonds |> hex_plot(carat, price, depth)


# 25.4.2 Combining with other tidyverse ====
# The most useful helpers combine a dash of data manipulation with ggplot2.
# CASE: Fn of vertical bar charts where we automatically sort the bars in
#       frequency order. Since the bar chart is vertical, we also need to
#       reverse the usual order to get the highest values at the top.
sorted_bars <- function(df, var) {
    df |> 
        mutate(
            {{ var }} := fct_rev(fct_infreq( {{ var }}))
        ) |> 
        ggplot(aes(y = {{ var }})) +
        geom_bar()
}
diamonds |> sorted_bars(clarity) 
# NOTE: We use a new operator here, := commonly referred to as the
# “walrus operator”. 

# CASE: Fn to draw a bar plot just for a subset of the data.
conditional_bars <- function(df, condition, var) {
    df |> 
        filter( {{condition}} ) |> 
        ggplot(aes(x = {{ var }})) +
        geom_bar()
}
diamonds |> conditional_bars(cut == "Good", clarity)


# 25.4.3 Labeling ====
# We can add labels to the histogram fn we prepared earlier.
histogram <- function(df, var, binwidth = NULL) {
    df |> 
        ggplot(aes(x = {{ var }})) +
        geom_histogram(binwidth = binwidth)
}
diamonds |> histogram(carat, 0.1)

# CASE: Label the fn output with the var name and the binwidth that was used.
# To do this we use englue fn from rlang. rlang is a low-level package that’s
# used by just about every other package in the tidyverse because it 
# implements tidy evaluation (as well as many other useful tools).
histogram <- function(df, var, binwidth) {
    label <- rlang::englue("A histogram of {{var}} with binwidth {binwidth}")
    df |> 
        ggplot(aes(x = {{var}})) +
        geom_histogram(binwidth = binwidth) +
        labs(title = label)
}
diamonds |> histogram(carat, 0.1)
# We can use the same approach in any other place where you want to supply
# a string in a ggplot2 plot.


# 25.5 Style --------------------------------------------------------------
# R doesn’t care what your function or arguments are called but 
# the names make a big difference for humans.
# Generally, function names should be verbs, and arguments should be nouns.
# There are some exceptions too. Use your best judgement and don’t be afraid
# to rename a function if you figure out a better name later.

# Too short
f()
# Not a verb or descriptive
my_awesome_function()
# Long, but clear
impute_missing()
collapse_years()

# R also doesn’t care about how you use white space in your functions but
# future readers will. function() should always be followed by squiggly 
# brackets ({}), and the contents should be indented by an additional 
# two spaces. This makes it easier to see the hierarchy in your code 
# by skimming the left-hand margin.

# Missing extra two spaces
density <- function(colour, facets, binwidth = 0.1) {
diamonds |> 
        ggplot(
            aes(x = carat, y = after_stat(density), colour = {{ colour }})
        ) +
        geom_freqpoly() +
        facet_wrap(vars({{ facets }}))
}

# Pipe indented correctly
density <- function() {
    diamonds |> 
        ggplot(
            aes(
                x = carat,
                y = after_stat(density),
                colour = {{ colour }}
            )
        ) +
        geom_freqpoly(binwidth = binwidth) +
        facet_wrap(vars({{ facets }}))
}


# 25.6 Summary ------------------------------------------------------------
# NO CODE.




#_====
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# C26 - Iteration ---------------------------------------------------------
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# In this chapter, we will learn tools for iteration, repeatedly performing
# the same action on different objects. Iteration in R generally tends to
# look rather different from other programming languages because so much 
# of it is implicit and we get it for free.

# For example, if you want to double a numeric vector x in R, you can just
# write 2 * x. In most other languages, you’d need to explicitly double each 
# element of x using some sort of for loop.

# Now it’s time to learn some more general tools, often called 
# functional programming tools because they are built around functions that 
# take other functions as inputs.


# 26.1 Prerequisites ------------------------------------------------------
library(tidyverse)


# 26.2 Modifying multiple columns -----------------------------------------
# Imagine you have this simple tibble where you want to count the number of 
# observations and compute the median of every column.
df <- tibble(
    a = rnorm(10),
    b = rnorm(10),
    c = rnorm(10),
    d = rnorm(10)
)
df

# We could do that manually with copy-and-paste.
df |> summarize(
    n = n(),
    a = median(a),
    b = median(b),
    c = median(c),
    d = median(d)
)
# This breaks our rule of thumb to never copy and paste more than twice.
# Also, this will get very tedious if you have tens or hundreds of columns.

# SOL: We use the across() fn.
df |> 
    summarize(
        n = n(),
        across(a:d, median)
    )


# 26.2.1 Selecting columns with .cols ====
# The first argument to across(), .cols, selects the columns to transform. 
# This uses the same specifications as select(), so you can use functions 
# like starts_with() and ends_with() to select columns based on their name.

# There are two additional selection techniques that are particularly useful 
# for across(): everything() and where().
# everything() is straightforward: it selects every (non-grouping) column.
df <- tibble(
    grp = sample(2, 10, replace = T),
    a = rnorm(10),
    b = rnorm(10),
    c = rnorm(10),
    d = rnorm(10)
)
df                  # data check
df |> 
    group_by(grp) |> 
    summarize(across(everything(), median))
# NOTE: Grouping columns (grp here) are not included in across(), because 
# they’re automatically preserved by summarize().

# where() allows you to select columns based on their type:
# 1. where(is.numeric) selects all numeric columns.
# 2. where(is.character) selects all string columns.
# 3. where(is.Date) selects all date columns.
# 4. where(is.POSIXct) selects all date-time columns.
# 5. where(is.logical) selects all logical columns.

# Just like other selectors, you can combine these with Boolean algebra. 
# For example, !where(is.numeric) selects all non-numeric columns.


# 26.2.2 Calling a single function ====
# The second argument to across() defines how each col will be transformed.
# In simple cases, as above, this will be a single existing function.
# This is a pretty special feature of R: 
# We pass one fn (median, mean, str_flatten, ...) to another fn (across).
# This is one of the features that makes R a functional programming language.

# NOTE: Function name should never be followed by (). We are passing this
# fn to across(), so across() can call it; we’re not calling it ourselves.
# CASE: Calling fn names with () gives error.
df |> 
    group_by(grp) |> 
    summarize(
        across(everything(), median())
    )
# This error arises because you’re calling the function with no input.
median()


# 26.2.3 Calling multiple functions ====
# In complex cases we might want to perform multiple transformations or 
# supply additional arguments in across().
rnorm_na <- function(n, n_na, mean = 0, sd = 1) {
    sample(
        c(rnorm(n - n_na, mean, sd),
          rep(NA, n_na))
    )
}
df_miss <- tibble(
    a = rnorm_na(5, 1),
    b = rnorm_na(5, 1),
    c = rnorm_na(5, 2),
    d = rnorm(5)
)
df_miss
df_miss |> 
    summarize(
        across(a:d, median),
        n = n()
    )
# It would be nice if we could pass along na.rm = TRUE to median() to remove 
# these missing values.
# SOL: We need to create a new fn that calls median() with the desired args.
df_miss |> 
    summarize(
        across(a:d, function(x) median(x, na.rm = T)),
        n = n()
    )
# This is a little verbose, so R comes with a handy shortcut. For this sort 
# of throw away or anonymous function you can replace function with \.
df_miss |> 
    summarize(
        across(a:d, \(x) median(x, na.rm = T)),
        n = n()
    )

# In either case, across() effectively expands to the following code:
df_miss |> 
    summarize(
        a = median(a, na.rm = T),
        b = median(b, na.rm = T),
        c = median(c, na.rm = T),
        d = median(d, na.rm = T),
        n = n()
    )

# When we remove the missing values from the median(), it would be nice to 
# know just how many values were removed. 
# We can find that out by supplying two functions to across(): one to compute 
# the median and the other to count the missing values. 
# You supply multiple functions by using a named list to .fns:
# CASE: Counting the number of missing values removed.
df_miss |> 
    summarize(
        across(
            a:d, 
            list(
                median = \(x) median(x, na.rm = T),
                n_miss = \(x) sum(is.na(x))
            )
        ),
        n = n()
    )


# 26.2.4 Column names ====
# The result of across() is named according to the specification provided in 
# the .names argument. 
# CASE: Specifying our own fn where the name of the function comes first.
df_miss |> 
    summarize(
        across(
            a:d, 
            list(
                median = function(x) median(x, na.rm = T),
                n_miss = function(x) sum(is.na(x))),
            .names = "{.fn}_{.col}"
        ),
        n = n()
    )

# The .names argument is particularly important when you use across() with 
# mutate(). By default, the output of across() is given the same names as 
# the inputs. This means that across() inside of mutate() will replace 
# existing columns. 
# CASE: Using coalesce to replace NA's with 0.
df_miss |> 
    mutate(
        across(a:d, function(x) coalesce(x, 0))
    )
# If you’d like to instead create new columns, you can use the .names 
# argument to give the output new names.
df_miss |> 
    mutate(
        across(
            a:d,
            function(x) coalesce(x, 0),
            .names = "{.col}_na_zero"
        )
    )


# 26.2.5 Filtering ====
# across() is a great match for summarize() and mutate() but it’s more 
# awkward to use with filter(). So, dplyr provides two variants of across() 
# called if_any() and if_all().

# same as df_miss |> filter(is.na(a) | is.na(b) | is.na(c) | is.na(d))
df_miss |> 
    filter(if_any(a:d, is.na))
# same as df_miss |> filter(is.na(a) & is.na(b) & is.na(c) & is.na(d))
df_miss |> 
    filter(if_all(a:d, is.na))


# 26.2.6 across() in functions ====
# across() is particularly useful to program with because it allows you to 
# operate on multiple columns.
# CASE: Jacob Scott's helper fn which wraps a bunch of lubridate functions 
# to expand all date columns into year, month, and day columns.
expand_dates <- function(df) {
    df |> 
        mutate(
            across(
                where(is.Date),
                list(year = year, month = month, day = day)
            )
        )
}
# example dataset
df_date <- tibble(
    name = c("Amy", "Bob"),
    date = ymd(c("2009-08-03", "2010-01-16"))
) 
# function check
df_date |> expand_dates()

# across() also makes it easy to supply multiple cols in a single argument 
# because the first argument uses tidy-select; you just need to remember to 
# embrace that argument.
# For example, this fn will compute the means of numeric columns by default. 
# But by supplying the second argument you can choose to summarize just 
# selected columns.
summarize_means <- function(df, summary_vars = where(is.numeric)) {
    df |> 
        summarize(
            across({{summary_vars}}, function(x) mean(x, na.rm = T)),
            n = n(),
            .groups = "drop"
        )
}
# with no summary vars
diamonds |> 
    group_by(cut) |> 
    summarize_means()
# with summary vars
diamonds |> 
    group_by(cut) |> 
    summarize_means(c(carat, x:z))


# 26.2.7 Compare with pivot_longer() ====
# Before we go on, it’s worth pointing out an interesting connection 
# between across() and pivot_longer(). In many cases, you perform the 
# same calculations by first pivoting the data and then performing the 
# operations by group rather than by column.
# creating the dataset.
df <- tibble(
    grp = sample(2, 10, replace = TRUE),
    a = rnorm(10),
    b = rnorm(10),
    c = rnorm(10),
    d = rnorm(10)
)
df
# calculating the summary statistics
df |> 
    summarize(
        across(a:d, list(median = median, mean = mean))
    )
# We could compute the same values by pivoting longer and then summarizing.
long <- df |> 
    pivot_longer(a:d) |> 
    group_by(name) |> 
    summarize(
        median = median(value),
        mean = mean(value)
    )
# Then if you wanted the same structure as across() you could pivot again.
long |> 
    pivot_wider(
        names_from = name,
        values_from = c(median, mean),
        names_vary = "slowest",
        names_glue = "{name}_{.value}"
    )

# Knowing this technique is useful because sometimes you’ll hit a problem 
# that’s not currently possible to solve with across(), like, when you have 
# groups of columns that you want to compute with simultaneously.
# CASE: Computing a weighted mean.
df_paired <- tibble(
    a_val = rnorm(10),
    a_wts = runif(10),
    b_val = rnorm(10),
    b_wts = runif(10),
    c_val = rnorm(10),
    c_wts = runif(10),
    d_val = rnorm(10),
    d_wts = runif(10)
)
df_paired
# There’s currently no way to do this with across(), but it’s relatively 
# straightforward with pivot_longer().
df_long <- df_paired |> 
    pivot_longer(
        everything(),
        names_to = c("group", ".value"),
        names_sep = "_"
    )
df_long
df_long |> 
    group_by(group) |> 
    summarize(mean = weighted.mean(val, wts))
# If needed, you could pivot_wider() this back to the original form.
df_long |> 
    group_by(group) |> 
    summarize(
        mean = weighted.mean(val, wts), 
        .groups = "drop"
    ) |> 
    pivot_wider(
        names_from = group,
        values_from = mean
    )


# 26.3 Reading multiple files ---------------------------------------------
# Here, you will learn how to use purrr::map() to do something to every file 
# in a directory.
# Let’s start with a little motivation: imagine you have a directory full of 
# excel spreadsheets you want to read. You could do it with copy and paste:
data2019 <- readxl::read_excel("data/y2019.xlsx")
data2020 <- readxl::read_excel("data/y2020.xlsx")
data2021 <- readxl::read_excel("data/y2021.xlsx")
data2022 <- readxl::read_excel("data/y2022.xlsx")
# And then use dplyr::bind_rows() to combine them all together:
data <- bind_rows(data2019, data2020, data2021, data2022)
data
# You can imagine that this would get tedious quickly, especially if you 
# had hundreds of files, not just four. The following sections show you 
# how to automate this sort of task. There are three basic steps: 
# 1. use list.files() to list all the files in a directory, 
# 2. then use purrr::map() to read each of them into a list, 
# 3. then use purrr::list_rbind() to combine them into a single data frame.


# 26.3.1 Listing files in a directory ====
# list.files() lists the files in a directory. You’ll almost always use 
# three arguments:
# 1. The first argument, path, is the directory to look in.
# 2. pattern is a regular expression used to filter the file names.
# 3. full.names determines whether or not the directory name should be 
#    included in the output. You almost always want this to be TRUE.
# Example code.
paths <- list.files(
    path = "data/gapminder", 
    pattern = "[.]xlsx$",
    full.names = T
)
paths
length(paths)


# 26.3.2 Lists ====
# Now that we have these 12 paths, we could call read_excel() 12 times to 
# get 12 dataframes. 
gapminder_1952 <- readxl::read_excel("data/gapminder/1952.xlsx")
gapminder_1957 <- readxl::read_excel("data/gapminder/1957.xlsx")
gapminder_1962 <- readxl::read_excel("data/gapminder/1962.xlsx")
gapminder_1967 <- readxl::read_excel("data/gapminder/1967.xlsx")
gapminder_1972 <- readxl::read_excel("data/gapminder/1972.xlsx")
gapminder_1977 <- readxl::read_excel("data/gapminder/1977.xlsx")
gapminder_1982 <- readxl::read_excel("data/gapminder/1982.xlsx")
gapminder_1987 <- readxl::read_excel("data/gapminder/1987.xlsx")
gapminder_1992 <- readxl::read_excel("data/gapminder/1992.xlsx")
gapminder_1997 <- readxl::read_excel("data/gapminder/1997.xlsx")
gapminder_2002 <- readxl::read_excel("data/gapminder/2002.xlsx")
gapminder_2007 <- readxl::read_excel("data/gapminder/2007.xlsx")

# But putting each sheet into its own variable is going to make it hard to 
# work with them a few steps down the road. Instead, they’ll be easier to 
# work with if we put them into a single object. 
# A list is the perfect tool for this job:
files <- list(
    readxl::read_excel("data/gapminder/1952.xlsx"),
    readxl::read_excel("data/gapminder/1957.xlsx"),
    readxl::read_excel("data/gapminder/1962.xlsx"),
    readxl::read_excel("data/gapminder/1967.xlsx"),
    readxl::read_excel("data/gapminder/1972.xlsx"),
    readxl::read_excel("data/gapminder/1977.xlsx"),
    readxl::read_excel("data/gapminder/1982.xlsx"),
    readxl::read_excel("data/gapminder/1987.xlsx"),
    readxl::read_excel("data/gapminder/1992.xlsx"),
    readxl::read_excel("data/gapminder/1997.xlsx"),
    readxl::read_excel("data/gapminder/2002.xlsx"),
    readxl::read_excel("data/gapminder/2007.xlsx")
)

# Now that you have these dataframes in a list, you can use 
# files[[i]] to extract the ith element.
files[[3]]


# 26.3.3 purrr:map() and list_rbind() ====
# The code to read the files one-by-one by hand is tedious. Happily, we can 
# use purrr::map() to make even better use of our paths vector.

# Using map() to get a list of 12 dataframes.
files <- map(paths, readxl::read_excel)
length(files)
files[[1]]
# Now we can use purrr::list_rbind() to combine that list of dataframes 
# into a single data frame:
list_rbind(files)
# Or we could do both steps at once in a pipeline:
paths |> 
    map(readxl::read_excel) |> 
    list_rbind()

# What if we want to pass in extra arguments to read_excel()? We use the 
# same technique that we used with across().
# CASE: Peek at the first few rows of the data with n_max = 1 while importing.
paths |> 
    map(function(path) readxl::read_excel(path, n_max = 1)) |> 
    list_rbind()
# Something is missing: there’s no year column because that value is 
# recorded in the path, not in the individual files.


# 26.3.4 Data in the path ====
# Sometimes the name of the file is data itself. In this example, the file 
# name contains the year, which is not otherwise recorded in the individual 
# files. 
# To get that column into the final dataframe, we need to do two things:
# First, we name the vector of paths. 
paths |> set_names(basename)
# Those names are automatically carried along by all the map functions, so 
# the list of dataframes will have those same names:
files <- paths |> 
    set_names(basename) |> 
    map(readxl::read_excel)
# The above call to map() is shorthand for:
# files <- list(
#     "1952.xlsx" = readxl::read_excel("data/gapminder/1952.xlsx"),
#     "1957.xlsx" = readxl::read_excel("data/gapminder/1957.xlsx"),
#     "1962.xlsx" = readxl::read_excel("data/gapminder/1962.xlsx"),
#     "1967.xlsx" = readxl::read_excel("data/gapminder/1967.xlsx"),
#     "1972.xlsx" = readxl::read_excel("data/gapminder/1972.xlsx"),
#     "1977.xlsx" = readxl::read_excel("data/gapminder/1977.xlsx"),
#     "1982.xlsx" = readxl::read_excel("data/gapminder/1982.xlsx"),
#     "1987.xlsx" = readxl::read_excel("data/gapminder/1987.xlsx"),
#     "1992.xlsx" = readxl::read_excel("data/gapminder/1992.xlsx"),
#     "1997.xlsx" = readxl::read_excel("data/gapminder/1997.xlsx"),
#     "2002.xlsx" = readxl::read_excel("data/gapminder/2002.xlsx"),
#     "2007.xlsx" = readxl::read_excel("data/gapminder/2007.xlsx")
# )

# Now, we can also use [[ to extract elements by name:
files[["1962.xlsx"]]
# Then we use the names_to argument to list_rbind() to tell it to save the 
# names into a new column called year then use readr::parse_number() to 
# extract the number from the string.
paths |> 
    set_names(basename) |> 
    map(readxl::read_excel) |> 
    list_rbind(names_to = "year") |> 
    mutate(
        year = parse_number(year)
    )

# In more complicated cases, there might be other vars stored in the 
# directory name, or maybe the file name contains multiple bits of data. 
# In that case, use set_names() (without any args) to record the full path, 
# and then use tidyr::separate_wider_delim() and friends to turn them into 
# useful columns.
paths |> 
    set_names() |> 
    map(readxl::read_excel) |> 
    list_rbind(names_to = "year") |> 
    separate_wider_delim(year, delim = "/", names = c(NA, "dir", "file")) |> 
    separate_wider_delim(file, delim = ".", names = c("year", "ext"))


# 26.3.5 Save your work ====
# Now that we have done all this hard work to get to a nice tidy dataframe
# it’s a great time to save your work:
paths <- list.files(
    path = "data/gapminder", 
    pattern = "[.]xlsx$",
    full.names = T
)

gapminder <- paths |> 
    set_names(basename) |> 
    map(readxl:read_excel) |> 
    list_rbind(names_to = "year") |> 
    mutate(year = parse_number(year))
write_csv(gapminder, "gapminder.csv")
# Now when you come back to this problem in the future, you can read in a 
# single csv file. 


# 26.3.6 Many simple iterations ====
# In most cases, you’ll need to do some additional tidying, and you have 
# two basic options: 
# 1. you can do one round of iteration with a complex function, or 
# 2. do multiple rounds of iteration with simple functions.
# While most folks reach first for one complex iteration, but you are often 
# better by doing multiple simple iterations.

# CASE: You want to read in a bunch of files, filter out missing values, 
#       pivot, and then combine.
# We can use complex iteration.
process_file <- function(path) {
    df <- readxl::read_csv(path)
    df |> 
        filter(!is.na(id)) |> 
        mutate(id = tolower(id)) |> 
        pivot_longer(jan:dec, names_to = "month")
}
paths |> 
    purrr::map(process_file) |> 
    list_rbind()
# GIVES ERROR.

# Altly, we could use multiple simple iterations.
paths |> 
    map(read_csv) |> 
    map(function(df) df |> filter(!is.na(id))) |> 
    map(function(df) df |> mutate(id = tolower(id))) |> 
    map(function(df) df |> pivot_longer(jan:dec, names_to = "month")) |> 
    list_rbind()
# GIVES ERROR.


# 26.3.7 Heterogeneous data ====
# Unfortunately, sometimes it’s not possible to go from map() straight to 
# list_rbind() as the dataframes are so heterogeneous that list_rbind() 
# either fails or yields a data frame that’s not very useful.
# In that case, it’s still useful to start by loading all of the files:
files <- paths |> 
    map(readxl::read_excel)
# Then a very useful strategy is to capture the structure of the dataframes 
# so that you can explore it using your data science skills.
# For this we use df_types fn that returns a tibble with 1 row for each col.
df_types <- function(df) {
    tibble(
        col_name = names(df),
        col_type = map_chr(df, vctrs::vec_ptype_full),
        n_miss = map_int(df, function(x) sum(is.na(x)))
    )
}
# function type
df_types(gapminder)
# You can then apply this fn to all of the files, and maybe do some pivoting 
# to make it easier to see where the differences are.
files |> 
    map(df_types) |> 
    list_rbind(names_to = "file_name") |> 
    select(-n_miss) |> 
    pivot_wider(names_from = col_name, values_from = col_type)
# If the files have heterogeneous formats, you might need to do more 
# processing before you can successfully merge them. You might want to read 
# about map_if() and map_at().


# 26.3.8 Handling failures ====
# One of the downsides of map() is it succeeds or fails as a whole. map()
# will either successfully read all of the files in a directory or fail 
# with an error, reading zero files.
# Luckily, purrr comes with a helper to tackle this problem: possibly(). 
# possibly() is what’s known as a function operator: it takes a fn and 
# returns a fn with modified behaviour. possibly() changes a fn from 
# erroring to returning a value that you specify 
files <- paths |> 
    map(
        possibly(\(path) readxl::read_excel(path), NULL)
    )
data <- files |> list_rbind()
data

# Now you have all the data that can be read easily, and it’s time to tackle 
# the hard part of figuring out why some files failed to load and what to do 
# about it. Start by getting the paths that failed:
failed <- map_vec(files, is.null)
paths[failed]
# Then call the import fn again for each failure and find out what went wrong.


# 26.4 Saving multiple outputs --------------------------------------------
# In this section, we’ll now explore sort of the opposite problem: how can 
# you take one or more R objects and save it to one or more files?
# Let's do it!

# 26.4.1 Writing to a database ====
# We start by creating a table that we will fill in with data. The easiest 
# way to do this is by creating a template, a dummy dataframe that contains 
# all the cols we want, but only a sampling of the data. 
# For the gapminder data, we can make that template by reading a single file
# and adding the year to it:
paths <- list.files(
    path = "data/gapminder", 
    pattern = "[.]xlsx$",
    full.names = T
)
template <- readxl::read_excel(paths[[1]])
template$year <- 1952
template

# Now we can connect to the database, and use DBI::dbCreateTable() to 
# turn our template into a database table:
con <- DBI::dbConnect(duckdb::duckdb())
DBI::dbCreateTable(con, "gapminder", template)

# dbCreateTable() doesn’t use the data in template, just the var names 
# and types. So if we inspect the gapminder table now you’ll see that 
# it’s empty but it has the variables we need with the types we expect:
con |> tbl("gapminder")

# Next, we need a fn that takes a single file path, reads it into R, and 
# adds the result to the gapminder table. We can do that by combining 
# read_excel() with DBI::dbAppendTable():
append_file <- function(path) {
    df <- readxl::read_excel(path)
    # df$year <- parse_number(basename(path))
    # this line gives ERROR
    
    DBI::dbAppendTable(con, "gapminder", df)
}
# ERROR

# Now we need to call append_file() once for each element of paths.
paths |> map(append_file)
# But we don’t care about the output of append_file(), so instead of map() 
# it’s slightly nicer to use walk(). walk() does exactly the same thing 
# as map() but throws the output away:
paths |> walk(append_file)

# Now we can see if we have all the data in our table:
con |> 
    tbl("gapminder") # |> count(year)


# 26.4.2 Writing csv files ====
# Imagine that we want to take the ggplot2::diamonds data and save one 
# csv file for each clarity. First we need to make individual datasets.
# There are many ways you could do that, but there’s one way we particularly
# like: group_nest()
by_clarity <- diamonds |> 
    group_nest(clarity)
by_clarity
# This gives us a new tibble with eight rows and two cols. clarity is our 
# grouping var and data is a list-column containing one tibble for each 
# unique value of clarity.
by_clarity$data[[1]]
# Let’s create a column that gives the name of output file.
by_clarity <- by_clarity |>
    mutate(path = str_glue("diamonds-{tolower({clarity})}.csv"))
by_clarity

# To save these datasets by hand we might write something like:
# write_csv(by_clarity$data[[1]], by_clarity$path[[1]])
# write_csv(by_clarity$data[[2]], by_clarity$path[[2]])
# write_csv(by_clarity$data[[3]], by_clarity$path[[3]])
# write_csv(by_clarity$data[[4]], by_clarity$path[[4]])
# write_csv(by_clarity$data[[5]], by_clarity$path[[5]])
# write_csv(by_clarity$data[[6]], by_clarity$path[[6]])
# write_csv(by_clarity$data[[7]], by_clarity$path[[7]])
# write_csv(by_clarity$data[[8]], by_clarity$path[[8]])

# We use our function from previous section.
walk2(by_clarity$data, by_clarity$path, write_csv)


# 26.4.3 Saving plots ====
# We can take the same basic approach to create many plots. 
# Let’s first make a function that draws the plot we want:
carat_histogram <- function(df) {
    ggplot(data = df, aes(x = carat)) +
        geom_histogram(binwidth = 0.1)
}
# function check.
carat_histogram(by_clarity$data[[1]])

# Now we can use map() to create a list of many plots and 
# their eventual file paths:
by_clarity <- by_clarity |> 
    mutate(
        plot = map(data, carat_histogram),
        path = str_glue("clarity-{clarity}.png")
    )
by_clarity
# Then use walk2() with ggsave() to save each plot:
walk2(
    by_clarity$path,
    by_clarity$plot,
    function(path, plot) ggsave(path, plot, width = 6, height = 6)
)

# This is shorthand for:
# ggsave(by_clarity$path[[1]], by_clarity$plot[[1]], width = 6, height = 6)
# ggsave(by_clarity$path[[2]], by_clarity$plot[[2]], width = 6, height = 6)
# ggsave(by_clarity$path[[3]], by_clarity$plot[[3]], width = 6, height = 6)
# ggsave(by_clarity$path[[4]], by_clarity$plot[[4]], width = 6, height = 6)
# ggsave(by_clarity$path[[5]], by_clarity$plot[[5]], width = 6, height = 6)
# ggsave(by_clarity$path[[6]], by_clarity$plot[[6]], width = 6, height = 6)
# ggsave(by_clarity$path[[7]], by_clarity$plot[[7]], width = 6, height = 6)
# ggsave(by_clarity$path[[8]], by_clarity$plot[[8]], width = 6, height = 6)


# 26.5 Summary ------------------------------------------------------------
# NO CODE.




#_====
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# C27 - A field guide to base R -------------------------------------------
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# To finish off the programming section, we’re going to give you a quick 
# tour of the most important base R fns that we don’t otherwise discuss 
# in the book. These tools are particularly useful as you do more 
# programming and will help you read code you’ll encounter in the wild.
# This is a good place to remind you that the tidyverse is not the only 
# way to solve data science problems. It’s not possible to use the tidyverse 
# without using base R.


# 27.1 Prerequisites ------------------------------------------------------
library(tidyverse)


# 27.2 Selecting multiple elements with [ ---------------------------------
# [ is used to extract sub-components from vectors and dataframes and 
# is called like x[i] or x[i, j].

# 27.2.1 Subsetting vectors ====
# There are five main types of things that you can subset a vector with:
# 1. A vector of positive integers. Subsetting with positive integers 
# keeps the elements at those positions
x <- c("one", "two", "three", "four", "five")
x[c(3, 2, 5)]
# By repeating a position, you can actually make a longer output than input 
# making the term “subsetting” a bit of a misnomer.
x[c(1, 1, 5, 5, 5, 2)]

# 2. A vector of negative integers. Negative values drop the elements at 
# the specified positions
x[c(-1, -3, -5)]

# 3. A logical vector. Subsetting with a logical vector keeps all values 
# corresponding to a TRUE value. This is most often useful in conjunction 
# with the comparison functions.
x <- c(10, 3, NA, 5, 8, 1, NA)
# All non-missing values of x
x[!is.na(x)]
# All even (or missing) values of x
x[x %% 2 == 0]

# 4. A character vector. If you have a named vector, you can subset it 
# with a character vector.
x <- c(abc = 1, def = 2, xyz = 5)
x[c("xyz", "def")]

# 5. Nothing. The final type of subsetting is nothing, x[], which returns 
# the complete x.


# 27.2.2 Subsetting dataframes ====
# There are quite a few different ways that you can use [ with a dataframe.
# The most important way is to select rows and columns independently with 
# df[rows, cols]. For example, df[rows, ] and df[, cols] select just 
# rows or just cols, using the empty subset to preserve the other dimension.
df <- tibble(
    x = 1:3,
    y = c("a", "e", "f"),
    z = runif(3)
)
df
# Select first row and second column
df[1, 2]
# Select all rows and columns x and y
df[, c("x", "y")]
# Select rows where `x` is greater than 1 and all columns
df[x > 1, ]

# In most places, you can use “tibble” and “data frame” interchangeably.
# There’s an important difference between tibbles and dataframes.
#  If df is a data.frame, then df[, cols] will return a vector if col 
#  selects a single col and a data frame if it selects more than one col. 
#  If df is a tibble, then [ will always return a tibble.
df1 <- data.frame(x = 1:3)
df1[, "x"]
df2 <- tibble(x = 1:3)
df2[, "x"]
# One way to avoid this ambiguity with data.frames is to explicitly 
# specify drop = FALSE:
df1[ , "x", drop = FALSE]


# 27.2.3 dplyr equivalents ====
# Several dplyr verbs are special cases of "[".
# 1. filter() is equivalent to subsetting the rows with a logical vector 
# taking care to exclude missing values.
df <- tibble(
    x = c(2, 3, 1, 1, NA),
    y = letters[1:5],
    z = runif(5)
)
df
df |> filter(x > 1)
# same as
df[!is.na(df$x) & (df$x > 1), ]

# 2. arrange() is equivalent to subsetting the rows with an integer vector 
# usually created with order().
df
df |> arrange(x, y)
# same as
df[order(df$x, df$y), ]

# 3. Both select() and relocate() are similar to subsetting the columns 
# with a character vector
df |> select(x, z)
# same as
df[ , c("x", "z")]

# 4. Base R also provides a fn that combines the features of filter() and 
# select() called subset():
df |> filter(x > 1) |> select(y, z)
# same as
df |> subset(x > 1, c(y, z))


# 27.3 Selecting a single element with $ and [[ ---------------------------
# [, which selects many elements, is paired with [[ and $, which extracts
# a single element.

# 27.3.1 Data frames ====
# [[ and $ can be used to extract cols out of a data frame. [[ can access 
# by position or by name, and $ is specialized for access by name.
tb <- tibble(
    x = 1:4,
    y = c(10, 4, 1, 21)
)
tb
# by position
tb[[1]]
# by name
tb[["x"]]
tb$x

# They can also be used to create new cols, the base R equivalent of mutate()
tb$z <- tb$x + tb$y
tb
# There are several other base R approaches to creating new cols including 
# with transform(), with(), and within().

# Using $ directly is convenient when performing quick summaries. 
# CASE: If you just want to find the size of the biggest diamond or the 
# possible values of cut, there’s no need to use summarize():
max(diamonds$carat)
levels(diamonds$cut)

# dplyr also provides an alt to [[/$ that we didn’t mention earlier: pull().
# pull() takes either a var name or var position and returns just that col.
diamonds |> pull(carat) |> max()
diamonds |> pull(cut) |> levels()


# 27.3.2 Tibbles ====
# There are some important differences between tibbles and base data.frames 
# when it comes to $. 
# Dataframes match the prefix of any var names (so-called partial matching) 
# and don’t complain if a column doesn’t exist:
df <- data.frame(x1 = 1)
df
df$x
df$z

# Tibbles are more strict: they only ever match var names exactly and they 
# will generate a warning if the col you are trying to access doesn’t exist.
tb <- tibble(x1 = 1)
tb
tb$x
tb$z
# For this reason we sometimes joke that tibbles are lazy and surly: 
# they do less and complain more.


# 27.3.3 Lists ====
# [[ and $ are also really important for working with lists, and it’s 
# important to understand how they differ from [.
l <- list(
    a = 1:3,
    b = "a string",
    c = pi,
    d = list(-1, -5)
)
l

# 1. [ extracts a sub-list. It doesn’t matter how many elements you extract 
# the result will always be a list.
str(l[1:2])
str(l[1])
str(l[4])

# 2. [[ and $ extract a single component from a list. They remove a 
# level of hierarchy from the list.
str(l[[1]])
str(l[[4]])
str(l$a)

# The difference between [ and [[ is particularly important for lists 
# because [[ drills down into the list while [ returns a new, smaller list.


# 27.4 Apply family -------------------------------------------------------
# Previously, we learned tidyverse techniques for iteration like 
# dplyr::across() and the map family of functions. 
# In here, you’ll learn about their base equivalents, the apply family.

# Let's get a quick overview of this family so we can recognize them 
# in the wild.
df <- tibble(a = 1, b = 2, c = "a", d = "b", e = 4)
df
# First find numeric columns
num_cols <- sapply(df, is.numeric)
num_cols
# Then transform each column with lapply() then replace the original values
df[ , num_cols] <- lapply(df[ , num_cols, drop = FALSE], function(x) x * 2)
df
# The code above uses a new fn sapply(). It’s similar to lapply() but it 
# always tries to simplify the result, hence the s in its name, here 
# producing a logical vector instead of a list. 
# We don’t recommend using it for programming, because the simplification 
# can fail and give you an unexpected type, but it’s usually fine for 
# interactive use. 
# purrr has a similar function called map_vec() that we didn’t mention 
# in Chapter 26.
vapply(df, is.numeric, logical(1))

# Another important member of the apply family is tapply() which computes 
# a single grouped summary:
diamonds |> 
    group_by(cut) |> 
    summarize(price = mean(price))
# same as
tapply(diamonds$price, diamonds$cut, mean)
# Unfortunately tapply() returns its results in a named vector which 
# requires some gymnastics if you want to collect multiple summaries 
# and grouping variables into a dataframe.


# 27.5 for loops ----------------------------------------------------------
paths <- list.files(
    path = "data/gapminder", 
    pattern = "[.]xlsx$",
    full.names = T
)
paths
length(paths)

# The most straightforward use of for loops is to achieve the same effect 
# as walk(): call some function with a side-effect on each element of a list.
paths |> map(append_file)
# ERROR


# 27.6 Plots --------------------------------------------------------------
# Many R users who don’t otherwise use the tidyverse prefer ggplot2 for 
# plotting due to helpful features like sensible defaults, automatic 
# legends, and a modern look. 
# However, base R plotting functions can still be useful because they’re 
# so concise — it takes very little typing to do a basic exploratory plot.

# Examples of base R plot from the diamonds dataset.
hist(diamonds$carat)
plot(diamonds$carat, diamonds$price)
# NOTE: Base plotting functions work with vectors, so you need to pull 
#       columns out of the data frame using $ or some other technique.


# 27.7 Summary ------------------------------------------------------------
# NO CODE.







