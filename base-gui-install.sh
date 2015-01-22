#!/bin/bash
echo "Installing standard GUI software...."

##########################
# Install basic software #
##########################
apt-get update
apt-get -y install gnome-session-fallback flashplugin-installer chromium-browser pepperflashplugin-nonfree rar vlc

update-pepperflashplugin-nonfree --install

# Media Codecs
apt-get -y install ubuntu-restricted-extras
/usr/share/doc/libdvdread4/install-css.sh

#######################
# Install all updates #
#######################
apt-get update; apt-get upgrade -y; apt-get dist-upgrade -y

exit 0