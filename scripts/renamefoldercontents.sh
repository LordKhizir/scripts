rm move.sh
touch move.sh
folder=${PWD##*/}
echo "Preparing move.sh for contents of folder '${folder}'"
for source in *;
do
  if [ "${source}" == "." ] || [ "${source}" == "move.sh" ] #Avoid processing special names or "move" file
  then
    continue
  fi
  target="${folder} ${source}" # Add prefix
  target="$(echo $target | sed 's/20190/2019-0/g')" # Replace substrings
  target="$(echo $target | sed 's/20191/2019-1/g')" # Replace substrings
  target="$(echo $target | sed 's/20200/2020-0/g')" # Replace substrings
  target="$(echo $target | sed 's/20201/2020-1/g')" # Replace substrings
  target="$(echo $target | sed 's/20210/2021-0/g')" # Replace substrings
  target="$(echo $target | sed 's/20211/2021-1/g')" # Replace substrings
  target="$(echo $target | sed 's/ +/ /g')" # Remove double spaces
  target="$(echo $target | sed 's/\(.*\) \.\(.*\)/\1\.\2/g')" # Remove final spaces before extension
  if ! [ "${source}" == "${target}" ]
  then
    echo mv \"${source}\" \"${target}\" >> move.sh
  fi
done
vi move.sh
