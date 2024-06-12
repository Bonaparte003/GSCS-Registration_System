#!/usr/bin/env bash

# Load environment variables from .env file
source .env

# Function for displaying loading progress
function loader {
    for i in {1..10}; do
        echo -n "."
        sleep 0.1
    done
    echo -e "100%\n"
}

# Function to check if a command is available, and install it if not
function check_and_install {
    if ! command -v $1 &> /dev/null; then
        echo "$1 could not be found. Attempting to install $1..."
        if [ -x "$(command -v apt-get)" ]; then
            sudo apt-get update
            sudo apt-get install -y $1
        elif [ -x "$(command -v yum)" ]; then
            sudo yum install -y $1
        else
            echo "Package manager not found. Please install $1 manually."
            exit 1
        fi
    fi
}

# Check if rsync and sshpass are installed, and install them if they are not
check_and_install rsync
check_and_install sshpass

# Configuration for variables
source_directory="negpod_12-q1"
dest="summative/1023-2024j"

# Create the destination directory on the remote server if it doesn't exist
sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no "$USERNAME@$HOST" "mkdir -p /summative/1023-2024j"

# Use rsync to backup the directory to the alu-cod.online server
rsync -avz --delete -e "sshpass -p $PASSWORD ssh -o StrictHostKeyChecking=no" "$source_directory" "$USERNAME@$HOST:$dest"

echo -n "Backup completed. Ending Program ."
loader
echo -e "\n\n **************************** Thank You!!*****************************"
