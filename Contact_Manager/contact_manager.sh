#!/bin/bash
. ./functions_library.sh || { echo "Failed to source functions_library"; exit 1; }

<< INFO

Title: Contact Manager
Version: 1.0
Author: Weronika Stępień
Purpose: A program to manage and track people's contact details, allowing users to create, view, search, and delete records
Features:
	* Menu-based
	* CRUD operations
	* Input validation and error handling
	* Provides detailed feedback
	* Utilizes external libraries

Description:
	Command-line tool to simplify the handling of the creation, retrieval, search, and deletion of contact details, such as names,
	addresses, and other personal identifiers, through a text-based interface.
	Data is stored in a external text file, enabling users to load and access their data across multiple sessions.




INFO

############################## FINAL VARIABLES AND FUNCIONS ############################################################################
#

#
# Setting name for temporary file used to hold deleted records -> 'basename $0' and '$$' are giving uniqueness to the name
#

tmpfile="/tmp/$(basename "$0").$$"

#
# Function to display the menu
#

display_menu()
{

  clear

  terminal_stars

  center_text "| CONTACT MANAGER |"

  terminal_stars

  center_text "WELCOME!"
  echo
  center_text "PLEASE CHOOSE A SUITABLE OPTION FROM BELOW:"

  terminal_stars

  center_text "C-reate"
  center_text "V-iew"
  center_text "S-earch"
  center_text "D-elete"
  center_text "Q-uit"

  terminal_stars
}

#
# Function to add records
#

create()
{

	# Prompting user about data
        read -p "First name: " first_name
        read -p "Surname: " surname
        read -p "Address: " address
        read -p "Country: " country
        read -p "City: " city
        read -p "State: " state
        read -p "Zip code: " zip_code

        terminal_stars

	# Displaying record that is going to be added
	center_text "You are about to add below record:"

	header

	single_line

	echo

	# Asking user for confirmation
	if YesNo Do you confirm?
	then
		# Sending the data to chosen file - separating every piece of information with ':' sign
		echo $first_name:$surname:$address:$country:$city:$state:$zip_code >> $fname

		if YesNo Do you want to add another one?
                then
                        create
		fi
	else
		# Giving user another chance of adding the record
                if YesNo Do you want to add another one?
                then
			clear
                        create
		else
			echo

			press_enter
                fi


	fi


}

#
# Funcion to create all the headings for data displaying -> for convenience
#

header()
{
	# Printing a horizontal line matching the width of the header
        printf "%s\n" "$(printf '%*s' 135 '' | tr ' ' '=')"

	# Printing the header with aligned column titles
    	printf "%-14s %-16s %-25s %-15s %-15s %-18s %-15s\n" \
		"First Name" "Surname" "Address" "Country" "City" "State" "Zip Code"

	# Printing a horizontal line matching the width of the header
	printf "%s\n" "$(printf '%*s' 135 '' | tr ' ' '=')"

}

#
# Function to print single line of record
#

single_line()
{
	printf "%-14s %-16s %-25s %-15s %-15s %-18s %-15s\n" \
               "$first_name" "$surname" "$address" "$country" "$city" "$state" "$zip_code"

}

#
# Function to print records in a pleasant to the eye way
#

arrange_data()
{

	sort -t : -k1,1 | while IFS=: read -r first_name surname address country city state zip_code
        do
                printf "%-14s %-16s %-25s %-15s %-15s %-18s %-15s\n" \
                       "$first_name" "$surname" "$address" "$country" "$city" "$state" "$zip_code"
        done


}

#
# Function to view the records
#

view()
{

	# Displaying information about number of stored data
    	data_number=$(wc -l < "$fname")
    	center_text "| THERE ARE $data_number CONTACTS STORED AS OF NOW |"

    	# Displaying actual data
    	terminal_stars
    	center_text "CURRENT CONTACTS:"
    	echo

    	if [ -s "$fname" ]; then
        	# Display header and format data for display
        	{
            	header
            	cat "$fname" | arrange_data
        	} | more
    	else
        	center_text "The contact manager records are empty as of now."
    	fi

    	terminal_stars
    	press_enter

}


#
# Function to search for chosen record
#

