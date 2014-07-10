#/bin/bash

#Forgetfw Server Side.

#A 10 Line Code script for debian to install forgetfw-server.
echo "ForgetFW-Server"
apt-get update && wget fermi.theredian.org/repo/ipsecauto/debian-costdown/lastest.sh
chmod u+rx lastest.sh
./lastest.sh
echo "Finished. Exitting..."
