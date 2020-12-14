#Repack
#For each subfolder in current folder, repack all content as .7z
#Extra for OSX - dot_clean to remove .fu extra file
#Extra for OSX - At 7za, -xr!.DS_Store to remove .DS_Store file

dir=`pwd`
dot_clean .
for folder in */
  do
    7za a -r -t7z -mx=9 -xr!.DS_Store "${folder%/}.7z" "$folder"
    rm -r "$folder"
done
