#!/bin/bash
##### GUIDE: https://github.com/mipmip/zabbix_agentd_osx_installer

## Steps
# 1. Enable root over SSH
# 	sudo vi /private/etc/sshd_config
# 	PermitRootLogin yes
# 2. sudo passwd
# 	enter ws password
# 	enter server password

cd /var/root/zabbix

installer -pkg /var/root/zabbix/zabbix_agentd.2.0.5.OS.X.pkg -target /

/var/root/zabbix/postinstall.sh

sed -i "s/Server=0.0.0.0/Server=10.192.92.12/" /usr/local/etc/zabbix/zabbix_agentd.conf
sed -i "s/Hostname=yourhostname/Hostname=${host}/" /etc/zabbix/zabbix_agentd.conf

launchctl load /Library/LaunchDaemons/com.zabbix.zabbix_agentd.plist

