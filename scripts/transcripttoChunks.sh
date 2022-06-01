#!/bin/bash
# Joseph Polizzotto
# Wake Technical Community College
# 919-866-7977
# version 0.0.2

###### PC SCRIPT #######

function version (){
    printf "\nVersion 0.0.2\n"

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

if [ -x "$(command -v perl)" ]; then

printf "%-15s \e[1;32m%s\e[m\n" "Perl" "OK"

else

printf "%-15s \e[1;31m%s\e[m\n" "Perl" "Not Found"

fi

if [ -x "$(command -v fold)" ]; then

printf "%-15s \e[1;32m%s\e[m\n" "Fold" "OK"

else

printf "%-15s \e[1;31m%s\e[m\n" "Fold" "Not Found"

fi

exit 1

fi

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

# Fix lines that have only one word

sed -zi 's/\(\n\n\)\([A-Za-z]*\b\.\)/\2/g' "$x"

# Repair lines that have parentheses followed by single word

sed -zi 's/\()\)\([A-Za-z]*\b\.\)\(\n\n\)/\1\n\n\2\n\n/g' "$x"

sed -zi 's/\()\)\([A-Za-z]*\b\. \)\(\n\n\)/\1\n\n\2\n\n/g' "$x"

# Fix problem with prepositions ending lines 

# (end of a caption chunk)

sed -zi 's/\( a\)\(\s\n\n\)/\2a /g' "$x"

sed -zi 's/\( an\)\(\s\n\n\)/\2an /g' "$x"

sed -zi 's/\( the\)\(\s\n\n\)/\2the /g' "$x"

sed -zi 's/\( The\)\(\s\n\n\)/\2The /g' "$x"

sed -zi 's/\( and\)\(\s\n\n\)/\2and /g' "$x"

sed -zi 's/\( and \)\(\s\n\n\)/\2and /g' "$x"

sed -zi 's/\( so\)\(\s\n\n\)/\2so /g' "$x"

sed -zi 's/\( but\)\(\s\n\n\)/\2but /g' "$x"

sed -zi 's/\( or\)\(\s\n\n\)/\2or /g' "$x"

sed -zi 's/\( for\)\(\s\n\n\)/\2for /g' "$x"

sed -zi 's/\( between\)\(\s\n\n\)/\2between /g' "$x"

sed -zi 's/\( of\)\(\s\n\n\)/\2of /g' "$x"

sed -zi 's/\( to\)\(\s\n\n\)/\2to /g' "$x"

sed -zi 's/\( at\)\(\s\n\n\)/\2at /g' "$x"

sed -zi 's/\( in\)\(\s\n\n\)/\2in /g' "$x"

sed -zi 's/\( into\)\(\s\n\n\)/\2into /g' "$x"

sed -zi 's/\( on\)\(\s\n\n\)/\2on /g' "$x"

# (in the middle of a caption chunk)

sed -zi 's/\( a\)\(\s\n\)\([A-Za-z]\)/\2a \3/g' "$x"

sed -zi 's/\( an\)\(\s\n\)\([A-Za-z]\)/\2an \3/g' "$x"

sed -zi 's/\( the\)\(\s\n\)\([A-Za-z]\)/\2the \3/g' "$x"

sed -zi 's/\( The\)\(\s\n\)\([A-Za-z]\)/\2The \3/g' "$x"

sed -zi 's/\( and\)\(\s\n\)\([A-Za-z]\)/\2and \3/g' "$x"

sed -zi 's/\( and \)\(\s\n\)\([A-Za-z]\)/\2and \3/g' "$x"

sed -zi 's/\( but\)\(\s\n\)\([A-Za-z]\)/\2but \3/g' "$x"

sed -zi 's/\( so\)\(\s\n\)\([A-Za-z]\)/\2so \3/g' "$x"

sed -zi 's/\( to\)\(\s\n\)\([A-Za-z]\)/\2to \3/g' "$x"

sed -zi 's/\( at\)\(\s\n\)\([A-Za-z]\)/\2at \3/g' "$x"

sed -zi 's/\( in\)\(\s\n\)\([A-Za-z]\)/\2in \3/g' "$x"

sed -zi 's/\( into\)\(\s\n\)\([A-Za-z]\)/\2into \3/g' "$x"

sed -zi 's/\( on\)\(\s\n\)\([A-Za-z]\)/\2on \3/g' "$x"

sed -zi 's/\( or\)\(\s\n\)\([A-Za-z]\)/\2or \3/g' "$x"

sed -zi 's/\( for\)\(\s\n\)\([A-Za-z]\)/\2for \3/g' "$x"

sed -zi 's/\( of\)\(\s\n\)\([A-Za-z]\)/\2of \3/g' "$x"

sed -zi 's/\( between\)\(\s\n\)\([A-Za-z]\)/\2between \3/g' "$x"

# Remove files

rm "$new"_2.txt

done

echo -e "Converting transcript to caption chunks... \033[1;32mDone\033[0m.\r"

