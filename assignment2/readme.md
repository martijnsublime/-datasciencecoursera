#Part one: Merge the training and the test sets to create one data set 

## Create train set variable

Load the corresponding dataframes into R for the subjects, the activities performed by these subjects and the corresponding measured variables. Do this for the training set. 

```r
activities_train = read.table("UCI HAR Dataset/train/y_train.txt")
values_train = read.table("UCI HAR Dataset/train/x_train.txt")
subject_train = read.table("UCI HAR Dataset/train/subject_train.txt")
```

Combine these into one data set, and assign to the variable `train`. 
```r
train = cbind(subject_train,activities_train,values_train)
```

## Test Set

Load the corresponding dataframes into R for the subjects, the activities performed by these subjects and the corresponding measured variables. Do this for the test set. 

```r
activities_test = read.table("UCI HAR Dataset/test/y_test.txt")
values_test = read.table("UCI HAR Dataset/test/x_test.txt")
subject_test = read.table("UCI HAR Dataset/test/subject_test.txt")
```

Combine these into one data set, and assign to the variable `test`. 
```r
test = cbind(subject_test,activities_test,values_test)
```

## Column names
Get the the correct and descriptive variable names, and assign these to a variable `column_names`. This variable will be used to link the correct names to the different variables. 

```r
variable_names = as.vector(read.table("UCI HAR Dataset/features.txt")[,-1])
subject = c("subject")
activity = c("activity")
column_names = c(subject,activity,variable_names)
```


##One data set

Combine the test and train data set into one data set named `human_activity_recognition`.

```r
human_activity_recognition = rbind(train,test)
```

Assign the correct variable names with the help of `column_names`. 

```r
colnames(human_activity_recognition) = column_names
```

#Extract only the measurements on the mean and standard deviation for each measurement

## Identify the mean and standard deviation relevant variables

Make use of regular expressions applied to all variable names to extract the variables related to the measurements of mean and standard deviation.

```r
mean_variable = c(grep("mean[()]",names(human_activity_recognition)))
std_variable = c(grep("std[()]",names(human_activity_recognition)))
```
## Create subset

Use `mean_variable` and `std_variable` to take a subset out of the total data set `human_activity_recognition` that only contains column values related to measurements of mean and standard deviation. Also include the subjects and their activity. 

```r
human_activity_recognition_subset = human_activity_recognition[,c(1,2,mean_variable,std_variable)]
```

# Use descriptive activity names to name the activities in the data set and appropriately labels the data set with descriptive activity names.

Knowing how the number of an activity translates to the actual activity (e.g. The number one stands for Walking), we make use of the `sapply()` function to convert every number for the `activity` variable into a more descriptive string that allows for better understanding of the type of activity.    

```r
human_activity_recognition_subset$activity = sapply(human_activity_recognition_subset$activity,function(x) ifelse(x=="1","Walking",x))
human_activity_recognition_subset$activity = sapply(human_activity_recognition_subset$activity,function(x) ifelse(x=="2","Walking_upstairs",x))
human_activity_recognition_subset$activity = sapply(human_activity_recognition_subset$activity,function(x) ifelse(x=="3","Walking_downstairts",x))
human_activity_recognition_subset$activity = sapply(human_activity_recognition_subset$activity,function(x) ifelse(x=="4","Sitting",x))
human_activity_recognition_subset$activity = sapply(human_activity_recognition_subset$activity,function(x) ifelse(x=="5","Standing",x))
human_activity_recognition_subset$activity = sapply(human_activity_recognition_subset$activity,function(x) ifelse(x=="6","Laying",x))
```

#### Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

Make use of the `reshape2` package to massage the data set. 

```r
install.packages("reshape2")
library(reshape2)
```

Create a new data set, `tidy_data_two`, that is a subset of the previously created data set `human_activity_recognition_subset`, based on the variables that only relate to measurements of mean. Next, we use `melt()` to create a unique id-variable combination. As our ID we take the combination of subject and activity, and as our measure we take all variables related to mean. (which are defined in `all_mean_variables` with the help of regular expressions.)

```r
all_mean_variables = c(grep("mean[()]",names(human_activity_recognition_subset),value=TRUE))
tidy_data_two = melt(human_activity_recognition_subset,id=c("subject","activity"),measure.vars=all_mean_variables)
```