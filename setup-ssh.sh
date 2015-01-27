#!/bin/bash
echo "Setting up SSH..."

###########################
# Setting up root account #
###########################
mkdir -p /root/.ssh;chmod 700 /root/.ssh;cd /root/.ssh;mkdir -p /root/.ssh/tmp;touch /root/.ssh/authorized_keys 

###########################
# Setting up user account #
###########################
mkdir -p ~/.ssh;chmod 700 ~/.ssh;cd ~/.ssh;mkdir -p ~/.ssh/tmp;touch ~/.ssh/authorized_keys

################################
# Setting up user's SSH Config #
################################
echo "ControlMaster auto
ControlPath ~/.ssh/tmp/%h_%p_%r
Host *
	User YOURUSERNAME
Host tunnel1
	HostName tunnel1.sista.arizona.edu
Host tunnel2
	HostName tunnel2.sista.arizona.edu
Host dalek
	ProxyCommand ssh -q -W %h:%p tunnel1
Host dalek2
	HostName dalek
	ProxyCommand ssh -q -W %h:%p tunnel2
#Host YOURMACHINE
#	ProxyCommand ssh -q -W %h:%p tunnel1
#	LocalForward 5999 YOURMACHINE:5900
#Host YOURMACHINE2
#	HostName YOURMACHINE
#	ProxyCommand ssh -q -W %h:%p tunnel2
#	LocalForward 5999 YOURMACHINE:5900
ForwardAgent yes" > ~/.ssh/config

##########################
# Ask to create ssh keys #
##########################
echo "Would you like to create ssh private/public keys?"
read -r -p "Are you sure? [y/N] " response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
then
    echo "Creating keys for root..."
    ssh-keygen -t rsa -b 4096 -f /root/.ssh/id_rsa
    echo "Creating key for your account..."
    ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa
else
    echo "No keys created..."
fi

exit 0
