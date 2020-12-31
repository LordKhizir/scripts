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
  7z x "$file" -o"$name"/
  rm "$file"
done
#Extra bells;
say -v Monica "unpack completado"
