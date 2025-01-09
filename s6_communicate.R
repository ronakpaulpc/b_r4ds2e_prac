# Code from book R for Data Science (2nd Edition) by Hadley Wickham and co.
# Here we have script files for each book section.
# Then, in each script file we have code sections for each chapter.
# This script contains code from the "Communicate" section of the book.

# So far, you’ve learned the tools to get your data into R, tidy it into a 
# form convenient for analysis, and then understand your data through 
# transformation, and visualization. 
# However, it doesn’t matter how great your analysis is unless you can 
# explain it to others: you need to communicate your results.

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
# C28 - Quarto ------------------------------------------------------------
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Quarto provides a unified authoring framework for data science, 
# combining your code, its results, and your prose. Quarto documents 
# are fully reproducible and support dozens of output formats, 
# like PDFs, Word files, presentations, and more.

# Quarto files are designed to be used in three ways:
# 1. For communicating to decision-makers, who want to focus on the 
#    conclusions, not the code behind the analysis.
# 2. For collaborating with other data scientists (including future you!), 
#    who are interested in both your conclusions, and how you reached them 
#    (i.e. the code).
# 3. As an environment in which to do data science, as a modern-day lab 
#    notebook where you can capture not only what you did, but also what 
#    you were thinking.

# Quarto is a command line interface tool, not an R package. 
# This means that help is, by-and-large, not available through ?. 
# Instead, as you work through this chapter, and use Quarto in the future, 
# you should refer to the Quarto documentation.


# 28.1 Prerequisites ------------------------------------------------------
# You need the Quarto command line interface (Quarto CLI), but you 
# don’t need to explicitly install it or load it, as RStudio 
# automatically does both when needed.


# 28.2 Quarto basics ------------------------------------------------------


# NO CODE.





















