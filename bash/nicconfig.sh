#!/bin/bash

DNS=""
GATEWAY=""
NETMASK=""
NETMASK2=""
while read HOST ETH0 ETH1
do

ssh -n -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=10 $ETH0 "cat > /etc/network/interfaces << EOL
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
auto eth0 eth1
iface eth0 inet static
address $ETH0
netmask $NETMASK
gateway $GATEWAY
dns-nameserver $DNS

iface eth1 inet static
address $ETH1
netmask $NETMASK2
EOL
ifup eth1"
done < ovn2
