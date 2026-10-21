# epita-wreaker
 Just smth to mess with computers at Epita when someone forgets to I3lock

### install\_rand.sh usage
`$ ./install_rand.sh [-unsafe] [-perm] [-noanti] [-nobak] [-tar] [-evil] [confloose to install]`  
  
safe by default (no risk of real damage), change this with `-unsafe`  
does not reinstall on reboot by default, change this with `-perm`  
installs random confloose unless specific one is passed as param  
makes backups, deactivate with `-nobak`  
if you want a full backup of the afs/.confs dir as a tarball, use `-tar`  
installs an antidote unless `-noanti` is specified (or `-nobak`)  
evil sets all options to their worst (same as `-unsafe -perm -noanti -nobak`)  

___

### List of conflooses

###### lag
adds a `sleep 0.7` to the .bashrc every time bash starts  
adds a `sleep 1.5` to most usual commands  
flips vim and emacs  
aliases clear to yes

###### gamble
has a chance to delete a file when trying to open/copy/mv it  
has a high chance of copying a file when trying to rm it  
