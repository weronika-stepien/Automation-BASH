#!/bin/bash

. ./functions_library.sh || { echo "Failed to source 'functions_library'"; exit 1; }

<<INFO

Title: Keyword Founder
Version: 1.0
Author: Weronika Stępień
Purpose: Automates the process of identifying files containing specific keyword within a directory
Features:
	* Provides multiple search options: single file, directory, or multi-file search
	* Exports search results to a file for easy reference
	* Displays search occurrences directly in the terminal with numbering
	* Automatically handles file and directory paths, even if unknown to the user
	* Includes a menu system with dynamic options for various search use cases
	* Supports input validation and user-friendly error handling

Description:
	This script offers robust search functionality for analyzing keyword occurrences across files and directories,
	with a simple, user-friendly menu interface. It supports recursive file searching, system-wide search capabilities,
	and flexible output options including terminal display and file export

INFO

#
#
############################# GLOBAL VARIABLES AND FUNCIONS ############################################################################
#

#
# Getting terminal width and height
#

rows=$(tput lines)
cols=$(tput cols)



#
# Function that asks the user for knowledge of the path
#

path_answer()
{
        echo
        center_text "Are you able to provide the precise path?"
        echo

        echo
        center_text "YES                        NO"
        echo

	echo
        read -p "$(center_text "Answer: ")" answer
        echo

	quit_message
}

#
# Function for displaying menu of options
#

main_menu()
{
	clear

	terminal_stars
	center_text "| KEYWORD FOUNDER |"
	terminal_stars

	echo
        center_text "WHAT DO YOU WISH TO DO?"
        echo
        center_block_numeric "Search Single File" "Search Complete Directory" "Search Multiple Files and Directories"

	quit_message
}

#
# A function that displays the ability to search data in each file in the selected directory for the occurrence of a keyword
#

directory_search()
{
	clear

        terminal_stars
        center_text "| KEYWORD FOUNDER |"
        center_text "| COMPLETE DIRECTORY SEARCH |"
        terminal_stars

	quit_message

	echo

	path_answer

		case $answer in

		[Yy*] | [Yy*]es | [Ys*]ES)
                        path_known

                        ;;

		[Nn*] | [Nn*]o | [Nn*]O)
			path_unknown_dir

			;;

		[Qq*] | [Qq*]uit | [Qq*]UIT)
			quit2 "exit 0" "directory_search"

			;;

		*)

			center_text "To use this program you need to type in option of choice!"
        		sleep 1.75

			clear

			directory_search

			;;

	esac

}

#
# Function that displays option to search single file data for chosen keyword occurrence
#

single_file_search()
{
	clear

        terminal_stars
        center_text "| KEYWORD FOUNDER |"
        center_text "| SINGLE FILE SEARCH |"
        terminal_stars

	quit_message

        echo

	path_answer

		case $answer in

		[Yy*] | [Yy*]es | [Ys*]ES)
			path_known

			;;

		[Nn*] | [Nn*]o | [Nn*]O)
			path_unknown_single

			;;
		[Qq*] | [Qq*]uit | [Qq*]UIT)
			quit2 "exit 0" "single_file_search"

			;;

		*)

			center_text "To use this program you need to type in option of choice!"
        		sleep 1.75

			clear

			single_file_search

			;;

	esac

}

#
# A function that displays the ability to search the contents of many files in many selected directories for the use of a keyword
#

multi_search()
{
	clear

	terminal_stars
	center_text "| KEYWORD FOUNDER |"
	center_text "| MULTIPLE FILES AND DIRECTORIES SEARCH |"
	terminal_stars

       	quit_message

	echo

	path_answer

	case $answer in

		[Yy*] | [Yy*]es | [Ys*]ES)
			path_known_multi

			;;

		[Nn*] | [Nn*]o | [Nn*]O)
			path_unknown_multi

			;;
		[Qq*] | [Qq*]uit | [Qq*]UIT)
			quit2 "exit 0" "multi_files_search"

			;;

		*)

			center_text "To use this program you need to type in option of choice!"
        		sleep 1.75

			clear

			multi_files_search

			;;

	esac

}

#
# A function that searches the single path specified by the user for a keyword -> regardless of whether it is a directory or a file
#

