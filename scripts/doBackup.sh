for folder in \
  'Vault3D' \
  'Hobby' \
  'Cosplay' \
  'Rulebooks and Lore' \
  'DO NOT SHARE'

do
  echo BACKING UP ${folder}
  source="/Users/toni.navarro/NAS/${folder}/"
  destination="/Users/toni.navarro/Backup/${folder}"
  echo Source: ${source}
  echo Destination: ${destination}

  rsync -v --archive --progress --timeout=0 --human-readable \
    --backup --backup-dir=OLD-FILES-TO-REMOVE \
    --exclude=.DS_Store --exclude=._* \
    --delete \
    "${source}" "${destination}"
done

