#!/bin/bash

echo "" > Ping.log
while read host ip
do

(ping -c 4 $host >> Ping.log &)

#done < hostlist 
done < vlan679
