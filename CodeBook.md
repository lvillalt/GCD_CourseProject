The Code Book
-------------

The values extracted are those described in the UCI HAR Dataset documentation as those with a calculated:
	
	mean(): Mean value
	std(): Standard deviation

The variable names written out below use "pseudo general expressions" to summarize. Items inside parentheses would
be replaced by one of the elements "or'd" with the pipe (|) symbol. For an example see tBodyAcc below.
All values are normalized and bounded within [-1,1].

The information within the dataset does not mention units used, but accelerometers typically measure between +/-1g.
Where a 'g' is 32feet/sec^2, or 9.81 meters/sec^2. (When calibrated to an output voltage per position).
	
		file : extract_both.txt
				180 rows, 66 columns
		Subject.ID  : Factor with 30 levels from "1" to "30"
		Activity.ID : Factor with 6 levels - "Walking", "Walking.Upstairs", "Walking.Downstairs", 
		"Sitting.Still", "Standing.Up", "Laying.Down"

		All values are real numbers (numeric in R) normalized and bounded within [-1,1]

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

