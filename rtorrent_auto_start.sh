#!/bin/bash

# Send output to /var/log/syslog and /var/log/messages
exec 1> >(logger -s -t $(basename $0)) 2>&1
# ----

FILE="$HOME/.session/rtorrent.lock"

# Where to save PID file
FILE_PID="$HOME/rtorrent_PID/PID"

# IMPORTANT!!
# HDD mouting path -->
volume="/media/mouting/path"
# ------

function checkPID
{
        echo "rTorrent working, his PID is: "
        grep -o '[^+]\+$' $FILE
}

function create_PID_File
{
  echo "Creating PID file:"
  pgrep -x rtorrent > $HOME/skrypty/PID
}

function checkIfDiskIsMounted
{
  if mount | grep "on ${volume} type" > /dev/null
  then
    start_rtorrent
  else
    echo "Something went wrong, unplug and plug hard drive one more time."
  fi
}

function start_rtorrent
{
  if mount | grep "on ${volume} type" > /dev/null
  then
    echo "Disk WoodBOX_HDD is mounted."
    create_PID_File
    sleep 1

    if [ -s $FILE_PID ]
    then
    	echo "Checking if rTorrent is working..."
    	checkPID
    else
    	echo "rTorrent is not working."
    	echo "Run..."
    	screen -Sdm rtorrent rtorrent
    	screen -list
    fi
  else
    echo "Disk WoodBOX_HDD is not mounted."
    echo "Mounting..."
    sudo mount -a
    checkIfDiskIsMounted
  fi
}

start_rtorrent
