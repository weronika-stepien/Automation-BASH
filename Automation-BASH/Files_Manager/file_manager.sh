#!/bin/bash

. ./functions_library.sh || { echo "Failed to source functions_library"; exit 1; }

<< INFO

Title: File Manager
Version: 1.0
Author: Weronika Stępień
Purpose: Automated file location and management
Features:
	* Flexible search options
	* Detailed file information display
	* Customizable file copying and moving
	* Error handling and user feedback

Description:
	A Bash-based file manager designed to assist with file searching and manipulation tasks. Designed to handle both
	single and multiple file operations, this script can search, copy, move, and delete files interactively across the system.
	Users are presented with real-time feedback, and the script includes confirmation prompts to safeguard against accidental
	deletions or overwrites. Users can also export file details, which include file size, type, and absolute path to external logs

INFO

#
#
######################## GLOBAL VARIABLES AND FUNCTIONS ##############################################################################
#
#

#
# Getting terminal width and height
#

rows=$(tput lines)
cols=$(tput cols)

#
# Function to display the main menu
#

main_menu()
{
	clear

	terminal_stars
	center_text "| FILE MANAGER |"
	terminal_stars

	echo
        center_text "WHAT DO YOU WISH TO DO?"
        echo
        center_block_numeric "Find" "Copy" "Move" "Delete"

	quit_message
}


#
# Function that allows to select the number of files to perform the operation
#

operate_answer()
{
	quit_message

        echo
        center_text "On how many files you want to operate on?"
        echo

        echo
        center_block_numeric "Single file" "Multiple files"
        echo

        echo
        read -p "$(center_text "Choice: ")" choice
        echo

}

#
# Function to set find menu
#

find_option()
{
        clear

        terminal_stars
        center_text "| FILE MANAGER |"
	center_text "| FIND |"
        terminal_stars

	operate_answer

	case $choice in

		1)
		find_single

		;;

		2)
		find_multi

		;;

		[Qq*] | [Qq*]uit | [Qq*]UIT)
        	quit2 "exit 0" "main_menu"

        	;;


		*)
		center_text "Invalid choice!"
                center_text "Please choose from displayed options"

		sleep 1

		find_option

                ;;


	esac
}

#
# Function to search for a file in the whole system
#

find_single()
{
	clear

        terminal_stars
        center_text "| FILE MANAGER |"
        center_text "| FIND | SINGLE FILE |"
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
		    	find_single
	    	else
		    	quit2 "exit 0" "find_single"
	    	fi

    	else
	    	# If multiple files are found, display them for user to select
	    	file_count=$(echo "$search_file" | wc -l)

	    	if [ "$file_count" -gt 1 ]
	    	then
		    	echo
		    	echo "Multiple files named '$file_name' were found:"
		    	echo

		    	# Displaying the files with a numbered list
		    	echo
		    	echo "$search_file" | nl
		    	echo

		    	# Prompting the user to choose a file
		    	read -p "Please enter the number of the file you want to choose: " file_choice

                    	# Validating the user choice and selecting the corresponding file
            	    	selected_file=$(echo "$search_file" | sed -n "${file_choice}p")

		    	if [ -z "$selected_file" ]
		    	then
			    	echo
			    	center_text "Invalid choice. Please try again"
			    	echo

			    	sleep 1

                            	find_single
		    	fi

	    	else
		    	selected_file="$search_file"
	    	fi

	    	echo
	    	center_text "File '$file_name' found at: $selected_file"
	    	echo

            	# Show file details
            	file_size=$(du -h "$selected_file" | cut -f1)
            	file_type=$(file "$selected_file" | awk -F: '{print $2}')
            	file_permissions=$(ls -l "$selected_file" | awk '{print $1}')
            	absolute_path=$(realpath "$selected_file")

	    	echo "File name: $file_name"
	    	echo "File Size: $file_size"
            	echo "File Type: $file_type"
            	echo "File Permissions: $file_permissions"
            	echo "Absolute Path: $absolute_path"

	    	echo

            	# Provide options to the user
            	center_text "Would you like to:"
	    	center_block_numeric "Search for another file" "Save information to '${file_name}-info.txt'" "Exit"

	    	echo
	    	read -p "$(center_text "Please enter your choice: ")" user_choice
	    	echo

	    	case $user_choice in

			1)
			find_single

			;;

			2)
			echo "File name: $file_name" > "${file_name}-info.txt"
                	echo "File Size: $file_size" >> "${file_name}-info.txt"
                	echo "File Type: $file_type" >> "${file_name}-info.txt"
                	echo "File Permissions: $file_permissions" >> "${file_name}-info.txt"
                	echo "Absolute Path: $absolute_path" >> "${file_name}-info.txt"

                	echo "Information successfully saved to '${file_name}-info.txt'"

			;;

			3)
                	quit2 "exit 0" "find_single"

			;;

			*)
			echo
			center_text "Invalid choice. Exiting..."
			echo

                	quit2 "exit 0" "find_single"

			;;

	    	esac

	    	echo

	    	if YesNo "Would you like to search again?"
	    	then
		    	find_single
	    	else
		    	quit2 "exit 0" "find_single"
	    	fi
    	fi


}

