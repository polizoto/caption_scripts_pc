#!/bin/bash
# Joseph Polizzotto
# Wake Technical Community College
# 919-866-7977

find . -type f -name "~*.sbv" -exec rm -f {} \;


if [ ! -n "$(find . -maxdepth 1 -name '*.sbv' -type f -print -quit)" ]; then

echo -e "\033[1;31m\nSBV files are not located in this directory. Exiting...\033[0m"

exit

fi

if [ ! -f  "/c/scripts/sentence-boundary-original.pl" ]; then 

echo -e "\n\033[1;31mCould not locate \033[1;35msentence-boundary-original.pl.\033[0m\033[1;31m Place \033[1;35msentence-boundary-original.pl\033[0m\033[1;31m in \033[0m\033[1;44mC:\scripts\ \033[0m\033[1;31mfolder and run the script again. Exiting....\033[0m\n" >&2

exit

fi

echo -ne "\nConverting SBV to TXT...\r"

for x in ./*.sbv; do

new="${x%.*}"

cp "$x" "$new".txt

# remove caption numbers
                
# sed -i 's/^[0-9]\+$//g' "$new".txt

# remove time stamps

sed -i 's/^[0-9]:[0-9].*$//g' "$new".txt

# remove empty lines

sed -i '/^$/d' "$new".txt

# remove new lines

sed -i ':a;N;$!ba;s/\n/ /g' "$new".txt

# Remove double words

sed -i -e 's/\b\([a-z]\+\)[ ,\n]\1/\1/g' "$new".txt

# Place sentences on their own lines

perl '/c/scripts/sentence-boundary-original.pl' -d /c/scripts/HONORIFICS -i "$new".txt -o "$new"2.txt

mv "$new"2.txt "$new".txt 

# Remove two or more consecutive spaces

sed -i 's/ \+/ /g' "$new".txt

sed -i 's/[[:space:]][[:space:]]/ /g' "$new".txt

# Find and replace for common mistakes

sed -i -e 's/wake tech/Wake Tech/g' "$new".txt

sed -i -e 's/softchalk/SoftChalk/g' "$new".txt

sed -i -e 's/blackboard/Blackboard/g' "$new".txt

# Capitalize words that come before menu, button, toolbar, folder, window, pane etc.

sed -i -e 's/\b\(\w*\)\( [Mm]enu\)\b/\u\1\2/g' "$new".txt

sed -i -e 's/\b\(\w*\)\( [Bb]utton\)\b/\u\1\2/g' "$new".txt

sed -i -e 's/\([Tt]he \)\(\w*\)\( toolbar\)\b/\1\u\2 toolbar/g' "$new".txt

sed -i -e 's/\([Tt]he \)\(\w*\)\( folder\)\b/\1\u\2 folder/g' "$new".txt

sed -i -e 's/\([Tt]he \)\(\w*\)\( window\)\b/\1\u\2 window/g' "$new".txt

sed -i -e 's/\([Tt]he \)\(\w*\)\( pane\)\b/\1\u\2 pane/g' "$new".txt

# Clean up punctuation errors

# remove space before a period

sed -i 's/ \././g' "$new".txt

# add a new line when a sentence having a `."` is not split

sed -zi 's/\.”\s/.”\n\n/g' "$new".txt

# Add Transcript text to the top of the TXT file, with a blank line before transcript

awk -i inplace -v ORS='\r\n' 'FNR==1{print FILENAME " Transcript:"}1' "$new".txt 

sed -i '1 s/^.*\///' "$new".txt

sed -i '1 s/\.txt/ -/' "$new".txt

# Add a new line after the title of the transcript
# sed -i '1 s/^.*$/&\n/g' "$new".txt

# Place blank lines in between sentences

sed -zi 's/\n/\n\n/g' "$new".txt

# Remove files

rm "$x"

done

echo -e "Converting SBV to TXT... \033[1;32mDone\033[0m.\r"
