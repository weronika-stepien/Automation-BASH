#!/bin/bash

. ./functions_library.sh || { echo "Failed to source functions_library"; exit 1; }

<< INFO
Title: Directory Cleaner
Version: 1.0
Author: Weronika Stępień
Purpose: Automates the cleanup of all files within a user-specified directory
Features:
	* User-specified target directory
	* Validation and safety mechanism
	* Clear feedback
	* Automated deletion process

Description:
	This script automates the process of cleaning up directories by deleting all files within a user-specified folder.
	Designed for efficient and secure file management, it includes user confirmation steps to prevent accidental data loss.
	This program simplifies the task of clearing directories, making it a reliable solution for routine maintenance.


INFO

######################### MAIN CODE LOGIC #############################################################################################

#
# Clearing the screen for readability
#

clear

#
# Setting welcome page
#

terminal_stars
center_text "| DIRECTORY CLEANUP |"
terminal_stars

echo

#
# Getting path to the folder from user
#

read -p "What is the path to the directory you want to clean? -> " path

echo
center_text "SEARCHING...."
sleep 1
echo

#
# Searching for the directory pointed by the user
#
if [[ -d "$path" ]]
then
	center_text "DIRECTORY FOUND...."

    	echo
    	sleep 0.75

	# Prompting user for validation
    	if YesNo "Do you really want to delete all the files in $path?"
	then
		# Deleting all the files
        	rm -rf "$path"/*

        	# Informing the user about the results
        	if [[ $? -eq 0 ]]
		then
			sleep 0.75
            		center_text "SUCCESSFULLY DELETED"
        	else
            		center_text "ERROR"
            		center_text "PROGRAM RAN INTO SOME ISSUES WHILE EXECUTING"
           	 	center_text "NO CHANGES WERE MADE"
        	fi
    	else
        	center_text "NO CHANGES WERE MADE"
    	fi

else
	center_text "NO DIRECTORY FOUND MATCHING THE CRITERIA"
    	echo
	press_enter
fi
