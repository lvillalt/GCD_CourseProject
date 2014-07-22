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

### Note that mean-X, mean-Y, mean-Z, std-X, std-Y, std-Z are at [1:6] , [41:46], [81:86], [121:126], [161:166];
### mean and std are at [201:202], [214:215], [227:228], [240:241], [253:254]; 
### mean-X, mean-Y, mean-Z, std-X, std-Y, std-Z are at [266:271], [345:350], [424:429]; 
### mean and std are [503:504], [529:530], [542:543]

### THESE COLUMNS ARE OFF THE 'feature' VECTOR. WILL NEED TO ADD 2 TO EACH INDEX
### SINCE WE WILL cbind() THE SUBJECT AND ACTIVITY COLUMNS

### NOTE: X_test, X_train have 8977 columns, 1 is a space for 8976/16 = 561

## setwd("F:\\Documents\\Coursera")   ## NOTE that the script requires setwd() to 
## where the data directory is

train_activity <- read.table(".\\UCI HAR Dataset\\train\\y_train.txt")
train_subject <- read.table(".\\UCI HAR Dataset\\train\\subject_train.txt")
colnames(train_subject) <- c("Subject.ID")
colnames(train_activity) <- c("Activity.ID")
data_features <- read.table(".\\UCI HAR Dataset\\features.txt")
colnames(data_features) <- c("Feature.ID", "Feature.Name")
widthVect <- c(-1, rep(16, times=561))
XVal <- read.fwf(".\\UCI HAR Dataset\\train\\X_train.txt", widths = widthVect)
colnames(XVal) <- data_features$Feature.Name
trainData <- cbind(train_subject, cbind(train_activity, XVal))
rm(list=c("train_activity", "train_subject", "XVal"))

test_activity <- read.table(".\\UCI HAR Dataset\\test\\y_test.txt")
test_subject <- read.table(".\\UCI HAR Dataset\\test\\subject_test.txt")
XVal <- read.fwf(".\\UCI HAR Dataset\\test\\X_test.txt", widths = widthVect)
colnames(XVal) <- data_features$Feature.Name
colnames(test_subject) <- c("Subject.ID")
colnames(test_activity) <- c("Activity.ID")
testData <- cbind(test_subject, cbind(test_activity, XVal))

rm(list=c("test_activity", "test_subject", "XVal", "data_features", "widthVect"))

mergedData <- rbind(testData, trainData)

rm(list=c("testData", "trainData"))


extractData <- cbind(mergedData[1:8], cbind(mergedData[43:48], mergedData[83:88]))
extractData <- cbind(extractData, cbind(mergedData[123:128], mergedData[163:168]))
extractData <- cbind(extractData, cbind(mergedData[203:204], mergedData[216:217]))
extractData <- cbind(extractData, cbind(mergedData[229:230], mergedData[242:243]))
extractData <- cbind(extractData, cbind(mergedData[255:256], mergedData[268:273]))
extractData <- cbind(extractData, cbind(mergedData[347:352], mergedData[426:431]))
extractData <- cbind(extractData, cbind(mergedData[505:506], mergedData[531:532]))
extractData <- cbind(extractData, mergedData[544:545])

extractData$Activity.ID <- factor(extractData$Activity.ID)

##activity_factors <- read.table(".\\UCI HAR Dataset\\activity_labels.txt")

levels(extractData$Activity.ID) <- c("Walking", "Walking.Upstairs", "Walking.Downstairs", "Sitting.Still", "Standing.Up", "Laying.Down")

mergedData$Activity.ID <- factor(mergedData$Activity.ID)

levels(mergedData$Activity.ID) <- c("Walking", "Walking.Upstairs", "Walking.Downstairs", "Sitting.Still", "Standing.Up", "Laying.Down")

##> identical(extractData$Activity.ID, mergedData$Activity.ID)
##[1] TRUE


mergedData$Subject.ID <- factor(mergedData$Subject.ID)


extractData$Subject.ID <- factor(extractData$Subject.ID)



merged_both <- aggregate(mergedData[,3:563], by=list(mergedData$Subject.ID,mergedData$Activity.ID), FUN=mean)

##> write.table(merged_both, "merged_both.txt")

##>
##> mean(mergedData[(mergedData[,1]=="1" & mergedData[,2]=="Walking"),3])
##[1] 0.2773308
##> 
##> mean(mergedData[(mergedData[,1]=="3" & mergedData[,2]=="Walking"),3])
##[1] 0.2755675
##> 



extract_both <- aggregate(extractData[,3:66], by=list(extractData$Subject.ID,extractData$Activity.ID), FUN=mean)


##> mean(extractData[(extractData[,1]=="1" & extractData[,2]=="Walking"),3])
##[1] 0.2773308
##> mean(extractData[(extractData[,1]=="3" & extractData[,2]=="Walking"),3])
##[1] 0.2755675
##> 

newColNames <- colnames(extract_both)
newColNames[1] <- c("Subject.ID")
newColNames[2] <- c("Activity.ID")


 for(i in 3:length(newColNames)){
     
     newColNames[i] <- sub("\\()|\\()-", "", newColNames[i])
     newColNames[i] <- sub("\\-", ".", newColNames[i])
	 newColNames[i] <- paste(newColNames[i], "_avg", sep="")
 }
 
 colnames(extract_both) <- newColNames
 write.table(extract_both, "extract_both.txt")
 
 
