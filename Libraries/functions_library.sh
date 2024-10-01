#!/bin/bash

<< INFO

Author: Weronika Stępień
Purpose: An program for storing all the functions ever created in case there's need to use them again
Features:
	* Organized and well commented
	* Each function have proper description
	* Each function indicates in which file it was first created
	* Each description of function includes features
	* Some functions may contain example of use

INFO

#################################### MANUAL FOR REUSING FUNCTIONS #####################################################################
#
# Source the External File in Your Main Script :
#
# 		-> source ./functions_library
# 		-> . functions_library
#
# This command loads the 'functions_library' file into the current shell session.
# It's best practise is to use absolute paths to avoid issues with relative paths when running scripts from different locations.
#
# Once the file is sourced, you can call any function defined in it as if it were part of your main script.
#
# In need to avoid sourcing the same file multiple times, conditional check can be used:
#
# 		if [ -f ./functions_library ]; then
#    			source ./functions_library
# 		fi
#
# Securing the script in case sourcing failed:
#
# 		. ./functions_library || { echo "Failed to source functions_library"; exit 1; }
#
#######################################################################################################################################

#
# Prompt User with Yes/No Confirmation
#

<< DESCRIPTION
	A function to display a string (passed in as '$*') in addition with '(Yes / No)?' question.
	User can only provide asked answer - nothing else is allowed.
	If the input from the user is 'yes' then function rerurns exit code of 0 -> which means TRUE
	If the input from the user is 'no' then function rerurns exit code of 1 -> which means FALSE

Features:
	* Infinity loop till a valid answer is entered
	* While reading the answer only first word will be stored in variable called 'answer'
	* While reading the answer in case of more than one word the rest will be stored in variable called 'rest' and discarded
	* User has a possibility to answer not only with full words but also with just letters

First Usage: 'contact_manager.sh' program

DESCRIPTION

YesNo()
{
	while true
	do
		echo -e "$* (Yes / No): \c"

		read answer rest

		case $answer in
			y|Y|Yes|YES)
				return 0
			;;

			n|N|No|NO)
				return 1
			;;

			*)
				echo "Please answer with YES / NO...."
			;;
		esac
	done

}

<< USAGE

* Syntax:
YesNo "Prompt message"

* Output:
Do you want to proceed?(Yes/No):

USAGE

#
##
#

#
# Center a Single Line of Text in the Terminal
#

<< DESCRIPTION
	A function that is centering a given string on the screen by calculating the appropriate padding based on the terminal's width.
	It takes a single argument, which is the text to be centered, and prints the text with spaces on the left so that it appears
	centered horizontally

Features:
        * Storing terminal width value in variable called 'term_width'
        * Calculating the padding required to center the text based on the terminal width and the length of the text
	* Takes one string argument and stores the value in variable called 'text'
        * Outputs the centered text using printf, ensuring proper formatting across different terminal environments

First Usage: 'contact_manager.sh' program

DESCRIPTION


