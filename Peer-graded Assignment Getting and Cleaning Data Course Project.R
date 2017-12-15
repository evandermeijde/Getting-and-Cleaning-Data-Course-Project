## R script for "Peer-graded Assignment: Getting and Cleaning Data Course Project"
# Review criteria
# 1 The submitted data set is tidy.
# 2 The Github repo contains the required scripts.
# 3 GitHub contains a code book that modifies and updates the available codebooks with the data to indicate all the variables and summaries calculated, along with units, and any other relevant information.
# 4 The README that explains the analysis files is clear and understandable.
# 5 The work submitted for this project is the work of the student who submitted it.
#
## You should create one R script called run_analysis.R that does the following.
# 1 Merges the training and the test sets to create one data set.
# 2 Extracts only the measurements on the mean and standard deviation for each measurement.
# 3 Uses descriptive activity names to name the activities in the data set
# 4 Appropriately labels the data set with descriptive variable names.
# 5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#
## load libraries
require(caret)
require(tidyverse)
require(zoo)
require(xlsx)
require(data.table)
#
## set wd
setwd("C:/Users/Elisabeth/Desktop/Fourpoints/Coursera/Getting Cleaning data week 4")
## Download data
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", 
              "dataset.zip", mode='wb')
## unzip (I get an error when I use read.table directly)
unzip("dataset.zip")
## look up the name of the map/files
list.files()
## metadata
feature.names <- read.table("UCI HAR Dataset/features.txt")
activity.labels <- read.table("UCI HAR Dataset/activity_labels.txt", header = FALSE)
## three datasets of training data
subject.train <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE)
activity.train <- read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE)
features.train <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE)
## three sets of testing data
subject.test <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE)
activity.test <- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE)
features.test <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE)
###################################################################### 
# 1 Merge the training and the test sets to create one data set.
## merge the three test and train tests
subject <- rbind(subject.train, subject.test)
activity <- rbind(activity.train, activity.test)
features <- rbind(features.train, features.test)
## correct column names
colnames(features) <- t(feature.names[2])
## merge into one dataset
colnames(activity) <- "activity"
colnames(subject) <- "subject"
data <- cbind(features,activity,subject)
###########################################################################
# 2 Extract only the measurements on the mean and standard deviation for each measurement.
## list with indices
cols.M.Sd <- grep(".*Mean.*|.*Std.*", names(data), ignore.case=TRUE)
## add required columns
req.cols <- c(cols.M.Sd, 562, 563)
## the dimensions of data
dim(data)
## extract requested data
extracted.data <- data[,req.cols]
## the dimensions of requested data
dim(extracted.data)
#####################################################################
# 3 Use descriptive activity names to name the activities in the data set
## change the numeric type in character
extracted.data$activity <- as.character(extracted.data$activity)
## loop through the 6 levels, and change into the description from the metadata
for (i in 1:6){
  extracted.data$activity[extracted.data$activity == i] <- as.character(activity.labels[i,2])
}
## change into a factor
extracted.data$activity <- as.factor(extracted.data$activity)
######################################################################
# 4 Appropriately label the data set with descriptive variable names.
## current names
names(extracted.data)
## change Acc into Accelerometer
names(extracted.data)<-gsub("Acc", "Accelerometer", names(extracted.data))
## change Gyro into Gyroscope
names(extracted.data)<-gsub("Gyro", "Gyroscope", names(extracted.data))
## change BodyBody into Body
names(extracted.data)<-gsub("BodyBody", "Body", names(extracted.data))
## change Mag into Magnitude
names(extracted.data)<-gsub("Mag", "Magnitude", names(extracted.data))
## change ^t into Time
names(extracted.data)<-gsub("^t", "Time", names(extracted.data))
## change ^f into Frequency
names(extracted.data)<-gsub("^f", "Frequency", names(extracted.data))
## change tBody into TimeBody
names(extracted.data)<-gsub("tBody", "TimeBody", names(extracted.data))
## change -mean() into Mean
names(extracted.data)<-gsub("-mean()", "Mean", names(extracted.data), ignore.case = TRUE)
## change -std() into STD
names(extracted.data)<-gsub("-std()", "STD", names(extracted.data), ignore.case = TRUE)
## change -freq() into Frequency
names(extracted.data)<-gsub("-freq()", "Frequency", names(extracted.data), ignore.case = TRUE)
## change angle into Angle
names(extracted.data)<-gsub("angle", "Angle", names(extracted.data))
## change gravity into Gravity
names(extracted.data)<-gsub("gravity", "Gravity", names(extracted.data))
## new names
names(extracted.data)
##############################################################################################
# 5 From the data set in step 4, creates a second, 
# independent tidy data set with the average of each variable for each activity and each subject.
## change subject into factor
extracted.data$subject <- as.factor(extracted.data$subject)
extracted.data <- data.table(extracted.data)
## create a dataset data.mean with averages
data.mean <- aggregate(. ~subject + activity, extracted.data, mean)
## sort on subject and activity
data.mean <- data.mean[order(data.mean$subject,data.mean$activity),]
## create a csv file on harddisk
write.table(data.mean, file = "dataMean.txt", row.names = FALSE)
