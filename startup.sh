#!/bin/bash
# File:    startup.sh
# Author:  Simon Aster
# Created: 2022-07-08
# Version: 1
###############
# Startup script for setting up graphical environment and starting nionswift

echo "Usage for running nionswift container and mounting current directory into container:"
echo 'docker container run --net=host -e XAUTH_HOST="$(xauth list $DISPLAY)" -e DISPLAY -v /tmp/.X11-unix -v $(pwd):/home/nion/Documents --rm nionswift'
echo "================================"
echo "================================"

source ~/miniconda/bin/activate root # configure Environment Variables for Miniconda

XAUTH_FIRST_LINE=$(echo $XAUTH_HOST | awk '{print $1 " " $2 " " $3}') # crop XAUTH entry to first line
xauth -q add $XAUTH_FIRST_LINE
echo "Added X-Authentication from host:"
xauth list

nionswift # finally start nionswift
