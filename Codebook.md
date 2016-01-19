## Overview of the raw data
The raw data are located in two folders test/train.

X_train.txt: Training set.  
y_train.txt': Training labels.  
subject_train.txt: Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

X_test.txt: Test set.  
y_test.txt: Test labels.  
subject_test.txt: Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.  

features.txt: List of all features, 2 columns.  
activity_labels.txt: Links the class labels with their activity name, 2 columns.  

The first step is to load all data files.

```r
X_test<- read.table("./test/X_test.txt", header=FALSE)
y_test<- read.table("./test/y_test.txt", header=FALSE)
subject_test<- read.table("./test/subject_test.txt", header=FALSE)
X_train<- read.table("./train/X_train.txt", header=FALSE)
y_train<- read.table("./train/y_train.txt", header=FALSE)
subject_train<- read.table("./train/subject_train.txt", header=FALSE)
activity_lab<- read.table("activity_labels.txt", header=FALSE)
features<- read.table("features.txt", header=FALSE)
```

Now by examning the dimension, it could be concluded that there are 561 measurements for 6 types of activity across 30 subjects. 
In the test set, there are 2947 observations, while in the train set, there are 7352 observations.

The names of feasures are related to each column of observation in the data set (i.e. X_test/train.txt). 

The activities coded from 1-6 are correspond to  "walking", "walking upstairs", "walking downstairs", "sitting", "standing" and "laying".

## Transformations to get tidy data
The goal is to merge the data and get a subset of data which contains mean and std of measurements for each activity of each subject.

1. Merge data to one set

```r
X<- rbind(X_test, X_train)
y<- rbind(y_test, y_train)
subject<- rbind(subject_test, subject_train)
data<- data.frame("measures"=X, "activity"=y$V1, "subject"=subject$V1)
```

2. Extracts only the measurements on the mean and standard deviation for each measurement.

The features' names are stored in V2 of the data frame "features", first need to be changed to characters. The second step is to assign these names to each column in the merged data set in the correct order. Recall that the first 561 columns are from X/measures, and they correspond to these feature names.

```r
features$V2<- sapply(features$V2, as.character)
names(data)[1:561]<- features$V2
```
The next step is to grab the measurements that contain "mean()" or "std()", which is done by useing a "Logical" vector to identify those columns.

For future analysis, also attach the activity and subject columns.

```r
Logical<- grepl("mean()", names(data), fixed=TRUE) | grepl("std()", names(data), fixed=TRUE)
datasub<- data[, Logical]
datasub<- cbind(datasub, "activity"=data$activity, "subject"=data$subject)
```
The final sub set of data contains 66 measurements together with the "activity" and "subject" variables.

3. Uses descriptive activity names to name the activities in the data set.

This is done by join the data with the activity label, a description variable "activity_desc" is added to the joined data set.

```r
activity_lab$V2<- sapply(activity_lab$V2, as.character)
names(activity_lab)<- c("activity", "activity_desc")
library(plyr)
datasub<- join(datasub, activity_lab, by="activity", type="left")
```

4. Appropriately labels the data set with descriptive variable names.

This is done through the above steps to address questions 1-3.

5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Since there are 30 subjects, 6 types of activity, and 66 measurement variables, the result is expected to by a matrix (180 rows and 66 columns).

Aggregate the data by subject and activity type, calculate the mean. 

Note that there is no need to to that for "activity", "subject" and "activity_desc" columns, which are the 67-69th columns, pull them out from the subset when do the calculation.


```r
result<-aggregate(datasub[,-(67:69)], by=list(subject=datasub$subject, activity=datasub$activity_desc), mean)
write.table(result, file="Tidydata.txt", row.names=FALSE)
```
