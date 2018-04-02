restic:= resticme.sh
target:=/tmp/
install:
	#cp -v restic target
	cp -v cron.d/sauvegarde /etc/cron.d/
