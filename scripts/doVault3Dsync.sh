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

# Copy from here to there
copyFromHereToThere() {
  mountRemote
  echo "----------------------------------------"
  echo "Starting rsync from ${HereBaseFolder}/${FOLDER} to ${ThereBaseFolder}/${FOLDER}"
  date
  rsync -avut ${DRYRUN} --progress --timeout=0 --exclude=.DS_Store --exclude=._* "${HereBaseFolder}/Vault3D/${FOLDER}" "${ThereBaseFolder}/Vault3D/${FOLDER}"
}

# Copy from there to here
copyFromThereToHere() {
  mountRemote
  echo "----------------------------------------"
  echo "Starting rsync from ${ThereBaseFolder}/${FOLDER} to ${HereBaseFolder}/${FOLDER}"
  date
  rsync -avut ${DRYRUN} --progress --timeout=0 --exclude=.DS_Store --exclude=._* "${ThereBaseFolder}/Vault3D/${FOLDER}" "${HereBaseFolder}/Vault3D/${FOLDER}"
}

#Usage
display_usage() {
  echo "Automate Vault3D remote sync\n"
  echo "Configured to always update, but never delete. Also excludes usual noise files (like ._wtf, .DS_Store)"
  echo "Usage: ${0##*/} {-up|-down|-full|-mount} [-f|--folder=FOLDER] [-d|--dry-run] [-h|--help]\n"
  echo "Main operation:"
  echo "\t-mount\tMount remote point THERE"
  echo "\t-up\tCopy from HERE to THERE"
  echo "\t-down\tCopy from THERE to HERE"
  echo "\t-full\tFirst copy from HERE to THERE, and then from THERE to HERE"
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
    -f=*|--folder=*)
    FOLDER="${i#*=}/"
    shift
    ;;
    -d|--dry-run)
    DRYRUN=" --dry-run "
    shift
    ;;
    -h|--help)
    METHOD="help"
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
