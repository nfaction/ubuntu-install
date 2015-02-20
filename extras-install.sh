#!/bin/bash
echo "Installing extra software...."

##########################
# Install basic software #
##########################
apt-get update
apt-get -y install nautilus-dropbox

# Spotify
 apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4E9CFF4E
sh -c 'echo "deb http://repository.spotify.com stable non-free" >> /etc/apt/sources.list'
apt-get update && apt-get install spotify-client-qt
# Netflix
apt-add-repository ppa:ehoover/compholio
apt-get update && apt-get install netflix-desktop
# MS Office | http://www.liberiangeek.net/2012/06/how-to-install-microsoft-office-suite-2010-in-ubuntu-12-04-using-wine-1-5/
# Check out playonlinux
# Caffeine
add-apt-repository ppa:caffeine-developers/caffeine-dev
apt-get update && apt-get -y install caffeine

echo "Installing Oracle Java 7..."
add-apt-repository ppa:webupd8team/java
apt-get update && apt-get -y install oracle-java7-installer
echo "Java version check:"
java -version

#######################
# Install all updates #
#######################
apt-get update; apt-get upgrade -y; apt-get dist-upgrade -y

exit 0