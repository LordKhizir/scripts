touch move.sh
for source in *;
do
  if [ "${source}" == "." ] || [ "${source}" == "move.sh" ] #Avoid processing special names or "move" file
  then
    continue
  fi
  target="${source}"
  target="$(echo $target | sed 's/2019/ - 2019/g')" # Replace substrings
  target="$(echo $target | sed 's/2020/ - 2020/g')" # Replace substrings
  target="$(echo $target | sed 's/2021/ - 2021/g')" # Replace substrings
  if ! [ "${source}" == "${target}" ]
  then
    echo mv \"${source}\" \"${target}\" >> move.sh
  fi
done
vi move.sh