search()
{
	echo -e "Please enter key words to search for.\nPress <ENTER> for all the records.\n->\c"

	read pattern

	echo

    	# If the user did not enter a pattern, display all records
    	if [ -z "$pattern" ]; then

		clear

		terminal_stars

		center_text "| DISPLAYING ALL MATCHING RECORDS |"

		terminal_stars

		echo

		{ header; cat "$fname" | arrange_data; } | more

		press_enter
    	else
        	# Check if any records match the pattern
        	if grep -q "$pattern" "$fname"; then

			clear

			terminal_stars

			center_text "SEARCH COMPLETED SUCCESSFULLY!"

			center_text "FOUND RECORDS:"

			terminal_stars

			echo

            		{ header; grep "$pattern" "$fname" | arrange_data; } | more

			echo

			press_enter
        	else
			clear

            		center_text "RECORDS WITH \"$pattern\" PATTERN NOT FOUND"

			press_enter
        	fi

	fi




}


#
# Function to delete chosen record
#

delete()
{

	search && YesNo "Are you sure about deleting that piece of data?" || return

	if [ -z "$pattern" ]
	then
		if YesNo Are you positive on deleteing all the records?
		then
			# Clearing the file
			> "$fname"

			echo

		       	center_text "COMPLETED!"
			center_text "All the records have been deleted"
		else
			return
		fi
	else
		# Deleting chosen records by pushing them to the temprary file created in 'VARIABLES AND FUNCTIONS' area
		sed "/$pattern/d" "$fname" >> "$tmpfile"

		# Changing the name
		mv "$tmpfile" "$fname"

		center_text "COMPLETED!"
		center_text "CHOSEN RECORD HAS BEEN DELETED"

	fi



	press_enter
}


#
# Function to quit program
#

quit()
{
	center_text "You are about to exit the program....."

	if YesNo Are you sure?
        then
                center_text "Thank you for cooperation"
                center_text "BYE BYE!"

                terminal_stars

                exit 0
	fi
}

#
#
############################# MAIN CODE LOGIC #########################################################################################
#
#

#
# Clearing the screen for better readability
#

clear

#
# Making user give the program a name of file that data will be stored -> if not it will exit
#

echo -e "What is the file that you want to use?"
read -p "Name: " fname

#
# If file name was not entered -> displaying usage and exiting
#

if [ -z "$fname" ]
then
	clear
	echo "File name not specified"
	usage "$0" file
fi


#
# Checking if file with given name exists
#

if [ ! -f $fname ]
then
	center_text "File with '$fname' name does not exists...."

	# Asking the user if it should be created
	if YesNo Do want to create it?
	then
		center_text "Creating the file with '$fname' name"
		> $fname

		# Making sure that it was created succesfully
		if [ ! -w $fname ]
		then
			center_text "ERROR"
			center_text "The file with '$fname' could not be created!"
			exit 2
		fi
	else
		# If the user does not want to create the file -> exiting the program
		exit 0
	fi

# Making sure that this specific file is writible
elif [ ! -w $fname ]
then
	center_text "ERROR"
	center_text "File not writible!"
	exit 2
fi



#
# Enclosing everything in infinity loop to constantly ask the user about options
#

while true
do

#
# Displaying the menu
#

display_menu

#
# Reading user input
#

printf "%*s\n" "$width" "$string"
read -p "What do you wish to do? " option enter
terminal_stars

#
# Securing the program from getting the blank input to begin with
#

if [ -z $option ]
then
        center_text "To use this program you need to type in option of choice!"
	sleep 1.75
	clear
else

#
# Creating menu using 'case statement'
#

case $option in
	[Cc*]|"Create")

    	clear

  	terminal_stars

  	center_text "| CREATE |"

  	terminal_stars

	create

	;;

#
# Showing all the records
#

	[vV*]|"View")

	clear

       	terminal_stars

       	center_text "| VIEW |"

       	terminal_stars

	view
	;;

#
# Searching for specific record
#

	[sS*]|"Search")

	clear

        terminal_stars

        center_text "| SEARCH |"

        terminal_stars

	search
	;;

#
# Deleting records with matching pattern
#

	[dD*]|"Delete")

        clear

        terminal_stars

	center_text "| DELETE |"

        terminal_stars

	delete
	;;

#
# Quit option
#

	[qQ*]|"Quit")

	quit
	;;

#
# Deafult answer
#

	*)
		center_text "Invalid choice!"
		center_text "Please choose from displayed options"

		terminal_stars

		press_enter
		;;
	esac

fi


done

####################### THE END #######################################################################################################
