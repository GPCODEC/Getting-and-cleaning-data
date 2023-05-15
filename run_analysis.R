rm(list =ls())
library(dplyr)

filename <- "getting_cleaning_data_finalproject"
if (!file.exists (filename)){
    fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileurl,filename, method = "curl")
    
}

if (!file.exists("project_datasets")){
    unzip(filename)
}

features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n", "functions"))
head(features)
activities <- read.table("UCI HAR Dataset/activity_labels.txt",
                         col.names = c("code","activity"))
activities
str(features)
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", 
                           col.names = "subject" )
head(subject_test, n = 10)
x_test <-  read.table("UCI HAR Dataset/test/X_test.txt",
                      col.names = features$functions)
str(x_test)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", 
                     col.names = "code")
head(y_test)
subject_train <- read.table("UCI HAR DAtaset/train/subject_train.txt",
                            col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt",
                      col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", 
                       col.names = "code")

x <- rbind(x_train,x_test)
y <- rbind(y_train, y_test)
subject <- rbind(subject_train, subject_test)
full_data <- cbind(subject, y,x)
extracted_data <- full_data %>% select(subject, code, contains("mean"),
                                       contains("std"))
rm(subject_test,subject_train,x,y,features,subject,x_test,x_train)

activities[extracted_data$code,2]
extracted_data$code
extracted_data$code <-activities[extracted_data$code, 2]

names(extracted_data)
names(extracted_data)[2] ="activity"
names(extracted_data) <- gsub("Acc","Accelerometer", names(extracted_data))
names(extracted_data) <- gsub("Gyro","Gyroscope", names(extracted_data))
names(extracted_data) <- gsub("BodyBody", "Body", names(extracted_data))
names(extracted_data) <- gsub("Mag","Magnitude", names(extracted_data))
names(extracted_data) <- gsub("^t","Time", names(extracted_data))
names(extracted_data) <- gsub("^f", "Frequency", names(extracted_data))
names(extracted_data) <- gsub("meanFreq","meanfrequency", names(extracted_data))
names(extracted_data) <- gsub("\\.","_",names(extracted_data))
names(extracted_data) <- gsub("__$","",names(extracted_data))
names(extracted_data) <- gsub("___", "_", names(extracted_data))
names(extracted_data) <- gsub("_$","", names(extracted_data))
names(extracted_data) <- gsub("tBody", "timebody", names(extracted_data))
names(extracted_data) <- gsub("^angle","Angle", names(extracted_data))

summarised_data <- extracted_data %>% group_by(subject, activity) %>%
summarise_all(funs(mean))

write.table(summarised_data,"summarised_data.txt", row.names = FALSE)
