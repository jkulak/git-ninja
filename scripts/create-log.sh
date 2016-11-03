#!/usr/bin/env bash

# This script:
# 1. creates given number of files with random names
# 2. writes 10 lines with random string to every file
# 3. Creates a commit for each file

commits=$1

if [ -z "$commits" ]; then
    echo "Missing argument: number of commits to create"
    exit 128
fi

if [[ "$commits" > 100 ]]; then
    echo "I'm not sure if you really want to do this, 100 is the current maximum"
    exit 1
fi

for (( i = 0; i < $commits; i++ )); do
    file=$(echo "$RANDOM" | md5)
    touch $file
    line=""

    for (( n = 0; n < 10; n++ )); do
        line=$(echo "$RANDOM+$n" | md5)$'\n\r'$line
    done
    echo $line >> $file
    git add $file
    git commit -m "Auto add $file"
done
