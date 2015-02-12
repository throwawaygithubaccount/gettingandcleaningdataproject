##  Coursera - Data Science - Getting and Cleaning Data Project
##  NOTE: This file assumes you maintained the folder structure in the original
##          zip file such that within your working folder, you have:
##              /UCI HAR Dataset
##                  /test
##                  /train

# You should create one R script called run_analysis.R that does the following:
#   1. Merges the training and the test sets to create one dataset.
#   2. Extracts only the measurements on the mean and standard deviation for 
#       each measurement.
#   3. Uses descriptive activity names to name the activities in the dataset
#   4. Appropriately labels the dataset with descriptive variable names.
#   5. From the dataset in step4, creates a second, independent tidy dataset 
#       with the average of each variable for each activity and each subject.

#   0. Make sure packages you need are installed.
if (require(dplyr) == FALSE){
    install.packages("dplyr")
    require(dplyr)
}

##  1. Merge the training and test sets
#   Import the column names and labels
features <- read.table("./UCI HAR Dataset/features.txt", 
                       stringsAsFactors = FALSE)
act_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", 
                         stringsAsFactors = FALSE)

#   Import the test information
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")

#   Turn it into a dataframe
subdata1 <- data.frame(x = subject_test)
subdata1 <- cbind(subdata1, y_test, X_test)

#   Remove objects from environment and clear them from RAM (optional)
rm(subject_test, X_test, y_test)
gc()

#   Import the training information
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")

#   Turn it into a dataframe
subdata2 <- data.frame(x = subject_train)
subdata2 <- cbind(subdata2, y_train, X_train)

#   Combine test and training datasets
data <- rbind(subdata1, subdata2)

#   Remove objects from environment and clear them from RAM (optional)
rm(subject_train, X_train, y_train, subdata1, subdata2)
gc()

#   Add variable names -- do this before extract. (#4 in assignment)
names(data) <- c("subject", "activity", features[, 2])

#   2. Extract only variables with mean and standard deviation
#   NOTES: Used sort() here so means would be next to respective SD. 
#       fixed = TRUE is required or you get "meanFreq". Columns 1 and 2
#       are for subject and activity, respectively.
columns <- sort(c(1, 2, 
                  grep(names(data), pattern = "mean()", fixed = TRUE), 
                  grep(names(data), pattern = "std()", fixed = TRUE)))
data <- data[, columns]

#   Add activity labels (#3 in the assignment)
data$activity <- factor(data$activity, levels = 1:6, labels = act_labels[, 2])

#   5. Create new data set with average of each variable for each activity and
#       each subject.
tidy_data <- data %>% 
    group_by(subject, activity) %>% 
    summarise_each("mean")

#   Save it
write.table(x = tidy_data, file = "./tidy_data.txt", row.names = FALSE)   
