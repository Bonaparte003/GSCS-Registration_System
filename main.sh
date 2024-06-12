
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

# function to view all students
function view_student {
  # Check if the file exists
  if [ -f "$file_path" ]; then
    # check if file is empty
    if [ -s "$file_path" ]; then
      # message
      echo -e "\n\n \t\t\t*** Viewing All Students ***\n\n\n"
      # display students
      cat "$file_path"
      # and also call restart the app for user to choose other
      ./main.sh
    else
      echo "${red}No Student Found. Try Adding New Students.${reset}"
      echo -e "\n\n **** Press any key to return home **** \n\n"
      read -n 1
      clear
      ./main.sh
    fi
    else
    echo "${red}File Not Found.${reset}"
    echo -e "\n\n **** Press any key to return home **** \n\n"
    read -n 1
    clear
    ./main.sh
  fi
} 

# Function to update student details ----
function update_student {
# check if file exists
  if [ -f "$file_path" ]; then
    # get email
    read -p "Enter The Student Id To Edit: " id

    # check existence of the student id
    if grep -E "^\|[[:space:]]*$id[[:space:]]*\|" "$file_path"; then
      # message to the being edited
      echo -e "\nYou Are Editing this User\n"
      # get data from user: age and email
      read -p "Enter New Age: " age
      read -p "Enter New Email: " email

      if [[ $email == *"@alustudent.com" ]]; then
        temp_file="temp_file"
        found=false
        while IFS= read -r line; do
          if echo "$line" | grep -q -E "^\|[[:space:]]*$id[[:space:]]*\|"; then
            printf "| %-26s | %-26s | %-33s |\n" "$id" "$age" "$email" >> "$temp_file"
            found=true
          else
            echo "$line" >> "$temp_file"
          fi
        done < "$file_path"
        
        if [ "$found" = false ]; then
          echo "${red}Student ID: $id not found in the file.${reset}"
          echo -e "\n\n **** Press any key to return home **** \n\n"
          read -n 1
          clear
          ./main.sh
        else
          mv "$temp_file" "$file_path"
          echo "${green}Successfully Edited Student with ID: $id${reset}"
          echo -e "\n\n **** Preparing Your Preview **** \n\n"
          loader
          # end of loading
          clear
          view_student
        fi
      else
        echo -e "\n\n${orange}**************** This is Not A valid ALU Student Email ****************${reset}\n\n"
        update_student
      fi
    else
      echo -e "${red}Error: Student Id Doesn't exist: $id${reset}"
      echo -e "\n\n **** Press any key to return home **** \n\n"
      read -n 1
      clear
      ./main.sh
    fi
  else
    echo -e "${red}Error: File not found : $file_path${reset}"
    echo -e "\n\n **** Press any key to return home **** \n\n"
    read -n 1
    clear
    ./main.sh
  fi
}

#---------------------------------------function to Delete student------------------
function delete_student {
    # Get student Id
    read -p "Enter The Student Id To Delete: " id
   # Check if file Exists To Avoid Errors
    if [ -f "$file_path" ]; then
        # Use Grep To Search Student Id that matches the pattern
        grep -E -n "^\|[[:space:]]*$id[[:space:]]*\|" "$file_path" | while read -r line; do
            # Lines matches including numbers and split them (with line numbers)
            line_num=$(echo "$line" | cut -d ':' -f 1)
            # Delete the line that matched the search and the next line
            sed -i "${line_num}d;$(($line_num+1))d" "$file_path"
        done
	echo "${green}Deleted row with Student ID: $id${reset}"

        echo -e "\n\n **** Preparing Your Preview **** \n\n"
        loader
        # End of loading
        clear
        view_student
       else
         echo "${red}Error: File not found : $file_path${reset}"
         echo -e "\n\n **** Press any key to return home **** \n\n"
         read -n 1
         clear
         ./main.sh
    fi
}

function exit_main {
    # Send message for closing app
    echo -en "${green}\n\n\nClosing App. Please wait for a few seconds to finish...\n\n\n${reset}"
    sleep 0.6
    clear
    # Kill the main process
    pkill -f './main.sh'
}

#------------------------function to save in new file ------------------------------
function email_save {
    echo -en "${green}Saving Emails in ASC${reset}"
    sleep 0.6
    clear
    ./select-emails.sh
}

emails='student-emails.txt'


#------------------------function to view emails in ASC order-----------------------
function view_email {
    # Loading message
    echo -en "${green}Opening Emails preview in ASC Order${reset}"
    loader
    # End of loading
    cat "$emails"
    ./main.sh
}
