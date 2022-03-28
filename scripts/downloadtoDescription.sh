#!/bin/bash
# Joseph Polizzotto
# Wake Technical Community College
# 919-866-7977
# version 0.0.3

if ! [ -x "$(command -v youtube-dl)" ]; then

echo -e "\n\033[1;31mError: youtube-dl (http://ytdl-org.github.io/youtube-dl/download.html)is not installed. Exiting...\033[0m" >&2

exit 1

fi

if [ $# -eq 0 ]; then
 
echo -e "\n\033[1;31mEnter the URL for the video or playlist. Exiting...\033[0m" >&2

exit 1

fi

if [ ! -f  "/c/scripts/sentence-boundary-original.pl" ]; then 

echo -e "\n\033[1;31mCould not locate \033[1;35msentence-boundary-original.pl.\033[0m\033[1;31m Place \033[1;35msentence-boundary-original.pl\033[0m\033[1;31m in \033[0m\033[1;44mC:\scripts\ \033[0m\033[1;31mfolder and run the script again. Exiting....\033[0m\n" >&2

exit

fi

if ! [ -x "$(command -v pandoc)" ]; then

echo -e "\n\033[1;31mError: Pandoc (https://pandoc.org/installing.html)is not installed. Exiting...\033[0m" >&2

exit 1

fi

echo -ne "\nConverting YouTube Captions to description...\r"

youtube-dl --skip-download --write-sub $1 >/dev/null 2>&1

if [ -n "$(find . -maxdepth 1 -name '*.en-*.vtt' -type f -print -quit)" ]; then

for f in *.en-*.vtt; do 

mv -- "$f" "${f//\.en-*\./\.en\.}"; 

done

fi

# Find and delete random YT filename strings if there are TWO random strings before VTT

if [ -n "$(find . -maxdepth 1 -name '*-[0-9]*-*.vtt' -type f -print -quit)" ]; then

for f in ./*-[0-9]*-*.vtt; do

    new=$(printf "%s\n" "$f" | sed 's/\(.*\)-[^-]\w*-[^-]*.\en\(\.[^-]*\)/\1\2/')
	
mv "$f" "$new"	

done

fi

# Find and delete random YT filename strings

for f in ./*.vtt; do

    new=$(printf "%s\n" "$f" | sed 's/\(.*\)-[^-]*.\en\(\.[^-]*\)/\1\2/')

	mv "$f" "$new"

done

if [ -n "$(find . -maxdepth 1 -name '*-.vtt' -type f -print -quit)" ]; then

for f in *-.vtt; do 

mv -- "$f" "${f//-.vtt/.vtt}"; 

done

fi

for x in ./*.vtt; do

new="${x%.*}"

cp "$x" "$new".txt

# remove WEBVTT markup

sed -i 's/^WEBVTT$//g' "$new".txt

sed -i 's/^Kind:\ captions$//g' "$new".txt

sed -i 's/^Language:\ en-US$//g' "$new".txt

sed -i 's/^Language:\ en.*$//g' "$new".txt

sed -i 's/^[0-9][0-9]:.*$//g' "$new".txt

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

# Capitalize words that come before menu, button, toolbar, folder, window, pane etc. (but not `the` or `a`)

sed -i -e 's/\b\(\w*\)\( [Mm]enu\)\b/\u\1\2/g' "$new".txt

sed -i -e 's/\b\(The\)\( [Mm]enu\)\b/\l\1\2/g' "$new".txt

sed -i -e 's/\b\(A\)\( [Mm]enu\)\b/\l\1\2/g' "$new".txt

sed -i -e 's/\b\(\w*\)\( [Bb]utton\)\b/\u\1\2/g' "$new".txt

sed -i -e 's/\b\(The\)\( [Bb]utton\)\b/\l\1\2/g' "$new".txt

sed -i -e 's/\b\(A\)\( [Bb]utton\)\b/\l\1\2/g' "$new".txt

sed -i -e 's/\([Tt]he \)\(\w*\)\( toolbar\)\b/\1\u\2 toolbar/g' "$new".txt

sed -i -e 's/\([Tt]he \)\(\w*\)\( folder\)\b/\1\u\2 folder/g' "$new".txt

sed -i -e 's/\([Tt]he \)\(\w*\)\( window\)\b/\1\u\2 window/g' "$new".txt

sed -i -e 's/\([Tt]he \)\(\w*\)\( pane\)\b/\1\u\2 pane/g' "$new".txt

# Clean up punctuation errors

# remove space before a period

sed -i 's/ \././g' "$new".txt

# replace curly quotes with straight quotes

sed -i 's/”/"/g' "$new".txt

sed -i 's/“/"/g' "$new".txt

sed -i "s/’/'/g" "$new".txt

# add a new line when a sentence having a `."` is not split

sed -zi 's/\.”\s/.”\n\n/g' "$new".txt

# Add Transcript text to the top of the TXT file, with a blank line before transcript

awk -i inplace -v ORS='\r\n' 'FNR==1{print FILENAME " Transcript:"}1' "$new".txt 

sed -i '1 s/^.*\///' "$new".txt

sed -i '1 s/\.txt/ -/' "$new".txt

sed -i '1 s/-wDX//' "$new".txt

# Add a new line after the title of the transcript
# sed -i '1 s/^.*$/&\n/g' "$new".txt

# Place blank lines in between sentences

sed -zi 's/\n/\n\n/g' "$new".txt

# Place parentheses groups that start a line (speaker, music cues) on their own lines
sed -zi 's/\((\S[^)]*) \)/\1\n/g' "$new".txt

# add new line characters after parentheses groups
sed -i 's/.*\(([^()]*)\).*/\1\n/g' "$new".txt

# remove dash that appears at the beginning of a new line

perl -0777 -pi -e 's/\n- /\n/g' "$new".txt

# Remove hyphens that appear after end of sentence punctuation

sed -zi 's/\("\) - /\1\n\n/g' "$new".txt

sed -zi 's/\(\.\) - /\1\n\n/g' "$new".txt

sed -zi 's/\(\?\) - /\1\n\n/g' "$new".txt

# Remove files

rm "$x"

done

# Correct error in file names that have -wDX

if [ -n "$(find . -maxdepth 1 -name '*-wDX.txt' -type f -print -quit)" ]; then

for f in *-wDX.txt; do 

mv -- "$f" "${f//-wDX\.txt/\.txt}"; 

done

fi

# Create HTML files

for x in ./*.txt; do

        basePath=${x%.*}
        baseName=${basePath##*/}
        export baseName

new="${x%.*}"

cp "$x" "$new".md

sed -i '1 s/^/# /' "$new".md



pandoc "$new".md -f markdown -t docx -o "$new".docx

# Remove files

# rm "$new".md

done

echo -e "Converting YouTube Captions to description... \033[1;32mDone\033[0m.\r"

