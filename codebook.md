# CodeBook

Here is the code book that describes the variables, data, and transformations performed to clean up the data within run_analysis.R

## Variables

    trainURL | File Path for the training data
    testURL | File Path for the testing data
    dt_train | var for training data table
    dt_test | var for testing data table
    dt_traintest | var for r-combined training and test data
    train_subjectURL | File Path for the subject training data
    test_subjectURL | File Path for the subject testing data
    dt_subject_train | var for subject testing data table
    dt_subject_test | var for subject testing data table
    train_activityURL | File path for the training activity file
    test_activityURL | File path for the testing activity file
    dt_activity_train | var for activity training data table
    dt_activity_test | var for activity testing data table
    dt_feature | var to read features.txt into
    dt | merged training and test data tables

## Data

    There are 3 logical sets of data. The subject, activity and the actual data recorded.
    These are identified by data tables above by convention dt_xxxxx.

## Transformations (see code comment for specific executions of each step)

    Step 1 Merge the training and the test sets to create one data set
    Step 2 Extract only the measurements on the mean and standard deviation for each measurement
    Step 3 Use descriptive activity names to name the activities in the data set
    Step 4 Appropriately label the data set with descriptive variable names
    Step 5 From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject
