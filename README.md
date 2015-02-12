# Getting and Cleaning Data - Course Project
#### In-depth code explanation.

The code file itself is pretty well documented, but this file will go into greater depth. Note that I assume you have kept the original file structure of the data *and that this folder is located in your working directory* as per the instructions in the spec. 

Lines 18-21 of the run_analysis.R file simply checks to see if the user has installed the required package `dplyr` and loads it if installed, otherwise installs it and then loads it.

Lines 25 - 27 simply read in the `features.txt` and `activity_labels.txt` files -- note that these files are read in as strings and not factors. That's important for later. 

Lines 31 - 33 then read in the test data. Lines 36 and 37 initialize a data frame and then combine the test data. This also works as a simple check since `cbind()` won't work unless the vectors you are combining have the same number of rows.

Lines 40 and 41 simply remove the raw data (`rm()`) and clear them from RAM (`gc()`). Not necessary on most modern computers, but it's good practice if working with very large raw files.

Lines 43 - 50 repeat the same data import steps as performed on the test data but with the training data instead. We now have two dataframes with the same number of columns -- one representing the test data and one representing the training data. Line 53 then combines them together.

Line 56 and 57 clear out the raw (unneeded) objects from the environment again.

Part of the assignment requires making nice variable names in our dataframe. Thankfully, we already imported most of the column names in our `features` object (lines 25 and 26). Thus, line 60 simply names the first two columns as `subject` and `activity`, respectively and then the remaining columns are named according to the original authors naming scheme.

Lines 66 to 68 will find only the columns we want. We need columns 1 and 2 (`subject` and `activity`). We also need all columns that contain `mean()` and `std()` so we use `grep()` to find it. Note here that `fixed = TRUE` is required or you will pick up columns you don't need (e.g., `meanFreq`). Thus, `columns` now represents the indices of the columns we want to keep. We can then just slice out the columns using standard `[]` notation (line 69).

Line 72 uses the author's description of the activities to add labels to our dataset and make the activities a little easier to understand.

Lines 76 to 78 then perform the appropriate aggregation and then summarization. Specifically, line 76 tells R to store the new data in a dataframe called `tidy_data`. `%>%` acts as a pipe and can be thought of as the equivalent of saying "then". Thus, we are saying, "Look at `data`, *then* group it by `subject` and `activity`, *then* summarize each column by taking the mean."

Finally, line 81 saves the data as per the spec's instructions.

