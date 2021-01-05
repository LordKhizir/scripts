rm move.sh
touch move.sh
for source in *;
do
  if [ "${source}" == "." ] #Avoid processing special names
  then
    continue
  fi
  #Here comes the magic
  #target="$(echo $source | sed 's/Vladistov //g')" # Replace substrings
  #target="$(echo $source | sed 'y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/')" # Convert to lowercase
  #target="$(echo $source | python3 -c "import sys; print(sys.stdin.read().title())")" #Convert to Capitalized First Letter
  target="$(echo $source | sed 's/WD/Winterdale/g')" # Replace substrings
  #target="The Bosses - ${source}" # Add prefix
  #target="$(echo $source | sed 'y/abcdefghijklmnopqrstuvwxyz/ABCDEFGHIJKLMNOPQRSTUVWXYZ/')" # Convert to uppercase
  #target="$(echo $source | sed 's/\([0-9]*\)\( - \)\(.*\)\(\..*\)/AUTOR - \3 [Gambody \1]\4/')" # Move 000000 to end
  if ! [ "${source}" == "${target}" ]
  then
    echo mv \"${source}\" \"${target}\" >> move.sh
  fi
done
echo "rm move.sh" >> move.sh
vi move.sh
