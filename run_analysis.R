#### UCI HAR Course Project (Getting and Cleaning Data)

library(dplyr)
library(stringr)

#1-Create a working directory----

project_dir <- "./course_project"

if (!dir.exists(project_dir)) {
  dir.create(project_dir, recursive = TRUE)
}


#2- Download + unzip the dataset----
zip_path <- file.path(project_dir, "UCI_HAR_Dataset.zip")

download.file(
  url      = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
  destfile = zip_path,
)

unzip(zipfile = zip_path, exdir = project_dir)

data_dir <- file.path(project_dir, "UCI HAR Dataset")


#3- Read metadata: features + activity labels----
features <- read.table(
  file.path(data_dir, "features.txt"),
  col.names = c("n", "variables"),
  stringsAsFactors = FALSE
)

# Optional clean-up: remove "()" from feature names (e.g., mean() -> mean). Makes the variable names look simpler
features <- features %>%
  mutate(variables = str_replace_all(variables, "\\(\\)", ""))

# activity_labels.txt maps activity code -> activity name
activities <- read.table(
  file.path(data_dir, "activity_labels.txt"),
  col.names = c("code", "Activity"),
  stringsAsFactors = FALSE
)


#4- Read train and test datasets----
activities <- read.table("./course_project/UCI HAR Dataset/activity_labels.txt", col.names = c("code", "Activity"))
subject_test <- read.table("./course_project/UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("./course_project/UCI HAR Dataset/test/X_test.txt", col.names = features$variables)
y_test <- read.table("./course_project/UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("./course_project/UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("./course_project/UCI HAR Dataset/train/X_train.txt", col.names = features$variables)
y_train <- read.table("./course_project/UCI HAR Dataset/train/y_train.txt", col.names = "code")


#5- Merge train and test into a single dataset----
test <- cbind(subject_test, y_test, x_test)
train <- cbind(subject_train, y_train, x_train)
dataset.merged <- rbind(train, test)


#6- Keep only mean/std measurements + identifiers----
dataset.merged_means_and_sd <- dataset.merged %>% select(subject, code, contains("mean"), contains("std"))


#7- Add descriptive activity names (join instead of base merge)----
dataset.merged_means_and_sd <- merge(dataset.merged_means_and_sd, activities, by="code")
colnames(dataset.merged_means_and_sd)[1] <- "Activity_Code"



#8- Clean variable names (optional readability step)----
#These replacements are stylistic; you can adjust to your preference.
names(dataset.merged_means_and_sd) <- gsub("Acc",      "_Accelerometer_", names(dataset.merged_means_and_sd), fixed = TRUE)
names(dataset.merged_means_and_sd) <- gsub("Gyro",     "_Gyroscope_",     names(dataset.merged_means_and_sd), fixed = TRUE)
names(dataset.merged_means_and_sd) <- gsub("Mag",      "_Magnitude_",     names(dataset.merged_means_and_sd), fixed = TRUE)
names(dataset.merged_means_and_sd) <- gsub("BodyBody", "_Body_",          names(dataset.merged_means_and_sd), fixed = TRUE)


#9- Create the tidy dataset: mean of each variable for each subject-activity pair----
clean_dataset <- dataset.merged_means_and_sd %>%
  group_by(subject, Activity_Code, Activity) %>%  
  summarise(across(where(is.numeric), mean), .groups = "drop")


#10- Write output to disk (tab-delimited)----
write.table(
  clean_dataset,
  file = file.path(project_dir, "Tidy_Final_Clean_Data.txt"),
  row.names = FALSE,
  sep = "\t",
  quote = FALSE
)

