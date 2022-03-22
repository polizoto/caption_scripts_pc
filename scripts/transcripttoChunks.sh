#!/bin/bash
# Joseph Polizzotto
# Wake Technical Community College
# 919-866-7977
# version 0.0.1

if [ ! -n "$(find . -maxdepth 1 -name '*.txt' -type f -print -quit)" ]; then

echo -e "\033[1;31m\nTXT files are not located in this directory. Exiting...\033[0m"

exit 

fi

echo -ne "\nConverting transcript to caption chunks...\r"

for x in ./*.txt; do

new="${x%.*}"

cp "$x" "$new"_2.txt

# remove Transcript title text on first line

sed -i '1 s/^.*- Transcript:$//g' "$new"_2.txt

# delete two empty lines at the top of a TXT file

sed -i '/./,$!d' "$new"_2.txt

# Wrap lines at 35 characters

fold -w 40 -s "$new"_2.txt > "$x"

# Insert new line for every two lines, preserving paragraphs

perl -00 -i -ple 's/.*\n.*\n/$&\n/mg' "$x"

# Remove files

rm "$new"_2.txt

done

echo -e "Converting transcript to caption chunks... \033[1;32mDone\033[0m.\r"

