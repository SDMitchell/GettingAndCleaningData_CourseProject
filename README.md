# Coursera "Getting and Cleaning Data" Course Project README  

This a set of simple instructions to use the one and only script that fulfils the instructions in the project rubric. The [codebook](https://github.com/SDMitchell/GettingAndCleaningData_CourseProject/blob/master/CodeBook.md) explains what steps were taken to clean and tidy the data, as well as the variables in the resulting (final) data set.  
  
In brief, the idea behind the project is to parse out a data set representing data collected from the accelerometers and gyro of a Samsung Galaxy S smartphone while it was attached to various subjects undergoing various "daily life" tasks. The original purpose was likely to attempt to cluster or classify the data to attempt to predict what a person was doing and (ultimately) where they were doing it.  

The blurb, verbatim from the web site:

> The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.  
>  
> The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.  

##Instructions

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
--- Calls: None  
```
fetchDataFile <- function(targetURL = targetFilename, targetZipFilename = expectedZipFilename)
```
#### readData  
Looking for three files here, subject_type.txt, X_type.txt, y_type.txt. Read the files and
combine them for a complete view. Fix the activities column with a factor and fix the feature
column names with the proper labels instead of the default.  
--- Calls: getActivityLabels, getMeasurementLabels  
```
readData <- function(dataDirectory, dataType)
```
#### getActivityLabels  
Read the activity labels out of the appropriate source file and create a factor with the contents  
--- Calls: None  
```
getActivityLabels <- function(dataDirectory)
```
#### getMeasurementLabels  
Read the measurement labels out of the appropriate source file and create a list with the contents  
--- Calls: None  

```
getMeasurementLabels <- function(dataDirectory)
```
#### readAllData  
Simply reads both the test and training data and merges them together into one data.frame  
--- Calls: readData  
```
readAllData <- function(dataDirectory)
```
#### filterFeatureSet  
We want to return the features asked for plus the subject and activity. This can be run on an existing  
data set or an existing data directory. The feature list is technically a list of regular expressions, but you  
could likely cause some issues if you tried to get too fancy with it.  
--- Calls: readAllData  
```
filterFeatureSet <- function(dataDirectory = NULL, dataset = NULL, featureList=c("mean", "std"))
```
#### createFinalDataSet  
This is where we create the final tidy data set, which is a second, independent tidy data set  
with the average of each variable for each activity and each subject.  
--- Calls: filterFeatureSet  
```
createFinalDataSet <- function(dataDirectory = NULL, dataset = NULL)
```
#### run_analysis  
This is the driver function for generating the assignment results. When this code file is source'd
running this function will generate the tidy data set file, downloading and filtering the data
with the default values as specified in the assignment  
--- Calls: fetchDataFile, createFinalDataSet  
```
run_analysis <- function(outputFilename=defaultOutputFilename)
```


