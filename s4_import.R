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
# Microsoft Excel is a widely used spreadsheet software program where
# - data are organized in worksheets inside of spreadsheet files.


# 20.2.2 Getting started ====
# Most of readxl’s functions allow you to load Excel spreadsheets into R:
# read_xls() reads Excel files with xls format.
# read_xlsx() read Excel files with xlsx format.
# read_excel() can read files with both xls and xlsx format. It guesses the 
# file type based on the input.

# NOTE: For the rest of the chapter we will focus on using read_excel().


# 20.2.3 Reading excel spreadsheets ====





# TBC ####



#_====
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# C24 - Web scraping ------------------------------------------------------
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
























