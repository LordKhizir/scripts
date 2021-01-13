baseFolder="/Users/toni.navarro/NAS/3D/"
patreons=(
  "Archvillain Games"
  "Artisans Guild"
  "Asgard Rising"
  "Bite The Bullet"
  "Last Sword Miniatures"
  "Loot Studios"
  "Titan Forge"
  "Ritual Casting"
)

for patreon in "${patreons[@]}"
do
  echo "================================================"
  echo ${patreon}
  echo "------------------------------------------------"
  ls -r "${baseFolder}${patreon}" | grep -v ".jpg"
  echo " "
done
