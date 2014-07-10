#/bin/bash

#
#ForgetFW.sh version 0.1-alpha-deb-01 by Alex Fang. Copyright (c) 2014 ALL RIGHTS RESERVED.
#

#INTRO
#
#ForgetFW.sh is a debian script for Chinese users to get over the great firewall.

echo "Welcome to ForgetFW Version 0.1-A-DEB-01 by Alex Fang."
echo "A 16 line script for getting over Great Firewall..."
echo "Please Enter anykey to continue..." $anykey ; read anykey
apt-get update && apt-get install vpnc
clear
echo "Finished. Please enter the following credentials..."
vpnc-connect

#END#
