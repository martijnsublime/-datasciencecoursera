#### Merge the training and the test sets to create one data set 

# Train Set
activities_train = read.table("UCI HAR Dataset/train/y_train.txt")
values_train = read.table("UCI HAR Dataset/train/x_train.txt")
subject_train = read.table("UCI HAR Dataset/train/subject_train.txt")

train = cbind(subject_train,activities_train,values_train)

# Test Set
activities_test = read.table("UCI HAR Dataset/test/y_test.txt")
values_test = read.table("UCI HAR Dataset/test/x_test.txt")
subject_test = read.table("UCI HAR Dataset/test/subject_test.txt")

test = cbind(subject_test,activities_test,values_test)

# Column names
variable_names = as.vector(read.table("UCI HAR Dataset/features.txt")[,-1])
subject = c("subject")
activity = c("activity")
column_names = c(subject,activity,variable_names)

# One data set
human_activity_recognition = rbind(train,test)
colnames(human_activity_recognition) = column_names

#### Extract only the measurements on the mean and standard deviation for each measurement

mean_variable = c(grep("mean[()]",names(human_activity_recognition)))
std_variable = c(grep("std[()]",names(human_activity_recognition)))
human_activity_recognition_subset = human_activity_recognition[,c(1,2,mean_variable,std_variable)]

#### Uses descriptive activity names to name the activities in the data set
#### Appropriately labels the data set with descriptive activity names.

human_activity_recognition_subset$activity = sapply(human_activity_recognition_subset$activity,function(x) ifelse(x=="1","Walking",x))
human_activity_recognition_subset$activity = sapply(human_activity_recognition_subset$activity,function(x) ifelse(x=="2","Walking_upstairs",x))
human_activity_recognition_subset$activity = sapply(human_activity_recognition_subset$activity,function(x) ifelse(x=="3","Walking_downstairts",x))
human_activity_recognition_subset$activity = sapply(human_activity_recognition_subset$activity,function(x) ifelse(x=="4","Sitting",x))
human_activity_recognition_subset$activity = sapply(human_activity_recognition_subset$activity,function(x) ifelse(x=="5","Standing",x))
human_activity_recognition_subset$activity = sapply(human_activity_recognition_subset$activity,function(x) ifelse(x=="6","Laying",x))


#### Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
install.packages("reshape2")
library(reshape2)

all_mean_variables = c(grep("mean[()]",names(human_activity_recognition_subset),value=TRUE))
tidy_data_two = melt(human_activity_recognition_subset,id=c("subject","activity"),measure.vars=all_mean_variables)


write.table(tidy_data_two,"tidy_data_two.txt")
