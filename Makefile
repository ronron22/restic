install:
	echo installing cron jobs and resticme.sh
	cp -iv cron.d/sauvegarde /etc/cron.d/
	cp -iv resticme.sh /usr/local/bin/
	cp -iv rsyslog-resticme.conf /etc/rsyslog.d/ && service rsyslog force-reload
