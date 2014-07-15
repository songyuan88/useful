#/bin/bash

#IPsec IKE Phase 1 / Phase 2 (Based on StrongS/WAN) One-click installation script for ArchLinux.
#Author: Alex Fang. Linscence: GNU GPLv2 (Released with useful(Bundle)).

clear



if [ $(id -u) != "0" ]; then
    echo "The current user has no root privilages\n"
    exit 1
fi

echo "*****************************************"
echo "  IKEv2Auto v0.1-alpha-arch  by A. F.    "
echo " Released under GNU GPLv2 with Useful.   "
echo "  BUG REPORTS : frjalex@gmail.com        "
echo "*****************************************"

pacman -Syu

mkdir ikev2auto
cd ikev2auto

wget http://download.strongswan.org/strongswan-5.2.0.tar.gz

tar xzvf strongswan-5.2.0.tar.gz

cd strongswan-5.2.0


./configure --enable-eap-identity --enable-eap-md5 \
--enable-eap-mschapv2 --enable-eap-tls --enable-eap-ttls --enable-eap-peap \
--enable-eap-tnc --enable-eap-dynamic --enable-eap-radius --enable-xauth-eap \
--enable-xauth-pam --enable-dhcp --enable-openssl --enable-addrblock --enable-unity \
--enable-certexpire --enable-radattr --enable-tools --enable-openssl --disable-gmp

make && make install
