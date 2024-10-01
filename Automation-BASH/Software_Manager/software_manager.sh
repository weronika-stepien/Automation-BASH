#!/bin/bash

. ./functions_library.sh || { echo "Failed to source functions_library"; exit 1; }

<< INFO

Title: Software Management Automation Tool
Version: 1.0
Author: Weronika Stępień
Purpose: Automated service and program management
Features:
	* Menu-based
	* OS detection
	* Modular architecture
	* Terminal customization
	* Cross-platform compatibility
	* Validation and error handling
	* Post-installation configuration

Description:

INFO

############################## FINAL VARIABLES AND FUNCIONS ############################################################################
#


## COLORS ##

RED=$(tput setaf 196)
GREEN=$(tput setaf 40)
YELLOW=$(tput setaf 11)
BLUE=$(tput setaf 4)
ENDCOLOR=$(tput sgr0)

#
# Getting OS name and storing it in variable named 'system'
#

system=$(uname)

#
# Getting distro name and storing it in variable named 'distro'
#

distro=$(cat /etc/issue | awk '{print $1}')

#
# Saving terminal width
#

term_width=$(tput cols)

#
# Global arrays to separate services and programs
#

programs=("git" "ansible" "terraform" "slack")

services=("docker" "jenkins" "kubectl" "prometheus" "mysql" "grafana-server")

#
# Variables to hold different 'apache' names
#

ubu_deb="apache2"
fed_mac="httpd"

#
# Adding specific 'apache' name to the 'services' array
#

	if [ "$distro" == "Ubuntu" ] || [ "$distro" == "Debian" ]
	then
               services+=("$ubu_deb")
        else
               services+=("$fed_mac")
        fi

#
# Global array to put services and programs together
#

software=("${programs[@]}" "${services[@]}")

#
# Function to display the menu
#

main_menu()
{
	clear

 	terminal_stars

  	center_text "| SOFTWARE MANAGER |"

  	terminal_stars

  	echo

	center_text "PLEASE CHOOSE SUITABLE OPTION FROM BELOW:"

  	terminal_stars

  	center_block "1) View" "2) Install" "3) Configurate" "4) Toggle" "5) Uninstall" "6) Quit"

  	terminal_stars
}

#
# Function to view list of programs and services along with their status
#

