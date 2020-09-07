The run_analysis.R script performs the data preparation and then followed by the 5 steps required as described in the course project’s definition.

1. Download the dataset
  Dataset downloaded and extracted under the folder called UCI HAR Dataset

2. Assign each data to variables
  Activity Files:
    activityTest <- y_test
    activityTrain <- y_train
    
   Subject Files:
    subjectTest <- subject_test 
    subjectTrain <- subject_train
    
   Features Files:
    featuresTest <- X_test
    featuresTrain <- X_train
    
   Metadata:
    activityLables <- activity_lables 

3. Merges the training and the test sets to create one data set
  subject is created by merging subjectTest and subjectTrain using rbind() function
  activity is created by merging activityTest and activityTrain using rbind() function
  features is created by merging featuresTest and featuresTrain using rbind() function
completeData is created by merging features, activity and subject using cbind() function

4. Extracts only the measurements on the mean and standard deviation for each measurement
  newData is created by subsetting completeData

5. Uses descriptive activity names to name the activities in the data set
Entire numbers in code column of the newData replaced with corresponding activity taken from second column of the activities variable

6. Appropriately labels the data set with descriptive variable names
code column in newData renamed into activities
All Acc in column’s name replaced by Accelerometer
All Gyro in column’s name replaced by Gyroscope
All BodyBody in column’s name replaced by Body
All Mag in column’s name replaced by Magnitude
All start with character f in column’s name replaced by Frequency
All start with character t in column’s name replaced by Time

7. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
FinalData is created by sumarizing newData taking the means of each variable for each activity and each subject, after groupped by subject and activity.
Export FinalData into FinalData.txt file.