path_known()
{
	clear

	terminal_stars
	center_text "| KEYWORD FOUNDER |"
	terminal_stars
	center_text "| PATH KNOWN |"
	terminal_stars


	# Getting the path and keyword from the user
    	read -p "What's the path -> " path
    	read -p "What's the keyword -> " keyword

	# Checking if the path points to a directory or a file
    	if [ -d "$path" ]
	then
        	# Searching the directory for files containing the keyword
        	echo
		center_text "Searching entire directory for files containing the keyword '$keyword'..."
        	echo

		sleep 1

		# Searching recursively, suppressing errors
		occurrences=$(grep -rnw "$path" -e "$keyword" 2>/dev/null)

    	elif [ -f "$path" ]
	then
        	# Search the single file for the keyword
		echo
        	center_text "Searching file '$path' for the keyword '$keyword'..."
        	echo

		echo
		occurrences=$(grep -n "$keyword" "$path")
		echo

		if YesNo "Would you like to search again?"
		then
			path_known
		else
			quit2 "exit 0" "path_known"
		fi

    	else
		echo
   	     	center_text "The provided path does not exist. Exiting....."
        	sleep 1
		return
    	fi

	# Checking if there are any occurrences of the 'keyword'
    	if [ -z "$occurrences" ]
	then
		echo
        	center_text "No occurrences of the keyword '$keyword' found"
        	echo

		if YesNo "Would you like to search again?"
		then
			path_known
        	else
           		quit2 "exit 0" "path_known"
        	fi

	else
        	# Counting the number of occurrences
        	occurrences_count=$(echo "$occurrences" | wc -l)

		echo
		center_text "Found $occurrences_count occurrences of the keyword '$keyword'."
		echo

        	# Asking the user what to do with the occurrences
		read -p "$(center_text "Would you like to view them or export them to a file? (view/export): ")" input
		echo

        	if [ "$input" == "view" ]
		then
            		echo "Displaying occurrences:"
            		echo
			echo "$occurrences" | nl  # Numbered output for viewing
			echo

			if YesNo "Would you like to search again?"
                	then
                        	path_known
                	else
                        	quit2 "exit 0" "path_known"
                	fi

		elif [ "$input" == "export" ]
		then
            		echo "$occurrences" | nl > "${keyword}_occurrences.txt"

			echo
			center_text "Occurrences successfully exported to '${keyword}_occurrences.txt'"
			echo
        	else

			center_text "Invalid choice. Please enter 'view' or 'export'"
        	fi
    	fi
}

#
# A function that searches multiple user-specified paths for a keyword occurrences -> whether they are directories or files
#

path_known_multi()
{
	clear

        terminal_stars
        center_text "| KEYWORD FOUNDER |"
        terminal_stars
        center_text "| PATH KNOWN |"
	terminal_stars


	# Prompting the user to enter multiple paths (separated by space)
    	echo
    	read -p "Please enter the paths (separated by space): " -a paths

    	# Prompting the user to enter the keyword
    	echo
	read -p "What's the keyword -> " keyword

    	total_occurrences=0
    	all_occurrences=""

    	# Looping through each path provided by the user
    	for path in "${paths[@]}"
	do

        	# Checking if the path points to a directory or a file

		if [ -d "$path" ] # Directory
		then
            		# Searching the directory for files containing the keyword and extract lines with the keyword
            		echo
		       	center_text "Searching directory '$path' for files containing the keyword '$keyword'..."
			echo

			sleep 1

            		occurrences=$(grep -rnw "$path" -e "$keyword" 2>/dev/null)

		elif [ -f "$path" ] # File
		then
            		# Searching the single file for the keyword and extract lines with the keyword
            		echo
			center_text "Searching file '$path' for the keyword '$keyword'..."
			echo

			sleep 1

            		occurrences=$(grep -n "$keyword" "$path" 2>/dev/null)
        	else
			echo
            		center_text "The provided path '$path' does not exist. Skipping..."
			echo

			sleep 1

			continue
        	fi

        	# Checking if there are any occurrences of the keyword
        	if [ -z "$occurrences" ]
		then
            		echo
			center_text "No occurrences of the keyword '$keyword' found in '$path'"
			echo
        	else
            		# Counting and collecting the occurrences
            		occurrences_count=$(echo "$occurrences" | wc -l)
            		total_occurrences=$((total_occurrences + occurrences_count))

			all_occurrences+="$occurrences"$'\n'
        	fi
    	done

    	# Providing feedback on the total occurrences found
    	if [ "$total_occurrences" -eq 0 ]
	then
        	echo
		center_text "No occurrences of the keyword '$keyword' found in the provided paths"
		echo

        	if YesNo "Would you like to search again?"
        	then
            		path_known_multi
        	else
            		quit2 "exit 0" "path_known_multi"
        	fi

	else
        	echo
		center_text "Found $total_occurrences occurrences of the keyword '$keyword'"
		echo

        	read -p "$(center_text "Would you like to view them or export them to a file? (view/export): ")" choice

        	if [ "$choice" == "view" ]
		then
			echo
            		echo "Displaying occurrences:"
			echo

            		echo "$all_occurrences" | nl  # Numbered output for viewing

			if YesNo "Would you like to try searching again?"
                	then
                        	path_known_multi
                	else
                        	quit2 "exit 0" "path_unknown_single"
                	fi


		elif [ "$choice" == "export" ]
		then
            		echo "$all_occurrences" | nl > "${keyword}_occurrences.txt"

			echo
			center_text "Occurrences successfully exported to '${keyword}_occurrences.txt'"
			echo

		else
            		echo "Invalid choice. Please enter 'view' or 'export'"


        	fi
    	fi

}

