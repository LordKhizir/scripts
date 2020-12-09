#Repack
#For each subfolder in current folder, extrar RAR files, remove them, and repack all content as .7z
#TODO: Expand with support for .zip - YAGNI
dir=`pwd`
for folder in */
  do cd "$folder"
  echo "Processing folder [$folder]"
  for rarfile in *.rar
    do unrar x "$rarfile"
    rm "$rarfile"
  done
  cd "$dir"
  7za a -r -t7z -mx=9 "${folder%/}.7z" "$folder"
  rm -r "$folder"
done
