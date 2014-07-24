GCD_CourseProject
=================

Coursera Getting and Cleaning Data 
-----------------------------------
Course Project
--------------

      Create R script called run_analysis.R that:

	1)	Merges the training and the test sets to create one dataset
	2)	Extracts only the measurements on the mean and standard deviation for each measurement
	3)	Uses descriptive activity names to name the activities in the data sets
	4)	Appropriately labels the data set with descriptive variable names
	5)	Creates a second, independent tidy data set with the average of each variable for
	    each activity and each subject


Results Executive Summary
-------------------------

This is one lengthy README file. If the reader only cares about results, and how to run the analysis, 
the section 'Performing the Analysis' could be skipped.

The analysis described herein, and performed by running the 'run_analysis.R' script, uses the so called 
'feature vector' files from the UCI HAR Dataset (i.e. X_train.txt, and X_test.txt), and the files that 
describe the factors (i.e. y_train.txt, subject_train.txt, y_test.txt, subject_test.txt, features.txt)

The UCI HAR Dataset provides 
-----------------------------
- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.
- Features are normalized and bounded within [-1,1].
- Each feature vector is a row on the text file.

From these source files, the analysis merges the train and test datasets to produce the 'mergedData' object.
This R object is not written out, but is left in memory to be available for further analysis.

From the 'mergedData' object, the analysis extracts all mean and standard deviation measurements into an object called
'extractData'. 

From 'extractData', the aggregate function is used to calculate the arithmetic mean (aka average) for each subject and activity.

This is saved as object 'extract_both', and written out as 'extract_both.txt'.

The Code Book
-------------

The values extracted are those described in the UCI HAR Dataset documentation as those with a calculated:
	
	mean(): Mean value
	std(): Standard deviation

The variable names written out below use "pseudo general expressions" to summarize. Items inside parentheses would
be replaced by one of the elements "or'd" with the pipe (|) symbol. For an example see tBodyAcc below.
All values are normalized and bounded within [-1,1].
	
		file : extract_both.txt
				180 rows, 66 columns
		Subject.ID  : Factor with 30 levels from "1" to "30"
		Activity.ID : Factor with 6 levels - "Walking", "Walking.Upstairs", "Walking.Downstairs", 
		"Sitting.Still", "Standing.Up", "Laying.Down"

		All values are normalized and bounded within [-1,1]

		tBodyAcc.(mean|std)(X|Y|Z)_avg : (e.g. tBodyAcc.meanX_avg)
		tGravityAcc.(mean|std)(X|Y|Z)_avg
		tBodyAccJerk.(mean|std)(X|Y|Z)_avg
		tBodyGyro.(mean|std)(X|Y|Z)_avg
		tBodyGyroJerk.(mean|std)(X|Y|Z)_avg
		tBodyAccMag.(mean|std)(X|Y|Z)_avg
		tGravityAccMag.(mean|std)(X|Y|Z)_avg
		tBodyAccJerkMag.(mean|std)(X|Y|Z)_avg
		tBodyGyroMag.(mean|std)(X|Y|Z)_avg
		tBodyGyroJerkMag.(mean|std)(X|Y|Z)_avg
		fBodyAcc.(mean|std)(X|Y|Z)_avg
		fBodyAccJerk.(mean|std)(X|Y|Z)_avg
		fBodyGyro.(mean|std)(X|Y|Z)_avg
		fBodyAccMag.(mean|std)(X|Y|Z)_avg
		fBodyAccJerkMag.(mean|std)(X|Y|Z)_avg
		fBodyGyroMag.(mean|std)(X|Y|Z)_avg
		fBodyGyroJerkMag.(mean|std)(X|Y|Z)_avg	

		gravityMean.(mean|std)(X|Y|Z)_avg
		tBodyAccMean.(mean|std)(X|Y|Z)_avg
		tBodyAccJerkMean.(mean|std)(X|Y|Z)_avg
		tBodyGyroMean.(mean|std)(X|Y|Z)_avg
		tBodyGyroJerkMean.(mean|std)(X|Y|Z)_avg


Before "sourcing" this script
-----------------------------

 The script assumes:

 * The working directory is set to a directory (e.g. setwd("F:\\Documents\\Coursera")) that includes:
   1. The run_analysis.R script
   2. A subfolder named 'UCI HAR Dataset' that encloses the data file hierarchy
 
 * The file structure, and the files themselves have not been modified, other than 
    being extracted from the  *.zip file
 
The Analysis 
------------

Before starting an analysis, it is useful to note file structure, and any idiosyncrasies.
A visual inspection of the files shows that they are delimited with spaces, and use UNIX-style line delimiters.
The files will appear as 'garbage' text on a standard "Windows" text editor (e.g. notepad). 