#
# A function that finds a single file specified by the user and then searches it for a keyword occurrence
#

path_unknown_single()
{
	clear

	terminal_stars
        center_text "| KEYWORD FOUNDER |"
        terminal_stars
        center_text "| PATH UNKNOWN |"
        terminal_stars


	# Prompting the user for the file name
    	echo
    	read -p "Please enter the name of the file: " file_name
    	echo

    	# Searching for the file in the entire system
    	echo
    	center_text "Searching for file '$file_name' in the entire system..."
    	echo

    	search_file=$(sudo find / -type f -name "$file_name" 2>/dev/null)

    	# If no file is found, prompting the user again or allowing them to exit
    	if [ -z "$search_file" ]
	then
        	echo
        	center_text "No file named '$file_name' found"
        	echo

        	if YesNo "Would you like to try searching for another file?"
		then
            		path_unknown_single
        	else
            		quit2 "exit 0" "path_unknown_single"
        	fi
    	else
        	# If multiple files are found, display them for user to select
        	file_count=$(echo "$search_file" | wc -l)

        	if [ "$file_count" -gt 1 ]
		then
            		echo
            		center_text "Multiple files named '$file_name' were found:"
            		echo

            		# Displaying the files with a numbered list
            		echo "$search_file" | nl
			echo

            		# Prompting the user to choose a file
            		read -p "Please enter the number of the file you want to search: " file_choice

            		# Validating the user choice and selecting the corresponding file
            		selected_file=$(echo "$search_file" | sed -n "${file_choice}p")

            		if [ -z "$selected_file" ]
			then
                		echo "Invalid choice. Please try again"

                		path_unknown_single
            		fi

		# Logic for when only one file found
		else
			selected_file="$search_file"
        	fi

        	echo
        	center_text "File '$file_name' found at: $selected_file"
        	echo

        	# Proceeding with keyword search logic as in 'path_known'
        	read -p "What's the keyword -> " keyword

        	# Searching the selected file for the keyword
        	echo
        	center_text "Searching file '$selected_file' for occurrences of the keyword '$keyword'..."
        	echo

        	occurrences=$(grep -n "$keyword" "$selected_file" 2>/dev/null)
        	occurrences_count=$(grep -c "$keyword" "$selected_file")

        	# If no occurrences are found
        	if [ -z "$occurrences" ] || [ "$occurrences_count" -eq 0 ]
		then
			echo
            		center_text "No occurrences of the keyword '$keyword' found in file '$file_name'"
            		echo

            		if YesNo "Would you like to search for another keyword?"
			then
                		path_unknown_single
            		else
                		quit2 "exit 0" "path_unknown_single"
            		fi

		# If occurrences are found
		else
			echo
            		center_text "Found $occurrences_count occurrences of the keyword '$keyword' in file '$file_name'"
            		echo

            		echo
            		read -p "$(center_text "Would you like to view them or export them to a file? (view/export):")" choice

            		if [ "$choice" == "view" ]
			then
                		echo
                		echo "Displaying occurrences:"
                		echo

                		echo "$occurrences" | nl  # Numbered output for viewing
              			echo

                		if YesNo "Would you like to search again?"
				then
                    			path_unknown_single
                		else
                    			quit2 "exit 0" "path_unknown_single"
                		fi

            		elif [ "$choice" == "export" ]
			then
               	 		echo "$occurrences" | nl > "${keyword}_occurrences.txt"

                		echo
                		center_text "Occurrences successfully exported to '${keyword}_occurrences.txt'"
                		echo

                		if YesNo "Would you like to search again?"
				then
                    			path_unknown_single
                		else
                    			quit2 "exit 0" "path_unknown_single"
                		fi

            		else
				echo
                		center_text "Invalid choice. Please enter 'view' or 'export'"
				echo

                		sleep 1

                		path_unknown_single
			fi
		fi
	fi

}

