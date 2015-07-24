

## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names.
## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

library(tools)
library(reshape2)

dataDirectoryBase <- "UCI HAR Dataset"
targetFilename <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
dataDescription <- "http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones"
expectedZipFilename <- "getdata_projectfiles_UCI HAR Dataset.zip"
defaultOutputFilename <- "run_analysis.txt"

## fetchDataFile
## A function to fetch the input data file if it does not currently exist locally.
## This function will download the zip file and write its MD5 sum to disk (with a ".MD5" extension). It
## will proceed to unpack the zip file. On error an exception is thrown; on success the extracted directory
## name is returned
##
fetchDataFile <- function(targetURL = targetFilename, targetZipFilename = expectedZipFilename) {

	# Try to download the given file if our input file does not already exist
	if(!file.exists(targetZipFilename))
	{
		download.file(url=targetURL, destfile=targetZipFilename, method="auto", mode="wb")
		if(file.exists(targetZipFilename))
		{
			# Record the downloaded file's MD5 sum; this file's creation date can serve as the downloaded date
			write(md5sum(targetZipFilename), paste(targetZipFilename, ".MD5", sep=""))

			# We retrieved the file, so try to unzip it
			unzip(targetZipFilename)

			# Don't go any further if the zip file unpacked correctly but we didn't get the contents we were expecting
			if(!file.exists(dataDirectoryBase))
			{
				stop("There was a problem attempting to unzip the downloaded file from the given URL; the contents were incorrect")
			}
		}
		else
		{
			stop("There was a problem attempting to download the file from the given URL")
		}
	}

	# Ok, we're all clear if we made it this far
	dataDirectoryBase
}

## readData
## Looking for three files here, subject_type.txt, X_type.txt, y_type.txt. Read the files and
## combine them for a complete view. Fix the activities column with a factor and fix the feature
## column names with the proper labels instead of the default.
##
readData <- function(dataDirectory, dataType) {
	subjectFilename <- file.path(dataDirectory, dataType, sprintf("subject_%s.txt", dataType))
	XFilename <- file.path(dataDirectory, dataType, sprintf("X_%s.txt", dataType))
	yFilename <- file.path(dataDirectory, dataType, sprintf("y_%s.txt", dataType))

	if(!file.exists(subjectFilename))
	{
		stop("There is no subject data in the given data directory")
	}
	if(!file.exists(XFilename))
	{
		stop("There is no sensor (X) data in the given data directory")
	}
	if(!file.exists(yFilename))
	{
		stop("There is no activity (y) data in the given data directory")
	}

	activityLabels = getActivityLabels(dataDirectory)
	columnNames <- c("subject", "activity", getMeasurementLabels(dataDirectory))

	subjectData	<- read.table(subjectFilename)
	XData	<- read.table(XFilename)
	yData	<- read.table(yFilename)
	data <- cbind(subjectData, activityLabels[yData$V1], XData)

	colnames(data) <- columnNames

	data
}

## getActivityLabels
## Read the activity labels out of the appropriate source file and create a factor with the contents
##
getActivityLabels <- function(dataDirectory) {
	activityLabelsFilename <- file.path(dataDirectory, "activity_labels.txt")

	if(!file.exists(activityLabelsFilename))
	{
		stop("There is no activity label data in the given data directory")
	}

	labelData <- read.table(activityLabelsFilename)
	factor(labelData$V1, labels=labelData$V2)
}

## getMeasurementLabels
## Read the measurement labels out of the appropriate source file and create a list with the contents
##
getMeasurementLabels <- function(dataDirectory) {
	measurementLabelsFilename <- file.path(dataDirectory, "features.txt")

	if(!file.exists(measurementLabelsFilename))
	{
		stop("There is no feature label data in the given data directory")
	}

	labelData <- read.table(measurementLabelsFilename)
	labels <- as.character(labelData$V2)
	#labels <- gsub("(", "", labels)
	#labels <- gsub("\\)", "", labels)
	#labels <- gsub(",", "", labels)
	#labels <- gsub("^t", "", labels)
	labels
}

## readAllData
## Simply reads both the test and training data and merges them together into one data.frame
##
readAllData <- function(dataDirectory) {
	testData <- readData(dataDirectory, "test")
	trainData <- readData(dataDirectory, "train")
	allData <- rbind(testData, trainData)

	allData
}

## filterFeatureSet
## We want to return the features asked for plus the subject and activity. This can be run on an existing
## data set or an existing data directory. The feature list is technically a list of regular expressions, but you
## could likely cause some issues if you tried to get too fancy with it.
##
filterFeatureSet <- function(dataDirectory = NULL, dataset = NULL, featureList=c("mean", "std")) {
	if(is.null(dataDirectory) && is.null(dataset))
		stop("You must specify either a dataset or a dataDirectory containing the appropriate data")

	if(is.null(dataset))
		allData <- readAllData(dataDirectory)
	else
		allData <- dataset

	# Build the regex out of the feature list, since all of the features have the same form
	features = c(1,2,grep(sprintf("-(%s)\\(", paste(featureList, collapse="|")), names(allData)))
	allData[,features]
}

## createFinalDataSet
## This is where we create the final tidy data set, which is a second, independent tidy data set
## with the average of each variable for each activity and each subject.
##
createFinalDataSet <- function(dataDirectory = NULL, dataset = NULL) {
	# Create our data set of just the variables the assignment asked for
	filteredData <- filterFeatureSet(dataDirectory, dataset, c("mean", "std"))

	# Melt the data set into long form using the subject and activity as id columns
	molten <- melt(filteredData, id.vars=c(1,2), factorsAsStrings=FALSE)

	# Cast back to the wide form using mean() as the aggregated function
	final <- dcast(molten, subject+activity~variable, mean)

	# Return the final data set
	final
}

## run_analysis
## This is the driver function for generating the assignment results. When this code file is source'd
## running this function will generate the tidy data set file, downloading and filtering the data
## with the default values as specified in the assignment
##
run_analysis <- function(outputFilename=defaultOutputFilename) {
	# Go to the target URL and fetch the data set if it is needed
	fetchDataFile(targetFilename)
	data <- createFinalDataSet(dataDirectory=dataDirectoryBase)
	write.table(data, outputFilename, row.name=FALSE)
}
