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


