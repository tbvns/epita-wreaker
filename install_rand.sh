#!/bin/bash
repo=$(dirname $0)

if [ $# -eq 2 ]; then
	rand=$RANDOM%2

	if [ $rand -eq 0 ]; then
		dir="lag"
	else
		dir="gamble"
	fi
else
	dir=$1
fi


./$repo/$dir/install.sh
