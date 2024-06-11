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

