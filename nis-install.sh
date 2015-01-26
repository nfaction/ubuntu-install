#!/bin/bash

#Install NIS
echo "Installing NIS packages..."
apt-get -y install portmap nis nfs-common autofs nscd tcsh zsh

# Move APS home
echo "Moving /home/aps to /lhome/aps..."
mkdir -p /lhome
mv /home/aps /lhome
usermod -d /lhome/aps -m aps

# Configuring NIS
echo "Configuring NIS..."
echo "portmap:150.135.15.165" >> /etc/hosts.allow
echo "portmap:150.135.15.166" >> /etc/hosts.allow

echo "+::::::" >> /etc/passwd
echo "+:::" >> /etc/group
echo "+::::::::" >> /etc/shadow

echo "domain sista" >> /etc/yp.conf
echo "ypserver ns1.sista.arizona.edu" >> /etc/yp.conf
echo "ypserver ns2.sista.arizona.edu" >> /etc/yp.conf

echo "Setting up Autofs..."
echo "/net    /etc/auto.net" >> /etc/auto.master
echo "/home   yp:auto.home  -rw,intr,nosuid,noacl,vers=3" >> /etc/auto.master

service autofs restart


service ypbind restart

echo "session optional        pam_mkhomedir.so skel=/etc/skel umask=077" >> /etc/pam.d/common-session

sed -i "s/exit 0/#exit 0/" /etc/rc.local
echo "
#/etc/init.d/networking start
service ypbind restart
service nfs-common restart
service autofs restart

( sleep 10; /etc/cron.hourly/cknis) </dev/null >/dev/null 2>&1 &

(sleep 13; cd /net/v04/work; /usr/local/sbin/pause) </dev/null >/dev/null 2>&1 &
(sleep 13; cd /net/v07/misc; /usr/local/sbin/pause) </dev/null >/dev/null 2>&1 &
(sleep 13; cd /net/v05/data; /usr/local/sbin/pause) </dev/null >/dev/null 2>&1 &
exit 0
" >> /etc/rc.local

sysv-rc-conf ypbind on

echo "Changing Lightdm bahavior...."
cp /etc/lightdm/lightdm.conf /etc/lightdm/lightdm.conf.orig

echo "

[SeatDefaults]
greeter-show-manual-login=true
greeter-session=unity-greeter
greeter-hide-users=true
allow-guest=false
user-session=gnome-fallback" > /etc/lightdm/lightdm.conf

service lightdm restart

echo "Finished."
