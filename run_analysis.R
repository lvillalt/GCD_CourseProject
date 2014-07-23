## Getting and Cleaning Data Class Project
##
##      Create R script called run_analysis.R that does:
##
##1)	Merges the training and the test sets to create one dataset
##2)	Extracts only the measurements on the mean and standard deviation for each measurement
##3)	Uses descriptive activity names to name the activities in the data sets
##4)	Appropriately labels the data set with descriptive variable names
##5)	Creates a second, independent tidy data set with the average of each variable for each 
##      activity and each subject

### Note that mean-X, mean-Y, mean-Z, std-X, std-Y, std-Z are at [1:6] , [41:46], [81:86], 
###[121:126], [161:166];
### mean and std are at [201:202], [214:215], [227:228], [240:241], [253:254]; 
### mean-X, mean-Y, mean-Z, std-X, std-Y, std-Z are at [266:271], [345:350], [424:429]; 
### mean and std are [503:504], [529:530], [544:545]

### THESE COLUMNS ARE OFF THE 'feature' VECTOR. WE WILL NEED TO ADD 2 TO EACH INDEX
### SINCE WE WILL cbind() THE SUBJECT AND ACTIVITY COLUMNS

### NOTE: X_test, X_train have 8977 columns, 1 is a space for 8976/16 = 561 variables

## setwd("F:\\Documents\\Coursera")   ## NOTE that the script requires setwd() to 
## where the data directory is

### We first read the vectors of activity per measurement, and subject per measurement
### for the 'train' dataset
train_activity <- read.table(".\\UCI HAR Dataset\\train\\y_train.txt")
train_subject <- read.table(".\\UCI HAR Dataset\\train\\subject_train.txt")

### We rename the columns, to make the result more readable
### The naming scheme was chosen for readability as opposed to 'typeability'
### which is why there is a mix of upper and lower case, and periods
### This resembles the default R datasets
colnames(train_subject) <- c("Subject.ID")
colnames(train_activity) <- c("Activity.ID")

### We then read the list of 'features'. This is a list of variable names per column
data_features <- read.table(".\\UCI HAR Dataset\\features.txt")
### We rename the columns for readability
colnames(data_features) <- c("Feature.ID", "Feature.Name")

### The width vector for use in read.fwf()
### Note that we skip the first column (an extra space), and then 
### use the rep() function to create a vector of 561 16-wide variables
widthVect <- c(-1, rep(16, times=561))

### Read the 'train' dataset into a temporary object
### Should be noted that this procedure is written to be succinct and readable,
### not memory efficient. This part of the analysis requires x64 R, and 
### a machine with a lot of memory. Once the merging has happened, if
### the environment is saved, the remaining analysis runs in a machine with 1GB RAM
XVal <- read.fwf(".\\UCI HAR Dataset\\train\\X_train.txt", widths = widthVect)

### Reset the column names to be the 'Feature.Name' elements
colnames(XVal) <- data_features$Feature.Name

### cbind() the subject and activity vectors to the train dataset
trainData <- cbind(train_subject, cbind(train_activity, XVal))

### remove objects to free up memory
rm(list=c("train_activity", "train_subject", "XVal"))

### Read the vectors of activity per measurement, and subject per measurement
### for the 'test' dataset
test_activity <- read.table(".\\UCI HAR Dataset\\test\\y_test.txt")
test_subject <- read.table(".\\UCI HAR Dataset\\test\\subject_test.txt")


### Read the 'test' dataset into a temporary object
### Should be noted that this procedure is written to be succinct and readable,
### not memory efficient. This part of the analysis requires x64 R, and 
### a machine with a lot of memory. Once the merging has happened, if
### the environment is saved, the remaining analysis runs in a machine with 1GB RAM
XVal <- read.fwf(".\\UCI HAR Dataset\\test\\X_test.txt", widths = widthVect)

### Reset the column names to be the 'Feature.Name' elements
colnames(XVal) <- data_features$Feature.Name

### We rename the columns, to make the result more readable
### The naming scheme was chosen for readability as opposed to 'typeability'
### which is why there is a mix of upper and lower case, and periods
### This resembles the default R datasets
colnames(test_subject) <- c("Subject.ID")
colnames(test_activity) <- c("Activity.ID")

### cbind() the subject and activity vectors to the 'test' dataset
testData <- cbind(test_subject, cbind(test_activity, XVal))

### remove objects to free up memory
rm(list=c("test_activity", "test_subject", "XVal", "data_features", "widthVect"))

### Merge the 'test' and 'train' datasets by rbind()
mergedData <- rbind(testData, trainData)

### remove objects to free up memory
rm(list=c("testData", "trainData"))

### Note that mean-X, mean-Y, mean-Z, std-X, std-Y, std-Z are at [1:6] , [41:46], [81:86], 
###[121:126], [161:166];
### mean and std are at [201:202], [214:215], [227:228], [240:241], [253:254]; 
### mean-X, mean-Y, mean-Z, std-X, std-Y, std-Z are at [266:271], [345:350], [424:429]; 
### mean and std are [503:504], [529:530], [542:543]
### THESE COLUMNS ARE OFF THE 'feature' VECTOR. WE WILL NEED TO ADD 2 TO EACH INDEX
### SINCE WE cbind() THE SUBJECT AND ACTIVITY COLUMNS
extractData <- cbind(mergedData[1:8], cbind(mergedData[43:48], mergedData[83:88]))
extractData <- cbind(extractData, cbind(mergedData[123:128], mergedData[163:168]))
extractData <- cbind(extractData, cbind(mergedData[203:204], mergedData[216:217]))
extractData <- cbind(extractData, cbind(mergedData[229:230], mergedData[242:243]))
extractData <- cbind(extractData, cbind(mergedData[255:256], mergedData[268:273]))
extractData <- cbind(extractData, cbind(mergedData[347:352], mergedData[426:431]))
extractData <- cbind(extractData, cbind(mergedData[505:506], mergedData[531:532]))
extractData <- cbind(extractData, mergedData[544:545])

