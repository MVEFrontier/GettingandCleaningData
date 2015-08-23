# GettingandCleaningData

There are thre files in this repository:
  README.md - a description of the files, how the code works, and a code book.\n
  run_analysis.R - the actual program that transforms the raw Samsung data into a tidy dataset.
  code_book.txt - an explanation of the variables along with a summary of their origin that is expanded on in the Samsung
                  dataset.
                  
run_analyis.R
  I tried to use inline documentation as much as possible, and I hope that it is useful.  dplyr is used for much
  of the formatting.  The script assumes that the dataset is placed in the same directory that the script is in.
  
  After setting the various directories for files needed by the script, it reads in the column name information
  provided as part of the dataset documentation.  The column names are cleaned up to eliminate hyphens which R does
  not permit in column names.  Training data are read, the subject id added to the row, and column names assigned; the
  process is then repeated with the test data.