#
# A function that finds a single directory specified by the user and then searches its content for a keyword occurrence
#

path_unknown_dir()
{
	clear
	terminal_stars
        center_text "| KEYWORD FOUNDER |"
        terminal_stars
        center_text "| PATH UNKNOWN |"
        terminal_stars


	# Prompting the user for the directory name
	echo
	read -p "Please enter the name of the directory: " dir_name
	echo

    	# Searching for the directory in the entire system
    	echo
	center_text "Searching for '$dir_name' in the entire system..."
	echo

    	search_path=$(sudo find / -type d -name "$dir_name" 2>/dev/null)

    	# If no directory is found, prompting the user again or allowing them to exit
    	if [ -z "$search_path" ]
	then
		echo
        	center_text "No directory named '$dir_name' found"
		echo

        	if YesNo "Would you like to try searching for another directory?"
        	then
            		path_unknown_dir
        	else
            		quit2 "exit 0" "path_unknown_dir"
        	fi

	# If directory is found
    	else
        	echo
		center_text "Directory '$dir_name' found at: $search_path"
		echo

        	# Proceeding with keyword search logic as in 'path_known'
        	read -p "What's the keyword -> " keyword

        	# Searching the directory for files containing the keyword
        	echo
		center_text "Searching directory '$search_path' for files containing the keyword '$keyword'..."
		echo

        	occurrences=$(grep -rnl "$keyword" "$search_path" 2>/dev/null)

		# Counting all occurrences
		occurrences_count=$(grep -rc "$keyword" "$search_path" | awk -F: '{sum += $2} END {print sum}')

        	# If no occurrences are found
       	 	if [ -z "$occurrences" ] || [ "$occurrences_count" -eq 0 ]
		then
            		echo
			center_text "No occurrences of the keyword '$keyword' found"
			echo

			if YesNo "Would you like to search for another keyword?"
			then
                		path_unknown_dir
            		else
                		quit2 "exit 0" "path_unknown_dir"
            		fi

        	# If occurrences are found
		else
                	echo
			center_text "Found $occurrences_count occurrences of the keyword '$keyword'"
			echo

                	echo
			read -p "$(center_text "Would you like to view them or export them to a file? (view/export):")" choice

                	if [ "$choice" == "view" ]
			then
				echo
                    		echo "Displaying occurrences:"
				echo

                    		echo "$occurrences" | nl  # Numbered output for viewing

				echo

				if YesNo "Would you like to search again?"
				then
					path_unknown_dir
				else
					quit2 "exit 0" "path_known"
				fi

			elif [ "$choice" == "export" ]
			then
                    		echo "$occurrences" | nl > "${keyword}_occurrences.txt"

				echo
				center_text "Occurrences successfully exported to '${keyword}_occurrences.txt'"
				echo

				if YesNo "Would you like to search again?"
                                then
                                        path_unknown_dir
                                else
                                        quit2 "exit 0" "path_known"
                                fi

                	else
                    		echo "Invalid choice. Please enter 'view' or 'export'"

				sleep 1

				path_unknown_dir
                	fi

		fi
	fi

}

#
# A function that finds multiple user-specified files and directories and then searches their contents for a keyword occurrence
#

