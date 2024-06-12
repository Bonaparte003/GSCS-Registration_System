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