view()
{
	clear

    	terminal_stars
    	center_text "| VIEW |"
    	terminal_stars
    	center_text "| OS: $system | Distribution: $distro |"
    	terminal_stars

	echo

    	# Arrays to hold status
    	service_status=()
    	program_status=()

    	# Determine the length of the longest service and program names
    	max_service_length=0
    	max_program_length=0

    	for service in "${services[@]}"
	do
        	[ ${#service} -gt $max_service_length ] && max_service_length=${#service}
    	done

    	for program in "${programs[@]}"
	do
        	[ ${#program} -gt $max_program_length ] && max_program_length=${#program}
    	done

    	# Add buffer for the statuses
    	service_col_width=$((max_service_length + 40))
    	program_col_width=$((max_program_length + 20))

    	# Calculating the starting position to center the text
    	total_col_width=$((service_col_width + program_col_width))
    	start_pos=$(( (term_width - total_col_width) / 2 + 10 ))

    	# Manually setting spaces for headers
    	services_header_spaces="                                           "
    	programs_header_spaces="                    "

    	# Checking for services
    	for service in "${services[@]}"
	do
        	#if command -v "$service" > /dev/null 2>&1
		#if systemctl list-units -all | grep "$service" > /dev/null 2>&1
		if "$service" --version > /dev/null 2>&1
		then
            		service_status+=("${GREEN}Installed${ENDCOLOR}")
        	else
            		service_status+=("${RED}Not installed${ENDCOLOR}")
        	fi
    	done

    	# Checking for programs
    	for program in "${programs[@]}"
	do
        	if command -v "$program" > /dev/null 2>&1
		then
            		program_status+=("${GREEN}Installed${ENDCOLOR}")
        	else
            		program_status+=("${RED}Not installed${ENDCOLOR}")
        	fi
    	done

    	echo

    	# Printing headers
    	echo "$services_header_spaces SERVICES $programs_header_spaces PROGRAMS"

	echo

    	# Printing services and programs in two columns
    	for ((i = 0; i < ${#services[@]}; i++))
	do
        	service_line="${services[i]}: ${service_status[i]}"

		# Only append a colon if there's content in the program line
        	if [[ -n "${programs[i]}" ]]
		then
            		program_line="${programs[i]}: ${program_status[i]}"
        	else
            		program_line=""
        	fi

		printf "%*s%-*s%-*s\n" $start_pos "" $service_col_width "$service_line" $program_col_width "$program_line"
    	done

    	echo

	press_enter
}


#
# Function to install chosen service or program
#

install()
{

	clear

    	terminal_stars

    	center_text "| INSTALL |"

    	terminal_stars

    	center_text "| OS: $system | Distribution: $distro |"

    	terminal_stars


	if [ "$system" == "Linux" ]
	then
		# Creating an empty array to later hold uninstalled tools and packages
    		declare -a missing_software=()

    		# Iterating over all programs and services
    		for app in "${software[@]}"
    		do
        		# Fishing out not installed ones
        		if ! command -v "$app" >/dev/null 2>&1
        		then
            			# Adding not installed ones to the array
            			missing_software+=("$app")
        		fi
    		done

    		# Checking if array with software is empty using '#' length -> If yes it means everything is installed
    		if [ ${#missing_software[@]} -eq 0 ]
    		then
        		echo
        		center_text "Every service and program is installed."
        		echo
			center_text "Returning to the menu...."

			sleep 1

			return

    		fi

    		# Listing uninstalled services and programs
    		echo "The following software is not installed:"
    		echo

    		# Iterating over indexes in array
    		for i in "${!missing_software[@]}"
    		do
        		# Showing number and name
        		echo "$((i+1)). ${missing_software[$i]}"
    		done

    		echo

    		# Getting user input
    		read -p "Enter the numbers of the software you want to install (separated by spaces): " selected

		# Checking if input is empty
        	if [ -z "$selected" ]
		then
            		center_text "${RED}ERROR: No input provided${ENDCOLOR}"
            		sleep 0.85
			install

        	fi

    		# Creating empty array to hold user input
    		declare -a selected_software=()


    		# Iterating over numbers given by user
    		for num in $selected
    		do
			# Validating the user input
            		if [[ "$num" =~ ^[0-9]+$ ]] && [ "$num" -le "${#missing_software[@]}" ] && [ "$num" -gt 0 ]
			then
                		# Saving user input to an array -> 'num-1' changing chosen numbers to indexes in array
				selected_software+=("${missing_software[$((num-1))]}")
			else
                		echo "Invalid selection: '$num'. Please choose a valid number."
                		echo

				if YesNo "Do you wanna choose again?"
				then
					install
				else
					center_text "${RED}Returning the the menu....${ENDCOLOR}"
					sleep 1
					return
					break

				fi
            		fi
    		done

    		# Confirming installation
    		echo "You selected the following tools to install:"

		for app in "${selected_software[@]}"
    		do
        		echo
        		echo "$app"
        		echo
    		done

    		if YesNo "Do you want to proceed with the installation?"
    		then
        		# Creating two arrays to save successfully installed software and unsuccessfully installed software
        		declare -a installed_software=()
        		declare -a failed_software=()

            		# Iterating over selected tools
            		for app in "${selected_software[@]}"
            		do
                		case "$distro" in

                    		[XLKuU]buntu | Debian)

					# Logic for software which needs additional steps
					case "$app" in

						"mysql")
							sudo apt install mysql-server

							;;

						"terraform")
							# Updating the repository
							center_text "${YELLOW}STEP 1/4: Updating the repository${ENDCOLOR}"
							sleep 0.85
							echo
							if YesNo "Do you want to proceed?"
							then
								sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
							else
								install
							fi

							# Adding 'HashiCorp's' official GPG key
							center_text "${YELLOW}STEP 2/4: Adding 'HashiCorp's' official GPG key${ENDCOLOR}"
                                                        sleep 0.85
                                                        echo
							if YesNo "Do you want to proceed?"
                                                        then
								curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
							else
								install
							fi

							# Adding the official 'HashiCorp Linux' repository
							center_text "${YELLOW}STEP 3/4: Adding the official 'HashiCorp Linux' repository${ENDCOLOR}"

                                                        sleep 0.85
                                                        echo
							if YesNo "Do you want to proceed?"
                                                        then
							      echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

							else
								install
							fi

							# Installing 'Terraform'
							center_text "${YELLOW}STEP 4/4: Installing 'Terraform'${ENDCOLOR}"
                                                        sleep 0.85
                                                        echo
							if YesNo "Do you want to proceed?"
                                                        then
								sudo apt-get update && sudo apt-get install terraform
							else
								install
							fi

							;;

						"grafana-server")
							# Installing the prerequisite packages
							center_text "${YELLOW}STEP 1/3: Installing the prerequisite packages${ENDCOLOR}"
                                                        sleep 0.85
                                                        echo
                                                        if YesNo "Do you want to proceed?"
                                                        then
								sudo apt-get install -y apt-transport-https software-properties-common wget
							else
								install
							fi

							# Installing the GPG key
							center_text "${YELLOW}STEP 2/3: Installing the GPG key${ENDCOLOR}"
                                                        sleep 0.85
                                                        echo
                                                        if YesNo "Do you want to proceed?"
                                                        then
								sudo mkdir -p /etc/apt/keyrings/

								wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null

							else
								install
							fi

							# Installing 'Grafana'
							center_text "${YELLOW}STEP 3/3: Installing 'Grafana'${ENDCOLOR}"
                                                        sleep 0.85
                                                        echo
                                                        if YesNo "Do you want to proceed?"
                                                        then
								sudo apt-get update

								sudo apt-get install grafana

							else
								install
							fi

							;;

						"jenkins")
							# Installing needed 'Java-jdk'
							center_text "${YELLOW}STEP 1/3: Installing needed 'Java-jdk'${ENDCOLOR}"
                                                        sleep 0.85
                                                        echo
                                                        if YesNo "Do you want to proceed?"
                                                        then
								sudo apt-get update

								sudo apt install default-jre
							else
								install
							fi

							# Adding the key repository to the system
							center_text "${YELLOW}STEP 2/3: Adding the key repository to the system${ENDCOLOR}"
                                                        sleep 0.85
                                                        echo
                                                        if YesNo "Do you want to proceed?"
                                                        then
								wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key |sudo gpg --dearmor -o /usr/share/keyrings/jenkins.gpg
								# appending the Debian package repository address
								# to the server’s sources.list
								sudo sh -c 'echo deb [signed-by=/usr/share/keyrings/jenkins.gpg] http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'

							else
								install
							fi

							# Installing 'Jenkins'
							center_text "${YELLOW}STEP 3/3: Installing 'Jenkins'${ENDCOLOR}"
                                                        sleep 0.85
                                                        echo
                                                        if YesNo "Do you want to proceed?"
                                                        then
								sudo apt-get update

								sudo apt-get install jenkins
							else
								install
							fi

							;;

						"kubernetes")
							# Adding 'Kubernetes' signing key
							center_text "${YELLOW}STEP 1/3: Adding 'Kubernetes' signing key${ENDCOLOR}"
                                                        sleep 0.85
                                                        echo
                                                        if YesNo "Do you want to proceed?"
                                                        then
								curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

							else
								install
							fi

							# Adding software repositories
							center_text "${YELLOW}STEP 2/3: Adding software repositories${ENDCOLOR}"
                                                        sleep 0.85
                                                        echo
                                                        if YesNo "Do you want to proceed?"
                                                        then
								echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

							else
								install
							fi

							# Installing 'Kubernetes' tools
							center_text "${YELLOW}STEP 3/3: Installing 'Kubernetes' tools${ENDCOLOR}"
                                                        sleep 0.85
                                                        echo
                                                        if YesNo "Do you want to proceed?"
                                                        then
								sudo apt install kubeadm kubelet kubectl
							else
								install
							fi

							;;

						"docker")
							# Uninstalling any old versions of 'Docker'
							center_text "${YELLOW}STEP 1/5: Uninstalling any old versions of 'Docker' \
								                                                       ${ENDCOLOR}"
                                                        sleep 0.85
                                                        echo
                                                        if YesNo "Do you want to proceed?"
                                                        then
								sudo apt-get remove docker docker-engine docker.io containerd runc
							else
								install
							fi

							# Installing dependencies
							center_text "${YELLOW}STEP 2/5: Installing dependencies${ENDCOLOR}"
                                                        sleep 0.85
                                                        echo
                                                        if YesNo "Do you want to proceed?"
                                                        then
								sudo apt-get update

								sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
							else
								install
							fi

							# Adding 'Docker’s' GPG key
							center_text "${YELLOW}STEP 3/5: Adding 'Docker’s' GPG key${ENDCOLOR}"
                                                        sleep 0.85
                                                        echo
                                                        if YesNo "Do you want to proceed?"
                                                        then
								curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
							else
								install
							fi

							# Adding the 'Docker' repository
							center_text "${YELLOW}STEP 4/5: Adding the 'Docker' repository${ENDCOLOR}"
                                                        sleep 0.85
                                                        echo
                                                        if YesNo "Do you want to proceed?"
                                                        then
								sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
							else
								install
							fi

							# Installing 'Docker'
							center_text "${YELLOW}STEP 5/5: Adding the 'Docker' repository${ENDCOLOR}"
                                                        sleep 0.85
                                                        echo
                                                        if YesNo "Do you want to proceed?"
                                                        then
								sudo apt-get update

								sudo apt-get install docker-ce
							else
								install
							fi

							;;


						# Software which doesn't need additional steps
						*)
							sudo apt-get install -y "$app"

							;;
					esac

					;;

		    		Fedora | CentOS | Red*)

					# Logic for software who need additional steps
                                        case "$app" in

						"terraform")
							# Adding the 'HashiCorp' repository
							center_text "${YELLOW}STEP 1/2: Adding the 'HashiCorp' repository${ENDCOLOR}"
                                                        sleep 0.85
                                                        echo
                                                        if YesNo "Do you want to proceed?"
                                                        then
								sudo dnf install -y dnf-plugins-core

								sudo dnf config-manager --add-repo \
								https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
							else
								install
							fi

							# Installing 'Terraform'
							center_text "${YELLOW}STEP 2/2: Installing 'Terraform'${ENDCOLOR}"
                                                        sleep 0.85
                                                        echo
                                                        if YesNo "Do you want to proceed?"
                                                        then
								sudo dnf install terraform
							else
								install
							fi

							;;

						"grafana-server")
							# Adding the 'Grafana' repository
							center_text "${YELLOW}STEP 1/2: Adding the 'Grafana' repository${ENDCOLOR}"
                                                        sleep 0.85
                                                        echo
                                                        if YesNo "Do you want to proceed?"
                                                        then
								sudo dnf install -y dnf-plugins-core

								sudo tee /etc/yum.repos.d/grafana.repo <<-'EOF'
								[grafana]
								name=Grafana OSS
								baseurl=https://packages.grafana.com/oss/rpm
								repo_gpgcheck=1
								enabled=1
								gpgcheck=1
								gpgkey=https://packages.grafana.com/gpg.key
								EOF
							else
								install
							fi

							# Installing 'Grafana'
							center_text "${YELLOW}STEP 2/2: Installing 'Grafana'${ENDCOLOR}"
                                                        sleep 0.85
                                                        echo
                                                        if YesNo "Do you want to proceed?"
                                                        then
								sudo dnf install grafana
							else
								install
							fi

							;;

						"jenkins")
							# Installing 'Java'
							center_text "${YELLOW}STEP 1/3: Installing 'Java'${ENDCOLOR}"
                                                        sleep 0.85
                                                        echo
                                                        if YesNo "Do you want to proceed?"
                                                        then
								sudo dnf install java-11-openjdk

							else
								install
							fi

							# Adding the 'Jenkins' repository
							center_text "${YELLOW}STEP 2/3: Adding the 'Jenkins' repository${ENDCOLOR}"
                                                        sleep 0.85
                                                        echo
                                                        if YesNo "Do you want to proceed?"
                                                        then
								sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo

								sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
							else
								install
							fi

							# Installing 'Jenkins'
							center_text "${YELLOW}STEP 3/3: Installing 'Jenkins'${ENDCOLOR}"
                                                        sleep 0.85
                                                        echo
                                                        if YesNo "Do you want to proceed?"
                                                        then
								sudo dnf install jenkins
							else
								install
							fi

							;;

						"kubernetes")
							center_text "Which type of kubernetes do you prefer"
							center_text "full -> for installing kubelet, kubedm, kubectl"
							center_text "8 -> for installing MicroK8s"
							read -p "Your choice: " choice

							if [ "$choice" == "full"]
							then
								echo "Installing kubectl"
								sleep 0.85
								dnf install kubernetes-client

								echo "Installing kubeadm"
								sleep 0.85
								dnf install kubernetes-kubeadm

								echo "Installing kubelet"
								sleep 0.85
								dnf install kubernetes-node

							else
								echo "Installing MicroK8s"
								sleep 0.85
								sudo snap install microk8s --classic

							fi

							;;

						"docker")
							# Uninstalling any older versions of 'Docker'
							center_text "${YELLOW}STEP 1/3: Uninstalling any older versions of 'Docker' \
														     ${ENDCOLOR}"
                                                        sleep 0.85
                                                        echo
                                                        if YesNo "Do you want to proceed?"
                                                        then
								sudo dnf remove docker docker-client
								sudo dnf remove docker-client-latest docker-common
								sudo dnf remove docker-latest docker-latest-logrotate
								sudo dnf remove docker-logrotate docker-engine

							else
								install
							fi

							# Setting up the 'Docker' repository
							center_text "${YELLOW}STEP 2/3: Setting up the 'Docker' repository${ENDCOLOR}"
                                                        sleep 0.85
                                                        echo
                                                        if YesNo "Do you want to proceed?"
                                                        then
								sudo dnf -y install dnf-plugins-core

								sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
							else
								install
							fi

							# Installing 'Docker'
							center_text "${YELLOW}STEP 3/3: Installing 'Docker'${ENDCOLOR}"
                                                        sleep 0.85
                                                        echo
                                                        if YesNo "Do you want to proceed?"
                                                        then
								sudo dnf install docker-ce docker-ce-cli containerd.io
							else
								install
							fi

							;;


						*)
							sudo dnf install -y "$app"

							;;

						esac

					;;

		     		*)
                        		echo
                        		echo "ERROR: Unsupported distribution"

					terminal_stars
                        		press_enter

		      			;;

				esac

                		# Checking execution code of the last command (0 - success, others - error)
                		if [ $? -eq 0 ]
                		then
                    			# If command was successful -> adding name of the software to 'installed_software' array
                    			installed_software+=("$app")

	    			else
					# If command was unsuccessful -> adding name of the software to 'failed_software' array
                    			failed_software+=("$app")

				fi
            		done

            		# Showing information about successful installation process
			if [ ${#installed_software[@]} -gt 0 ]
			then
    				echo
    				echo "${YELLOW}Successfully installed:${ENDCOLOR}"
    				echo

    				# Listing installed components
    				for tool in "${installed_software[@]}"
    				do
        				echo "- ${GREEN}$tool${ENDCOLOR}"
    				done

    				echo

				# Prompting user about next step
				if YesNo "Do you want to select different software?"
                                then
                                        install
                                else
                                        echo
                                        center_text "Returning to the menu...."
                                        echo

                                        press_enter
					break
                                fi

			fi

			# Showing information about unsuccessful installation process
			if [ ${#failed_software[@]} -gt 0 ]
			then
    				echo
    				echo "${YELLOW}Failed to install:${ENDCOLOR}"
    				echo

    				# Listing failed components
    				for app in "${failed_software[@]}"
    				do
        				echo "${RED}- $app${ENDCOLOR}"
    				done

    				echo

				if YesNo "Do you want to select different software?"
                        	then
                                	install
                        	else
                                	echo
                                	center_text "Returning to the menu...."
                                	echo

                                	press_enter
					break
                        	fi

			fi


		else
			if YesNo "Do you want to select different software?"
			then
				install
			else
				echo
				center_text "Returning to the menu...."
		       		echo

				press_enter
				break
			fi

		fi


	# MacOS Logic
	elif [ "$system" == "Darwin" ]
        then
            	# Installing software on macOS using Homebrew
            	for app in "${selected_software[@]}"
            	do
			case "$app" in

				"terraform")
					# Installing 'Terraform' using 'Homebrew'
					center_text "${YELLOW}STEP 1/1: Installing 'Terraform' using 'Homebrew'${ENDCOLOR}"
                                        sleep 0.85
                                       	echo
                                        if YesNo "Do you want to proceed?"
                                        then
						brew tap hashicorp/tap

						brew install hashicorp/tap/terraform
					else
						install
					fi

					;;


				"jenkins")
					# Installing 'Java-jdk'
					center_text "${YELLOW}STEP 1/2: Installing 'Java-jdk'${ENDCOLOR}"
                                        sleep 0.85
                                        echo

					if YesNo "Do you want to proceed?"
                                        then
						brew install openjdk@11

					else
						install
					fi

					# Installing 'Jenkins' using 'Homebrew'
					center_text "${YELLOW}STEP 2/2: Installing 'Jenkins' using 'Homebrew'${ENDCOLOR}"
                                        sleep 0.85
                                        echo

					if YesNo "Do you want to proceed?"
                                        then
						brew install jenkins-lts
					else
						install
					fi

					;;

				"grafana-server")
					brew install grafana

					;;

				"kubernetes")
					if YesNo "Only 'MicroK8s' avalible for installation, do you want to procced?"
					then
						brew install ubuntu/microk8s/micro

						microk8s install
					else
						install
					fi

					;;

				*)
					brew install "$app"

					;;

			esac

			# Checking execution code of the last command (0 - success, others - error)
                	if [ $? -eq 0 ]
                	then
                    		installed_software+=("$app")
                	else
                    		failed_software+=("$app")
                	fi
           	 done

            	# Showing information about successful installation process
           	if [ ${#installed_software[@]} -gt 0 ]
            	then
               		echo
               		echo "${YELLOW}Successfully installed:${ENDCOLOR}"
               		echo

               		# Listing installed components
               		for tool in "${installed_software[@]}"
               		do
                 		echo "- ${GREE}$tool${ENDCOLOR}"
               		done

                	echo


            	# Showing information about unsuccessful installation process
		else
                	echo
                	echo "${YELLOW}Failed to install:${ENDCOLOR}"
                	echo

                	# Listing failed components
                	for app in "${failed_software[@]}"
               		do
                   		echo "- ${RED} $app ${ENDCOLOR}"
                	done

                	echo

            	fi

		if YesNo "Do you want to select different software?"
        	then
			install
		else
			echo
			center_text "Returning to the menu...."
			echo

			press_enter

		fi

	# Logic for unsupported OS
	else
            	echo "Unsupported OS: $system"
            	echo
		center_text "Returning to the menu....."

		sleep 1

		return
        fi


}



#
# Function to finalize setup after installation
#

configurate()
{
        clear

        terminal_stars

        center_text "| CONFIGURATE |"

        terminal_stars

        center_text "| OS: $system | Distribution: $distro |"

        terminal_stars

	echo

	center_text ${YELLOW}"This feature is currently under development"${ENDCOLOR}

	echo

        press_enter

}

#
# Function to start or stop the specified service
#


toggle()
{
	clear

    	terminal_stars
    	center_text "| TOGGLE |"
    	terminal_stars
    	center_text "| OS: $system | Distribution: $distro |"
    	terminal_stars



	# Checking if OS is supported
        if [ "$system" != "Linux" ] && [ "$system" != "Darwin" ]
        then
                center_text "Unsupported OS: $system"
                echo
		center_text "Returnung to the menu...."

		sleep 1

		return

        fi

	# Creating array to hold installed services
    	declare -a installed_services=()

	# Creating arrays to hold status
    	declare -a active_services=()
    	declare -a inactive_services=()

	# Creating array to hold the combined list of services
	declare -a combined_services=()


    	# Checking if OS is 'Linux' based
    	if [ "$system" == "Linux" ]
	then
        	# Finding installed services
        	for service in "${services[@]}"
		do
			if command -v "$service" > /dev/null 2>&1
	    		then
		    		installed_services+=("$service")
            		fi
        	done

        	# If no services are installed
        	if [ ${#installed_services[@]} -eq 0 ]
		then
            		echo
            		center_text "${RED}None of the services are installed${ENDCOLOR}"
            		echo
			center_text "Returning to the menu...."

			sleep 1

			return

		else
            		# Checking for services status and preparing combined list
            		for service in "${installed_services[@]}"
			do
                		status=$(systemctl status "$service" | grep 'Active' | awk '{print $2}')

                		if [ "$status" == "active" ]
				then
                    			active_services+=("${service}: ${GREEN}Active${ENDCOLOR}")
                		else
                    			inactive_services+=("${service}: ${RED}Not active${ENDCOLOR}")
                		fi
            		done

            		# Printing the header for available services
            		echo
            		center_text "AVAILABLE SERVICES"
            		echo

			# Combining active and inactive services for 'center_block' usage
			combined_services=("${active_services[@]}" "${inactive_services[@]}")

        		# Printing services and their statuses with 'center_block' using combined services (active + inactive)
            		center_block "${combined_services[@]}"

		fi

		# Getting user input
		echo
        	read -p "Enter the name of the service you want to update: " selected

        	# Checking if the selected service is installed
        	service_index=-1
        	for ((i = 0; i < ${#installed_services[@]}; i++))
		do
			if [[ "${installed_services[i]}" == "$selected" ]]
			then
				service_index=$i
                		break
            		fi
        	done

		# Logic for invalid choice
        	if [ $service_index -eq -1 ]
		then
			echo "ERROR: The service '${RED}$selected${ENDCOLOR}' is not available in the installed services list"
            		echo

			if YesNo "Do you want to select a different service?"
			then
				toggle
            		else
                		echo
                		center_text "Returning to the menu..."
                		press_enter
            		fi

		# Logic for valid choice
        	else
			echo
            		echo "You have chosen: ${YELLOW}$selected${ENDCOLOR}"

			if YesNo "Do you want to proceed with the change?"
			then
				echo
                		center_text "Proceeding with status change for ${YELLOW}$selected${ENDCOLOR}..."

                		declare -a success=()
                		declare -a failure=()

                		status=$(systemctl status "${installed_services[$service_index]}" | grep 'Active' | awk '{print $2}')

                		if [ "$status" == "active" ]
				then
                 			sudo systemctl stop "${installed_services[$service_index]}"

                		else
					sudo systemctl start "${installed_services[$service_index]}"

                		fi

                		# Checking command success
                		if [ $? -eq 0 ]
				then
                    			success+=("$selected")
                		else
                    			failure+=("$selected")
                		fi

                		# Showing success result
                		if [ ${#success[@]} -gt 0 ]
				then
                    			echo
                    			echo "${YELLOW}Status successfully changed for:${ENDCOLOR}"
                    			echo "- ${GREEN}$selected${ENDCOLOR}"
                    			echo

					if YesNo "Do you want to select a different service?"
					then
                        			toggle
                    			else
                        			echo
                        			center_text "Returning to menu..."
                        			press_enter
                    			fi

				# Showing failure result
				else
					echo
                    			echo "${YELLOW}Failed to update status for:${ENDCOLOR}"
                    			echo "${RED}- $selected${ENDCOLOR}"
                    			echo

					if YesNo "Do you want to select a different service?"
					then
                        			toggle
                    			else
                        			echo
                        			center_text "Returning to the menu..."
                        			press_enter
                    			fi
                		fi

			else
				if YesNo "Do you want to select a different service?"
				then
					toggle
				else
					echo
					center_text "Returning to the menu..."
					press_enter
				fi

			fi
		fi

	elif [ "$system" == "Darwin" ]
        then
		# Finding installed services
        	for service in "${services[@]}"
		do
			if brew list "$service" > /dev/null 2>&1
			then
				installed_services+=("$service")

			elif [ "$service" == "kubernetes" ]
			then
				if brew list microk8s > /dev/null 2>&1
                        	then
					installed_services+=("$service")
				fi
			fi
		done


        	# Logic in case none of the services is installed
        	if [ ${#installed_services[@]} -eq 0 ]
		then
            		echo
            		center_text "${RED}None of the services are installed${ENDCOLOR}"
            		echo
            		echo "Returning to the menu...."

			sleep 1

			return

        	else
            		# Checking for services status
            		for service in "${installed_services[@]}"
			do
                		status=$(brew services list | grep "$service" | awk '{print $2}')

                		if [ "$status" == "started" ]
				then
                    			active_services+=("${service}: ${GREEN}Active${ENDCOLOR}")
                		else
                    			inactive_services+=("${service}: ${RED}Not active${ENDCOLOR}")
                		fi
            		done

          		# Printing the header for available services
                        echo
                        center_text "AVAILABLE SERVICES"
                        echo

                        # Combining active and inactive services for 'center_block' usage
                        combined_services=("${active_services[@]}" "${inactive_services[@]}")

                        # Printing services and their statuses with 'center_block' using combined services (active + inactive)
                        center_block "${combined_services[@]}"

        	fi

        	# Getting user input
        	echo
        	read -p "Enter the name of the service you want to update: " selected

        	# Checking if the selected service available
        	service_index=-1

		for ((i = 0; i < ${#installed_services[@]}; i++))
		do
			if [[ "${installed_services[i]}" == "$selected" ]]
			then
				service_index=$i
                		break
            		fi
        	done

        	# Logic for invalid choice
        	if [ $service_index -eq -1 ]
		then
            		echo "ERROR: The service '${RED}$selected${ENDCOLOR}' is not available in the installed services list"
            		echo

			if YesNo "Do you want to select a different service?"
			then
                		toggle
            		else
                		echo
                		center_text "Returning to the menu..."
                		press_enter
            		fi

        	# Logic for valid choice
        	else
            		echo
            		echo "You have chosen: ${YELLOW}$selected${ENDCOLOR}"

			if YesNo "Do you want to proceed with the change?"
			then
                		echo
                		center_text "Proceeding with status change for ${YELLOW}$selected${ENDCOLOR}..."

                		declare -a success=()
                		declare -a failure=()

                		status=$(brew services list | grep "$selected" | awk '{print $2}')

                		if [ "$status" == "started" ]
				then
                    			brew services stop "$selected"
                		else
                    			brew services start "$selected"
                		fi

                		# Checking command success
                		if [ $? -eq 0 ]
				then
                    			success+=("$selected")
                		else
                    			failure+=("$selected")
                		fi

                		# Showing success result
                		if [ ${#success[@]} -gt 0 ]
				then
                    			echo
                    			echo "${YELLOW}Status successfully changed for:${ENDCOLOR}"
                    			echo "- ${GREEN}$selected${ENDCOLOR}"
                    			echo

					if YesNo "Do you want to select a different service?"
					then
						toggle
                    			else
                        			echo
                        			center_text "Returning to menu..."
                        			press_enter
      					fi

				# Showing failure result
                		else
                    			echo
                    			echo "${YELLOW}Failed to update status for:${ENDCOLOR}"
                    			echo "${RED}- $selected${ENDCOLOR}"
                    			echo

					if YesNo "Do you want to select a different service?"
					then
                        			toggle
                    			else
                       	 			echo
                        			center_text "Returning to the menu..."
                        			press_enter
                  			fi
				fi
			fi
		fi
	fi


}



#
# Function to uninstall and remove traces of the selected service or program
#

uninstall()
{

	clear

    	terminal_stars

    	center_text "| UNINSTALL |"

    	terminal_stars

    	center_text "| OS: $system | Distribution: $distro |"

    	terminal_stars


	if [ "$system" == "Linux" ]
	then

		# Creating an empty array to later hold uninstalled tools and packages
    		declare -a installed_software=()

    		# Array of all the programs and services to check -> mixing together global arrays
    		software=("${programs[@]}" "${services[@]}")

    		# Iterating over all programs and services
    		for app in "${software[@]}"
    		do
        		# Fishing out installed ones
        		if command -v "$app" >/dev/null 2>&1
        		then
            			# Adding installed ones to the array
            			installed_software+=("$app")
        		fi
    		done

    		# Checking if array with software is empty using '#' length -> If yes it means everything is installed
    		if [ ${#installed_software[@]} -eq 0 ]
    		then
        		echo
        		echo "${RED}None of the services and programs are installed${ENDCOLOR}"

			terminal_stars
        		press_enter

    		fi

    		# Listing installed services and programs
    		echo "${YELLOW}The following software is installed:${ENDCOLOR}"
    		echo

    		# Iterating over indexes in array
    		for i in "${!installed_software[@]}"
    		do
        		# Showing number and name
        		echo "$((i+1)). ${installed_software[$i]}"
    		done

    		echo

    		# Getting user input
    		read -p "Enter the numbers of the software you want to uninstall (separated by spaces): " selected

		# Checking if input is empty
        	if [ -z "$selected" ]
		then
            		center_text "${RED}ERROR: No input provided${ENDCOLOR}"
            		sleep 0.85
			uninstall

        	fi

    		# Creating empty array to hold user input
    		declare -a selected_software=()


    		# Iterating over numbers given by user
    		for num in $selected
    		do
			# Validating the user input
            		if [[ "$num" =~ ^[0-9]+$ ]] && [ "$num" -le "${#installed_software[@]}" ] && [ "$num" -gt 0 ]
			then
				# Saving user input to an array -> 'num-1' changing chosen numbers to indexes in array
        			selected_software+=("${installed_software[$((num-1))]}")
			else
				echo "Invalid selection: '${RED}$num${ENDCOLOR}'. Please choose a valid number."
                		echo

				if YesNo "Do you wanna choose again?"
				then
					uninstall
				else
					center_text "${RED}Returning the the menu....${ENDCOLOR}"
					sleep 1
					return

				fi
            		fi
    		done

    		# Confirming removal
    		echo "You selected the following tools to uninstall:"

		for app in "${selected_software[@]}"
    		do
        		echo
        		echo "${YELLOW}$app${ENDCOLOR}"
        		echo
    		done

    		if YesNo "Do you want to proceed with the removal?"
    		then
        		# Creating two arrays to save successfully removed software and unsuccessfully removed software
        		declare -a uninstalled_software=()
        		declare -a failed_software=()

        		# Iterating over selected tools
            		for app in "${selected_software[@]}"
            		do
                		case "$distro" in

                    		[XLKuU]buntu | Debian)

					if [ "$app" == "mysql" ]
                                        then
                                      		sudo apt purge mysql-server
                                                sudo apt autoremove

					elif [ "$app" == "kubernetes" ]
					then
						sudo apt purge kubeadm kubectl kubelet kubernetes-cni minikube
						sudo autoremove

					elif [ "$app" == "grafana-server" ]
					then
						sudo apt-get purge grafana
						sudo apt autoremove

					else

						sudo apt-get purge "$app"
						sudo apt autoremove
					fi

					;;

		    		Fedora | CentOS | Red*)
					if ["$app" == "kubernetes"]
                                        then
                                                sudo dnf remove kubeadm kubectl kubelet kubernetes-cni minikube
                                                sudo autoremove

                                       else
					       sudo dnf remove "$app"
					       sudo dnf autoremove
					fi

					;;

                    			*)
                       		 	echo
                        		echo "ERROR: Unsupported distribution"
                        		terminal_stars
                        		press_enter
                        		return

					;;

					esac

				# Checking for successful uninstallation
                		if [ $? -eq 0 ]
                		then
                    			uninstalled_software+=("$app")
                		else
                    			failed_uninstalls+=("$app")
                		fi
            		done

            		# Showing uninstallation result
            		if [ ${#uninstalled_software[@]} -gt 0 ]
            		then
                		echo
                		echo "${YELLOW}Successfully uninstalled:${ENDCOLOR}"

				for app in "${uninstalled_software[@]}"
                		do
                    			echo "- ${GREEN}$app${ENDCOLOR}"
                		done

				echo

				if YesNo "Do you wanna choose different software?"
                        	then
                                	uninstall
                        	else
                                	press_enter
                        	fi

			fi

            		if [ ${#failed_uninstalls[@]} -gt 0 ]
            		then
                		echo
                		echo "${YELLOW}Failed to uninstall:${ENDCOLOR}"

				for app in "${failed_uninstalls[@]}"
                		do
                    			echo "- ${RED}$app${ENDCOLOR}"
                		done

				echo

				if YesNo "Do you wanna choose different software?"
                        	then
                                	uninstall
                        	else
                                	press_enter
                        	fi

            		fi

		# In case user doesn't wanna procced with the removal
		else
			if YesNo "Do you wanna choose different software?"
			then
				uninstall
			else
				press_enter
			fi
        	fi

	elif [ "$system" == "Darwin" ]
    	then
        	declare -a installed_software=()

        	for app in "${software[@]}"
        	do
            		if brew list "$app" > /dev/null 2>&1
            		then
                		installed_software+=("$app")

			elif [ "$app" == "kubernetes" ]
			then
				if brew list microk8s > /dev/null 2>&1
				then
					installed_software+=("$app")
				fi
            		fi
        	done

        	if [ ${#installed_software[@]} -eq 0 ]
       		then
            		echo
            		center_text "${RED}No installed services or programs found${ENDCOLOR}"
            		echo
            		center_text "Returning to the menu...."

            		sleep 1
            		return
        	fi

        	# Listing installed software for macOS
        	echo "The following software is installed:"
        	echo

		for i in "${!installed_software[@]}"
        	do
            		echo "$((i+1)). ${installed_software[$i]}"
        	done

        	echo

		read -p "Enter the numbers of the software you want to uninstall (separated by spaces): " selected

        	declare -a selected_software=()

        	for num in $selected
        	do
            		selected_software+=("${installed_software[$((num-1))]}")
        	done

        	# Confirming uninstallation
        	echo "You selected the following tools to uninstall:"
        	for app in "${selected_software[@]}"
        	do
            		echo
            		echo "${YELLOW}$app${ENDCOLOR}"
            		echo
        	done

        	if YesNo "Do you want to proceed with the uninstallation?"
        	then
            		declare -a uninstalled_software=()
            		declare -a failed_uninstalls=()

            		for app in "${selected_software[@]}"
            		do
				if [ "$app" == "kubernetes" ]
				then
					brew uninstall microk8s
				else
					brew uninstall "$app"
				fi

                		# Saving uninstallation results
                		if [ $? -eq 0 ]
                		then
                    			uninstalled_software+=("$app")
                		else
                    			failed_uninstalls+=("$app")
                		fi
            		done

			# Showing successfull uninstallation result
            		if [ ${#uninstalled_software[@]} -gt 0 ]
            		then
                		echo
                		echo "${YELLOW}Successfully uninstalled:${ENDCOLOR}"

				for app in "${uninstalled_software[@]}"
                		do
                    			echo "- ${GREEN}$app${ENDCOLOR}"
                		done

				echo
            		fi

			# Showing unsuccessfull uninstallation result
            		if [ ${#failed_uninstalls[@]} -gt 0 ]
           		then
                		echo
                		echo "${YELLOW}Failed to uninstall:${ENDCOLOR}"

				for app in "${failed_uninstalls[@]}"
                		do
                    			echo "- ${RED}$app${ENDCOLOR}"
                		done

				echo
            		fi

			# Prompt after results are shown
			if YesNo "Do you wanna choose different software?"
                        then
                                uninstall
                        else
                                press_enter
                        fi


		# In case user doesn't wanna procced with the removal
		else
			if YesNo "Do you wanna choose different software?"
			then
				uninstall
			else
				press_enter
			fi
        	fi

	# Logic for unsupported OS
	else
        	echo "Unsupported OS: $system"
        	echo
        	center_text "Returning to the menu....."
        	sleep 1
        	return
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
read -p "   What do you wish to do? " option enter
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
# Option to make post installational configuration
#

        [3*]|"Configurate")

        configurate

        ;;


#
# Option to start/stop chosen service
#

        [4*]|"Toggle")

        toggle

        ;;


#
# Option to uninstall chosen tools and packages
#

	[5*]|"Uninstall")

	uninstall

	;;

#
# Quit option
#

	[6*]|"Quit")

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
