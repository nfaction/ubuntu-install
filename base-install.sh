#!/bin/bash
echo "Installing standard software...."

##########################
# Install basic software #
##########################
apt-get update
apt-get -y install openssh-server byobu vim emacs ntpdate zsh tcsh git

#######################
# Install all updates #
#######################
apt-get update; apt-get upgrade -y; apt-get dist-upgrade -y

#########################
# Set SISTA NTP Servers #
#########################
sed -i '/^# Specify one or more NTP servers./a server ntp1.sista.arizona.edu\nserver ntp2.sista.arizona.edu' /etc/ntp.conf

##########################
# Set time-zone manually #
##########################
dpkg-reconfigure tzdata

exit 0