#
# A function to search for multiple files in the whole system
#

find_multi()
{
	clear

        terminal_stars
        center_text "| FILE MANAGER |"
        center_text "| FIND | MULTIPLE FILES |"
        terminal_stars

	# Asking for files names
    	echo
    	read -p "Please enter the file names (separated by spaces): " -a names
    	echo

    	# Searching the entire system for the provided files
    	echo
    	center_text "Searching the system for the specified files..."
    	echo

    	sleep 1

	search_results=()

    	# Finding all matching files and storing them in an array
    	for name in "${names[@]}"
	do
        	results=$(sudo find / -name "$name" 2>/dev/null)

		if [ -n "$results" ]
		then
			while IFS= read -r result
			do
				search_results+=("$result")

			done <<< "$results"
        	fi
    	done

    	# Displaying found files
    	if [ ${#search_results[@]} -eq 0 ]
	then
        	echo
        	center_text "No matching files found"
        	echo

		sleep 1

		return
    	else
        	echo "Found the following files:"
        	echo

		select_choices=()
        	count=1

        	for result in "${search_results[@]}"
		do
            		echo "$count) $result"  # Displaing full path with unique numbering

			select_choices+=("$result")
            		count=$((count + 1))
        	done

        	# Allowing the user to select multiple choices
        	echo "Please enter the numbers of the files you'd like to display information for (separated by spaces):"
        	read -a selected_indices

        	selected_paths=()

		for index in "${selected_indices[@]}"
		do
            		selected_paths+=("${select_choices[$((index - 1))]}")  # Using unique index for the selection
        	done

        	# Initializing variable to store file info for later to export
        	all_file_info=""

        	# Looping through the selected paths to display information
        	for selected_file in "${selected_paths[@]}"
		do
            		echo
            		center_text "File Info for: $selected_file"
            		echo

			file_name=$(basename "$selected_file")
            		file_size=$(du -sh "$selected_file" 2>/dev/null | cut -f1)
            		file_type=$(file -b "$selected_file")
            		file_permissions=$(ls -ld "$selected_file" | awk '{print $1}')
            		absolute_path=$(realpath "$selected_file")

            		# Display file information
            		echo "File name: $file_name"
			echo "File Size: $file_size"
            		echo "File Type: $file_type"
            		echo "File Permissions: $file_permissions"
            		echo "Absolute Path: $absolute_path"
            		echo

            		# Accumulate file info for export
            		all_file_info+="File Info for: $selected_file\n"
			all_file_info+="File name: $file_name\n"
            		all_file_info+="File Size: $file_size\n"
            		all_file_info+="File Type: $file_type\n"
            		all_file_info+="File Permissions: $file_permissions\n"
            		all_file_info+="Absolute Path: $absolute_path\n\n"
        	done

		# Asking for additional actions once after all files' information is displayed
        	echo
		center_text "What would you like to do next:"
		echo
        	center_block_numeric "Search for another file" "Save this information to 'multiple_files_info.txt'" "Exit"
		echo
		read -p "$(center_text "Choice: ")" choice

		case $choice in

			1)
			find_multi

			;;

			2)
                	echo -e "$all_file_info" > "multiple_files_info.txt"

			echo
			center_text "Information saved to 'multiple_files_info.txt'"
			echo

			;;

			3) quit2 "exit 0" "find_multi"

			;;

            		*)
			echo
			center_text "Invalid option. Returning to main menu"

			sleep 1

			find_multi

			;;
        	esac

	fi
}

