#!/bin/bash -

# set repo : REPO=rest:http://backup:pass@truc:8000/sauvegarde
# set password RESTIC_PASSWORD=pass

ops="-x"
script_name=$(basename ${0/.sh/})
tmp_file=$(mktemp --suffix $script_name)
lock_file=/tmp/${script_name}.lock

if ! [ -f $lock_file ] ; then
	lockfile $lock_file
else
	echo "An instance seem will be active"  	
	exit 2
fi

clean_exit() {
	if [ -f $tmp_file ] ; then
		unlink $tmp_file
	elif [ -f $lock_file ] ; then
		rm -f $lock_file 
	fi
}

trap clean_exit 2 3 9

declare -A tag_and_hash_dict 

tag_and_hash_dict=( ["lib-cyrus"]="/var/lib/cyrus" ["spool-cyrus"]="/var/spool/cyrus" ["www"]="/var/www"\
       	["lib-knot"]="/var/lib/knot" ["lib-ldap"]="/var/lib/ldap" ["lib-mysql"]="/var/lib/mysql" ["etc"]="/etc"\
       	["synapse-config"]="/usr/local/synapse/homeserver.yaml" )

case $1 in
	start)
		for key in ${!tag_and_hash_dict[@]} ; do
			restic -r $REPO backup $ops --tag $key ${tag_and_hash_dict[$key]}
		done	
	;;	
	clean) 
		restic forget --prune --keep-daily 30
	;;
	check)
		restic -r $REPO check
	;;
	list)
		if ! restic -r $REPO snapshots &> $tmp_file ; then
			echo "There a corruption problem, read $tmp_file please"
			exit 2
		else
			echo "Check is ok"

		fi	
	;;
	*)
		echo "Gruik !!!"
	;;	
esac	
