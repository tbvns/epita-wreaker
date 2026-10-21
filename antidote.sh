#!/bin/sh

if [[ -d ~/confbackup ]]; then
	bakdir=~/confbackup
elif [[ -d ~/afs/confbackup ]]; then
	bakdir=~/afs/confbackup
else
	echo no backup dir was found
	if [[ -e ~/afs/fullconfsbackup.tar.gz ]]; then
		echo full config backup found at ~/afs/fullconfsbackup.tar.gz
		echo manually untar it and copy relevant files
	else
		echo uh-oh, no backup found, someone hates you
	fi
	exit -1
fi

[[ -f $bakdir/afs/.confs/install.sh ]] && cp $bakdir/afs/.confs/install.sh ~/afs/.confs/install.sh
