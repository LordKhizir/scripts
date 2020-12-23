#Unpack
#For each subfolder in current folder, extrar RAR and ZIP files, and remove them

set -e #Halt on error, to avoid removing unprocessed files
dir=`pwd`
for folder in */
  do cd "$folder"
  echo "Processing folder [$folder]"
  for rarfile in *.rar
    do
       dirname=$(echo "$rarfile" | sed -e 's/\.[^.]*$//')
       if [ "${dirname}" == "*" ] #Avoid processing * in case of no rar files
       then
         continue
       fi
       echo "Processing RAR file [$rarfile]"
       mkdir "$dirname"
       unrar x -r "$rarfile" "$dirname"/
       rm "$rarfile"
    done
  for zipfile in *.zip
    do
      dirname=$(echo "$zipfile" | sed -e 's/\.[^.]*$//')
      if [ "${dirname}" == "*" ] #Avoid processing * in case of no rar files
      then
        continue
      fi
      echo "Processing ZIP file [$zipfile]"
      mkdir "$dirname"
      unzip "$zipfile" -d "$dirname"
      rm "$zipfile"
    done
  cd "$dir"
done
