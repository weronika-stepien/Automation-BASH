#!/bin/bash

<<INFO

Title: File Locator with Size Report
Version: 1.0
Author: Weronika Stępień
Purpose: Automates the process of finding and verifying the existence of a specified file in the current directory
Features:
	* Automated search
	* Detailed feedback

Description:
	This script automates the process of locating a specific file within the current directory and displays its detailed status.
	The user is prompted to input the file name, and the script uses 'find' and 'du' commands to search for the file.
	It provides feedback about whether the file exists or not, and if found, displays It's full path and size
	in a human-readable format.



INFO

clear

# Checking if the file exists:

echo "What are you looking for:"
read file


path=$(find . -name $file)
size=$(du -h $path)

if [ -f "$path" ]
then
	echo
	echo -e " Searched file: $file \n Status: EXISTS \n Path: $path \n Size: $size"
else
	echo -e " Searched file: $file \n Status: DOES NOT EXISTS \n Path: NOT FOUND"
fi

