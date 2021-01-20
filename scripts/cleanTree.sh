#Clean up folder and subfolders of undesired pests
echo Removing .DS_Store files from current directory tree
find . -name ".DS_Store" -depth -exec rm {} \;
echo Removing dot files
dot_clean .

