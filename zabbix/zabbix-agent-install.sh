#!/bin/bash
##### GUIDE: https://www.digitalocean.com/community/articles/how-to-install-zabbix-on-ubuntu-configure-it-to-monitor-multiple-vps-servers
cd /root/zabbix

host=$HOSTNAME
date=$(date +%Y%m%d)

# Check Installation
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' zabbix-agent|grep "install ok installed")
echo "Checking for zabbix-agent: $PKG_OK"
if [ "" == "$PKG_OK" ]; then
  echo "Not installed.  Installing now...."
  #dpkg -i zabbix-agent_2.0.9-1_amd64.deb
else
	echo "Uninstalling and re-installing..."
	dpkg -r zabbix-agent
	dpkg -P zabbix-agent
	#dpkg -i zabbix-agent_2.0.9-1_amd64.deb
fi


MACHINE_TYPE=`uname -m`
if [ ${MACHINE_TYPE} == 'x86_64' ]; then
  # 64-bit stuff here
  dpkg -i zabbix-agent_2.0.9-1_amd64.deb
else
  # 32-bit stuff here
  dpkg -i zabbix-agent_2.0.9-1_i386.deb
fi

sed -i "s/Server=127.0.0.1/Server=10.192.92.12/" /etc/zabbix/zabbix_agentd.conf
sed -i "s/ServerActive=127.0.0.1/#ServerActive=127.0.0.1/" /etc/zabbix/zabbix_agentd.conf
sed -i "s/Hostname=Zabbix server/Hostname=${host}/" /etc/zabbix/zabbix_agentd.conf

service zabbix-agent restart

# Backup iptables-rules if exists
if [ -f /etc/default/iptables-rules ];
  then
    mv /etc/default/iptables-rules /etc/default/iptables-rules.$date.zabbix-install
fi

cp iptables-rules /etc/default
chmod 644 /etc/default/iptables-rules
cp iptables /etc/init.d/
chmod 744 /etc/init.d/iptables
# Use only if using default iptables template for workstations
sed -i "21i# allow zabbix agent\n-A INPUT -s 10.192.92.12 -p tcp -m tcp --dport 10050 -j ACCEPT\n-A INPUT -s 10.192.92.12 -p tcp -m tcp --dport 10051 -j ACCEPT" /etc/default/iptables-rules
service iptables restart

echo "Installing Iptables Persistent"
apt-get install iptables-persistent
echo "Rules are now located at: /etc/iptables/rules.v4 and /etc/iptables/rules.v6."

echo "Testing connection..."
host="cybermen"
port=10051

nc -z -w 3 $host $port > /dev/null 2>&1
    if [[ $? = 0 ]]; then
        printf "%s%s%s\n" " [$host:" "UP" "]"
    else
        printf "%s%s%s\n" " [$host:" "DOWN" "]"
    fi

echo "Installation of Zabbix-agent complete!"
