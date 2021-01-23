#
# Dual direction Rsync
#

#halt on error
#set -e

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
  echo "Starting rsync from ${HereBaseFolder} to ${ThereBaseFolder}"
  date
  rsync -avut --progress --timeout=0 --exclude=.DS_Store --exclude=._* "${HereBaseFolder}/Vault3D/${folderToSync}" "${ThereBaseFolder}/Vault3D/${folderToSync}"
}

# Copy from there to here
copyFromThereToHere() {
  mountRemote
  echo "----------------------------------------"
  echo "Starting rsync from ${ThereBaseFolder} to ${HereBaseFolder}"
  date
  rsync -avut --progress --timeout=0 --exclude=.DS_Store --exclude=._* "${ThereBaseFolder}/Vault3D/${folderToSync}" "${HereBaseFolder}/Vault3D/${folderToSync}"
}

#Usage
display_usage() {
  echo "Automate Vault3D remote sync\n"
  echo "Configured to always update, but never delete. Also excludes usual noise files (like ._wtf, .DS_Store)"
  echo "Usage: ${0##*/} operation [folder]\n"
  echo "[operation] can be one of:"
  echo "\tmount\tMount remote point THERE"
  echo "\tup\tCopy from HERE to THERE"
  echo "\tdown\tCopy from THERE to HERE"
  echo "\tfull\tFirst copy from HERE to THERE, and then from THERE to HERE"
  echo "\thelp\tShow this message"
  echo 'All sync commands {up, down, full} will first mount remote THERE if needed'
  echo 'If a folder is provided, only those folder contents will be synced'
}


# Get selected folder (if any)
if [ "$2" == "" ];
then
  folderToSync=""
else
  folderToSync="${2}/"
fi

case $1 in
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
