#Returns the column names transformed into R-friendly names (see README.md for naming convention)
GetHeaders <- function() 
{
  #Read in headers as list
  temp<-(read.table("UCI HAR Dataset/features.txt", header=FALSE, 
                    sep="\n", quote="", stringsAsFactors=FALSE))$V1;
  #Remove the numeric prefix on each element in list
  temp <- sapply(temp, function(x) { strsplit(x[1], "^\\d* ", perl=TRUE)[[1]][[2]] }, USE.NAMES=FALSE);
  return(temp);
}

#Taked in a "raw" header name from the GetHeaders function, and transforms it into a name matching our
#codebook convention.  Returns "NA" if transformation failed
CleanHeaderName <- function(x)
{
  #Case 1 : time/freq domain
  if(grepl("^t", x) || grepl("^f", x))
  {
    parts <- strsplit((gsub("[()]", "", x)), "-");
    return(paste(parts[[1]], collapse="."));
  }
  #case 2, angle domain
  else if (grepl("^angle", x))
  {
    parts <- strsplit(x, "[(]")[[1]];
    parts <- gsub("[)]", "", strsplit(parts, ",")[[2]]);
    parts[1] <- paste("a", parts[1], sep="");
    return(paste(parts, collapse="."));
  }
  return(NA);
}

#Returns in the merged Test and Training set tables, with the specified column names
ReadAndMergeTables <- function(colNames)
{
  firstHalf<-read.table("UCI HAR Dataset/test/X_test.txt", col.names=colNames);
  return(rbind(firstHalf, read.table("UCI HAR Dataset/train/X_train.txt", col.names=colNames)));
}

#Returns the activity for each row
GetActivities <- function()
{
  colNames <- c("ActivityID");
  activities <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = colNames)
  activities <- rbind(activities, read.table("UCI HAR Dataset/train/y_train.txt", col.names = colNames));
  activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("ActivityID", "Activity"))
  
  #Unfortunetly, because R doesn't preseve row order with Merge(), we have to do this a bit messily
  #We'll do this by adding an $id and then sorting by it post-merge
  activities$id <- 1:nrow(activities)
  activities <- merge(activities, activityLabels, by = "ActivityID");
  return(activities[order(activities$id), ]$Activity);
}

#Read the test table in using above functions to get and transform
#column names, then rbind the training table to it
data <- ReadAndMergeTables(lapply(GetHeaders(), CleanHeaderName));
#We're going to CBind the activities to the data
data <- cbind(data, GetActivities());

#Then, we're going to transform the activity names into something more useful


