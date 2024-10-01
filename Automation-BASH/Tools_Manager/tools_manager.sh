#!/bin/bash

. ./functions_library.sh || { echo "Failed to source functions_library"; exit 1; }

<< INFO

Title: Tools and Packages Manager
Version: 1.0
Author: Weronika Stępień
Purpose: Automating the management of system tools and packages
Features:
        * Menu-based
        * OS detection
        * Cross-platform compatibility
        * Validation and error handling

Description:
	The script automates the management of system tools and packages across various Linux distributions and macOS.
	Designed for DevOps usage, it provides a streamlined, menu-based interface for viewing, installing, and uninstalling software.
	The script automatically detects the operating system and distribution, and adjusts It's behavior accordingly,
	providing customized support for Ubuntu, Fedora, CentOS, Debian, and macOS systems.

INFO
############################## FINAL VARIABLES AND FUNCIONS ############################################################################
#

## COLORS ##

RED="\e[91m"
GREEN="\e[92m"
BLUE="\e[34m"
ENDCOLOR="\e[0m"

#
# Getting OS name and storing it in variable named 'system'
#
#
system=$(uname)

#
# Getting distro name and storing it in variable named 'distro'
#

distro=$(cat /etc/issue | awk '{print $1}')

#
# Function for getting inforamation about installation status of tools and packages that work only for OS based on Red Hat,
# CentOS and Fedora
#
#			yum | dnf | rpm | cronie

		# Creating an array to store names of the tools that will be checked for rpm based distros
        	tools_rpm=("yum" "dnf" "rpm" "cronie")

status_rpm()
{
    	# Setting the loop so it runs as many times as length of the array 'tools'
	# and takes value of every item name using variable 'tool'
	for tool in "${tools_rpm[@]}"
	do
		# Check if the tool exists as a executable command on the system
		if command -v "$tool" >/dev/null 2>&1
		then
            		echo -e "$tool: ${GREEN}Installed${ENDCOLOR}"

		# When the tool isn't found as a command
        	else
            		# Check if the tool is installed as a package using dnf
            		if command -v dnf >/dev/null 2>&1
			then
                		if dnf list installed "$tool" >/dev/null 2>&1
				then
                    			echo -e "$tool: ${GREEN}Installed${ENDCOLOR}"
                		else
                    			echo -e "$tool: ${RED}Not installed${ENDCOLOR}"
                		fi

            		# Check if the tool is installed as a package using yum
			elif command -v yum >/dev/null 2>&1
			then
                		if yum list installed "$tool" >/dev/null 2>&1
				then
                    			echo -e "$tool: ${GREEN}Installed${ENDCOLOR}"
                		else
                    			echo -e "$tool: ${RED}Not installed${ENDCOLOR}"
                		fi

			# Check if the tool is installed as a package using rpm
            		elif command -v rpm >/dev/null 2>&1
			then
                		if rpm -q "$tool" >/dev/null 2>&1
				then
                    			echo -e "$tool: ${GREEN}Installed${ENDCOLOR}"
               			else
                    			echo -e "$tool: ${RED}Not installed${ENDCOLOR}"
                		fi
            		else
                		echo -e "$tool: ${YELLOW}Neither command nor package${ENDCOLOR}"
            		fi
        	fi
    	done
}


#
# Function for getting inforamation about installation status of tools and packages that work only for OS based on Ubuntu and Debian
#
#		apt | apt-get | dpkg |

		# Creating an array to store names of the tools that will be checked for Ubuntu and Debian
        	tools_dpkg=("apt" "dpkg" "apt-get" "cron")