#
# Function to set copy menu
#

copy_option()
{
 	clear

        terminal_stars
	center_text "| FILE MANAGER |"
        center_text "| COPY |"
        terminal_stars

	operate_answer

	case $choice in

		1)
		copy_single

		;;

		2)
		copy_multi

		;;

		[Qq*] | [Qq*]uit | [Qq*]UIT)
        	quit2 "exit 0" "main_menu"

        	;;


		*)
		center_text "Invalid choice!"
                center_text "Please choose from displayed options"

		sleep 1

		copy_option

                ;;


	esac

}

#
# Function to copy single file
#

copy_single()
{
	clear

        terminal_stars
        center_text "| FILE MANAGER |"
        center_text "| COPY | SINGLE FILE |"
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

    	# If no file is found, prompting the user again or allowing to exit
    	if [ -z "$search_file" ]
	then
        	echo
        	center_text "No file named '$file_name' found"
        	echo

        	if YesNo "Would you like to try searching for another file?"
		then
			copy_single
        	else
            		quit2 "exit 0" "copy_single"
        	fi
    	else
		# If multiple files are found, displaying them for the user to select
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
            		read -p "Please enter the number of the file you want to copy: " file_choice

            		# Validating the user choice and select the corresponding file
            		selected_file=$(echo "$search_file" | sed -n "${file_choice}p")

            		if [ -z "$selected_file" ]
			then
                		echo
				center_text "Invalid choice. Please try again"
				echo

				sleep 1

                		copy_single
			fi

		else
			selected_file="$search_file"
        	fi

		echo
        	center_text "File '$file_name' found at: $selected_file"
        	echo

        	# Asking user for the destination location
		center_text "Do you want to copy the file to the same location with a new name or a different location? (s/d):"
		read -p "$(center_text "Choice: ")" copy_choice

        	if [ "$copy_choice" == "s" ]
		then
            		# Asking for the new file name
            		read -p "Enter the new file name (e.g., ${file_name}-copy): " new_file_name

			cp "$selected_file" "$(dirname "$selected_file")/$new_file_name"

			echo
			center_text "File copied successfully as '$new_file_name' in the same location"
			echo

        	elif [ "$copy_choice" == "d" ]
		then
            		# Asking for the new location
            		read -p "Enter the new directory path: " new_dir

			cp "$selected_file" "$new_dir"

			echo
            		center_text "File copied successfully to '$new_dir'"
			echo
        	else
            		echo
			center_text "Invalid choice. Exiting copy operation..."
			echo

			sleep 1

			copy_single
        	fi

        	# After copying, asking what to do next
        	echo
        	center_text "What would you like to do: "
		echo
		center_blck_numeric "Copy another file" "Search for a file" "Exit"
		echo
		read -p "$(center_text "Choice: ")" next_action

        	case $next_action in
            	1)
                copy_single

		;;

		2)
                find_single

		;;

		3)
                quit2 "exit 0" "copy_single"

		;;

		*)
                echo
		center_text "Invalid choice. Exiting..."
		echo

                quit2 "exit 0" "copy_single"

		;;

		esac

	fi

}

#
# Function to copy multiple files
#

