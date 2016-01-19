# Get_Clean_data_project
## This repo is for final course project.

This analysis uses data downloaded from the following url:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The raw data includes two sets - test and training sets, which include many measurements on 30 subjects of 6 types of activity.

The goal of this analysis is to create a tidy data set for future analysis. 
To clean the data set, this involves steps such as:
1. merge the data set
2. extract certain useful measurements
3. label the variables with meaningful words
4. average over multiple observations

The code book that describes the variables, the data, and any transformations performed to clean up the data could be found in "Codebook.md".

The associated R script for processing the data could be found in "run_analysis.R"

The final result (i.e. the tidy data set) could be found in file "Tidydata.txt".

