library(data.table) #load data.table for use later on
if(!file.exists('./data')){dir.create('./data')} #create data directory if one doesn't exist
setwd('./data') #change to the data directory

## retrieve the dataser
fileUrl <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
download.file(fileUrl, destfile = './experimentdata.zip',method='curl')

##record the date the data was downloaded
dateDownloaded <- date()

##unzip the data
unzip('./experimentdata.zip')

## read in the test data
xTestData <- read.table('./UCI HAR Dataset//test/X_test.txt')
yTestData <- read.table('./UCI HAR Dataset//test/Y_test.txt')
subjectTestData <- read.table('./UCI HAR Dataset//test//subject_test.txt')

##combine the test data
testData <- cbind(subjectTestData, yTestData, xTestData)

##read in the training data
xTrainData <- read.table('./UCI HAR Dataset//train/X_train.txt')
yTrainData <- read.table('./UCI HAR Dataset//train/Y_train.txt')
subjectTrainData <- read.table('./UCI HAR Dataset//train//subject_train.txt')

##combine the training data
trainData <- cbind(subjectTrainData, yTrainData, xTrainData)

##combine the test data and the training data
fullData <- rbind(testData, trainData)

##add column labels
columnlabels <- read.table('./UCI HAR Dataset//features.txt')
columnlabels <- data.frame(lapply(columnlabels,as.character), stringsAsFactors = FALSE)
columnlabels <- columnlabels[,2]
clabels <- c('subjectId','activityId',columnlabels)
colnames(fullData) <- clabels

##calculate the mean and standard deviation of each data column
dataMeans <- data.frame(colMeans(fullData[,-c(1,2)],na.rm=TRUE))
dataSD <- data.frame(apply(fullData[-c(1,2)],2,sd,na.rm=TRUE))

##add labels to each activity
actLabels <- read.table('./UCI HAR Dataset//activity_labels.txt')
fullData = merge(fullData,actLabels,by.x="activityId",by.y="V1",all=TRUE)
fullData <- fullData[,c(2,1,564,3:563)]
colnames(fullData)[colnames(fullData)=="V2"] <- 'Activity'

##copy the dataset for use to calculate averages
indFullData <- fullData[,c(1,2,4:564)]
indFullData <- as.data.table(indFullData)

##calculate mean for each subject and activity
indFullDataAvg <- indFullData[,lapply(.SD, mean), by = c('subjectId', 'activityId')]

##order data by subject and activity
indFullDataAvg <- indFullDataAvg[order(indFullDataAvg$subjectId, indFullDataAvg$activityId)]

##re-attach the labels
indfullDataAvg = merge(indfullDataAvg,actLabels,by.x="activityId",by.y="V1",all=TRUE)
indfullDataAvg <- indfullDataAvg[,c(2,1,564,3:563)]
colnames(indfullDataAvg)[colnames(indfullDataAvg)=="V2"] <- 'Activity'

## create data export files
write.table(fullData, './fullActivityData.txt',sep='\t')
write.table(indFullDataAvg, './activityDataAvg.txt',sep='\t')