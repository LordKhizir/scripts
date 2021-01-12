#Compare two IDENTICAL folders, compare each file pair and keep only the smaller one
set -e #Halt on error, to avoid removing non converted files

display_usage() {
	echo "Compare two IDENTICAL folders, compare each file pair and keep only the smaller one"
	echo "\nUsage: $0 sourceFolderA sourceFolderB destination\n"
	}

if (( $# != 3 )); then
	display_usage
  exit 0;
fi

sourceA="$1"
sourceB="$2"
destination="$3"

echo "Starting folder comparison"
echo "Source folder A:    ${sourceA}"
echo "Source folder B:    ${sourceB}"
echo "Destination folder: ${destination}"

find "${sourceA}" -type f |
while read sourceAfile;
do
  extension=${sourceAfile##*.}
  name=${sourceAfile%.$extension}
  if [ "${name}" == "*" ]; then continue; fi #Avoid processing * in case of no files matching extension

	#Get the correspondent locators
	sourceBfile="$(echo ${sourceAfile} | sed "s/${sourceA}/${sourceB}/g")" # Replace folders
	destinationfile="$(echo ${sourceAfile} | sed "s/${sourceA}/${destination}/g")" # Replace folders
	destinationfolder="$(dirname "${destinationfile}")"

	sourceAfileBytes=`stat -f %z "${sourceAfile}"`
	sourceBfileBytes=`stat -f %z "${sourceBfile}"`
	echo "\tSource A    :${sourceAfile} - ${sourceAfileBytes} bytes"
	echo "\tSource B    : ${sourceBfile} - ${sourceBfileBytes} bytes"

	#Creating destination folder
	mkdir -p "${destinationfolder}"

	#Select which file to copy
  if [ ${sourceAfileBytes} -lt ${sourceBfileBytes} ] ;then #Note - for non OSX, use stat -c %s
		#Copy selected file
		echo "Copying A"
		cp "${sourceAfile}" "${destinationfolder}"
  else
		echo "Copying B"
		cp "${sourceBfile}" "${destinationfolder}"
  fi
done
echo "RESULTS:"
echo "Source folder A:    ${sourceA}"
du -sh "${sourceA}"
echo "Source folder B:    ${sourceB}"
du -sh "${sourceB}"
echo "Destination folder: ${destination}"
du -sh "${destination}"
