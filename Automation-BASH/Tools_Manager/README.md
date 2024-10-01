# <center></centerSoftware>Tools Manager
#### <center> Automate the management of system packages</center>
<p align="center">

[![GIF](https://upload.wikimedia.org/wikipedia/commons/d/df/Wikisp-logo-icon-black.svg "GIF")](https://upload.wikimedia.org/wikipedia/commons/d/df/Wikisp-logo-icon-black.svg "GIF")

![Static Badge](https://img.shields.io/badge/fedora-lightblue%20%20%20%20%20%20%20%20%20%20?style=for-the-badge&logo=fedora&logoColor=lightblue&logoSize=auto&labelColor=black)  ![Static Badge](https://img.shields.io/badge/redhat-darkred%20%20%20%20%20%20?style=for-the-badge&logo=redhat&logoColor=darkred&logoSize=auto&labelColor=black) ![Static Badge](https://img.shields.io/badge/ubuntu-orange?style=for-the-badge&logo=ubuntu&logoColor=orange&logoSize=auto&labelColor=black) ![Static Badge](https://img.shields.io/badge/debian-gray?style=for-the-badge&logo=debian&logoColor=white&logoSize=auto&labelColor=black) ![Static Badge](https://img.shields.io/badge/macos-darkviolet?style=for-the-badge&logo=apple&logoColor=darkviolet&logoSize=auto&labelColor=black)

</p>

------------

<p align="center">
![Static Badge](https://img.shields.io/badge/Table%20%20%20%20%20%20%20%20%20%20%20of%20%20%20%20%20%20%20%20%20%20Contents-blue?style=for-the-badge&logoColor=darkviolet)

**| [Overview](#overview) | [Key Features](#key-features) | [User Manual](#user-manual) | [Ongoing Improvements and Known Bugs](#ongoing-improvements-and-known-bugs) | [Found a Bug?](#found-a-bug) |**

</p>



------------



## <center>Overview</center>
<p align="center">Automates system package management across various Linux distributions and macOS. With built-in OS detection, it intelligently adapts to each operating system and provides adequate commands to install, view, or uninstall software, making it easy to manage tools and packages without needing specialized knowledge of each system</p>


------------



## <center>Key Features</center>
##### <center>OS Detection</center>
###### <center> Detects the operating system in use and adjusts package management commands accordingly.</center>
##### <center>Menu-Based</center>
###### <center>  Offers a simple, interactive menu to easily navigate through different package management options.</center>
##### <center>Overview</center>
###### <center> Provides an option to view all installed tools and packages with a single command.</center>
##### <center>Protection</center>
###### <center>Prevents the removal of essential system utilities, ensuring the integrity of the operating system.</center>
##### <center>Batch Installation / Removal</center>
###### <center>Allows users to select and remove or install  multiple tools and packages in one go. </center>


------------



## <center>User Manual</center>
#### Prerequisites
Ensure that the following are installed on your system:
- Bash shell (`/bin/bash`)
 ```bash
$ which bash
```
> **Note**
> Output typically shows `/bin/bash` or `/usr/local/bin/bash` if Bash was installed via Homebrew on macOS

####  Requirements
- Administrator (sudo) rights:
```bash
# Check if you have sudo privileges:
$ sudo -v
```
> **Note**
> If you are prompted for your password and no errors occur, you have sudo rights.

- External script

  The script relies on an external file called `functions_library` located in the repository. Ensure this file exists in the correct location:
```bash
# Check if the external file exists in the same directory as the script:
$ ./functions_library  && echo "functions_library exists" || echo "functions_library is missing"
```
> **Note**
> Output of the command should be: `functions_library exists`

####  Setup
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
$ chmod +x tools_manager.sh
```

####   Features and Usage
- Run the file

  To run the script, execute:
```bash
$ ./tools_manager.sh
```


######  Main Menu

After running the script, you will be presented with a menu. The available options are:

1. ** View **: Displays a list of installed tools and packages specific to your operating system.
2. **Install**: Provides a list of available tools that are not currently installed. You can select the tools you wish to install.
3. **Uninstall**: Shows the list of installed tools and allows you to uninstall selected packages.
4. **Quit**: Exits the program.

Select an option by typing the corresponding number and pressing `Enter`.

###### View
To view a list of currently installed tools:
1. From the `main menu`, choose the `View` option by typing `1` and pressing `Enter`.
2. The script will display the installed tools based on your operating system:
 -  For Ubuntu/Debian systems, it uses `dpkg` and `apt`.
 -  For Fedora/CentOS, it uses `yum`, `dnf`, and `rpm`.
 -  For macOS, it uses `brew`.
6.  After viewing the tools, press `Enter` to return to the `main menu`.

###### Install
To install missing tools:
1. Select the `Install` option by typing `2` and pressing `Enter`.
2. The script will list the tools that are available for installation but are not yet installed on your system.
3. You will be prompted to select the tools you want to install by entering their corresponding numbers (separated by spaces) and pressing `Enter`.
4. Confirm your selection when prompted to proceed with the installation.
5. The installation process will run, and you will be shown which tools were successfully installed and if any failed.

###### Uninstall
To remove tools that are no longer needed:
1. Select the `Uninstall` option by typing `3` and pressing `Enter`.
2. The script will display a list of tools that are currently installed and safe to uninstall (excluding core system utilities).
3. Choose the tools you wish to uninstall by entering their corresponding numbers and pressing `Enter`.
4. Confirm the uninstallation when prompted.
5. After the process is complete, you will see which tools were successfully removed and if any uninstallation attempts failed.

###### Quit
To quit the program, type in `4` and press `Enter`. Before exiting, the program will confirm if you’re sure about quitting:
1. Type `Yes` to quit the program.
2. Type `No` to return to the  `main menu `.

#### Customization
###### Adjusting Uninstallation Logic

By default, the script excludes critical tools from being uninstalled, such as apt, yum, or brew. You can adjust which tools are considered "non-removable" or change the uninstallation commands.

**Steps to Adjust Non-Removable Tools**:
1. In the `uninstall()` function, find the arrays that list non-removable tools:
 - `non_removable_dpkg` for Debian-based systems
 - `non_removable_rpm` for Red Hat-based systems
2. Add or remove tools from these arrays. For example:
```bash
non_removable_dpkg=("apt" "tar" "sed" "new-tool")
```


###### Customizing the List of Tools and Packages
You can customize which tools and packages are checked or managed by modifying the arrays for each supported operating system.

**Steps to Customize Tools List**:
1. Open the script in a text editor.
2. Locate the arrays for each operating system:
 - `tools_rpm` for Red Hat-based systems (Fedora, CentOS)
 - `tools_dpkg` for Debian-based systems (Ubuntu, Debian)
 - `tools_mac` for macOS
 - `tools_all` for common tools across all systems
3. Add or remove the names of the tools you want to manage. For example:
```bash
$ tools_rpm=("yum" "dnf" "rpm" "cronie" "new-tool")
```
4. Save the changes and rerun the script.

------------

## <center>Ongoing Improvements and Known Bugs</center>

| # | Name              | Type             | Description                                                                                                                                                |
|---|-------------------|------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 1 | Automatic Updates | Work in progress | Introducing an option to automatically check for and apply system updates for all installed packages, reducing manual intervention for system maintenance. |
| 2 | Certain Packages  | Bug              |  On macOS, certain packages may fail to install via brew if they are part of a cask, but the script treats them as regular packages.                       |




------------

## <center>Found a bug?</center>
<p align="center">
If you encounter any issues or bugs while using this project, please feel free to open an issue in the Issues section of the repository. Make sure to describe the bug in detail, providing steps to reproduce, expected behavior, and any relevant logs or screenshots.

If you'd like to contribute a fix for the issue, you're welcome to submit a pull request (PR). When submitting a PR, please reference the issue number and provide a description of the changes made.
</p>

------------

