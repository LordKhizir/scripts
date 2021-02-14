#Repack
#For each subfolder in current folder, repack all content as .7z
#For each individual file in current folder, if it is an STL, also pack as indiviual 7z
#Settings for maximum compression
#Extra for OSX - dot_clean to remove .fu extra file
#Extra for OSX - At 7za, -xr to remove unwanted files: .DS_Store, Thumbs.db

set -e #Halt on error, to avoid removing unprocessed folders
dir=`pwd`
dot_clean .
for folder in */
  do
    7za a -t7z -m0=lzma2 -mx=9 -mqs=on -mfb=64 -md=1024m -ms=on -xr!.DS_Store -xr!Thumbs.db "${folder%/}.7z" "${folder}"
    rm -r "${folder}"
done

#do7z
#For each file in current folder, create a 7z file
#Settings for maximum compression
for file in *.{stl,STL};
  do
    extension=${file##*.}
    name=${file%.$extension}
    if [ "${name}" == "*" ] #Avoid processing * in case of no matching files
    then
      continue
    fi
    7za a -t7z -m0=lzma2 -mx=9 -mqs=on -mfb=64 -md=1024m -ms=on "${file%.*}.7z" "$file"
    rm "${file}"
done
#Extra bells ;)
say -v Monica "repack completado"
