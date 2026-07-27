#!/bin/bash
set -e

./steamcmd/steamcmd.sh +runscript /home/steam/rs2server.txt

sudo rm -f /tmp/.X11-unix/.lock
sudo rm -f /tmp/.X1-lock
sudo rm -f /tmp/.X10-lock

sudo Xvfb :1 -screen 0 800x600x24 2>&1 &

export DISPLAY=:1
export WINEDLLOVERRIDES="mscoree,mshtml="

sleep 2

wine /RS2/server/Binaries/Win64/VNGame.exe VNTE-CuChi