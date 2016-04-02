library(reshape2)

filename <- "dataset.zip"

# Download and unzip data
if(!file.exists(filename)){
        fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(fileUrl, filename)
        unzip(filename)
}

activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt", stringsAsFactors = FALSE)
features <- read.table("UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)

mean_and_std <- grep(".*mean.*|.*std.*", features[,2])
mean_and_std.names <- features[mean_and_std, 2]

# load data
xTrain <- read.table("UCI HAR Dataset/train/X_train.txt")[mean_and_std]
yTrain <- read.table("UCI HAR Dataset/train/y_train.txt")
subjectTrain <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(subjectTrain, yTrain, xTrain)

xTest <- read.table("UCI HAR Dataset/test/X_test.txt")[mean_and_std]
yTest <- read.table("UCI HAR Dataset/test/y_test.txt")
subjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(subjectTest, yTest, xTest)

# merge data
dataMerge <- rbind(train, test)
colnames(dataMerge) <- c("subject", "activity", mean_and_std.names)

# step 5
dataMerge$activity <- factor(dataMerge$activity, levels = activityLabels[, 1], labels = activityLabels[, 2])
dataMerge$subject <- as.factor(dataMerge$subject)

dataMerge.melted <- melt(dataMerge, id = c("subject", "activity"))
dataMerge.mean <- dcast(dataMerge.melted, subject + activity ~ variable, mean)

# write data to file
write.table(dataMerge.mean, "tidy.txt", row.names = FALSE, quote = FALSE)
