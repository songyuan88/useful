#!/bin/bash

#A SHELL BASED SCRIPT FOR IPSEC IKEv2 VPN INSTALLATION BASED ON racoon.

echo "##############################################################"
echo "# This is a shell-based tool for IPsec IKE VPN installation. #"
echo "# Author: Alex Fang. Email and debugging: frjalex@gmail.com  #"
echo "# Liscense: MIT or GPL v2#Author twitter: twitter.com/AFANG01#"
echo "# View Sourcecode and other interestings: github.com/frjalex/#"
echo "##############################################################"



if [ $(id -u) != "0" ]; then
    echo  "The current user has no root privilages\n"
    exit 1
fi

echo "finished detecting root privilages. Now installing racoon. * NOTE *: please choose manual install!"
#install racoon
apt-get install racoon


echo "racoon installation completed."

echo "Now we're configuring it for you!"
mbanner=hellovpn
echo "Please enter your preferred connection banner!"  read mbanner
echo "your banner"
echo $mbanner
cd /etc/racoon/
rm motd
cat > motd <<EOF
$mbanner
EOF
gname1=vpn

echo "Please enter your 1st group name like this " $gname1 ; read gname1
echo "Your group name is"
echo $gname1

gsecret1=vpn123
echo "Enter your preferred group secret(PSK) LIKE THIS" $gsecret1 ; read gsecret1
echo "Your secret is"
echo $gsecret1

rm -rf psk.txt
cat >psk.txt <<EOF
$gname1 $gsecret1
#id and secret
EOF



#destroy ipsec.conf and rebuild and ask for client ip
cip=xxx.xxx.xxx.xxx
echo "Now please enter your server's STATIC IP address."
echo "the format must be like xxx.xxx.xxx.xxx now please enter your ip" read cip
echo "Your server's ip address is"
echo $cip

dns1=8.8.8.8
echo "the default dns1 is Google 1(8.8.8.8) If you want to change: " read dns1
echo "the dns1 is now:"
echo $dns1

dns2=8.8.4.4
echo "the default dns2 is Google 2(8.8.4.4) If you want to change: " read dns2
echo "the dns2 is now:"
echo $dns2

fqdn1=xxx.theredian.org
echo "please input your servers fqdn the format is like '%s' "
echo "your fqdn: " read fqdn1
echo "now the fqdn is"
echo $fqdn1

echo "Saved.
cd /etc/racoon/

rm -rf ipsec.conf

cat >ipsec.conf <<EOF
log info;
path include "/etc/racoon";
path pre_shared_key "/etc/racoon/psk.txt";

listen {
}

remote anonymous {
        exchange_mode main,aggressive;
        doi ipsec_doi;
        nat_traversal on;
        proposal_check obey;
        generate_policy unique;
        ike_frag on;
        passive on;
        dpd_delay = 30;
	dpd_retry = 30;
	dpd_maxfail = 800;
	mode_cfg = on;
        proposal {
                encryption_algorithm aes;
                hash_algorithm sha1;
                authentication_method xauth_psk_server;
                dh_group 2;
		lifetime time 12 hour;
        }
}

timer
{
        natt_keepalive 20 sec;
}

sainfo anonymous {
        lifetime time 12 hour ;
        encryption_algorithm aes,3des,des;
        authentication_algorithm hmac_sha1,hmac_md5;
        compression_algorithm deflate;
}

mode_cfg {
        dns4 $dns1,$dns2; #濉笂浣燰PS涓婄殑DNS
        save_passwd on;
        network4 10.1.0.2; #VPS瀹㈡埛绔疘P
        netmask4 255.255.255.0;
        pool_size 250;
        banner "/etc/racoon/motd";
        auth_source pam;
        conf_source local;
        pfs_group 2;
	default_domain " $fqdn1 ";
} 

EOF
#######################racoon and ipsec settings completed#######################################

cd

echo "-----------------------VPN SETTINGS COMPLETED. NOW MODIFYING IPTABLES...----------"
echo "this is your ethernet config"
ifconfig

ipeth=eth0
echo "Please enter your default ethernet port like eth0 . Enter it : " read ipeth
echo "Now your ethernet is"
echo $ipeth

sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
sysctl -p
iptables --table nat --append POSTROUTING -o $ipeth  --jump MASQUERADE

#add a default vpn user
echo "adding a vpn user named vpn01..."
echo "Enter your prefered UNIX password please."
useradd vpn01
passwd vpn01


###################COMPLETED####################################
echo "-------------CONGREDULATIONS! VPN IS READY! ENJOY! "

echo " #######################################################"
echo "#"
echo "# Powered by Alex Fang                              #"
echo "# Your vpn username is vpn01"
echo "# Your password is the password you defined        #"
echo "# Your group name is"
echo $gname1
echo "#your group secret is"
echo $gsecret1
echo "#your connection banner is"
echo $mbanner
echo "your Primary dns is"
echo $dns1
echo "your Secondary dns is"
echo $dns2
echo "Thanx and enjoy."
echo "##########################################################"