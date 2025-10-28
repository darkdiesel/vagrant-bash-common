#!/usr/bin/env bash

# add user
useradd -m -d /home/mednafen_user/ -s /bin/bash -G sudo mednafen_user

# install dependencies
apt-get install build-essential

# configure
bash ./configure

# build from root dir or from src
make

# crontab -e
@reboot /home/mednafen_user/mednafen-server/src/mednafen-server /home/mednafen_user/mednafen-server/standart.conf > /home/mednafen_user/mednafen-server/serverlog > /home/mednafen_user/mednafen-server/serverlog2