#/bin/bash

#Racoon_Config_Setup.sh, a part of IPsecAuto Project. For Setting up racoon.conf & adding IPtables & sysctl rules only.
#works on any system that has Racoon installed and has configured /etc/racoon/motd and /etc/racoon/psk.txt file.

#Author: Alex Fang    frjalex@gmail.com
#BUG REPORTS: frjalex@gmail.com
#Released under GNU GPLv2.
#hiddenauthorthatuwanaknow.theredian.org

echo
echo "+----------------------------------------------------------------+"
echo "|      Racoon Config Setup Environment. Must be root to setup.   |"
echo "| Author: Alex Fang. frjalex@gmail.com  Released under GPLv2.    |"
echo "+----------------------------------------------------------------+"
echo

echo "Press enter to continue..." $entercontinue ; read entercontinue

echo "Press 1 if u ONLY WANT to edit the iptables rules." $entercontinue2 ; read entercontinue2


if [ $entercontinue2 = 1 ] then
  echo "Custom and edit your racoon.conf by yourself after install. Enter to set iptables rules:" read entercontinue ;
  $CLIENTIP=10.1.0.0/24
  echo "enter your Client IP Address of racoon.conf. Enter to use the default(recommend)" $CLIENTIP ; read CLIENTIP
  apt-get update && apt-get -y install iptables
  iptables -A INPUT -p tcp -m tcp --dport 22 -j ACCEPT
  iptables -A INPUT -p udp -m udp --dport 500 -j ACCEPT
  iptables -A INPUT -p udp -m udp --dport 4500 -j ACCEPT
  iptables -A INPUT -p esp -j ACCEPT
  iptables -A INPUT -s 127.0.0.0/24 -d 127.0.0.0/24 -j ACCEPT
  iptables -A FORWARD -s $CLIENTIP -j ACCEPT
  iptables -t nat -A POSTROUTING -s $CLIENTIP -o eth0 -j MASQUERADE
  exit 1
fi


echo "-----------------Downloading Config File---------------------"
FILEPATH=/etc/racoon
echo "Please enter your path your racoon was installed. The default path will be /etc/racoon." read FILEPATH ;
echo "the path you entered is" $FILEPATH
cd $FILEPATH

rm -f racoon.conf
wget https://raw.githubusercontent.com/frjalex/useful/master/racoon.conf --no-check-certificate

echo "Custom and edit your racoon.conf by yourself after install. Enter to set iptables rules:" read entercontinue ;
$CLIENTIP=10.1.0.0/24
echo "enter your Client IP Address of racoon.conf. Enter to use the default(recommend)" $CLIENTIP ; read CLIENTIP
apt-get update && apt-get -y install iptables
iptables -A INPUT -p tcp -m tcp --dport 22 -j ACCEPT
iptables -A INPUT -p udp -m udp --dport 500 -j ACCEPT
iptables -A INPUT -p udp -m udp --dport 4500 -j ACCEPT
iptables -A INPUT -p esp -j ACCEPT
iptables -A INPUT -s 127.0.0.0/24 -d 127.0.0.0/24 -j ACCEPT
iptables -A FORWARD -s $CLIENTIP -j ACCEPT
iptables -t nat -A POSTROUTING -s $CLIENTIP -o eth0 -j MASQUERADE


echo "Finished.   Bye. Exiting..."
#FINISHED.
