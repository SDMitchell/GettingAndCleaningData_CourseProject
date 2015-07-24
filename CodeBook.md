---
title: "Codebook for the Coursera Getting and Cleaning Data Final Project"
author: "SD Mitchell"
date: "July 23, 2015"
output:
  html_document:
    keep_md: yes
---

## Project Description
The purpose of this project is to demonstrate the ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis.

##Study design and data processing

###Collection of the raw data
Information on the raw data set can be found at [The UCI Machine Learning Repository](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones). To directly quote the web site, the data is a *"Human Activity Recognition database built from the recordings of 30 subjects performing activities of daily living (ADL) while carrying a waist-mounted smartphone with embedded inertial sensors."*  
  
It is important to note that the sub-directories in the data sets (named "Inertial Signals") were NOT included in this project and are totally ignored in the results.

##Creating the tidy datafile

###Guide to creating the tidy data file
To create the tidy data file, the following code block can be executed from the R command console. A somewhat decent internet connection is recommended, plus permissions to create new files and directories within the working directory of the script are required.
```
source("run_analysis.R")
dirname <- fetchDataFile(targetFilename) # where targetFilename is the URL at which the zipped data set is hosted
rawdata <- readAllData(dirname)
run_analysis("run_analysis.txt")
```
The [README](https://github.com/SDMitchell/GettingAndCleaningData_CourseProject/blob/master/README.md) contains more information on collecting data frames from intermediate steps, as well as a method of caching data so that the interim steps don't take as long if other operations on the data set are desired (other than the creation of the tidy data file).  

###Cleaning of the data
After the data set has been downloaded and extracted, the cleaning process is run. The data is read into memory in two steps which are identical except for the data being used: processing the training data and processing the test data. The activity levels are extracted directly from the source file in which they are contained and substituted into the data sets as factors; the measurement labels are processed slightly to change the leading indicator into a more decriptive "Time" or "Freq" domain indicator. All dashes ("-") are converted to periods (".") so that any variable references do not need to be quoted in backticks if $ notation is used.  

The data is then prefixed with two feature columns, the subject (read from its corresponding data file) and the activity (mentioned previously). There is then a step to bind the training data to the test data using rbind, creating a complete data set which is only partially tidy.  
  
The original data contained many algorithm result feature that were not desired in the final output (e.g. energy bands, kurtosis) so a step to filter all of the "undesireds" out is undertaken, leaving just the mean and std algorithm features in the result.  

An extra requirement of the project was to take the mean of all of the like features instead of using their original values; this was taken care of with a melt/dcast combination using the subject and the activity as the id column. A bit more label cleaning (getting rid of ugly parentheses and changing the algorithm names to "MeanOf<algo_name>" to relect their new contents) and the data is finally tidy.  

All of this is driven from a run_analysis() convenience function which can be run to kick off the workflow described.  

[The readme document describes the code in a bit more detail.](https://github.com/SDMitchell/GettingAndCleaningData_CourseProject/blob/master/README.md)

##Description of the variables in the output text file  
### Metadata
File Characteristics | Value
----------------- | -------
File Name | run_analysis.txt
File Size | 224,793 bytes
Line Endings | CR+LF (Windows)
SHA-1 | f0caaf27aab9b90f9369041fe4808e59e1ddf769

Data Characteristics | Value
----------------- | -------
Number of Samples | 180
Number of Features | 68
Date Computed | July 23, 2015
ID Feature | subject + activity
Header? | Yes
Quoted Strings? | Yes
NA present? | No
NA Values | Not applicable
Preprocessing | Features are normalized and bounded within [-1,1]  

### Feature Name Taxonomy
All feature names are composed of four required portions followed by an optional portion. This naming scheme allows the data value to be interpreted without consulting the external data dictionary. 

Part | Options | Description
-------- | -------- | --------
Domain|Time or Freq|Specifies if the original feature was a time-domain signal or was the result of an FFT
Placement|Body or Gravity|denotes if the measurement was originally the body portion of the acceleration or the gravity portion
Type|Acc, Gyro, Body, Jerk, Mag|Acc = accelerometer, Gyro = gyroscope, Body = ?, Jerk = first derivative of acceleration signal was taken, Mag = magnitude using Euclidean norm
Algorithm|MeanOfMean or MeanOfStd|Specifies if the feature is the mean of an original feature which was a mean or std
Axes|X, Y, Z or factor levels or <empty>|The axis along which a measurement was carried out, or the ordered levels of a factor as text

**A note on units** - *I originally thought that there would be a unit to this data set, but there is no indication one way or the other as to HOW the data was scaled/normalized. Most methods would leave the data unitless, but if a variance-to-mean ratio was used this would not be true. Since I could find no indication contrary to this, I'll play the odds and say that it wasn't done this way.* 
  
*I also have no idea where an FFT with non-complex values came from, but I'm just going with was given. Maybe also a normalization technique of which I am unaware (I'm sure there are many, to say the least).*  
  
    
(Please note that the following table likely has a horizontal scrollbar when viewed on Github)  
  
Name | Class | Units | Domain | Placement | Type | Algorithm | Axes
-------- | -------- | -------- | -------- | -------- | -------- | -------- | --------
subject|integer|None|N/A|N/A|N/A|N/A|N/A
activity|factor 1..6|None|N/A|N/A|N/A|N/A|Levels: WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING
TimeBodyAcc.MeanOfMean.X|numeric|None|Time|Body|Acc|MeanOfMean|X
TimeBodyAcc.MeanOfMean.Y|numeric|None|Time|Body|Acc|MeanOfMean|Y
TimeBodyAcc.MeanOfMean.Z|numeric|None|Time|Body|Acc|MeanOfMean|Z
TimeBodyAcc.MeanOfStd.X|numeric|None|Time|Body|Acc|MeanOfStd|X
TimeBodyAcc.MeanOfStd.Y|numeric|None|Time|Body|Acc|MeanOfStd|Y
TimeBodyAcc.MeanOfStd.Z|numeric|None|Time|Body|Acc|MeanOfStd|Z
TimeGravityAcc.MeanOfMean.X|numeric|None|Time|Gravity|Acc|MeanOfMean|X
TimeGravityAcc.MeanOfMean.Y|numeric|None|Time|Gravity|Acc|MeanOfMean|Y
TimeGravityAcc.MeanOfMean.Z|numeric|None|Time|Gravity|Acc|MeanOfMean|Z
TimeGravityAcc.MeanOfStd.X|numeric|None|Time|Gravity|Acc|MeanOfStd|X
TimeGravityAcc.MeanOfStd.Y|numeric|None|Time|Gravity|Acc|MeanOfStd|Y
TimeGravityAcc.MeanOfStd.Z|numeric|None|Time|Gravity|Acc|MeanOfStd|Z
TimeBodyAccJerk.MeanOfMean.X|numeric|None|Time|Body|AccJerk|MeanOfMean|X
TimeBodyAccJerk.MeanOfMean.Y|numeric|None|Time|Body|AccJerk|MeanOfMean|Y
TimeBodyAccJerk.MeanOfMean.Z|numeric|None|Time|Body|AccJerk|MeanOfMean|Z
TimeBodyAccJerk.MeanOfStd.X|numeric|None|Time|Body|AccJerk|MeanOfStd|X
TimeBodyAccJerk.MeanOfStd.Y|numeric|None|Time|Body|AccJerk|MeanOfStd|Y
TimeBodyAccJerk.MeanOfStd.Z|numeric|None|Time|Body|AccJerk|MeanOfStd|Z
TimeBodyGyro.MeanOfMean.X|numeric|None|Time|Body|Gyro|MeanOfMean|X
TimeBodyGyro.MeanOfMean.Y|numeric|None|Time|Body|Gyro|MeanOfMean|Y
TimeBodyGyro.MeanOfMean.Z|numeric|None|Time|Body|Gyro|MeanOfMean|Z
TimeBodyGyro.MeanOfStd.X|numeric|None|Time|Body|Gyro|MeanOfStd|X
TimeBodyGyro.MeanOfStd.Y|numeric|None|Time|Body|Gyro|MeanOfStd|Y
TimeBodyGyro.MeanOfStd.Z|numeric|None|Time|Body|Gyro|MeanOfStd|Z
TimeBodyGyroJerk.MeanOfMean.X|numeric|None|Time|Body|GyroJerk|MeanOfMean|X
TimeBodyGyroJerk.MeanOfMean.Y|numeric|None|Time|Body|GyroJerk|MeanOfMean|Y
TimeBodyGyroJerk.MeanOfMean.Z|numeric|None|Time|Body|GyroJerk|MeanOfMean|Z
TimeBodyGyroJerk.MeanOfStd.X|numeric|None|Time|Body|GyroJerk|MeanOfStd|X
TimeBodyGyroJerk.MeanOfStd.Y|numeric|None|Time|Body|GyroJerk|MeanOfStd|Y
TimeBodyGyroJerk.MeanOfStd.Z|numeric|None|Time|Body|GyroJerk|MeanOfStd|Z
TimeBodyAccMag.MeanOfMean|numeric|None|Time|Body|AccMag|MeanOfMean
TimeBodyAccMag.MeanOfStd|numeric|None|Time|Body|AccMag|MeanOfStd
TimeGravityAccMag.MeanOfMean|numeric|None|Time|Gravity|AccMag|MeanOfMean
TimeGravityAccMag.MeanOfStd|numeric|None|Time|Gravity|AccMag|MeanOfStd
TimeBodyAccJerkMag.MeanOfMean|numeric|None|Time|Body|AccJerkMag|MeanOfMean
TimeBodyAccJerkMag.MeanOfStd|numeric|None|Time|Body|AccJerkMag|MeanOfStd
TimeBodyGyroMag.MeanOfMean|numeric|None|Time|Body|GyroMag|MeanOfMean
TimeBodyGyroMag.MeanOfStd|numeric|None|Time|Body|GyroMag|MeanOfStd
TimeBodyGyroJerkMag.MeanOfMean|numeric|None|Time|Body|GyroJerkMag|MeanOfMean
TimeBodyGyroJerkMag.MeanOfStd|numeric|None|Time|Body|GyroJerkMag|MeanOfStd
FreqBodyAcc.MeanOfMean.X|numeric|None|Freq|Body|Acc|MeanOfMean|X
FreqBodyAcc.MeanOfMean.Y|numeric|None|Freq|Body|Acc|MeanOfMean|Y
FreqBodyAcc.MeanOfMean.Z|numeric|None|Freq|Body|Acc|MeanOfMean|Z
FreqBodyAcc.MeanOfStd.X|numeric|None|Freq|Body|Acc|MeanOfStd|X
FreqBodyAcc.MeanOfStd.Y|numeric|None|Freq|Body|Acc|MeanOfStd|Y
FreqBodyAcc.MeanOfStd.Z|numeric|None|Freq|Body|Acc|MeanOfStd|Z
FreqBodyAccJerk.MeanOfMean.X|numeric|None|Freq|Body|AccJerk|MeanOfMean|X
FreqBodyAccJerk.MeanOfMean.Y|numeric|None|Freq|Body|AccJerk|MeanOfMean|Y
FreqBodyAccJerk.MeanOfMean.Z|numeric|None|Freq|Body|AccJerk|MeanOfMean|Z
FreqBodyAccJerk.MeanOfStd.X|numeric|None|Freq|Body|AccJerk|MeanOfStd|X
FreqBodyAccJerk.MeanOfStd.Y|numeric|None|Freq|Body|AccJerk|MeanOfStd|Y
FreqBodyAccJerk.MeanOfStd.Z|numeric|None|Freq|Body|AccJerk|MeanOfStd|Z
FreqBodyGyro.MeanOfMean.X|numeric|None|Freq|Body|Gyro|MeanOfMean|X
FreqBodyGyro.MeanOfMean.Y|numeric|None|Freq|Body|Gyro|MeanOfMean|Y
FreqBodyGyro.MeanOfMean.Z|numeric|None|Freq|Body|Gyro|MeanOfMean|Z
FreqBodyGyro.MeanOfStd.X|numeric|None|Freq|Body|Gyro|MeanOfStd|X
FreqBodyGyro.MeanOfStd.Y|numeric|None|Freq|Body|Gyro|MeanOfStd|Y
FreqBodyGyro.MeanOfStd.Z|numeric|None|Freq|Body|Gyro|MeanOfStd|Z
FreqBodyAccMag.MeanOfMean|numeric|None|Freq|Body|AccMag|MeanOfMean
FreqBodyAccMag.MeanOfStd|numeric|None|Freq|Body|AccMag|MeanOfStd
FreqBodyBodyAccJerkMag.MeanOfMean|numeric|None|Freq|Body|BodyAccJerkMag|MeanOfMean
FreqBodyBodyAccJerkMag.MeanOfStd|numeric|None|Freq|Body|BodyAccJerkMag|MeanOfStd
FreqBodyBodyGyroMag.MeanOfMean|numeric|None|Freq|Body|BodyGyroMag|MeanOfMean
FreqBodyBodyGyroMag.MeanOfStd|numeric|None|Freq|Body|BodyGyroMag|MeanOfStd
FreqBodyBodyGyroJerkMag.MeanOfMean|numeric|None|Freq|Body|BodyGyroJerkMag|MeanOfMean
FreqBodyBodyGyroJerkMag.MeanOfStd|numeric|None|Freq|Body|BodyGyroJerkMag|MeanOfStd

##Sources
The [source data set](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) used in the project contains most of the reference material, along with the [The UCI Machine Learning Repository](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) web site.  
  
  
  
