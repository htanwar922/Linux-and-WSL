#!/bin/bash

# my make-file function

mkfile_util ()
{
vim -E -s $1 << EOF
wq!
EOF
sudo chmod u+x $1
return;
}

mkfile ()
{

if [ "$1" = "-h" ]; then
    echo 'mkfile [-hr] [file]'
cat <<EOF
	-h : access help
	-r : remove already existing files after creating backup and create new ones
	If no file name is passed, a tmp file is created.
EOF
    return
fi

# crtd=0
thispath=""
if [ $3 ]; then thispath=$3/; fi
tmp="$thispath"tmp

#echo $1 $2 $3
if [ "$1" = "-r" ]; then
    if [ $2 -a -d $2 ]; then
	echo "$2 is an existing directory."
	echo -e "Couldn\'t remove dir to create file."
	echo -n "do you want to remove? [y/n]: "
	read a
	if [ "$a" != "y" -a "$a" != "Y" ]; then return; fi
    fi
    
    if [ $2 ]; then tmp=$thispath$2; fi
    
    if [ -e $tmp ]; then
    
	echo -n "do you want to backup and remove $tmp? [y/n]: "
	read a
    
	if [ "$a" != "y" -a "$a" != "Y" ]; then return; fi

	mv $tmp $tmp~
	if [ -e $tmp ]; then echo "could not remove $tmp"; return; else echo "removed"; fi
	
    fi
	
    mkfile_util $tmp
    
    # if [ -e $tmp ]; then ctrd=1; fi
	# echo "crtd1 = $crtd"
	
else
    
    if [ $1 ]; then tmp=$thispath$1; fi
    
    if [ -e $tmp ]; then
	
	echo -n "file $tmp already exists, "
	mkfile -r $tmp $thispath; return;

    else
	
	mkfile_util $tmp
	
	# if [ -e $tmp ]; then ctrd=1; fi
	# echo "crtd2 = $crtd"
	
    fi
fi

found=`ls | grep "^$tmp$" | wc -l`
echo $found
if [ $found -ne 1 ]; then echo -e "Error : Couldn\'t create file"; else echo "created successfully"; fi

return;

}
