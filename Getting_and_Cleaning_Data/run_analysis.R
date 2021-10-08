library(dplyr)
library(purrr)

## Downloads the dataset (downloads only one time as it checks if already exists)
downloadDataset <- function(){
  filename <- "UCI_HAR_Dataset.zip"
  
  # Checking if archive already exists.
  if (!file.exists(filename)){
    fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileURL, filename)
  }  
  
  # Checking if folder exists
  if (!file.exists("UCI HAR Dataset")) { 
    unzip(filename) 
  }
}

# Merges the training and the test sets to create one data set.
mergeTrainAndTestData <- function() {
  features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
  activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
  subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
  x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
  y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
  subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
  x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
  y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")
  
  # Combine Train and test datasets
  X <- rbind(x_train, x_test)
  Y <- rbind(y_train, y_test)
  Subject <- rbind(subject_train, subject_test)
  cbind(Subject, Y, X)
}

# Uses descriptive activity names to name the activities in the data set.
replaceActivityCodeWithLabel = function(rawData) {
  rawData %>% mutate(code=activities[data.uci$code, "activity"]) %>% 
    rename(activity = code)
}

# Extracts only the measurements on the mean and standard deviation for each measurement.
selectRequiredColums = function(rawData) {
  rawData %>% select(subject, activity, contains("mean"), contains("std"))
}

# Appropriately labels the data set with descriptive variable names.
makeColumnNamesDescriptive <- function(rawData) {
  rawData %>% rename_with(partial(gsub, "Acc", "Accelerometer")) %>%
    rename_with(partial(gsub, "Gyro", "Gyroscope")) %>%
    rename_with(partial(gsub, "BodyBody", "Body")) %>%
    rename_with(partial(gsub, "Mag", "Magnitude")) %>%
    rename_with(partial(gsub, "^t", "Time")) %>%
    rename_with(partial(gsub, "^f", "Frequency")) %>%
    rename_with(partial(gsub, "angle", "Angle")) %>%
    rename_with(partial(gsub, "gravity", "Gravity")) %>%
    rename_with(partial(gsub, "[.]+", ".")) %>%
    rename_with(partial(gsub, "[.]$", ""))
}

# Creates a second, independent tidy data set with the average of each variable
# for each activity and each subject.
aggregateDataBySubjectAndActivity = function(tidyData) {
  tidyData %>%
    group_by(subject, activity) %>%
    summarise_all(funs(mean)) %>%
    ungroup
}

# Dump aggregated tidy data to file
dumpAggregatedTidyData = function(aggregatedTidyData) {
  write.table(aggregatedTidyData, "UCI.Summary.txt", row.name=FALSE)
}

# Run all the steps in order
downloadDataset()
mergeTrainAndTestData() %>%  
  replaceActivityCodeWithLabel  %>% 
  selectRequiredColums %>% 
  makeColumnNamesDescriptive %>% 
  aggregateDataBySubjectAndActivity %>%
  dumpAggregatedTidyData
