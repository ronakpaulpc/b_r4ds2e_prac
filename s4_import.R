# Code from book R for Data Science (2nd Edition) by Hadley Wickham and co.
# Here we have script files for each book section.
# Then, in each script file we have code sections for each chapter.
# This script contains code from the "Import" section of the book.
# In this part of the book you’ll learn how to access data stored as
# - spreadsheets, databases, arrow format, hierarchical data and web scraping.

# There are two important tidyverse packages that we won’t discuss here:
# > haven, for working with data from SPSS, STATA, and SAS files, and
# > xml2, for working with XML data.

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
    "readxl",                       # For reading in excel files
    "repurrrsive",
    "tidymodels",
    "writexl"                       # For writing out excel files
)
# p_loaded()                        # checking the loaded packages
# unloadNamespace("writexl")        # Unloading a pkg



#_====
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# C20 - Spreadsheets ------------------------------------------------------
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Here we learn how to get data out of a spreadsheet, either an 
# - Excel spreadsheet or a Google Sheet. This will build on much of what
# - you have learned in Chapter 7, but we will also discuss additional 
# - considerations and complexities when working with data from spreadsheets.
# If you or your collaborators are using spreadsheets for organizing data
# - we strongly recommend reading “Data Organization in Spreadsheets” paper
# - by Karl Broman and Kara Woo.


# 20.1 Prerequisites ------------------------------------------------------
library(readxl)         # load data from excel spreadsheets
library(tidyverse)
library(writexl)        # create excel spreadsheets


# 20.2 Excel --------------------------------------------------------------
# Microsoft Excel is a widely used spreadsheet software program where data
# are organized in worksheets inside of spreadsheet files. Here, we learn 
# how to load data from Excel spreadsheets in R with the readxl package. 
# This package is non-core tidyverse, so you need to load it explicitly.
# We also use the writexl package to create Excel spreadsheets.


# 20.2.2 Getting started ====
# Most of readxl’s functions allow you to load Excel spreadsheets into R:
# read_xls() reads Excel files with xls format.
# read_xlsx() read Excel files with xlsx format.
# read_excel() can read files with both xls and xlsx format. It guesses the 
# file type based on the input.
# NOTE: For the rest of the chapter we will focus on using read_excel().


# 20.2.3 Reading excel spreadsheets ====
# Here read_excel() will read the file in as a tibble. The first argument 
# to read_excel() is the path to the file to read.
students <- read_excel("data/students.xlsx")
students
# We have six students in the data and five variables on each student. 
# However there are a few problems that we need to address in this dataset.

# Problem 1: The column names are all over the place.
# We can modify var names to snake_case using the col_names argument.
read_excel(
    "data/students.xlsx",
    col_names = c("student_id", "full_name", "favourite_food", 
                  "meal_plan", "age")
)
# Unfortunately, this didn’t quite do the trick. We now have the var names 
# we want, but what was previously the header row now shows up as the 
# first observation in the data. 
# You can explicitly skip that row using the skip argument.
read_excel(
    "data/students.xlsx",
    col_names = c("student_id", "full_name", "favourite_food",
                  "meal_plan", "age"),
    skip = 1
)

# Problem 2: In the favourite_food column, one of the observations 
# is N/A, which stands for “not available” but it’s currently not 
# recognized as an NA.
read_excel(
    "data/students.xlsx",
    col_names = c("student_id", "full_name", "favourite_food", 
                  "meal_plan", "age"),
    skip = 1,
    na = c("", "N/A")
)

# Problem 3: Another issue is that age is read in as a character var but 
# it really should be numeric.
# We can supply a col_types argument to read_excel() and specify the 
# col types for the variables.
read_excel(
    "data/students.xlsx",
    col_names = c("student_id", "full_name", "favourite_food",
                  "meal_plan", "age"),
    skip = 1,
    na = c("", "N/A"),
    col_types = c("numeric", "text", "text", "text", "numeric")
)
# However, this didn’t quite produce the desired result either. 
# By specifying that age should be numeric, we have turned the one cell 
# with the non-numeric entry (which had the value five) into an NA. 
# In this case, we should read age in as "text" and then make the change 
# once the data is loaded in R.
students <- read_excel(
    "data/students.xlsx",
    col_names = c("student_id", "full_name", "favourite_food",
                  "meal_plan", "age"),
    skip = 1,
    na = c("", "N/A"),
    col_types = c("numeric", "text", "text", "text", "text")
)
students <- students |> 
    mutate(
        age = if_else(age == "five", "5", age),
        age = parse_number(age)
    )
students
# It took us multiple steps and trial-and-error to load the data in 
# exactly the format we want, and this is not unexpected. Data science 
# is an iterative process, and the process of iteration can be even more 
# tedious when reading data in from spreadsheets compared to other 
# plain text, rectangular data files because humans tend to input data 
# into spreadsheets and use them not just for data storage but also for 
# sharing and communication.


# 20.2.4 Reading worksheets ====
# An important feature that distinguishes spreadsheets from flat files 
# is the notion of multiple sheets, called worksheets.




# TBC ####



#_====
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# C24 - Web scraping ------------------------------------------------------
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
























