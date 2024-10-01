# Library of Functions
#### Store and organize all the useful Bash functions ever created for quick reference and reuse


![Preview](/Images/functions_library.gif)

![Static Badge](https://img.shields.io/badge/fedora-lightblue%20%20%20%20%20%20%20%20%20%20?style=for-the-badge&logo=fedora&logoColor=lightblue&logoSize=auto&labelColor=black)  ![Static Badge](https://img.shields.io/badge/redhat-darkred%20%20%20%20%20%20?style=for-the-badge&logo=redhat&logoColor=darkred&logoSize=auto&labelColor=black) ![Static Badge](https://img.shields.io/badge/ubuntu-orange?style=for-the-badge&logo=ubuntu&logoColor=orange&logoSize=auto&labelColor=black) ![Static Badge](https://img.shields.io/badge/debian-gray?style=for-the-badge&logo=debian&logoColor=white&logoSize=auto&labelColor=black) ![Static Badge](https://img.shields.io/badge/macos-darkviolet?style=for-the-badge&logo=apple&logoColor=darkviolet&logoSize=auto&labelColor=black)


------------


![Static Badge](https://img.shields.io/badge/Table%20%20%20%20%20%20%20%20%20%20%20of%20%20%20%20%20%20%20%20%20%20Contents-blue?style=for-the-badge&logoColor=darkviolet)

**| [Overview](#overview) | [Key Features](#key-features) | [User Manual](#user-manual) | [Ongoing Improvements and Known Bugs](#ongoing-improvements-and-known-bugs) | [Found a Bug?](#found-a-bug) |**



------------



## Overview
This script serves as a library of reusable Bash functions designed to enhance the efficiency and consistency of shell scripts. Each function is well-organized, thoroughly commented, and includes a proper description of its purpose, features, and usage examples. The functions are intended to be sourced into other scripts, providing common functionalities such as user prompts, text formatting, and program control flow.


------------

## Key Features
##### Reusable
###### Each function can be sourced into other scripts to enhance functionality.
##### Detailed  Metadata
###### Functions include descriptions, features, first usage reference, and examples.
##### Sourcing Support
###### The project includes guidelines on how to properly source the functions library and avoid potential errors.
##### Cross-Script Compatibility
###### Functions are designed to be portable across different Bash scripts and environments, ensuring that they work seamlessly regardless of the script they are integrated into.
##### Customization
###### Allowance for easy parameter adjustments or modifications to fit different use cases without rewriting core functionality.


------------



## User Manual
</div>

#### 1. Sourcing
To use the functions provided in the library, you need to **source** the `functions_library` file in your script. This process loads all the functions into your current shell session, making them available for use within your script.

###### When the library is in the same directory as your script:
```bash
$ source ./functions_library
```
###### When the library is in different directory than your script:
```bash
$ source /path/to/functions_library
```
###### To ensure the file is only sourced once,  conditional check can be implemented:
```bash
$ if [ -f /path/to/functions_library ]; then
    source /path/to/functions_library
fi
```
###### To handle errors during sourcing:
```bash
$ source /path/to/functions_library || { echo "Failed to source functions_library"; exit 1; }
```
#### 2. Usage
Once the library is sourced, you can call any function in your script just as if it were defined locally. Every function has its own set of input parameters and usage examples, which are documented within the library.
###### General Syntax:
```bash
$ function_name argument1 argument2 ...
```
#### 3. Function Documentation
Each function in the library comes with detailed documentation, including:

- **Description**: A brief overview of what the function does.
- **Features**: Key functionalities and special behaviors.
- **First Usage**: Reference to where the function was first used in a script.
- **Syntax**: The expected input format when calling the function.
- **Example Output**: Illustrates the output when the function is used.

To view the documentation for any function, refer to the comment block above its definition within the `functions_library` file.

#### 4. Customization
The `functions_library` is designed for extensibility. You can easily add new functions by following the existing structure:
- **Add new function**: Define the function in the same format with proper documentation.
- **Update metadata**: Include details like the function’s purpose, first usage, and any relevant features.
- **Maintain consistency**: Ensure that the new functions follow the existing style guide and commenting format.

If you would like to contribute to the `functions_library`, follow these steps:
1. Fork the repository.
2. Add your new function in the appropriate section.
3. Ensure your function follows the existing structure and includes proper documentation.
4. Test your function before submitting a pull request.

------------
<div align="center">

## Ongoing Improvements and Known Bugs

| **#** | **Name**                                                   | **Type**         | **Description**                                                                                                                                                                                                                         |
|:-----:|:----------------------------------------------------------:|:----------------:|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|
| 1     | Terminal Width Detection                                   | Bug              | The `center_text` and `center_block` functions rely on terminal width detection via `tput cols`. In some remote environments or restricted shells, this command may return incorrect values, causing improper text alignment.           |
| 2     | Inconsistent Behavior of YesNo() on Non-Interactive Shells | Bug              | The `YesNo` function may not work as expected in non-interactive shells (e.g., running in a CI/CD pipeline) due to the absence of user input.                                                                                           |
| 3     | `file_exists` Function Ignores Hidden Files                | Bug              | The `file_exists` function does not currently search for hidden files (those starting with a `.`). This may lead to missed results when searching directories that contain hidden files.                                                |
| 4     | Sourcing Failure on Restricted Systems                     | Bug              | On some restricted systems, sourcing the `functions_library` file may fail if permission to access external files is limited.                                                                                                           |
| 5     | Interactively Add Function                                 | Work in progress | Instead of manually editing the file, this option allows users to define and add new functions through an interactive command-line interface. The feature will guide users through the process of defining key aspects of the function. |



------------

## Found a bug?
If you encounter any issues or bugs while using this project, please feel free to open an issue in the Issues section of the repository. Make sure to describe the bug in detail, providing steps to reproduce, expected behavior, and any relevant logs or screenshots.

If you'd like to contribute a fix for the issue, you're welcome to submit a pull request (PR). When submitting a PR, please reference the issue number and provide a description of the changes made.

------------

</div>



