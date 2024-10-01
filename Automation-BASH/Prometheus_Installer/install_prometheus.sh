#!/bin/bash

. ./functions_library.sh || { echo "Failed to source functions_library"; exit 1; }

<< INFO

Title: 'Prometheus' installer
Version: 1.0
Author: Weronika Stępień
Purpose: Automation of 'Prometheus' installing process
Features:
	* Cross-platform support
	* Automated OS detection
	* Clear and structured output
	* User validation
	* Error handling

Description:
	The script is designed to streamline the setup of Prometheus on both Linux-based systems and macOS.
	It automatically detects the operating system, verifies if Prometheus is already installed, and installs it accordingly.
	The script uses a simple and interactive user interface, prompting for user confirmation before performing installation tasks.
	It is a flexible and reliable solution for automating the Prometheus setup in DevOps environments, ensuring smooth integration        into system monitoring pipelines.



INFO

######################### MAIN CODE LOGIC #############################################################################################

## COLORS ##

RED=$(tput setaf 196)
GREEN=$(tput setaf 40)
YELLOW=$(tput setaf 11)
BLUE=$(tput setaf 4)
ENDCOLOR=$(tput sgr0)

################

#
# Getting distro name and storing it in variable named 'distro'
#

distro=$(cat /etc/issue | awk '{print $1}')

#
# Clearing the screen fo readability
#

clear

#
# Styling the title message
#

terminal_stars
center_text "| PROMETHEUS |"
center_text "| INSTALLATION |"
terminal_stars

echo

#
# Checking if working OS is 'Linux' based using 'uname' command
#

if [ "$(uname)" == "Linux" ]
then

	# Checking if the software is already installed
	if command -v prometheus > /dev/null 2>&1
	then
		echo
		center_text "${GREEN}PROMETHEUS ALREADY INSTALLED${ENDCOLOR}"

	else
		center_text "Current OS is $(uname) based"
        	echo

		# Asking user for validation
		if YesNo Installation can be \done. Do you want to proceed?
		then
			if [ $distro == "Ubuntu" ]
			then
				sudo apt install prometheus
			else
				sudo dnf install prometheus
			fi

			center_text "INSTALLATION COMPLETED!"
                	center_text "HAVE A NICE WORK!"
		fi
	fi
#
# Checking if working OS is 'MacOS' based using 'uname' command
#

elif [ "$(uname)" == "Darwin"  ]
then
	center_text "Current OS is $(uname) based"

	# Asking user for validation
        if YesNo Installation can be \done. Do you want to proceed?
        then
                brew install prometheus

		center_text "INSTALLATION COMPLETED!"
		center_text "HAVE A NICE WORK!"
        fi
else
	# In case it's neither 'MacOS' or 'Linux' based -> Refusal
	center_text "${RED}ERROR${ENDCOLOR}"
	center_text "Current OS is $(uname) based"
	center_text "INSTALLATION NOT SUPPORTED"
fi

