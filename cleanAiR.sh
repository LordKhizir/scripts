#Clean AiR
#For each subfolder and file, remove " - By AiR" from names

#Halt on error
set -e

#Folders
find . -name '* - By AiR' -type d | while read NAME ; do mv "${NAME}" "${NAME%' - By AiR'}" ; done

#Files
find . -name '* - By AiR.*' -type f |
while read file;
do
  extension=${file##*.}
  newname="${file% - By AiR.$extension}"
  mv "${file}" "$newname.$extension"
done
