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

export file_path="Students-list_0524.txt"

#----------------------------------------function To Register student
function register {
  local email_regex="^[a-zA-Z0-9._%+-]+@alustudent.com$"
  local age_regex="^[0-9]+$"
  local id_regex="^[0-9]{1,4}$"

  # Validate Email
  while true; do
      read -p "Enter Student Email: " email
      if [[ $email =~ $email_regex ]] && ! grep -Eq "\|\s*$email\s*\|" "$file_path"; then
        break
      elif [[ $email =~ $email_regex ]] && grep -Eq "\|\s*$email\s*\|" "$file_path"; then
        echo -e "\n\n${orange}**************** This Email Already Exists ****************${reset}\n\n"
      else
        echo -e "\n\n${orange}**************** This is Not A valid Email ****************${reset}\n\n"
      fi
  done
  # Validate Age
  while true; do
    read -p "Enter Student Age: " age
    if [[ $age =~ $age_regex ]]; then
      break
    else
      echo -e "\n\n${orange}**************** This is Not A valid Age ****************${reset}\n\n"
    fi
  done

  # Validate Student ID
  while true; do
    read -p "Enter Student Id: " id
    # Ensure the input is numeric and has up to 4 digits
    if [[ $id =~ ^[0-9]{1,4}$ ]]; then
      local id_regex="^ALU[0-9]{8}$"
      current_year=$(date +%Y)
      # Zero-pad the ID to ensure it has exactly 4 digits
      id=$(printf "%04d" $id)
      # Generate the new ID with the current year and the zero-padded ID
      new_id="ALU${current_year}${id}"
      if [[ $new_id =~ $id_regex ]] && ! grep -q -E "^\|[[:space:]]*ALU${new_id:3}[[:space:]]*\|" "$file_path"; then
        break
      elif [[ $new_id =~ $id_regex ]] && grep -q -E "^\|[[:space:]]*ALU${new_id:3}[[:space:]]*\|" "$file_path"; then
        echo -e "\n\n${orange}**************** This Student Id Already Exists ****************${reset}\n\n"
      else
        echo -e "\n\n${orange}**************** This is Not A valid Student Id ****************${reset}\n\n"
        read -p "Enter a valid Student Id: " id
      fi
    else
      echo -e "\n\n${orange}**************** This is Not A valid Student Id ****************${reset}\n\n"
    fi
  done


  # Check if file exists and add headers if not
  if [ ! -e "$file_path" ]; then
    printf "+----------------------------+----------------------------+-----------------------------------+\n" > $file_path
    printf "| %-26s | %-26s | %-33s |\n" "student Id" "Age" "Email" >> $file_path
    printf "+----------------------------+----------------------------+-----------------------------------+\n" >> $file_path
    echo "Adding Data"
    echo -en "${green}opening preview loading${reset} "
    loader
    while IFS= read -r line; do
      echo "$line"
    done < "$file_path"
    echo -e "\n\n **** Press any key to return home **** \n\n"
    read -n 1
    clear
    ./main.sh
  elif [ -e "$file_path" ]; then
    echo "Adding Data"
    printf "| %-26s | %-26s | %-33s |\n" "$new_id" "$age" "$email" >> $file_path
    printf "+----------------------------+----------------------------+-----------------------------------+\n" >> $file_path
    echo -en "${green}opening preview loading${reset} "
    loader
    while IFS= read -r line; do
      echo "$line"
    done < "$file_path"
    echo -e "\n\n **** Press any key to return home **** \n\n"
    read -n 1
    clear
    ./main.sh
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
      while IFS= read -r line; do
        echo "$line"
      done < "$file_path"
    else
      echo -e "${red}No Student Found. Try Adding New Students.${reset}"
    fi
  else
    echo -e "${red}File Not Found.${reset}"
  fi
  echo -e "\n\n **** Press any key to return home **** \n\n" 
  read -n 1 
  clear
  ./main.sh
}

