library(dplyr)

## Download the file 
if(!file.exists("./data")) {dir.create("./data")}
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, destfile = "./data/projectdataset.zip")

unzip(zipfile = "./data/projectdataset.zip", exdir = "./data")

## Read activity files 
activityTest <- read.table("./data/UCI HAR Dataset/test/y_test.txt", header = FALSE)
activityTrain <- read.table("./data/UCI HAR Dataset/train/y_train.txt", header = FALSE)

## Read subject files 
subjectTest <- read.table("./data/UCI HAR Dataset/test/subject_test.txt", header = FALSE)
subjectTrain <- read.table("./data/UCI HAR Dataset/train/subject_train.txt", header = FALSE)

## Read features files 
featuresTest <- read.table("./data/UCI HAR Dataset/test/X_test.txt", header = FALSE)
featuresTrain <- read.table("./data/UCI HAR Dataset/train/X_train.txt", header = FALSE)

## Read metadata 
activityLabels <- read.table("./data/UCI HAR Dataset/activity_labels.txt", header = FALSE)

## Merge the training and the test sets to create one data set 
subject <- rbind(subjectTest, subjectTrain)
activity <- rbind(activityTest, activityTrain)
features <- rbind(featuresTest, featuresTrain)

## Set names to variables 
names(subject) <- c("subject")
names(activity) <- c("activity")
featureNames <- read.table("./data/UCI HAR Dataset/features.txt", header = FALSE)
names(features) <- featureNames$V2

## Merge the data 
completeData <- cbind(features,activity,subject)

## Subset Name of Features by measurements on the mean and standard deviation
colNames <- colnames(completeData)

extractedData <- (grepl("activity", colNames)|grepl("subject", colNames)|grepl("mean..", colNames)|grepl("std..", colNames))
requiredColumns <- c(extractedData, 562, 563)
newData <- completeData[,requiredColumns]

## Use descriptive activity names 
newData$activity <- as.character(newData$activit)
for (i in 1:6){
    newData$activit[newData$activity == i] <- as.character(activityLabels[i,2])
}

newData$activity <- as.factor(newData$activity)

## Rename the columns to more descriptive activity names 
names(newData) <- gsub("^t", "Time", names(newData))
names(newData)<-gsub("^f", "frequency", names(newData))
names(newData)<-gsub("Acc", "Accelerometer", names(newData))
names(newData)<-gsub("Gyro", "Gryoscope", names(newData))
names(newData)<-gsub("Mag", "Magnitude", names(newData))
names(newData)<-gsub("BodyBody", "Body", names(newData))
names(newData)<-gsub("tBody", "TimeBody", names(newData))
names(newData)<-gsub("-mean()", "Mean", names(newData), ignore.case = TRUE)
names(newData)<-gsub("-std()", "STD", names(newData), ignore.case = TRUE)
names(newData)<-gsub("-freq()", "Frequency", names(newData), ignore.case = TRUE)
names(newData)<-gsub("angle", "Angle", names(newData))
names(newData)<-gsub("gravity", "Gravity", names(newData))

## Create a second independent tidy set with the average of each variable for each activity and each subject 
FinalData <- newData %>%
    group_by(subject, activity) %>%
    summarise_all(funs(mean))
write.table(newData, "FinalData.txt", row.name=FALSE)