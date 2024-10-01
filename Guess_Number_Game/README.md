<div align="center">

# Guess Number
####  Game that challenges the user to guess a randomly generated number

![Preview](/Images/guess_number_game.gif)

![Static Badge](https://img.shields.io/badge/fedora-lightblue%20%20%20%20%20%20%20%20%20%20?style=for-the-badge&logo=fedora&logoColor=lightblue&logoSize=auto&labelColor=black)  ![Static Badge](https://img.shields.io/badge/redhat-darkred%20%20%20%20%20%20?style=for-the-badge&logo=redhat&logoColor=darkred&logoSize=auto&labelColor=black) ![Static Badge](https://img.shields.io/badge/ubuntu-orange?style=for-the-badge&logo=ubuntu&logoColor=orange&logoSize=auto&labelColor=black) ![Static Badge](https://img.shields.io/badge/debian-gray?style=for-the-badge&logo=debian&logoColor=white&logoSize=auto&labelColor=black) ![Static Badge](https://img.shields.io/badge/macos-darkviolet?style=for-the-badge&logo=apple&logoColor=darkviolet&logoSize=auto&labelColor=black)



------------


![Static Badge](https://img.shields.io/badge/Table%20%20%20%20%20%20%20%20%20%20%20of%20%20%20%20%20%20%20%20%20%20Contents-blue?style=for-the-badge&logoColor=darkviolet)

**| [Overview](#overview) | [Key Features](#key-features) | [User Manual](#user-manual) | [Ongoing Improvements and Known Bugs](#ongoing-improvements-and-known-bugs) | [Found a Bug?](#found-a-bug) |**





------------



## Overview
The Number Guessing Game offers an interactive way to test your guessing skills. Players are asked to guess a number, with feedback provided after each attempt to indicate if the guess was too high or too low. There are no restrictions on how many attempts can be made, and users can quit at any time.


------------



## Key Features
##### Non-Restrictive
###### The player can guess as many times as they need without a time limit or penalties for incorrect guesses.
##### Tracking Attempts
###### The game keeps a count of how many tries the player has made to guess the correct number.
##### Guidance
###### Provides clear guidance after each guess, instructing players whether to guess higher or lower.
##### Simple Exit Mechanism
###### Players can easily exit the game by typing "Q", receiving a message with the correct answer before leaving.
##### Colored Output
###### Uses colors to enhance the gaming experience, with different colors representing high, low, or correct guesses.



------------



## User Manual
</div>

#### Prerequisites
Ensure that the following are installed on your system:
- Bash shell (`/bin/bash`)
 ```bash
$ which bash
```
> **Note**
> Output typically shows `/bin/bash` or `/usr/local/bin/bash` if Bash was installed via Homebrew on macOS

####  Requirements

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
$ chmod +x number_guessing_game.sh
```

####   Features and Usage
- Run the file

  To run the script, execute:
```bash
$ ./number_guessing_game.sh
```


######  Gameplay

The goal is to guess a randomly generated number. The game gives hints after each guess to help guide you towards the correct number.

**How to Play:**

1. After starting the game, you will be prompted to make a guess.
2. Enter your guess as a number and press `Enter`.
3. The game will provide feedback, telling you whether your guess was too high or too low.
4. Keep guessing until you find the correct number, or type `Q`, at any time to quit the game.
5. If you guess correctly, the game will congratulate you and tell you how many attempts it took to guess the number.

#### Customization
###### Changing Color Scheme

The colors for feedback can be changed by editing the color variables defined at the beginning of the script. For example, change the color for correct guesses:
```bash
$ BOLDGREEN=$(tput bold; tput setaf 2)
```
You can change the color code to a different value from the tput palette.


###### Changing Guess Range
By default, the game generates a random number based on `$RANDOM`. You can customize this by setting a specific range:
```bash
 # Limit guesses to between 1 and 100
$ number=$((RANDOM % 100))
```

------------
<div align="center">

## Ongoing Improvements and Known Bugs

| # | Name               | Type             | Description                                                                                                                                                                                                       |
|---|--------------------|------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 1 | Difficulty Levels  | Work in progress | Adding the ability for players to choose difficulty levels (easy, medium, hard) where the range of the random number changes based on difficulty. Easy might have a range of 1-50, medium 1-100, and hard 1-1000. |
| 2 |  Multi-Player Mode | Work in progress |  Implementing a two-player mode where players take turns guessing numbers, and the game tracks attempts for each player. The winner is the one who guesses the number in the fewest tries.                        |
| 3 | Color Display      | Bug              | Some terminal emulators may not correctly display the ANSI color codes, resulting in incorrect or missing colored output.                                                                                         |





------------

## Found a bug?

If you encounter any issues or bugs while using this project, please feel free to open an issue in the Issues section of the repository. Make sure to describe the bug in detail, providing steps to reproduce, expected behavior, and any relevant logs or screenshots.

If you'd like to contribute a fix for the issue, you're welcome to submit a pull request (PR). When submitting a PR, please reference the issue number and provide a description of the changes made.

------------

</div>



