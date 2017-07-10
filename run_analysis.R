
getwd()
if(!file.exists("C:\\Users\\charles\\Desktop\\couseras\\course2\\Assigndata")){
  dir.create("C:\\Users\\charles\\Desktop\\couseras\\course2\\Assigndata")}
setwd("C:\\Users\\charles\\Desktop\\couseras\\course2\\Assigndata") 

    #install Packages
install.packages("downloader")
install.packages("data.table")
install.packages("dplyr")

    #Loading the require Packages
library(downloader)
library(data.table)
library(dplyr)

    #Downloading and unzip Data
url <- "http://archive.ics.uci.edu/ml/machine-learning-databases/00240/UCI%20HAR%20Dataset.zip" 
download.file(url, destfile = "data.zip", mode = "wb") 
unzip(zipfile="data.zip", exdir = "./Assigndata") 

    #Reading in Dataset

    # Reading in trainings tables:
subject_train <- read.table("./Assigndata/UCI HAR Dataset/train/subject_train.txt")
x_train <- read.table("./Assigndata/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./Assigndata/UCI HAR Dataset/train/y_train.txt")

    # Reading in testing tables:
subject_test <- read.table("./Assigndata/UCI HAR Dataset/test/subject_test.txt")
x_test <- read.table("./Assigndata/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./Assigndata/UCI HAR Dataset/test/y_test.txt")

    # Reading in feature table:
features <- read.table('./Assigndata/UCI HAR Dataset/features.txt')
#features

  # Reading in activity labels:
activity_Labels = read.table('./Assigndata/UCI HAR Dataset/activity_labels.txt')
activity_Labels

    # Assigning Column Names
colnames(subject_train) <- "subjectId"
colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityId"

colnames(subject_test) <- "subjectId"
colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"

colnames(activity_Labels) <- c('activityId','activityType')
#colnames(activity_Labels) 
    # Merge the training and the test sets to create one data set

    # Merging
mg_train <- cbind(y_train, subject_train, x_train)
mg_test <- cbind(y_test, subject_test, x_test)
All <- rbind(mg_train, mg_test)
View(All)

    #Extracting only the measurements onthe mean and standard deviation for eachmeasurement

   #Naming the columns
colNames <- colnames(All)
#colNames

    #Extracts only the measurements on the mean and standard deviation for each measurement. 
mean_and_std <- (grepl("activityId" , colNames) | grepl("subjectId" , colNames) | 
                   
                grepl("mean" , colNames) | grepl("std" , colNames) 
                 
)

#mean_and_std

   #Uses descriptive activity names to name the activities in the data set

   #subsetting the Vector
set_Mean_Std <- All[ , mean_and_std == TRUE]
#View(set_Mean_Std)

set_ActivityNames <- merge(set_Mean_Std, activity_Labels,by='activityId',all.x=TRUE)
#View(set_ActivityNames)

    #Appropriately labels the data set with descriptive variable names.

    #Creating tidyset
set_Tidy <- aggregate(. ~subjectId + activityId, set_ActivityNames, mean)
#View(set_Tidy)

    #Creating a second independent tidy dataset with the average of each variable for each activity and eachsubject
set_Tidy1 <- set_Tidy[order(set_Tidy$subjectId, set_Tidy$activityId),]
#View(set_Tidy1)

write.table(set_Tidy1, "Tidy.txt", row.name=FALSE)