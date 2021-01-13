#Repack
#For each subfolder in current folder, repack all content as .7z
#Settings for maximum compression
#Extra for OSX - dot_clean to remove .fu extra file
#Extra for OSX - At 7za, -xr to remove unwanted files: .DS_Store, Thumbs.db

set -e #Halt on error, to avoid removing unprocessed folders
dir=`pwd`
dot_clean .
for folder in */
  do
    7za a -t7z -m0=lzma2 -mx=9 -mqs -mfb=64 -md=1024m -ms=on -xr!.DS_Store -xr!Thumbs.db "${folder%/}.7z" "$folder"
    rm -r "$folder"
done
#Extra bells ;)
say -v Monica "repack completado"
