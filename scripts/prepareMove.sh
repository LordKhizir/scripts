rm move.sh
touch move.sh
for source in *;
do
  if [ "${source}" == "." ] #Avoid processing special names
  then
    continue
  fi
  #Here comes the magic
  target=source
  #target="$(echo $source | sed 's/Biringan //g')" # Replace substrings
  #target="$(echo $source | sed 'y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/')" # Convert to lowercase
  target="$(echo $source | python3 -c "import sys; print(sys.stdin.read().title())")" #Convert to Capitalized First Letter
  #target="Asgard Rising ${source}" # Add prefix
  #target="${source} [Wasteworld]" # Add suffix to FOLDERS
  target="$(echo $target | sed 'y/_/ /')" # Remove -_
  target="$(echo $target | sed 's/\.Jpg/\.jpg/')" # Respect extensions
  target="$(echo $target | sed 's/\.7Z/\.7z/')" # Respect extensions
  target="$(echo $target | sed 's/\.Rar/\.rar/')" # Respect extensions
  target="$(echo $target | sed 's/\.Zip/\.zip/')" # Respect extensions
  #target="$(echo $target | sed 's/20191/2019-1/g')" # Replace substrings
  #target="$(echo $target | sed 's/20200/2020-0/g')" # Replace substrings
  #target="$(echo $target | sed 's/20201/2020-1/g')" # Replace substrings
  #target="$(echo $source | sed 'y/abcdefghijklmnopqrstuvwxyz/ABCDEFGHIJKLMNOPQRSTUVWXYZ/')" # Convert to uppercase
  #target="$(echo $source | sed 's/\([0-9]*\)\( - \)\(.*\)\(\..*\)/AUTOR - \3 [Gambody \1]\4/')" # Move 000000 to end
  #target="$(echo $source | sed 's/Lost Tribes - \(.*\)\(\..*\)/\1 [Lost Tribes]\2/')" # Move prefix to end
  #target="$(echo $source | sed 's/Winterdale \(.*\)\(\..*\)/\1 [Winterdale]\2/')" # Move 000000 to end
  #Remove tagging from images
  #target="$(echo $source | sed 's/\[.*\]//g')" # Remove [xx]
  #target="$(echo $target | sed 's/[0-9].[0-9]//g')" # Remove versioning
  #target="$(echo $target | sed 's/ +/ /g')" # Remove double spaces
  #target="$(echo $target | sed 's/\(.*\) \.\(.*\)/\1\.\2/g')" # Remove final spaces before extension
  #target="$(echo $source | sed 's/\(.*\)\.7z/\1 [Shadowfey]\.7z/g')" # Add suffix to 7z files
  if ! [ "${source}" == "${target}" ]
  then
    echo mv \"${source}\" \"${target}\" >> move.sh
  fi
done
echo "rm move.sh" >> move.sh
more move.sh
