#! /bin/bash

trap "echo exit" SIGINT SIGTERM
DEST=""
LN=0
while read line ; do
    (( LN++ ))
    if [[ "$line" =~ TGT[[:space:]](.*) ]] ; then
	DEST=${BASH_REMATCH[1]}
    else
	# empty line
	[[ -z $(echo "$line"|xargs) ]] && continue
	[ ! -z $DEST ] || { echo "Failed to find destination at line $LN"; exit 1; }
	if [[ "$line" =~ .*/(.*) ]] ; then  
		FILE=${BASH_REMATCH[1]}
 	else	
		FILE="$line"
	fi
	mkdir -p "$DEST"
	rsync -a "$line" "$DEST/$FILE"
    fi
done < install.log
