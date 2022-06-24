
###############################################
#############   COURSE PROJECT   ##############
#########  Getting & Cleaning Data  ###########
###############################################


library(readxl)
library(magrittr)
library(data.table)
library(tidyverse)
library(xml2)
library(openxlsx)
library(dplyr)
library(readr)
library(httr)


###############################################
######  create a list of files to read   ######
###############################################


datafiles <- list.files(path = "C:\\Users\\aumrge\\Documents\\Coursera\\Course 03 - Getting and Cleaning Data\\Course Project\\Data\\UCI HAR Dataset\\UCI HAR Dataset", 
                   recursive = TRUE, full.names = TRUE) %>%
          .[!str_detect(., "(Signals|README|zip|info|~)")]

#################################################
##########  location and files names   ########## 
##########     in datafiles list       ##########
#################################################
#
#[1] activity_labels.txt"    
#[2] features.txt"           
#[3] test/subject_test.txt"  
#[4] test/X_test.txt"        
#[5] test/y_test.txt"        
#[6] train/subject_train.txt"
#[7] train/X_train.txt"      
#[8] train/y_train.txt"      
#
###############################################



################################################################################################################
#############################  Read files into dataframes   #################################################### 
################################################################################################################


activity_labels      <- read.csv(datafiles[1], header = FALSE, sep = "", col.names = c("Activity_ID", "Activity"))
features             <- read.csv(datafiles[2], header = FALSE, sep = "", col.names = c("Feature_ID","Feature"))

subjects_test        <- read.csv(datafiles[3], header = FALSE, sep = "", col.names = c("Subject_ID"))
subjects_Training    <- read.csv(datafiles[6], header = FALSE, sep = "", col.names = c("Subject_ID"))



activities_test      <- read.csv(datafiles[5], header = FALSE, sep = "", col.names = c("Activity_ID")) %>% 
                              left_join(activity_labels, by = c("Activity_ID" = "Activity_ID")) 

activities_Training  <- read.csv(datafiles[8], header = FALSE, sep = "", col.names = c("Activity_ID")) %>% 
                              left_join(activity_labels, by = c("Activity_ID" = "Activity_ID")) 



data_set_test        <- read.csv(datafiles[4], header = FALSE, sep = "", col.names = features$Feature) %>% 
                              select( c(contains("mean"), contains("std")))  
                     
  
data_set_training    <- read.csv(datafiles[7], header = FALSE, sep = "", col.names = features$Feature) %>% 
                              select( c(contains("mean"), contains("std")))

final_test_df        <- subjects_test %>% 
                              bind_cols(activities_test, data_set_test) %>% 
                              select( -c("Activity_ID"))

final_training_df    <- subjects_Training %>% 
                              bind_cols(activities_Training, data_set_training) %>% 
                              select( -c("Activity_ID"))

Final_data_set       <- final_test_df %>% 
                              bind_rows((final_training_df))


#######################################################
##########    Clean Up Global Environment   ###########
#########  Removal all but "Final_data_set"  ##########
##########             Optional             ###########
#######################################################
#
     rm(list = ls(pattern = "^[adfs]")  )
     rm(list)
#
#######################################################




############################################################################################
######################      PROJECT REQUIREMENTS SATISFIED     #############################
############################################################################################
#
# 1) Merges the training and the test sets to create one data set.
# 2) Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3) Uses descriptive activity names to name the activities in the data set
# 4) Appropriately labels the data set with descriptive variable names. 
#
############################################################################################