status_dpkg()
{
	# Setting the loop so it runs as many times as length of the array 'tools'
        # and takes value of every item name using variable 'tool'
	for tool in "${tools_dpkg[@]}"
	do
		# Check if the tool exist as a executable command on the system
        	if command -v "$tool" >/dev/null 2>&1
		then
            		echo -e "$tool: ${GREEN}Installed${ENDCOLOR}"

		# When the tool isn't found as a command
		else

			# Check if the tool is installed as a package using dpkg
            		if dpkg-query -l "$tool" >/dev/null 2>&1 # 'dpkg-query -l' lists packages matching the name
			then
                		echo -e "$tool: ${GREEN}Installed${ENDCOLOR}"
            		else
                		echo -e "$tool: ${YELLOW}Neither command nor package${ENDCOLOR}"
            		fi
        	fi
    	done

}

#
# Function for getting inforamation about installation status of tools and packages that work on all the distros
#
#	 	java | wget | curl | awk | grep | sed | tar | flatpak | snap | pip | npm |

        	# Creating an array to store names of the tools that will be checked for all distros
        	tools_all=("java" "wget" "curl" "awk" "grep" "sed" "tar" "flatpak" "snap" "pip" "npm" "appimagelauncher")


status_all()
{
	# Setting the loop so it runs as many times as length of the array 'tools'
        # and takes value of every item name using variable 'tool'
	for tool in "${tools_all[@]}"
	do
		# Check if the tool exist as a executable command on the system
		if command -v "$tool" >/dev/null 2>&1
		then
    			echo -e "$tool: ${GREEN}Installed${ENDCOLOR}"

		# When the tool isn't found as a command
		else
			# Case for package managers
    			case "$tool" in
        			flatpak|snap|pip|npm|conda)

					# Ubuntu and Debian based
					if command -v dpkg >/dev/null 2>&1
					then
						# 'dpkg-query -l' lists packages matching the name
                				if dpkg-query -l "$tool" >/dev/null 2>&1
						then
                    					echo -e "$tool: ${GREEN}Installed${ENDCOLOR}"
                				else
                    					echo -e "$tool: ${RED}Not installed${ENDCOLOR}"
                				fi


					# Red Hat, CentOS and Fedora based
					elif command -v rpm >/dev/null 2>&1
					then
                				if rpm -q "$tool" >/dev/null 2>&1
						then
                    					echo -e "$tool: ${GREEN}Installed${ENDCOLOR}"
                				else
                    					echo -e "$tool: ${RED}Not installed${ENDCOLOR}"
                				fi

					# Arch based
            				elif command -v pacman >/dev/null 2>&1
					then
                				if pacman -Q "$tool" >/dev/null 2>&1
						then
                    					echo -e "$tool: ${GREEN}Installed${ENDCOLOR}"
                				else
                    					echo -e "$tool: ${RED}Not installed${ENDCOLOR}"
                				fi

					# openSUSE based
					elif command -v zypper >/dev/null 2>&1
					then
                				if zypper se --installed-only "$tool" >/dev/null 2>&1
						then
                    					echo -e "$tool: ${GREEN}Installed${ENDCOLOR}"
                				else
                    					echo -e "$tool: ${RED}Not installed${ENDCOLOR}"
                				fi

					else
                				echo -e "$tool: ${RED}Not installed${ENDCOLOR}"
            				fi

					;;


				# Case to especially check 'Cron Tools' -> must make different approach
				# 'Crontab, cron, and crond' are related tools
	                        # If '$tool' would be used -> potentially missing some options
				crontab|cron|crond)
 					if command -v crontab >/dev/null 2>&1
					then
						echo -e "crontab: ${GREEN}Installed${ENDCOLOR}"

					elif command -v cron >/dev/null 2>&1
					then
        					echo -e "cron: ${GREEN}Installed${ENDCOLOR}"

					elif command -v crond >/dev/null 2>&1
					then
        					echo -e "crond: ${GREEN}Installed${ENDCOLOR}"
    					else
        					echo -e "$tool: ${RED}Not installed${ENDCOLOR}"

					fi

					;;

				# Default
				*)
					echo -e "$tool: ${RED}Not installed${ENDCOLOR}"

					;;
			esac
		fi

	done
}

