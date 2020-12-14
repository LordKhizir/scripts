#Unpack
#For each subfolder in current folder, extrar RAR and ZIP files, and remove them
dir=`pwd`
for folder in */
  do cd "$folder"
  echo "Processing folder [$folder]"
  for rarfile in *.rar
    do
       echo "Processing RAR file [$rarfile]"
       unrar x "$rarfile"
       rm "$rarfile"
    done
  for zipfile in *.zip
    do
      echo "Processing ZIP file [$zipfile]"
      zipfilename=$(echo "$zipfile" | sed -e 's/\.[^.]*$//')
      mkdir "$zipfilename"
      unzip "$zipfile" -d "$zipfilename"
      rm "$zipfile"
    done
  cd "$dir"
done
