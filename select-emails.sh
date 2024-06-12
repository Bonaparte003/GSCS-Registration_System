#!/usr/bin/env bash


#save in given files--------------------------------------
file_path='Students-list_1023.txt'
file_save='student-emails.txt'

if [ -f "$file_path" ]; then
    # Extract email addresses from the file------------------
    new_email=$(awk -F '|' 'NR > 3 { gsub(/^[ \t]+|[ \t]+$/, "", $4); print $4 }' "$file_path")
    echo "$new_email" > "$file_save"

    # Display loading message----------------------
    echo -n "Opening Emails preview in ascending order"
    for i in {1..10}; do
        echo -n "."
        sleep 0.1
    done
    echo -e "100%\n"
    # End of loading

    # Sort the email list-----------------------------
    cat "$file_save" | sort > "$file_save.temp"
    mv "$file_save.temp" "$file_save"

    echo -e "\n\n\n"
    ./main.sh

    #file doesn't exit error message
else
    echo "Error: File doesn't exist"
fi
