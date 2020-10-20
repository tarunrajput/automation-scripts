#!/bin/bash

ENDCOLOR="\033[0m"
BLACK="\033[30m"
RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[33m"
BLUE="\033[1;34m"
PINK="\033[35m"
CYAN="\033[36m"
WHITE="\033[37m"
NORMAL="\033[0;39m"



if [ $USER != root ]; then
  echo -e $RED"Error: must be root"
  echo -e $YELLOW"Exiting..."$ENDCOLOR
  exit 0
fi

echo -e $YELLOW"Cleaning obselete deb packages..."$ENDCOLOR
apt-get autoclean
echo""
echo -e $YELLOW"Cleaning apt cache..."$ENDCOLOR
apt-get clean
echo""
echo -e $YELLOW"Removing unused dependencies..."$ENDCOLOR
apt-get autoremove --purge
echo ""
echo -e $GREEN$(journalctl --disk-usage)$ENDCOLOR
echo -e -n $BLUE"Enter vacuum time for journalctl (e.g.: 1s/ 7d): "$ENDCOLOR
read time
echo ""
echo -e $YELLOW"Removing journal files older than "$BLUE$time$ENDCOLOR
journalctl --vacuum-time=$time
echo ""
echo -e $YELLOW"Emptying everything in Trash..."$ENDCOLOR
rm -rf /home/tarun/.local/share/Trash/files/*
rm -rf /home/tarun/.local/share/Trash/info/*
echo ""
# Removes old revisions of snaps
# CLOSE ALL SNAPS BEFORE RUNNING THIS
echo -e $YELLOW"Removing old revisions of Snaps..."$ENDCOLOR
set -eu
snap list --all | awk '/disabled/{print $1, $3}' |
    while read snapname revision; do
        snap remove "$snapname" --revision="$revision"
    done
echo ""
echo -e $YELLOW"**********FINISHED**********"$ENDCOLOR



