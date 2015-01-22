#!/bin/bash

# If on a laptop
add-apt-repository ppa:linrunner/tlp
apt-get update && apt-get install tlp tlp-rdw
tlp start