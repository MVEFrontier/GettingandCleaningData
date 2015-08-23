run_analysis<-function()
{
    library(dplyr)
    
    currDir<-getwd()
    
    mainDir<-currDir
    dataDir<-paste(mainDir,"/UCI HAR Dataset", sep="")
    trainDir<-"./train"
    testDir<-"./test"
       
    # read in column information data.
    setwd(dataDir)
    columnNames<-read.table("features.txt")
    activityLabels<-read.table("activity_labels.txt")
    
    # eliminate characters that aren't allowed for column headers
    columnNamesClean<-gsub("-", "", columnNames$V2)

    # read the training data, and assign column headers.
    setwd(trainDir)
    trainSubjectList<-read.table("subject_train.txt")
    trainX<-read.table("X_train.txt", col.names = columnNamesClean)
    trainY<-read.table("y_train.txt")
    
    # go to the test directory, read the training data, and assign column
    # headers.
    setwd(dataDir)
    setwd(testDir)
    testSubjectList<-read.table("subject_test.txt")
    testX<-read.table("X_test.txt", col.names = columnNamesClean)
    testY<-read.table("y_test.txt")
    setwd(mainDir)
    
    # convert these into dplyr tables, which I like better.
    activityLabelsTbl<-tbl_df(activityLabels)
    
    trainSubjectListTbl<-tbl_df(trainSubjectList)
    trainXTbl<-tbl_df(trainX)
    trainYTbl<-tbl_df(trainY)
    
    testSubjectListTbl<-tbl_df(testSubjectList)
    testXTbl<-tbl_df(testX)
    testYTbl<-tbl_df(testY)
    
    # some simple renames of column headers before we start
    # this completes #4 from the checklist.
    trainSubjectListTbl<-rename(trainSubjectListTbl, SubjectID=V1)
    trainYTbl<-rename(trainYTbl, ActivityID=V1)
    testSubjectListTbl<-rename(testSubjectListTbl, SubjectID=V1)
    testYTbl<-rename(testYTbl, ActivityID=V1)
    activityLabelsTbl<-rename(activityLabelsTbl, ActivityID=V1, ActivityName=V2)
    
    
    # let's add a sequence to each of the tables to give us something to join on.
    # note that file lengths in train and test differ.
    fileRows<-count(trainYTbl)
    trainSubjectListTbl<-mutate(trainSubjectListTbl, id=seq(1, fileRows$n, by=1))
    trainXTbl<-mutate(trainXTbl, id=seq(1, fileRows$n, by=1))
    trainYTbl<-mutate(trainYTbl, id=seq(1, fileRows$n, by=1))
    fileRows<-count(testYTbl)
    testSubjectListTbl<-mutate(testSubjectListTbl, id=seq(1, fileRows$n, by=1))
    testXTbl<-mutate(testXTbl, id=seq(1, fileRows$n, by=1))
    testYTbl<-mutate(testYTbl, id=seq(1, fileRows$n, by=1))
    
    # how about an identifier that will help us know which dataset it came from?
    trainYTbl<-mutate(trainYTbl, dataSet="Train")
    testYTbl<-mutate(testYTbl, dataSet="Test")
    
    # what activities are these ids, anyway?
    # this completes item 3 on the checklist.
    trainYTbl<-left_join(trainYTbl, activityLabelsTbl)
    testYTbl<-left_join(testYTbl, activityLabelsTbl)
    
    # join all of the training tables.
    trainDataIntermediate<-inner_join(trainSubjectListTbl, trainYTbl, by=c("id"="id"))
    trainDataComplete<-inner_join(trainDataIntermediate, trainXTbl, by=c("id"="id"))
    testDataIntermediate<-inner_join(testSubjectListTbl, testYTbl, by=c("id"="id"))
    testDataComplete<-inner_join(testDataIntermediate, testXTbl, by=c("id"="id"))
    
    # lets append the training data to the test data.
    # this completes item 2 on the checklist.
    combinedData<-rbind(testDataComplete, trainDataComplete)
    
    # now we want to extract the measurements that contain mean and
    # standard deviation.
    # this completes item 2 on the checklist.
    analysisData<-select(combinedData, SubjectID, dataSet, ActivityName, contains("mean"), contains("std"))
    
    # now lets tidy the data and report the average of each variable by activity
    # and subject.  Writing the table to our directory is the last step.
    # this completes item 5 on the checklist.
    tidyData<-group_by(analysisData, ActivityName, SubjectID)
    tidyData<-summarise_each(tidyData, funs(mean), -dataSet)
    write.table(tidyData, file="tidy_data.txt", row.names = FALSE, sep="\t")
    
    # View(tidyData)
    
    # rename the columns to be more user friendly.
#     renameMap <- c("ActivityName" = "ActivityName",
#                    "SubjectID" = "SubjectID",
#                    "tBodyAccmean..X" = "Time Body Mean Acceleration X-Axis",
#                    "tBodyAccmean..Y" = "Time Body Mean Acceleration Y-Axis",
#                    "tBodyAccmean..Z" = "Time Body Mean Acceleration Z-Axis",
#                    "tGravityAccmean..X" = "Time Mean Gravity Acceleration X-Axis",
#                    "tGravityAccmean..Y" = "Time Mean Gravity Acceleration Y-Axis",
#                    "tGravityAccmean..Z" = "Time Mean Gravity Acceleration Z-Axis",
#                    "tBodyAccJerkmean..X" = "Time Mean Body Linear Acceleration X-Axis",
#                    "tBodyAccJerkmean..Y" = "Time Mean Body Linear Acceleration Y-Axis",
#                    "tBodyAccJerkmean..Z" = "Time Mean Body Linear Acceleration Z-Axis",
#                    "tBodyGyromean..X" = "Time Mean Body Angular Velocity X-Axis",
#                    "tBodyGyromean..Y" = "Time Mean Body Angular Velocity Y-Axis",
#                    "tBodyGyromean..Z" = "Time Mean Body Angular Velocity Z-Axis",
#                    

                   
                   
    # names(tidyData) <- renameMap[names(tidyData)]
    
    View(tidyData)
}