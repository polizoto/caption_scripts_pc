#!/bin/bash
# Joseph Polizzotto
# Wake Technical Community College
# 919-866-7977
# version 0.0.2

find . -type f -name "~*.txt" -exec rm -f {} \;

if [ ! -n "$(find . -maxdepth 1 -name '*.txt' -type f -print -quit)" ]; then

echo -e "\033[1;31m\nTXT files are not located in this directory. Exiting...\033[0m"

exit

fi

if ! [ -x "$(command -v pandoc)" ]; then

echo -e "\n\033[1;31mError: Pandoc (https://pandoc.org/installing.html)is not installed. Exiting...\033[0m" >&2

exit 1

fi

echo -ne "\nConverting TXT to HTML...\r"

for x in ./*.txt; do

        basePath=${x%.*}
        baseName=${basePath##*/}
        export baseName

new="${x%.*}"

cp "$x" "$new".md

sed -i '1 s/^/# /' "$new".md

pandoc -M document-css=false -H /c/stylesheets/standard.css -i "$new".md -f markdown -s -t html5 --metadata pagetitle="$baseName"\ -\ Transcript -o "$new".html

# Edit HTML
# Add missing value for lang attribute

sed -i 's/lang=""/lang="en"/g' "$new".html

# Remove files

rm "$new".md

done

echo -e "Converting TXT to HTML... \033[1;32mDone\033[0m.\r"
