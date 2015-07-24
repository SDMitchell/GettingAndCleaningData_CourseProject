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

##Creating the tidy datafile

###Guide to create the tidy data file
To create the tidy data file, the following code block can be executed from the R command console. A somewhat decent internet connection is recommended, plus permissions to create new files and directories within the working directory of the script are required.
```
source("run_analysis.R")
dirname <- fetchDataFile(targetFilename) # where targetFilename is the URL at which the zipped data set is hosted
rawdata <- readAllData(dirname)
run_analysis("run_analysis.txt")
```
The [README](https://github.com/SDMitchell/GettingAndCleaningData_CourseProject/blob/master/README.md) contains more information on collecting data frames from intermediate steps, as well as a method of caching data so that the interim steps don't take as long if other operations on the data set are desired (other than the creation of the tidy data file).  

###Cleaning of the data
Short, high-level description of what the cleaning script does. [The readme document describes the code in greater detail.](https://github.com/SDMitchell/GettingAndCleaningData_CourseProject/blob/master/README.md)

##Description of the variables in the run_analysis.txt file
General description of the file including:
 - Dimensions of the dataset
 - Summary of the data
 - Variables present in the dataset

###Variable 1 (repeat this section for all variables in the dataset)
Short description of what the variable describes.

Some information on the variable including:
 - Class of the variable
 - Unique values/levels of the variable
 - Unit of measurement (if no unit of measurement list this as well)
 - In case names follow some schema, describe how entries were constructed (for example time-body-gyroscope-z has 4 levels of descriptors. Describe these 4 levels). 

####Notes on variable 1:
If available, some additional notes on the variable not covered elsewehere. If no notes are present leave this section out.

##Sources
The [source data set](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) used in the project contains most of the reference material, along with the [The UCI Machine Learning Repository](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) web site.
