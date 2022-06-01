#!/bin/bash
# Joseph Polizzotto
# Wake Technical Community College
# 919-866-7977
# version 0.0.4

###### PC SCRIPT #######

function version (){
    printf "\nVersion 0.0.4\n"

return 0
}

function usage (){
    printf "\nUsage: $(baseName "$0") [options [parameters]]\n"
    printf "\n"
    printf "Options:\n"
	printf " -d, Diagnostics.\n"	
    printf " -h, Print help\n"
    printf " -v, Print script version\n"

return 0
}

while getopts dhv flag

do
    case "${flag}" in
		: ) echo -e "\nOption -"$OPTARG" requires an argument." >&2
            exit 1;;
		d) diagnostics="${flag}";;
        v) version; exit 2;;
        h) usage; exit 2;;
        \?) echo -e "\n\e[1;31mInvalid option\e[m";usage; exit 2;;
    esac

  done
  
if [ -n "$diagnostics" ]; then

if [ -x "$(command -v sed)" ]; then

printf "\n%-15s \e[1;32m%s\e[m\n" "Sed" "OK"

else

printf "%-15s \e[1;31m%s\e[m\n" "Sed" "Not Found"

fi

if [ -x "$(command -v mv)" ]; then

printf "%-15s \e[1;32m%s\e[m\n" "Mv" "OK"

else

printf "%-15s \e[1;31m%s\e[m\n" "Mv" "Not Found"

fi

if [ -x "$(command -v mv)" ]; then

printf "%-15s \e[1;32m%s\e[m\n" "Find" "OK"

else

printf "%-15s \e[1;31m%s\e[m\n" "Find" "Not Found"

fi

if [ -x "$(command -v youtube-dl)" ]; then

printf "%-15s \e[1;32m%s\e[m\n" "youtube-dl" "OK"

else

printf "%-15s \e[1;31m%s\e[m\n" "youtube-dl" "Not Found"

fi

if [ -f  "/c/scripts/sentence-boundary-original.pl" ]; then 

printf "%-15s \e[1;32m%s\e[m\n" "perlscript" "OK"

else

printf "%-15s \e[1;31m%s\e[m\n" "perlscript" "Not Found"

fi

exit 1

fi

red='\e[1;31m%s: %s\n\e[0m\n'
green='\e[1;32m%s: %s\n\e[0m\n'
yellow='\e[1;33m%s: %s\n\e[0m\n'

if ! [ -x "$(command -v youtube-dl)" ]; then

echo -e "\n\033[1;31mError: youtube-dl (http://ytdl-org.github.io/youtube-dl/download.html)is not installed. Exiting...\033[0m" >&2

exit 1

fi