path_unknown_multi()
{
	clear

	terminal_stars
        center_text "| KEYWORD FOUNDER |"
        terminal_stars
        center_text "| PATH UNKNOWN |"
        terminal_stars


	# Asking for directories and files names
    	echo
    	read -p "Please enter the directories and file names (separated by spaces): " -a names
	echo

    	# Searching the entire system for the provided directories and files
    	echo
	center_text "Searching the system for the specified directories and files..."
	echo

	sleep 1

    	search_results=()

    	for name in "${names[@]}"
	do
        	results=$(sudo find / -name "$name" 2>/dev/null)

		if [ -n "$results" ]
		then
            		search_results+=("$results")
        	fi
    	done

	# Displaying found files and directories
    	if [ ${#search_results[@]} -eq 0 ]
	then
        	echo
		center_text "No matching files or directories found"
		echo

		sleep 1

        	return
	else
		echo "Found the following files and directories:"

		select_choices=()
		count=1

    		for result in "${search_results[@]}"
		do
        		echo "$count) $result"

			select_choices+=("$result")
        		count=$((count + 1))
    		done

		# Allowing the user to select multiple choices
    		echo "Please enter the numbers of the files/directories you'd like to search for the keyword (separated by spaces):"
    		read -a selected_indices

    		selected_paths=()

		for index in "${selected_indices[@]}"
		do
        		selected_paths+=("${select_choices[$((index - 1))]}")
    		done

		# Keyword search logic
		read -p "What's the keyword -> " keyword

    		total_occurrences=0
    		all_occurrences=""

    		for path in "${selected_paths[@]}"
		do
        		if [ -d "$path" ]
			then
            			# Searching the directory for files containing the keyword and extract lines with the keyword
            			echo
				center_text "Searching directory '$path' for files containing the keyword '$keyword'..."
				echo

				sleep 1

            			occurrences=$(grep -rnw "$path" -e "$keyword" 2>/dev/null)

			elif [ -f "$path" ]
			then
            			# Searching the single file for the keyword and extract lines with the keyword
            			echo
				center_text "Searching file '$path' for the keyword '$keyword'..."
				echo

				sleep 1

            			occurrences=$(grep -n "$keyword" "$path" 2>/dev/null | sed "s|^|$path:|")

			else
            			echo
				center_text "The provided path '$path' does not exist. Skipping..."
				echo

				sleep 1

				continue
        		fi

			# Checking if there are any occurrences of the keyword
        		if [ -z "$occurrences" ]
			then
				echo
				center_text "No occurrences of the keyword '$keyword' found in '$path'"
				echo
        		else
				# Counting and collecting the occurrences
            			occurrences_count=$(echo "$occurrences" | wc -l)
            			total_occurrences=$((total_occurrences + occurrences_count))

				all_occurrences+="$occurrences"$'\n'
        		fi
		done

    		# Providing feedback on the total occurrences found
    		if [ "$total_occurrences" -eq 0 ]
		then
        		echo
			center_text "No occurrences of the keyword '$keyword' found in the selected paths"
			echo

        		if YesNo "Would you like to search for another keyword? "
      			then
            			path_unknown_multi
        		else
            			quit2 "exit 0" "path_unknown_multi"
        		fi

		else
        		echo
			center_text "Found $total_occurrences occurrences of the keyword '$keyword'"

        		read -p "$(center_text "Would you like to view them or export them to a file? (view/export): ")" choice

        		if [ "$choice" == "view" ]
			then
            			echo "Displaying occurrences:"

				echo "$all_occurrences" | nl  # Numbered output for viewing
				echo

				if YesNo "Do you want to search again?"
				then
					path_unknown_multi
                		else
                        		quit2 "exit 0" "path_unknown_multi"
                		fi


        		elif [ "$choice" == "export" ]
			then
            			echo "$all_occurrences" | nl > "${keyword}_occurrences.txt"

				center_text "Occurrences successfully exported to '${keyword}_occurrences.txt'"
        		else
				echo
            			center_text "Invalid choice. Please enter 'view' or 'export'"
        		fi
    		fi
	fi
}




#
#
############################# MAIN CODE LOGIC #########################################################################################
#
#

#
# Clearing the screen fo readability
#

clear



#
# Enclosing everything in infinity loop to constantly ask the user about options
#

while true
do

#
# Displaying the menu
#

main_menu

#
# Reading user input
#

echo
read -p "$(center_text "Action: ")" user_input
echo


#
# Securing the program from getting the blank input to begin with
#

if [ -z $user_input ]
then
        center_text "To use this program you need to type in option of choice!"
	sleep 1.75
	clear
else

#
# Option when user knows file path
#

case $user_input in

	1)
	single_file_search

	;;

	2)

	directory_search

	;;


#
# Option when user doesn't knows file path
#

        3)

	multi_search

        ;;


#
# Quit option
#

	[Qq*] | [Qq*]uit | [Qq*]UIT)

	quit2 "exit 0" "main_menu"

	;;

#
# Deafult answer
#

	*)
		terminal_stars

		center_text "Invalid choice!"
		center_text "Please choose from displayed options"

		terminal_stars

		press_enter

		;;
	esac

fi


done

