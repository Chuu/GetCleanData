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

ExtractMeanStDevColNamesFilter <- function(x)
{
  colNames <- colnames(data);
  return(grepl("(\\.mean\\.)|(\\.std\\.)", colNames));
}

#Take in a data frame with an Activities column, and returns a data frame with the
#Activity folded into the name
#FoldActivitiesIntoData <- function(data)
#{
#  AddActivityToColumnName <- function(group)
#  {
#    groupname <- toString(group$Activity[1]);
#    columns <- names(group);
#    return(lapply(columns, function(x) { paste(c(x, groupname), collapse=".")}));
#  }
#  
#  splitData <- split(data, data$Activity)
#  newColNames <- lapply(splitData, AddActivityToColumnName);
#  mapply()
#  
#  return(newColNames);
#}

#Read the test table in using above functions to get and transform
#column names, then rbind the training table to it
#data <- ReadAndMergeTables(lapply(GetHeaders(), CleanHeaderName));

#Now we're going to remove any column that doesn't contain Mean or StDev measures
#data <- data[, ExtractMeanStDevColNamesFilter(data)]

#We're going to CBind the activities to the data
#data$Activity <- GetActivities();

#At this point, we now have our transformed raw data to work with.  We now need a tidy data set.  We're going to
#construct a set where the columns are the mean/stdev columns, and each row represents on Activity
activities <- split(data, data$Activity);
View(activities[[1]])