#----------------------------function To Update Student----------------------
function update_student {
  if [ -f "$file_path" ] && [ -s "$file_path" ]; then
  
    local email_regex="^[a-zA-Z0-9._%+-]+@alustudent.com$"
    local id_entered="^ALU[0-9]{8}$"
    
    # Display the current content of the file
    while IFS= read -r line; do
      echo "$line"
    done < "$file_path"

    while true; do
      # Enter the student id to edit
      read -p "Enter The Student Id To Edit: " id
      if [[ $id =~ $id_entered ]] && grep -q -E "^\|[[:space:]]*$id[[:space:]]*\|" "$file_path"; then
        break
      elif ! [[ $id =~ $id_entered ]]; then
        echo -e "\n\n${orange}**************** Invalid ID ****************${reset}\n\n"
      elif ! grep -q -E "^\|[[:space:]]*$id[[:space:]]*\|" "$file_path"; then
        echo -e "\n\n${orange}**************** Student ID not found ****************${reset}\n\n"
      fi
    done

    if [[ $id =~ $id_entered ]] && grep -q -E "^\|[[:space:]]*$id[[:space:]]*\|" "$file_path"; then
      student_info=$(grep -E "^\|[[:space:]]*$id[[:space:]]*\|" "$file_path")
      
      if [[ -n $student_info ]]; then
        echo -e "\nYou Are Editing this User\n"
        echo "$student_info"
        original_line="$student_info"
      fi  
    fi

    # Ask the user if they want to edit the age
    read -p "Do you want to edit the age? (y/n): " edit_age
    if [[ $edit_age == "y" ]]; then
      while true; do
        read -p "Enter New Age: " age
        if ! [[ $age =~ ^[0-9]+$ ]]; then
          echo -e "\n\n${orange}**************** Invalid Age ****************${reset}\n\n"
        else
          break
        fi
      done
    else
      age=$(echo $original_line | awk -F'|' '{print $3}' | xargs)
    fi

    # Ask the user if they want to edit the email
    read -p "Do you want to edit the email? (y/n): " edit_email
    if [[ $edit_email == "y" ]]; then
      while true; do
        read -p "Enter New Email: " email
        if ! [[ $email =~ $email_regex ]]; then
          echo -e "\n\n${orange}**************** Invalid email ****************${reset}\n\n"
        elif grep -q -E "\|\s*$email\s*\|" "$file_path"; then
          echo -e "\n\n${orange}**************** This Email Already Exists ****************${reset}\n\n"
        else
          break
        fi
      done
    else
      email=$(echo $original_line | awk -F'|' '{print $4}' | xargs)
    fi

    # Ask the user if they want to edit the ID
    read -p "Do you want to edit the ID? (y/n): " edit_id
    if [[ $edit_id == "y" ]]; then
      while true; do
        read -p "Enter New Student Id: " id2
        if [[ $id2 =~ ^[0-9]{1,4}$ ]]; then
          local id_regex="^ALU[0-9]{8}$"
          current_year=$(date +%Y)
          # Zero-pad the ID to ensure it has exactly 4 digits
          id=$(printf "%04d" $id2)
          # Generate the new ID with the current year and the zero-padded ID
          new_id="ALU${current_year}${id}"
        
          if grep -q -E "^\|[[:space:]]*$new_id[[:space:]]*\|" "$file_path" ; then
            echo -e "\n\n${orange}**************** ID Already Exists ****************${reset}\n\n"
          else
            break
          fi
        fi # This 'fi' closes the inner if statement
      done
    else
      new_id=$id
    fi

    # Delete the original line and write the updated information
    temp_file=$(mktemp)
    while IFS= read -r line; do
      if echo "$line" | grep -q -E "^\|[[:space:]]*$id[[:space:]]*\|"; then
        # Use new_id instead of id if the ID was edited
        printf "| %-26s | %-26s | %-33s |\n" "$new_id" "$age" "$email" >> "$temp_file"
      else
        echo "$line" >> "$temp_file"
      fi
    done < "$file_path"

    # Move the temporary file to replace the original file
    if mv "$temp_file" "$file_path"; then
      echo "Student information updated successfully."
    else
      echo -e "\n\n${red}Failed to update student information.${reset}\n"
    fi
  else
    echo -e "\n\n${red}The file does not exist or is empty.${reset}\n"
  fi
  echo -e "\n\n **** Press any key to return home **** \n\n"
  read -n 1
  clear
  ./main.sh
}

