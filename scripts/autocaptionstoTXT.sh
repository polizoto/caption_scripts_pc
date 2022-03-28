#!/bin/bash
# Joseph Polizzotto
# Wake Technical Community College
# 919-866-7977
# version 0.0.2

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

echo -ne "\nConverting YouTube auto-captions to TXT...\r"

youtube-dl --skip-download --write-sub --write-auto-sub $1 >/dev/null 2>&1

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

for f in ./*.vtt; do

    new=$(printf "%s\n" "$f" | sed 's/\(.*\)-[^-]*.\en\(\.[^-]*\)/\1\2/')

	mv "$f" "$new"

done

for x in ./*.vtt; do

new="${x%.*}"

cp "$x" "$new".txt

# remove WEBVTT markup

# Remove <c> tags that may appear in some webVTT files

if grep -qi "<c>" "$new".txt > /dev/null ; then perl -0777 -i -pe 's/<.*?>//gs' "$new".txt ;  fi

#

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

# Punctuate text

read -r CONTENTS < "$new".txt

# feed text into punctuator

curl -sS -d "text=$CONTENTS" http://bark.phon.ioc.ee/punctuator > "$new".txt

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

# capitalize chapter and word that comes after

sed -i -e 's/\( chapter \)\(\w*\)/ Chapter \u\2/g' "$new".txt

# capitalize week

sed -i -e 's/\( week \)\([[:digit:]]\)/ Week \2/g' "$new".txt

# capitalize section

sed -i -e 's/\( section \)\([[:digit:]]\)/ Section \2/g' "$new".txt

# capitalize module

sed -i -e 's/\( module \)\([[:digit:]]\)/ Module \2/g' "$new".txt

# Clean up punctuation errors

sed -i -e "s/'Ve/'ve/g" "$new".txt

sed -i -e "s/'Re/'re/g" "$new".txt

sed -i -e "s/'S/'s/g" "$new".txt

sed -i -e "s/'T/'t/g" "$new".txt

sed -i -e "s/'Ll/'ll/g" "$new".txt

sed -i -e "s/i've/I've/g" "$new".txt

sed -i -e 's/ i / I /g' "$new".txt

sed -i -e "s/ gon na / gonna /g" "$new".txt

# remove space before a period

sed -i 's/ \././g' "$new".txt

# add a new line when a sentence having a `."` is not split

sed -zi 's/\.”\s/.”\n\n/g' "$new".txt

# Delete commas between brackets

sed -i 's/\[,/\[/g' "$new".txt

sed -i 's/],/]/g' "$new".txt

# Place blank lines in between sentences

sed -zi 's/\n/\n\n/g' "$new".txt

# Place parentheses groups that start a line (speaker, music cues) on their own lines
sed -zi 's/\((\S[^)]*) \)/\1\n/g' "$new".txt

# add new line characters after parentheses groups
sed -i 's/.*\(([^()]*)\).*/\1\n/g' "$new".txt

# Place bracket groups that start a line (speaker, music cues) on their own lines
sed -zi 's/\([(\S[^)]*] \)/\1\n/g' "$new".txt

# add new bracket characters after parentheses groups
sed -i 's/.*\(\[[^[]*]\).*/\1\n/g' "$new".txt

# Delete commas that appear within parentheses

sed -E -i ':a; s/(\[[^],]*), */\1 /; ta; s/\[([^]]*)\]/(\1)/g' "$new".txt

# remove dash that appears at the beginning of a new line

perl -0777 -pi -e 's/\n- /\n/g' "$new".txt

# Capitalize words that start a new line and are lower-case

sed -i 's/^\([a-z]\)/\u\1/g' "$new".txt

# Remove files

rm "$x"

done

echo -e "Converting YouTube auto-captions to TXT... \033[1;32mDone\033[0m.\r"

