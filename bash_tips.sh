# Here are some useful Bash tips

#                                      1. Globbing

# When trying to list dotfiles, simply use "echo .*"


#                                       2. Variables

# Shell treats each word separated by a space as a single program or command.
# So simply use " " to enumerate all such words into a single string.

# Shell does not output variable values when enclosed in single quotes.  
# It only does so when it is done in double quotes.

# Special Variables:
# PPID ("Parent Process ID") is an automatically set variable when the Bash shell is started

# unset command:
# the unset command unsets the variable value.

# export command:
# export VARIABLENAME=VALUE makes the new bash shell inherit the newly created variable.

# env command: env lists all the environment variable that are exported to a new shell.

compgen -v
# compgen or "completion generator" lists all the variables that are present in your shell.

#                                         3. Functions
# A command can be either a function, alias, program, or a builtin

# Functions don't necessarily have formal arguments

# Sample Program:

function myfunction {
   echo $1
   echo $2
}

myfunction "HELLO WORLD"
# Output:
# HELLO WORLD
#

myfunction HELLO WORLD
# Output:
# HELLO
# WORLD

# Variables have scope in Bash. This prevents misuse of them.
# Bash Functions can access variables that are declared outside of it.
# Local Variables can also be declared inside Bash Functions.
# But Local Variables can only be accessed inside a function and not outside

# Sample Program:

function myfunc {
    local myvar="Hi from INSIDE"
    echo $myvar
}

local myvar="Hi from OUTSIDE"

#Output:
#-bash: local: can only be used in a function

# Four types of commands in Bash:
# 1. Builtins
# 2. Functions
# 3. Programs
# 4. Aliases

# * Builtins
# Builtins are 'built in' commands that come prepackaged in your bash shell
# Eg. "cd" is a builtin
# You can also access a builtin by typing the builtin keyword

# Sample Commands:

builtin cd /tmp # Takes you to the tmp folder in the root directory
cd - # Takes you to your previous directory. ! Very Useful !
builtin grep
builtin notaprogram

# Output for the last two lines:
# -bash: builtin: grep: not a shell builtin
# -bash: builtin: notaprogram: not a shell builtin

# *Functions

# Sample Program: Overriding a builtin program

function cd() {
    echo 'No'
}

cd /tmp # Outputs No
builtin cd /tmp # cd now acts like a proper builtin
cd -
unset -f cd # To unset a function use the unset with -f flag
cd /tmp
cd -

# Sample Program: Listing functions in the current environment
declare -f # Lists all the functions with their source code
declare -F # Simply lists the function names
unset -f cd # Unsets the cd function in the current working directory

# * Programs
# Programs, unlike builtins, are separate files located on your system
# For example, grep, sed, vi are separate programs in your machines
# Use the builtin comman to check if a command is a builtin
# Use the which _Command_ to check the location of a file on your machine

# Sample program
builtin grep
which grep # Output: /usr/bin/grep
which which # which is itself a program and not a builtin

# *alias
# The Shell translates a string into what it's being aliased to.

# Sample Program:

alias cd="doesnotexist"
alias # Output: alias cd='doesnotexist'
cd # Output: -bash: doesnotexist: command not found
unalias cd # Removes any remaining aliases

# Additional Notes:
# the Intepretation of a command in a shell can be deduced using the 'type' builtin

# Sample Program:
type ls # Output: ls is hashed (/bin/ls)
type pwd # Output: pwd is a shell builtin
type myfunc # Output: -bash: type: myfunc: not found


#                                        4. Pipes and Redirects

# Sample command
' These are some file contents' > file1 # Creates a file1 if it doesn't exist and writes to it.
cat file1 # Outputs to the terminal console the contents of the file.

# '>' is called the redirect operator.

# Basic Pipe Program

cat file1 | grep -c file # Searches for the number of occurrences of the pattern 'file' in file1
# Here it outputs 1.

