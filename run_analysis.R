dat_x_train <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt", header=FALSE, sep= "")
dat_x_test <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt", header=FALSE, sep= "")


dat_y_train <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt", header=FALSE, sep= "")
dat_y_test <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt", header=FALSE, sep= "")

dat_sub_train <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt", header=FALSE, sep= "")
dat_sub_test <- read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt", header=FALSE, sep= "")

dat_train <- cbind(dat_sub_train, dat_x_train,dat_y_train )
dat_test <- cbind(dat_sub_test, dat_x_test,dat_y_test )

dat <- rbind(dat_train, dat_test)

dat_activity_labels<-read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt", header=FALSE, sep= "")
dat_features<-read.table("./getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset/features.txt", header=FALSE, sep= "")

list_of_features <-as.character(dat_features[,2]) 
list_of_features <- make.names(list_of_features, unique=TRUE)
names(dat) <- c("subject", list_of_features, "activity")


dat_step2_1 <- select(dat,contains("subject"))
dat_step2_2 <- select(dat,contains("mean"))
dat_step2_3 <- select(dat,contains("std"))
dat_step2_4 <- select(dat,contains("activity_level"))

dat_step2 <- cbind(dat_step2_1, dat_step2_2, dat_step2_3, dat_step2_4)


dat_step3 <- merge(dat_step2, dat_activity_labels, by.x ="activity_level", by.y = "V1")
colnames(dat_step3)[colnames(dat_step3)=="V2"] <- "activity_name"

dat_step4 <- dat_step3

names(dat_step4) <- gsub("tBody", "TimeBody", names(dat_step4) ) 
names(dat_step4) <- gsub("tGravity", "TimeGravity", names(dat_step4) ) 
names(dat_step4) <- gsub("fBody", "FreqBody", names(dat_step4) ) 
names(dat_step4) <- gsub("BodyBody", "Body", names(dat_step4) ) 
names(dat_step4) <- gsub(".std", "Std", names(dat_step4) ) 
names(dat_step4) <- gsub(".mean", "Mean", names(dat_step4) ) 

dat_step5 <- dat_step4  %>% group_by(subject, activity_name ) %>% summarise_each(funs(mean))
write.table(dat_step5, "tidydata.txt", row.name=FALSE)