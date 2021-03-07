#Unpack
#Extrar RAR and ZIP files, and remove them

set -e #Halt on error, to avoid removing unprocessed files

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
  if [ "${extension}" == "rar" ] || [ "${extension}" == "RAR" ]
  then
    #Rar5 is not supported by 7z
    unrar x "$file" "$name"
  else
    7z x "$file" #-o"$name"/        Output to dir... but it was creating doubles
  fi
  rm "$file"
done
#Extra bells;
say -v Monica "unpack completado"
