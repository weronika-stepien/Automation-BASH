# <center></centerSoftware>Software Management Automation Tool
#### <center>Automate software lifecycle management to simplify DevOps operations</center>
<p align="center">

[![GIF](https://upload.wikimedia.org/wikipedia/commons/d/df/Wikisp-logo-icon-black.svg "GIF")](https://upload.wikimedia.org/wikipedia/commons/d/df/Wikisp-logo-icon-black.svg "GIF")

![Static Badge](https://img.shields.io/badge/fedora-lightblue%20%20%20%20%20%20%20%20%20%20?style=for-the-badge&logo=fedora&logoColor=lightblue&logoSize=auto&labelColor=black)  ![Static Badge](https://img.shields.io/badge/redha#!/bin/bash


t-darkred%20%20%20%20%20%20?style=for-the-badge&logo=redhat&logoColor=darkred&logoSize=auto&labelColor=black) ![Static Badge](https://img.shields.io/badge/ubuntu-orange?style=for-the-badge&logo=ubuntu&logoColor=orange&logoSize=auto&labelColor=black) ![Static Badge](https://img.shields.io/badge/debian-gray?style=for-the-badge&logo=debian&logoColor=white&logoSize=auto&labelColor=black) ![Static Badge](https://img.shields.io/badge/macos-darkviolet?style=for-the-badge&logo=apple&logoColor=darkviolet&logoSize=auto&labelColor=black)

------------

![Static Badge](https://img.shields.io/badge/Table%20%20%20%20%20%20%20%20%20%20%20of%20%20%20%20%20%20%20%20%20%20Contents-blue?style=for-the-badge&logoColor=darkviolet)

**| [Overview](#overview) | [Key Features](#key-features) | [User Manual](#user-manual) | [Ongoing Improvements and Known Bugs](#ongoing-improvements-and-known-bugs) | [Found a Bug?](#found-a-bug) |**
</p>

------------

## <center>Overview</center>
<p align="center">This project enables programs and services management to improve software lifecycle automation on Linux and macOS platforms. With modular architecture and intelligent OS detection, it provides any user with the ability to manage installation, configuration, and service status checks. The dynamic, menu-driven interface makes tasks such as toggling services and post-install configurations effortless while offering real-time feedback. Coupled with strong error handling, the tool ensures reliable operation across multiple distributions, reducing the need for manual oversight in multi-system environments and boosting overall efficiency.

</p>

------------

## <center>Key Features</center>
##### <center>OS Detection </center>
###### <center> Automatically identifies the operating system and distribution to apply appropriate package managers and commands.</center>

##### <center>Service and Program Overview</center>
###### <center>  Organizes installed programs and services into separate columns, grouping them into relevant categories for better readability and management.</center>
##### <center>  Active and Inactive Services Highlight</center>
###### <center>  Automatically highlights active services in green and inactive services in red, allowing users to quickly distinguish between operational and non-operational services.</center>
##### <center>  Dynamic Display</center>
###### <center>  Updates the active/inactive status of services dynamically without requiring a manual refresh.</center>
##### <center>  Automated Batch Installation</center>
###### <center>  Enables the installation of multiple services or programs in one go while requiring minimal user input and providing real-time progress updates for each step of the installation.</center>
##### <center>Configuration</center>
###### <center>After installation, additional configuration steps are automatically handled, enabling users to use their tools without manually adjusting settings.</center>
##### <center>  Selective Removal </center>
###### <center>  Empowers users to uninstall specific services or programs with a simple menu-based selection.</center>
##### <center>  Service and Program Cleanup</center>
###### <center>  Uninstalls software while safely removing associated dependencies, ensuring that the system remains free of unused packages without disrupting other services.</center>
##### <center>  Error Feedback</center>
###### <center>  Includes built-in validation and error handling to ensure smooth operation, minimizing system disruptions during installations or service management.</center>
##### <center>  Rollback</center>
###### <center>  Allows users to revert to the previous state in case an installation introduces issues or conflicts with existing services.</center>
##### <center>  Customization</center>
###### <center>  Enables easy integration of new services or programs by simply extending predefined arrays and functions.</center>


------------



## <center>User Manual</center>
#### 1. Prerequisites
Ensure that the following are installed on your system:
- Bash shell (`/bin/bash`)
 ```bash
$ which bash
```
> **Note**
> Output typically shows `/bin/bash` or `/usr/local/bin/bash` if Bash was installed via Homebrew on macOS

- OS-specific package managers like `apt` for Ubuntu/Debian, `dnf` for Fedora/RedHat or `brew` for macOS

 ```bash
 # To check if apt is available:
$ which apt 

# To check if dnf is available:
$ which dnf

# To check if brew is available:
$ which brew
```

>**Note**
> No output means specific package manager is not installed

#### 2. Setup
- Clone this repository
 ```bash
$ git clone <repository_url>
```
- Go into the repository
 ```bash
$ cd <repository_folder>
```
- Make it executable
 ```bash
$ chmod +x software_manager.sh
```
#### 3. Requirements
- Administrator (sudo) rights:
```bash
# Check if you have sudo privileges:
$ sudo -v
```
> **Note**
> If you are prompted for your password and no errors occur, you have sudo rights.

- External script

  The script relies on an external file called functions_library located in the repository. Ensure this file exists in the correct location:
```bash
# Check if the external file exists in the same directory as the script:
$ ./functions_library  && echo "functions_library exists" || echo "functions_library is missing"
```
> **Note**
> Output of the command should be: functions_library exists

#### 4. Usage
- Run the file

  To run the script, execute:
```bash
$ ./software_manager.sh
```

#### 5. Customization
###### Terminal Colors
The script supports color customization through terminal colors like `RED`, `GREEN`, `YELLOW`, and `BLUE`. Users can change used colors  by modifying the respective variables (`tput setaf` values) at the top of the script.
###### Services and Programs
The lists of services and programs managed by the script are stored in the arrays `services` and `programs`. You can customize the software managed by adding or removing items from these arrays:

- `programs=("git" "ansible" "terraform" "slack")`
- `services=("docker" "jenkins" "kubectl" "prometheus" "mysql" "grafana-server")`

Add new software names to these arrays, and the script will automatically include them in the management functions. After that the `install()` function also needs to get the appropriate modifications.
###### Alignment
The script calculates the starting position for text output with the variable `start_pos`. You can adjust this logic to change how far from the left or right the text starts. Additionally, the column widths for services and programs can be tweaked for better alignment using `service_col_width` and `program_col_width`.
###### Menu Appearance Customization
The appearance of the menu can be customized by modifying the function `main_menu()`. To change the text within the menu, update the strings within the `center_text` and `center_block` calls for options such as `View`, `Toggle`, `Uninstall` etc.

> **Note**
> External functions are well described in  ` functions_library` script.



------------

## <center>Ongoing Improvements and Known Bugs</center>

| **#** | **Name**               | **Type**    | **Description**                                                                                                             |
|:-----:|:----------------------:|:-----------:|:---------------------------------------------------------------------------------------------------------------------------:|
| 1     | Text Centering         | Bug         | The current text-centering function does not correctly adjust when color codes are applied, causing the text to misalign.   |
| 2     | Double Exit Invocation | Bug         | In certain workflows, the `press_enter` function is mistakenly called twice, leading to multiple exit prompts.              |
| 3     | Configuration Feature  | In Progress | The configuration module is still in progress and will include advanced options for customizing post-installation settings. |



------------

## <center>Found a bug?</center>
<p align="center">
If you encounter any issues or bugs while using this project, please feel free to open an issue in the Issues section of the repository. Make sure to describe the bug in detail, providing steps to reproduce, expected behavior, and any relevant logs or screenshots.

If you'd like to contribute a fix for the issue, you're welcome to submit a pull request (PR). When submitting a PR, please reference the issue number and provide a description of the changes made.
</p>

------------