copy_multi()
{
	clear

        terminal_stars
        center_text "| FILE MANAGER |"
        center_text "| COPY | MULTIPLE FILES |"
        terminal_stars


    	# Asking for multiple file names
    	echo
    	read -p "Please enter the file names (separated by spaces): " -a file_names
    	echo

    	search_results=()

    	# Searching for all provided files across the system
    	echo
    	center_text "Searching the system for the specified files..."
    	echo

	sleep 1

    	for file_name in "${file_names[@]}"
	do
        	results=$(sudo find / -type f -name "$file_name" 2>/dev/null)

		if [ -n "$results" ]
		then
            		search_results+=("$results")
        	fi
    	done

    	# Displaying the search results
    	if [ ${#search_results[@]} -eq 0 ]
	then
        	echo
        	center_text "No matching files found"
        	echo

		sleep 1

		return
    	else
        	echo "Found the following files:"

		select_choices=()
        	count=1

        	for result in "${search_results[@]}"
		do
            		while IFS= read -r line
			do
                		echo "$count) $line"

				select_choices+=("$line")
                		count=$((count + 1))

			done <<< "$result"
        	done

        	# Letting the user select multiple files for copying
        	echo "Please enter the numbers of the files you'd like to copy (separated by spaces):"
        	read -a selected_indices

        	selected_paths=()

        	for index in "${selected_indices[@]}"
		do
            		selected_paths+=("${select_choices[$((index - 1))]}")
        	done

        	# Asking the user if they want to copy files to the same directory with new names
        	echo

		if YesNo "Do you want to copy the selected files to the same location with new names?"
		then
            		for path in "${selected_paths[@]}"
			do
                		file_name=$(basename "$path")
                		new_name="${file_name%.*}-copy.${file_name##*.}"

				cp "$path" "$(dirname "$path")/$new_name"

				echo
				center_text "File '$file_name' copied to the same location as '$new_name'"
				echo
            		done

		else
            		# Prompting the user for the destination directory
            		read -p "Enter the destination directory for all selected files: " dest_dir

			for path in "${selected_paths[@]}"
			do
                		file_name=$(basename "$path")

				cp "$path" "$dest_dir"

				echo
				center_text "File '$file_name' copied to $dest_dir"
				echo
            		done
        	fi

        	# Asking if the user wants to copy again, save info or exit
		echo
        	center_text "What would you like to do?"
		echo
		center_block_numeric "Copy for another files" "Save info" "Exit"
		echo
		read -p "$(center_text "Choice: ")" action

        	case $action in

			1)
			copy_multi

			;;

			2)
            		for path in "${selected_paths[@]}"
			do
                		file_name=$(basename "$path")
                		file_size=$(du -h "$path" | cut -f1)
                		file_type=$(file "$path" | cut -d: -f2)
                		file_permissions=$(stat -c "%A" "$path")
                		abs_path=$(realpath "$path")

                		echo "File Name: $file_name" > "${file_name}-info.txt"
                		echo "File Size: $file_size" >> "${file_name}-info.txt"
                		echo "File Type: $file_type" >> "${file_name}-info.txt"
                		echo "File Permissions: $file_permissions" >> "${file_name}-info.txt"
                		echo "Absolute Path: $abs_path" >> "${file_name}-info.txt"

                		echo "Information saved to ${file_name}-info.txt"
            		done

			;;

			3)
            		quit2 "exit 0" "copy_multi"

			;;

			*)
			echo
			center_text "Invalid choice. Exiting..."
			echo

                	quit2 "exit 0" "copy_multi"

			;;

			esac
	fi
}

#
# Function to set move menu
#

move_option()
{
        clear

        terminal_stars
	center_text "| FILE MANAGER |"
        center_text "| MOVE |"
        terminal_stars

	operate_answer

	case $choice in

                1)
                move_single

                ;;

                2)
                move_multi

                ;;

		[Qq*] | [Qq*]uit | [Qq*]UIT)
        	quit2 "exit 0" "main_menu"

        	;;


                *)
                center_text "Invalid choice!"
                center_text "Please choose from displayed options"

                sleep 1

                move_option

		;;

	esac
}

#
# Function to move single file
#

