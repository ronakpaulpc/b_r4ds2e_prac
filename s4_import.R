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
#         "googlesheets4",
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

# # Extra packages in this book section
# install.packages("slider")          # for complex rolling aggregates
# install.packages("RMariaDB")        # MariaDB SQL server
# install.packages("RPostgres")       # Postgre SQL server

# Loading the required packages
easypackages::libraries(
    "tidyverse",                      # Universe of data mgmt pkgs
    "arrow",
    "babynames",
    "curl",
    "DBI",
    "dbplyr",
    "duckdb",
    "gapminder",
    "ggrepel",
    "ggridges",                     # Ridgeline plots based on ggplot2
    "ggthemes",                     # Useful themes based on ggplot2
    "googlesheets4",                # For handling Google Sheets
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


# 20.2 Excel --------------------------------------------------------------
# Microsoft Excel is a widely used spreadsheet software program where data
# are organized in worksheets inside of spreadsheet files. Here, we learn 
# how to load data from Excel spreadsheets in R with the readxl package. 
# This package is non-core tidyverse, so you need to load it explicitly.
# We also use the writexl package to create Excel spreadsheets.

# 20.2.1 Prerequisites ====
library(tidyverse)
library(readxl)         # load data from excel spreadsheets
library(writexl)        # create excel spreadsheets


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
# You can read a single worksheet from a spreadsheet with the sheet argument 
# in read_excel(). 
penguins_torgersen <- read_excel(
    "data/penguins.xlsx",
    sheet = "Torgersen Island"
)
# check
penguins_torgersen |> print(n = 100)

# Some variables that appear to contain numerical data are read in as 
# characters due to the character string "NA" not being recognized 
# as a true NA.
penguins_torgersen <- read_excel(
    "data/penguins.xlsx",
    sheet = "Torgersen Island",
    na = "NA"
)
# check
penguins_torgersen |> print(n = 100)

# Altly, you can use excel_sheets() to get information on all worksheets 
# in an Excel spreadsheet, and then read the one(s) you’re interested in.
excel_sheets("data/penguins.xlsx")
# Once you know the names of the worksheets, you can read them in.
# Read sheet for Biscoe Island
penguins_biscoe <- read_excel(
    "data/penguins.xlsx",
    sheet = "Biscoe Island",
    na = "NA"
)
penguins_biscoe |> head()
# Read sheet for Dream Island
penguins_dream <- read_excel(
    "data/penguins.xlsx",
    sheet = "Dream Island",
    na = "NA"
)
penguins_dream |> head()

# In this case the full penguins dataset is spread across 3 worksheets 
# in the spreadsheet. Each worksheet has the same number of columns but 
# different numbers of rows.
dim(penguins_torgersen)
dim(penguins_biscoe)
dim(penguins_dream)
# We can put them together with bind_rows().
penguins <- bind_rows(penguins_torgersen, penguins_biscoe, penguins_dream)
penguins


# 20.2.5 Reading part of a sheet ====
# Since many use Excel spreadsheets for presentation as well as for 
# data storage, it’s quite common to find cell entries in a spreadsheet 
# that are not part of the data you want to read into R.
# The readxl package has one such example spreadsheet where the 
# actual dataframe is in the middle of the sheet but there is 
# extraneous text in cells above and below the data.

# You can use the readxl_example() function to locate the spreadsheet on 
# your system in the directory where the package is installed. This fn 
# returns the path to the spreadsheet, which you can use in 
# read_excel() as usual.
deaths_path <- readxl_example("deaths.xlsx")
deaths_path
deaths <- read_excel(deaths_path)
deaths
# The top three rows and the bottom four rows are not part of the dataframe. 
# It’s possible to eliminate these extraneous rows using the skip and 
# n_max arguments, but we recommend using cell ranges. 
# In Excel, the top left cell is A1. As you move across columns to the 
# right, the cell label moves down the alphabet, i.e. B1, C1, etc. 
# And as you move down a column, the number in the cell label increases, 
# i.e. A2, A3, etc.
# Here the data we want to read in starts in cell A5 and ends in cell F15. 
# In spreadsheet notation, this is A5:F15, which we supply to the range 
# argument.
deaths <- read_excel(deaths_path, range = "A5:F15")
deaths


# 20.2.6 Data types ====
# In CSV files, all values are strings. This is not particularly true to 
# the data, but it is simple: everything is a string.
# The underlying data in Excel spreadsheets is more complex. A cell can be 
# one of four things:
# 1. A boolean, like TRUE, FALSE, or NA.
# 2. A number, like “10” or “10.5”.
# 3. A datetime, which can also include time like “11/1/21” or 
#    “11/1/21 3:00 PM”.
# 4. A text string, like “ten”.

# NO CODE.


# 20.2.7 Writing to Excel ====
# Let’s create a small data frame that we can then write out. 
# Note that item is a factor and quantity is an integer.
bake_sale <- tibble(
    item        = factor(c("brownie", "cupcake", "cookie")),
    quantity    = c(10, 5, 8)
)
bake_sale
# You can write data back to disk as an Excel file using the 
# write_xlsx() function from the writexl package.
write_xlsx(bake_sale, path = "data/bake-sale.xlsx")
# Note that column names are included and bolded. These can be turned off 
# by setting col_names and format_headers arguments to FALSE.

# Just like reading from a CSV, information on data type is lost when we 
# read the data back in. This makes Excel files unreliable for caching 
# interim results as well.
read_excel("data/bake-sale.xlsx")


# 20.2.8 Formatted output ====
# The writexl package is a light-weight solution for writing a simple 
# Excel spreadsheet, but if you’re interested in additional features 
# like writing to sheets within a spreadsheet and styling, you will 
# want to use the openxlsx package.
# Note that this package is not part of the tidyverse so the functions 
# and workflows may feel unfamiliar. For example, function names are 
# camelCase, multiple functions can’t be composed in pipelines, and 
# arguments are in a different order than they tend to be in the tidyverse.

# NO CODE.



# 20.3 Google Sheets ------------------------------------------------------
# Google Sheets is another widely used spreadsheet program. It’s free and 
# web-based. Just like with Excel, in Google Sheets data are organized 
# in worksheets (also called sheets) inside of spreadsheet files.

# 20.3.1 Prerequisites ====
# This section will also focus on spreadsheets, but this time you’ll be 
# loading data from a Google Sheet with the googlesheets4 package. 
# This package is non-core tidyverse as well, you need to load it explicitly.
library(googlesheets4)
library(tidyverse)


# 20.3.2 Getting started ====
# The main function of the googlesheets4 package is read_sheet(), which 
# reads a Google Sheet from a URL or a file id. This function also goes 
# by the name range_read(). You can also create a brand new sheet with 
# gs4_create() or write to an existing sheet with sheet_write() and friends.

# NO CODE.


# 20.3.3 Reading Google Sheets ====
# Here we will read in the same sheet in excel section except its now a 
# Google sheet. The first argument to read_sheet() is the URL of the file 
# to read, and it returns a tibble. These URLs are not pleasant to work 
# with, so you’ll often want to identify a sheet by its ID.
# First, we suspend authorization
gs4_deauth()
# Now we read the sheet
students_sheet_id <- "1V1nPp1tzOuutXFLb3G9Eyxi3qxeEhnOXUzL5_BcCQ0w"
students_sheet_id
students <- read_sheet(students_sheet_id)
students
# Just like we did with read_excel(), we can supply column names, 
# NA strings, and column types to read_sheet().
students <- read_sheet(
    students_sheet_id,
    col_names = c("student_id", "full_name", "favourite_food", 
                  "meal_plan", "age"),
    skip = 1,
    na = c("", "N/A"),
    col_types = "dcccc"
)
students
# Note that we defined column types a bit differently here, using short 
# codes. For example, “dcccc” stands for “double, character, character, 
# character, character”.

# It’s also possible to read individual sheets from Google Sheets as well. 
# Let’s read the “Torgersen Island” sheet from the penguins Google Sheet.
penguins_sheet_id <- "1aFu8lnD_g0yjF5O-K6SFgSEWiHPpgvFCF0NY9D6LXnY"
penguins_sheet_id
penguins <- read_sheet(
    penguins_sheet_id,
    sheet = "Torgersen Island"
)
penguins
# You can obtain a list of all sheets within a Google Sheet 
# with sheet_names().
sheet_names(penguins_sheet_id)

# Finally, just like with read_excel(), we can read in a portion of a 
# Google Sheet by defining a range in read_sheet(). 
# Note that we’re also using the gs4_example() function below to locate 
# an example Google Sheet that comes with the googlesheets4 package.
deaths_url <- gs4_example("deaths")
deaths_url
class(deaths_url)
# Read the sheet
deaths <- read_sheet(
    deaths_url,
    range = "A5:F15"
)
deaths


# 20.3.4 Writing to Google Sheets ====
# Let’s create a small data frame that we can then write out. 
# Note that item is a factor and quantity is an integer.
bake_sale <- tibble(
    item        = factor(c("brownie", "cupcake", "cookie")),
    quantity    = c(10, 5, 8)
)
bake_sale
# You can write from R to Google Sheets with write_sheet(). The first 
# argument is the data frame to write, and the second argument is the 
# name (or other identifier) of the Google Sheet to write to.
write_sheet(bake_sale, ss = "bake-sale")
# If you’d like to write your data to a specific (work)sheet inside a 
# Google Sheet, you can specify that with the sheet argument as well.
write_sheet(bake_sale, ss = "bake-sale", sheet = "sales")
# NOTE: Exporting Google Sheet asks for Google authorization.


# 20.3.5 Authentication ====
# While you can read from a public Google Sheet without authenticating 
# with your Google account and with gs4_deauth(), reading a private sheet 
# or writing to a sheet requires authentication so that googlesheets4 
# can view and manage your Google Sheets.

# When you attempt to read in a sheet that requires authentication 
# googlesheets4 will direct you to a web browser with a prompt to 
# sign in to your Google account and grant permission to operate 
# on your behalf with Google Sheets.

# However, if you want to specify a specific Google account, etc. you 
# can do so with gs4_auth(), e.g., gs4_auth(email = "mine@example.com")
# which will force the use of a token associated with a specific email.

# NO CODE.


# 20.4 Summary ------------------------------------------------------------
# Microsoft Excel and Google Sheets are two of the most popular 
# spreadsheet systems. Being able to interact with data stored in 
# Excel and Google Sheets files directly from R is a superpower!

# NO CODE.



#_====
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# C21 - Databases ---------------------------------------------------------
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# A huge amount of data lives in databases, so it’s essential that you know 
# how to access it. In this chapter, you’ll first learn the basics of the 
# DBI package: how to use it to connect to a database and then retrieve 
# data with a SQL query. SQL, short for structured query language, is the 
# lingua franca of databases, and is an important language for all 
# data scientists to learn. That said, we’re not going to start with SQL 
# but instead we’ll teach you dbplyr, which can translate your dplyr code 
# to the SQL.


# 21.1 Prerequisites ------------------------------------------------------
# In this chapter we will use DBI and dbplyr.
# DBI is a low-level interface that connects to databases and executes SQL.
# dbplyr is a high-level interface that translates your dplyr code to SQL 
# queries then executes them with DBI.
library(DBI)
library(dbplyr)
library(tidyverse)


# 21.2 Database basics ----------------------------------------------------
# At the simplest level, you can think about a database as a collection of 
# dataframes, called tables in database terminology. Like a dataframe a 
# database table is a collection of named columns, where every value 
# in the column is the same type.
# Databases are run by database management systems (DBMS) which come in 
# three basic forms:
# 1. Client-server DBMS run on a powerful central server, which you 
#    connect to from your computer (the client). They are great for sharing 
#    data with multiple people in an organization. Popular client-server 
#    DBMS include PostgreSQL, MariaDB, SQL Server, and Oracle.
# 2. Cloud DBMS, like Snowflake, Amazon’s RedShift, and Google’s BigQuery 
#    are similar to client server DBMS’s, but they run in the cloud. This 
#    means that they can easily handle extremely large datasets and can 
#    automatically provide more compute resources as needed.
# 3. In-process DBMS, like SQLite or duckdb, run entirely on your computer. 
#    They’re great for working with large datasets where you’re the 
#    primary user.

# NO CODE.


# 21.3 Connecting to a database -------------------------------------------
# To connect to the database from R, you’ll use a pair of packages:
# 1. You’ll always use DBI (database interface) because it provides a set 
#    of generic functions that connect to the database, upload data, run 
#    SQL queries, etc.
# 2. You’ll also use a package tailored for the DBMS you’re connecting to. 
#    This package translates the generic DBI commands into the specifics 
#    needed for a given DBMS. There is usually one package for each DBMS 
#    e.g., RPostgres for PostgreSQL and RMariaDB for MySQL.

# If you can’t find a specific package for your DBMS, you can usually use 
# the odbc package instead. This uses the ODBC protocol supported by many 
# DBMS. odbc requires a little more setup because you’ll also need to 
# install an ODBC driver and tell the odbc package where to find it.

# Concretely, you create a database connection using DBI::dbConnect(). 
# The first argument selects the DBMS, then the second and subsequent 
# arguments describe how to connect to it (i.e. where it lives and the 
# credentials that you need to access it).
# Create a MariaDB connection
con <- DBI::dbConnect(
    RMariaDB::MariaDB(),
    username = "foo"
)
# ERROR: Failed to connect: Can't connect to server on 'localhost' (10061)
# Create a Postgre SQL connection
con <- DBI::dbConnect(
    RPostgres::Postgres(),
    hostname = "databases.mycompany.com",
    port = 1234
)
# ERROR: invalid connection option "hostname"

# The precise details of the connection vary a lot from DBMS to DBMS so 
# unfortunately we can’t cover all the details here. This means you’ll need
# to do a little research on your own. Typically you can ask the other data 
# scientists in your team or talk to your DBA (database administrator).


# 21.3.1 In this book ====
# Setting up a client-server or cloud DBMS would be a pain for this book 
# so we’ll instead use an in-process DBMS that lives entirely in an 
# R package: duckdb. Thanks to the magic of DBI, the only difference 
# between using duckdb and any other DBMS is how you’ll connect to the 
# database. This makes it great to teach with because you can easily run 
# this code as well as easily take what you learn and apply it elsewhere.

# Connecting to duckdb is particularly simple because the defaults create 
# a temporary database that is deleted when you quit R. That’s great for 
# learning because it guarantees that you’ll start from a clean slate 
# every time you restart R.
con <- DBI::dbConnect(duckdb::duckdb())
con
# duckdb is a high-performance database that’s designed very much for the 
# needs of a data scientist. If you want to use duckdb for a real data 
# analysis project, you’ll also need to supply the dbdir argument to make 
# a persistent database and tell duckdb where to save it.
con <- DBI::dbConnect(duckdb::duckdb(), dbdir = "duckdb")


# 21.3.2 Load some data ====
# Since this is a new database, we need to start by adding some data. 
# Here we’ll add mpg and diamonds datasets from ggplot2 using 
# DBI::dbWriteTable(). 
# The simplest usage of dbWriteTable() needs three arguments: 
# 1. a database connection, 
# 2. the name of the table to create in the database, and 
# 3. a dataframe of data.
dbWriteTable(con, "mpg", ggplot2::mpg)
dbWriteTable(con, "diamonds", ggplot2::diamonds)
# If you’re using duckdb in a real project, we highly recommend learning 
# about duckdb_read_csv() and duckdb_register_arrow(). These give you 
# powerful and performant ways to quickly load data directly into duckdb 
# without having to first load it into R.


# 21.3.3 DBI basics ====
# You can check that the data is loaded correctly by using a couple of 
# other DBI functions.
# dbListTables() lists all tables in the database.
dbListTables(con)
# dbReadTable() retrieves the contents of a table. dbReadTable() returns 
# a data.frame so we use as_tibble() to convert it into a tibble so that 
# it prints nicely.
diamonds <- dbReadTable(con, "diamonds") |> 
    as_tibble()
class(diamonds)

# If you already know SQL, you can use dbGetQuery() to get the results of 
# running a query on the database.
sql <- "
SELECT carat, cut, clarity, color, price
FROM diamonds
WHERE price > 15000
"
dbGetQuery(con, sql) |> as_tibble()


# 21.4 dbplyr basics ------------------------------------------------------
# Now that we’ve connected to a database and loaded up some data, we can 
# start to learn about dbplyr. dbplyr is a dplyr backend, which means that 
# you keep writing dplyr code but the backend executes it differently. 
# In this, dbplyr translates to SQL.

# To use dbplyr, you must first use tbl() to create an object that 
# represents a database table.
# First we setup the database connection
con <- DBI::dbConnect(duckdb::duckdb(), dbdir = "duckdb")
# Now we create the database object
diamonds_db <- tbl(con, "diamonds")
diamonds_db
# This object is lazy; when you use dplyr verbs on it, dplyr doesn’t do 
# any work: it just records the sequence of operations that you want to 
# perform and only performs them when needed. 
# For example, take the following pipeline.
big_diamonds_db <- diamonds_db |> 
    filter(price > 15000) |> 
    select(carat:clarity, price)
big_diamonds_db
# You can tell this object represents a database query because it prints 
# the DBMS name at the top.

# You can see the SQL code generated by the dplyr function show_query(). 
# If you know dplyr, this is a great way to learn SQL! Write some dplyr code, 
# get dbplyr to translate it to SQL, and then try to figure out how the two 
# languages match up.
big_diamonds_db |> show_query()

# To get all the data back into R, you call collect(). Behind the scenes 
# this generates the SQL, calls dbGetQuery() to get the data, then turns 
# the result into a tibble
big_diamonds <- big_diamonds_db |> 
    collect()
big_diamonds
# Typically, you’ll use dbplyr to select the data you want from the 
# database, performing basic filtering and aggregation using the 
# translations described below. Then, once you’re ready to analyse the data 
# with functions that are unique to R, you’ll collect() the data to get an 
# in-memory tibble, and continue your work with pure R code.


# 21.5 SQL ----------------------------------------------------------------


# TBC ####








#_====
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# C24 - Web scraping ------------------------------------------------------
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



# TBC ####





