#---------------------------------------function to Delete student------------------
function delete_student {
    # Check if file Exists To Avoid Errors
    if [ -f "$file_path" ]; then
        # Display the current content of the file
        while IFS= read -r line; do
          echo "$line"
        done < "$file_path"
        # standard ID
        local id_standard="^ALU[0-9]{8}$"
        while [[ ! $id =~ $id_standard ]] && ! grep -q -E "^\|[[:space:]]*ALU[0-9]{4}[[:space:]]*\|" "$file_path" ; do
            read -p "Enter The Student Id To Delete: " id
            echo -e "\n\n${orange}**************** Invalid ID Standard / Not Found****************${reset}\n\n"
        done
        # Use Grep To Search Student Id that matches the pattern
        grep -E -n "^\|[[:space:]]*$id[[:space:]]*\|" "$file_path" | while read -r line; do
            # Lines matches including numbers and split them (with line numbers)
            line_num=$(echo "$line" | cut -d ':' -f 1)
            # Delete the line that matched the search and the next line
            sed -i "${line_num}d;$(($line_num+1))d" "$file_path"
        done
        echo -e "${green}Deleted row with Student ID: $id${reset}"
        sleep 1
        echo -e "\n\n **** Preparing Your Preview **** \n\n"
        loader
        # End of loading 
        clear
        view_student
    else
         echo -e "${red}Error: File not found : $file_path${reset}"
         echo -e "\n\n **** Press any key to return home **** \n\n"
        read -n 1
        clear
        ./main.sh
    fi
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

#------------------------function to backup data
function back_up {
    read -p "Are you sure you want to backup your data? (Y or N) If you backup this data, everything will be backed up and you won't be able to run this program unless you go to the online server or backup directory: " opt

    if [ "$opt" == 'Y' ] || [ "$opt" == 'y' ]; then
        echo -en "Opening Backup"
        loader
        ./move-to-directory.sh
    else
        echo "$opt"
        echo -e "\n\n **** Press any key to return home **** \n\n"
        read -n 1
        clear
        ./main.sh
    fi
}

#------------------------function to exit program---------------
function exit_main {
    # Send message for closing app
    echo -en "${green}\n\n\nClosing App. Please wait for a few seconds to finish...\n\n\n${reset}"
    sleep 0.6
    clear
    # Kill the main process
    pkill -f './main.sh'
}

# App menu
echo -e "\n\n******************************************************************"
print_orange "*****************ALU Student Management System ******************"
echo -e "*******************************************************************\n"


echo "╔═══════════════════════════════════════════════════╗"
echo "║                  Main Menu                        ║"
echo "╠═══════════════════════════════════════════════════╣"
echo "║    1. Add New Student                             ║"
echo "║    2. View All Students                           ║"
echo "║    3. Update Student                              ║"
echo "║    4. Delete Student                              ║"
echo "║    5. Save Student Emails Sorted in ASC           ║"
echo "║    6. View All Emails Only in ASC Order           ║"
echo "║    7. Backup your data                            ║"
echo "║    8. Exit                                        ║"
echo "╚═══════════════════════════════════════════════════╝"

echo -e "\nEnter your choice (1-8): "

# Allow the user to input their choice with read function
echo -e "\n"
read -p "Enter Your choice Here: " choice
echo -e "\n"

# Switch case to call functions according to user need
case $choice in
    1)
        register
        ;;
    2)
        view_student
        ;;
    3)
        update_student
        ;;
    4)
    
        delete_student
        ;;
    5)
        email_save
        ;;
    6)
        view_email
        ;;
    7)
        back_up
        ;;
    8)
        exit_main
        ;;
    *)
        echo -e "${red}Invalid choice. Please try again.${reset}"
        echo -e "\n\n **** Press any key to return home **** \n\n"
        read -n 1
        clear
        ./main.sh
        ;;
esac

