#!/bin/bash
# Joseph Polizzotto
# Wake Technical Community College
# 919-866-7977

find . -type f -name "~*.txt" -exec rm -f {} \;
find . -type f -name "~*.mp4" -exec rm -f {} \;
find . -type f -name "~*.srt" -exec rm -f {} \;

if [ ! -f  "C:\Python37-32\Scripts\aeneas_execute_task.py" ]; then 
echo -e "\n\033[1;31mError: Aeneas module not found. Make sure Aeneas is installed (https://github.com/sillsdev/aeneas-installer/releases) and is in your path. Exiting....\033[0m" >&2

exit

fi

if [ ! -n "$(find . -maxdepth 1 -name '*.txt' -type f -print -quit)" ]; then

echo -e "\033[1;31m\nTXT files are not located in this directory. Exiting...\033[0m"

exit 

else 

if [ ! -d ./video ]; then

mkdir video

fi

fi

# if [ ! -n "$(find . -maxdepth 1 -name '*.mp4' -type f -print -quit)" ]; then

# echo -e "\033[1;31m\nMP4 files are not located in this directory. Exiting...\033[0m"

# exit

# fi

for x in ./*.txt; do

video="${x%.*}"

if [ ! -e ./video/"$video".mp4 ]; then

echo -e "\033[1;31m\nCould not find a MP4 file in the video folder that matches "$x".. Exiting...\033[0m"

exit

else

if [ ! -d ./captions ]; then

mkdir captions

fi

fi

done;

# for x in ./*.mp4; do

# text="${x%.*}"

# if [ ! -e "$text".txt ]; then

# echo -e "\033[1;31m\nCould not find a TXT file that matches "$x". Exiting...\033[0m"

# exit

# fi

# done;

echo -ne "\nConverting TXT to SRT...\r"

for x in ./*.txt; do

new="${x%.*}"

python -m aeneas.tools.execute_task ./video/"$new".mp4 "$x" "task_language=eng|task_adjust_boundary_nonspeech_min=1.000|task_adjust_boundary_nonspeech_string=REMOVE|is_text_file_ignore_regex=\[\(.*\)\]|task_adjust_boundary_algorithm=percent|task_adjust_boundary_percent_value=75|is_text_type=subtitles|os_task_file_format=srt" ./captions/"$new".srt >/dev/null 2>&1

# added is_text_file_ignore_regex=\[\(.*\)\] (to not align text that is within parentheses)

done

echo -e "Converting TXT to SRT... \033[1;32mDone\033[0m.\r"
