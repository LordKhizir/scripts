#do7z
#For each file in current folder, create a 7z file
#Settings for maximum compression
for file in *.*
  do
    7za a -t7z -m0=lzma2 -mx=9 -mqs=on -mfb=64 -md=1024m -ms=on "${file%.*}.7z" "$file"
done
#Extra bells;
say -v Monica "dusietezeta completado"