#
# Function for getting inforamation about installation status of tools and packages that work on MacOS
#
#		java | brew | wget | tar | snap | flatpak | pip | npm | sed | grep | awk | curl | cron |

        	# Creating an array to store names of the tools that will be checked for MacOS
        	tools_mac=("java" "brew" "wget" "tar" "snap" "flatpak" "pip" "npm" "cron" "sed" "grep" "awk" "curl")


status_mac()
{
	# Setting the loop so it runs as many times as length of the array 'tools'
        # and takes value of every item name using variable 'tool'
	for tool in "${tools_mac[@]}"
	do

                # Check if the tool exist as a executable command on the system
		if command -v "$tool" >/dev/null 2>&1
		then
    			echo -e "$tool: ${GREEN}Installed${ENDCOLOR}"

                # When the tool isn't found as a command
		else
            		case "$tool" in

				# Case to especially check 'snap' and 'flatpak'
				# Not natively available on macOS -> usually installed via Homebrew
				snap|flatpak)

                    			if brew list --cask "$tool" >/dev/null 2>&1 # using Homebrew's 'cask'
					then
                        			echo -e "$tool: ${GREEN}Installed via Homebrew${ENDCOLOR}"
                    			else
                        			echo -e "$tool: ${RED}Not installed${ENDCOLRO}"
                    			fi

					;;

				# Case to especially check 'pip'
				pip)
					if python3 -m pip --version >/dev/null 2>&1
					then
                        			echo -e "$tool: ${GREEN}Installed${ENDCOLOR}"
                    			else
                        			echo -e "$tool: ${RED}Not installed${ENDCOLOR}"
                    			fi

					;;

	                        # Default
				*)
					echo -e "$tool: ${YELLOW}Neither command nor package${ENDCOLOR}"

					;;

			esac


		fi

	done


}

#
# Function to display the menu
#

main_menu()
{

  clear

  terminal_stars

  center_text "| TOOLS AND PACKAGES MANAGER |"

  terminal_stars

  center_text "WELCOME!"
  echo
  center_text "PLEASE CHOOSE SUITABLE OPTION FROM BELOW:"

  terminal_stars

  center_block "1) View" "2) Install" "3) Uninstall" "4) Quit"

  terminal_stars
}

#
# Function to view installed tools and packages accordingly to OS in current usage
#

view()
{
	clear

        terminal_stars

        center_text "| VIEW |"

        terminal_stars

        center_text "| OS: $system | Distribution: $distro |"

        terminal_stars

	if [ $system == "Linux" ]
	then
		case "$distro" in

				[XLKuU]buntu | Debian)
					status_dpkg
					status_all

					terminal_stars
        				press_enter

					;;

				Fedora | CentOS | Red*)
					status_rpm
					status_all

					terminal_stars
        				press_enter

					;;

				*)
					echo "ERROR"

					terminal_stars
        				press_enter

					;;

		esac

	else
		status_mac

	fi


}


#
# Function to install tools and packages
#

