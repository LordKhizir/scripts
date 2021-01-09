#Shrink all supported images
set -e #Halt on error, to avoid removing non converted files

display_usage() {
	echo "Convert images to jpg and shrink them"
	echo "\nUsage: $0 [-tree]\n"
  echo "\t-tree: If present, process the whole directory tree. If not, just current folder."
	}

timestamp=$(date +%s)

if [[ "$1" =~ .*help.* ]];
then
	display_usage
	exit 1
fi

if [ "$1" = "-tree" ];
then
  maxdepth=""
else
  maxdepth="-maxdepth 1"
fi

find . -type f ${maxdepth} \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" -o -iname "*.tiff" -o -iname "*.bmp" \)  |
while read file;
do
  extension=${file##*.}
  name=${file%.$extension}
  if [ "${name}" == "*" ]; then continue; fi #Avoid processing * in case of no files matching extension

  echo "\t${file}"

  #First step - format conversion - only if needed
  if [ "${extension}" == "JPG" ];
  then
		mv "${file}" "${name}.jpg" # only extension needs to be normalized
	elif ! [ "${extension}" == "jpg" ];
	then
    echo "\t\tConverting to jpg"
    magick convert "${file}" "${name}.jpg"
    rm "${file}"
  fi

  #Second step - optimization
  #It is an heuristic process...so in some cases instead of a file size reduction we will get an increase
  #So we do the conversion on a new file, and will only replace the original in case of an actual size reduction
  magick convert "${name}.jpg" -fuzz 5% -trim +repage -resize 921600@\> "${name}_${timestamp}.jpg"
  originalBytes=`stat -f %z "${name}.jpg"`
  resizedBytes=`stat -f %z "${name}_${timestamp}.jpg"`
  if [ ${originalBytes} -lt ${resizedBytes} ] ;then #Note - for non OSX, use stat -c %s
    # Conversion produces bigger file - remove it
    rm "${name}_${timestamp}.jpg"
  else
    # Conversion produces a file with reduced size - use it
    echo "\t\tShrinked from ${originalBytes} to ${resizedBytes}"
    mv "${name}_${timestamp}.jpg" "${name}.jpg"
  fi
done