move_single()
{
	clear

        terminal_stars
        center_text "| FILE MANAGER |"
        center_text "| MOVE | SINGLE FILE |"
        terminal_stars


    	# Prompting the user for the file name
    	echo
    	read -p "Please enter the name of the file to move: " file_name
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

        	if YesNo "Would you like to try searching for another file to move?"
		then
            		move_single
        	else
            		quit2 "exit 0" "move_single"
        	fi

	else
        	# If multiple files are found, display them for the user to select
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
            		read -p "Please enter the number of the file you want to move: " file_choice

            		# Validating the user choice and selecting the corresponding file
            		selected_file=$(echo "$search_file" | sed -n "${file_choice}p")

            		if [ -z "$selected_file" ]
			then
                		echo "Invalid choice. Please try again"

				move_single
            		fi

		else
            		selected_file="$search_file"
		fi

		echo
        	center_text "File '$file_name' found at: $selected_file"
        	echo

        	# Asking the user if they know the target directory path
        	if YesNo "Do you know the path to the target directory?"
		then
            		# User knows the path to the target directory
            		read -p "Please enter the path to the target directory: " target_directory

            		# Checking if the target directory exists
            		if [ -d "$target_directory" ]
			then
                		# Asking for confirmation before moving the file
                		if YesNo "Are you sure you want to move the file '$file_name' to '$target_directory'?"
				then
                    			mv "$selected_file" "$target_directory"/

					echo
                    			center_text "File moved to '$target_directory'"
					echo

					sleep 1

				else
					echo
                    			center_text "Move operation canceled"
                    			echo

					sleep 1

					move_single
				fi

			else
                		echo
                		center_text "The target directory does not exist"
				echo

				sleep 1

                		move_single
			fi

		else
            		# User does not know the target directory path
            		read -p "Please enter the name of the target directory: " target_name

            		echo
            		center_text "Searching for directory '$target_name' in the entire system..."
            		echo

            		search_directory=$(sudo find / -type d -name "$target_name" 2>/dev/null)

            		# If no directory is found
            		if [ -z "$search_directory" ]
			then
                		echo
                		center_text "No directory named '$target_name' found"
                		echo

                		if YesNo "Would you like to try searching for another directory?"
				then
                    			move_single
                		else
                    			quit2 "exit 0" "move_single"
                		fi

			else
                		# If multiple directories are found, display them for the user to select
                		dir_count=$(echo "$search_directory" | wc -l)

                		if [ "$dir_count" -gt 1 ]
				then
                    			echo
                    			center_text "Multiple directories named '$target_name' were found:"
                    			echo

                    			# Displaying the directories with a numbered list
                    			echo "$search_directory" | nl
                    			echo

                    			# Prompting the user to choose a directory
                    			read -p "Please enter the number of the directory you want to move the file to: " dir_choice

                    			# Validating the user choice and selecting the corresponding directory
                    			selected_directory=$(echo "$search_directory" | sed -n "${dir_choice}p")

                    			if [ -z "$selected_directory" ]
					then
                        			echo
						center_text "Invalid choice. Please try again"
						echo

						sleep 1

						move_single
					fi

				else
					selected_directory="$search_directory"
				fi

				echo
                		center_text "Directory '$target_name' found at: $selected_directory"
                		echo

                		# Asking for confirmation before moving the file
                		if YesNo "Are you sure you want to move the file '$file_name' to '$selected_directory'?"
				then
                    			mv "$selected_file" "$selected_directory"/

					echo
                    			center_text "File moved to '$selected_directory'"
					echo

				else
					echo
					center_text "Move operation canceled"
					echo

					sleep 1

					move_single
				fi
			fi
		fi

		# Asking the user what to do next
        	if YesNo "Would you like to search for another file to move?"
		then
            		move_single
        	else
            		quit2 "exit 0" "move_single"
        	fi
	fi

}

#
# Function to move multiple files
#

