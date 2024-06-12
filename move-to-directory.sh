#!/usr/bin/env bash

# Function for program loader------------------------
function loader {
    for i in {1..10}; do
        echo -n "."
        sleep 0.1
    done
    echo -e "100%\n"
}

# Check if the directory exists---------------------
folder="negpod_12-q1"

# File initialization---------------
s_email='select-emails.sh'
main='main.sh'
file_path='Students-list_1023.txt'
file_save='student-emails.txt'

# file exit

if [ -f "$s_email" ] && [ -f "$main" ] && [ -f "$file_path" ] && [ -f "$file_save" ]; then
    if [ -d "$folder" ]; then
        echo -n "Moving Files "
        loader
        mv -f "$main" "$s_email" "$file_save" "$file_path" "$folder"
        echo -n "Backing up data to alu-cod.online "
        loader
        ./backup-Negpod_12.sh
    else
        echo -n "Creating directory "
        loader
        mkdir "$folder"

        echo -n "Folder Created Successfully!! Moving Files "
        loader
        mv -f "$main" "$s_email" "$file_save" "$file_path" "$folder"
        echo -n "Backing up data to alu-cod.online "
        loader
        ./backup-Negpod_12.sh
    fi
else
    echo "Error: Your Files Don't Exist"
    echo -n "Ending Programming "
    loader
fi
