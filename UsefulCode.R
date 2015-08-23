library(RCurl)

if (!file.info('UCI HAR Dataset')$isdir) {
  dataFile <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
  dir.create('UCI HAR Dataset')
  download.file(dataFile, 'UCI-HAR-dataset.zip')
  unzip('./UCI-HAR-dataset.zip')
}