Code is implemented using modular functions and each doing particular step of the data analysis

## Functions
Following function need to be executed in order.

### downloadDataset
Downloads the dataset and stores in current directory and if files are present in the directory then this won't do anything.

### mergeTrainAndTestData
Merges the training and the test sets to create one data set.

### replaceActivityCodeWithLabel
Uses descriptive activity names to name the activities in the data set.

### selectRequiredColums
Extracts only the measurements on the mean and standard deviation for each measurement.

### makeColumnNamesDescriptive
Appropriately labels the data set with descriptive variable names.

### aggregateDataBySubjectAndActivity
Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

### dumpAggregatedTidyData
Dump aggregated tidy data to file

### Run all the steps in order
```r
downloadDataset()
mergeTrainAndTestData() %>%  
  replaceActivityCodeWithLabel  %>% 
  selectRequiredColums %>% 
  makeColumnNamesDescriptive %>% 
  aggregateDataBySubjectAndActivity %>%
  dumpAggregatedTidyData```
