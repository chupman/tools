#!/bin/bash

echo "" > TestKeys.log
while read host
do

(ssh -n -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=10 $host 'hostname' ;echo "$? $host " >>TestKeys.log &)

done < Results.log
