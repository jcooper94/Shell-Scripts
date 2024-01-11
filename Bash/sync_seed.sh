#!/bin/sh
login=""
pass=""
host="nova.usbx.me"

#server download directory
remote_other=""
#local download directory
local_other=""

if [ -e synctorrent.lock ]
then
	echo "Synctorrent is running already."
	exit 1
else
	touch synctorrent.lock
	lftp -p 22 -u $login,$pass sftp://$host << EOF
	set mirror:use-pget-n 3
	mirror -c -P5 --log=other-sync.log --Remove-source-files $remote_other $local_other
	quit
EOF
	rm -f synctorrent.lock
	exit 0
fi