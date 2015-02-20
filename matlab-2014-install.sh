#!/bin/bash
unpackdir="/root/matlab2014b"
pullfrom="root@timelord:/mnt/raid6/APS/Installers/Linux_Installers/matlab_R2014b_glnxa64.zip"

echo "Unpacking Matlab"
mkdir -p $unpackdir
echo "Copying Matlab..."
rsync -avz $pullfrom $unpackdir
echo "Finished copying..."

## Notes: https://help.ubuntu.com/community/MATLAB
matlab_dir=$unpackdir

# CD to MATLAB install dir
cd $matlab_dir
unzip matlab_R2014b_glnxa64.zip

echo "Installing Oracle Java 7..."
sudo bash -c "add-apt-repository ppa:webupd8team/java && apt-get update && apt-get install oracle-java7-installer"
echo "Java version check:"
java -version


echo "Make sure that you are running ssh -X and without Byobu!!"
./install
echo "Continue with on-screen instructions, and activate product"
echo "Activate using: Activation Key:	09757-26711-28248-47939-28103"
echo "Installation located at /usr/local/MATLAB/R2014a/bin"
wget http://upload.wikimedia.org/wikipedia/commons/2/21/Matlab_Logo.png -O /usr/share/icons/matlab.png
echo "#!/usr/bin/env xdg-open
[Desktop Entry]
Type=Application
Icon=/usr/share/icons/matlab.png
Name=MATLAB R2014b
Comment=Start MATLAB - The Language of Technical Computing
#Uncomment the following line and comment the line after to
#force matlab to use the 32 bits architecture
#Exec=matlab -arch=glnx86 -desktop
Exec=matlab -desktop
Categories=Development;
#Uncomment the following line if you've got several matlab icons in the launcher
#StartupWMClass=com-mathworks-util-PostVMInit" > /usr/share/applications/matlab.desktop

echo "Create symbolic link into /usr/local/bin: sudo ln -s /usr/local/MATLAB/R2014b/bin/matlab /usr/local/bin"
# Add Matlab to PATH in /etc/environment
cp /etc/environment /etc/environment.orig
echo "PATH=$PATH:/usr/local/MATLAB/R2014b/bin" > /etc/environment