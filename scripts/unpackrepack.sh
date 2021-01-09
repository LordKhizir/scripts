#Unpack & repack, folder by folder
#It just re-compresses everything... and moves to "done" folder
#Use it for mass processes, to avoid generating huge pools of files

set -e #Halt on error, to avoid removing unprocessed files
mkdir -p "done"

for file in *.{rar,RAR,zip,ZIP,7z,7Z};
do
  extension=${file##*.}
  name=${file%.$extension}
  if [ "${name}" == "*" ] #Avoid processing * in case of no matching files
  then
    continue
  fi
  echo "Unpacking [$file]"
  mkdir "$name"
  7z x "$file" -o"$name"/
  rm "$file"
  7za a -t7z -m0=lzma2 -mx=9 -mfb=64 -md=1024m -ms=on -xr!.DS_Store -xr!Thumbs.db "done/${name%/}.7z" "$name"
  rm -r "$name"
done
#Extra bells;
say -v Monica "unpackrepack completado"
