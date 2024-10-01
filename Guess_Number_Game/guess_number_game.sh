#!/bin/bash

. ./functions_library.sh || { echo "Failed to source functions_library"; exit 1; }

<<INFO

Title: Number Guessing Game
Version: 1.0
Author: Weronika Stępień
Purpose: A simple number guessing game with infinite attempts, guiding the player through high and low guesses
Features:
	* Colored and formatted output
	* Interactive guessing mechanism
	* Track keeping of the user attempts
	* Feedback system

Description:
	The script is an interactive number guessing game that challenges users to guess a randomly generated number.
	It provides real-time feedback after each guess, informing the user whether the guess is too high or too low
	and allows an unlimited number of attempts. Player has a way to quit the game at any time by typing "Q".

INFO

#########COLORS###############

RED=$(tput setaf 1)         # Red
GREEN=$(tput setaf 2)       # Green
BOLDGREEN=$(tput bold; tput setaf 2)   # Bold Green
BOLDRED=$(tput bold; tput setaf 1)     # Bold Red
BLUE=$(tput setaf 4)        # Blue
BOLDBLUE=$(tput setaf 33)    # Bold Blue
YELLOW=$(tput setaf 3)      # Yellow
BOLDYELLOW=$(tput bold; tput setaf 3)  # Bold Yellow
MAGENTA=$(tput setaf 5)     # Magenta
BOLDMAGENTA=$(tput bold; tput setaf 5) # Bold Magenta
CYAN=$(tput setaf 6)        # Cyan
ENDCOLOR=$(tput sgr0)       # Reset/End Color

###############################

clear

number=$RANDOM
tries=1
exit="Q"


for (( ; ; )) #INFINITY FOR LOOP
do
	echo
	read -p "$(center_text "This is your $tries try of guessing the number. What's your pick: ")" user_input
	echo

	if [ $user_input == $exit ]
        then
		center_text "${CYAN} Awww... It's so sad you gave up :'-(\n Btw the number was: ${BOLDGREEN}$number ${ENDCOLOR}"
                break

	elif [ -z $user_input ]
        then
		center_text "To play the game you need to type in some number :)"
                sleep 1

	else

		if [ $user_input -eq $number ] # equal
		then
			echo -e "${BOLDGREEN} BRAVO! Your choice was right :D ${ENDCOLOR}"
			echo -e "${BOLDGREEN} It has taken you ${BOLDBLUE}$tries tries${ENDCOLOR} ${BOLDGREEN}to find out what was the number. ${ENDCOLOR}"
			break

		elif [ $user_input -ge $number ]
		then
			center_text "${BOLDYELLOW} Damm... you went to HIGH! Try some lesser value than:${BOLDBLUE} $user_input ${ENDCOLOR}"
			echo
			echo -e "${RED} Remember if you're tired you can type in 'Q' to exit.${ENDCOLOR}"
			echo
		else
			center_text "${BOLDMAGENTA} Upss... that's to LOW! Try some higher value than:${BOLDBLUE} $user_input ${ENDCOLOR}"
			echo
			echo -e "${RED} Remember if you're tired you can type in 'Q' to exit.${ENDCOLOR}"
			echo
		fi

	fi

	tries=$((tries+1))

done
