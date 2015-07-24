# Coursera Getting and Cleaning Data Course README


##tl;dr Instructions

*Run this section once in your environment*
```
source("run_analysis.R")
dirname <- fetchDataFile(targetFilename) where targetFilename is the URL at which the zipped data set is hosted
rawdata <- readAllData(dirname)
```

*To create the filtered data set with the raw numbers*
```
filteredData <- filterFeatureSet(dataset=rawdata)
```
*To create the final data set with the averages of the requested values*
```
finalData <- createFinalDataSet(dataset=rawdata)
```

*To do everything that involves writing the final data set to disk using the defined default values*
```
run_analysis("output_filename.txt")
```

##Preconditions
It is assumed that the "tools" and "reshape2" packages have been installed via install.packages()

##Postconditions
These variables are added to the environment when the script is source-d. They are the default values for the various methods
that are added to the workspace:  
**dataDirectoryBase** <- *"UCI HAR Dataset"*  
**targetFilename** <- *"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"*  
**dataDescription** <- *"http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones"*  
**expectedZipFilename** <- *"getdata_projectfiles_UCI HAR Dataset.zip"*  
**defaultOutputFilename** <- *"run_analysis.txt"*  

These functions are added to the environment when the script is source-d:  

#### fetchDataFile  
A function to fetch the input data file if it does not currently exist locally.
This function will download the zip file and write its MD5 sum to disk (with a ".MD5" extension). It
will proceed to unpack the zip file. On error an exception is thrown; on success the extracted directory
name is returned  
```
fetchDataFile <- function(targetURL = targetFilename, targetZipFilename = expectedZipFilename)
```
#### readData  
Looking for three files here, subject_type.txt, X_type.txt, y_type.txt. Read the files and
combine them for a complete view. Fix the activities column with a factor and fix the feature
column names with the proper labels instead of the default.
```
readData <- function(dataDirectory, dataType)
```
#### getActivityLabels  
Read the activity labels out of the appropriate source file and create a factor with the contents  
```
getActivityLabels <- function(dataDirectory)
```
#### getMeasurementLabels  
Read the measurement labels out of the appropriate source file and create a list with the contents  
```
getMeasurementLabels <- function(dataDirectory)
```
#### readAllData  
Simply reads both the test and training data and merges them together into one data.frame  
```
readAllData <- function(dataDirectory)
```
#### filterFeatureSet  
We want to return the features asked for plus the subject and activity. This can be run on an existing  
data set or an existing data directory. The feature list is technically a list of regular expressions, but you  
could likely cause some issues if you tried to get too fancy with it.  
```
filterFeatureSet <- function(dataDirectory = NULL, dataset = NULL, featureList=c("mean", "std"))
```
#### createFinalDataSet  
This is where we create the final tidy data set, which is a second, independent tidy data set  
with the average of each variable for each activity and each subject.  
```
createFinalDataSet <- function(dataDirectory = NULL, dataset = NULL)
```
#### run_analysis  
This is the driver function for generating the assignment results. When this code file is source'd
running this function will generate the tidy data set file, downloading and filtering the data
with the default values as specified in the assignment  
```
run_analysis <- function(outputFilename=defaultOutputFilename)
```


