
## Script assumes data has been downloaded and that we are working in a directory
# containing folder/data set. Otherwise, the following code can be used to
# download the data.
# fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
# dir.create("UCI HAR Dataset")
# download.file(fileURL, "UCI-HAR-dataset.zip")
# unzip("./UCI-HAR-dataset.zip")

# The steps are not performed in the strict order given (there is some overlapping)
# but the end result is the same.

#################################################################
#1. Merging the training and the test sets to create one data set.
#################################################################

# File locations
X.train = "./UCI HAR Dataset/train/X_train.txt"
X.test  = "./UCI HAR Dataset/test/X_test.txt"
y.train = "./UCI HAR Dataset/train/Y_train.txt"
y.test  = "./UCI HAR Dataset/test/Y_test.txt"

subject.train = "./UCI HAR Dataset/train/subject_train.txt"
subject.test  = "./UCI HAR Dataset/test/subject_test.txt"

# Matrix containing all measurements.
X = rbind(read.table(X.train), read.table(X.test))

# vector containing activity code values
activity = rbind(read.table(y.train), read.table(y.test))
activity = activity[,1]

# vector containing subject IDs
subject = rbind(read.table(subject.train), read.table(subject.test))
colnames(subject) = "subject"

#################################################################
#2. Extract only the measurements on the mean and standard deviation for each measurement
#################################################################

features = read.table("./UCI HAR Dataset/features.txt", colClasses = c("NULL","character"))
names(X) = features[,1]

index = grep("-mean\\(\\)|-std\\(\\)", features[,1])
ftr.ms = features[index,1]

X = X[,index]
colnames(X) = ftr.ms

#################################################################
#3. Use descriptive activity names to name the activities in the data set
#################################################################

labels = read.table("./UCI HAR Dataset/activity_labels.txt", stringsAsFactors = F)
for(i in labels[,1])
  activity = gsub(labels[i,1],labels[i,2], activity)

#################################################################
#4. Appropriately labels the data set with descriptive variable names
#################################################################

data = cbind(subject, activity, X)

#################################################################
#5. From the data set in step 4, creates a second, independent tidy data set with 
# the average of each variable for each activity and each subject.
#################################################################

library(reshape2)
data.m = melt(data, id = colnames(data)[1:2], measure.vars = ftr.ms)
tidy = dcast(data.m, subject + activity ~ variable, mean )

#################################################################
# 6. Save new data set
#################################################################

write.table(tidy, "tidy.txt", row.names = FALSE)