center_text()
{
  local term_width=$(tput cols)
  local text="$1"
  local text_length=${#text}
  local padding=$(( (term_width - text_length) / 2 ))
  printf "%*s%s\n" "$padding" "" "$text"
}

<< USAGE

* Syntax:
center_text "String1"
center_text "String2"

echo "String3 String4"

* Output:
        String1
	String2

String3 String4

USAGE


#
##
#

#
# Center Multiple Lines of Text in the Terminal
#

<< DESCRIPTION
	 Function takes multiple lines of text, determines the longest line, and then centers all the lines within the terminal window.
 	 The terminal width is dynamically determined using tput cols, and the function calculates the necessary padding to
	 center each line

Features:
        * Dynamic terminal width detection
        * Longest line calculation
        * Accepts multiple lines as input via positional parameters ("$@"), making it versatile for centering blocks of text

First Usage: 'tools_manager.sh' program

DESCRIPTION

center_block()
{

    local term_width=$(tput cols)
    local lines=("$@")
    local max_length=0

    # Find the longest line in given String
    for line in "${lines[@]}"
    do
        [ ${#line} -gt $max_length ] && max_length=${#line}
    done

    # Center all the lines of text
    for line in "${lines[@]}"
    do
        local padding=$(( (term_width - max_length) / 2 ))
        printf "%*s%s\n" $padding "" "$line"
    done
}

<< USAGE

* Syntax:
center_block "String1" "String2" "String3"

* Output:
	String1
	String2
	String3
USAGE


#
##
#

#
# Center Multiple Lines of Text in the Terminal with Numbers
#

<< DESCRIPTION
	Takes a set of lines, finds the longest one, and then center-aligns all the lines within the terminal window while prepending
	each line with a number. The terminal width is dynamically determined using 'tput cols'

Features:
        * Dynamic terminal width detection
        * Longest line calculation
        * Numbering of lines
        * Centering with padding

First Usage: 'software_manager.sh' program


DESCRIPTION

center_block_numeric()
{
    local term_width=$(tput cols)
    local lines=("$@")
    local max_length=0

    # Find the longest line in given String
    for line in "${lines[@]}"
    do
        [ ${#line} -gt $max_length ] && max_length=${#line}
    done

    # Center all the lines of text
    for i in "${!lines[@]}"
    do
        local line="${lines[$i]}"
        local number=$((i + 1))
        local padded_line="$number. $line"
        local padding=$(( (term_width - max_length - ${#number} - 2) / 2 ))
        printf "%*s%s\n" $padding "" "$padded_line"
    done
}

<< USAGE
* Syntax:

center_block_numeric "String1" "String2" "String3"

* Output:
        1. String1
        2. String2
        3. String3
USAGE


#
##
#

#
# Generate a Divider Line of Asterisks
#

<< DESCRIPTION
	Function generates a line of asterisks (*) that is 135 characters long and prints it to the terminal.

Features:
        * Fixed length of terminal width.
        * Stores the generated asterisk line in the 'stars' variable.
        * Prints the asterisk line to the terminal using 'echo' command

First Usage: 'contact_manager.sh' program

DESCRIPTION


terminal_stars()
{
  stars=$(printf "%135s" " " | tr " " "*")
  echo "$stars"

}

<< USAGE

* Syntax:
terminal_stars

* Output:
***************************************************************************************************************************************

USAGE


#
##
#


#
# Pause Script and Prompt User to Press 'ENTER'
#

<< DESCRIPTION
	Function to pause and then refresh to the starting point.
	It's prompting the user to press the ENTER key before continuing the script'sexecution.
	It also clears the terminal after the key is pressed.

Features:
        * It checks whether the variable $option is empty. If it is, the script continues without waiting for user input.
        * Displays a centered message.
	* Pausing the script temporarily.
        * Screen clearing.

First Usage: 'contact_manager.sh' program

DESCRIPTION

press_enter()
{
  [ "$option" = ""  ] && continue

  center_text "Press <ENTER> to continue"
  read enter

  clear

}

<< USAGE

* Syntax:
press_enter

* Output:
		Press <ENTER> to continue

USAGE


#
##
#

#
# Usage function
#

<< DESCRIPTION
	Function to provide users with instructions on how to properly run a script.
	It prints a usage message showing the script's name without its directory path and any additional arguments that are passed.
	The function then exits the script with an error status 2).

Features:
        * Uses the 'basename' command to strip the directory path from the script's name.
        * Sends the usage message to 'stderr' (standard error) by redirecting output with '1>&2'.
	* Accepts additional arguments.
        * Terminates the script with an exit status code of 2, which is a convention indicating incorrect usage or missing arguments.

First Usage: 'usage_test' program

DESCRIPTION


usage()
{
  script=$1
  shift

  echo "Usage: $(basename "$script") $*" 1>&2
  exit 2
}

<< USAGE

* Syntax:
usage "my_script.sh" "arg1 arg2"

* Output:
Usage: my_script.sh arg1 arg2

USAGE

#
##
#

#
# Check if a File Exists and Display Its Information
#

<< DESCRIPTION
	Function allows to search for a file within the current directory and its subdirectories.
	It checks if the file exists, then displays the file's path and size if found.
	If the file does not exist, it informs the user accordingly.

Features:
        * Uses the 'find' command to search for the file in the current directory and all subdirectories.
        * Verifies whether the specified file exists.
	* Shows specification of the file.
        * Provides clear feedback whether the file exists or not.

First Usage: 'file_exists.sh' program

DESCRIPTION

file_exists()
{

# OPTION MESSAGE -> echo "What are you looking for:"
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

}

<< USAGE

* Syntax:
./file_exists

* Output:
	Searched file: filename
	Status: EXISTS
	Path: ./path/to/file
	Size: 1.2K

USAGE

#
##
#

#
# Quit Any Program
#

<< DESCRIPTION
	A function that prompts the user to confirm if they want to quit the program.
	If the user confirms, a message of thanks is printed, and the program exits.

Features:
        * Uses the 'YesNo()' function to ask for confirmation
        * Exits the program upon confirmation, printing a farewell message
        * Prints a line of stars to signify the program's end

DESCRIPTION

quit()
{
        echo

        center_text "You are about to exit the program....."

        if YesNo Are you sure?
        then
                center_text "Thank you for cooperation"
                center_text "BYE BYE!"

                terminal_stars

                exit 0
	else
		continue
        fi
}

<< USAGE

* Syntax:
quit

* Output:
		You are about to exit the program...
			(Yes / No): yes

		   Thank you for cooperation
			   BYE BYE!

USAGE

#
##
#

#
# Quit Any Program with Conditional Functions
#

<< DESCRIPTION
        A function that prompts the user to confirm if they want to quit. Based on their response,
	it executes one of two provided functions: one for confirming and another for declining.

Features:
        * Uses the 'YesNo()' function to ask for confirmation
        * Executes a user-provided function for confirmation
        * Clears the screen after the response

DESCRIPTION

quit2()
{
	echo
    	center_text "You are about to exit the program....."

    	if YesNo "Are you sure?"
    	then
	    	clear

	    	# If confirmed, execute the provided function or 'exit'
	    	$1
    	else
	    	clear

	    	# If declined, execute the provided function to return to the desired location
	    	$2
    	fi
}

<<USAGE

* Syntax:
quit2 "exit_function" "return_function"

* Output:
You are about to exit the program...
(Yes / No): y   # Executes "function_if_yes"

USAGE


#
##
#

#
# Display Quit Message at the Bottom of the Terminal
#

<< DESCRIPTION
        A function that displays a message at the bottom-center of the terminal, informing the user to press "Q" to quit the program

Features:
        * Dynamically calculates the padding required to center the message at the bottom of the screen
        * Saves and restores the current cursor position to avoid interfering with other output

DESCRIPTION


quit_message()
{
        # Message to display
        message="If you want to quit the program press 'Q'"

        # Calculating the position for 'message' at the bottom-center of the screen
        start_col=$(( (cols - ${#message}) / 2 ))

        # Saving the current cursor position
        tput sc

        # Moving to the bottom of the screen
        tput cup $((rows - 1)) $start_col

        # Printing message about 'Quit' option
        echo "$message"

        # Getting back at the saved cursor position
        tput rc

}

<< USAGE

* Syntax:
quit_message

* Output:
<Position -> BOTTOM/CENTER> If you want to quit the program press 'Q'

USAGE

#
##
#
