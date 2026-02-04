Code Book — UCI HAR Course Project (Getting and Cleaning Data)

1. Purpose of this document

This document describes:
	•	how to obtain and load the source dataset,
	•	what the R script does step by step,
	•	the structure of the final tidy dataset (Tidy_Final_Clean_Data.txt),
	•	the variables included, the transformations applied, and the summary statistics computed.


2. How to access the data

2.1 Download source data

The source dataset is the UCI Human Activity Recognition Using Smartphones Data Set.

The R script downloads the dataset from:
	•	https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

2.2 Folder structure

The script creates a folder called:
	•	./course_project/

and unzips the dataset so that the data are located in:
	•	./course_project/UCI HAR Dataset/



3. How to run the analysis
	1.	Open R / RStudio.
	2.	Set the working directory to the location where you want the course_project folder created.
	3.	Run the script (e.g. run_analysis.R).

The script will generate the final output file:
	•	./course_project/Tidy_Final_Clean_Data.txt

This output file is tab-delimited.


4. About the source data files used

The script uses the following files from the unzipped dataset:

Metadata
	•	features.txt (561 rows × 2 columns)
Contains the original feature index and feature names (variable names for the measurement columns).
	•	activity_labels.txt (6 rows × 2 columns)
Maps the activity code (1–6) to a descriptive activity name:
	•	WALKING
	•	WALKING_UPSTAIRS
	•	WALKING_DOWNSTAIRS
	•	SITTING
	•	STANDING
	•	LAYING

Test subset
	•	test/subject_test.txt (2947 × 1)
Subject IDs for the test set.
	•	test/X_test.txt (2947 × 561)
Measurement variables for the test set.
	•	test/y_test.txt (2947 × 1)
Activity codes (1–6) for the test set.

Train subset
	•	train/subject_train.txt (7352 × 1)
Subject IDs for the train set.
	•	train/X_train.txt (7352 × 561)
Measurement variables for the train set.
	•	train/y_train.txt (7352 × 1)
Activity codes (1–6) for the train set.


5. Description of the processing steps performed by the script

Step 1 — Create project directory

Creates a directory ./course_project if it does not exist.

Step 2 — Download and unzip

Downloads the dataset ZIP file and unzips it into the project directory.

Step 3 — Read variable names (features)

Reads features.txt and uses the feature names as column names for the measurement tables (X_test, X_train).

Transformation applied to feature names:
	•	The substring "()" is removed from feature names.
Example: tBodyAcc-mean()-X → tBodyAcc-mean-X (or similar depending on separators)

This is done to simplify the column names.

Step 4 — Read train and test tables

Reads:
	•	subjects (subject_train, subject_test)
	•	activity codes (y_train, y_test)
	•	measurements (x_train, x_test)

Step 5 — Merge train and test sets

Creates:
	•	train by column-binding subject + activity code + measurements
	•	test by column-binding subject + activity code + measurements
Then row-binds them to obtain the full dataset:
	•	dataset.merged (10299 rows × 563 columns)

Step 6 — Extract mean and standard deviation measurements

Subsets the merged dataset to keep:
	•	subject
	•	code (activity code)
	•	only variables containing "mean" or "std" in their name

Resulting object:
	•	dataset.merged_means_and_sd

Note: This selection uses contains("mean") and contains("std"). Therefore, it includes all variables whose names contain these strings (depending on the dataset naming, this may also include variables such as meanFreq).

Step 7 — Add descriptive activity names

Merges with activity_labels.txt by activity code.
	•	The column code is renamed to Activity_Code
	•	An Activity column is added with descriptive labels.

Step 8 — Clean variable names

To make measurement variable names more descriptive, the script replaces these substrings in column names:
	•	Acc → _Accelerometer_
	•	Gyro → _Gyroscope_
	•	Mag → _Magnitude_
	•	BodyBody → _Body_

These replacements are cosmetic (readability) and do not change the values.

Step 9 — Create the final tidy dataset (summary)

The script groups the data by:
	•	subject
	•	Activity_Code
	•	Activity

and computes:
	•	the mean of each numeric measurement variable for each subject-activity pair.

Resulting tidy dataset:
	•	clean_dataset (expected 180 rows: 30 subjects × 6 activities)

Step 10 — Export tidy dataset

Writes the final tidy dataset as a tab-delimited text file:
	•	./course_project/Tidy_Final_Clean_Data.txt


6. Final output: variables and summaries

6.1 Dimensions

The final tidy dataset contains:
	•	One row per subject × activity
	•	One column per summary measurement

Expected rows: 180 (30 subjects × 6 activities)

6.2 Identifier variables
	•	subject
Integer ID identifying the participant (1–30).
Unit: none (identifier)
	•	Activity_Code
Integer code 1–6 corresponding to the activity.
Unit: none (identifier)
	•	Activity
Descriptive activity label (character/factor).
Unit: none (category)

6.3 Measurement variables (summary variables)

All remaining columns are numeric and represent:

Average (mean) value of the original measurement, calculated over all observations belonging to that subject and activity.

These measurement variables come from the UCI HAR features and include only those with mean and std in the original feature names (as selected by the script).

7. Summary of transformations applied
	•	Removed "()" from feature names.
	•	Subset to keep only mean and standard deviation related variables (as defined by string matching).
	•	Added activity names using activity label mapping.
	•	Renamed and expanded abbreviations in variable names for readability.
	•	Computed mean of each numeric variable grouped by subject and activity.


8. Output file
	•	File name: Tidy_Final_Clean_Data.txt
	•	Format: tab-delimited text file
	•	Rows: subject–activity combinations
	•	Columns: identifiers + mean of selected measurement variables
