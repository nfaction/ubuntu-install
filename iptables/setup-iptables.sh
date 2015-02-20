#!/bin/bash

echo "Installing IPTables and rule-chain..."
#
# Backup iptables-rules if exists
#
if [ -f /etc/default/iptables-rules ];
  then
    mv /etc/default/iptables-rules /etc/default/iptables-rules.$date
fi

#
# Copy rules into place, set permissions and copy in service script
#
cp iptables-rules /etc/default
chmod 644 /etc/default/iptables-rules
cp iptables /etc/init.d/
chmod 744 /etc/init.d/iptables

#
# Restart IPTables
#
service iptables restart

#
# Make /etc/init.d/iptables start automatically at boot time
#
update-rc.d iptables defaults

#
# Dump rule-set into terminal
#
echo "Current rules:"
iptables -vnL

echo "Finished installing IPTables and rule-chain..."
exit 0