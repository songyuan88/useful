#/bin/bash

#This Auto-rewrites the default racoon configuration file. By Alex Fang released under GNU GPLv2

echo
echo "Downloading rewrite file..."
cd /etc/racoon
rm -rf racoon.conf
wget raw.githubusercontent.com/frjalex/useful/master/racoon.conf

echo "Confirming...Press anykey to continue..." $anykey ; read anykey
clear
echo "finished."
echo "exitting..."

exit 1
