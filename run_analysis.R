## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names.
## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

library(tools)

dataDirectoryBase <- "UCI HAR Dataset"
targetFilename <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
dataDescription <- "http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones"
expectedZipFilename <- "getdata_projectfiles_UCI HAR Dataset.zip"

##
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