The README file for the UCI HAR Dataset (.\\UCI HAR Dataset\README.txt) provides all the information on

* What the experiment was, how measurements were taken, and how they were processed into a dataset
* What data is in each 'record' (i.e. each row of the dataset)
* Which files describe the labels for each factor (subject, and/or activity)

The data was randomly divided into a 'training' dataset, and a 'test' dataset.

The file 'features_info.txt' provides general data for the processed dataset components, what they call 
the 'features'.
These 'features' include time domain data, identified with an initial lower case t in the name, calculated frequency domain data, indentified with a lower case f, and some estimated coefficients 
and signal statistics (like mean and standard deviation).

The analysis consists of reading in the factors from all these different files, merging the data for the 'test' and 'train' datasets, extracting a separate dataset with just the mean and std of the measurements, and write out a dataset of the averages per subject and activity for each of these.

If the assumptions listed above are met, the script can be run from R with the command:

    source("run_analysis.R")


Performing the Analysis
-----------------------

We will first note that what we will call the 'factor' files, are space delimited and can be read as tables.
We first read the vectors of activity per measurement, and subject per measurement for the 'train' dataset.

    train_activity <- read.table(".\\UCI HAR Dataset\\train\\y_train.txt")
    train_subject <- read.table(".\\UCI HAR Dataset\\train\\subject_train.txt")

It should be noted that the datasets are processed serially, and not in parallel. The reason for this is that making the analysis script more readable also makes it less memory efficient. Merging the 'test' and 'train' datasets this way requires more than 4GB of RAM in Windows. This cannot be run on 32 bit version of R for Windows. By saving the working environment after the merge, the memory footprint is lessened and the analysis, after the merge, run easily with less than 1GB of RAM on Windows.

We rename the columns, to make the result more readable. The naming scheme was chosen for readability as opposed to 'typeability', which is why there is a mix of upper and lower case, and periods. This resembles the default R datasets.

    colnames(train_subject) <- c("Subject.ID")
    colnames(train_activity) <- c("Activity.ID")


We then read the list of 'features'. This is a list of variable names per column.

    data_features <- read.table(".\\UCI HAR Dataset\\features.txt")

We rename the columns for readability.

    colnames(data_features) <- c("Feature.ID", "Feature.Name")

We create the width vector for use in read.fwf(). Note that we skip the first column (an extra space), and then use the rep() function to create a vector of 561 16-wide variables.

    widthVect <- c(-1, rep(16, times=561))

Note that the datasets X_test, and X_train have 8977 columns, 1 is a space for 8976/16 = 561 variables.

We read the 'train' dataset into a temporary object XVal. It should be noted that this procedure is written to be succinct and readable, not memory efficient. This part of the analysis requires x64 R, and a machine with a lot of memory. Once the merging has happened, if the environment is saved, the remaining analysis runs in a machine with 1GB RAM.

    XVal <- read.fwf(".\\UCI HAR Dataset\\train\\X_train.txt", widths = widthVect)


We then reset the column names to be the 'Feature.Name' elements. Note that these names have not been modified from the originally provided names, they include parentheses and dashes.

    colnames(XVal) <- data_features$Feature.Name

We 'column bind' the subject and activity vectors to the train dataset. This adds two columns, a subject and an activity column.

    trainData <- cbind(train_subject, cbind(train_activity, XVal))

We then remove objects to free up memory.

    rm(list=c("train_activity", "train_subject", "XVal"))



Read the vectors of activity per measurement, and subject per measurement for the 'test' dataset.

		test_activity <- read.table(".\\UCI HAR Dataset\\test\\y_test.txt")
		test_subject <- read.table(".\\UCI HAR Dataset\\test\\subject_test.txt")


Read the 'test' dataset into a temporary object. It should be noted that this procedure is written to be succinct and readable, not memory efficient. This part of the analysis requires x64 R, and a machine with a lot of memory. Once the merging has happened, if the environment is saved, the remaining analysis runs in a machine with 1GB RAM.

		XVal <- read.fwf(".\\UCI HAR Dataset\\test\\X_test.txt", widths = widthVect)

Reset the column names to be the 'Feature.Name' elements
		colnames(XVal) <- data_features$Feature.Name

We rename the columns, to make the result more readable. The naming scheme was chosen for readability as opposed to 'typeability' which is why there is a mix of upper and lower case, and periods. This resembles the default R datasets.

		colnames(test_subject) <- c("Subject.ID")
		colnames(test_activity) <- c("Activity.ID")

