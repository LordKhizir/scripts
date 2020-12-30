rm move.sh
touch move.sh
for file in *;
do
  if [ "${name}" == "." ] #Avoid processing special names
  then
    continue
  fi
  echo mv \"${file}_SOURCE\" \"${file}_TARGET\" >> move.sh
done
open move.sh