install()
{
	clear

	terminal_stars
	center_text "| INSTALL |"
	terminal_stars
	center_text "| OS: $system | Distribution: $distro |"
	terminal_stars

	# Creating an empty array to later hold uninstalled tools and packages
	declare -a missing_tools=()

	# Checking if OS is 'Linux' based
	if [ $system == "Linux" ]
	then
		case "$distro" in

			[XLKuU]buntu | Debian)
				# Array of all the tools and packages to check -> mixing together global arrays
				tools=("${tools_all[@]}" "${tools_dpkg[@]}")

				;;

			Fedora | CentOS | Red*)
                                # Array of all the tools and packages to check -> mixing together global arrays
				tools=("${tools_rpm[@]}" "${tools_all[@]}")

				;;

			*)
				echo

				echo "ERROR"

				terminal_stars

				press_enter

				;;
		esac

		# Itering over all tools and packages
		for tool in "${tools[@]}"
		do
			# Fishing out not installed ones
			if ! command -v "$tool" >/dev/null 2>&1
			then
				# Adding not installed ones to the array
				missing_tools+=("$tool")
			fi
		done

	# In case the OS is 'MacOS' based
	elif [ $system == "Darwin" ]
	then
                # Array of all the tools and packages to check
		tools=("${tools_mac[@]}")

                # Itering over all tools and packages
		for tool in "${tools[@]}"
		do
			# Fishing out not installed ones
			if ! command -v "$tool" > /dev/null 2>&1
			then
				# Adding not installed ones to the array
				missing_tools+=("$tool")
			fi
		done

	# In case OS is neither 'Linux' nor 'MacOS' based
	else
		echo

		echo "Unsupported system."

		terminal_stars

		press_enter

	fi

	# Checking if array with uninstalled tools and packages is empty using '#' length -> If yes it means everything is installed
	if [ ${#missing_tools[@]} -eq 0 ]
	then
		echo

		echo "All tools are installed."

		terminal_stars

		press_enter

	fi

	# Listing uninstalled tools and packages
	echo "The following tools are not installed:"

	echo

	# Itering over indexes in array with uninstalled tools and packages
	for i in "${!missing_tools[@]}"
	do
		# Showing number and name
		echo "$((i+1)). ${missing_tools[$i]}"
	done

	echo

	# Getting user input
	read -p "Enter the numbers of the tools you want to install (separated by spaces): " selected

	# Creating empty array to hold user input
	selected_tools=()

	# Itering over numbers given by user
	for num in $selected
	do
		# Saving user input to an array -> 'num-1' changing chosen numbers to indexes in array
		selected_tools+=("${missing_tools[$((num-1))]}")
	done

	# Confirming installation
	echo "You selected the following tools to install:"
	for tool in "${selected_tools[@]}"
	do
		echo

		echo "$tool"

		echo
	done


	if YesNo Do you want to proceed with the installation?
	then
		# Creating two arrays to save successfully installed tools and unsuccessfully installed tools
		declare -a installed_tools=()
		declare -a failed_tools=()

		# Itering over selected tools
		for tool in "${selected_tools[@]}"
		do
			# Using adequate command to the OS distribution type
			if [ "$distro" == "Ubuntu" ] || [ "$distro" == "Debian" ]
			then
				if [ "$tool" == "default-jdk" ]
				then
                        		sudo apt-get install --assume-yes default-jdk

				elif [ "$tool" == "appimagelauncher" ]
				then
					sudo add-apt-repository ppa:appimagelauncher-team/stable
					sudo apt update
					sudo apt install appimagelauncher
                    		else
					sudo apt-get install -y $tool
				fi

			elif [ "$distro" == "Fedora" ] || [ "$distro" == "CentOS" ] || [ "$distro" == "RedHat" ]
			then
				if [ "$tool" == "default-jdk" ]
				then
                        		sudo dnf install -y java-latest-openjdk
                                else
					sudo dnf install -y $tool
				fi

			elif [ "$system" == "Darwin" ]
			then
				if [ "$tool" == "wget" ]
				then
                        		brew install wget

                    		elif [ "$tool" == "default-jdk" ]
				then
                        		brew install --cask adoptopenjdk
                    		else

					brew install $tool
				fi

			else
				echo

				echo "Unsupported system."

				echo

				press_enter

			fi

			# Checking execution code of the last command  (0 - success, others - error)
			if [ $? -eq 0 ]
			then
				# If command was successfull -> adding name of the tool to 'installed_tools' array
				installed_tools+=("$tool")
			else
                                # If command was unsuccessfull -> adding name of the tool to 'failed_tools' array
				failed_tools+=("$tool")
			fi
		done

		# Showing information about successfull installation process
		if [ ${#installed_tools[@]} -gt 0 ]
		then
			echo

			echo "Successfully installed:"

			echo

			# Listing installed components
			for tool in "${installed_tools[@]}"
			do
				echo "- $tool"

			done

			echo

			press_enter
		fi

                # Showing information about unsuccessfull installation process
		if [ ${#failed_tools[@]} -gt 0 ]
		then
			echo

			echo "Failed to install:"

			echo

			# Listing failed components
			for tool in "${failed_tools[@]}"
			do
				echo "- $tool"
			done

			echo

			press_enter
		fi

	else
		if YesNo Do you want to select different tools?
		then
			install
		else
			echo "Returning to menu..."
			press_enter
		fi
	fi

	terminal_stars
}



#
# Function to uninstall chosen tools or packages
#

uninstall()
{
    clear

    terminal_stars
    center_text "| UNINSTALL |"
    terminal_stars
    center_text "| OS: $system | Distribution: $distro |"
    terminal_stars

    # Creating arrays for non-removable tools
    non_removable_dpkg=("apt" "tar" "sed" "awk" "grep" "dpkg" "apt-get")
    non_removable_rpm=("dnf" "yum" "rpm" "tar" "sed" "awk" "grep")

    # Creating empty arrays for later
    declare -a installed_tools=()
    declare -a missing_tools=()

    # Checking if OS is 'Linux' based
    if [ "$system" == "Linux" ]
    then
        case "$distro" in
            [XLKuU]buntu | Debian)
                # Array of all the tools and packages to check -> mixing together global arrays
                tools=("${tools_all[@]}" "${tools_dpkg[@]}")
                non_removable_tools=("${non_removable_dpkg[@]}")
                ;;
            Fedora | CentOS | Red*)
                # Array of all the tools and packages to check -> mixing together global arrays
                tools=("${tools_rpm[@]}" "${tools_all[@]}")
                non_removable_tools=("${non_removable_rpm[@]}")
                ;;
            *)
                echo
                echo "ERROR: Unsupported Linux distribution."
                terminal_stars
                press_enter
                ;;
        esac

        # Wyświetlanie narzędzi, które nie mogą być usunięte
        echo
	center_text "Below tools cannot be removed safely:"
	echo
        center_block_numeric "${non_removable_tools[@]}"
        echo

        # Iterating over all tools and packages
        for tool in "${tools[@]}"
        do
            # Check if the tool is in the non_removable_tools array
            if [[ " ${non_removable_tools[@]} " =~ " $tool " ]]
            then
                continue
            fi

            # Check if the tool is installed
            if command -v "$tool" >/dev/null 2>&1
            then
                # Exclude non-removable tools
                if [[ "$tool" == "brew" ]]
                then
                    echo "$tool cannot be removed safely."
                    echo
                else
                    # Add installed tool to the array
                    installed_tools+=("$tool")
                fi
            fi
        done

    # In case the OS is 'MacOS' based
    elif [ "$system" == "Darwin" ]
    then
        tools=("${tools_mac[@]}")
        non_removable_tools=("brew")

        # Wyświetlanie narzędzi, które nie mogą być usunięte
        echo
        center_text "Below tools cannot be removed safely"
        for i in "${!non_removable_tools[@]}"; do
            center_text "$((i + 1)). ${non_removable_tools[$i]}"
        done
        echo

        # Iterating over all tools and packages
        for tool in "${tools[@]}"
        do
            # Check if the tool is in the non_removable_tools array
            if [[ " ${non_removable_tools[@]} " =~ " $tool " ]]
            then
                center_text "$tool cannot be removed safely."
                continue
            fi

            # Check if the tool is installed
            if command -v "$tool" >/dev/null 2>&1
            then
                installed_tools+=("$tool")
            fi
        done

    else
        echo
        echo "Unsupported system."
        echo
        press_enter
    fi

    # Checking if array with installed tools and packages is empty
    if [ ${#installed_tools[@]} -eq 0 ]
    then
        echo
        echo "All tools are uninstalled."
        terminal_stars
        press_enter
    fi

    # Listing installed tools and packages
    echo
    echo "The following tools are safe to uninstall:"
    echo

    # Iterating over indexes in array with installed tools and packages
    for i in "${!installed_tools[@]}"
    do
        # Showing number and name
        echo "$((i+1)). ${installed_tools[$i]}"
    done

    echo

    # Getting user input
    read -p "Enter the numbers of the tools you want to uninstall (separated by spaces): " selected

    # Creating empty array to hold user input
    declare -a selected_tools=()

    # Iterating over numbers given by user
    for num in $selected
    do
        # Saving user input to an array -> 'num-1' changing chosen numbers to indexes in array
        selected_tools+=("${installed_tools[$((num-1))]}")
    done

    # Confirming removal
    echo "You selected the following tools to uninstall:"
    echo

    for tool in "${selected_tools[@]}"
    do
        echo "$tool"
    done

    if YesNo "Do you want to proceed with the removal?"
    then
        # Creating two arrays to save successfully and unsuccessfully uninstalled tools
        declare -a uninstalled_tools=()
        declare -a failed_tools=()

        for tool in "${selected_tools[@]}"
        do
            # Check if the tool is in the non_removable_tools array
            if [[ " ${non_removable_tools[@]} " =~ " $tool " ]]
            then
                center_text "$tool cannot be removed safely."
                continue
            fi

            # Using adequate command to the OS distribution type
            case "$distro" in
                [XLKuU]buntu | Debian)
                    if [ "$tool" == "snap" ]
                    then
			    sudo systemctl stop snapd
			    sudo apt autoremove --purge --assume-yes snapd gnome-software-plugin-snap
			    rm -rf ~/snap/
			    sudo rm -rf /var/cache/snapd/

		    elif [ "$tool" == "default-jdk" ]
                    then
			    sudo apt-get autoremove --assume-yes default-jdk
			    sudo apt-get purge --assume-yes default-jdk

		    elif [ "$tool" == "appimagelauncher" ]
                    then
                            echo "AppImageLauncher has a built-in uninstallation process"
                    else
			    sudo apt-get autoremove --assume-yes $tool
                    fi

                    ;;
                Fedora | CentOS | Red*)
                    if [ "$tool" == "default-jdk" ]
                    then
			    sudo dnf autoremove -y java-latest-openjdk

		    elif [ "$tool" == "appimagelauncher" ]
		    then
			    echo "AppImageLauncher has a built-in uninstallation process"

                    else
			    sudo dnf autoremove -y $tool
                    fi

                    ;;
                *)
                    echo
                    echo "Unsupported distribution."
                    echo
                    press_enter

		    ;;
            esac

            # Checking execution code of the last command (0 - success, others - error)
            if [ $? -eq 0 ]
            then
                # If command was successful -> adding name of the tool to 'uninstalled_tools' array
                uninstalled_tools+=("$tool")
            else
                # If command was unsuccessful -> adding name of the tool to 'failed_tools' array
                failed_tools+=("$tool")
            fi

        done

        # Showing information about successful removal process
        if [ ${#uninstalled_tools[@]} -gt 0 ]
        then
            echo
            echo "Successfully uninstalled:"
            echo
            # Listing uninstalled components
            for tool in "${uninstalled_tools[@]}"
            do
                echo "- $tool"
            done
            echo
            press_enter
        fi

        # Showing information about unsuccessful removal process
        if [ ${#failed_tools[@]} -gt 0 ]
        then
            echo
            echo "Failed to uninstall:"
            echo
            # Listing failed components
            for tool in "${failed_tools[@]}"
            do
                echo "- $tool"
            done
            echo
            press_enter
        fi

    else
        if YesNo "Do you want to select different tools?"
        then
            uninstall
        else
            echo "Returning to menu..."
            press_enter
        fi
    fi

    terminal_stars
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
# Option to show already installed tools and packages
#

case $option in
	[1*]|"View")

    	view

	;;

#
# Option to show tools and packages that are available for installation and install them per user choice
#

	[2*]|"Install")

	install

	;;

#
# Option to uninstall chosen tools and packages
#

	[3*]|"Uninstall")

	uninstall

	;;

#
# Quit option
#

	[4*]|"Quit")

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
