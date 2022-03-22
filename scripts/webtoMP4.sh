#!/bin/bash
# Joseph Polizzotto
# Wake Technical Community College
# 919-866-7977

find . -type f -name "~*.mp4" -exec rm -f {} \;

if ! [ -x "$(command -v youtube-dl)" ]; then

echo -e "\n\033[1;31mError: youtube-dl (http://ytdl-org.github.io/youtube-dl/download.html)is not installed. Exiting...\033[0m" >&2

exit 1

fi

if [ $# -eq 0 ]; then
 
echo -e "\n\033[1;31mEnter the video's URL. Exiting...\033[0m" >&2

exit 1

fi

if [ ! -d ./video ]; then

mkdir video

fi

# Get Video title

curl  -sS $1 | grep "class=\"vid-title\"" | sed 's/^[^>]*>//g' | sed 's/<.*>//g' | sed -z 's/\n//' > title.txt

read -r title < title.txt

rm title.txt

# Give message to user

echo -ne "\nDownloading \033[1;44m"$title".mp4\033[0m...\r"

# Get brightcove URL

curl  -sS $1 | grep "<iframe" | sed 's/^.*src="\/\///' | sed 's/".*$//' | sed '1 s/^.*$//' | sed -z 's/\n//' > url.txt

read -r line < url.txt

rm url.txt

# Download video and save as MP4

youtube-dl "$line" -o ./video/"$title".mp4 >/dev/null 2>&1


echo -e "Downloading \033[1;44m"$title".mp4\033[0m... \033[1;32mDone\033[0m.\r"