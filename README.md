# GettingandCleaningData

There are thre files in this repository:
  README.md - a description of the files, how the code works, and a code book.\n
  run_analysis.R - the actual program that transforms the raw Samsung data into a tidy dataset.
  code_book.txt - an explanation of the variables along with a summary of their origin that is expanded on in the Samsung
                  dataset.
                  
run_analyis.R
  I tried to use inline documentation as much as possible, and I hope that it is useful.  dplyr is used for much
  of the formatting.  The script assumes that the dataset is placed in the same directory that the script is in.
  
  After setting the various directories for files needed by the script, it reads in the variable name information
  provided as part of the dataset documentation, and renames the columns to use those variable names.  The column
  names are cleaned up to eliminate hyphens which R does not permit in column names.  Training data are read, the
  subject id added to the row, and column names assigned; the process is then repeated with the test data.  All are
  then converted from data frames into dplyr tables.
  
  The column headers are renamed using the list in the features.txt file from the UCI HAR Dataset.  A sequence ID is
  added to each of the tables to make joins using inner_join() possible.  Several inner_joins are executed to combine
  all of the intermediate data tables into a single combined data set called CombinedData.  Columns with mean and std
  in their name are selected for analysis.  The data to be analyzed are grouped on Activity Name and Subject ID, and then
  summarise_each is applied to each column in the table and saved.  This creates our tidyData dataset, which is then
  written to the tidy_data.txt file as a tab delimited file with the paramater rownames=FALSE.
  
  