# Pipe: A pipe commands takes the output of 1 command and sends it as an input of another.

cat file5 | grep -c file

# Output:
# cat: file5: No such file or directory
# 0

# There are three main types of channels:
# 0 -- Standard Input
# 1 -- Standard Output
# 2 -- Standard Error
# The numbers 0, 1, 2 are known as the file descriptors

# ! Important Example !

command_does_not_exist # Error Message Outputted to the terminal
command_does_not_exist 2> /dev/null # ***Outputs Nothing

# Remember that in the last command, you are simply redirecting date from the standard error
# channel to the /dev/null file.

# /dev/null file is a special Unix/Linux kernel file that can absorb and gulp any data.

# You can easily redirect outputs from one channel to another channel to a file
command_does_not_exist 2>&1 > outfile
cat outfile # Error: Prints the error message onto the terminal
command_does_not_exist > outfile 2>&1
cat outfile # Prints the error message CORRECTLY!

# Correct way to redirect stderr channel:
# stdout->outfile stderr->stdout
# Mahasaya->outfile 2->&1

# * Redirects vs Pipes

# Sample Program

grep -c file < file1 # Takes file1 as input to the grep command
file1 | grep -c file # Equivalent: Outputs 1

# Appending to a file
# Use the '>>' Character to append contents to a file

echo line1 > file3 # writes the String "line1" to file3
echo line2 > file3 # OVERwrites the String "line2" to file3
echo line1 > file3 # writes AGAIN to the file3
echo line2 >> file3 # Appends line2 to file3'
cat file3
# Output:
# line1
# line2

#                                5. Shell Scripts and Startups

# Definition: A shell script is a collection of shell commands can be run at once.

# Sample Program:

echo '#!/bin/bash' > simple_script
echo 'I am a simple script' >> simple_script
./simple_script # Output: Error: Permission Denied

# Any command with '#!......" is known as the "shebang" or the "hashbang"
# When a compiler sees such a program it knows that such a program must be run with the help of an interpreter or a shell.

./simple_script #---> Only works if simple_script is an executable

# Hoever, you can change the file access using the 'chmod' command

chmod +x simple_script # Changes the file to be an executable so that any member can access it
./simple_script # This atleast can access the file

# *PATH Variable

# The PATH variable is a variable that holds all the directories that the bash shell can search in.
# And the PATH variable is set by Shell Startup Scripts

# Sample Output:

echo $PATH
# Output:
#/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Library/TeX/texbin:/opt/X11/bin:/Library/Apple/usr/bin

# You can slightly alter the PATH variable as follows
PATH={$PATH}:. # Sets the current working directory as a Path

# *Startup Explained

# Which Startup Scripts run depends on the context in which they operate
# Different shells have different Contexts which can be observed by directed graphs.

# At each point the context-hierarchy determines whether you are operating on an interactive or a non-interactive shell.

# Interactive means that the startup scripts takes user input from the terminal.
# Non-interactive means that the startp script does not take input files from the terminal.

# The path that the context hierarchy takes is as follows:

# local/remote shell -> login/non-login -> interactive-shell?
# If the file that you want to run is not part of this hierarchy, it is simply ignored.

# * Source Builtin

# 'source' is a builtin that can be used to run scripts at the local context.
# i.e. it makes your shell run scripts in your current directory.

# Sample Program:
MYVAR=HELLO
echo 'echo $MYVAR' > simple_echo
chmod +x simple_echo
./simple_echo
source simple_echo

# Suffix: Most Shell Scripts have a .sh suffix attached to the end, but it is not necessary.
# The OS does not CARE about the suffix.

# *******AVOIDING STARTUP SCRIPTS*********

# Startup Scripts can be avoided by using the following command

env -i bash --noprofile --norc

# -i flag: Removes all the env variables when the bash command is run
# --noprofile flag tells bash not to source the system-wide bash startup files.
# --norc tells bash not to source the personal ones present in your home folder.






