move_multi()
{
	clear

    	terminal_stars
    	center_text "| FILE MANAGER |"
    	center_text "| MOVE | MULTIPLE FILES |"
    	terminal_stars

    	# Asking for files names
    	echo
    	read -p "Please enter the files to move (separated by spaces): " -a file_names
    	echo

    	# Searching the entire system for the provided files
    	echo
    	center_text "Searching the system for the specified files..."
    	echo

    	search_results=()

	for file_name in "${file_names[@]}"
	do
        	results=$(sudo find / -type f -name "$file_name" 2>/dev/null)

        	if [ -n "$results" ]
		then
            		search_results+=("$results")
        	fi
    	done

    	# Displaying found files
    	if [ ${#search_results[@]} -eq 0 ]
	then
        	echo
        	center_text "No matching files found"
        	echo

		sleep 1

		move_multi

    	else
        	echo "Found the following files:"

		select_choices=()
		count=1

        	for result in "${search_results[@]}"
		do
            		echo "$count) $result"

			select_choices+=("$result")
            		count=$((count + 1))
        	done

        	# Allowing the user to select multiple files to move
        	echo "Please enter the numbers of the files you'd like to move (separated by spaces):"
        	read -a selected_indices

        	selected_paths=()

		for index in "${selected_indices[@]}"
		do
            		selected_paths+=("${select_choices[$((index - 1))]}")
        	done

        	# Asking if the user knows the destination path
        	if YesNo "Do you know the target directory path? (Y/N): "
		then
            		read -p "Please enter the target directory: " target_dir

		else
            		read -p "Please enter the name of the target directory: " dir_name

            		# Searching for the target directory
            		echo
            		center_text "Searching for directory '$dir_name' in the entire system..."
            		echo

			search_dir=$(sudo find / -type d -name "$dir_name" 2>/dev/null)

            		# If no directory is found
            		if [ -z "$search_dir" ]
			then
                		echo
                		center_text "No directory named '$dir_name' found"
                		echo

				sleep 1

				move_multi

			else
                		# If multiple directories are found, allow user to choose
                		dir_count=$(echo "$search_dir" | wc -l)

				if [ "$dir_count" -gt 1 ]
				then
                    			echo
                    			center_text "Multiple directories named '$dir_name' found:"
                    			echo

					echo "$search_dir" | nl

                    			read -p "Please enter the number of the directory to use: " dir_choice

					target_dir=$(echo "$search_dir" | sed -n "${dir_choice}p")
                		else
                    			target_dir="$search_dir"
				fi
			fi
		fi

        	# Confirm before moving files
        	echo
        	center_text "You have chosen to move the following files:"
        	echo

		for file in "${selected_paths[@]}"
		do
            		echo "$file"
        	done

		echo
		center_text "To the directory: $target_dir"
		echo

        	if YesNo "Are you sure you want to proceed? (Y/N): "
       		then
            		for file in "${selected_paths[@]}"
			do
                		mv "$file" "$target_dir"

				echo "Moved '$file' to '$target_dir'"
            		done

			echo
            		center_text "Files successfully moved!"
            		echo
        	else
			echo
            		center_text "Move operation cancelled"
			echo

            		sleep 1

			move_multi
        	fi

        	# Giving user options after the move operation
        	echo
		center_text "What would you like to do next?"
		echo
		center_block_numeric "Move more files" "Exit"
        	echo
		read -p "$(center_text "Please enter your choice: ")" next_choice

        	case $next_choice in
        		1)
            		move_multi

			;;

			2)
            		quit2 "exit 0" "move_multi"

			;;

			*)
			echo
            		center_text "Invalid choice. Exiting..."
			echo

			sleep 1

            		quit2 "exit 0" "move_multi"

			;;
        	esac
	fi

}

#
# Function to set delete menu
#

delete_option()
{
        clear

        terminal_stars
	center_text "| FILE MANAGER |"
        center_text "| DELETE |"
        terminal_stars

	operate_answer

	case $choice in

                1)

                delete_single
                ;;

                2)
                delete_multi

                ;;

		[Qq*] | [Qq*]uit | [Qq*]UIT)
		quit2 "exit 0" "main_menu"

        	;;


                *)
                center_text "Invalid choice!"
                center_text "Please choose from displayed options"

                sleep 1

                delete_option

		;;
	esac

}

#
# Function to delete single file
#

