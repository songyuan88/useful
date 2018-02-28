#!/bin/bash
# Program:
#     this program used for multi-port service for shadowsocks-libev
#     shaddowsockes-libev do not support multi port configuration, use multiple instances instead.
#     visit https://github.com/shadowsocks/shadowsocks-libev/issues/5  for more information
#
#     Usage: ss_multi_port.sh user_as default_cfg daemon_opt
#
#     In general, this script need start as a daemon from sysV init or systemd
#     for systemd: it is run from /etc/systemd/system/multi-user.target.wants/shadowsocks-libev.service
#
# History:
# 2017-01-01    deeve.ma@gmail.com    first release



# check argument number
if [ $# != 3 ]
then
        echo "Usage: `basename $0` user_as default_cfg daemon_opt"
        exit 1
fi


pid_file_dir=/var/run/shadowsocks-libev
user_as=$1
default_cfg=$2
daemon_opt=$3


# create pid file folder
[ -d $pid_file_dir ] || mkdir $pid_file_dir

# pid file name
pid_0_file=$pid_file_dir/ss_0.pid
pid_1_file=$pid_file_dir/ss_1.pid
pid_2_file=$pid_file_dir/ss_2.pid
pid_3_file=$pid_file_dir/ss_3.pid

# config file name
default_cfg_dir=/opt/shadowsocks-libev

#cfg_0_file=$default_cfg
cfg_0_file=$default_cfg_dir/ss_0_cfg.json
cfg_1_file=$default_cfg_dir/ss_1_cfg.json
cfg_2_file=$default_cfg_dir/ss_2_cfg.json
cfg_3_file=$default_cfg_dir/ss_3_cfg.json



# start service
echo "start multi-port service:"
/usr/bin/ss-server -a $user_as -c $cfg_0_file -f $pid_0_file $daemon_opt
/usr/bin/ss-server -a $user_as -c $cfg_1_file -f $pid_1_file $daemon_opt
/usr/bin/ss-server -a $user_as -c $cfg_2_file -f $pid_2_file $daemon_opt
#/usr/bin/ss-server -a $user_as -c $cfg_3_file -f $pid_3_file $daemon_opt

echo "start multi-port sevice done!"

exit 0
