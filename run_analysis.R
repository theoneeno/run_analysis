run_analysis<-function(){
  if(!file.exists("data")){dir.create("data")} 
  #to create a folder called"data"
  
  fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileUrl,destfile="./data/data.zip")
  #download the data we need
  
  library(utils)
  unzip("./data/data.zip",exdir="./data")
  #use a packge "utils" to unzipped the data,we may install the package before
  
  features<-read.table("./data/UCI HAR Dataset/features.txt",sep='',header=F)
  x_test<-read.table("./data/UCI HAR Dataset/test/X_test.txt",sep='',header=F)
  y_test<-read.table("./data/UCI HAR Dataset/test/y_test.txt",sep='',header=F)
  subject_test<-read.table("./data/UCI HAR Dataset/test/subject_test.txt",sep='',header=F)
  x_train<-read.table("./data/UCI HAR Dataset/train/X_train.txt",sep='',header=F)
  y_train<-read.table("./data/UCI HAR Dataset/train/y_train.txt",sep='',header=F)
  subject_train<-read.table("./data/UCI HAR Dataset/train/subject_train.txt",sep='',header=F)
  #read the tables.There is no header in the table so we call header=F
  
  subject<-rbind(subject_test,subject_train)
  x<-rbind(x_test,x_train)
  y<-rbind(y_test,y_train)
  #bind test and train tables
  
  t<-grep("mean|std",features$V2)
  #to know which colums are about mean and std
  
  data_subset<-x[t]
  #subset clums mean and std
  
  data_subset<-cbind(subject,y,data_subset)
  #bind subjec, activity and the data
  
  names<-c("subject","activity",as.vector(features$V2[t]))
  names(data_subset)<-names
  #names the dataframe."subject" is the number of volunteer,"activity" is the number of activity
  #as.vector(features$V2[t])extract the right names
  
  data_subset$activity<-factor(data_subset$activity,levels=c(1,2,3,4,5,6),labels=c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING"))
  #label the activity as factor
  
  library("reshape2")
  #use the package"reshape2" to reshape data.we may install the package before.
  
  meltdata<-melt(data_subset,id=c("subject","activity"))
  finaldata<-dcast(meltdata,subject+activity~variable,mean)
  #melt data and then reshape it
  
  write.table(finaldata,file="./data/tidydataset.txt",row.names=FALSE)
  #create a txt called "tidydataset.txt",there is no row names
  return(0)
}