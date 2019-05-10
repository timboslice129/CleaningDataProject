##load all packages we need for our analysis ##
library(dplyr)
library(reshape2)

##Reading in all files associated with dataset into R objects

x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
features <- read.table("UCI HAR Dataset/features.txt")

## merge study and test measurements
StudyandTest <- rbind(x_test, x_train)

## subset features column from dataset as a character vector so we can name variables of our main dataframe ##
features_vector <- as.character(features[,2])

## use features vector to name variables of our studyandtest dataframe ##
names(StudyandTest) <- features_vector

#subset to only mean and std of measurements
StudyandTestMeanSTD <- StudyandTest[,grep("mean|std", features_vector)]

## merge subject datasets ##
subjects <- rbind(subject_test, subject_train)

## merge activity datasets ##
activity <- rbind(y_test, y_train)

## bind merged subject and activity datasets to main dataframe ##

activitymeanstd <- cbind(activity, StudyandTestMeanSTD)
complete_data <- cbind(subjects, activitymeanstd)

#name subject and activity columns#
names(complete_data)[1] <- "subject"
names(complete_data)[2] <- "activity"

## convert our activity and subject columns to  factors and assign levels based on the order of the activity.txt file  ##

complete_data$activity <- factor(complete_data$activity, labels = c("Walking", "WalkingUpstairs", "WalkingDownstairs", "Sitting", "Standing", "Laying"))

complete_data$subject <- factor(complete_data$subject)
## next we are going to convert the dataset to a tibble for easier viewing  ##

complete_data <- tbl_df(complete_data)

## remove unwanted characters in variable names ##
names1 <- names(complete_data)
names1 <- gsub("\\(", "", names1)
names1 <- gsub("\\)", "", names1)
names1 <- gsub("-", "", names1)
names(complete_data) <- names1

## Melt the data frame so all the measurement variables are under one column.##
complete_data_melt <- melt(complete_data, id = c("subject", "activity"))

## now we can use the dcast function to calculate the mean of each variable grouped by subject and activity ##
tidy_data <- dcast(complete_data_melt, subject + activity ~ variable, mean)

## save tidy dataset as a new file ##

write.table(tidy_data, file = "tidydata.txt")





                      



