#
# Dual direction Rsync
#

#halt on error
set -e

#including authentication
source ${0%/*}/../secrets/Vault3D_THERE_credentials.sh

#Config
ThereBaseFolder=/Users/toni.navarro/dockernaut-Shared3D
HereBaseFolder=/Users/toni.navarro/NAS

# Check if mount point exists, and create it if needed
createMountPoint() {
  if [ ! -d ${ThereBaseFolder} ]
  then
      echo "Mount directory does not exists - creating"
      mkdir ${ThereBaseFolder}
  fi
}

# Mount remote ThereBaseFolder
mountRemote() {
  createMountPoint
  if ! mount | grep "${ThereBaseFolder}" > /dev/null;
  then
      echo "Mounting remote"
      mount_smbfs ${THERE_mount_string} ${ThereBaseFolder}
  fi
}

setTotalTime() {
  TIME_IN_MINUTES=$((((($DAYS * 24) + $HOURS) * 60) + $MINUTES))
  if [ "${TIME_IN_MINUTES}" == "0" ]
  then
    TIME_IN_MINUTES=1440 # 24h * 60m, default 1 day
  fi
}

# Find differences on the last n hours
findDifferences() {
  #TODO OJO puede ser que me haya cargado KLT Studio con los sed... bajarlo
  mountRemote
  setTotalTime
  echo "----------------------------------------"
  echo "Starting diff from files modified in last N hours"
  date
  echo "Finding files modified on last ${TIME_IN_MINUTES} minutes in ${HereBaseFolder}/Vault3D/${FOLDER} -- written on recent_files_Here_unsorted.txt"
  find "${HereBaseFolder}/Vault3D/${FOLDER}" -not -name ".DS_Store" -not -name "\._*" -mmin -${TIME_IN_MINUTES} \
    | sed 's/\/\//\//' \
    | sed 's/.*Vault3D//' \
    > recent_files_Here_unsorted.txt
  echo "Finding files modified on last ${TIME_IN_MINUTES} minutes in ${ThereBaseFolder}/Vault3D/${FOLDER} -- written on recent_files_There_unsorted.txt"
  find "${ThereBaseFolder}/Vault3D/${FOLDER}"  -not -name ".DS_Store" -not -name "\._*" -mmin -${TIME_IN_MINUTES} \
    | sed 's/\/\//\//' \
    | sed 's/.*Vault3D//' \
    > recent_files_There_unsorted.txt
  echo "Sorting files"
  sort < recent_files_Here_unsorted.txt > recent_files_Here.txt
  sort < recent_files_There_unsorted.txt > recent_files_There.txt
  rm recent_files_*_unsorted.txt
  echo "--- Differences ------------------------"
  echo "< 'Here'                                                                      > 'There' >"
  diff --side-by-side --width=160 recent_files_Here.txt recent_files_There.txt
}

findDifferences2() {
  echo "MINUTES ${MINUTES}"
}

# Copy from here to there
copyFromHereToThere() {
  mountRemote
  echo "----------------------------------------"
  echo "Starting rsync from ${HereBaseFolder}/${FOLDER} to ${ThereBaseFolder}/${FOLDER}"
  date
  rsync -avut ${DRYRUN} --size-only --progress --timeout=0 --exclude=.DS_Store --exclude=._* "${HereBaseFolder}/Vault3D/${FOLDER}" "${ThereBaseFolder}/Vault3D/${FOLDER}"
}

# Copy from there to here
copyFromThereToHere() {
  mountRemote
  echo "----------------------------------------"
  echo "Starting rsync from ${ThereBaseFolder}/${FOLDER} to ${HereBaseFolder}/${FOLDER}"
  date
  rsync -avut ${DRYRUN} --size-only --progress --timeout=0 --exclude=.DS_Store --exclude=._* "${ThereBaseFolder}/Vault3D/${FOLDER}" "${HereBaseFolder}/Vault3D/${FOLDER}"
}

#Usage
display_usage() {
  echo "Automate Vault3D remote sync\n"
  echo "Configured to always update, but never delete. Also excludes usual noise files (like ._wtf, .DS_Store)"
  echo "Usage: ${0##*/} {-up|-down|-full|-mount|-diff} [--days] [--hours] [--minutes] [-f|--folder=FOLDER] [-d|--dry-run] [-h|--help]\n"
  echo "Main operation:"
  echo "\t-mount\tMount remote point THERE"
  echo "\t-up\tCopy from HERE to THERE"
  echo "\t-down\tCopy from THERE to HERE"
  echo "\t-full\tFirst copy from HERE to THERE, and then from THERE to HERE"
  echo "\t-diff\tGet a side-by-side list of files recently modified. If days, hours and/or minutes are informed, time is calculated with them. If not, time will be 24h"
  echo "\t-help\tShow this message"
  echo "Options"
  echo '\tAll sync commands {up, down, full} will first mount remote THERE if needed'
  echo '\t-f|--folder: If a FOLDER is provided, only those folder contents will be synced'
  echo '\t-d|--dry-run: Evaluates files to be copied, but only lists them. Use it to check before committing a big or dangerous rsync.'
}

# Parameter parsing
METHOD="help"
FOLDER=""
DRYRUN=""
MINUTES="0"
HOURS="0"
DAYS="0"

for i in "$@"
do
case $i in
    -up)
    METHOD="up"
    shift
    ;;
    -down)
    METHOD="down"
    shift
    ;;
    -full)
    METHOD="full"
    shift
    ;;
    -mount)
    METHOD="mount"
    shift
    ;;
    -diff)
    METHOD="diff"
    shift
    ;;
    --help)
    METHOD="help"
    shift
    ;;
    --minutes=*)
    MINUTES="${i#*=}"
    shift
    ;;
    --hours=*)
    HOURS="${i#*=}"
    shift
    ;;
    --days=*)
    DAYS="${i#*=}"
    shift
    ;;
    -f=*|--folder=*)
    FOLDER="${i#*=}/"
    shift
    ;;
    -d|--dry-run)
    DRYRUN=" --dry-run "
    shift
    ;;
    *)
          # unknown option - just ignoring it
    ;;
esac
done

#Main method selection
case $METHOD in
  mount)
    mountRemote
    exit
    ;;
  diff)
    findDifferences
    exit
    ;;
  up)
    copyFromHereToThere
    exit
    ;;
  down)
    copyFromThereToHere
    exit
    ;;
  full)
    copyFromHereToThere
    copyFromThereToHere
    exit
    ;;
  help)
    display_usage
    exit
    ;;
esac
