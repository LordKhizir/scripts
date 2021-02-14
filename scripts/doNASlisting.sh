#Perform a listing ONLY if there is no actual contents file newer than 8 hours
#Or if -f (force) is passed as parameter
if ! [ `find /Users/toni.navarro/NAS/contents/Vault3D_contents.txt -maxdepth 1 -type f -mmin -480` ] || [ "$1" = "-f" ] ;
then
 #echo "No recent file found - generating new one"
  rm -f /Users/toni.navarro/NAS/contents/Vault3D_contents.txt
  find /Users/toni.navarro/NAS/Vault3D/* > /Users/toni.navarro/NAS/contents/Vault3D_contents.txt
  #touch /Users/toni.navarro/NAS/contents/Vault3D_contents.txt
#else
  #echo "Recent file found - no need to rewrite it"
fi
