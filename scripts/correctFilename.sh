#!/bin/bash
# Joseph Polizzotto
# Wake Technical Community College
# 919-866-7977


###### PC SCRIPT #######

function version (){
    printf "\nVersion 0.0.1\n"

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

exit 1

fi

red='\e[1;31m%s: %s\n\e[0m\n'
green='\e[1;32m%s: %s\n\e[0m\n'
yellow='\e[1;33m%s: %s\n\e[0m\n'
COUNT=0

for i in ./*.docx ./*.pdf ./*.html ./*.txt ;do
  if [ -f "$i" ] ;then
    ((COUNT++))
  fi
  
done

if [ $COUNT -eq 0 ] ;then

	echo -e "\033[1;31m\nThere are no files located in this directory. Exiting...\033[0m"
	
	exit 1
	
	  else
  
	echo -ne "\nUpdating filenames...\r"

fi


if [ -n "$(find . -maxdepth 1 -name '*.html' -type f -print -quit)" ]; then

for file in ./*.html; do

	# Remove special characters from filenames:( _&,()%#$¢{}[];@) 
	
	mv "$file" "$(echo "$file" | sed 's/[][ _&,\(\)%#\$¢{};\@]//g')"
	
done

fi

if [ -n "$(find . -maxdepth 1 -name '*.pdf' -type f -print -quit)" ]; then

for file in ./*.pdf; do

	# Remove special characters from filenames:( _&,()%#$¢{}[];@) 
	
	mv "$file" "$(echo "$file" | sed 's/[][ _&,\(\)%#\$¢{};\@]//g')"
	
done

fi

if [ -n "$(find . -maxdepth 1 -name '*.docx' -type f -print -quit)" ]; then

for file in ./*.docx; do

	# Remove special characters from filenames:( _&,()%#$¢{}[];@) 
	
	mv "$file" "$(echo "$file" | sed 's/[][ _&,\(\)%#\$¢{};\@]//g')"
	
done

fi

if [ -n "$(find . -maxdepth 1 -name '*.txt' -type f -print -quit)" ]; then

for file in ./*.txt; do

	# Remove special characters from filenames:( _&,()%#$¢{}[];@) 
	
	mv "$file" "$(echo "$file" | sed 's/[][ _&,\(\)%#\$¢{};\@]//g')"
	
done

fi

echo -e "Updating filenames... \033[1;32mDone\033[0m.\r"

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


