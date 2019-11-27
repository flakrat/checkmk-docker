#!/bin/bash
# Author: Mike Hanby
# Email: mhanby@uab.edu
# 
# Reference: https://checkmk.com/cms_managing_docker.html


readlink=readlink
if [[ "$OSTYPE" == "darwin"* ]]; then
  readlink=greadlink
fi

show_help () {
  echo "Usage: `basename $0` <options>";
  echo;
  echo "Options:";
  echo " -h | --help   = Help, show this message.";
  echo " -c | --container=<NAME>   = CheckMK Docker Container Name (Mandatory).";
  echo " -d | --dest=<PATH>        = Destination path for the backup (Mandatory).";
}

OPTS=`getopt -o hc:d: --long help,container:,dest: -n 'help' -- "$@"`

eval set -- "$OPTS"

while true; do
  case "$1" in
    -h | --help )      show_help; exit 0; shift ;;
    -c | --container ) container="$2"; shift 2 ;;
    -d | --dest )      dest="$2"; shift 2 ;;
    -- ) shift; break ;;
    * ) echo "Invalid arguments!"; show_help; exit 1 ;;
  esac
done

if [ ! "$container" ]; then
    show_help
    exit 1
fi

if [ ! "$dest" ]; then
  show_help
  exit 1
fi

date="$(date +%Y%m%d_%H%M)"
file="${container}-site-bak-${date}.tar"

# Stop the running CheckMK docker container
echo "Stopping the CheckMK container: $container"
docker stop $container

# Create a copy of /omd/sites from the container into a tar file
echo "Creating copy of /omd/sites from '$container' to: $dest/$file"
docker cp $container:/omd/sites - > $dest/$file

# Start the container
echo "Starting the CheckMK container: $container"
docker start $container
sleep 5
docker container logs $container

# Compress the backup
echo "Compressing the backup file as: $dest/${file}.xz"
xz $dest/$file
