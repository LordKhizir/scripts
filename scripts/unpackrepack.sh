#Unpack & repack, folder by folder
#It just re-compresses everything... and moves to "done" folder
#Use it for mass processes, to avoid generating huge pools of files

set -e #Halt on error, to avoid removing unprocessed files
workFolder="TMPWRKFLDR"
mkdir -p "${workFolder}"

for file in *.{rar,RAR,zip,ZIP,7z,7Z};
do
  extension=${file##*.}
  name=${file%.$extension}
  if [ "${name}" == "*" ] #Avoid processing * in case of no matching files
  then
    continue
  fi
  newFile="${workFolder}/${name%/}.7z"
  echo "Unpacking [$file]"
  mkdir "$name"
  if [ "${extension}" == "rar" ] || [ "${extension}" == "RAR" ]
  then
    #Rar5 is not supported by 7z
    unrar x "$file" "$name"
  else
    7z x "$file" -o"$name"/
  fi
  7za a -t7z -m0=lzma2 -mx=9 -mqs=on -mfb=64 -md=1024m -ms=on -xr!.DS_Store -xr!Thumbs.db -xr!desktop.ini "${newFile}" "$name/."
  rm -r "$name" # remove temp folder for the file
  #If the original file was already a 7z, check if new file is smaller than the first one - sometimes it happens, depending on compression method
  if [ "${extension}" == "7z" ] || [ "${extension}" == "7Z" ]
  then
    oldSize=`stat -f %z "${file}"`
    newSize=`stat -f %z "${newFile}"`
    #Select which file to copy
    if [ ${oldSize} -lt ${newSize} ] ;then #Note - for non OSX, use stat -c %s
  		echo "Restoring original file - it's smaller!"
  		mv "${file}" "${newFile}"
    else
  		rm "${file}"
    fi
  else
    rm "${file}"
  fi
done
#Move everything from working dir, and remove
mv ${workFolder}/* .
rm -r ${workFolder}
#Extra bells;
#say -v Monica "unpackrepack completado"
