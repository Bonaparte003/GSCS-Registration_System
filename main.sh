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