delete_single()
{
	clear

        terminal_stars
        center_text "| FILE MANAGER |"
        center_text "| DELETE | SINGLE FILE |"
        terminal_stars


	# Prompting the user for the file name
    	echo
    	read -p "Please enter the name of the file to delete: " file_name
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
            		delete_single
        	else
            		quit2 "exit 0" "delete_single"
        	fi

	else
        	# If multiple files are found, displaying them for user to select
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
            		read -p "Please enter the number of the file you want to delete: " file_choice

            		# Validating the user choice and selecting the corresponding file
            		selected_file=$(echo "$search_file" | sed -n "${file_choice}p")

            		if [ -z "$selected_file" ]
			then
                		echo
				center_text "Invalid choice. Please try again"
				echo

				sleep 1

                		delete_single
			fi

        	# Logic for when only one file found
       		else
            		selected_file="$search_file"
        	fi

        	echo
        	center_text "File '$file_name' found at: $selected_file"
        	echo

        	# Ask for confirmation before deletion
        	if YesNo "Are you sure you want to delete this file: '$selected_file'?"
        	then
			rm "$selected_file"

			if [ $? -eq 0 ]
			then
                		echo
                		center_text "File '$selected_file' has been successfully deleted."
                		echo
            		else
                		echo
                		center_text "Error: Unable to delete file '$selected_file'"
                		echo

				sleep 1

				quit2 "exit 0" "delete_single"
            		fi

		else
            		echo
            		center_text "File deletion canceled."
            		echo

			echo
                        center_text "Error: Unable to delete file '$selected_file'"
                        echo

                        sleep 1

                        quit2 "exit 0" "delete_single"
        	fi

        	if YesNo "Would you like to delete another file?"
        	then
            		delete_single
        	else
            		quit2 "exit 0" "delete_single"
        	fi
    	fi
}

#
# Function to delete multiple files
#

delete_multi()
{
	clear

        terminal_stars
        center_text "| FILE MANAGER |"
        center_text "| DELETE | MULTIPLE FILES |"
        terminal_stars


	# Asking for file names
    	echo
    	read -p "Please enter the names of the files you want to delete (separated by spaces): " -a file_names
    	echo

    	# Searching the entire system for the provided files
    	echo
    	center_text "Searching the system for the specified files..."
    	echo

	sleep 1

    	search_results=()

    	for file_name in "${file_names[@]}"
	do
        	results=$(sudo find / -type f -name "$file_name" 2>/dev/null)

        	if [ -n "$results" ]
		then
            		search_results+=("$results")
        	fi
    	done

    	# Displaying found files
    	if [ ${#search_results[@]} -eq 0 ]
	then
        	echo
        	center_text "No matching files found."
        	echo

		sleep 1

		delete_multi
    	else
        	echo "Found the following files:"

		select_choices=()
        	count=1

        	for result in "${search_results[@]}"
		do
            		echo "$count) $result"

			select_choices+=("$result")
            		count=$((count + 1))
        	done

        	# Allowing the user to select multiple choices for deletion
        	echo "Please enter the numbers of the files you'd like to delete (separated by spaces):"
        	read -a selected_indices

        	selected_paths=()

        	for index in "${selected_indices[@]}"
		do
            		selected_paths+=("${select_choices[$((index - 1))]}")
        	done

        	# Confirm deletion for each file
        	total_files=${#selected_paths[@]}
        	current_file_num=1

        	for file in "${selected_paths[@]}"
		do
            		echo
            		center_text "File $current_file_num/$total_files :"
            		center_text "$file"

			if YesNo "Are you sure you want to delete this file?"
            		then
                		rm "$file"

				if [ $? -eq 0 ]
				then
                    			echo
                    			center_text "File '$file' has been successfully deleted."
                    			echo
                		else
                    			echo
                    			center_text "Error: Unable to delete file '$file'"
                    			echo
                		fi

			else
                		echo
                		center_text "Deletion canceled for '$file'"
                		echo
            		fi

			current_file_num=$((current_file_num + 1))
        	done

        	# Asking if the user wants to delete more files
        	if YesNo "Would you like to delete more files?"
        	then
            		delete_multi
        	else
            		quit2 "exit 0" "delete_multi"
        	fi
	fi


}

#
#
######################### MAIN CODE LOGIC #############################################################################################
#
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

	find_option

	;;

	2)

	copy_option

	;;
#
#
#
        3)

	move_option

        ;;

#
#
#
	4)

	delete_option

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

		sleep 1

		main_menu


		;;
	esac

fi


done

#
#
######################### THE END #####################################################################################################