Column bind the subject and activity vectors to the 'test' dataset.

		testData <- cbind(test_subject, cbind(test_activity, XVal))

Remove objects to free up memory.

		rm(list=c("test_activity", "test_subject", "XVal", "data_features", "widthVect"))

Merge the 'test' and 'train' datasets by rbind().

		mergedData <- rbind(testData, trainData)

Remove objects to free up memory.

		rm(list=c("testData", "trainData"))

		Note that mean-X, mean-Y, mean-Z, std-X, std-Y, std-Z are at 
		[1:6] , [41:46], [81:86],[121:126], [161:166];
		mean and std are at [201:202], [214:215], [227:228], [240:241], [253:254]; 
		mean-X, mean-Y, mean-Z, std-X, std-Y, std-Z are at [266:271], [345:350], [424:429]; 
		mean and std are [503:504], [529:530], [542:543]
		
Since these column indices are off of the 'feature' vector, we will need to add two (2) to each index, since we added two columns.

		extractData <- cbind(mergedData[1:8], cbind(mergedData[43:48], mergedData[83:88]))
		extractData <- cbind(extractData, cbind(mergedData[123:128], mergedData[163:168]))
		extractData <- cbind(extractData, cbind(mergedData[203:204], mergedData[216:217]))
		extractData <- cbind(extractData, cbind(mergedData[229:230], mergedData[242:243]))
		extractData <- cbind(extractData, cbind(mergedData[255:256], mergedData[268:273]))
		extractData <- cbind(extractData, cbind(mergedData[347:352], mergedData[426:431]))
		extractData <- cbind(extractData, cbind(mergedData[505:506], mergedData[531:532]))
		extractData <- cbind(extractData, mergedData[544:545])

Turn Activity.ID into a factor variable.

		extractData$Activity.ID <- factor(extractData$Activity.ID)

Original values for the 'activity' are in the file (".\\UCI HAR Dataset\\activity_labels.txt").

We will relabel the factor for readability, as previously discussed.

		levels(extractData$Activity.ID) <- c("Walking", "Walking.Upstairs", "Walking.Downstairs",
		"Sitting.Still", "Standing.Up", "Laying.Down")

Turn Activity.ID into a factor variable.

		mergedData$Activity.ID <- factor(mergedData$Activity.ID)


We will relabel the factor for readability, as previously discussed.

		levels(mergedData$Activity.ID) <- c("Walking", "Walking.Upstairs", "Walking.Downstairs", 
		"Sitting.Still", "Standing.Up", "Laying.Down")

We check that the columns have retained the correct values, even if the labels have changed.
(This is not part of the script, it is a manual verification)

		identical(extractData$Activity.ID, mergedData$Activity.ID)
		[1] TRUE


Turn Subject.ID into a factor variable. We do not need to relabel, since 1-30 is adequate for subject.

		extractData$Subject.ID <- factor(extractData$Subject.ID)
		mergedData$Subject.ID <- factor(mergedData$Subject.ID)


Calculating the average for all variables per subject AND activity.

		merged_both <- aggregate(mergedData[,3:563], 
		by=list(mergedData$Subject.ID,mergedData$Activity.ID), FUN=mean)

THIS IS NOT THE FINAL TIDY DATASET, SO IT IS NOT WRITTEN OUT, JUST KEPT IN MEMORY.


Calculating the average per subject and activity for all mean and std variables.

		extract_both <- aggregate(extractData[,3:66], 
		by=list(extractData$Subject.ID,extractData$Activity.ID), FUN=mean)

Unit tests to manually verify that aggregate was used correctly.
(This is not part of the script, it is a manual verification)

		mean(extractData[(extractData[,1]=="1" & extractData[,2]=="Walking"),3])
		[1] 0.2773308
		mean(extractData[(extractData[,1]=="3" & extractData[,2]=="Walking"),3])
		[1] 0.2755675

Rename the columns for readability, and to get rid of parentheses.

		newColNames <- colnames(extract_both)
		newColNames[1] <- c("Subject.ID")
		newColNames[2] <- c("Activity.ID")

Rename the columns for readability, and to get rid of parentheses, and stray dashes. We also add "_avg" to identify that this is an average across factors.

		for(i in 3:length(newColNames)){
     
			newColNames[i] <- sub("\\()|\\()-", "", newColNames[i])
			newColNames[i] <- sub("\\-", ".", newColNames[i])
			newColNames[i] <- paste(newColNames[i], "_avg", sep="")
		}
 
Reset the column names to the more readable alternative.

		colnames(extract_both) <- newColNames
 
Write 'extract_both.txt' out to disk. This is the tidy data set to turn in.

		write.table(extract_both, "extract_both.txt")
 
