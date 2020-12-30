#Shrink all supported images
set -e #Halt on error, to avoid removing non converted files
timestamp=$(date +%s)
for file in *.{jpg,JPG,jpeg,png,PNG,webp,WEBP,tiff,TIFF,bmp,BMP};
do
  extension=${file##*.}
  name=${file%.$extension}
  if [ "${name}" == "*" ]; then continue; fi #Avoid processing * in case of no files matching extension
  mv "$file" "$timestamp$file"
  magick convert "$timestamp$file" -fuzz 5% -trim +repage -resize 921600@\> "${name}.jpg"
  rm "$timestamp$file"
done
