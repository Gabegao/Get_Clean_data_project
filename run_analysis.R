## Load data
X_test<- read.table("./test/X_test.txt", header=FALSE)
y_test<- read.table("./test/y_test.txt", header=FALSE)
subject_test<- read.table("./test/subject_test.txt", header=FALSE)
X_train<- read.table("./train/X_train.txt", header=FALSE)
y_train<- read.table("./train/y_train.txt", header=FALSE)
subject_train<- read.table("./train/subject_train.txt", header=FALSE)
activity_lab<- read.table("activity_labels.txt", header=FALSE)
features<- read.table("features.txt", header=FALSE)

dim(X_test) ## 2947 rows of 561 variables
dim(X_train) ## 7352 rows of 561 variables

##1. Merges the training and the test sets to create one data set.
## step 1. Append the train data set to test data set
X<- rbind(X_test, X_train)
y<- rbind(y_test, y_train)
subject<- rbind(subject_test, subject_train)
## step 2. Create a data frame "data" to merge all data sets
data<- data.frame("measures"=X, "activity"=y$V1, "subject"=subject$V1)
##str(data)

rm("X")
rm("y")
rm("subject")
rm("X_test")
rm("X_train")
rm("y_test")
rm("y_train")
rm("subject_test")
rm("subject_train")

##2.Extracts only the measurements on the mean and standard deviation for each measurement
## step 1. Match the varible names with the features data frame
features$V2<- sapply(features$V2, as.character)
names(data)[1:561]<- features$V2
Logical<- grepl("mean()", names(data), fixed=TRUE) | grepl("std()", names(data), fixed=TRUE)
datasub<- data[, Logical]
## step 2. Attach the acitivity and subject labels to the subset of data
datasub<- cbind(datasub, "activity"=data$activity, "subject"=data$subject)

##3.Uses descriptive activity names to name the activities in the data set
## Join by acitivity variable and add a description variable "acitivity_desc" to store the activity name
activity_lab$V2<- sapply(activity_lab$V2, as.character)
names(activity_lab)<- c("activity", "activity_desc")
library(plyr)
datasub<- join(datasub, activity_lab, by="activity", type="left")

##4. Appropriately labels the data set with descriptive variable names.
##This is done through the above steps to address questions 1-3.
names(datasub)

##5. From the data set in step 4, creates a second, independent tidy data set with the average 
##  of each variable for each activity and each subject.
## Step 1. aggregate the data by subject and activity type, calculate the mean
## Note that there is no need to to that for "activity", "subject" and "activity_desc" columns
## which are 67-69th columns, pull them out from the subset when do the calculation
result<-aggregate(datasub[,-(67:69)], by=list(subject=datasub$subject, activity=datasub$activity_desc), mean)

write.table(result, file="Tidydata.txt", row.names=FALSE)
