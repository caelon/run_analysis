library(data.table)
if(!file.exists('./data')){dir.create('./data')}
setwd('./data')
fileUrl <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
download.file(fileUrl, destfile = './experimentdata.zip',method='curl')
dateDownloaded <- date()
unzip('./experimentdata.zip')
xTestData <- read.table('./UCI HAR Dataset//test/X_test.txt')
yTestData <- read.table('./UCI HAR Dataset//test/Y_test.txt')
subjectTestData <- read.table('./UCI HAR Dataset//test//subject_test.txt')
testData <- cbind(subjectTestData, yTestData, xTestData)
xTrainData <- read.table('./UCI HAR Dataset//train/X_train.txt')
yTrainData <- read.table('./UCI HAR Dataset//train/Y_train.txt')
subjectTrainData <- read.table('./UCI HAR Dataset//train//subject_train.txt')
trainData <- cbind(subjectTrainData, yTrainData, xTrainData)
fullData <- rbind(testData, trainData)
columnlabels <- read.table('./UCI HAR Dataset//features.txt')
columnlabels <- data.frame(lapply(columnlabels,as.character), stringsAsFactors = FALSE)
columnlabels <- columnlabels[,2]
clabels <- c('subjectId','activityId',columnlabels)
colnames(fullData) <- clabels
dataMeans <- data.frame(colMeans(fullData[,-c(1,2)],na.rm=TRUE))
dataSD <- data.frame(apply(fullData[-c(1,2)],2,sd,na.rm=TRUE))
actLabels <- read.table('./UCI HAR Dataset//activity_labels.txt')
fullData = merge(fullData,actLabels,by.x="activityId",by.y="V1",all=TRUE)
fullData <- fullData[,c(2,1,564,3:563)]
colnames(fullData)[colnames(fullData)=="V2"] <- 'Activity'
indFullData <- fullData[,c(1,2,4:564)]
indFullData <- as.data.table(indFullData)
indFullDataAvg <- indFullData[,lapply(.SD, mean), by = c('subjectId', 'activityId')]
indFullDataAvg <- indFullDataAvg[order(indFullDataAvg$subjectId, indFullDataAvg$activityId)]
indfullDataAvg = merge(indfullDataAvg,actLabels,by.x="activityId",by.y="V1",all=TRUE)
indfullDataAvg <- indfullDataAvg[,c(2,1,564,3:563)]
colnames(indfullDataAvg)[colnames(indfullDataAvg)=="V2"] <- 'Activity'
