#!/usr/bin/env bash

# Function for program loader------------------------
function loader {
    for i in {1..10}; do
        echo -n "."
        sleep 0.1
    done
    echo -e "100%\n"
}

