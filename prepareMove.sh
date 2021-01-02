rm move.sh
touch move.sh
for source in *;
do
  if [ "${source}" == "." ] #Avoid processing special names
  then
    continue
  fi
  #Here comes the magic
  target="$(echo $source | sed 's/Ballares - //g' | sed 's/ Ballares//g')" # Replace substrings
  #target="$(echo $source | sed 'y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/')" # Convert to lowercase
  #target="$(echo $source | sed 's/\([0-9]*\)\( - \)\(.*\)\(\..*\)/AUTOR - \3 [Gambody \1]\4/')" # Move 000000 to end
  if ! [ "${source}" == "${target}" ]
  then
    echo mv \"${source}\" \"${target}\" >> move.sh
  fi
done
open move.sh
