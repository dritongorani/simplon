#!/bin/bash



# 4. Functions

# A function compiles a set of commands into a group. If you need to execute the command again, simply write the function instead of the whole set of commands.

# There are several ways of writing functions.

# The first way is by starting with the function name and following it with parentheses and brackets:

# hello_world () {
# sudo apt update
# sudo apt upgrade
# }


#Execute the hello world function
hello_world


#############################

#  Loops

# Loop bash commands are useful if you want to execute commands multiple times. There are three types of them you can run in bash – for, while, and until.
####################################################
# The FOR loop runs the command for a list of items:
####################################################
#!/bin/bash
# for item in [list]
# do
# [commands]
# done

# The following example uses a for loop to print all the days of the week:

# #!/bin/bash
# for days in Monday Tuesday Wednesday Thursday Friday Saturday Sunday
# do
# echo “Day: $days”
# done
###################################################
# While
###################################################
# The next type of loop is while. The script will evaluate a condition. If the condition is true, it will keep executing the commands until the output no longer meets the defined condition.

# #!/bin/bash
# while [condition]
# do
# [commands]
# done

# Let’s take a look at a simple example that involves a variable and increment operator, denoted as ((++)):

# #!/bin/bash
# i=0
# while [ $i -le 5 ]
# do 
# echo $i
# ((i++))
# done

###############################################
#UNTIL
###############################################
# The last type of loop, until, is the opposite of while. It will iterate the command until the condition becomes true.
# If we want the same output as the while example above using the until loop, we can write the script like this:

# #!/bin/bash
# i=0
# until [ $i -gt 5 ]
# do 
# echo $i
# ((i++))
# done