#Shrink all supported images
set -e #Halt on error, to avoid removing non converted files
timestamp=$(date +%s)
for file in *.{jpg,JPG,jpeg,png,PNG,webp,WEBP,tiff,TIFF,bmp,BMP};
do
  extension=${file##*.}
  name=${file%.$extension}
  if [ "${name}" == "*" ]; then continue; fi #Avoid processing * in case of no files matching extension

  #First step - format conversion - only if needed
  if ! [ "${extension}" == "jpg" ];
  then
    magick convert "${file}" "${name}.jpg"
    rm "${file}"
  fi

  #Second step - optimization
  #It is an heuristic process...so in some cases instead of a file size reduction we will get an increase
  #So we do the conversion on a new file, and will only replace the original in case of an actual size reduction
  magick convert "${name}.jpg" -fuzz 5% -trim +repage -resize 921600@\> "${timestamp}${name}.jpg"
  if [ `stat -f %z "${name}.jpg"` -lt `stat -f %z "${timestamp}${name}.jpg"` ] ;then #Note - for non OSX, use stat -c %s
    # Conversion produces bigger file - remove it
    rm "${timestamp}${name}.jpg"
  else
    # Conversion produces a file with reduced size - use it
    mv "${timestamp}${name}.jpg" "${name}.jpg"
  fi
done
