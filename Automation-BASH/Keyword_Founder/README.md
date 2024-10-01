# <center></centerSoftware>Keyword Founder
#### <center> Simplify the task of identifying files that contain specific keywords within a directory or across the entire system</center>
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
<p align="center">Keyword Founder is a Bash script that automates the keyword search process by offering a dynamic, menu-based interface. It can handle single-file searches, directory-wide searches, and multi-directory searches, making it ideal for analyzing large datasets or code repositories. The program also offers options to view or export search results for later reference.</p>


------------



## <center>Key Features</center>
##### <center>User-Friendly Menu</center>
###### <center>  Includes a dynamic, text-based menu system for easy navigation through various search options.</center>
##### <center>Multiple Search Modes</center>
###### <center> Supports searching within a single file, a complete directory, or across multiple files and directories.</center>
##### <center>Path Flexibility</center>
###### <center> Automatically handles unknown file and directory paths, allowing users to perform searches without needing to manually locate files.</center>
##### <center>Keyword Occurrence</center>
###### <center>Displays the number of keyword occurrences directly in the terminal with line numbers.</center>
##### <center>Exporting Results</center>
###### <center>Offers the option to export search results to a file, making it easy to save and reference them later.</center>


------------



## <center>User Manual</center>
####  Requirements
- External script

  The script relies on an external file called `functions_library` located in the repository. Ensure this file exists in the correct location:
```bash
# Check if the external file exists in the same directory as the script:
$ ./functions_library  && echo "functions_library exists" || echo "functions_library is missing"
```
> **Note**
> Output of the command should be: `functions_library exists`
#### Getting Started
###### To run a program, you need to:
- Clone this repository
 ```bash
$ git clone <repository_url>
```
- Go into the repository
 ```bash
$ cd <repository_folder>
```
- Ensure that you have appropriate exectution permissions. You can adjust permissions using:
```bash
 $ .chmod +x keyword_founder.sh
 ```
- Run the script by typing:
 ```bash
 $ ./keyword_founder.sh
 ```

#### Features and Usage
######  Main Menu
After launching Keyword Founder, you will see a `main menu` with the following search options:
1.  **Search Single File**: Search for a keyword within a specific file.
2.    **Search Complete Directory**: Search across all files in a selected directory, including subdirectories.
3.    **Search Multiple Files and Directories**: Search multiple files and directories for the same keyword.

You can select an option by typing the corresponding number (`1`,` 2`,`3`) and pressing `Enter`. If you want to leave the program, just enter the letter `Q`.

###### Single File Search
1. Select the option by typing `1` and pressing `Enter`.
2. The program will ask if you know the file path. If you do, enter the path and the keyword you wish to search for.
3. If you don’t know the file path, the program will search the system for the file and allow you to select from the results.
4. Results can be displayed directly in the terminal or exported to a file.

###### Complete Directory Search
1. Select the option by typing  `2 ` and pressing  `Enter `.
2. Enter the directory path and keyword to search for.
3. The program will recursively search the entire directory for occurrences of the keyword in all files.
4. You can choose to view the results in the terminal or export them to a text file.

###### Multiple Files and Directories
1. Select the option by typing `3` and pressing `Enter`.
2. Enter the names of the files and directories you want to search, separated by spaces.
3. The program will search for the keyword in each specified file and directory.
4. As with other modes, you can view the results in the terminal or export them to a file.

###### Quit
To quit the program, type in `Q` and press `Enter`. Before exiting, the program will confirm if you’re sure about quitting:
1. Type `Yes` to quit the program.
2. Type `No` to return to the main menu.


#### Customization
###### Changing Search Command Behavior

The script uses `grep` to search files for keywords. You can modify the search behavior to match your requirements, such as ignoring case sensitivity or searching for exact matches only.

**Steps to Customize `grep` Behavior**:

1. Locate the `grep` commands in the script.
2. Modify the `grep` options as needed:
```bash
# Add -i  to ignore case:
$ grep -in "$keyword" "$path"
 
# Add -w to match whole words only:
$ grep -n -w "$keyword" "$path"
```


###### Export File Naming Convention
By default, exported search results are saved with the file name format `keyword_occurrences.txt`. You can change this naming convention to better suit your workflow.

**Steps to Modify Export File Naming**:

1.  In the script, locate the line where results are exported:
```bash
 $ echo "$occurrences" | nl > "${keyword}_occurrences.txt"
```
2. Modify the filename format as needed. For example, you could add a timestamp:
```bash
$ timestamp=$(date +"%Y%m%d_%H%M%S")
$ echo "$occurrences" | nl > "${keyword}_occurrences_$timestamp.txt"
```
------------

## <center>Ongoing Improvements and Known Bugs</center>

| # | Name               | Type             | Description                                                                                                                                                                                               |
|---|--------------------|------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 1 | Filters            | Work in progress | Search options that allow to filter by file type, size, or date modified, making searches more targeted and efficient.                                                        |
| 2 | Multi-Keyword      | Work in progress | Searching for multiple keywords simultaneously across files and directories.                                                                                                                              |
| 3 | Special Characters | Bug              | When searching for keywords that contain special characters (e.g., `&`,`*`, `$`), the `grep` command may misinterpret them as part of the regular expression, leading to incorrect or incomplete results. |
| 4 | Permission         | Bug              | When the script performs a system-wide search for unknown file or directory paths, it may fail to locate certain files due to permission restrictions or symbolic links.                                  |




------------

## <center>Found a bug?</center>
<p align="center">
If you encounter any issues or bugs while using this project, please feel free to open an issue in the Issues section of the repository. Make sure to describe the bug in detail, providing steps to reproduce, expected behavior, and any relevant logs or screenshots.

If you'd like to contribute a fix for the issue, you're welcome to submit a pull request (PR). When submitting a PR, please reference the issue number and provide a description of the changes made.
</p>

------------




