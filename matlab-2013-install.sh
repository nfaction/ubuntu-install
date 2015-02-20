#!/bin/bash

echo "Copying Matlab..."
rsync -avz root@timelord:/mnt/raid6/APS/Installers/Linux_Installers/R2013b_full /root/
echo "Finished copying..."
## Notes: https://help.ubuntu.com/community/MATLAB
matlab_dir="/root/R2013b_full/"

echo "Installing Oracle Java 7..."
add-apt-repository ppa:webupd8team/java
apt-get update
apt-get install oracle-java7-installer
echo "Java version check:"
java -version

# CD to MATLAB install dir
cd $matlab_dir
echo "Make sure that you are running ssh -X and without Byobu!!"
./install
echo "Continue with on-screen instructions, and activate product"
echo "Activate using: Activation Key:	09757-26711-28248-47939-28103"
echo "Installation located at /usr/local/MATLAB/R2013b/bin"
wget http://upload.wikimedia.org/wikipedia/commons/2/21/Matlab_Logo.png -O /usr/share/icons/matlab.png
echo "#!/usr/bin/env xdg-open
[Desktop Entry]
Type=Application
Icon=/usr/share/icons/matlab.png
Name=MATLAB R2013b
Comment=Start MATLAB - The Language of Technical Computing
#Uncomment the following line and comment the line after to
#force matlab to use the 32 bits architecture
#Exec=matlab -arch=glnx86 -desktop
Exec=matlab -desktop
Categories=Development;
#Uncomment the following line if you've got several matlab icons in the launcher
#StartupWMClass=com-mathworks-util-PostVMInit" > /usr/share/applications/matlab.desktop

# Add Matlab to PATH in /etc/environment
cp /etc/environment /etc/environment.orig
echo PATH=\"$PATH:/usr/local/MATLAB/R2013b/bin\" > test
