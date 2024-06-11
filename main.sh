#!/usr/bin/env bash

green='\033[0;32m'
orange='\033[0;33m'
red='\033[0;31m'
reset='\033[0m'

# Function to print text in light blue color
print_orange() {
  local text="$1"
  echo -e "${orange}${text}${reset}"
}

# function for application loader
function loader {
  for i in {1..57}; do
    echo -en "."
    sleep 0.02
  done
  echo -e "100%\n"
}

echo -e "\n\n"
print_orange "███╗   ██╗███████╗ ██████╗ ██████╗  ██████╗ ██████╗      ██╗██████╗ "
print_orange "████╗  ██║██╔════╝██╔════╝ ██╔══██╗██╔═══██╗██╔══██╗    ███║╚════██╗"
print_orange "██╔██╗ ██║█████╗  ██║  ███╗██████╔╝██║   ██║██║  ██║    ╚██║ █████╔╝"
print_orange "██║╚██╗██║██╔══╝  ██║   ██║██╔═══╝ ██║   ██║██║  ██║     ██║██╔═══╝ "
print_orange "██║ ╚████║███████╗╚██████╔╝██║     ╚██████╔╝██████╔╝     ██║███████╗"
print_orange "╚═╝  ╚═══╝╚══════╝ ╚═════╝ ╚═╝      ╚═════╝ ╚═════╝      ╚═╝╚══════╝"
echo
echo -e "\n"

echo -en "Loading"
loader

export file_path="Students-list_1023.txt"

#----------------------------------------function To Register student
function register {
  # get inputs with function
  read -p "Enter Student Email: " email
  read -p "Enter Student Age: " age
  #must be in formmat like this [ALU2023001]
  read -p "Enter Student Id: " id

  if [[ $email == *"@alustudent.com" ]]; then
    if [ -e "$file_path" ]; then
      echo "adding student"
    else
      printf "+----------------------------+----------------------------+-----------------------------------+\n" > $file_path
      printf "| %-26s | %-26s | %-33s |\n" "student Id" "Age" "Email" >> $file_path
      printf "+----------------------------+----------------------------+-----------------------------------+\n" >> $file_path
      echo "Creating Table and Adding Data"
    fi
    sleep 1
    # use grep to search if student id column exists
    if grep -E "^\|[[:space:]]$id[[:space:]]\|" $file_path; then
      # message notification
      echo -e "\n\n${orange}*The student Id Already Exists${reset}\n"
      # restart app for the user to enter new data
      sleep 2
      clear
      ./main.sh
    else
      # Print table rows
      printf "| %-26s | %-26s | %-33s |\n" "$id" "$age" "$email" >> $file_path
      printf "+----------------------------+----------------------------+-----------------------------------+\n" >> $file_path
      # loading message
      echo -en "${green}opening preview loading${reset} ";
      loader
      # end of loading
      cat $file_path
      echo -e "\n\n **** Press any key to return home **** \n\n"
      read -n 1
      clear
      ./main.sh
    fi
  else
    echo -e "\n\n${orange}**************** This is Not A valid ALU Student Email ****************${reset}\n\n"
    # call the register function if invalid email to allow the user to input again
    register
  fi
}

