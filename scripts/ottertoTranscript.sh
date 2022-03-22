#!/bin/bash
# Joseph Polizzotto
# Wake Technical Community College
# 919-866-7977

find . -type f -name "~*.txt" -exec rm -f {} \;


if [ ! -n "$(find . -maxdepth 1 -name '*.txt' -type f -print -quit)" ]; then

echo -e "\033[1;31m\nTXT files are not located in this directory. Exiting...\033[0m"

exit

fi

if [ ! -f  "/c/scripts/sentence-boundary-original.pl" ]; then 

echo -e "\n\033[1;31mCould not locate \033[1;35msentence-boundary-original.pl.\033[0m\033[1;31m Place \033[1;35msentence-boundary-original.pl\033[0m\033[1;31m in \033[0m\033[1;44mC:\scripts\ \033[0m\033[1;31mfolder and run the script again. Exiting....\033[0m\n" >&2

exit

fi

echo -ne "\nCleaning up transcripts...\r"

for x in ./*.txt; do

new="${x%.*}"

cp "$x" "$new"_edited.txt

# Remove Otter text

sed -i 's/Transcribed\ by\ https:\/\/otter\.ai//g' "$new"_edited.txt

# remove empty lines

sed -i '/^$/d' "$new"_edited.txt

# remove new lines

sed -i ':a;N;$!ba;s/\n/ /g' "$new"_edited.txt

# Remove double words

sed -i -e 's/\b\([a-z]\+\)[ ,\n]\1/\1/g' "$new"_edited.txt

# Place sentences on their own lines

perl '/c/scripts/sentence-boundary-original.pl' -d /c/scripts/HONORIFICS -i "$new"_edited.txt -o "$new"_edited_2.txt

mv "$new"_edited_2.txt "$new"_edited.txt 

# Remove two or more consecutive spaces

sed -i 's/ \+/ /g' "$new"_edited.txt 

sed -i 's/[[:space:]][[:space:]]/ /g' "$new"_edited.txt 

# Find and replace for common mistakes

sed -i -e 's/wake tech/Wake Tech/g' "$new"_edited.txt 

sed -i -e 's/softchalk/SoftChalk/g' "$new"_edited.txt 

sed -i -e 's/blackboard/Blackboard/g' "$new"_edited.txt 

# Capitalize words that come before menu, button, toolbar, folder, window, pane etc.

sed -i -e 's/\b\(\w*\)\( [Mm]enu\)\b/\u\1\2/g' "$new"_edited.txt 

sed -i -e 's/\b\(\w*\)\( [Bb]utton\)\b/\u\1\2/g' "$new"_edited.txt 

sed -i -e 's/\([Tt]he \)\(\w*\)\( toolbar\)\b/\1\u\2 toolbar/g' "$new"_edited.txt 

sed -i -e 's/\([Tt]he \)\(\w*\)\( folder\)\b/\1\u\2 folder/g' "$new"_edited.txt 

sed -i -e 's/\([Tt]he \)\(\w*\)\( window\)\b/\1\u\2 window/g' "$new"_edited.txt 

sed -i -e 's/\([Tt]he \)\(\w*\)\( pane\)\b/\1\u\2 pane/g' "$new"_edited.txt 

# Clean up punctuation errors

# remove space before a period

sed -i 's/ \././g' "$new"_edited.txt 

# add a new line when a sentence having a `."` is not split

sed -zi 's/\.”\s/.”\n\n/g' "$new"_edited.txt 

# Add Transcript text to the top of the TXT file, with a blank line before transcript

awk -i inplace -v ORS='\r\n' 'FNR==1{print FILENAME " Transcript:"}1' "$new"_edited.txt 

sed -i '1 s/^.*\///' "$new"_edited.txt 

sed -i '1 s/\.txt/ -/' "$new"_edited.txt 

sed -i '1 s/_edited//' "$new"_edited.txt 

# Place blank lines in between sentences

sed -zi 's/\n/\n\n/g' "$new"_edited.txt 

# Remove files

mv "$new"_edited.txt  "$x"

done

echo -e "Cleaning up transcripts... \033[1;32mDone\033[0m.\r"
