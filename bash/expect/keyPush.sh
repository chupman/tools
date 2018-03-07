#!/bin/bash

HOST="remote-host"
USER="root"
PASS="mahPassword"
NFSHOST="nfs-host"
DIR="/mnt/some-dir"

#CMD=$@

# echo "Enter ip of FQDN"
# read HOST
#echo "Enter username"
#read USER
#echo "Enter Password"
#read -s PASS

###while read RACKNUMBER MACHINETYPE LOGIN PASSWORD OSLEVEL PROJECT_ID HOST VLAN_NUMBER
while read HOST
do 

VAR=$(expect -c "
spawn ssh -o StrictHostKeyChecking=no $USER@$HOST
match_max 100000
expect \"*?assword:*\"
send -- \"$PASS\r\"
send -- \"\r\"
expect $prompt
send -- \"mkdir -p /mnt/$NFSHOST ;\r\"
send -- \"mount -o nfsvers=3 $NFSHOST:/ /mnt/$DIR ;\r\"
send -- \". /mnt/cobbler/others/SSHKeyAdd.sh ;\r\"
send -- \"umount /mnt/cobbler ;\r\"

expect $prompt

expect eof
")
echo "==============="
echo "$VAR"


done < hostlist-file
