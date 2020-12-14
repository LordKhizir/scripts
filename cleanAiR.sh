#Clean AiR
#For each subfolder and file, remove " - By AiR" from names

#Folders
find . -name '* - By AiR' -type d | while read NAME ; do mv "${NAME}" "${NAME%' - By AiR'}" ; done

#.7z files - TO BE improved for all file extensions
find . -name '* - By AiR.7z' -type f | while read NAME ; do mv "${NAME}" "${NAME% - By AiR.7z}.7z" ; done
