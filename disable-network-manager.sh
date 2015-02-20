#!/bin/bash
DATE=$(date +"%Y-%m-%d-%T")

echo "Backing up Network Manager config..."
cp /etc/NetworkManager/NetworkManager.conf /etc/NetworkManager/NetworkManager.conf.$DATE.bak

sed -i "s/managed=true/managed=false/" /etc/NetworkManager/NetworkManager.conf

echo "Setting up Network Interfaces file..."
cp /etc/network/interfaces /etc/network/interfaces.$DATE.bak

cdr2mask ()
{
   # Number of args to shift, 255..255, first non-255 byte, zeroes
   set -- $(( 5 - ($1 / 8) )) 255 255 255 255 $(( (255 << (8 - ($1 % 8))) & 255 )) 0 0 0
   [ $1 -gt 1 ] && shift $1 || shift
   echo ${1-0}.${2-0}.${3-0}.${4-0}
}

ADDR=$(cat /etc/NetworkManager/system-connections/"`ls -t /etc/NetworkManager/system-connections | head -n 1`" | grep "addresses" | cut -f2 -d"=" | cut -f1 -d";")
nmtemp=$(cat /etc/NetworkManager/system-connections/"`ls -t /etc/NetworkManager/system-connections | head -n 1`" | grep "addresses" | cut -f2 -d"=" | cut -f2 -d";")
NM=$(cdr2mask $nmtemp)
GW=$(cat /etc/NetworkManager/system-connections/"`ls -t /etc/NetworkManager/system-connections | head -n 1`" | grep "addresses" | cut -f2 -d"=" | cut -f3 -d";")
SD=$(cat /etc/NetworkManager/system-connections/"`ls -t /etc/NetworkManager/system-connections | head -n 1`" | grep "dns-search" | cut -f2 -d"=" | tr -d ';')
NS=$(cat /etc/NetworkManager/system-connections/"`ls -t /etc/NetworkManager/system-connections | head -n 1`" | grep "dns=" | cut -f2 -d"=" | sed -e 's/;/ /g')

echo

echo "Network information:"
echo $ADDR
echo $NM
echo $GW
echo $SD
echo $NS

echo

echo "auto eth0
iface eth0 inet static
        address $ADDR
        netmask $NM
        gateway $GW
        dns-search $SD
        dns-nameservers $NS" >> /etc/network/interfaces

echo "Restarting networking..."
/etc/init.d/networking stop
sleep 5
service networking start

echo "Done..."

echo "YOU MUST REBOOT NOW!"
