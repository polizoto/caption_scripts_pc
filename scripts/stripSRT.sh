#!/bin/bash
# Joseph Polizzotto
# Wake Technical Community College
# 919-866-7977

find . -type f -name "~*.vtt" -exec rm -f {} \;

if [ ! -f  "C:\Python37-32\Scripts\aeneas_execute_task.py" ]; then 
echo -e "\n\033[1;31mError: Aeneas module not found. Make sure Aeneas is installed (https://github.com/sillsdev/aeneas-installer/releases) and is in your path. Exiting....\033[0m" >&2

exit

fi

if [ ! -n "$(find . -maxdepth 1 -name '*.vtt' -type f -print -quit)" ]; then

echo -e "\033[1;31m\nVTT files are not located in this directory. Exiting...\033[0m"

exit

fi

echo -ne "\nConverting VTT to TXT...\r"

for x in ./*.vtt; do

new="${x%.*}"

python -m aeneas.tools.convert_syncmap "$x" "$new".srt >/dev/null 2>&1

rm "$x"

done

for x in ./*.srt; do

new="${x%.*}"

cp "$x" "$new".txt

# remove caption numbers
                
sed -i 's/^[0-9]\+$//g' "$new".txt

# remove time stamps

sed -i 's/^[0-9][0-9]:[0-9].*$//g' "$new".txt

# remove empty double empty lines

sed -i '/^$/{N;/^\n$/d;}' "$new".txt

# Replace incorrect VTT tags

sed -i 's/\(<v \)\(.[^>]*\)\(>\)/(\2) /g' "$new".txt

sed -i 's/<\/v>//g' "$new".txt

# Remove double words

sed -i -e 's/\b\([a-z]\+\)[ ,\n]\1/\1/g' "$new".txt

# Remove two or more consecutive spaces

sed -i 's/ \+/ /g' "$new".txt

# Find and Replace common typos in project (edit for your needs)

sed -i -e 's/Microsoft teams/Microsoft Teams/g' "$new".txt

sed -i -e 's/wake tech/Wake Tech/g' "$new".txt

rm "$x"

done

echo -e "Converting VTT to TXT... \033[1;32mDone\033[0m.\r"
