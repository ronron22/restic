#!/bin/bash -

set -x

# set repo : REPO=rest:http://backup:pass@truc:8000/sauvegarde
# set password RESTIC_PASSWORD=pass

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$HOME/bin
restic_credential_file=/root/.restic-credential.sh
ops="-x"
script_name=$(basename ${0/.sh/})
tmp_file=$(mktemp --suffix $script_name)
lock_file=/var/lock/.${script_name}.exclusivelock

lock() {
	# http://www.kfirlavi.com/blog/2012/11/06/elegant-locking-of-bash-program/
	exec 200>$lock_file

	if flock -n 200 ; then
		return 0 
	else
		return 1
	fi
}

lock || exit 1

# loading credential if exist
if [ -f $restic_credential_file ] ; then
	source $restic_credential_file
fi

clean_exit() {
	if [ -f $tmp_file ] ; then
		unlink $tmp_file
	fi
	if [ -f $lock_file ] ; then
		rm -f $lock_file
	fi
}

logme() {
	logger
}

function log_and_exec () {
	#https://www.linuxquestions.org/questions/linux-newbie-8
	#/bash-log-and-execute-function-670915/
       	eval "$@";
	logger \[$?\] "$@";
}


trap clean_exit 2 3 9

declare -A tag_and_hash_dict 

tag_and_hash_dict=( ["lib-cyrus"]="/var/lib/cyrus" ["spool-cyrus"]="/var/spool/cyrus" ["www"]="/var/www"\
       	["lib-knot"]="/var/lib/knot" ["lib-ldap"]="/var/lib/ldap" ["lib-mysql"]="/var/lib/mysql" ["etc"]="/etc"\
       	["synapse-config"]="/usr/local/synapse/homeserver.yaml" )

case $1 in
	start)
		for key in ${!tag_and_hash_dict[@]} ; do
			$restic -r $REPO backup $ops --tag $key ${tag_and_hash_dict[$key]}
		done	
	;;	
	clean) 
		restic -r $REPO forget unlock
		restic -r $REPO forget --prune --keep-daily 30
	;;
	check)
		restic -r $REPO check
	;;
	list)
		if ! restic -r $REPO snapshots ; then
			echo "Unable to list snapshots"
			exit 2
		else
			echo "Check is ok"

		fi	
	;;
	*)
		echo "Gruik !!!"
	;;	
esac	
