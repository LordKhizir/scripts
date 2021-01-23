#getLastScreenshot
#Create an URL file with an anchor to passed URL
display_usage() {
	echo "Move last Screenshot taken to the current folder."
  echo "\tIf no filename is provided, it will be last_screenshot.png"
  echo "\tIf a filename is provided, it will be used with .png extension attached"
	echo "\nUsage: $0 [filename]\n"
	}

# if no filename argument, use default
if [  $# -le 0 ]
then
  filename="last_screenshot.png"
else
  filename="${1}.png"
fi

mv "`find ~/Desktop/Screenshots -name "Screenshot *.png" -print0 | xargs -0 ls -1 -t | head -1`" "${filename}"
