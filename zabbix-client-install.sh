#!/bin/bash

host=$HOSTNAME
date=$(date +%Y%m%d)

apt-get install zabbix-agent

sed -i "s/Server=127.0.0.1/Server=10.192.92.12/" /etc/zabbix/zabbix_agentd.conf
sed -i "s/ServerActive=127.0.0.1/#ServerActive=127.0.0.1/" /etc/zabbix/zabbix_agentd.conf
sed -i "s/Hostname=Zabbix server/Hostname=${host}/" /etc/zabbix/zabbix_agentd.conf

service zabbix-agent restart

# Use only if using default iptables template for workstations
sed -i "s/# allow responses from outbound connections/# allow zabbix agent\n-A INPUT -s 10.192.92.12 -p tcp -m tcp --dport 10050 -j ACCEPT\n-A INPUT -s 10.192.92.12 -p tcp -m tcp --dport 10051 -j ACCEPT\n# allow responses from outbound connections" /etc/default/iptables-rules
service iptables restart

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

exit 0