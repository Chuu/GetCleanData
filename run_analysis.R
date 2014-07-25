#Returns the column names transformed into R-friendly names (see README.md for naming convention)
GetHeaders <- function() 
{
  #Read in headers as list
  temp<-(read.table("UCI HAR Dataset/features.txt", header=FALSE, 
                    sep="\n", quote="", stringsAsFactors=FALSE))$V1;
  #Remove the numeric prefix on each element in list
  temp <- sapply(temp, function(x) { strsplit(x[1], "^\\d* ", perl=TRUE)[[1]][[2]] }, USE.NAMES=FALSE);
  temp
}

#Read the test table in, then rbind the training table to it
#test<-read.table("UCI HAR Dataset/test/X_test.txt", col.names=temp)
#test<-rbind(test, read.table("UCI HAR Dataset/train/X_train.txt", col.names=temp))