if [ $# -eq 0 ]; then
 
echo -e "\n\033[1;31mEnter the URL for the video or playlist. Exiting...\033[0m" >&2

exit 1

fi

if [ ! -f  "/c/scripts/sentence-boundary-original.pl" ]; then 

echo -e "\n\033[1;31mCould not locate \033[1;35msentence-boundary-original.pl.\033[0m\033[1;31m Place \033[1;35msentence-boundary-original.pl\033[0m\033[1;31m in \033[0m\033[1;44mC:\scripts\ \033[0m\033[1;31mfolder and run the script again. Exiting....\033[0m" >&2

exit

fi

# Check if there are captions with this video

youtube-dl --skip-download --list-subs $1 > ./check_subtitles.txt 2>&1

if grep -q 'no subtitles' ./check_subtitles.txt ; then

if ! grep -q 'Available' ./check_subtitles.txt ; then
    
echo -e "\n\033[1;31mThere are no captions for one of the videos at this URL. Exiting....\033[0m" >&2

rm ./check_subtitles.txt

exit

fi

fi

if 	grep -q 'Video unavailable' ./check_subtitles.txt ; then
    
echo -e "\n\033[1;31mInvalid URL. Check the URL and try again. Exiting....\033[0m" >&2

rm ./check_subtitles.txt

exit

else

rm ./check_subtitles.txt

fi

#

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

for f in ./*.vtt; do

new="${f%.*}"

cp "$f" "$new".txt

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

# Remove uh and um

sed -i -e 's/ um/ /g' "$new".txt

sed -i -e 's/ uh/ /g' "$new".txt

sed -i -e 's/Uh / /g' "$new".txt

sed -i -e 's/Um / /g' "$new".txt

# Remove double words

sed -i -e 's/\b\([a-z]\+\)[ ,\n]\1/\1/g' "$new".txt

sed -i -e 's/\b\([a-z]\+\)[ ,\n]\1/\1/g' "$new".txt

# Remove Double Spaces

sed -i 's/ \+/ /g' ./"$new".txt

character_count="$(wc -c ./"$new".txt | sed -r  's/^[^0-9]*([0-9]+).*/\1/')"

if (( $character_count > 7999 )); 

then

# insert <split> tag at the 7999 character mark

sed -r -i 's/(.{7999})/\1<split>/g;s/<split>$//' ./"$new".txt

# Move the <split> tag onto its own line when it comes before a space

sed -i 's/\(<split>\)\( \)/\n\1\n/g' ./"$new".txt

# Move the <split> so that it is not in the middle of a word and so that the <split> tag is on its own line

sed -i  's/\(<split>\)\([A-Za-z]\+\)\(\b\)/\2\n\1\n/g' ./"$new".txt

# Append a marker at the top of the TXT file

sed -i '1s/^/\n<split>\n/' ./"$new".txt

# Split the file by the <split> marker

csplit -k -s -n 2 -b '%d.txt' -f "$new" <(echo "ENDMDL dummy, delete this file"; cat ./"$new".txt) '/^<split>/+1' '{*}' && rm ./"$new"0.txt

# remove Split tag from text file

perl -0777 -pi -e 's/<split>\n//g' ./"$new"[1-9]*.txt

# remove new lines from files when these are before a character

sed -zi 's/\(\n\)\([A-Za-z]\)/ \2/g' ./"$new"[1-9]*.txt

# Remove remaining new lines (those that already have a space after them)

sed -zi 's/\n//g' ./"$new"[1-9]*.txt

# Delete contents of original file

sed -i '/^/d' ./"$new".txt

count=1
for x in ./"$new"[1-9]*.txt; do

# Punctuate text

read -r CONTENTS < ./"$new"$count.txt

# Add a new line and test text

sed -i '$a\' ./"$new".txt

# feed text into punctuator

curl -sS -d "text=$CONTENTS" http://bark.phon.ioc.ee/punctuator >> ./"$new".txt

# Rejoin separated pages and make the next character lower case

sed -zi 's/\(\n\)\([A-Z]\)/\L\2/g' ./"$new".txt

rm ./"$new"$count.txt
	
count=$[ $count + 1 ] ; 

done

else

# Punctuate text

read -r CONTENTS < "$new".txt

# feed text into punctuator

curl -sS -d "text=$CONTENTS" http://bark.phon.ioc.ee/punctuator > "$new".txt

fi

# Remove double words (if didn't catch all of them!)

sed -i -e 's/\b\([a-z]\+\)[ ,\n]\1/\1/g' "$new".txt

sed -i -e 's/the the/the /g' "$new".txt

sed -i -e 's/the this/ this/g' "$new".txt

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

sed -i -e 's/microsoft word/Microsoft Word/g' "$new".txt

sed -i -e 's/microsoft/Microsoft/g' "$new".txt

sed -i -e 's/global accessibility awareness day/Global Accessibility Awareness Day/g' "$new".txt

sed -i -e 's/office math/Office Math/g' "$new".txt

sed -i -e 's/joseph/Joseph/g' "$new".txt

sed -i -e 's/polizzotto/Polizzotto/g' "$new".txt

sed -i -e 's/natasha/Natosha/g' "$new".txt

sed -i -e 's/burgess rodriguez/Burgess Rodriguez/g' "$new".txt

sed -i -e 's/word document/Word document/g' "$new".txt

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

sed -i -e "s/I'M/I'm/g" "$new".txt

sed -i -e "s/i'm/I'm/g" "$new".txt

sed -i -e "s/i'll/I'll/g" "$new".txt

sed -i -e "s/i've/I've/g" "$new".txt

sed -i -e "s/let'say/let's say/g" "$new".txt

sed -i -e "s/ that'sort/ that sort/g" "$new".txt

sed -i -e "s/it'something/it's something/g" "$new".txt

sed -i -e "s/they'regularly/they're regularly/g" "$new".txt

sed -i -e "s/that'something/that's something/g" "$new".txt

sed -i -e "s/you'referring/you're referring/g" "$new".txt

# Capitalize common proper nouns

sed -i -e "s/spanish/Spanish/g" "$new".txt

sed -i -e "s/italian/Italian/g" "$new".txt

sed -i -e "s/english/English/g" "$new".txt

sed -i -e "s/christian/Christian/g" "$new".txt

sed -i -e "s/epub/EPUB/g" "$new".txt

sed -i -e "s/html/HTML/g" "$new".txt

sed -i -e "s/isbn/ISBN/g" "$new".txt

sed -i -e "s/mathml/MathML/g" "$new".txt

sed -i -e "s/mathjax/MathJax/g" "$new".txt

sed -i -e "s/vitalsource/VitalSource/g" "$new".txt

sed -i -e "s/linux/Linux/g" "$new".txt

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

rm "$f"

done

echo -e "Converting YouTube auto-captions to TXT... \033[1;32mDone\033[0m.\r"

if [ -n "$(find . -maxdepth 1 -name '*.txt' -type f -print -quit)" ]; then

for file in ./*.txt; do

	# Remove special characters from filenames:( _&,()%#$¢{}[];@) 
	
	mv "$file" "$(echo "$file" | sed 's/[][ _&,\(\)%#\$¢{};\@]//g')"
	
done

fi

echo -e "\nFilename Length:\n"

depth=2

find . -maxdepth $depth -type f -print0 | sed 's|\./||g' | \
    
while IFS= read -r -d '' file; do \
      
f=$(basename "$file"); 

if [ "${#f}" -gt 31 ] ; then

printf "$red" "$file" "${#f}"

elif [ "${#f}" -gt 24 ] ; then

printf "$yellow" "$file" "${#f}"

else 

printf "$green" "$file" "${#f}"

fi

done | column -s : -t 

