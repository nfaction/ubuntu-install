#!/bin/bash

usage() {

    echo "usage: update-usr-uid-gid.sh HOME_DIR OLD_UID OLD_GID NEW_UID NEW_GID OLD_Research_GID NEW_RESEARCH_GID"
	
}

#Bad arguments
if [ $# -eq 0 ]; then
	usage
	exit 0
fi

# home
usrhome=$1

# Old UID/GID
olduid=$2
oldgid=$3

# New UID/GID
newuid=$4
newgid=$5

# Research group 
oldres=$6
newres=$7

# Check input
echo "User's home: $usrhome"
echo "User's OLD UID/GID: ${olduid}/${oldgid}"
echo "User's NEW UID/GID: ${newuid}/${newgid}"
echo "User's OLD Research GID: ${oldres}"
echo "User's NEW Research GID: ${newres}"

#
# Ask for confirmation
#
echo "Proceed with UID/GID Upgrade? -----------------------------"
read -r -p "Are you sure? [y/N] " response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
then
    echo "Proceeding with Upgrade..."
else
    echo "Cleaning up and Exiting..."
    exit 0
fi

chown ${newuid}:${newgid} $usrhome

# Update user's UIDs
find ${usrhome}/ -type f -uid $olduid | xargs /bin/chown $newuid
find ${usrhome}/ -type d -uid $olduid | xargs /bin/chown $newuid

# Update user's GIDs
find ${usrhome}/ -type f -gid $oldgid | xargs /bin/chgrp $newgid
find ${usrhome}/ -type d -gid $oldgid | xargs /bin/chgrp $newgid

# Update user's research group
find ${usrhome}/ -type f -gid $oldres | xargs /bin/chgrp $newres
find ${usrhome}/ -type d -gid $oldres | xargs /bin/chgrp $newres

exit 0