### Turn Activity.ID into a factor variable
extractData$Activity.ID <- factor(extractData$Activity.ID)

### Original values for the 'activity' are in the following file
##activity_factors <- read.table(".\\UCI HAR Dataset\\activity_labels.txt")
### We will relabel the factor for readability, as previously discussed
levels(extractData$Activity.ID) <- c("Walking", "Walking.Upstairs", "Walking.Downstairs", "Sitting.Still", "Standing.Up", "Laying.Down")

### Turn Activity.ID into a factor variable
mergedData$Activity.ID <- factor(mergedData$Activity.ID)

### Original values for the 'activity' are in the following file
##activity_factors <- read.table(".\\UCI HAR Dataset\\activity_labels.txt")
### We will relabel the factor for readability, as previously discussed
levels(mergedData$Activity.ID) <- c("Walking", "Walking.Upstairs", "Walking.Downstairs", "Sitting.Still", "Standing.Up", "Laying.Down")

### UNIT TEST TO CHECK THAT ONLY THE LABELS HAVE CHANGED
##> identical(extractData$Activity.ID, mergedData$Activity.ID)
##[1] TRUE


### Turn Subject.ID into a factor variable. We do not need to relabel, since 1-30 is adequate for subject
extractData$Subject.ID <- factor(extractData$Subject.ID)
mergedData$Subject.ID <- factor(mergedData$Subject.ID)

### The following would create objects merged separately by 'subject' and 'activity'
### Mainly useful for unit testing
##merged_test <- aggregate(mergedData[,3:563], by=list(mergedData$Subject.ID), FUN=mean)
##merged_activity <- aggregate(mergedData[,3:563], by=list(mergedData$Activity.ID), FUN=mean)

### The following would create objects merged separately by 'subject' and 'activity'
### Mainly useful for unit testing
##extract_test <- aggregate(extractData[,3:66], by=list(extractData$Subject.ID), FUN=mean)
##extract_activity <- aggregate(extractData[,3:66], by=list(extractData$Activity.ID), FUN=mean)

###write.table(merged_activity, "merged_activity.txt")
###write.table(merged_test, "merged_test.txt")
###write.table(extract_activity, "extract_activity.txt")
###write.table(extract_test, "extract_test.txt")


### UNIT TESTS FOR SINGLE VARIABLE MERGES
###> mean(mergedData[mergedData[,2]=="Walking",3])
###[1] 0.2763369
###> mean(mergedData[mergedData[,2]=="Walking.Upstairs",4])
###[1] -0.02592329
###> 
###> mean(mergedData[mergedData[,1]=="1",3])
###[1] 0.2656969
###> mean(mergedData[mergedData[,1]=="2",3])
###[1] 0.2731131
###> mean(mergedData[mergedData[,1]=="2",4])
###[1] -0.01913232
###> 

### Calculating the average for all variables per subject AND activity.
merged_both <- aggregate(mergedData[,3:563], by=list(mergedData$Subject.ID,mergedData$Activity.ID), FUN=mean)

### THIS IS NOT THE FINAL TIDY DATASET, SO IT IS NOT WRITTEN OUT, JUST KEPT IN MEMORY
##> write.table(merged_both, "merged_both.txt")
##> mean(mergedData[(mergedData[,1]=="1" & mergedData[,2]=="Walking"),3])
##[1] 0.2773308
##> 
##> mean(mergedData[(mergedData[,1]=="3" & mergedData[,2]=="Walking"),3])
##[1] 0.2755675
##> 


### Calculating the average per subject and activity for all mean and std variables
extract_both <- aggregate(extractData[,3:66], by=list(extractData$Subject.ID,extractData$Activity.ID), FUN=mean)

#### UNIT TESTS 
##> mean(extractData[(extractData[,1]=="1" & extractData[,2]=="Walking"),3])
##[1] 0.2773308
##> mean(extractData[(extractData[,1]=="3" & extractData[,2]=="Walking"),3])
##[1] 0.2755675
##> 

### Rename the columns for readability, and to get rid of parentheses
newColNames <- colnames(extract_both)
newColNames[1] <- c("Subject.ID")
newColNames[2] <- c("Activity.ID")

### Rename the columns for readability, and to get rid of parentheses
 for(i in 3:length(newColNames)){
     
     newColNames[i] <- sub("\\()|\\()-", "", newColNames[i])
     newColNames[i] <- sub("\\-", ".", newColNames[i])
	 newColNames[i] <- paste(newColNames[i], "_avg", sep="")
 }
 
### Reset the column names to the more readable alternative 
colnames(extract_both) <- newColNames
 
### Write 'extract_both.txt' out to disk. This is the tidy data set to turn in 
write.table(extract_both, "extract_both.txt")
 
 
