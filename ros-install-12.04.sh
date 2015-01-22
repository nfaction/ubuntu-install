#!/bin/bash

# Adding ROS Repo
sh -c 'echo "deb http://packages.ros.org/ros/ubuntu precise main" > /etc/apt/sources.list.d/ros-latest.list'
# Setup keys
wget http://packages.ros.org/ros.key -O - | sudo apt-key add -
# Update
apt-get update
echo "Installing ROS Desktop-full ..."
apt-get install ros-hydro-desktop-full
echo "Initilizing Rosdep..."
rosdep init
rosdep update
echo "Setting up ROS environment..."
echo "source /opt/ros/hydro/setup.bash" >> ~/.bashrc
source ~/.bashrc
echo "If you are using a different user, you must source ROS's .bashrc..."
echo "Do this by entering:"
echo "source /opt/ros/hydro/setup.bash"

echo "Installing Rosinstall..."
apt-get install python-rosinstall
